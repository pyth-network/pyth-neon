const QueryAccount = artifacts.require("QueryAccount");
const Pyth = artifacts.require("Pyth");

module.exports = function (deployer) {
    deployer.deploy(QueryAccount);
    deployer.link(QueryAccount, Pyth);
    deployer.deploy(Pyth);
};
