const Web3 = require('web3');
const config = require('./config');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(config.eth_url);
}


const MyContract = new web3.eth.Contract(config.abi, config.contractaddress);


class Enode {

    async add_enode(_from, _companyid, _enodename) {
        try {
            const companyexistence = await MyContract.methods.ShowCompanyidExist(_companyid).call({
                from: _from
            });
            if (companyexistence == true) {
                try {
                    const add_enode_stat = await MyContract.methods.AddEnode(_companyid, _enodename).send({
                        from: _from,
                        gas: config.gas,
                        gasPrice: config.gasPrice
                    });
                    return {
                        code: 200,
                        message: '新增enode成功',
                        detail: '交易hash:' + add_enode_stat.transactionHash
                    };
                } catch (err) {
                    return {
                        code: 400,
                        'message': 'eth拒绝交易',
                        'detail': '发起者不是该公司的属主或者enode已存在:' + err
                    };
                }
            } else {
                return {
                    code: 400,
                    message: '公司id' + _companyid + '不存在',
                    'detail': _companyid
                };
            }
        } catch (err) {
            return {
                'code': 400,
                message: 'eth拒绝',
                'detail': 'error:' + err
            };
        }
    }



    async del_enode(_from, _enodeid) {
        try {
            const enodeexistence = await MyContract.methods.ShowEnodeExist(_enodeid).call({
                from: _from
            });
            if (enodeexistence == true) {
                try {
                    const del_enode_stat = await MyContract.methods.DelEnode(_enodeid).send({
                        from: _from,
                        gas: config.gas,
                        gasPrice: config.gasPrice
                    });
                    return {
                        code: 200,
                        message: '删除enode成功',
                        detail: '交易hash:' + del_enode_stat.transactionHash
                    };
                } catch (err) {
                    return {
                        code: 400,
                        'message': 'eth拒绝交易',
                        'detail': '发起者不是该enode的属主:' + err
                    };
                }
            } else {
                return {
                    code: 400,
                    message: 'enodeid' + _enodeid + '不存在',
                    'detail': _enodeid
                };
            }
        } catch (err) {
            return {
                'code': 400,
                message: 'eth拒绝',
                'detail': 'error:' + err
            };
        }
    }

    async update_enode(_from, _enodeid, _stat) {
        try {
            const enodeexistence = await MyContract.methods.ShowEnodeExist(_enodeid).call({
                from: _from
            });
            if (enodeexistence == true) {
                try {
                    const update_enode_stat = await MyContract.methods.UpdateEnode(_enodeid, _stat).send({
                        from: _from,
                        gas: config.gas,
                        gasPrice: config.gasPrice
                    });
                    return {
                        code: 200,
                        message: '更新enode成功',
                        detail: '交易hash:' + update_enode_stat.transactionHash
                    };
                } catch (err) {
                    return {
                        code: 400,
                        'message': 'eth拒绝交易',
                        'detail': '发起者不是该enode的属主:' + err
                    };
                }
            } else {
                return {
                    code: 400,
                    message: 'enodeid' + _enodeid + '不存在',
                    'detail': _enodeid
                };
            }
        } catch (err) {
            return {
                'code': 400,
                message: 'eth拒绝',
                'detail': 'error:' + err
            };
        }
    }


    async get_enode(_from, _enodeid) {
        try {
            const enodeexistence = await MyContract.methods.ShowEnodeExist(_enodeid).call({
                from: _from
            });
            if (enodeexistence == true) {
                try {
                    const get_enode_stat = await MyContract.methods.ShowEnode(_enodeid).call({
                        from: _from
                    });
                    return {
                        code: 200,
                        message: '获取enode成功',
                        detail: get_enode_stat
                    };
                } catch (err) {
                    return {
                        code: 400,
                        'message': 'eth拒绝交易',
                        'detail': err
                    };
                }
            } else {
                return {
                    code: 400,
                    message: 'enodeid' + _enodeid + '不存在',
                    'detail': _enodeid
                };
            }
        } catch (err) {
            return {
                'code': 400,
                message: 'eth拒绝',
                'detail': 'error:' + err
            };
        }
    }



}
module.exports = Enode;