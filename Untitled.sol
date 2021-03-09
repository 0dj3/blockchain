contract Test
{
    struct Owner
    {
        string name;
        uint passSer;
        uint passNum;
        uint256 date;
        string phoneNumber;
    }
    
    struct Home
    {
        string homeAddress;
        fixed area;
        Owner owner;
        uint cost;
    }
    
    struct Request
    {
        int requestType;
        Home home;
        int result;
    }
    
    struct Employee
    {
        string name;
        string position;
        string phoneNumber;
    }
    
    Owner private owner;
    Home private home;
    Request private request;
    Employee private employee;
    
    //function SetRequest(int _requestType, string _homeAddress, fixed _area, uint _cost,  ) public
    //{
    //    
    //}
}
