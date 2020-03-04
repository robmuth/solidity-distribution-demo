const Distribute = artifacts.require("DistributeInGroups");

contract("DistributeInGroups", accounts => {
	it("should register 9 accounts", () => {
		return Distribute.deployed()
			.then(async (instance) => {
				for(let i = 1; i < 10; i++) {
					await instance.register({ from: accounts[i]});
				}

				return instance;
			})
			.then(async (instance) => {
				for(let i = 0; i < 9; i++) {
					assert.equal(await instance.addresses.call(i), accounts[i + 1]);
				}
			})
	});

	it("should distribute these 9 accounts in 3 groups", () => {
		const WEAK_SECRET_SEED = Math.floor(Math.random() * 1000);

		return Distribute.deployed()
			.then((instance) => {
				return instance.distribute(WEAK_SECRET_SEED, 3, {from: accounts[0]});
			});
	})
})