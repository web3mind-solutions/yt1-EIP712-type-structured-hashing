// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SigVerify is EIP712 {
    bytes32 private constant MAIL_TYPEHASH =
        keccak256("Mail(Person from,Person to,string contents)Person(string name,address wallet)");
    bytes32 private constant PERSON_TYPEHASH = keccak256("Person(string name,address wallet)");

    struct Person {
        string name;
        address wallet;
    }

    struct Mail {
        Person from;
        Person to;
        string contents;
    }

    constructor() EIP712("EtherMail", "1") {}

    function validateSig(Mail memory _mail, bytes memory _sig, address _signer) public view returns (bool) {
        bytes32 hashFromPerson = _encodeAndHash(_mail.from);
        bytes32 hashToPerson = _encodeAndHash(_mail.to);

        bytes memory encodeMail =
            abi.encode(MAIL_TYPEHASH, hashFromPerson, hashToPerson, keccak256(bytes(_mail.contents)));

        bytes32 hashedTypeData = _hashTypedDataV4(keccak256(encodeMail));

        address recoveredSigner = ECDSA.recover(hashedTypeData, _sig);

        return recoveredSigner == _signer;
    }

    function _encodeAndHash(Person memory _person) internal pure returns (bytes32) {
        bytes memory encodedPerson = abi.encode(PERSON_TYPEHASH, keccak256(bytes(_person.name)), _person.wallet);
        return keccak256(encodedPerson);
    }
}
