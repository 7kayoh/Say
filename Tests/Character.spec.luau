return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Packages = ReplicatedStorage.Packages
    
    local Say = require(Packages.Say)
    local Character = Say.Character

    describe("new", function()
        it("should create a character with the name", function()
            local testCharacter = Character.new("7kayoh")
            expect(testCharacter.Name == "7kayoh").to.be.ok()
        end)

        it("should create a character with the metadata", function()
            local testCharacter = Character.new("7kayoh", { testIndex = "test" })
            expect(testCharacter.Metadata).to.be.a("table")
            expect(testCharacter.Metadata.testIndex == "test").to.be.ok()
        end)
    end)
end