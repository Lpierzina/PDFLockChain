// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import Ownable from OpenZeppelin
// import "../open/Ownable.sol";



/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract OwnableLockChain is Ownable {
    // Struct to store document details
    struct Document {
        bytes32 hash;       // Hash of the document
        uint256 timestamp;  // Time when the document was registered
        address registrant; // Address of the user who registered the document
    }

    // Registration fee
    uint256 public fee = 0.001 ether; // Initial fee set to 0.001 Ether

    // Mapping from document hash to Document details
    mapping(bytes32 => Document) private documents;

    // Events
    event DocumentRegistered(bytes32 indexed hash, address indexed registrant, uint256 timestamp);

    // Modifier to check if the document is already registered
    modifier notRegistered(bytes32 _hash) {
        require(documents[_hash].timestamp == 0, "Document already registered");
        _;
    }

    // Constructor to set the initial owner
    constructor() Ownable(msg.sender) {
        // Any additional constructor code if needed
    }

    // Override renounceOwnership to disable it
    function renounceOwnership() public view override onlyOwner {
        revert("renounceOwnership is disabled");
    }

    // Override transferOwnership to disable it
    function transferOwnership(address) public view override onlyOwner {
        revert("transferOwnership is disabled");
    }

    // Function to set the registration fee (only callable by the owner)
    function setFee(uint256 _newFee) external onlyOwner {
        fee = _newFee;
    }

    // Function to get the current registration fee
    function getFee() external view returns (uint256) {
        return fee;
    }

    // Function to withdraw accumulated fees
    function withdrawFees() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No fees to withdraw");

        (bool success, ) = owner().call{value: balance}("");
        require(success, "Withdrawal failed");
    }

    // Function to register a document hash with a fee
    function registerDocument(bytes32 _hash) external payable notRegistered(_hash) {
        require(_hash != bytes32(0), "Invalid document hash");
        require(msg.value == fee, "Incorrect payment amount");

        documents[_hash] = Document({
            hash: _hash,
            timestamp: block.timestamp,
            registrant: msg.sender
        });

        emit DocumentRegistered(_hash, msg.sender, block.timestamp);
    }

    // Function to verify if a document hash is registered
    function isDocumentRegistered(bytes32 _hash) external view returns (bool) {
        return documents[_hash].timestamp != 0;
    }

    // Function to get document details
    function getDocumentDetails(bytes32 _hash)
        external
        view
        returns (bytes32 hash, uint256 timestamp, address registrant)
    {
        require(documents[_hash].timestamp != 0, "Document not registered");
        Document memory doc = documents[_hash];
        return (doc.hash, doc.timestamp, doc.registrant);
    }
}
