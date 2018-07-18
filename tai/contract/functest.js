let Web3 = require('web3');
let eth_url="http://localhost:7545";
//合约地址
let ContractAddress="0x1c02Ec2c82F0D38C4824FDbDd4DD3dd8D34562b8";
let abi=[{"constant":false,"inputs":[{"name":"_enodeid","type":"uint256"}],"name":"DelEnode","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_fromenodeid","type":"uint256"},{"name":"_enodeid","type":"uint256"}],"name":"Vote","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_enodename","type":"string"}],"name":"ShowEnodenameExist","outputs":[{"name":"result","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"CompanySum","outputs":[{"name":"sum","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ShowMembers_sum_id","outputs":[{"name":"R_sum","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_companyid","type":"uint256"}],"name":"ShowCompany","outputs":[{"name":"R_companyname","type":"string"},{"name":"R_email","type":"string"},{"name":"R_remark","type":"string"},{"name":"RCompany_Enode","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_companyid","type":"uint256"},{"name":"_enodename","type":"string"}],"name":"AddEnode","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_companyname","type":"string"},{"name":"_email","type":"string"},{"name":"_remark","type":"string"}],"name":"AddCompany","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_enodeid","type":"uint256"}],"name":"ShowBallot","outputs":[{"name":"ticketNum","type":"uint256"},{"name":"Enode_id","type":"uint256"},{"name":"ownerstat","type":"uint256"},{"name":"own","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_companyid","type":"uint256"}],"name":"ShowCompanyidExist","outputs":[{"name":"result","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_companyid","type":"uint256"}],"name":"DelCompany","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_companyname","type":"string"}],"name":"ShowCompanynameExist","outputs":[{"name":"result","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_enodeid","type":"uint256"},{"name":"_stat","type":"uint256"}],"name":"UpdateEnode","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_enodeid","type":"uint256"}],"name":"isMember","outputs":[{"name":"result","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_enodeid","type":"uint256"}],"name":"ShowEnodeExist","outputs":[{"name":"result","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_enodeid","type":"uint256"}],"name":"ShowEnode","outputs":[{"name":"R_companyname","type":"string"},{"name":"R_stat","type":"uint256"},{"name":"R_enodename","type":"string"},{"name":"R_owner","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"EnodeSum","outputs":[{"name":"sum","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_companyid","type":"uint256"},{"name":"_email","type":"string"},{"name":"_remark","type":"string"},{"name":"_stat","type":"uint256"}],"name":"UpdateCompany","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_companyname","type":"string"},{"name":"_email","type":"string"},{"name":"_remark","type":"string"},{"name":"_enode","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_companyname","type":"string"},{"indexed":false,"name":"_email","type":"string"},{"indexed":false,"name":"_remark","type":"string"}],"name":"AddCompanyEV","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_companyid","type":"uint256"}],"name":"DelCompanyEV","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_companyid","type":"uint256"},{"indexed":false,"name":"_email","type":"string"},{"indexed":false,"name":"_remark","type":"string"},{"indexed":false,"name":"_stat","type":"uint256"}],"name":"UpdateCompanyEV","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_companyid","type":"uint256"},{"indexed":false,"name":"_enodename","type":"string"}],"name":"AddEnodeEV","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeid","type":"uint256"},{"indexed":false,"name":"_stat","type":"uint256"}],"name":"UpdateEnodeEV","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeid","type":"uint256"}],"name":"DelEnodeEV","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_fromenodeid","type":"uint256"},{"indexed":false,"name":"_enodeid","type":"uint256"}],"name":"VoteEV","type":"event"}]

let testcompany2="小泰科技2"
//交易发起者
let from="0xbf8cB0542f260466e5c9233E8797d98463A9b14F"
if(typeof web3 != 'undefined'){
	web3=new Web3(web3.currentProvider);
}else{
	web3 = new Web3(eth_url);
}

var MyContract = new web3.eth.Contract(abi,ContractAddress);
//调用显示合约创始公司
MyContract.methods.ShowCompany(1).call().then(console.log);
//新增一家公司测试
MyContract.methods.ShowCompanynameExist(testcompany2).call({from: from}, function(error, result){
    if(!error) {
        MyContract.methods.AddCompany(testcompany2,"10086@10086.com","备注2").send({from: from,gas:200000,gasPrice:20000},function(error, transactionHash){
            if(!error) {
                 console.log("eth交易成功,新增公司ok");
            } else {
                console.log("eth交易拒绝,合约revert判断生效-新增公司");
            }
        });
        
    } else {
        console.log("公司已存在,第一层逻辑判断出错");
    }
});


//更新一家公司测试
MyContract.methods.ShowCompanynameExist("小泰科技").call({from: from}, function(error, result){
    if(!error) {
        MyContract.methods.UpdateCompany(1,"10086@10086.com","更改之后",3).send({from: from,gas:200000,gasPrice:20000},function(error, transactionHash){
            if(!error) {
                 console.log("更新成功,当前交易hash"+transactionHash);
                 MyContract.methods.ShowCompany(1).call().then(console.log);

            } else {
                console.log("eth交易拒绝,合约revert判断生效-更新公司");
            }
        });
        
    } else {
        console.log("公司已存在,第一层逻辑判断出错");
    }
});

//新增一个节点测试
MyContract.methods.ShowEnodenameExist("enode1:aaaaaaa").call({from: from}, function(error, result){
    if(!error) {
        MyContract.methods.AddEnode(1,"enode1:aaaaaaa").send({from: from,gas:200000,gasPrice:20000},function(error, transactionHash){
            if(!error) {
                 console.log("新增enode成功,当前交易hash"+transactionHash);
            } else {
                console.log("eth交易拒绝,合约revert判断生效-新增enode");
            }
        });
        
    } else {
        console.log("enode已存在,第一层逻辑判断出错");
    }
});

MyContract.methods.ShowEnode(1).call().then(console.log);
MyContract.methods.ShowEnode(2).call().then(console.log);

MyContract.methods.ShowMembers_sum_id().call().then(console.log);

//新增一个投票测试
MyContract.methods.ShowEnode(1).call({from: from}, function(error, result){
    if(!error) {
        MyContract.methods.Vote(1,2).send({from: from,gas:200000,gasPrice:20000},function(error, transactionHash){
            if(!error) {
                 console.log("投票成功,当前交易hash"+transactionHash);
            } else {
                console.log("投票拒绝,合约revert判断生效-投票");
            }
        });
        
    } else {
        console.log("第一层逻辑判断出错");
    }
});

MyContract.methods.ShowMembers_sum_id().call().then(console.log);




