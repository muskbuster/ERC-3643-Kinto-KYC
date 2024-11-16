pragma solidity 0.8.17;

import "../IModularCompliance.sol";
import "../../../token/IToken.sol";
import "./AbstractModuleUpgradeable.sol";

interface IEngenCredit {
    function earnedCredits(address account) external view returns (uint256);
}

contract EngenCreditCheck is AbstractModuleUpgradeable {
    /// Address of the Engen Credit contract
    address public engenCreditAddress;

    /// Minimum required credits for compliance
    uint256 public minimumRequiredCredits;

    /// Events
    /**
     * @dev Emitted when the Engen Credit address is updated.
     */
    event EngenCreditAddressUpdated(address newAddress);

    /**
     * @dev Emitted when the minimum required credits are updated.
     */
    event MinimumRequiredCreditsUpdated(uint256 newMinimum);

    /// Custom Errors
    error NotEnoughCredits(address account, uint256 credits, uint256 required);

    /// Functions

    /**
     * @dev Initializes the contract with the Engen Credit address and minimum required credits.
     * @param _engenCreditAddress Address of the Engen Credit contract.
     * @param _minimumRequiredCredits Minimum credits required for compliance.
     */
    function initialize(address _engenCreditAddress, uint256 _minimumRequiredCredits) external initializer {
        __AbstractModule_init();
        engenCreditAddress = _engenCreditAddress;
        minimumRequiredCredits = _minimumRequiredCredits;
        emit EngenCreditAddressUpdated(_engenCreditAddress);
        emit MinimumRequiredCreditsUpdated(_minimumRequiredCredits);
    }

    /**
     * @dev Updates the Engen Credit contract address.
     * @param _engenCreditAddress Address of the new Engen Credit contract.
     */
    function updateEngenCreditAddress(address _engenCreditAddress) external onlyComplianceCall {
        engenCreditAddress = _engenCreditAddress;
        emit EngenCreditAddressUpdated(_engenCreditAddress);
    }

    /**
     * @dev Updates the minimum required credits for compliance.
     * @param _minimumRequiredCredits New minimum required credits.
     */
    function updateMinimumRequiredCredits(uint256 _minimumRequiredCredits) external onlyComplianceCall {
        minimumRequiredCredits = _minimumRequiredCredits;
        emit MinimumRequiredCreditsUpdated(_minimumRequiredCredits);
    }

    /**
     * @dev Checks if the account has sufficient credits for compliance.
     * @param _from Address of the sender.
     * @param _to Address of the receiver.
     * @param _value Amount of tokens being transferred.
     * @param _compliance Address of the compliance contract.
     * @return True if the account has sufficient credits, false otherwise.
     */
    function moduleCheck(
        address _from,
        address _to,
        uint256 _value,
        address _compliance
    ) external view override returns (bool) {
        uint256 credits = _getCredits(_from);
        if (credits < minimumRequiredCredits) {
            revert NotEnoughCredits(_from, credits, minimumRequiredCredits);
        }
        return true;
    }

    /**
     * @dev Retrieves the earned credits of an account from the Engen Credit system.
     * @param account Address of the account.
     * @return The number of earned credits.
     */
    function _getCredits(address account) internal view returns (uint256) {
        return IEngenCredit(engenCreditAddress).earnedCredits(account);
    }

    /**
     * @dev See {IModule-moduleTransferAction}.
     * No specific transfer action is required for this module.
     */
    function moduleTransferAction(address _from, address _to, uint256 _value) external override onlyComplianceCall {}

    /**
     * @dev See {IModule-moduleMintAction}.
     * No specific mint action is required for this module.
     */
    function moduleMintAction(address _to, uint256 _value) external override onlyComplianceCall {}

    /**
     * @dev See {IModule-moduleBurnAction}.
     * No specific burn action is required for this module.
     */
    function moduleBurnAction(address _from, uint256 _value) external override onlyComplianceCall {}

    /**
     * @dev See {IModule-canComplianceBind}.
     * @return Always returns true as this module can be bound to any compliance.
     */
    function canComplianceBind(address _compliance) external view override returns (bool) {
        return true;
    }

    /**
     * @dev See {IModule-isPlugAndPlay}.
     * @return Always returns true as this module is plug-and-play.
     */
    function isPlugAndPlay() external pure override returns (bool) {
        return true;
    }


    function name() public pure returns (string memory _name) {
        return "EngenCreditCheck";
    }
}
