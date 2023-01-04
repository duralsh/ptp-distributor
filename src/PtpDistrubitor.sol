// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

interface PTP {
   function transfer(address dst, uint256 rawAmount) external returns (bool);
   function balanceOf(address account) external view returns (uint256);
   function mint(address dst, uint256 rawAmount) external;
   function minimumTimeBetweenMints() external view returns (uint256);
}


contract Distrubitor is Ownable{
    mapping(address => uint256) public withdrawn;
    mapping(address => uint256) public allocations;
    uint256 totalPTPWithdrawn;
    PTP public PTPContract = PTP(0x22d4002028f537599bE9f666d1c4Fa138522f9c8);

    error Unauthorized();

    constructor()
    {
        allocations[0xcf3Ac866f1e9344C814A1d4b06C5B5bfB5fABBf6] = 36363;
        allocations[0xbFD6eB8953d8158b465A631A925DbA0a3936E06f] = 36363;
        allocations[0xc135009C21291D72564737f276F41EE653F5c7C0] = 5456;
        allocations[0xD4dBa96a17a289D197A0Ef86A508984B8BB69Eb4] = 10909;
        allocations[0x758908eE6D6a42Be4ce44Ee24579f1A9d8b3481e] = 10909;
    }

    function changeBeneficiary (address _newBeneficiary) external {
        if ( allocations[msg.sender] == 0 ) { revert Unauthorized();}
        uint256 allocation = allocations[msg.sender];
        uint256 withdrawnBalance = withdrawn[msg.sender];

        allocations[_newBeneficiary] = allocation;
        withdrawn[_newBeneficiary] = withdrawnBalance;

        delete allocations[msg.sender];
        delete withdrawn[msg.sender];
    }

    function withdrawBeneficiary() external {
        uint256 ptpBalance = PTPContract.balanceOf(address(this));
        uint256 totalPTPBalance = totalPTPWithdrawn + ptpBalance ;
        uint256 withdrawable = ((totalPTPBalance * allocations[msg.sender]) / 100000) - withdrawn[msg.sender];
        withdrawn[msg.sender] += withdrawable;
        totalPTPWithdrawn += withdrawable;
        PTPContract.transfer(msg.sender,withdrawable);
    }

    function withdrawEmergency() external onlyOwner {
        uint256 ptpBalance = PTPContract.balanceOf(address(this));
        PTPContract.transfer(msg.sender,ptpBalance);
    }

    function claimable(address _beneficiary) view external returns (uint256) {
        uint256 ptpBalance = PTPContract.balanceOf(address(this));
        uint256 totalPTPBalance = totalPTPWithdrawn + ptpBalance ;
        return (((totalPTPBalance * allocations[_beneficiary]) / 100000) - withdrawn[_beneficiary]);
    } 
}
