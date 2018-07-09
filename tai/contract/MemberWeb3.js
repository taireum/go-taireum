let Web3 = require('web3');
let web3;

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
    console.log('undefined');
} else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}


let b = web3.eth.getBalance("0x98bb538928f4b0ce5d7b4b61575d50b7f6af767b");
b.then(function (x){console.log(x)});

let version = web3.version.api;
console.log(version);

let abi = [{"constant":true,"inputs":[{"name":"enode","type":"string"}],"name":"isMember","outputs":[{"name":"result","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"enode","type":"string"}],"name":"register","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"enode","type":"string"}],"name":"vote","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"enode","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"enode","type":"string"},{"indexed":false,"name":"voter","type":"address"}],"name":"Vote","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"enode","type":"string"},{"indexed":false,"name":"register","type":"address"}],"name":"Register","type":"event"}];
let address = "0x632ee4a878112b7e152aa59bb94cfc8703f3857f";
var member = web3.eth.contract(abi).at(address);

let isMember = member.isMember.call("cde");
console.log(isMember);