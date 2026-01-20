import { useState } from 'react';
import { ethers, BigNumber } from 'ethers';
import roboPunkNFT from './RoboPunksNft.json'

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
                const response = await contract.mint(BigNumber.from(mintAmount));
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
        <div>
            <h1>RoboPunks</h1>
            <p>Minting is live!</p>
            {isConnected ? (
                <div>
                    <div>
                        <button onClick={handleDecrement}>-</button>
                        <input type="text" value={mintAmount} readOnly />
                        <button onClick={handleIncrement}>+</button>
                    </div>
                    <button onClick={handleMint}>Mint</button>
                </div>
            ) : (
                <p>Please connect your wallet</p>
            )}
        </div>
    );
}

export default MainMint;

