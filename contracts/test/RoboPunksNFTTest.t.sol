// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test, console} from "forge-std/Test.sol";
import {RoboPunksNFT} from "../src/RobotPunksNFT.sol";
import {DeployRoboPunkNft} from "../script/DeployRoboPunkNft.sol";

contract RoboPunksNFTTest is Test {
    RoboPunksNFT public roboPunksNft;

    address public owner;
    address public user1;
    address public user2;

    uint256 public constant MINT_PRICE = 0.02 ether;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_PER_WALLET = 3;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        // Deploy as owner
        vm.prank(owner);
        roboPunksNft = new RoboPunksNFT();

        // Fund test users
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    /*//////////////////////////////////////////////////////////////
                            DEPLOYMENT TESTS
    //////////////////////////////////////////////////////////////*/

    function test_DeploymentSetsCorrectName() public view {
        assertEq(roboPunksNft.name(), "RoboPunks");
    }

    function test_DeploymentSetsCorrectSymbol() public view {
        assertEq(roboPunksNft.symbol(), "RP");
    }

    function test_DeploymentSetsCorrectMintPrice() public view {
        assertEq(roboPunksNft.mintPrice(), MINT_PRICE);
    }

    function test_DeploymentSetsCorrectMaxSupply() public view {
        assertEq(roboPunksNft.maxSupply(), MAX_SUPPLY);
    }

    function test_DeploymentSetsCorrectMaxPerWallet() public view {
        assertEq(roboPunksNft.maxPerWallet(), MAX_PER_WALLET);
    }

    function test_DeploymentTotalSupplyIsZero() public view {
        assertEq(roboPunksNft.totalSupply(), 0);
    }

    function test_DeploymentPublicMintDisabled() public view {
        assertEq(roboPunksNft.isPublicMintEnabled(), false);
    }

    function test_DeploymentSetsCorrectOwner() public view {
        assertEq(roboPunksNft.owner(), owner);
    }

    /*//////////////////////////////////////////////////////////////
                        DEPLOY SCRIPT TEST
    //////////////////////////////////////////////////////////////*/

    function test_DeployScriptDeploysCorrectly() public {
        DeployRoboPunkNft deployer = new DeployRoboPunkNft();
        RoboPunksNFT deployedNft = deployer.run();

        assertEq(deployedNft.name(), "RoboPunks");
        assertEq(deployedNft.symbol(), "RP");
        assertEq(deployedNft.mintPrice(), MINT_PRICE);
    }

    /*//////////////////////////////////////////////////////////////
                            OWNER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function test_OwnerCanEnablePublicMint() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);
        assertEq(roboPunksNft.isPublicMintEnabled(), true);
    }

    function test_OwnerCanDisablePublicMint() public {
        vm.startPrank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);
        roboPunksNft.setIsPublicMintEnabled(false);
        vm.stopPrank();
        assertEq(roboPunksNft.isPublicMintEnabled(), false);
    }

    function test_NonOwnerCannotEnablePublicMint() public {
        vm.prank(user1);
        vm.expectRevert();
        roboPunksNft.setIsPublicMintEnabled(true);
    }

    function test_OwnerCanSetBaseTokenUri() public {
        string memory newUri = "ipfs://QmTest/";

        vm.prank(owner);
        roboPunksNft.setbaseTokenUri(newUri);

        // Enable minting and mint one token to test URI
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE}(1);

        assertEq(roboPunksNft.tokenURI(1), "ipfs://QmTest/1.json");
    }

    function test_NonOwnerCannotSetBaseTokenUri() public {
        vm.prank(user1);
        vm.expectRevert();
        roboPunksNft.setbaseTokenUri("ipfs://QmTest/");
    }

    /*//////////////////////////////////////////////////////////////
                              MINT TESTS
    //////////////////////////////////////////////////////////////*/

    function test_MintSingleNft() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE}(1);

        assertEq(roboPunksNft.totalSupply(), 1);
        assertEq(roboPunksNft.balanceOf(user1), 1);
        assertEq(roboPunksNft.ownerOf(1), user1);
    }

    function test_MintMultipleNfts() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE * 3}(3);

        assertEq(roboPunksNft.totalSupply(), 3);
        assertEq(roboPunksNft.balanceOf(user1), 3);
    }

    function test_MintRevertsWhenMintingDisabled() public {
        vm.prank(user1);
        vm.expectRevert("Minting is not enabled");
        roboPunksNft.mint{value: MINT_PRICE}(1);
    }

    function test_MintRevertsWithWrongValue() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        vm.expectRevert("Wrong mint value");
        roboPunksNft.mint{value: MINT_PRICE - 0.001 ether}(1);
    }

    function test_MintRevertsWithExcessValue() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        vm.expectRevert("Wrong mint value");
        roboPunksNft.mint{value: MINT_PRICE + 0.001 ether}(1);
    }

    function test_MintRevertsWhenExceedsMaxPerWallet() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        vm.expectRevert("Exceeds max per wallet");
        roboPunksNft.mint{value: MINT_PRICE * 4}(4);
    }

    function test_MintTracksWalletMints() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE * 2}(2);

        assertEq(roboPunksNft.walletMints(user1), 2);
    }

    function test_MultipleMintsBySameWallet() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.startPrank(user1);
        roboPunksNft.mint{value: MINT_PRICE}(1);
        roboPunksNft.mint{value: MINT_PRICE * 2}(2);
        vm.stopPrank();

        assertEq(roboPunksNft.walletMints(user1), 3);
        assertEq(roboPunksNft.balanceOf(user1), 3);
    }

    function test_MintRevertsAfterMaxPerWalletReached() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.startPrank(user1);
        roboPunksNft.mint{value: MINT_PRICE * 3}(3);

        vm.expectRevert("Exceeds max per wallet");
        roboPunksNft.mint{value: MINT_PRICE}(1);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                            TOKEN URI TESTS
    //////////////////////////////////////////////////////////////*/

    function test_TokenUriReturnsCorrectFormat() public {
        vm.prank(owner);
        roboPunksNft.setbaseTokenUri("ipfs://QmBaseUri/");

        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE}(1);

        assertEq(roboPunksNft.tokenURI(1), "ipfs://QmBaseUri/1.json");
    }

    function test_TokenUriRevertsForNonExistentToken() public {
        vm.expectRevert("Token does not exist!");
        roboPunksNft.tokenURI(999);
    }

    /*//////////////////////////////////////////////////////////////
                            WITHDRAW TESTS
    //////////////////////////////////////////////////////////////*/

    function test_ContractReceivesEthOnMint() public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE * 2}(2);

        assertEq(address(roboPunksNft).balance, MINT_PRICE * 2);
    }

    function test_NonOwnerCannotWithdraw() public {
        vm.prank(user1);
        vm.expectRevert();
        roboPunksNft.withdraw();
    }

    /*//////////////////////////////////////////////////////////////
                              FUZZ TESTS
    //////////////////////////////////////////////////////////////*/

    function testFuzz_MintWithCorrectValue(uint256 quantity) public {
        // Bound quantity to valid range (1 to maxPerWallet)
        quantity = bound(quantity, 1, MAX_PER_WALLET);

        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE * quantity}(quantity);

        assertEq(roboPunksNft.totalSupply(), quantity);
        assertEq(roboPunksNft.balanceOf(user1), quantity);
        assertEq(roboPunksNft.walletMints(user1), quantity);
    }

    function testFuzz_MintRevertsWithWrongValue(uint256 wrongPrice) public {
        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        // Bound wrongPrice to reasonable range and ensure it's not equal to correct price
        wrongPrice = bound(wrongPrice, 0, 10 ether);
        vm.assume(wrongPrice != MINT_PRICE);

        // Fund user with enough ETH
        vm.deal(user1, wrongPrice + 1 ether);

        vm.prank(user1);
        vm.expectRevert("Wrong mint value");
        roboPunksNft.mint{value: wrongPrice}(1);
    }

    function testFuzz_MintRevertsWhenExceedsMaxPerWallet(
        uint256 quantity
    ) public {
        // Bound quantity to exceed max per wallet
        quantity = bound(quantity, MAX_PER_WALLET + 1, 100);

        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.deal(user1, quantity * MINT_PRICE);

        vm.prank(user1);
        vm.expectRevert("Exceeds max per wallet");
        roboPunksNft.mint{value: MINT_PRICE * quantity}(quantity);
    }

    function testFuzz_MultipleUsersMinting(
        uint256 user1Qty,
        uint256 user2Qty
    ) public {
        user1Qty = bound(user1Qty, 1, MAX_PER_WALLET);
        user2Qty = bound(user2Qty, 1, MAX_PER_WALLET);

        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE * user1Qty}(user1Qty);

        vm.prank(user2);
        roboPunksNft.mint{value: MINT_PRICE * user2Qty}(user2Qty);

        assertEq(roboPunksNft.totalSupply(), user1Qty + user2Qty);
        assertEq(roboPunksNft.balanceOf(user1), user1Qty);
        assertEq(roboPunksNft.balanceOf(user2), user2Qty);
    }

    function testFuzz_TokenIdsAreSequential(uint256 quantity) public {
        quantity = bound(quantity, 1, MAX_PER_WALLET);

        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE * quantity}(quantity);

        // Verify each token ID exists and is owned by user1
        for (uint256 i = 1; i <= quantity; i++) {
            assertEq(roboPunksNft.ownerOf(i), user1);
        }
    }

    function testFuzz_SetBaseTokenUri(string calldata uri) public {
        // Skip empty strings for valid test
        vm.assume(bytes(uri).length > 0);

        vm.prank(owner);
        roboPunksNft.setbaseTokenUri(uri);

        vm.prank(owner);
        roboPunksNft.setIsPublicMintEnabled(true);

        vm.prank(user1);
        roboPunksNft.mint{value: MINT_PRICE}(1);

        string memory expectedUri = string(abi.encodePacked(uri, "1.json"));
        assertEq(roboPunksNft.tokenURI(1), expectedUri);
    }
}
