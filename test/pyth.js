const Pyth = artifacts.require("Pyth");
const PythStructs = artifacts.require("PythStructs");

contract("Pyth", function () {

    beforeEach(async function () {
        this.pyth = await Pyth.deployed();
    });

    it("should parse Solana price account data correctly", async function() {

        const accountID = "0xf9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b";
        const accountData = "0xd4c3b2a10200000003000000f00c000001000000f8ffffff2000000007000000abfdac0700000000aafdac070000000080a86c92f70300009f051fd9000000003af8c5f101000000a81b624d00000000fcea9f40000000003af8c5f101000000181250620000000003000000000000003515b3861e8fe93e5f540ba4077c216404782b86d5e78077b3cbfd27313ab3bc0000000000000000000000000000000000000000000000000000000000000000aafdac07000000002099f885f60300005097ad920000000017125062000000008080627ff6030000201af08e000000000100000000000000abfdac0700000000e39431e42b2abdb0e1389b67229bdc9e0d4fa2b270e3b7b62905d7d1854f9a3500f3f404f6030000e0ee8685010000000100000000000000a6fdac070000000000f3f404f6030000e0ee8685010000000100000000000000a6fdac070000000079fadf2cdcc4a846aa957dda839f92b686d43284a001a39e7a2eb2fb6e7419ed2874c02453040000fbf5a56e0000000001000000000000004099a306000000002874c02453040000fbf5a56e0000000001000000000000004099a3060000000089b6b362208c21395cd9dad7aaf4e5b777d20a793b5b585e1b7128b89a208d975603be94f60300007fcadd810000000001000000000000009efdac07000000005603be94f60300007fcadd810000000001000000000000009efdac07000000001ae502a3e942b8b11cc374496b4d9c5c39f80c5dac1f459f35a20ec1b873089dc0bfb593f603000040612237000000000100000000000000a1fdac0700000000c0bfb593f603000040612237000000000100000000000000a1fdac07000000009f6a431f1f3b38846652638f8adc4ef2e5ad0bfcaca7f3c779a2dfc21c7c7527fff16f71f6030000ffa2e11100000000010000000000000073fdac0700000000fff16f71f6030000ffa2e11100000000010000000000000073fdac07000000000dc3bcea9155697608b05f04a70ad09a415172aa9bb5f740873ac0782b2b1a45c0f84fb0f2030000e99841af1800000000000000000000008446ac0700000000c0f84fb0f2030000e99841af1800000000000000000000008446ac070000000005d2064f331cffddcabe96fa365524dd64f4b386e885a34d152cbeae042ceaf541925acff7030000384dd52000000000010000000000000088fdac070000000041925acff7030000384dd52000000000010000000000000088fdac07000000009f3ea57bd409ba00c40d92ae571341c27e3c2f7edface1c24a51b1a15c31b2b7c02db774f603000080d55eb90000000001000000000000007bfdac0700000000c02db774f603000080d55eb90000000001000000000000007bfdac070000000024feb677a6bcc537350a6718fb40e64f0b80a364b5cff7ee65cccd573c20cd0f264e86c7f6030000c0ae3b280000000001000000000000009cfdac0700000000264e86c7f6030000c0ae3b280000000001000000000000009cfdac070000000009d9e487ca5572f6d4d46aea6ebb4f72e900cbdb739aac105e00b39673ff561e3fb181d5f60300001df5b9880000000001000000000000008bfdac07000000003fb181d5f60300001df5b9880000000001000000000000008bfdac0700000000a9ead3e3d34bcc8534bb2c650eb27a8c8c3f1a22d688284328538c42a8e823430047f1a9f6030000ffe3cca800000000010000000000000080fdac07000000000047f1a9f6030000ffe3cca800000000010000000000000080fdac0700000000e2b98f269084d4880511c8115dcef04f53c7e207992e03ffd126df944de4db04c0785b62f603000040420f000000000001000000000000009bfdac0700000000c0785b62f603000040420f000000000001000000000000009bfdac070000000007f2cb39fdb029dc51784d28ef17911d97c1a69c85723a1b6255b3425343ad75cc643892f603000048acc50301000000010000000000000044fdac0700000000cc643892f603000048acc50301000000010000000000000044fdac070000000043828fa3619da6bcaed68917de1d7cce9217dec72bae123063ff7be7dd2f963e1052fd8cf60300009f33d51a0000000001000000000000006bfdac07000000001052fd8cf60300009f33d51a0000000001000000000000006bfdac0700000000160fbac13af7ddd805d3170a3de0c6bd97126a1e02c0d259d0a86ef821d6e5c700eac041f6030000ce72de320000000001000000000000009cf8ac070000000000eac041f6030000ce72de320000000001000000000000009cf8ac07000000001883b1246dda5d07173dbd38d567000715842c1fd0e896e70b0a6dd2e51a4f9760fddfe5f60300006073f04000000000010000000000000083fcac070000000060fddfe5f60300006073f04000000000010000000000000083fcac070000000043b7784b6f8566cb328365fbce0b40461523baece78517b3155c31daa338298f1f7e53fff6030000df77935f00000000010000000000000004fdac07000000001f7e53fff6030000df77935f00000000010000000000000004fdac0700000000f59dddefcc166b2d89a4a3ccf3fec4bb4b98a151b4c037ff615ebb7842e33d75a02ab0bcf6030000609aa02d00000000010000000000000060fdac0700000000a02ab0bcf6030000609aa02d00000000010000000000000060fdac0700000000d0ca331cf5d9ee716bc8c690a300aba8403b37141cb63b0265c098c0c58e63ac204973cef6030000b798b73e000000000100000000000000d4f7ac0700000000204973cef6030000b798b73e000000000100000000000000d4f7ac0700000000bc546c95155995bc073f57c79fd4c2e07d201d3e1cbda74424bb0c61acea41bef0187659f603000021299646000000000100000000000000a3fdac0700000000b571307af6030000bfa50765000000000100000000000000a5fdac070000000091f2a580f1f1babe6c2e65eaada64050ec7cdcd53e57faec17050b1d43903c558066428cf60300008036be2600000000010000000000000086fdac07000000008066428cf60300008036be2600000000010000000000000086fdac0700000000a79a4389d6353bba85d35b7d66c9a630715437931f62afdd763e8d420e7bab72a99b34b3f6030000dd631e7900000000010000000000000088fdac0700000000a99b34b3f6030000dd631e7900000000010000000000000088fdac07000000007f8053276929f4e81a07e64c5a5799069923efa884dc27471f33b761508c4e1f82b92bf8f6030000027ea0ab010000000100000000000000e8fcac070000000082b92bf8f6030000027ea0ab010000000100000000000000e8fcac07000000000479228566bca87687ba32d88055c32308cc6f5a62cfa67f18819941e385b2b240e2cb9ef60300008014f840000000000100000000000000a1fdac070000000040e2cb9ef60300008014f840000000000100000000000000a1fdac07000000007dc2b5ad759b62840ab42ab69f32620a6be96024e37ef5d8b968238b4190b06a2c934173f6030000e8501e7100000000010000000000000059fdac07000000002c934173f6030000e8501e7100000000010000000000000059fdac070000000043349b3b6987593c65f7001122bb85d8f6f15ffd3751ab084788b687607a1ded40923daaf6030000c0fd448900000000010000000000000080fdac070000000040923daaf6030000c0fd448900000000010000000000000080fdac0700000000137381d03d190f42aab0156177d0d3e87260402ae95daf58296a053d8fe3b1e980275dd238040000404b553d000000000100000000000000cc84a1070000000080275dd238040000404b553d000000000100000000000000cc84a10700000000b1d03333541027917da2416a71fb3863a3cf72a3c1ecc76a4855d08d8018f54140157eb4f603000072edf04000000000010000000000000088fdac070000000040157eb4f603000072edf04000000000010000000000000088fdac0700000000cc9b10be29cc8bf39608ec84e2e3b436f856f14ab9da9bb5c16abfc01292cb4df2b8d49ef60300008d99518b00000000010000000000000088fdac0700000000f2b8d49ef60300008d99518b00000000010000000000000088fdac0700000000311b81d16f034312d08563469fd036e95b3a65df52907ba0b112ff89f85dc266e71902faf8030000fe93580401000000010000000000000028fdac0700000000e71902faf8030000fe93580401000000010000000000000028fdac07000000000c4a8e3702f6e26d9d0c900c1461da4e3debef5743ce253bb9f0308a68c94422b4bb7baef8030000fd1bad8a0200000001000000000000009eb3ac0700000000b4bb7baef8030000fd1bad8a0200000001000000000000009eb3ac0700000000329a63c1f089df2ab0b4461f67e870d776b975848fa076b18cc66ff8b977ca7c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

        let parsed = await this.pyth.parseSolanaPriceAccountData(accountID, accountData);

        assert.equal(parsed.id, accountID);

        assert.equal(parsed.expo, -8);
        assert.equal(parsed.maxNumPublishers, 32);
        assert.equal(parsed.numPublishers, 7);
        assert.equal(parsed.emaPrice, 4361848400000);
        assert.equal(parsed.emaConf, 1298275240);

        assert.equal(parsed.publishTime, 1649414680);
        assert.equal(parsed.productId, "0x3515b3861e8fe93e5f540ba4077c216404782b86d5e78077b3cbfd27313ab3bc");
        assert.equal(parsed.prevPrice, 4357344500000);
        assert.equal(parsed.prevConf, 2460850000);
        assert.equal(parsed.prevPublishTime, 1649414679);
        assert.equal(parsed.price, 4357234000000);
        assert.equal(parsed.conf, 2398100000);
        assert.equal(parsed.status, PythStructs.PriceStatus.TRADING);
    });

});
