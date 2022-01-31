// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";

abstract contract BPContract{
    function protect( address sender, address receiver, uint256 amount ) external virtual;   
}

contract RacewayX is ERC20, Ownable, ERC20Snapshot {

    BPContract public BP;
    bool public bpEnabled;
    bool public BPDisabledForever;
    
    constructor() ERC20("Raceway X", "RWX") {
        _mint(msg.sender, 1000000000 *10 **18);
    }
    
    function snapshot () public onlyOwner {
      //taking a snapshot of account balance
      _snapshot();
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Snapshot) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function setBPAddress(address _bp) external onlyOwner  {
        require(address(BP)== address(0), "Can only be initialized once");
        BP = BPContract(_bp);
    }
    
    function setBpEnabled(bool _enabled) external onlyOwner  {
        bpEnabled = _enabled;
    }
    
    function setBotProtectionDisableForever() external onlyOwner {
        require(BPDisabledForever == false);
        BPDisabledForever = true;
    }

    function _transfer(address from, address to, uint256 amount) internal override{
        if (bpEnabled && !BPDisabledForever){
        BP.protect(from, to, amount);
      }
    }
}