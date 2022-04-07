const QueryAccount = artifacts.require("QueryAccount");
const PythOracle = artifacts.require("PythOracle");

module.exports = function (deployer) {
    deployer.deploy(QueryAccount);
    deployer.link(QueryAccount, PythOracle);
    deployer.deploy(PythOracle);
};
