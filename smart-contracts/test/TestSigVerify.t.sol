// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SigVerify} from "src/SigVerify.sol";

contract TestSigVerify is Test {
    SigVerify sigVerify;

    function setUp() public {
        sigVerify = new SigVerify();
    }

    function testSigVerifyRecoversAddressCorrectly() public {
        address signer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        // 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
        // 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
        //recreating the data that we signed
        SigVerify.Person memory fromPerson =
            SigVerify.Person("Cow", address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
        SigVerify.Person memory toPerson = SigVerify.Person("Bob", address(0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB));
        SigVerify.Mail memory mail = SigVerify.Mail(fromPerson, toPerson, "Hello, Bob!");
        // r , s , v
        // 0x61d3c1c6a4b2498af87614e74632bf05468e27b4be29853f336ba045c44b04927c75a189983288cb480bd694566896bb74449ac18e859ea2c24a2ff8d0e4ad041b
        bytes32 r = 0x61d3c1c6a4b2498af87614e74632bf05468e27b4be29853f336ba045c44b0492;
        bytes32 s = 0x7c75a189983288cb480bd694566896bb74449ac18e859ea2c24a2ff8d0e4ad04;
        uint8 v = 0x1b;

        bytes memory packedSig = abi.encodePacked(r, s, v);

        bool success = sigVerify.validateSig(mail, packedSig, signer);

        console.log("Was it successful?", success);
    }

}
