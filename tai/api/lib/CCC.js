const Web3 = require('web3');
let fs   = require('fs');
const config = require('./config');
var exec = require('child_process').exec;


if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(config.eth_url);
}

//var data = fs.readFileSync('/opt/ccc_rest/lib/address.json', 'utf-8');
//var person = JSON.parse(data);//将字符串转换为json对象
//contractaddress=person.contractaddress;

// 交易发起者

const MyContract = new web3.eth.Contract(config.abi, config.contractaddress);


class CCC {
    async coinbase(){
        const address=await web3.eth.getCoinbase();
        return { code: 200,message:address} ; 
    }

    async add_companys(_from, _companyname, _email, _remark, _enode,_address) {
        const add_companys_stat=await MyContract.methods.AddCompany(_companyname, _email, _remark,_enode, _address).send({from: _from,gas: config.gas,gasPrice: config.gasPrice});
        
            return { code: 200,message: '添加公司成功',detail: add_companys_stat.transactionHash} ;
            
        }

    async update_companys(_from ,_companyid, _email, _remark, _enode, _stat) {
        const update_companys_stat=await MyContract.methods.UpdateCompany(_companyid, _email, _remark,_enode, _stat).send({from: _from,gas: config.gas,gasPrice: config.gasPrice});
        
            return { code: 200,message: '更新公司成功',detail: update_companys_stat.transactionHash} ;
            
        }
    async vote(_from ,_fromcompanyid,_tocompanyid) {
        const vote_stat=await MyContract.methods.Vote(_fromcompanyid,_tocompanyid).send({from: _from,gas: config.gas,gasPrice: config.gasPrice});
        
            return { code: 200,message: '投票成功',detail: vote_stat.transactionHash} ;
            
        }

    async checkmember(_from ,_companyid) {
        const checkmember_stat=await MyContract.methods.isMember(_companyid).call({from: _from});
        
            return { code: 200,message: '查询成功',detail: checkmember_stat} ;
            
        }
    async checkmemberowner(_from ,_account) {
        const checkmember_stat=await MyContract.methods.isMemberOwner(_account).call({from: _from});
        
            return { code: 200,message: '查询成功',detail: checkmember_stat} ;
            
        }
    async getcompany(_from ,_companyid) {
        const getcompany_stat=await MyContract.methods.ShowCompany(_companyid).call({from: _from});
        
            return { code: 200,message: '查询成功',detail: getcompany_stat} ;
            
        }

    async votemine(_from ,_fromcompanyid,_tocompanyid) {
        const votemine_stat=await MyContract.methods.VoteMine(_fromcompanyid,_tocompanyid).send({from: _from,gas: config.gas,gasPrice: config.gasPrice});
        
            return { code: 200,message: '挖矿节点投票成功',detail: votemine_stat.transactionHash} ;
            
        }

    async init_new(_company, _email, _remark, _chainid,_datadir,_rpcport,_eth_url,_networkid) {
        var command="cd lib/;crontab `pwd`/init";
        console.log(command)
        exec(command, function(err,stdout,stderr){
        if(err) {
            console.log(stderr);
        } else {
            
            console.log(stdout);
        }
		});
        
        
        const setup={ "company":_company,"remark":_remark,"email":_email,"chainid":_chainid,"datadir":_datadir,"rpcport":_rpcport,"eth_url":_eth_url,"networkid":_networkid}
        var str=JSON.stringify(setup)
        fs.writeFile('lib/ccc_setup.json',str,function(err){
	        if(err){
		    console.error(err);}
	        console.log('----------新增成功-------------');
        })
        
        return { code: 200,message: '后台任务已经触发,请稍后'} ;
            
        }
    
    }
    

module.exports = CCC;