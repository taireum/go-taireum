## **前言** 
我们在以太坊的代码基础上，进行了若干代码模块的重构与开发。
- 重构了以太坊的 P2P 网络通信模块，使其需要进行安全验证得到联盟许可才能加入新节点进入当前 联盟链网络。
-  重构了以太坊的共识算法，只有经过联盟成员认证授权的节点才能打包区块，打包节点按序轮流打 包，无需算力证明。
 
- 开发了联盟共识控制台(Consortium Consensus Console)CCC，方便对联盟链进行运维管理，联盟 链用户只需要在 web console 上就可以安装部署联盟链节点，投票选举新的联盟成员和区块授权打包 节点。

## **编译和安装**
环境准备

golang 最新 https://www.golangtc.com/download

geth客户端编译

    git clone https://github.com/itisaid/go-ethereum.git
    cd go-ethereum
    build/env.sh go run build/ci.go install

CCC控制台编译启动

在编译之前需要安装相关node.
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
    cd tai/api/;nvm install v8.9 && npm install && node bin/www &
    cd client;npm install && npm dev run




