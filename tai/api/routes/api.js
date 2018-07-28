const router = require('koa-router')();
const Company = require('./../lib/Company');
const Enode = require('./../lib/Enode');
const Vote= require('./../lib/Vote');



router.prefix('/api');
const c = new Company;
const e = new Enode;
const v = new Vote;


router.post('/v1', async (ctx, next) => {
 
    try{
        const {source,method,argv} = ctx.request.body;
        if(source=="company"){
              if(method=="add"){
                //添加公司
                const {from, companyname, email, remark}=argv
                ctx.body = await c.add_companys(from, companyname, email, remark);
              } else if (method=="del"){
                //删除公司
                const {from,companyid}=argv
                ctx.body = await c.del_companys(from,companyid);

              }else if (method=="update"){
                //更新公司
                const {from,companyid,email,remark,stat}=argv;
                ctx.body = await c.update_companys(from,companyid,email,remark,stat);

              }else if (method=="get"){
                //查询单个公司
                const {from,companyid}=argv;
                ctx.body = await c.get_companys(from,companyid);

              }else if (method=="getall"){
                //获取所有公司
                const {from}=argv;
                ctx.body = await c.get_all_companys(from);

              }else{
                ctx.body={"code": 400,"message": "非法的请求method","detail": method}
              }

              
        }else if (source=="enode"){
              if(method=="add"){
                //添加enode
                const {from, companyid,enodename}=argv
                ctx.body = await e.add_enode(from, companyid,enodename);
              }else if (method=="del"){
                //删除enode
                const {from,enodeid}=argv;
                ctx.body = await e.del_enode(from,enodeid);

              }else if (method=="update"){
                //更新enode
                const {from,enodeid,stat}=argv;
                ctx.body = await e.update_enode(from,enodeid,stat);

              }else if (method=="get"){
                //更新enode
                const {from,enodeid}=argv;
                ctx.body = await e.get_enode(from,enodeid);

              }else{
                ctx.body={"code": 400,"message": "非法的请求method","detail": method}
              }


        }else if (source=="vote"){
          if(method=="vote"){
            //添加enode
            const {from, fromcompany,tocompany}=argv
            ctx.body = await v.CompanyVote(from, fromcompany,tocompany);
          
          }else if (method=="check"){
            //更新enode
            const {from,companyid}=argv;
            ctx.body = await v.CheckisMember(from,companyid);

          }else{
            ctx.body={"code": 400,"message": "非法的请求method","detail": method}
          }


    }else{
          ctx.body={"code": 400,"message": "非法的请求对象","detail": source}
        }
      }catch (err) {
        ctx.body = {'code': 400,message:"请求出错",'detail': 'error:' + err.stack};
    }

  //ctx.body = await c.add_companys(from, companyname, email, remark);
});


module.exports = router;