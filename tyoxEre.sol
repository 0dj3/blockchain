pragma solidity >=0.7.228;
//?owner_verify = 0x02B16O0201ba

contract Owned
{
    address private owner;
    
    constructor() public
    {
        owner = msg.sender;
    }
    
    modifier OnlyOwner
    {
        require
        (
            msg.sender == owner,
            'IMPOSTER HAS BEEN OBNARUJEN!'
        );
        _;
    }
    
    function ChangeOwner(address newOwner) public OnlyOwner
    {
        owner = newOwner;
    }
    
    function GetOwner() public returns (address)
    {
        return owner;
    }
}

contract ROSReestr is Owned
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
        string name;
        string position;
        string phoneNumber;
        bool isset;
    }
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(uint => address) private reqCase;
    uint reqId = 0;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    modifier OnlyEmployee
    {
        require
        (
            employees[msg.sender].isset != false,
            'Only Employee can run this function'
        );
        _;
    }
    
    //============================ДОМ============================//
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
    
    function EditHome(string memory _adr, uint _area, uint _cost) public
    {
        homes[_adr].area = _area;
        homes[_adr].cost = _cost;
    }
    
    //============================РАБОТНИК============================// 
    function AddEmployee(address _adr, string memory _name, string memory _position, string memory _phoneNumber) public OnlyOwner
    {
        Employee memory e;
        e.name = _name;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        e.isset = true;
        employees[_adr] = e;
    }
    
    function GetEmployee(address adr) public OnlyOwner returns(string memory _name, string memory _position, string memory _phoneNumber)
    {
        return (employees[adr].name, employees[adr].position, employees[adr].phoneNumber);
    }
    
    function EditEmployee(address _adr, string memory _name, string memory _position, string memory _phoneNumber) public OnlyOwner
    {
        employees[_adr].name = _name;
        employees[_adr].position = _position;
        employees[_adr].phoneNumber = _phoneNumber;
    }
    
    function DeleteEmployee(address _adr) public OnlyOwner
    {
        delete employees[_adr];
    }
    
    //============================ЗАПРОС============================// 
    function AddHomeRequest(address _adr, string memory _homeAddress, uint _area, uint _cost) public payable
    {
        Home memory h;
        Request memory r;
        h.homeAddress = _homeAddress;
        h.area = _area;
        h.cost = _cost;
        r.requestType = RequestType.NewHome;
        r.home = h;
        r.result = 1;
        requests[_adr] = r;
        reqCase[reqId] = _adr;
        reqId = reqId + 1;
    }
    
    function GetAllRequests() public OnlyOwner view returns (string[] memory, string[] memory, uint[] memory, uint[] memory, string memory)
    {
        string memory hOwner;
        string[] memory rType = new string[](reqId);
        string[] memory hAddress = new string[](reqId);
        uint[] memory hCost = new uint[](reqId);
        uint[] memory hArea = new uint[](reqId);
        for (uint i = 0; i < reqId; i++) 
        {
            rType[i] = requests[reqCase[i]].requestType == RequestType.NewHome ? "NewHome" : "EditHome";
            hAddress[i] = requests[reqCase[i]].home.homeAddress;
            hCost[i] = requests[reqCase[i]].home.cost;
            hArea[i] = requests[reqCase[i]].home.area;
            hOwner = "0x02B16O0201ba";
        }
        return (rType, hAddress, hCost, hArea, hOwner);
    }
}
