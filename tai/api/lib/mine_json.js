let fs   = require('fs');

const Web3 = require('web3');
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
const config = require('./config');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(config.eth_url);
}
 
const MyContract = new web3.eth.Contract(config.abi, config.contractaddress);
    (async()=>{  
        const sum= await MyContract.methods.ShowSum().call({from: config.account});
        var array = [];　//创建一个数组  

        for(j = 1; j <=sum; j++) {
            const checkmember_stat=await MyContract.methods.isMemberMine(j).call({from: config.account});
            if (checkmember_stat == true){
                const getcompany_stat=await MyContract.methods.ShowCompany(j).call({from: config.account});
            
                array.push(getcompany_stat[3]);

            }
        }
        
        person=JSON.stringify( array );

        fs.writeFile('lib/mine.json',person,function(err){
            if(err){
                console.error(err);
            }
            console.log('----------创建mine列表成功-------------');
        })
        //str=JSON.stringify(person)
        
})()
