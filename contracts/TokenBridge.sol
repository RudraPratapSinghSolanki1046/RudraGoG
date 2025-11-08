// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title TokenBridgeX
 * @notice A decentralized token bridge enabling secure cross-chain asset transfers 
 *         through a two-step lock and release verification mechanism.
 */
contract Project {
    address public admin;
    uint256 public transferCount;

    struct BridgeTransfer {
        uint256 id;
        address sender;
        address receiver;
        uint256 amount;
        string targetChain;
        bool completed;
    }

    mapping(uint256 => BridgeTransfer) public transfers;

    event TokenLocked(uint256 indexed id, address indexed sender, uint256 amount, string targetChain);
    event TokenReleased(uint256 indexed id, address indexed receiver, uint256 amount, string fromChain);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Locks tokens on the source chain before bridging.
     * @param _receiver Receiver address on the target chain
     * @param _amount Amount of tokens to bridge
     * @param _targetChain Target blockchain name
     */
    function lockTokens(address _receiver, uint256 _amount, string memory _targetChain) external payable {
        require(_amount > 0, "Amount must be greater than 0");
        require(bytes(_targetChain).length > 0, "Target chain required");

        transferCount++;
        transfers[transferCount] = BridgeTransfer(
            transferCount,
            msg.sender,
            _receiver,
            _amount,
            _targetChain,
            false
        );

        emit TokenLocked(transferCount, msg.sender, _amount, _targetChain);
    }

    /**
     * @notice Admin releases the bridged tokens on the destination chain.
     * @param _id Transfer ID
     * @param _fromChain Name of the originating blockchain
     */
    function releaseTokens(uint256 _id, string memory _fromChain) external onlyAdmin {
        BridgeTransfer storage transfer = transfers[_id];
        require(!transfer.completed, "Transfer already completed");

        transfer.completed = true;

        emit TokenReleased(_id, transfer.receiver, transfer.amount, _fromChain);
    }

    /**
     * @notice Fetch transfer details
     * @param _id Transfer ID
     */
    function getTransfer(uint256 _id) external view returns (BridgeTransfer memory) {
        require(_id > 0 && _id <= transferCount, "Invalid transfer ID");
        return transfers[_id];
    }
}
// 
End
// 
