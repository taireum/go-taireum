pragma solidity ^0.4.24;

contract CCC {
    //定义企业
    struct Company{
        string company;
        string email;
        string remark;
        address owner;
        string enode;
        uint stat;
    }
    //Member 选举票数
    struct Ballot {
        uint ticketNum;
        mapping(address => uint) voters;
    }
   //Poa投票票数   
    struct Mine_Ballot {
        uint ticketNum;
        mapping(address => uint) voters;
    }
   // Poa投票记录  
    struct Mine_Ballot_Record {
        mapping (uint => uint)  record;
    }
    //Member 投票记录
    struct Ballot_Record {
        mapping (uint => uint)  record;
    }
    
    mapping(uint => Company) C_company;
    mapping(address => Ballot) C_votes;
    mapping(address => uint) C_Members;
    mapping(address => uint) C_Member_mine;

    mapping(uint => Mine_Ballot_Record) C_Ballot_Record_mine;
    mapping(address => Mine_Ballot) C_votes_mine;

    
    mapping(uint => Ballot_Record) C_Ballot_Record;
    mapping(string => uint) C_company_stat;
    mapping(address => uint) C_account_stat;


    //投票后 poa的总票数
    uint Members_mine_sum_id;
   //Member成员总票数
    uint Members_sum_id;
    //企业id 自增
    uint Company_id;
    //初始化合约
    function CCC (string _companyname,string _email,string _remark,string _enode) public{
        Company_id++;
        
        C_company[Company_id] = Company({company:_companyname,email:_email, remark:_remark,stat:0,owner:msg.sender,enode:_enode});
        C_Members[msg.sender]=1;
        C_Member_mine[msg.sender]=1;
        Members_mine_sum_id++;
        Members_sum_id++;
        C_account_stat[msg.sender]=1;
        C_company_stat[_companyname]=1;

    }
    
    
    //投票成为联盟成员(Member)
    function VoteMember(uint _fromcompanyid,uint _tocompanyid) public {
        require(_fromcompanyid != _tocompanyid, "from and to eq");

        require(C_company_stat[C_company[_fromcompanyid].company] == uint(1), "The Vote of from company does not exist");
        require(C_company_stat[C_company[_tocompanyid].company] == uint(1), "The Vote of to company does not exist");
        require(C_company[_fromcompanyid].owner == msg.sender ,"Not the company account address");
        require(C_Ballot_Record[_fromcompanyid].record[_tocompanyid] != uint(1) ,"Have voted");
 
       
        C_votes[C_company[_tocompanyid].owner].ticketNum++;
        C_Ballot_Record[_fromcompanyid].record[_tocompanyid]=1;

        if(C_votes[C_company[_tocompanyid].owner].ticketNum == Members_sum_id){
            C_Members[C_company[_tocompanyid].owner]=1;
            Members_sum_id++;

        }
    }

    // 投票授权打包区块投票，前提必须已经联盟成员
    function VoteMine(uint _fromcompanyid,uint _tocompanyid) public {
        require(_fromcompanyid != _tocompanyid, "from and to eq");
        require(C_Members[C_company[_tocompanyid].owner] == uint(1) ,"_tocompanyid not POA");
        require(C_Members[C_company[_fromcompanyid].owner] == uint(1) ,"_fromcompanyid not POA");


        require(C_company_stat[C_company[_fromcompanyid].company] == uint(1), "The Vote of from company does not exist");
        require(C_company_stat[C_company[_tocompanyid].company] == uint(1), "The Vote of to company does not exist");
        require(C_company[_fromcompanyid].owner == msg.sender ,"Not the company account address");
        require(C_Ballot_Record_mine[_fromcompanyid].record[_tocompanyid] != uint(1) ,"Have voted");

       
        C_votes_mine[C_company[_tocompanyid].owner].ticketNum++;
        C_Ballot_Record_mine[_fromcompanyid].record[_tocompanyid]=1;

        if(C_votes_mine[C_company[_tocompanyid].owner].ticketNum == Members_mine_sum_id){
            C_Member_mine[C_company[_tocompanyid].owner]=1;
            Members_mine_sum_id;

        }
    }

    //联盟新成员申请
   function applyMember (string _companyname,string _email,string _remark,string _enode,address _account) public{
        require(C_Members[msg.sender] == uint(1), "Not POA account");

        require(C_company_stat[_companyname] != uint(1), "The company has already existed");
        require(C_account_stat[_account] != uint(1), "The account address has already existed");

        Company_id++;
        C_company[Company_id] = Company({company:_companyname,email:_email, remark:_remark,stat:0,owner:_account,enode:_enode});
        C_company_stat[_companyname]=1;
        C_account_stat[_account]=1;


   }
   //更改
   function UpdateCompany (uint _companyid,string _email,string _remark,string _enode,uint _stat) public{
        require(C_company_stat[C_company[_companyid].company] == uint(1), "The company does not exist");
        require(C_company[_companyid].owner == msg.sender ,"Not the company account address");

        C_company[_companyid] = Company({company:C_company[_companyid].company,email:_email, remark:_remark,stat:_stat,enode:_enode,owner:msg.sender});

   }
   
   //查询投票记录
   function ShowBallot(uint _companyid) view public returns (uint ticketNum){
        ticketNum=C_votes[C_company[_companyid].owner].ticketNum;
        
    }
    //查看挖矿投票数
    function ShowBallotMine(uint _companyid) view public returns (uint ticketNum){
        ticketNum=C_votes_mine[C_company[_companyid].owner].ticketNum;
        
    }
    //查询企业是否为poa成员
    function isMember(uint _companyid ) view public returns (bool result){
        result = false;
        if(C_Members[C_company[_companyid].owner] ==1){
            result = true;
        }
    }
    //查询企业是否有挖矿打包权限
    function isMemberMine(uint _companyid ) view public returns (bool result){
        result = false;
        if(C_Member_mine[C_company[_companyid].owner] ==1){
            result = true;
        }
    }
    //查询账号是否是poa账号
    function isMemberOwner( address _account) view public returns (bool result){
        result = false;
        if(C_Members[_account] ==1){
            result = true;
        }
    }
    //查询企业的所有信息
    
    function ShowCompany(uint _companyid) view public returns(string R_companyname, string R_email,string R_remark,address R_owner,string R_enode,uint R_stat) {
        R_companyname=C_company[_companyid].company;
        R_remark=C_company[_companyid].remark;
        R_email=C_company[_companyid].email;
       
        R_enode=C_company[_companyid].enode;
        
        R_owner=C_company[_companyid].owner;
        R_stat=C_company[_companyid].stat;

         
    }
    //查询多少企业
    function ShowSum() view public returns(uint sum) {
        sum=Company_id;
         
    }
}