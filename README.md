Solidity Distribution Demo
============================

1. Add network to ```truffle-config.js```
   For example, add ganache:

```javascript
module.exports = {
  networks: {
    ganache: {
      host: "127.0.0.1",
      port: 7545,       
      network_id: "*",  
    },
}
```

2. Run tests with listing the smart contract's events with ```truffle test --show-events```
   Example output:

```
distributed(_address: <indexed> 0xC8f75Ce64420c74dea788CAc6E9f3A78C9aE8408 (address), _group: <indexed> 1 (uint256))
distributed(_address: <indexed> 0xc45fb6E496BC8788eE845266629d1Ce05023A2f3 (address), _group: <indexed> 0 (uint256))
distributed(_address: <indexed> 0x70c4f8B542D312e0e17AB2af31e89a6777328b6e (address), _group: <indexed> 1 (uint256))
distributed(_address: <indexed> 0xB5748D98a224c5e76EcCFFB4f72b7B844dAc5DfA (address), _group: <indexed> 2 (uint256))
distributed(_address: <indexed> 0xe631206A4341C03eeCB0419088c048d42214adAC (address), _group: <indexed> 1 (uint256))
distributed(_address: <indexed> 0xf1ea1F34C0e84bb044a188E7028abB358AEbE246 (address), _group: <indexed> 2 (uint256))
distributed(_address: <indexed> 0x969f827baB3e6535732ce138a4bbB94098fF0287 (address), _group: <indexed> 1 (uint256))
distributed(_address: <indexed> 0x24348e149bC28ABf5Fe32Fa52A4d6708286cC2b3 (address), _group: <indexed> 2 (uint256))
distributed(_address: <indexed> 0x62D144a18e08c88aF797519553030564806FA37a (address), _group: <indexed> 0 (uint256))
```