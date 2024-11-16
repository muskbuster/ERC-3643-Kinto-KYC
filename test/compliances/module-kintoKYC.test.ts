import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { ethers, upgrades } from 'hardhat';
import { expect } from 'chai';
import { deployComplianceFixture } from '../fixtures/deploy-compliance.fixture';

describe('KintoKYC', function () {
    async function deployComplianceWithKintoKYCModule() {
        const context = await loadFixture(deployComplianceFixture);
        const { compliance } = context.suite;
        const KintoKYCAddress = "0xf369f78E3A0492CC4e96a90dae0728A38498e9c7";
        const module = await ethers.deployContract('KintoKYC');
        //initialize w address 
        const proxy = await ethers.deployContract('ModuleProxy', [module.address, module.interface.encodeFunctionData('initialize', [KintoKYCAddress])]);
        await compliance.addModule(proxy.address);
        return { compliance, KintoKYCAddress, module, proxy };
      }
    it ('should add KintoKYC module', async function () {
        const { compliance, KintoKYCAddress } = await deployComplianceWithKintoKYCModule();
        const modules = await compliance.getModules();
        expect(modules).to.have.lengthOf(1);
        expect(modules[0]).to.equal(KintoKYCAddress);
    }
    );

    it ('should add KintoKYC module and get KintoKYC address', async function () {
        const { compliance, KintoKYCAddress } = await deployComplianceWithKintoKYCModule();
        const kintoKYCAddress = await compliance.kintoKYCAddress();
        expect(kintoKYCAddress).to.equal(KintoKYCAddress);
    });
    it ('should get name of KintoKYC module', async function () {
        const { compliance, KintoKYCAddress, module } = await deployComplianceWithKintoKYCModule();
        const name = await module.name();
        expect(name).to.equal('KintoKYC');
    }
    );


    
});