? Function 1: Initiate a bridge transfer
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

    ? Function 3: Get transfer details
    function getTransfer(uint256 _id) public view returns (BridgeTransfer memory) {
        require(_id > 0 && _id <= totalTransfers, "Invalid transfer ID");
        return transfers[_id];
    }
}

    
// 
update
// 
