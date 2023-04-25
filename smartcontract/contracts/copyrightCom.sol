// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract KeyValueStore {
    
    mapping(string => address) public store;
    address[] public conAddress;
    uint public length=0;

   function setNewItem(string memory feature, string memory Info) public returns (address) {
        require(store[feature] == address(0), "Feature already exists");
        MyContract newContract = new  MyContract(msg.sender, feature, Info);
        store[feature] = address(newContract);
        conAddress.push(address(newContract));
        length++;
        return address(newContract);
}

    function findAddress(string memory feature) public view returns (address) {
        return store[feature];
    }

    function getConAddress() public view returns (address[] memory) {
        return conAddress;
}
}

contract MyContract {
    address public owner;
    string public feature;
    string public info;
    string public tempinfo;
    address public tempOwner;
    string public IPFShash;
    uint public price;
    enum State { Default, ForSale, PendingConfirmation }
    State public state;
    event ItemOnChain(string,string);
    event ItemOnSell(uint);
    event ItemBought(address,string);
    event ItemConfirm();
    event ItemChangeOwner(address,address);
    event ItemRevet();
    event IPFShashSetted(string);
    constructor(address _owner ,string memory _feature, string memory _info) {
        owner = _owner;
        feature = _feature;
        info = _info;
        state = State.Default;
        emit ItemOnChain(feature,info);
    }

    function getInfo() public view returns (address, string memory, string memory, string memory, State, uint ) {
        return (owner, feature, info, IPFShash, state, price);
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner, "Only the owner can call this function.");
        owner = _newOwner;
        emit ItemChangeOwner(msg.sender,owner);
    }

    function setIPFShash(string memory _IPFShash) public {
        require(msg.sender == owner, "Only the owner can call this function.");
        IPFShash = _IPFShash;
        emit IPFShashSetted(IPFShash);
    }

    function sell(uint _price) public {
        require(msg.sender == owner, "Only the owner can call this function.");
        require(state == State.Default, "The contract must be in the Default state to be sold.");
        require(bytes(IPFShash).length > 0, "IPFS field must not be empty.");
        price = _price;
        state = State.ForSale;
        emit ItemOnSell(_price);
    }

    function revertSell() public {
        require(msg.sender == owner, "Only the owner can call this function.");
        require(state == State.ForSale, "The contract must be in the ForSale state to be reverted.");
        price = 0;
        state = State.Default ;
        emit ItemRevet();
    }

    function buy(string memory _newInfo) public payable {
        require(state == State.ForSale, "The contract must be in the ForSale state to be bought.");
        require(msg.value == price, "The value sent must be equal to the sale price.");
        tempinfo = _newInfo;
        tempOwner= msg.sender;
        state = State.PendingConfirmation;
        emit ItemBought(msg.sender,_newInfo );
    }

    function confirm() public {
        require(msg.sender == owner, "Only the owner can call this function.");
        require(state == State.PendingConfirmation, "The contract must be in the PendingConfirmation state to be confirmed.");
        payable(owner).transfer(address(this).balance);
        info=tempinfo;
        changeOwner(tempOwner);
        state = State.Default;
        emit ItemConfirm();
    }
}