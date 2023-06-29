// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";


abstract contract Balances is Ownable{
    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }
    function withdraw(address payable  _to) public override virtual onlyOwner {
       _to.transfer(getBalance());
   }
}

// contract MyContract is Ownable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), Balances{} - Можно передавать значение в конструктор прямо в сигнатуре 

contract MyContract is Ownable, Balances{ // Порядок важен. Хотя можно прописать просто Balances, т.к вместе с ним унаследуется все свойства Ownable
    constructor(address _owner) Ownable (msg.sender) {

    }

    function withdraw(address payable  _to) public override(Ownable, Balances) onlyOwner {
       //Balances.withdraw(_to);
       //Owner.withdraw(_to);
       require(_to != address(0), "zero addr");
       super.withdraw(_to); // Здесь вызовется первый по иерархии, т.е Balances
   }   
}