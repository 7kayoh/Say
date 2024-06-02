local Package = script.Parent
local Packages = Package.Parent

local Symbol = require(Packages.Symbol)

return {
    SceneIdle = Symbol("Idle"),
    ScenePlayed = Symbol("Played"),
    SceneCharacterIsAsking = Symbol("CharacterIsAsking"),
    SceneProtagonistIsReplying = Symbol("ProtagonistIsReplying"),
    SceneCharacterIsReplying = Symbol("CharacterIsReplying"),
}