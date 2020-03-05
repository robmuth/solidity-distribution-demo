const ShuffleAndDistribute = artifacts.require("ShuffleAndRoundRobinInGroups");

contract("ShuffleAndDistributeInGroups", accounts => {
	it("needs at least 13 accounts", () => {
		assert(accounts.length >= 13, "This test case needs at least 13 accounts (1 owner and 12 accounts for distribution)");
	});

	it("should register 12 accounts", () => {
		return ShuffleAndDistribute.deployed()
			.then(async (instance) => {
				for(let i = 1; i <= 12; i++) {
					await instance.register({from: accounts[i]});
				}

				return instance;
			})
			.then(async (instance) => {
				for(let i = 0; i < 12; i++) {
					assert.equal(await instance.registred.call(i), accounts[i + 1]);
				}
			})
	});

	it("should ShuffleAndDistribute these 12 accounts in 3 groups", async () => {
		const WEAK_SECRET_SEED = [...Array(32)].map(() => parseInt(Math.random() * 256));

		let instance;

		return ShuffleAndDistribute.deployed()
			.then((_instance) => {
				instance = _instance;
				return instance.distribute(WEAK_SECRET_SEED, 3, {from: accounts[0]});
			})
			.then(async () => {
				let differentPosition = 0;

				for(let i = 0; i < 12; i++) {
					const originalPosition = i;
					const originalAddr = await instance.registred(i);

					let newPosition = -1;

					for(let j = 0; j < 12; j++) {
						if(await instance.shuffled(j) == originalAddr)
							newPosition = j;
					}

					assert(newPosition !== -1, "Missing a registred account in the shuffled accounts: " + originalPosition);

					if(newPosition !== originalPosition)
						differentPosition++;
				}

				console.log("Shuffled " + differentPosition + " accounts.");
			});
	})
})