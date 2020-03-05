pragma solidity >=0.5.0 <0.7.0;

contract ShuffleAndRoundRobinInGroups {
	// 1. Register all accounts
	address[] public registred;
	mapping(address => bool) public isRegistred; // only allow registraion once
	
	// 2. shuffle the accounts
	address[] public shuffled;
	mapping(address => bool) isShuffled;
	
	// 3. distribute accounts in round robin
	mapping(address => uint256) public groups;

	// distribution can only run once
	bool ready = true;

	// only the contract owner can start distribution and selfdestruct the contract
	address payable owner = msg.sender;

	// debugging event
	event randomNr(uint256 indexed _rand, bool indexed _accepted);
	event distributed(address indexed _address, uint256 indexed _group);

	// ======= 1. =======
	function register() public {
		require(!isRegistred[msg.sender]);

		isRegistred[msg.sender] = true;
		registred.push(msg.sender);
	}

	// ======= 2. =======
	function shuffle(uint256 _seed) private {
		assert(msg.sender == owner);

		uint256 prevBlockHash = uint256(blockhash(block.number - 1));

		uint256 prevRand = 1;

		for(uint256 i = 0; i < registred.length; i++) {			
			uint256 rand;
			uint256 randPosition; 

			// search for a registred address which has not been shuffled
			do {
				// values from Java's java.util.Random, POSIX [ln]rand48, glibc [ln]rand48[_r], 
				// see https://en.wikipedia.org/wiki/Linear_congruential_generator#Parameters_in_common_use
				rand = (25214903917 * prevRand + 11) % (2 ** 48);
				prevRand = rand;

				randPosition = (prevBlockHash + _seed + rand) % registred.length;

				emit randomNr(randPosition, !isShuffled[registred[randPosition]]);
			} while(isShuffled[registred[randPosition]]);

			isShuffled[registred[randPosition]] = true;

			shuffled.push(registred[randPosition]);
		}
	}

	function roundRobin(uint256 _groups) private {
		assert(msg.sender == owner);

		for(uint256 i = 0; i < shuffled.length; i++) {
			groups[registred[i]] = i % _groups;
		}
	}

	// ======= 3. =======
	function distribute(uint256[] memory _seed, uint256 _groups) public {
		require(msg.sender == owner);
		require(_groups > 0);
		require(_seed.length > 0 && _seed[0] > 0);
		require(registred.length > 0);
		require(ready);
		ready = false;

		shuffle(uint256(keccak256(abi.encodePacked(_seed))));
		roundRobin(_groups);

		for(uint256 i = 0; i < registred.length; i++) {
			address addr = registred[i];
			uint256 group = groups[addr];

			emit distributed(addr, group);
		}
	}

	function stop() public {
		require(msg.sender == owner);
		selfdestruct(msg.sender);
	}
}