import React from "react";
import { Box, Button, Flex, Image, Link, Spacer} from "@chakra-ui/react"
import FacebookIcon from "./assets/facebook-icon.svg"
import TwitterIcon from "./assets/twitter-icon.svg"
import EmailIcon from "./assets/email-icon.svg"

const NavBar = ({ account, setAccount }) => {
    const isConnected = Boolean(account[0]);

    async function connectAccount() {
        if (window.ethereum) {
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            setAccount(accounts);
        }
    } 

    return (
        <Flex justify="space-between" align="center" padding="30px 30px">
            {/* Left Side - Social Media Icons */}
            <div>Facebook</div>
            <div>Twitter</div>
            <div>Email</div>
        
            {/* Rigth Side - Section and Connect */}
            <div>About</div>
            <div>Roadmap</div>
            <div>Team</div>

            {/* Connect */}
            {isConnected ? (
                <p>Connected</p>
            ) : (
                <button onClick={connectAccount}>Connect</button>
            )}
        </Flex>
    );
};

export default NavBar;