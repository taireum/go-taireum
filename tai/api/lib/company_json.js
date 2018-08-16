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
 
    const MyContract = new web3.eth.Contract(config.abi, config.contractaddress);
    (async()=>{  
        const sum= await MyContract.methods.ShowSum().call({from: config.account});
        var array = [];　//创建一个数组  

        for(j = 1; j <=sum; j++) {
                const getcompany_stat=await MyContract.methods.ShowCompany(j).call({from: config.account});
                temp={"companyid":j,"companyname":getcompany_stat[0],"email":getcompany_stat[1],"remark":getcompany_stat[2],"owner":getcompany_stat[3],"enode":getcompany_stat[4],"stat":getcompany_stat[5]};
                array.push(temp);

            }
        
        
        person=JSON.stringify( array );

        fs.writeFile('/opt/ccc_rest/lib/company.json',person,function(err){
            if(err){
                console.error(err);
            }
            console.log('----------创建公司列表成功-------------');
        })
        //str=JSON.stringify(person)
    })()

