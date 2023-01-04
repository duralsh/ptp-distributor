// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PtpDistrubitor.sol";

contract DistrubitorTest is Test {
    PTP public PTPContract = PTP(0x22d4002028f537599bE9f666d1c4Fa138522f9c8);
    Distrubitor PTP_DISTRIBUTOR = new Distrubitor();
    uint256 initialBalance = 3330000 ether;
    address[5] beneficiaries = [0xcf3Ac866f1e9344C814A1d4b06C5B5bfB5fABBf6,0xbFD6eB8953d8158b465A631A925DbA0a3936E06f, 0xc135009C21291D72564737f276F41EE653F5c7C0, 0xD4dBa96a17a289D197A0Ef86A508984B8BB69Eb4 , 0x758908eE6D6a42Be4ce44Ee24579f1A9d8b3481e] ;
 
    function setUp() public {
       

        mintPTP(address(PTP_DISTRIBUTOR),initialBalance, 0);
        
    }

    function testDistrubition() public {
        
        vm.startPrank(beneficiaries[0]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(PTP_DISTRIBUTOR)) + PTPContract.balanceOf(address(beneficiaries[0])), initialBalance);
        uint256 prevBalance = PTPContract.balanceOf(address(beneficiaries[0]));
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(beneficiaries[0])), prevBalance);
        vm.stopPrank();

        vm.prank(beneficiaries[1]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();

        vm.prank(beneficiaries[2]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();

        vm.prank(beneficiaries[3]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();

        vm.prank(beneficiaries[4]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();

        assertEq(PTPContract.balanceOf(address(PTP_DISTRIBUTOR)), 0);
        emit log_uint(PTPContract.balanceOf(address(PTP_DISTRIBUTOR)));

    }

    function testDistrubitionRepetitive() public {
        
        vm.startPrank(beneficiaries[0]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(PTP_DISTRIBUTOR)) + PTPContract.balanceOf(address(beneficiaries[0])), initialBalance);
        uint256 prevBalance = PTPContract.balanceOf(address(beneficiaries[0]));
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(beneficiaries[0])), prevBalance);
        vm.stopPrank();

        mintPTP(address(PTP_DISTRIBUTOR),initialBalance, 1);

        vm.startPrank(beneficiaries[0]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(beneficiaries[0])), prevBalance * 2);
        vm.stopPrank();

        vm.prank(beneficiaries[1]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(beneficiaries[0])), PTPContract.balanceOf(address(beneficiaries[1])));

        vm.prank(beneficiaries[2]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();

        vm.prank(beneficiaries[3]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();

        vm.prank(beneficiaries[4]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();

        assertEq(PTPContract.balanceOf(address(PTP_DISTRIBUTOR)), 0 );

        emit log_uint(PTPContract.balanceOf(address(PTP_DISTRIBUTOR)));
    }

    function testChangeBeneficiary() public {
        
        vm.startPrank(beneficiaries[0]);
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(PTP_DISTRIBUTOR)) + PTPContract.balanceOf(address(beneficiaries[0])), initialBalance);
        uint256 prevBalance = PTPContract.balanceOf(address(beneficiaries[0]));
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(beneficiaries[0])), prevBalance);
        vm.stopPrank();

        mintPTP(address(PTP_DISTRIBUTOR),initialBalance, 1);
        vm.startPrank(beneficiaries[0]);
        address randomAddress = address(bytes20(keccak256(abi.encodePacked(block.timestamp))));
        PTP_DISTRIBUTOR.changeBeneficiary(randomAddress);
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(beneficiaries[0])), prevBalance);
        vm.stopPrank();

        vm.prank(randomAddress);
        PTP_DISTRIBUTOR.withdrawBeneficiary();
        assertEq(PTPContract.balanceOf(address(beneficiaries[0])), PTPContract.balanceOf(randomAddress));



    }

    function mintPTP (address _receiver, uint256 _amount, uint256 mintCount) internal{
        vm.warp(1702395868 + mintCount* (PTPContract.minimumTimeBetweenMints()));
        vm.prank(0xc4Cf4996Ee374591D60FA80BcDfBF2F25CDE7CBe);
        PTPContract.mint(_receiver, _amount);
    }



   

}
