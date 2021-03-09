pragma solidity >=0.4.22 <0.6.0;

contract Test
{
    enum RequestType {NewHome, EditHome}
    
    struct Ownership
    {
        string homeAddress;
        address owner;
        uint p;
    }
    
    struct Owner
    {
        string name;
        uint passSer;
        uint passNum;
        string date; //TODO переделать
        string phoneNumber;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        uint cost;
    }
    
    struct Request
    {
        RequestType requestType;
        Home home;
        uint result;
    }
    
    struct Employee
    {
        uint passNum;
        uint passSer;
        string name;
        string position;
        string phoneNumber;
    }
    
    mapping(string => Employee) private emplyees; //TORO изменить ключ на что-то другое
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    function AddHome(string memory _adr, uint _area, uint _cost) public
    {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public returns(uint _area, uint _cost)
    {
        return (homes[adr].area, homes[adr].cost);
    }
     
    function AddEmployee(string memory _name, string memory _position, string memory _phoneNumber) public
    {
        Employee memory e;
        e.name = _name;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        emplyees[_phoneNumber] = e;
    }
    
    function EditEmployee(string memory phoneNumber, string memory _nameEmployee, string memory _position) public
    {
       emplyees[phoneNumber].name = _nameEmployee;
       emplyees[phoneNumber].position = _position;
    }
    
    function GetEmployee(string memory phoneNumber) public returns(string memory _name, string memory _position)
    {
         return (emplyees[phoneNumber].name, emplyees[phoneNumber].position);
    }
}
