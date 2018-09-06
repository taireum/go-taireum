const router = require('koa-router')();
const C = require('./../lib/CCC');
const fs   = require('fs');



router.prefix('/api');
const c = new C;

router.get('/contrac', function(ctx, next){
  var data = fs.readFileSync('lib/contractaddress.json', 'utf-8');
  person = JSON.parse(data);//将字符串转换为json对象

  ctx.body =  [ person.contractaddress]
})
router.get('/enode', function (ctx, next){
  var data = fs.readFileSync('lib/member.json', 'utf-8');
  person = JSON.parse(data);//将字符串转换为json对象

  ctx.body=person

})

router.get('/mine', function(ctx, next){
  var data = fs.readFileSync('lib/mine.json', 'utf-8');

  person = JSON.parse(data);//将字符串转换为json对象

  ctx.body=person})
router.get('/company', function(ctx, next){
  var data = fs.readFileSync('lib/company.json', 'utf-8');
  person = JSON.parse(data);//将字符串转换为json对象

  ctx.body=person
 
})

router.get('/coinbase', async (ctx, next) =>{
  ctx.body = await c.coinbase();
})

// response rpc whitelist
router.get('/rpc', function (ctx, next) {
    var data = fs.readFileSync('lib/rpc.json', 'utf-8');
    ipList = JSON.parse(data);//将字符串转换为json对象

    ctx.body = ipList
})

router.post('/v1', async (ctx, next) => {
 
    try{
        const {source,method,argv} = ctx.request.body;
        if(source=="ccc"){
              if(method=="add"){
                //添加公司
                const {_from, _companyname, _email, _remark, _enode,_address}=argv
                ctx.body = await c.add_companys(_from, _companyname, _email, _remark, _enode,_address);
              }else if(method=="update"){
                //更新公司
                const {_from ,_companyid, _email, _remark, _enode, _stat}=argv
                ctx.body = await c.update_companys(_from ,_companyid, _email, _remark, _enode, _stat);
              } else if(method=="vote"){
                //poa投票
                const {_from ,_fromcompanyid,_tocompanyid}=argv
                ctx.body = await c.vote(_from ,_fromcompanyid,_tocompanyid);
              }else if(method=="minevote"){
                //挖矿投票
                const {_from ,_fromcompanyid,_tocompanyid}=argv
                ctx.body = await c.votemine(_from ,_fromcompanyid,_tocompanyid);
              }else if(method=="check"){
                //检查company是否poa
                const {_from ,_companyid}=argv
                ctx.body = await c.checkmember(_from ,_companyid);
              }else if(method=="acheck"){
                //检查账号
                const {_from ,_account}=argv
                ctx.body = await c.checkmemberowner(_from ,_account);
              } else if(method=="get"){
                //获取
                const {_from ,_companyid}=argv
                ctx.body = await c.getcompany(_from ,_companyid);
              }else if(method=="setup"){
                //初始化
                const {_company, _email, _remark, _chainid,_datadir,_rpcport,_eth_url,_networkid}=argv
                ctx.body = await c.init_new(_company, _email, _remark, _chainid,_datadir,_rpcport,_eth_url,_networkid);
              }else{
                ctx.body={"code": 400,"message": "非法的请求method","detail": method}
              }

              
        }else{
          ctx.body={"code": 400,"message": "请求错误","detail": source}
        }
      }catch (err) {
        ctx.body = {'code': 400,message:"请求出错",'detail': 'error:' + err.stack};
    }

});




module.exports = router;
