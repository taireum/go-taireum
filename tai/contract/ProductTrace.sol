pragma solidity 0.4.24;

contract ProductTrace {
    
    address _owner;
    
    constructor() public {
        _owner = msg.sender;
    }
   
    struct Operator {
        address addr;           //地址
        string name;            //名称
        uint role;              //角色：1供应商 2总公司 3分销商 4客户 
    }
    
    struct Product{
        bytes4 id;              //商品ID，例如0x00000001
        string description;     //商品描述
        address owner;          //商品拥有者地址
        uint state;             //商品状态
        mapping(uint => Operator) operators;
    }
    
    mapping(bytes4 => Product) public products;
    mapping(address => Operator) public operators;
    
    function register(address _addr,string _name,uint _role) public returns(bool){
        require(msg.sender == _owner, "only contract owner can do this");
        operators[_addr] = Operator({addr:_addr,name:_name,role:_role});
        return true;
    }
    
    function addProduct(bytes4 _id,string _description) public returns(bool) {
        require(operators[msg.sender].role == 1, "only provider can add product");
        require(products[_id].state == uint(0), "product already added");
        products[_id] = Product({id:_id, description:_description, owner:msg.sender, state:1});
        products[_id].operators[1] = operators[msg.sender];
        return true;
    }

    //1 sell to 2, 2 sell to 3, 3 sell to 4
    function sellProduct(bytes4 _id,address _addr) public returns(bool) {
        require(products[_id].state == uint(1), "product isn't exist");
        require(products[_id].owner == msg.sender, "you don't own this product");
        require(operators[msg.sender].role == operators[_addr].role - 1, "can't sell to this operator");
        products[_id].owner = _addr;
        products[_id].operators[operators[_addr].role] = operators[_addr];
        return true;
    }

    //4 return to 3, 3return to 2, 2 return to 1
    function returnProduct(bytes4 _id) public returns(bool) {
        require(operators[msg.sender].role != 1, "provider can't return product");
        require(products[_id].state == uint(1), "product isn't exist");
        require(products[_id].owner == msg.sender, "you don't own this product");
        products[_id].owner = products[_id].operators[operators[msg.sender].role - 1].addr;
        delete products[_id].operators[operators[msg.sender].role];
        return true;
    }

    function queryProduct(bytes4 _id, uint _role) public view returns(address) {
        return products[_id].operators[_role].addr;
    }
    
}