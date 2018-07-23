const Web3 = require('web3');
const config = require('./config');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(config.eth_url);
}


const MyContract = new web3.eth.Contract(config.abi, config.contractaddress);


class Vote {

    async isMember(_from, _companyid) {
        try {
            const isMember_stat = await MyContract.methods.isMember(_companyid).call({
                from: _from
            });
            console.log(isMember_stat)
            if (isMember_stat == true) {
                return true;
            } else {
                return false;
            }
        } catch (err) {
            return false;
        }
    }

    async CheckisMember(_from, _companyid) {
        try {
            const isMember_stat = await MyContract.methods.isMember(_companyid).call({
                from: _from
            });
            if (isMember_stat == true) {
                return {
                    code: 200,
                    message: '查询成功' + _companyid,
                    detail: true
                };

            } else {
                return {
                    code: 200,
                    message: '查询成功' + _companyid,
                    detail: false
                };
            }
        } catch (err) {
            return {
                code: 400,
                message: '查询错误' + _companyid,
                detail: err
            };
        }
    }



    async CompanyVote(_from, _fromcompany, _tocompany) {
        try {
            const Vote_from_able = await this.isMember(_from, _fromcompany);

            const Vote_to_able = await this.isMember(_from, _tocompany);
            console.log(Vote_from_able, Vote_to_able)
            if (Vote_from_able == true && Vote_to_able == false) {
                try {
                    console.log(_from, _fromcompany, _tocompany)
                    const Vote_stat = await MyContract.methods.Vote(_fromcompany, _tocompany).send({
                        from: _from,
                        gas: config.gas,
                        gasPrice: config.gasPrice
                    });
                    return {
                        code: 200,
                        message: '投票成功',
                        detail: '交易hash:' + Vote_stat.transactionHash
                    };
                } catch (err) {
                    return {
                        code: 400,
                        'message': '拒绝投票',
                        'detail': err
                    };
                }
            } else {
                return {
                    code: 400,
                    message: "投票出错",
                    'detail': _fromcompany + "=>" + _tocompany
                };
            }
        } catch (err) {
            return {
                'code': 400,
                message: '投票源和被投票参数出错',
                'detail': 'error:' + err
            };
        }
    }




}
module.exports = Vote;