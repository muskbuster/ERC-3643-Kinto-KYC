# TREX RWA Token Leveraging Kinto Inbuilt KYC 

This project contains code implementation of the Famous RWA standard to use KINTO KYC and AML standards to enable Issuance of security tokens.

## Features

- **KYC Module**: Integrates Kinto's KYC (Know Your Customer) verification to ensure compliance with regulatory requirements.
- **AML Module**: Implements Anti-Money Laundering checks using Kinto's AML standards.
- **Modular Compliance**: Supports modular compliance checks, allowing for flexible and extensible compliance rules.
- **Upgradeable Contracts**: Utilizes upgradeable smart contracts to ensure future-proof and maintainable code.



## Architecture

```plaintext
                   +-----------------+
                   |    Registry     |
                   +-----------------+
                   | Identity registry|
                   | storage          |
                   +-----------------+
                      ↑          ↑
           Register    |          |   isVerified()
                      ↓           ↓
   +-----------------------------------------------+
   |                    Identity Registry          |
   +-----------------------------------------------+
   | Trusted Claim Topics Registry |               |
   | Trusted Claim Issuers Registry|               |
   +-----------------------------------------------+

                      ↑
                      |
                      ↓
       +--------------------------------------+
       |              Compliance              |
       +--------------------------------------+
       | Modular compliance                   |
       | Modules                              |
       +--------------------------------------+
                   ↑            ↑
 canTransfer()    |            |
                   ↓            ↓
 +-----------------------------+      +-----------------------+
 |         Identity Contract   |      |   Security Token      |
 +-----------------------------+      +-----------------------+
 |  **KINTO AML KYC**          |      |  ERC-20 functions     |
 |                             |      |  TREX functions       |
 +-----------------------------+      +-----------------------+
 ```

## Installation

1. Clone the repository:
## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/your-repo/trex-rwa-token.git
    cd trex-rwa-token
    ```

2. Install dependencies:
    ```sh
    npm install
    ```

3. Compile the contracts:
    ```sh
    npx hardhat compile
    ```

## Testing
Set PRIVATE_KEY in .env file
Run the tests to ensure everything is working correctly:
```sh
npx hardhat test
```
## Video 

## Deployment

This deployment can only be done on KINTO L2 mainet as they do not have testnet deployments

- THe KYC address - 0xf369f78E3A0492CC4e96a90dae0728A38498e9c7
- Engen Credit Checker - 0xD1295F0d8789c3E0931A04F91049dB33549E9C8F

