import React from "react";
import { Box, Button, Flex, Link, Spacer } from "@chakra-ui/react";
import { FaFacebook, FaTwitter, FaDiscord } from "react-icons/fa";
import { MdEmail } from "react-icons/md";

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
        <Flex justify="space-between" align="center" padding="30px">
            {/* Left Side - Social Media Icons */}
            <Flex justify="space-around" align="center" gap="15px">
                <Link href="https://facebook.com" isExternal>
                    <FaFacebook size={28} color="white" style={{ cursor: "pointer" }} />
                </Link>
                <Link href="https://twitter.com" isExternal>
                    <FaTwitter size={28} color="white" style={{ cursor: "pointer" }} />
                </Link>
                <Link href="https://discord.com" isExternal>
                    <FaDiscord size={28} color="white" style={{ cursor: "pointer" }} />
                </Link>
                <Link href="mailto:contact@robopunks.com">
                    <MdEmail size={28} color="white" style={{ cursor: "pointer" }} />
                </Link>
            </Flex>

            {/* Right Side - Navigation Links & Connect Button */}
            <Flex justify="space-around" align="center" width="40%" padding="30px">
                <Box margin="0 15px" cursor="pointer" _hover={{ color: "#D6517D" }}>
                    About
                </Box>
                <Spacer />
                <Box margin="0 15px" cursor="pointer" _hover={{ color: "#D6517D" }}>
                    Roadmap
                </Box>
                <Spacer />
                <Box margin="0 15px" cursor="pointer" _hover={{ color: "#D6517D" }}>
                    Team
                </Box>
                <Spacer />

                {/* Connect Button */}
                {isConnected ? (
                    <Box 
                        margin="0 15px" 
                        backgroundColor="#D6517D" 
                        padding="10px 15px"
                        borderRadius="5px"
                        color="white"
                    >
                        Connected
                    </Box>
                ) : (
                    <Button
                        backgroundColor="#D6517D"
                        borderRadius="5px"
                        boxShadow="0px 2px 2px 1px #0F0F0F"
                        color="white"
                        cursor="pointer"
                        fontFamily="inherit"
                        padding="15px"
                        margin="0 15px"
                        _hover={{ backgroundColor: "#C04069" }}
                        onClick={connectAccount}
                    >
                        Connect
                    </Button>
                )}
            </Flex>
        </Flex>
    );
};

export default NavBar;
