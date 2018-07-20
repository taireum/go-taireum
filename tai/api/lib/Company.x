const Web3 = require('web3');
const config = require('./config');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(config.eth_url);
}

// 交易发起者

const MyContract = new web3.eth.Contract(config.abi, config.contractaddress);


class Company {
    async add_companys(_from, _companyname, _email, _remark) {
        try {
            const companyexistence = await MyContract.methods.ShowCompanynameExist(_companyname).call({
                from: _from
            });
            if (companyexistence != true) {
                try {
                    const add_companys_stat = await MyContract.methods.AddCompany(_companyname, _email, _remark).send({
                        from: _from,
                        gas: config.gas,
                        gasPrice: config.gasPrice
                    });
                    return {
                        'code': 200,
                        message: '增加公司成功',
                        detail: '交易hash:' + add_companys_stat.transactionHash
                    };
                } catch (err) {
                    return {
                        'code': 400,
                        'message': 'eth拒绝交易',
                        detail: 'error:' + err
                    };
                }
            } else {
                return {
                    'code': 400,
                    message: `${_companyname}已经存在`,
                    detail: _companyname
                };
            }
        } catch (err) {
            return {
                'code': 400,
                message: 'eth拒绝',
                'detail': 'error:' + err.stack
            };
        }
    }

    async del_companys(_from, _companyid) {
        try{
            const companyexistence = await MyContract.methods.ShowCompanyidExist(_companyid).call({from: _from});
            if (companyexistence == true) {
                try {
                    const del_companys_stat = await MyContract.methods.DelCompany(_companyid).send({from: _from,gas: config.gas,gasPrice: config.gasPrice
                    });
                    return {code: 200,message: '删除公司成功',detail: '交易hash:' + del_companys_stat.transactionHash};
                } catch (err) {
                    return {code: 400,'message': 'eth拒绝交易','detail': '发起者不是该公司的属主:' + err};
                }
            } else {
                return {code: 400,message: '公司id' + _companyid + '不存在','detail': _companyid};
            }
        } catch (err) {
            return {'code': 400,message: 'eth拒绝','detail': 'error:' + err};
        }
    }



    async update_companys(_from,companyid,email,remark,stat) {
        try{
            const companyexistence = await MyContract.methods.ShowCompanyidExist(companyid).call({from: _from});
            if (companyexistence == true) {
                try {
                    const update_companys_stat = await MyContract.methods.UpdateCompany(companyid,email,remark,stat).send({from: _from,gas: config.gas,gasPrice: config.gasPrice
                    });
                    return {code: 200,message: '更新公司成功',detail: '交易hash:' + update_companys_stat.transactionHash};
                } catch (err) {
                    return {code: 400,'message': 'eth拒绝交易','detail': '出错:' + err};
                }
            } else {
                return {code: 400,message: '公司id' + companyid + '不存在','detail': companyid};
            }
        } catch (err) {
            return {'code': 400,message: 'eth拒绝','detail': 'error:' + err};
        }
    }

    async get_companys(_from,companyid) {
        try{
            const companyexistence = await MyContract.methods.ShowCompanyidExist(companyid).call({from: _from});
            if (companyexistence == true) {
                try {
                    const get_companys_stat = await MyContract.methods.ShowCompany(companyid).call({from: _from},);
                    return {code: 200,message: '查询'+companyid+'成功',detail: get_companys_stat};
                } catch (err) {
                    return {code: 400,'message': 'eth拒绝交易','detail': '出错:' + err};
                }
            } else {
                return {code: 400,message: '公司id' + companyid + '不存在','detail': companyid};
            }
        } catch (err) {
            return {'code': 400,message: 'eth拒绝','detail': 'error:' + err};
        }
    }
    async get_all_companys(_from) {
        var Arr=[];
        const get_companys_stat = await MyContract.methods.CompanySum().call({from: _from},);
        for(var i=1;i<99999999;i++){

            try{
                const temp=await MyContract.methods.ShowCompany(i).call({from: _from},);
                console.log(temp)
                Arr.push(temp)
            }catch (err) {
            
            }
        }
        return {code: 200,message: '获取所有企业成功',detail: Arr};


        
    }

}
module.exports = Company;