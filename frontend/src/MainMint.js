import { useState } from 'react';
import { ethers, BigNumber } from 'ethers';
import { Box, Button, Flex, Input, Text } from "@chakra-ui/react";
import roboPunkNFT from './RoboPunksNft.json';

const roboPunksNFTAddress = "0xf776B33d1c5CA010705767E195B1eDD528099Cbd";

const MainMint = ({ accounts, setAccounts }) => {
    const [mintAmount, setMintAmount] = useState(1);
    const isConnected = Boolean(accounts[0]);

    async function handleMint() {
        if (window.ethereum) {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            const contract = new ethers.Contract(
                roboPunksNFTAddress,
                roboPunkNFT.abi,
                signer
            );

            try {
                const response = await contract.mint(BigNumber.from(mintAmount), {
                    value: ethers.utils.parseEther((0.02 * mintAmount).toString()),
                });
                console.log("response: ", response);
            } catch (err) {
                console.log("error: ", err);
            }
        }
    }

    const handleDecrement = () => {
        if (mintAmount <= 1) return;
        setMintAmount(mintAmount - 1);
    };

    const handleIncrement = () => {
        if (mintAmount >= 5) return;
        setMintAmount(mintAmount + 1);
    };

    return (
        <Flex justify="center" align="center" height="100vh" paddingBottom="150px">
            <Box width="520px">
                {/* Title Section */}
                <Box textAlign="center" marginBottom="30px">
                    <Text fontSize="48px" textShadow="0 5px #000000">
                        RoboPunks
                    </Text>
                    <Text 
                        fontSize="30px" 
                        letterSpacing="-5.5%" 
                        fontFamily="VT323" 
                        textShadow="0 5px #000000"
                    >
                        Minting is live!
                    </Text>
                </Box>

                {/* Mint Section */}
                {isConnected ? (
                    <Box textAlign="center">
                        {/* Quantity Controls */}
                        <Flex justify="center" align="center" marginBottom="20px">
                            <Button 
                                backgroundColor="#D6517D"
                                color="white"
                                borderRadius="5px"
                                boxShadow="0px 2px 2px 1px #0F0F0F"
                                cursor="pointer"
                                onClick={handleDecrement}
                            >
                                -
                            </Button>
                            <Input 
                                type="text" 
                                value={mintAmount} 
                                readOnly 
                                width="60px"
                                textAlign="center"
                                margin="0 15px"
                                fontFamily="inherit"
                            />
                            <Button 
                                backgroundColor="#D6517D"
                                color="white"
                                borderRadius="5px"
                                boxShadow="0px 2px 2px 1px #0F0F0F"
                                cursor="pointer"
                                onClick={handleIncrement}
                            >
                                +
                            </Button>
                        </Flex>

                        {/* Mint Button */}
                        <Button 
                            backgroundColor="#D6517D"
                            color="white"
                            borderRadius="5px"
                            boxShadow="0px 2px 2px 1px #0F0F0F"
                            cursor="pointer"
                            fontFamily="inherit"
                            padding="15px 30px"
                            onClick={handleMint}
                        >
                            Mint Now
                        </Button>
                    </Box>
                ) : (
                    <Box textAlign="center">
                        <Text fontSize="20px" color="gray.300">
                            Please connect your wallet to mint
                        </Text>
                    </Box>
                )}
            </Box>
        </Flex>
    );
};

export default MainMint;
