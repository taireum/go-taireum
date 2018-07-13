pragma solidity ^0.4.0;
contract CCC {
//Definition of voting structure
    struct Ballot {
        uint ticketNum;
        uint enodeid;
        mapping(address => uint) voters;
    }
//Defining the Enode structure
    struct Enode{
        uint companyid;
        uint stat;
        string enodename;
        address owner;
        uint exist;
    }
//Defining organizational structure
    struct Company{
        string companyname;
        string email;
        string remark;
        address owner;
        uint stat;
        uint exist;
    }
     
    mapping(uint => Company) C_company;
    mapping(uint => Enode) C_enodes;
    mapping(uint => Ballot) Votes;
 
    uint Enode_id;//EnodeID generator, only increasing
    uint Enode_sum_id;//Total number of eNode
    uint Company_id;//CompanyID generator, only increasing
    uint Company_sum_id;//Total number of Company
    uint[] Temp;
 
//Initializing the entire contract, enodename must be filled in
 
    function CCC (string _companyname,string _email,string _remark,string _enode) public{
        Enode_id++;
        Company_id++;
        C_company[Company_id] = Company({companyname:_companyname, email:_email, remark:_remark,stat:0,owner:msg.sender,exist:1});
        
        C_enodes[Enode_id]=Enode({companyid:Company_id,stat:0,enodename:_enode,owner:msg.sender,exist:1});
        Votes[Enode_id].ticketNum++;
        Votes[Enode_id].enodeid=Enode_id;
        Votes[Enode_id].voters[msg.sender] = 1;
        Enode_sum_id++;
        Company_sum_id++;
    }
//Character contrast function of internal ==0 true
    function Compare(string _a, string _b) internal returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
//The temporary internal function is used to generate Company and eNode inclusion relations   
    function append(uint[] storage d,uint _enodeid) internal{
        d.push(_enodeid);
    }
//Enode node voting function
    function Vote(uint _enodeid) public {
        require(C_enodes[_enodeid].owner != msg.sender, "Not a owner");
        require(Votes[_enodeid].voters[msg.sender] >= 1, "had voted");
        Votes[_enodeid].ticketNum++;
        Votes[_enodeid].voters[msg.sender] = 1;
    }
//   Add an organization function that already exists and cannot be added
    function AddCompany (string _companyname,string _email,string _remark) public{
         
        for(uint i = 0; i <= Company_sum_id; i++) {
            if(Compare(C_company[i].companyname, _companyname) == 0)
                revert("Already exist");
        }
        Company_id++;
        Company_sum_id++;
        C_company[Company_id] = Company({companyname:_companyname, email:_email, remark:_remark,stat:0,owner:msg.sender,exist:1});
    }
//Delete the organization function
     function DelCompany  (uint _companyid) public{
        require(C_company[_companyid].owner == msg.sender, "Not a owner");
        require(C_company[_companyid].exist == uint(1), "Not existent");
        delete C_company[Company_id];
        for(uint  x= 0; x <= Enode_id; x++) {
            if(C_enodes[x].companyid == _companyid)
                delete C_enodes[x];
                Enode_sum_id--;
                }
        Company_sum_id--;
        
    }
     
     
//  Change the organization function
    function UpdateCompany (uint _companyid,string _companyname,string _email,string _remark,uint _stat) public{
        require(C_company[_companyid].owner == msg.sender, "Cannot modify this Company");
        require(C_company[_companyid].exist == uint(1), "Not existent");
        C_company[_companyid] = Company({companyname:_companyname, email:_email, remark:_remark,stat:_stat,owner:msg.sender,exist:1});
             
                 
    }
     
// Add the Enode node and bind to the related Company
 function AddEnode (uint _companyid,string _enodename) public{
        require(C_company[_companyid].owner == msg.sender, "Not a owner");
        for(uint i = 0; i <= Enode_id; i++) {
            if(Compare(C_enodes[i].enodename, _enodename) == 0)
                revert("Already exist");
        }
        Enode_id++;
        Enode_sum_id++;
        C_enodes[Enode_id]=Enode({companyid:_companyid,stat:0,enodename:_enodename,owner:msg.sender,exist:1});
         
         
    }
// Change the Enode function
 function UpdateEnode (uint _enodeid,uint _stat) public{
        require(C_enodes[_enodeid].owner == msg.sender, "Not a owner");
        require(C_enodes[_enodeid].exist == uint(1), "Not existent");
        C_enodes[_enodeid].stat=_stat;
                
    }
// Delete the Enode function
 function DelEnode (uint _enodeid) public{
        require(C_enodes[_enodeid].owner == msg.sender, "Not a owner");
        require(C_enodes[_enodeid].exist == uint(1), "Not existent");
        delete C_enodes[_enodeid];
        Enode_sum_id--;
    }
     
   
     
     
//   Query organization
    function ShowCompany(uint _companyid) view public returns(string R_companyname, string R_email,string R_remark,uint[]  RCompany_Enode) {
        require(C_company[_companyid].exist == uint(1), "Not existent");
        R_companyname=C_company[_companyid].companyname;
        R_remark=C_company[_companyid].remark;
        R_email=C_company[_companyid].email;
        for(uint i = 0; i <= Enode_id; i++) {
            if(C_enodes[i].companyid == _companyid)
               append(Temp,_companyid);
                
        }
        RCompany_Enode=Temp;
        uint[] Temp;
         
    }
     
//Query enode
    function ShowEnode(uint _enodeid) view public returns(string R_companyname, uint R_stat,string R_enodename,address R_owner ) {
        require(C_enodes[_enodeid].exist == uint(1), "Not existent");
        R_companyname=C_company[C_enodes[_enodeid].companyid].companyname;
        R_stat=C_enodes[_enodeid].stat;
        R_enodename=C_enodes[_enodeid].enodename;
        R_owner=C_enodes[_enodeid].owner;
    }
// Voting query
        function isMember(uint _enodeid) view public returns (bool result){
        result = false;
        if(Votes[_enodeid].ticketNum >= Enode_sum_id){
            result = true;
        }
    }
}
