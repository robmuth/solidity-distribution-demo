const Distribute = artifacts.require("DistributeInGroups");

module.exports = function(deployer) {
  deployer.deploy(Distribute);
};
