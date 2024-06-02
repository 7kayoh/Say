local Scene = require(script.Scene)
local Character = require(script.Character)
local Symbols = require(script.Symbols)

export type Scene = Scene.Scene
export type Line = Scene.Line
export type Choice = Scene.Choice
export type Character = Character.Character

return {
    _VERSION = { Major = 0, Minor = 1 },
    Scene = Scene,
    Character = CatalogSearchParams,
    Symbols = Symbols,
}