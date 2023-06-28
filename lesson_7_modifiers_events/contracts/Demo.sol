// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    //require - принимает условие и еще один аргумент (сообщение об ошибке)
    //revert - требуестся написать условие самостоятельно с помощью if. Принимает только сообщение об ошибке
    //assert - выпадает ошибка типа Panic (все плохо), если условие не сработало. И ничего указать нельзя
    address owner;

    event Paid (address indexed _from, uint _amount, uint _timestamp); //indexed - индексация полей для ускорения поиска

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        pay();
    }

    function pay() public payable {
        emit Paid(msg.sender, msg.value, block.timestamp); // произойдет событие, которое попадет в журнал событий. Можем подписаться на этот журнал событий сторонним сервисом
        
    }
    
    modifier onlyOwner(address _to){
        require(msg.sender == owner, "you are not an owner!");
        require(_to !=address(0), "incorrect address!"); //проверяем, что не является адресом по умолчанию
        _; //выходим из модификатора и переходим к телу функции
    }

    function withdraw (address payable _to) external onlyOwner(_to) {
        // Panic
        //assert( msg.sender == owner);
        //Error
        // require(msg.sender == owner, "you are not an owner!");
        // if(msg.sender != owner){
        //     revert("you are not an owner!");
        // }
        _to.transfer(address(this).balance);
    }


}