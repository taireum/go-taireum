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
geth="/opt/go-ethereum/build/bin/geth"
rm -rf $1/geth
rm -rf $1/keystore
mkdir -p $1

echo $2>passwd
(sleep 4;echo "$2"; 
sleep 4;echo "$2";
)| $geth --datadir $1 account new
address=`ls -al $1/keystore/UT*|awk -F '-' '{print $NF}'`
sed  "s/address/$address/g" init.json >genesis.json
sed -i "s/30488/$4/g"  genesis.json
$geth --datadir $1 init genesis.json
echo "[\"0x$address\"]" >mine.json
sleep 2;
\cp passwd /tmp
echo "$geth  --datadir $1 --mine --unlock \"0x$address\" --password ./passwd --etherbase   \"0x$address\"  --rpc  --rpcport $3 --rpcapi=\"api,miner,db,eth,net,web3,personal,admin\"  --networkid $5 ">/tmp/run.sh
chmod 777 /tmp/run.sh
echo "启动进程"
 $geth  --datadir $1   --unlock "0x$address" --password ./passwd --etherbase   "0x$address"  --mine --rpc  --rpcport $3 --rpcapi="api,miner,db,eth,net,web3,personal,admin"  --networkid $5>/tmp/geth.log&

#sleep 5
#echo "启动挖矿"
#(echo "miner.start(); admin.sleepBlocks(1); miner.stop()"; )|$geth  --unlock "0x$address" --password ./passwd --etherbase   "0x$address" attach ipc:$1/geth.ipc
 
