// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TokenBridgeX
 * @dev A decentralized bridge contract to transfer tokens securely between different blockchain networks.
 */
contract Project {
    address public admin;
    uint256 public totalTransfers;

    struct BridgeTransfer {
        uint256 id;
        address sender;
        address receiver;
        uint256 amount;
        string targetChain;
        bool completed;
    }

    mapping(uint256 => BridgeTransfer) public transfers;

    event TransferInitiated(uint256 indexed id, address indexed sender, string targetChain, uint256 amount);
    event TransferCompleted(uint256 indexed id, address indexed receiver);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // ✅ Function 1: Initiate a bridge transfer
    function initiateTransfer(address _receiver, uint256 _amount, string memory _targetChain) public {
        require(_amount > 0, "Amount must be greater than zero");

        totalTransfers++;
        transfers[totalTransfers] = BridgeTransfer(
            totalTransfers,
            msg.sender,
            _receiver,
            _amount,
            _targetChain,
            false
        );

        emit TransferInitiated(totalTransfers, msg.sender, _targetChain, _amount);
    }

    // ✅ Function 2: Mark transfer as completed (by admin)
    function completeTransfer(uint256 _id) public onlyAdmin {
        require(!transfers[_id].completed, "Already completed");
        transfers[_id].completed = true;
        emit TransferCompleted(_id, transfers[_id].receiver);
    }

    // ✅ Function 3: Get transfer details
    function getTransfer(uint256 _id) public view returns (BridgeTransfer memory) {
        require(_id > 0 && _id <= totalTransfers, "Invalid transfer ID");
        return transfers[_id];
    }
}

    