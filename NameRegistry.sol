pragma solidity ^0.4.23;

contract Owned {
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor() internal {
        owner = msg.sender;
    }
    
    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}

contract NameRegistry is Owned {
    uint public numContracts;
    
    struct Contract {
        address owner;
        address addr;
        bytes32 desctiption;
    }
    
    mapping(bytes32 => Contract) private contracts;
    
    constructor() public {
        numContracts = 0;
    }
    
    function addRegister(bytes32 _name, address _addr) public returns(bool) {
        if(contracts[_name].owner == 0) {
            Contract memory con = contracts[_name];
            con.owner = msg.sender;
            con.addr = _addr;
            numContracts++;
            return true;
        } else {
            return false;
        }
    }
    
    function removeRegister(bytes32 _name) public returns(bool) {
        if(contracts[_name].owner == msg.sender) {
            contracts[_name].owner = 0;
            numContracts--;
            return true;
        } else {
            return false;
        }
    }
    
    function changeOwner(bytes32 _name, address _newOwner) public onlyOwner {
        contracts[_name].owner = _newOwner;
    }
    
    function changeContractAddress(bytes32 _name, address _newAddress) public onlyOwner {
        contracts[_name].addr = _newAddress;
    }
    
    function getContractAddress(bytes32 _name) public constant returns(address) {
        return contracts[_name].addr;
    }
    
    function getOwnerAddress(bytes32 _name) public constant returns(address) {
        return contracts[_name].owner;
    }
}
