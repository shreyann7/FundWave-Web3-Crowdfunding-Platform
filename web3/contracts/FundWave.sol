// SPDX-License-Identifier: UNLICENSED
// SRH
pragma solidity ^0.8.9;

contract FundWave {
    //Defining Campaign Struct
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image; // as we will give the url of image
        address[] donators;
        uint256[] donations;
    }

    // creating a mapping
    mapping(uint256 => Campaign) public campaigns;
    // now that weve made a campaign mapping we can acces it as campaign[0]

    uint256 public numberOfCampaigns = 0;

    // Function Definations

    //memory keyword : memory keyword to store the data temporarily during the execution of a smart contract.

    //storage keyword :Storage holds data between function calls.


    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        // returns the index of recently created campaign 
        return numberOfCampaigns - 1;
    }

    //payable keyword : ensures that the owner address can handle Ether transactions.
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }

}