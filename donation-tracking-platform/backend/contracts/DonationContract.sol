// backend/contracts/DonationContract.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationContract {
    struct Campaign {
        uint id;
        address payable creator;
        string title;
        string description;
        uint goal;
        uint raisedAmount;
        bool approved;
    }

    Campaign[] public campaigns;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function createCampaign(string memory _title, string memory _description, uint _goal) public {
        campaigns.push(Campaign({
            id: campaigns.length,
            creator: payable(msg.sender),
            title: _title,
            description: _description,
            goal: _goal,
            raisedAmount: 0,
            approved: false
        }));
    }

    function approveCampaign(uint _campaignId) public {
        require(msg.sender == admin, "Only admin can approve");
        campaigns[_campaignId].approved = true;
    }

    function donate(uint _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.approved, "Campaign not approved");
        campaign.creator.transfer(msg.value);
        campaign.raisedAmount += msg.value;
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        return campaigns;
    }
}
