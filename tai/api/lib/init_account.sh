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
echo "$geth  --nodiscover --datadir $1 --mine --unlock \"0x$address\" --password ./passwd --etherbase   \"0x$address\"  --rpc  --rpcport $3 --rpcapi=\"api,miner,db,eth,net,web3,personal,admin\"  --networkid $5 ">/tmp/run.sh
chmod 777 /tmp/run.sh
echo "启动进程"
 $geth --mine  --nodiscover --datadir $1   --unlock "0x$address" --password ./passwd --etherbase   "0x$address"   --rpc  --rpcport $3 --rpcapi="api,miner,db,eth,net,web3,personal,admin"  --networkid $5>/tmp/geth.log&

##sleep 5
#echo "启动挖矿"
#(echo "miner.start(); admin.sleepBlocks(1); miner.stop()"; )|$geth  attach ipc:$1/geth.ipc
 
