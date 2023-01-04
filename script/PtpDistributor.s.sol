// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/PtpDistributor.sol";


contract DistributorScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        address[5] memory beneficiaries = [0xcf3Ac866f1e9344C814A1d4b06C5B5bfB5fABBf6, 0xbFD6eB8953d8158b465A631A925DbA0a3936E06f, 0x758908eE6D6a42Be4ce44Ee24579f1A9d8b3481e, 0xD4dBa96a17a289D197A0Ef86A508984B8BB69Eb4 , 0xc135009C21291D72564737f276F41EE653F5c7C0] ;
        Distributor PTP_DISTRIBUTOR = new Distributor(beneficiaries);

    }
}
