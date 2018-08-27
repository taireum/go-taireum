/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
let fs   = require('fs');
const Web3 = require('web3');
const config = require('./config');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(config.eth_url);
}
 
(async()=>{  
    var a=await web3.eth.getBlock(10);
    console.log(a);
    str={"contractaddress":a.miner};
	str1=JSON.stringify(str)
	console.log("正在写入合约地址 lib/contractaddress.json "+str1)
	fs.writeFile('lib/contractaddress.json',str1,function(err){
	if(err){
		console.error(err.stack);
		}
		console.log('----------新增成功-------------');
	})
				
    
})()

