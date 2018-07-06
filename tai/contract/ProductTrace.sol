pragma solidity 0.4.24;
//合约版本
contract ProductTrace {
    //合约人账号地址
    address _owner;
    //构造函数
    constructor() public {
        _owner = msg.sender;
       //将部署合约的地址作为合约拥有者
    }
    //构建角色数据结构
    struct Operator {
        address addr;           //地址
        string name;            //名称
        uint role;              //角色：1供应商 2总公司 3分销商 4客户 
    }
    //构建产品数据结构
    struct Product{
        bytes4 id;              //商品ID，例如0x00000001
        string description;     //商品描述
        address owner;          //商品拥有者地址
        uint state;             //商品状态
        mapping(uint => Operator) operators;
    }
    //字典化产品 
    mapping(bytes4 => Product) public products;
    mapping(address => Operator) public operators;
    //注册角色，需要输入 角色地址/角色命名/角色代码
    // 返回布尔值
    function register(address _addr,string _name,uint _role) public returns(bool){
        //用于中断调用者地址合法性
        require(msg.sender == _owner, "only contract owner can do this");
        //写入数据
        operators[_addr] = Operator({addr:_addr,name:_name,role:_role});
        return true;
    }
    //增加产品函数 输入 id/描述
    //返回布尔值
    function addProduct(bytes4 _id,string _description) public returns(bool) {
        //中断 判断是否为供应商
        require(operators[msg.sender].role == 1, "only provider can add product");
        //中断 判断商品状态 存在1和0 两种状态
        require(products[_id].state == uint(0), "product already added");
        //写入 产品id/拥有者/状态
        products[_id] = Product({id:_id, description:_description, owner:msg.sender, state:1});
        //写入 产品角色类型
        products[_id].operators[1] = operators[msg.sender];
        return true;
    }

    //1 sell to 2, 2 sell to 3, 3 sell to 4
    //出售函数 需要输入id 交易对象地址
    function sellProduct(bytes4 _id,address _addr) public returns(bool) {
        //中断 判断 产品是否存在
        require(products[_id].state == uint(1), "product isn't exist");
        //中断 判断交易产品该地址是否为合约拥有者
        require(products[_id].owner == msg.sender, "you don't own this product");
        //中断 判断追溯角色级别
        require(operators[msg.sender].role == operators[_addr].role - 1, "can't sell to this operator");
        products[_id].owner = _addr;
        //成功交易 变更地址
        products[_id].operators[operators[_addr].role] = operators[_addr];
        //成功交易 角色变更
        return true;
    }
    //产品上级追溯函数
    //4 return to 3, 3return to 2, 2 return to 1
    function returnProduct(bytes4 _id) public returns(bool) {
       //中断 判断 角色
        require(operators[msg.sender].role != 1, "provider can't return product");
        //中断 判断产品状态
        require(products[_id].state == uint(1), "product isn't exist");
        //判断 产品 拥有者 地址 
        require(products[_id].owner == msg.sender, "you don't own this product");
        // 现在产品 拥有者地址
        products[_id].owner = products[_id].operators[operators[msg.sender].role - 1].addr;
        delete products[_id].operators[operators[msg.sender].role];
        return true;
    }

    function queryProduct(bytes4 _id, uint _role) public view returns(address) {
        return products[_id].operators[_role].addr;
    }
    
}
