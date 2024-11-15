// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElectoralBond {
    struct Donator {
        address donatorAddress;
        uint256 amount;
    }

    struct Donee {
        uint256 donorLength;
        address[] donatorAddress;
        uint256[] amount;
    }

    mapping(address => Donee) public donees;

    // Register a donee before they can receive donations
    function registerDonee() public {
        address[] memory acc;
        uint[] memory amt;
        Donee memory d = Donee(0, acc, amt);
        donees[msg.sender] = d;
    }

    // Donate to a registered donee
    function giveDonation(address _doneeAddress) public payable {
        // Ensure a valid amount is being donated
        require(msg.value > 0, "Donation amount must be greater than zero");

        // Transfer the donation to the donee
        (bool sent, ) = payable(_doneeAddress).call{value: msg.value}("");
        require(sent, "Unable to donate");

        // Register the donation details for the donee
        Donee storage d = donees[_doneeAddress];
        d.donorLength++;
        d.amount.push(msg.value);
        d.donatorAddress.push(msg.sender);
    }

    // Get all donations for a specific donee
    function getAllDonations(address _doneeAddress) public view returns (Donator[] memory) {
        Donee memory donee = donees[_doneeAddress];
        Donator[] memory donators = new Donator[](donee.donorLength);

        for (uint256 i = 0; i < donee.donorLength; i++) {
            Donator memory d = Donator(
                donee.donatorAddress[i],
                donee.amount[i]
            );
            donators[i] = d;
        }

        return donators;
    }
}
