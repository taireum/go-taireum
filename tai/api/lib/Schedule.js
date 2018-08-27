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
var schedule = require("node-schedule");
var rule = new schedule.RecurrenceRule();
let fs   = require('fs');
var exec = require('child_process').exec;


const Web3 = require('web3');
const config = require('./config');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(config.eth_url);
}

var times1    = [1,6,11,16,21,26,31,36,41,46,51,56];
rule.second  = times1;
var j = schedule.scheduleJob(rule, function(){
    exec("node lib/company_json.js ; node lib/member_json.js;node lib/mine_json.js", function(err,stdout,stderr){
        if(err) {
            console.log(stderr);
        } else {
            
            console.log(stdout);
        }
    });


}

) 

