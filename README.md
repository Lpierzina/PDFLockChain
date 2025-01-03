# LockChain

**LockChain** is a decentralized application (dApp) designed to bring trust, security, and transparency to document registration and verification using blockchain technology. By allowing users to register a unique digital fingerprint (hash) of their files on the Ethereum blockchain, LockChain ensures that once a document’s authenticity is recorded, it cannot be tampered with or forged.

## Features

1. **Immutable Proof of Ownership:**  
   LockChain creates a permanent, verifiable record of your document’s existence and ownership at a specific point in time using the Ethereum blockchain.

2. **Enhanced Security:**  
   Traditional data storage and verification methods are susceptible to fraud and manipulation. With LockChain, each registered document hash is stored in a tamper-proof smart contract, guaranteeing its integrity.

3. **Easy Verification:**  
   Anyone can quickly verify the authenticity of a document by checking its hash against the blockchain record. No sensitive data is exposed—only the cryptographic hash is shared.

4. **Privacy Protection:**  
   LockChain does not store the actual document, only its hash. Your private content remains in your hands, and you control if or when you share the actual file.

5. **Cost-Effective & Efficient:**  
   With a low registration fee (default: 0.001 ETH) plus gas costs, LockChain provides a quick and affordable way to secure your documents without third-party intermediaries.

## Components

- **Smart Contract (OwnableLockChain.sol)**:  
  Found in the `src/` directory, this Solidity contract handles:
  - Registering document hashes.
  - Storing timestamps and registrant addresses.
  - Charging and updating the registration fee.
  - Withdrawing accumulated fees to the contract owner.

  The contract uses the OpenZeppelin `Ownable` pattern for access control and includes a custom logic to disable ownership transfer once deployed.

- **Front-End (index.html & JavaScript)**:  
  The `index.html` file and accompanying JavaScript code (referenced inline) provide a user-friendly interface for:
  - Connecting to Ethereum wallets (MetaMask or Coinbase Wallet).
  - Computing the hash of a selected PDF document.
  - Registering the document hash on the blockchain.
  - Verifying if a given document hash is registered.
  - Displaying a transaction receipt and generating a QR code for the transaction on Etherscan.

  The front-end uses Web3.js to interact with the Ethereum network and the deployed LockChain contract.

## Getting Started

### Prerequisites

- **Node.js & npm**: Used if you’re working with Foundry or additional toolings.
- **Foundry (Forge)**: For compiling and testing the smart contract.
- **MetaMask or Coinbase Wallet**: To connect and interact with the dApp.

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/YourUsername/LockChain.git
   cd LockChain

   Install Foundry (optional for contract development):
Refer to the Foundry Book for installation instructions.

Compile the Contract (optional):

bash

forge build

Run Tests (optional):
forge test

Deployment
Deploy the OwnableLockChain contract to the Ethereum network (e.g., Sepolia testnet) using your preferred method:


forge create --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY> src/OwnableLockChain.sol:OwnableLockChain
Update the contractAddress and YOUR_INFURA_PROJECT_ID in index.html to match your contract’s deployed address and Infura (or other RPC) details.

Below is a bash example of how you can manually export the variables in your shell without specifying a fork URL. Adjust the values as needed:

bash
export PRIVATE_KEY="0x123456789abcdef..."
export RPC_URL="https://sepolia.infura.io/v3/YOUR_PROJECT_ID"
export ETHERSCAN_API_KEY="YOUR_ETHERSCAN_API_KEY"

Then you can run:

forge script script/Deploy.s.sol:DeployScript --rpc-url $RPC_URL --broadcast --verify -vvvv

Usage
Open index.html in a Browser:
Serve the file or open it directly in your browser. For full functionality, open it through a local HTTP server (e.g. python3 -m http.server) to avoid any local file restrictions.

Connect Wallet:
Click Connect MetaMask or Connect Coinbase Wallet to authorize your wallet. If using a mobile device, open the site inside the wallet’s in-app browser.

Register a Document:
Select a PDF file using the Hash Document button.
Once hashed, click Register Hash on Blockchain to register the file’s hash.
Pay the fee and gas in your connected wallet.

Verify a Document:
Select the same document again or provide a known hash.
If registered, the app displays the registrant address and timestamp.

Security & Disclaimer
Use at your own risk. LockChain is provided as-is, and you are responsible for securing your private keys and understanding gas costs.
Always test with a test network (like Sepolia) before using mainnet.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Contributing
Contributions are welcome! Please open an issue or submit a pull request if you’d like to suggest improvements or add new features.

LockChain: Bringing trust, transparency, and convenience to document verification through blockchain technology.






