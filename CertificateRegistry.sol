// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CertificateRegistry {
    address public owner;

    struct Certificate {
        string name;
        string course;
        uint256 issueDate;
        bool isValid;
    }

    mapping(bytes32 => Certificate) public certificates;

    event CertificateIssued(bytes32 certHash, string name, string course, uint256 date);
    event CertificateRevoked(bytes32 certHash);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function issueCertificate(string memory _name, string memory _course, uint256 _issueDate) public onlyOwner returns (bytes32) {
        bytes32 certHash = keccak256(abi.encodePacked(_name, _course, _issueDate));
        certificates[certHash] = Certificate(_name, _course, _issueDate, true);
        emit CertificateIssued(certHash, _name, _course, _issueDate);
        return certHash;
    }

    function revokeCertificate(bytes32 _certHash) public onlyOwner {
        require(certificates[_certHash].isValid, "Certificate not found or already revoked");
        certificates[_certHash].isValid = false;
        emit CertificateRevoked(_certHash);
    }

    function verifyCertificate(bytes32 _certHash) public view returns (bool, string memory, string memory, uint256) {
        Certificate memory cert = certificates[_certHash];
        return (cert.isValid, cert.name, cert.course, cert.issueDate);
    }
}
