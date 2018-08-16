pragma solidity ^0.4.24;
contract CCC {
    struct Ballot_Record {
        mapping(uint => uint) record;
    }
//Definition of voting structure
    struct Ballot {
        uint ticketNum;
        uint companyid;
        address owner;
        mapping(address => uint) voters;
    }
//Defining the Enode structure
    struct Enode{
        uint companyid;
        uint stat;
        string enodename;
        address owner;
        //uint exist;
    }
//Defining organizational structure
    struct Company{
        string companyname;
        string email;
        string remark;
        address owner;
        uint stat;
        //uint exist;
    }
     
    mapping(uint => Company) C_company;
    mapping(string => uint) C_company_stat;
    mapping(uint => Ballot_Record) C_Ballot_Record;
    mapping(uint => Enode) C_enodes;
    mapping(string => uint) C_enodes_stat;
    mapping(uint => Ballot) Votes;
    mapping(uint => uint) Members;//Voting success node member
    
    uint Members_sum_id;
    uint Enode_id;//EnodeID generator, only increasing
    uint Enode_sum_id;//Total number of eNode
    uint Company_id;//CompanyID generator, only increasing
    uint Company_sum_id;//Total number of Company
    uint[] Temp;

    event AddCompanyEV(string _companyname,string _email,string _remark);
    event DelCompanyEV(uint _companyid);
    event UpdateCompanyEV(uint _companyid,string _email,string _remark,uint _stat);
    event AddEnodeEV(uint _companyid,string _enodename);
    event UpdateEnodeEV(uint _enodeid,uint _stat);
    event DelEnodeEV(uint _enodeid);
    event VoteEV(uint _fromcompanyid,uint _tocompanyid);

 
//Initializing the entire contract, enodename must be filled in
 
    function CCC (string _companyname,string _email,string _remark,string _enode) public{
        Enode_id++;
        Company_id++;
        C_company[Company_id] = Company({companyname:_companyname, email:_email, remark:_remark,stat:0,owner:msg.sender});
        
        C_enodes[Enode_id]=Enode({companyid:Company_id,stat:0,enodename:_enode,owner:msg.sender});
        Members[Enode_id]=1;
        Enode_sum_id++;
        Company_sum_id++;
        Members_sum_id++;
        C_company_stat[_companyname]=1;
        C_enodes_stat[_enode]=1;
        
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
    function Vote(uint _fromcompanyid,uint _tocompanyid) public {
        require(C_company[_fromcompanyid].owner == msg.sender, "You are not the owner of this Company");
        require(C_Ballot_Record[_fromcompanyid].record[_tocompanyid] != 1, "You have voted for it");
        require(_fromcompanyid != _tocompanyid, "You can't vote for yourself");
        require( C_company_stat[C_company[_fromcompanyid].companyname]== uint(1), "Your vote source Company does not exist");
        require( C_company_stat[C_company[_tocompanyid].companyname]== uint(1), "The vote Company does not exist");
        require(Members[_fromcompanyid] == uint(1),"Your From_CompanyID is not a selected node");
        require(Members[_tocompanyid] != uint(1),"You can't vote for the CommpanyID that has become an election node");
        Votes[_tocompanyid].ticketNum++;
        Votes[_tocompanyid].voters[msg.sender] = 1;
        C_Ballot_Record[_fromcompanyid].record[_tocompanyid]=1;
        if(Votes[_tocompanyid].ticketNum == Members_sum_id){
            Members[_tocompanyid]=1;
            Members_sum_id++;
            emit VoteEV(_fromcompanyid, _tocompanyid);
            //选举成功数+-1
            
        }
    }
//   Add an organization function that already exists and cannot be added
    function AddCompany (string _companyname,string _email,string _remark) public{
        require(C_company_stat[_companyname] != uint(1), "Already exist");
        Company_id++;
        Company_sum_id++;
        C_company[Company_id] = Company({companyname:_companyname, email:_email, remark:_remark,stat:0,owner:msg.sender});
        C_company_stat[_companyname]=1;
        //Votes[Company_id].ticketNum++;
        Votes[Company_id].companyid=Company_id;
        Votes[Company_id].owner=msg.sender;
        Votes[Company_id].voters[msg.sender] = 1;

        
        emit AddCompanyEV( _companyname, _email, _remark);

    }
//Delete the organization function
     function DelCompany  (uint _companyid) public{
        require(C_company[_companyid].owner == msg.sender, "Not a owner");
        require(C_company_stat[C_company[_companyid].companyname] == 1, "Not existent");
        for(uint  x= 0; x <= Enode_id; x++) {
            if(C_enodes[x].companyid == _companyid)
                delete C_enodes[x];
                Enode_sum_id--;
                delete C_enodes_stat[C_enodes[x].enodename];

                }
        Company_sum_id--;
        delete C_company_stat[C_company[_companyid].companyname];
        delete C_company[Company_id];
        delete Members[_companyid];

        emit DelCompanyEV(_companyid);
        
    }
     
     
//  Change the organization function
    function UpdateCompany (uint _companyid,string _email,string _remark,uint _stat) public{
        require(C_company[_companyid].owner == msg.sender, "Cannot modify this Company");
        require(C_company_stat[C_company[_companyid].companyname] == 1, "Not existent");
        C_company[_companyid].email=_email;
        C_company[_companyid].remark=_remark;
        C_company[_companyid].stat=_stat;
        emit UpdateCompanyEV(_companyid,_email,_remark,_stat);
                 
    }
     
// Add the Enode node and bind to the related Company
 function AddEnode (uint _companyid,string _enodename) public{
        require(C_company[_companyid].owner == msg.sender, "Not a owner");
        require(C_enodes_stat[_enodename] != uint(1), "Already exist");

        Enode_id++;
        Enode_sum_id++;
        C_enodes[Enode_id]=Enode({companyid:_companyid,stat:0,enodename:_enodename,owner:msg.sender});
        C_enodes_stat[_enodename]=1;
        emit AddEnodeEV(_companyid,_enodename);
    }
// Change the Enode function
 function UpdateEnode (uint _enodeid,uint _stat) public{
        require(C_enodes[_enodeid].owner == msg.sender, "Not a owner");
        require(C_enodes_stat[C_enodes[_enodeid].enodename] != uint(1), "Not existent");
        C_enodes[_enodeid].stat=_stat;
        emit UpdateEnodeEV(_enodeid,_stat);
                
    }
// Delete the Enode function
 function DelEnode (uint _enodeid) public{
        require(C_enodes[_enodeid].owner == msg.sender, "Not a owner");
        require(C_enodes_stat[C_enodes[_enodeid].enodename] == uint(1), "Not existent");
        delete C_enodes_stat[C_enodes[_enodeid].enodename];
        delete C_enodes[_enodeid];
        Enode_sum_id--;
        emit DelEnodeEV( _enodeid);
    }
     
   
     
     
//   Query organization
    function ShowCompany(uint _companyid) view public returns(string R_companyname, string R_email,string R_remark,address R_owner,uint[]  RCompany_Enode) {
        require(C_company_stat[C_company[_companyid].companyname] == 1, "Not existent");
        R_companyname=C_company[_companyid].companyname;
        R_remark=C_company[_companyid].remark;
        R_email=C_company[_companyid].email;
        R_owner=C_company[_companyid].owner;
        for(uint i = 0; i <= Enode_id; i++) {
            if(C_enodes[i].companyid == _companyid)
               append(Temp,i);
                
        }
        RCompany_Enode=Temp;
        uint[] Temp;
         
    }
     
//Query enode
    function ShowEnode(uint _enodeid) view public returns(string R_companyname, uint R_stat,string R_enodename,address R_owner ) {
        require(C_enodes_stat[C_enodes[_enodeid].enodename] == uint(1), "Not existent");
        R_companyname=C_company[C_enodes[_enodeid].companyid].companyname;
        R_stat=C_enodes[_enodeid].stat;
        R_enodename=C_enodes[_enodeid].enodename;
        R_owner=C_enodes[_enodeid].owner;
    }
// Voting query
    function isMember(uint _companyid) view public returns (bool result){
        result = false;
        if(Members[_companyid] == 1){
            result = true;
        }
    }
//   Query Enode sum
    function EnodeSum() view public returns (uint sum){
       sum=Enode_sum_id;
    }
// Query Company sum    
    function CompanySumID() view public returns (uint sum){
       sum=Company_sum_id;
    }
    function CompanySum() view public returns (uint sum){
       sum=Company_id;
    }
    
    function ShowBallot(uint _companyid) view public returns (uint ticketNum,uint Company_id,uint ownerstat,address own){
        ticketNum=Votes[_companyid].ticketNum;
        Company_id=Votes[_companyid].companyid;
        ownerstat=Votes[_companyid].voters[msg.sender];
        own=Votes[_companyid].owner;
    }
    
    function ShowEnodeExist(uint _enodeid) view public returns(bool result) {
        result = false;
        if(C_enodes_stat[C_enodes[_enodeid].enodename] == 1){
            result = true;
        }
    }

    function ShowEnodenameExist(string _enodename) view public returns(bool result) {
        result = false;
        if(C_enodes_stat[_enodename] == 1){
            result = true;
        }
    }
    
    function ShowCompanyidExist(uint _companyid) view public returns(bool result) {
        result = false;
        if(C_company_stat[C_company[_companyid].companyname]  == 1){
            result = true;
        }
    }

    function ShowCompanynameExist(string _companyname) view public returns(bool result) {
        result = false;
        if(C_company_stat[_companyname]  == 1){
            result = true;
        }
    }
    
     function ShowMembers_sum_id() view public returns(uint R_sum) {
       R_sum=Members_sum_id;
    }
    
    
}