const Shuffle = artifacts.require("ShuffleAndRoundRobinInGroups");

module.exports = function(deployer) {
  deployer.deploy(Shuffle);
};
