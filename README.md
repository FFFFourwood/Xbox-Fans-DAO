# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

## xbox fans 合约 

* path：`./contracts/xboxFans.sol`
* deploy执行文件：`./scripts/xboxFans.js`
* deploy `npx hardhat run scripts/xboxFans.js --network <network-name>`
* verify `npx hardhat verify <contract address> <arguments> --network <network>`
* 合约部署以后ABI位置在 `./artifacts/contracts/xboxFans.sol/xboxFans.json`  
