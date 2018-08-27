geth="/opt/go-ethereum/build/bin/geth"
rm -rf /tmp/geth
rm -rf /tmp/geth
mkdir -p /tmp/geth

echo $2>passwd
(sleep 4;echo "$2"; 
sleep 4;echo "$2";
)| $geth --datadir /tmp/geth account new
address=`ls -al /tmp/geth/keystore/UT*|awk -F '-' '{print $NF}'`
sed  "s/address/$address/g" init.json >genesis.json
sed -i "s/30488/$4/g"  genesis.json
$geth --datadir /tmp/geth init genesis.json
echo "[\"0x$address\"]" >mine.json
sleep 2;
\cp passwd /tmp/geth
echo "$geth --bootnodes \"$1\"  --nodiscover --datadir /tmp/geth  --unlock \"0x$address\" --password ./passwd --etherbase   \"0x$address\"  --rpc  --rpcport 8545 --rpcapi=\"api,miner,db,eth,net,web3,personal,admin\"  --networkid 99 ">/tmp/geth/run.sh
chmod 777 /tmp/geth/run.sh
echo "启动进程"
 $geth   --bootnodes "$1"  --nodiscover --datadir /tmp/geth   --unlock "0x$address" --password ./passwd --etherbase   "0x$address"   --rpc  --rpcport 8545 --rpcapi="api,miner,db,eth,net,web3,personal,admin"  --networkid 99>/tmp/geth.log&

##sleep 5
#echo "启动挖矿"
#(echo "miner.start(); admin.sleepBlocks(1); miner.stop()"; )|$geth  attach ipc:$1/geth.ipc
 
