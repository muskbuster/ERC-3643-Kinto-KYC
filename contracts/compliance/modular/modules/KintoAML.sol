pragma solidity 0.8.17;

import "../IModularCompliance.sol";
import "../../../token/IToken.sol";
import "./AbstractModuleUpgradeable.sol";

contract KintoAML is AbstractModuleUpgradeable {
    /// Address of the Kinto KYC contract
    address public kintoamlAddress;

    /// Events
    /**
     * @dev Emitted when the Kinto KYC contract address is updated.
     * `_oldAddress` is the previous KYC contract address.
     * `_newAddress` is the updated KYC contract address.
     */
    event KintoAMLAddressUpdated(address indexed _oldAddress, address indexed _newAddress);

    /// Custom Errors
    error InvalidKycAddress();
    error Unauthorized();

    /// Functions

    /**
     * @dev Initializes the contract and sets the initial state.
     * @notice This function should only be called once during the contract deployment.
     * @param _initialKycAddress The initial address of the Kinto KYC contract.
     */
    function initialize(address _initialKycAddress) external initializer {
        if (_initialKycAddress == address(0)) revert InvalidKycAddress();
        __AbstractModule_init();
        kintoamlAddress = _initialKycAddress;
    }

    /**
     * @dev Updates the KYC contract address for Kinto.
     * Only the owner of the Compliance smart contract can call this function.
     * @param _newKycAddress The new address of the KYC contract.
     */
    function updatekintoamlAddress(address _newKycAddress) external onlyComplianceCall {
        if (_newKycAddress == address(0)) revert InvalidKycAddress();
        address oldAddress = kintoamlAddress;
        kintoamlAddress = _newKycAddress;
      
    }

    /**
     * @dev Verifies the KYC status of a given address using the Kinto KYC contract.
     * @param _userAddress The address of the user to verify.
     * @return Returns `true` if the user is KYC verified, otherwise `false`.
     */
    function isKycVerified(address _userAddress) public view returns (bool) {
        // Assuming Kinto KYC contract has a function `isVerified(address user) returns (bool)`
        return Ikintoaml(kintoamlAddress).isKYC(_userAddress);
    }

    /**
     * @dev See {IModule-moduleTransferAction}.
     * No transfer action required in this module.
     */
    function moduleTransferAction(address _from, address _to, uint256 _value) external override onlyComplianceCall {}

    /**
     * @dev See {IModule-moduleMintAction}.
     * No mint action required in this module.
     */
    function moduleMintAction(address _to, uint256 _value) external override onlyComplianceCall {}

    /**
     * @dev See {IModule-moduleBurnAction}.
     * No burn action required in this module.
     */
    function moduleBurnAction(address _from, uint256 _value) external override onlyComplianceCall {}

    /**
     * @dev See {IModule-moduleCheck}.
     * Checks if the recipient's address is KYC verified in the Kinto KYC contract.
     * @return Returns `true` if the recipient is verified, otherwise `false`.
     */
    function moduleCheck(
        address /*_from*/,
        address _to,
        uint256 /*_value*/,
        address /*_compliance*/
    ) external view override returns (bool) {
        return isKycVerified(_to);
    }

    /**
     * @dev See {IModule-canComplianceBind}.
     */
    function canComplianceBind(address /*_compliance*/) external view override returns (bool) {
        return true;
    }

    /**
     * @dev See {IModule-isPlugAndPlay}.
     */
    function isPlugAndPlay() external pure override returns (bool) {
        return true;
    }

    /**
     * @dev See {IModule-name}.
     */
    function name() public pure returns (string memory _name) {
        return "KintoAML";
    }
}

/// Interface for the Kinto KYC contract
interface Ikintoaml {
    function isKYC(address user) external view returns (bool);
}
