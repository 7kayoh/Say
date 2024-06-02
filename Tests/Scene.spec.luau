return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Packages = ReplicatedStorage.Packages
    
    local Say = require(Packages.Say)
    local Scene = Say.Scene
    local Character = Say.Character

    describe("new", function()
        it("should create a new scene with a protagonist", function()
            local testCharacter = Character.new("7kayoh")
            local testScene = Scene.new(testCharacter)
            expect(testScene.Protagonist == testCharacter).to.be.ok()
        end)

        it("should create a new scene with a new protagonist", function()
            local testScene = Scene.new()
            expect(testScene.Protagonist).to.be.ok()
        end)

        -- TODO: finish the rest of the tests
    end)
end