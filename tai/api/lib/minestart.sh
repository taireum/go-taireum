geth="/opt/go-ethereum/build/bin/geth"
echo "启动挖矿"
(echo "miner.start()"; )|$geth  attach ipc:$1/geth.ipc
 
