pragma solidity ^0.4.23;

contract Escrow {
    address private owner;
    address private depositor;
    string private message;
    uint private status;
    uint private goalAmount;
    uint private totalAmount;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier onlyDepositor {
        require(msg.sender == depositor);
        _;
    }
    
    event EscrowEvent(
        address _owner, address _deposirot, uint _goalAmount, uint totalAmount, string message, uint _status
    );
    
    constructor(address _depositor, uint _goalAmount) public {
        require(_goalAmount > 0);
        owner = msg.sender;
        depositor = _depositor;
        message = "Contract generated.";
        goalAmount = _goalAmount*10**18;
        totalAmount = 0;
        status = 0;
        
        emit EscrowEvent(owner, depositor, goalAmount, totalAmount, message, status);
    }
    
    function deposit() public onlyDepositor payable {
        require(status == 0);
        require(msg.value <= goalAmount - totalAmount);
        
        totalAmount += msg.value;
        
        if(totalAmount==goalAmount) {
            status = 1;
            message  = "Deposit completed.";
        } else {
            message = "Depositing.";
        }
        emit EscrowEvent(owner, depositor, goalAmount, totalAmount, message, status);
    }
    
    function notice() public onlyDepositor {
        require(status ==1);
        status = 2;
        message = "Deliverty completed.";
        emit EscrowEvent(owner, depositor, goalAmount, totalAmount, message, status);
    }
    
    function withdraw() public onlyOwner payable {
        require(status == 2);
        uint buf = totalAmount;
        totalAmount = 0;
        status =3;
        owner.transfer(buf);
        message = "Withdraw completed.";
        emit EscrowEvent(owner, depositor, goalAmount, totalAmount, message, status);
    }
    
    function cancel() public onlyOwner payable {
        require(status != 3);
        uint buf = totalAmount;
        totalAmount = 0;
        status =0;
        depositor.transfer(buf);
        message = "Escrow canceled.";
        emit EscrowEvent(owner, depositor, goalAmount, totalAmount, message, status);
    }
    
    function close() public onlyOwner payable {
        require(status == 0 || status == 3);
        selfdestruct(depositor);
    }
    
    function getBalance() public constant returns(uint _balance, address _depositor, uint _goalAmount, string _message, uint _status) {
        return (address(this).balance, depositor, goalAmount, message, status);
    }
}
