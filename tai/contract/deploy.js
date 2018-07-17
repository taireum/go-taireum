//合约发布
let Web3 = require('web3');
let solc = require("solc");
let fs   = require('fs');
let eth_url="http://localhost:7545";
let sol_file="ccc.sol";
let company="小泰科技";
let email="979857108@qq.com";
let remark="暂略";
let enode="enode:xxxxxx";
let gas=10000000;


if(typeof web3 != 'undefined'){
	web3=new Web3(web3.currentProvider);
}else{
	web3 = new Web3(eth_url);
}
 
console.log("正在请求:"+eth_url);

let source=fs.readFileSync("./ccc.sol","utf8");
let cacl=solc.compile(source,1);
let abi= JSON.parse(cacl.contracts[':CCC'].interface);

console.log("当前abi解析:"+JSON.stringify(abi))
let bytecode=cacl.contracts[':CCC'].bytecode;		//合约二进制码
var temp='0x'+bytecode;

//var gasEstimate = web3.eth.estimateGas({to:web3.eth.accounts[0],data:temp}); //估算gas

console.log("当前合约二进制:"+JSON.stringify(temp))

web3.eth.getAccounts().then(data=>{
	web3.eth.personal.unlockAccount(data[0]).then(openAccountState=>{
		if(openAccountState){
			console.log("开户状态:"+openAccountState);
			var rsContract=new web3.eth.Contract(abi).deploy({
				data:'0x'+bytecode,
				arguments:[company,email,remark,enode],	//传递构造函数的参数
			}).send({
				from:data[0],
				gas: gas,
				gasPrice:'30000000000000'
			},function(error,transactionHash){
				console.log("send回调");
				console.log("error:"+error);
				console.log("send transactionHash:"+transactionHash);
			})
			.on('error', function(error){ console.error(error) })
			.then(function(newContractInstance){
				var newContractAddress=newContractInstance.options.address
				console.log("新合约地址:"+newContractAddress);
 
				web3.eth.getBlockNumber().then(blockNum=>{
					console.log("当前块号："+blockNum);
					web3.eth.getBlock(blockNum).then(data=>{
						console.log("当前块信息：");
						console.log(data);
					})
				});
 
			});
			
		}
	});
});

