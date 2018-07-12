pragma solidity ^0.4.0;
contract CCC {
    struct Ballot {
        uint ticketNum;
        uint enodeid;
        mapping(address => uint) voters;
    }
    struct Enode{
        uint companyid;
        uint stat;
        string enodename;
        address owner;
    }
    struct Company{
        string companyname;
        string email;
        string remark;
        address owner;
        uint stat;
    }

    
    mapping(uint=> Company) C_company;
    mapping(uint => Enode) C_enodes;
    mapping(uint => Ballot) Votes;

    uint Enode_id;
    uint Enode_sum_id;
    uint Company_id;
    uint Company_sum_id;
    uint[] Temp;



    function CCC (string _companyname,string _email,string _remark,string _enode) public{
        Enode_id=1;
        Company_id=1;
        C_company[Company_id] = Company({companyname:_companyname, email:_email, remark:_remark,stat:0,owner:msg.sender});
       
        C_enodes[Enode_id]=Enode({companyid:Company_id,stat:0,enodename:_enode,owner:msg.sender});
        Votes[Enode_id].ticketNum++;
        Votes[Enode_id].enodeid=Enode_id;
        Votes[Enode_id].voters[msg.sender] = 1;
        Enode_sum_id=Enode_id;
        Company_sum_id=Company_id;

    }
    function Compare(string _a, string _b) returns (int) {
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
    
    function Vote(uint _enodeid) public {
        require(C_enodes[_enodeid].owner != msg.sender, "Cannot vote");

        if(Votes[_enodeid].voters[msg.sender] >= 1 )
            revert("you had voted the enode.");
        
        Votes[_enodeid].ticketNum++;
        Votes[_enodeid].voters[msg.sender] = 1;
    }
//   
    function AddCompany (string _companyname,string _email,string _remark) public{
        //require(C_company[Company_id].owner != msg.sender, "only provider can add product");
        Company_id++;
        Company_sum_id++;
        C_company[Company_id] = Company({companyname:_companyname, email:_email, remark:_remark,stat:0,owner:msg.sender});
    }
//    
     function DelCompany  (uint _companyid) public{
        require(C_company[Company_id].owner != msg.sender, "Cannot delete this Company");
        for(uint i = 0; i <= Company_sum_id; i++) {
            if(i == _companyid) {
                    delete C_company[Company_id];
                    for(uint  x= 0; x <= Enode_id; i++) {
                        if(C_enodes[x].companyid == _companyid)
                           delete C_enodes[x];
                           Enode_sum_id--;
                           
                           
                    }
                    Company_sum_id--;
            }else{revert("No companyid exists");}
        }
    }
    
    
//  
    function UpdateCompany (uint _companyid,string _companyname,string _email,string _remark,uint _stat) public{
        require(C_company[Company_id].owner != msg.sender, "Cannot modify this Company");
        for(uint i = 0; i <= Company_sum_id; i++) {
            if(i == _companyid) {
            C_company[_companyid] = Company({companyname:_companyname, email:_email, remark:_remark,stat:_stat,owner:msg.sender});
            }else{revert("No companyid exists");}
        }
                
            }
    

//
 function AddEnode (uint _companyid,string _enodename) public{
        require(C_company[_companyid].owner != msg.sender, "No permission to add the organization eNode");
        for(uint i = 0; i <= Enode_sum_id; i++) {
            if(Compare(C_enodes[i].enodename, _enodename) == 0)
                revert("There are already eNode");
        }
        C_enodes[Enode_id]=Enode({companyid:_companyid,stat:0,enodename:_enodename,owner:msg.sender});
        Enode_id++;
        Enode_sum_id++;
        
    }
//
 function UpdateEnode (uint _enodeid,uint _stat) public{
        require(C_enodes[_enodeid].owner != msg.sender, "Cannot modify this eNode");
        for(uint i = 0; i <= Enode_sum_id; i++) {
                if(i == _enodeid) {        
                    C_enodes[_enodeid].stat=_stat;
                }else{revert("No enodeid exists");}
        }
    }

//
 function DelEnode (uint _enodeid) public{
        require(C_enodes[_enodeid].owner != msg.sender, "Cannot delete this eNode");
        for(uint i = 0; i <= Enode_sum_id; i++) {
                if(i == _enodeid) {

                    delete C_enodes[_enodeid];
                    Enode_sum_id--;
                }else{revert("No enodeid exists");}
        }
    }
    
//   
    function append(uint[] storage d,uint _enodeid) internal{
        d.push(_enodeid);
    }
  
    
//   
    function ShowCompany(uint _companyid) view public returns(string R_companyname, string R_email,string R_remark,uint[]  RCompany_Enode) {
        if(_companyid >Company_id )
            revert("no companyid");
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
    
//
    function ShowEnode(uint _enodeid) view public returns(string R_companyname, uint R_stat,string R_enodename ) {
        for(uint i = 0; i <= Enode_sum_id; i++) {
            if(i == _enodeid) {
                R_companyname=C_company[C_enodes[_enodeid].companyid].companyname;
                R_stat=C_enodes[_enodeid].stat;
                R_enodename=C_enodes[_enodeid].enodename;
         }else
                {revert("No enodeid exists");}
    }
        
    }
  //  
        function isMember(uint _enodeid) view public returns (bool result){
        result = false;
        if(Votes[Enode_id].ticketNum >= Enode_sum_id){
            result = true;
        }
    }



}
