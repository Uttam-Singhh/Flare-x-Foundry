// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IFlareContractRegistry} from "flare-foundry-periphery-package/coston2/util-contracts/userInterfaces/IFlareContractRegistry.sol";
import {IFtsoRegistry} from "flare-foundry-periphery-package/coston2/ftso/userInterfaces/IFtsoRegistry.sol";

error FundMe__NotOwner();

contract FundMe {
    mapping(address => uint256) private fundedAmount; // mapping

    uint256 public constant MIN_FUND = 1e18; //1 dollar (funded amount > $1)
    address private immutable i_owner; //owner of the fundme contract who can only withdraw
    address private constant FLARE_CONTRACT_REGISTRY =
        0xaD67FE66660Fb8dFE9d6b1b4240d8650e30F6019;

    constructor() {
        i_owner = msg.sender;
    }

    //this function helps us to retrieve the current price of FLR & convert the funded amount so it can be compared with MIN_FUND
    function getPriceinWei(
        string memory _symbol,
        uint256 Amount
    ) public view returns (uint256) {
        // access the contract registry
        IFlareContractRegistry contractRegistry = IFlareContractRegistry(
            FLARE_CONTRACT_REGISTRY
        );

        // retrieve the FTSO registry
        IFtsoRegistry ftsoRegistry = IFtsoRegistry(
            contractRegistry.getContractAddressByName("FtsoRegistry")
        );

        // get latest price
        (uint256 _price, , uint256 _decimals) = ftsoRegistry
            .getCurrentPriceWithDecimals(_symbol);

        return uint256(((_price * (10 ** (18 - _decimals))) * Amount) / 1e18);
    }

    function fund() public payable {
        uint256 fund_amount = getPriceinWei("C2FLR", msg.value);
        require(fund_amount >= MIN_FUND, "didn't send enough money");

        fundedAmount[msg.sender] += msg.value;
    }

    //only owner can call the withdraw function
    function withdraw() public onlyOwner {
        require(address(this).balance > 0);

        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Call failed");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    //retrieve the amount funded by an address
    function getAmountFunded(address funder) external view returns (uint256) {
        return fundedAmount[funder];
    }

    //retrieve the owner of the contract
    function getOwner() external view returns (address) {
        return i_owner;
    }
}
