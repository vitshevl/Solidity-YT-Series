// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Demo {
    //public - доступна для всех
    //external- вызов только извне контракта
    //internal - вызов только в контракте и наследникахх
    //private - вызов только внутри контракта (наследники не могут)

    //view - может читать состояние
    //pure - не может читать состояние
    string message = "hello"; //state
    uint public balance;
    
    // функция для зачисления денег, которые прилетают на адресс смарт-контракта
    receive() external payable {}


    // функция вызывается тогда, когда относительно смарт-контракта была вызвана транзакция с неизвестным именем функции
    fallback() external payable {}

    //payable - принимает денежные средства. Зачисляется на баланс смарт-контракта
    function pay() external payable{
        balance += msg.value; //- эта переменная опциональная, деньги в любом случае поступят на смарт контракт 
    }

    //transaction - вызывается через транзакцию, т.к модифицирует данные
    function setMessage(string memory newMessage) external{
        message = newMessage;
    }

    //call
    function getBalance() public view returns (uint balance) {
        balance = address(this).balance;
        //return balance;
    }

    function getMessage() external view returns (string memory){
        return message;
    }

    function rate(uint amount) public pure returns (uint){
        return amount * 3;
    }
}