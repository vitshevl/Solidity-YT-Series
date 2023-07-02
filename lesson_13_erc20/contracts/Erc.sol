// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint totalTokens;
    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;

    function name() external view returns(string memory) {
        return _name;
    }

    function symbol() external view returns(string memory) {
        return _symbol;
    }

    function decimals() external pure returns(uint) {
        return 18;// 1 token = 1 wei
    }

    function totalSupply() external view returns(uint) {
        return totalTokens;
    }

    modifier enoughTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "not enough tokens!");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not enough tokens!");
        _;
    }
    constructor (string memory name_, string memory symbol_, uint initialSupply, address shop) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function balanceOf(address account) public view returns(uint) {
        return balances[account];
    }

    function transfer(address to, uint amount) external enoughTokens (msg.sender, amount) {
        _beforeTokenTransfer(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);

    }

    function mint(uint amount, address shop) public onlyOwner {
        _beforeTokenTransfer(address(0), shop, amount);
        balances[shop] += amount;
        totalTokens += amount;
        emit Transfer(address(0), shop, amount);
    }

    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        totalTokens -= amount;
    }

    function allowance (address _owner, address spender) public view returns(uint) {
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) public {
        _approve(msg.sender, spender, amount);
    }

    function _approve (address sender, address spender, uint amount) internal virtual {
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }

     function transferFrom (address sender, address recipient, uint amount) public enoughTokens(sender,amount) {
         _beforeTokenTransfer(sender, recipient, amount);
         //require(allowances[sender][recipient] >= amount, "check allowance!");
         allowances[sender][msg.sender] -= amount; //error, если разрешенных токенов меньше, чем пытаются списать

         balances[sender] -= amount;
         balances[recipient] -= amount;
         emit Transfer(sender, recipient, amount);
     }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal virtual {}
}

 contract EPAMToken is ERC20 {
     constructor(address shop) ERC20("EPAMToken", "EPAM", 20, shop) {}
 }

 contract EPAMShop {
     IERC20 public token;
     address payable public owner;
     event Bought(uint _amount, address indexed _buyer);
     event Sold(uint _amount, address indexed _seller);

     constructor() {
         token = new EPAMToken(address(this));
         owner = payable (msg.sender);
     }

     modifier onlyOwner() {
        require(msg.sender == owner, "not enough tokens!");
        _;
    }

    function sell(uint _amountToSell) external {
        require(
            _amountToSell > 0 &&
            token.balanceOf(msg.sender) >= _amountToSell,
            "incorrect amount!"
        );

        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "check allowance!");

        token.transferFrom(msg.sender, address(this), _amountToSell);

        payable(msg.sender).transfer(_amountToSell);

        //call - низкоуровненый вызов, в котором мы можем отправлять данные, а также просто деньги. 
        //Здесь можем указать сколько денег отправляем и лимит по газу. Лимит по газу важен когда функция receive много что делает
        // Для этого выстовляется лимит, чтобы много не заплатить. В самом вызове можно указать {value: 100, gasLimit:...}

        //Если мы знаем, что receive ничего не делает, то мы можем использовать transfer или send.

        //transfer- функция, котороая просто принимает какое-то количество денежных средств. И она резервирует 2300 gas (лимит). Если не удалось, т.е
        // на стороннем смарт контракте произошла ошибка, тоэта фнкция породит ошибку и вся транзакция будет откачена и будет брошена ошибка Exception

        //send тоже самое, что и transfer, такой же лимит. Но если она не срабатывает, то она не бросит ошибку, она просто вернет логичское false.

        emit Sold(_amountToSell, msg.sender);
    }
    
    receive() external payable {
        uint tokensToBuy = msg.value; // 1 wei = 1 token
        require(tokensToBuy > 0, "not enough funds!"); 

        require(tokenBalance() >= tokensToBuy, "not enough tokens!");

        token.transfer(msg.sender, tokensToBuy);
        emit Bought(tokensToBuy, msg.sender);
    }

    function tokenBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }
 }