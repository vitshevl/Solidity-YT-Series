const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("LibDemo", function () {
    let owner
    let demo

    beforeEach (async function() {
        [owner] = await ethers.getSigners()

        const LibDemo = await ethers.getContractFactory("LibDemo", owner)
        demo = await LibDemo.deploy()
        await demo.waitForDeployment()
    })

    it("compares strings", async function(){
        const result = await demo.runnerStr("cat", "cat")
        expect(result).to.eq(true)

        const result2 = await demo.runnerStr("cat", "dog")
        expect(result2).to.eq(false)
    })

    it("finds uint in array", async function(){
        const result = await demo.runnerArr([1,2,3], 2)
        expect(result).to.eq(true)

        const result2 = await demo.runnerArr([1,2,3], 4)
        expect(result2).to.eq(false)
    })
    
})