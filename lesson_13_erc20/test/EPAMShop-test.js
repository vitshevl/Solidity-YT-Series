const { expect } = require("chai")
const { ethers } = require("hardhat")
const tokenJson = require("../artifacts/contracts/Erc.sol/EPAMToken.json")
//после компиляции у нас есть json, который описывает контракт. abi- application binary interface. Описывает то, что имеется в контракте.

describe("EPAMShop", function () {
    let owner
    let buyer
    let shop
    let erc20
    
    beforeEach (async function() {
        [owner, buyer] = await ethers.getSigners()

        const EPAMShop = await ethers.getContractFactory("EPAMShop", owner)
        shop = await EPAMShop.deploy()
        await shop.waitForDeployment()

        erc20 = new ethers.Contract(await shop.token(), tokenJson.abi, owner)
        //erc20 - это образец нашего смарт контракта, который развернут у нас в блокчейне,
        //относительно которого мы можем вызывать все те функции, которые перечислены в abi
    })

    it("should have an owner and a token", async function() {
        expect(await shop.owner()).to.eq(owner.address)

        expect(await shop.token()).to.be.properAddress
    })

    it("allows to buy", async function() {
        const tokenAmount = 3

        const txData = {
            value: tokenAmount,
            to: shop.getAddress()
        }

        const tx = await buyer.sendTransaction(txData)
        await tx.wait

        expect(await erc20.balanceOf(buyer.address)).to.eq(tokenAmount)

        await expect(() => tx)
            .to.changeEtherBalance(shop, tokenAmount)
        
        await expect(tx)
            .to.emit(shop, "Bought")
            .withArgs(tokenAmount, buyer.address)
    })

    it("allows to sell", async function() {
        const tx = await buyer.sendTransaction({
            value: 3,
            to: shop.getAddress()
        })
        await tx.wait()

        const sellAmount = 2

        const approval = await erc20.connect(buyer).approve(shop.getAddress(), sellAmount)

        await approval.wait()

        const sellTx = await shop.connect(buyer).sell(sellAmount)

        expect(await erc20.balanceOf(buyer.address)).to.eq(1)

        await expect(() => sellTx)
             .to.changeEtherBalance(shop, -sellAmount)
        
        await expect(sellTx)
             .to.emit(shop, "Sold")
             .withArgs(sellAmount, buyer.address)
    })
})