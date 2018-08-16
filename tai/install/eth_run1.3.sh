#!/bin/bash
rpm_list="epel-release git golang  vim "
if id |grep "^uid=0(root)">/dev/null ;then
echo User is root
else
 exit 2
fi

for x in $rpm_list
do
  rpm -aq| grep $x
   if [ $? -ne 0 ] 
   then
     yum install $x -y
   else
     echo "$x is install"
   fi
done

cd /tmp/
tar zxcv go-ethereum.tgz
cd  go-ethereum
build/env.sh go run build/ci.go install

cd tai/install
\cp  -a * /opt
cd /opt
/tmp/go-ethereum/build/bin/geth init genesis.json
nohup /tmp/go-ethereum/build/bin/geth --datadir ethdata --networkid 1108 &
