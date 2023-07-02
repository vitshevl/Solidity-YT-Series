// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function name() external view returns(string memory); //имя токена

    function symbol() external view returns(string memory); //код

    function decimals() external pure returns(uint); //18 количество нулей в стоимости токена

    function totalSupply() external view returns(uint); //всего токенов в обороте

    function balanceOf(address account) external view returns(uint); //количество токенов у аккаунта

    function transfer(address to, uint amount) external; //передать кому-то токены

    function allowance (address _owner, address spender) external view returns(uint); //сколько токенов позволено списывать

    function approve(address spender, uint amount) external; //позволить кому-то списывать токены

    function transferFrom (address sender, address recipient, uint amount) external; //списать у кого=то токены

    //индексироваться может до трех полей в одном событии.
    event Transfer(address indexed from, address indexed to, uint amount); //событые передачи токенов

    event Approve(address indexed owner, address indexed to, uint amount); //событые разрешения передачи токенов
}
