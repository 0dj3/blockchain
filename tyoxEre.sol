pragma experimental ABIEncoderV2;

contract Owned
{
    address payable private  owner;
    
    constructor() public
    {
        owner = msg.sender;
    }
    
    modifier OnlyOwner
    {
        require
        (
            msg.sender == owner,
            'IMPOSTER OBNARUJEN!'
        );
        _;
    }
    
    function ChangeOwner(address payable newOwner) public OnlyOwner
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
    
    //============================СТРУКТУРЫ============================//
    
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
        bool isExist;
    }
    
    struct Request
    {
        RequestType requestType;
        Home home; 
        bool isProcessed;
        uint result;
        address adr;
    }
    
    struct Employee
    {
        string name;
        string position;
        string phoneNumber;
        bool isset;
    }
    
    //============================ПЕРЕМЕННЫЕ============================//
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    address[] requestsInitiator;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    uint private amount;
    uint256 private prize = 100 wei;//Цена
    
    //============================МОДИФИКАТОРЫ============================// 
    
    modifier OnlyEmployee
    {
        require
        (
            employees[msg.sender].isset != false,
            'Are you rabotnik? Net? Nu togda go home!'
        );
        _;
    }
    
    modifier Costs(uint256 _value)
    {
        require(
            msg.value >= _value,
            'Po4 tut tak malo?!'
            );
            _;
    }
    
    //============================ВЛАДЕЛЕЦ============================//
    
    function AddOwnership(string memory _homeAddress, address _owner, uint _p) public
    {
        Ownership memory o;
        o.homeAddress = _homeAddress;
        o.owner = _owner;
        o.p = _p;
        ownerships[_homeAddress].push(o);
    }
    
    function EditOwnership(string memory _homeAddress, address _owner, uint _p) public
    {
        //TODO доделать
    }
    
    function DeleteOwnership(string memory _homeAddress, address _owner) public
    {
        delete ownerships[_homeAddress]; //TODO переделать
    }
    
    function GetOwnership(string memory adr) public view returns(uint[] memory, address[] memory)
    {
        //Ownership[] memory ownership = new Ownership[](ownerships[adr].length);
        uint[] memory p = new uint[](ownerships[adr].length);
        address[] memory ownerAddress = new address[](ownerships[adr].length);
        for(uint i = 0; i != ownerships[adr].length; i++)
        {
            p[i] = ownerships[adr][i].p;
            ownerAddress[i] = ownerships[adr][i].owner;
            
        }
        return(p, ownerAddress);
    }
    
    //============================ДОМ============================//
    
    function AddHome(string memory _adr, uint _area, uint _cost) public
    {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        h.isExist = true;
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
    
    function DeleteEmployee(address _adr) public OnlyOwner returns(bool)
    {
        if (employees[_adr].isset == true)
        {
            delete employees[_adr];
            return true;
        }
        return false;
    }
    
    //============================ЗАПРОС============================// 
    
    function AddRequest(uint _rType, string memory _homeAddress, uint _area, uint _cost, address _newOwner) public payable Costs(prize) returns(bool)
    {
        Home memory h;
        h.homeAddress = _homeAddress;
        h.area = _area;
        h.cost = _cost;
        Request memory r;
        r.requestType = _rType == 0? RequestType.NewHome : RequestType.EditHome;
        r.home = h;
        r.result = 0;
        r.adr = _rType == 0 ? address(0) : _newOwner;
        r.isProcessed = false;
        requests[msg.sender] = r;
        requestsInitiator.push(msg.sender);
        amount += msg.value;
        return true;
    }
    
    function GetRequest() public OnlyEmployee view returns (uint[] memory, uint[] memory, string[] memory)
    {
        uint[] memory ids = new uint[](requestsInitiator.length);
        uint[] memory types = new uint[](requestsInitiator.length);
        string[] memory homeAddress = new string[](requestsInitiator.length);
        for(uint i = 0; i != requestsInitiator.length; i++)
        {
            ids[i] = i;
            types[i] = requests[requestsInitiator[i]].requestType == RequestType.NewHome ? 0 : 1;
            homeAddress[i] = requests[requestsInitiator[i]].home.homeAddress;
        }
        return (ids, types, homeAddress);
    }
    
    function DeleteRequest(uint _reqId) public
    {
        delete requests[requestsInitiator[_reqId]];
    }
    
    //============================ЦЕНА============================//
    
    function ChangePrice(uint256 _newPrice) public OnlyOwner
    {
        prize = _newPrice;
    }
    
    function GetPrice() public view returns(uint256, string memory)
    {
        return (prize, " wei");
    }
    
    //============================ОБРАБОТКА============================// 
    
    function Obrabotka(uint _reqId) public OnlyEmployee returns(string memory)
    {
        if (requests[requestsInitiator[_reqId]].requestType == RequestType.NewHome)
        {
            if(homes[requests[requestsInitiator[_reqId]].home.homeAddress].isExist == false)
            {
                AddHome(requests[requestsInitiator[_reqId]].home.homeAddress,requests[requestsInitiator[_reqId]].home.area, requests[requestsInitiator[_reqId]].home.cost);
                DeleteRequest(_reqId);
                delete requestsInitiator[_reqId];
                return "Home dobablen!";
            }
           
        }
        else
        {
            if(homes[requests[requestsInitiator[_reqId]].home.homeAddress].isExist == true)
            {
                EditHome(requests[requestsInitiator[_reqId]].home.homeAddress,requests[requestsInitiator[_reqId]].home.area, requests[requestsInitiator[_reqId]].home.cost);
                DeleteRequest(_reqId);
                delete requestsInitiator[_reqId];
                return "Home edited";
            }
            else
            {
                return "Home ne exist";
            }
        }
    }
}
