// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract SchoolContract{

struct Student{

    address payable walletAddress;
    uint256 examgrade;
    uint256 balances;

}

struct Teacher{
    address payable teacherWalletAddress;
    uint256 balances;
}

    address public manager;

    uint public managerSalary = 1 ether; 
  
    constructor(){
        manager = msg.sender;
    }

    mapping(address => Teacher) public teachers;
    mapping(address => Student) public students;


   // mapping(address => uint) public deadLine;


    function addStudent(address payable walletAddress, uint256 examgrade, uint256 balances)onlymanager notSameAddress(walletAddress) external {
        require(examgrade <= 100, "Should be 100");
        students[walletAddress] = Student(walletAddress,examgrade,balances);
    }

    function addTeacher(address payable walletAddress,uint256 balances)onlymanager notSameAddress(walletAddress) external{
        teachers[walletAddress] = Teacher(walletAddress, balances);        
    }

    function getStudents(address walletAddress)external view returns(address _walletAdress , uint _examgrade ,  uint _balances){
        _walletAdress = students[walletAddress].walletAddress;
        _examgrade = students[walletAddress].examgrade;
        _balances = students[walletAddress].balances;
    }


    function getTeacher(address walletAddress) external onlyTeacher(walletAddress) onlymanager view returns(address _walletAddress , uint256 _balances){
        _walletAddress = teachers[walletAddress].teacherWalletAddress;
        _balances = teachers[walletAddress].balances;
    }

    function setStudentsNotes(address walletAddress, uint _examgrade) onlyTeacher(walletAddress) external {
        require(_examgrade <= 100, "Should be 100");
        students[walletAddress].examgrade = _examgrade;
    }

    function passedOrNot(address walletAddress) external view returns(string memory){
      return students[walletAddress].examgrade >= 50 ? "You passed!" : "You failed!";
    }
    
    function sendEtherStudent(address walletAddress,uint256 _amount)biggerThanZero(_amount) onlyTeacher(walletAddress) external payable{
        require(_amount < 1 ether ,"The amount sent cannot exceed 1 ether!");
        require(students[walletAddress].examgrade >= 85, "Your exam point bigger than 85!");
        students[walletAddress].balances += _amount;
        managerSalary -=_amount;
    }

    function teacherPayment(address walletAddress,uint256 _amount)biggerThanZero(_amount) onlymanager  external{
            teachers[walletAddress].balances += _amount;
            managerSalary -= _amount;
    }   

    function teacherWantExtra(address walletAddress ,uint256 _extraPayment) onlyTeacher(walletAddress) external{
        if(_extraPayment <= 49){
            teachers[walletAddress].balances += _extraPayment;
            managerSalary -= _extraPayment;
        }else {
          revert("Too many request to extra payment!");
        }
    }

    function deleteStudent(address walletAddress)onlymanager external{
        require(students[walletAddress].examgrade ==0 , "The point should be 0");
        delete(students[walletAddress]);
    }

    function deleteTeacher(address walletAddress) onlymanager external{
        delete(teachers[walletAddress]);
    }


    modifier onlymanager(){
        require(manager == msg.sender, "Youre not manager.");
        _;
    }
    modifier onlyTeacher(address walletAddress){
        require(teachers[walletAddress].teacherWalletAddress != students[walletAddress].walletAddress,"Youre not teacher");
        _;
    }

    modifier biggerThanZero(uint256 _amount){
        require(_amount > 0 ,"Amount must bigger than 0 !");
        _;
    }
    
    modifier notSameAddress(address walletAddress){
        _;
        require(teachers[walletAddress].teacherWalletAddress != students[walletAddress].walletAddress,"Teacher and student addresses should not be the same!!");
    }


}