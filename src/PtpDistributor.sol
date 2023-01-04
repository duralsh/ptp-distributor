// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

interface PTP {
   function transfer(address dst, uint256 rawAmount) external returns (bool);
   function balanceOf(address account) external view returns (uint256);
   function mint(address dst, uint256 rawAmount) external;
   function minimumTimeBetweenMints() external view returns (uint256);
}


contract Distributor is Ownable{
    mapping(address => uint256) public withdrawn;
    mapping(address => uint256) public allocations;
    uint256 totalPTPWithdrawn;
    PTP public PTPContract = PTP(0x22d4002028f537599bE9f666d1c4Fa138522f9c8);

    error Unauthorized();

    constructor(address[5] memory _beneficiaries)
    {
        allocations[_beneficiaries[0]] = 36363;
        allocations[_beneficiaries[1]] = 36363;
        allocations[_beneficiaries[2]] = 10909;
        allocations[_beneficiaries[3]] = 10909;
        allocations[_beneficiaries[4]] = 5456;
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
