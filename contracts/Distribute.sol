pragma solidity >=0.5.0 <0.7.0;

contract DistributeInGroups {
	address[] public addresses;
	mapping(address => bool) public registred;
	mapping(address => uint256) public groups;

	bool ready = true;

	address payable owner = msg.sender;

	event distributed(address indexed _address, uint256 indexed _group);

	function register() public {
		require(!registred[msg.sender]);

		registred[msg.sender] = true;
		addresses.push(msg.sender);
	}

	function distribute(uint256 _seed, uint256 _groups) public {
		require(msg.sender == owner);
		require(_groups > 0);
		require(_seed > 0);
		require(addresses.length > 0);
		require(ready);
		ready = false;

		bytes32 prevBlockHash = blockhash(block.number - 1);
		uint256 multiplier = uint256(prevBlockHash);

		for(uint256 i = 0; i < addresses.length; i++) {
			address addr = addresses[i];
			uint256 group = (multiplier * (_seed + i)) % _groups;

			groups[addr] = group;

			emit distributed(addr, group);
		}
	}

	function stop() public {
		require(msg.sender == owner);
		selfdestruct(msg.sender);
	}
}