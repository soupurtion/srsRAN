// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract Storage {
    struct x509_certificate { 
        string version;
        string serialNumber;
        string subjectName;
        string issuerName;
        uint256 subjectPublicKey;
        uint32 subjectUniqueID;
        uint32 validityPeriod;
        uint256 digitalSignature;
        string algorithm;
    }
 
    mapping(uint32 => x509_certificate) registrationMap;
    
    // If the user has write privileges, set their index in the ledger to a specified certificate
    function storeCert(string memory version, string memory serialNumber, string memory subjectName, string memory issuerName, uint256 subjectPublicKey, uint32 subjectUniqueID, uint32 validityPeriod, uint256 digitalSignature, string memory algorithm) public returns (bool) {
        if(hasWritePrivilege(msg.sender)) {
            x509_certificate memory cert = x509_certificate(version, serialNumber, subjectName, issuerName, subjectPublicKey, subjectUniqueID, validityPeriod, digitalSignature, algorithm);
            registrationMap[subjectUniqueID] = cert;
            return true;
        }
        return false;
    }
    
    // If the user has write privileges, set their index in the ledger to a specified key, 0x0 to delete
    function storeKey(uint32 id, uint256 key) public returns (bool) {
        if(hasWritePrivilege(msg.sender)) {
            if(key == 0x0) {
                delete registrationMap[id];
            } else {
                if(registrationMap[id].subjectPublicKey == 0) {
                    // If entry already exists, just set the key
                    registrationMap[id].subjectPublicKey = key;
                } else {
                    // Otherwise, set the entire certificate
                    x509_certificate memory cert = x509_certificate('version', 'serialNumber', 'subjectName', 'issuerName', key, id, 0, 0, 'algorithm');
                    registrationMap[id] = cert;
                }
            }
            return true;
        }
        return false;
    }

    // Retrieve a key value given its corresponding id
    function retrieveCert(uint32 id) public view returns (x509_certificate memory){
        return registrationMap[id];
    }

    // Retrieve a key value given its corresponding id
    function retrieveKey(uint32 id) public view returns (uint256){
        return registrationMap[id].subjectPublicKey;
    }

    // Only authorized users will return true, everyone else will return false
    function hasWritePrivilege(address user) public pure returns (bool) {
        if(user == 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4) return true; // Core network 1
        if(user == 0x235d39CDA65c223611eA2A914FD686307FF389A4) return true; // Core network 2
        if(user == 0x0000000000000000000000000000000000000000) return true; // etc...
        return false;
    }

    // Return the address of the message sender
    function whoAmI() public view returns (address) {
        return msg.sender;
    }
}