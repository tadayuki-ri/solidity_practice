pragma solidity ^0.4.23;

contract PiggyBank {
    address owner;
    
    modifier onlyBy(address _account) {
        require(
            msg.sender == _account,
            "Sender not authrized."
        );
        _;
    }
    
    event SavingsHistory(address _sender, uint _balance, uint _time);
    event PiggyBankStatus(address _owner, address _sender, uint _balance);
    
    constructor() public {
        owner = msg.sender;
    }
    
    function savings(uint _time) public onlyBy(owner) payable {
        emit SavingsHistory(msg.sender, address(this).balance, _time);
    }
    
    function getBalance() public onlyBy(owner) constant returns (uint) {
        return address(this).balance;
    }
    
    function changeOwner(address _newOwner) public onlyBy(owner) {
        emit PiggyBankStatus(_newOwner, msg.sender, address(this).balance);
    }
    
    function close() public onlyBy(owner) {
        selfdestruct(owner);
        emit PiggyBankStatus(owner, msg.sender, address(this).balance);
    }
}
