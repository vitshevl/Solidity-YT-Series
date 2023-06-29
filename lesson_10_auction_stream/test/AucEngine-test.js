const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("AucEngine", function () {
    let owner
    let seller
    let buyer
    let auct

    beforeEach (async function() {
        [owner, seller, buyer] = await ethers.getSigners()

        const AucEngine = await ethers.getContractFactory("AucEngine", owner)
        auct = await AucEngine.deploy()
        await auct.waitForDeployment()
    })

    it("sets owner", async function(){
        const currentOwner = await auct.owner()
        console.log(currentOwner)
        expect(currentOwner).to.eq(owner.address)
    })

    async function getTimestamp(bn){
        return (
            await ethers.provider.getBlock(bn)
        ).timestamp

    }

    it("creates auction correctly", async function(){
        const duration = 60
        const tx = await auct.createAuction(
            ethers.parseEther("0.0001"),
            3,
            "fake item",
            duration
          )

        const cAuction = await auct.auctions(0) // Promise
        console.log(cAuction)
        expect(cAuction.item).to.eq("fake item")
        console.log(tx)
        const ts = await getTimestamp(tx.getBlockNumber)
        expect(cAuction.endsAt).to.eq(ts + duration)

    })

    function delay(ms){
        return new Promise (resolve => setTimeout(resolve, ms))
    }

    it("allows to buy", async function(){
        await auct.connect(seller).createAuction(
            ethers.parseEther("0.0001"),
            3,
            "fake item",
            60
          )
          this.timeout(5000) // 5s
          await delay(1000)
          
          const buyTx = await auct.connect(buyer)
            .buy(0,{value: ethers.parseEther("0.0001")})

            const cAuction = await auct.auctions(0)
            const finalPrice = cAuction.finalPrice
            

            await expect(() => buyTx)
                .to.changeEtherBalance(
                    seller, finalPrice - ((finalPrice * BigInt(10)) / BigInt(100))
                )

            await expect(buyTx)
                .to.emit(auct, 'AuctionEnded')
                .withArgs(0, finalPrice, buyer.address);


            await expect(
                auct.connect(buyer)
                    .buy(0,{value: ethers.parseEther("0.0001")})
            ).to.be.revertedWith('stopped!')    
    })
    
})