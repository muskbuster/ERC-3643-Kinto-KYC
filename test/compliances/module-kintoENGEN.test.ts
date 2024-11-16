import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { ethers, upgrades } from 'hardhat';
import { expect } from 'chai';
import { deployComplianceFixture } from '../fixtures/deploy-compliance.fixture';

describe('EngenCreditCheck', function () {
    async function deployComplianceWithEngenCreditCheckModule() {
        const context = await loadFixture(deployComplianceFixture);
        const { compliance } = context.suite;
        const engenCreditAddress = "0x1234567890abcdef1234567890abcdef12345678";
        const minimumRequiredCredits = 100;
        const module = await ethers.deployContract('EngenCreditCheck');
        const proxy = await ethers.deployContract('ModuleProxy', [module.address, module.interface.encodeFunctionData('initialize', [engenCreditAddress, minimumRequiredCredits])]);
        await compliance.addModule(proxy.address);
        return { compliance, engenCreditAddress, minimumRequiredCredits, module, proxy };
    }

    it('should add EngenCreditCheck module', async function () {
        const { compliance, engenCreditAddress } = await deployComplianceWithEngenCreditCheckModule();
        const modules = await compliance.getModules();
        expect(modules).to.have.lengthOf(1);
        expect(modules[0]).to.equal(engenCreditAddress);
    });

    it('should update Engen Credit address', async function () {
        const { module } = await deployComplianceWithEngenCreditCheckModule();
        const newAddress = "0xabcdefabcdefabcdefabcdefabcdefabcdef";
        await module.updateEngenCreditAddress(newAddress);
        const updatedAddress = await module.engenCreditAddress();
        expect(updatedAddress).to.equal(newAddress);
    });

    it('should update minimum required credits', async function () {
        const { module } = await deployComplianceWithEngenCreditCheckModule();
        const newMinimum = 200;
        await module.updateMinimumRequiredCredits(newMinimum);
        const updatedMinimum = await module.minimumRequiredCredits();
        expect(updatedMinimum).to.equal(newMinimum);
    });

    it('should get name of EngenCreditCheck module', async function () {
        const { module } = await deployComplianceWithEngenCreditCheckModule();
        const name = await module.name();
        expect(name).to.equal('EngenCreditCheck');
    });

    it('should revert if not enough credits', async function () {
        const { module, engenCreditAddress } = await deployComplianceWithEngenCreditCheckModule();
        const mockEngenCredit = await ethers.deployContract('MockEngenCredit', [engenCreditAddress]);
        await mockEngenCredit.setCredits(50); // Set credits less than minimumRequiredCredits
        await expect(module.moduleCheck("0x123", "0x456", 100, "0x789")).to.be.revertedWith('NotEnoughCredits');
    });

    it('should pass if enough credits', async function () {
        const { module, engenCreditAddress } = await deployComplianceWithEngenCreditCheckModule();
        const mockEngenCredit = await ethers.deployContract('MockEngenCredit', [engenCreditAddress]);
        await mockEngenCredit.setCredits(150); // Set credits more than minimumRequiredCredits
        const result = await module.moduleCheck("0x123", "0x456", 100, "0x789");
        expect(result).to.be.true;
    });
});