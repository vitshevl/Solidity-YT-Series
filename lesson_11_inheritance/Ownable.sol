// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ownable {
   address public owner;

   constructor(address ownerOverride) {
       owner = ownerOverride == address(0) ? msg.sender : ownerOverride;
   }

   modifier onlyOwner() {
       require(owner == msg.sender, "not an owner!");
       _;
   }

   function withdraw(address payable  _to) public virtual onlyOwner {
       payable (owner).transfer(address(this).balance);
   }
}