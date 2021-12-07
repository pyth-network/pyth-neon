const QueryAccount = artifacts.require("QueryAccount");
const PythOracle = artifacts.require("PythOracle");

module.exports = function (deployer) {
    deployer.deploy(QueryAccount);
    deployer.link(QueryAccount, PythOracle);
    deployer.deploy(PythOracle, "0xf9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b", "BTC/USD");
};
