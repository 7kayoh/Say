local Package = script.Parent
local Packages = Package.Parent

local Dash = require(Packages.Dash)
local Signal = require(Packages.Signal)
local Symbol = require(Packages.Symbol)
local Character = require(script.Parent.Character)
local Symbols = require(script.Parent.Symbols)

local Scene = Dash.class("Scene", function(you: Character.Character?)
    return {
        DialogueChanged = Signal.new(),
        Destroying = Signal.new(),

        State = Symbols.SceneIdle,
        CurrentLineNumber = 0,
        Lines = {},
        Protagonist = you or Character.new("you"),
    }
end) :: Scene

export type Scene = Dash.Class<{
    DialogueChanged: Signal.Signal<Symbol.Symbol, Line>,
    Destroying: Signal.Signal<>,

    State: Symbol.Symbol,
    CurrentLineNumber: number,
    Lines: { Line },
    Protagonist: Character.Character,

    Say: (Scene, Character.Character, string, () -> ()?) -> (),
    Ask: (Scene, Character.Character, string, { Choice }, () -> ()?) -> (Signal.Signal<Choice>),
    Respond: (Choice) -> (),
    NextLine: (Scene) -> (),
}>

export type Choice = {
    Action: string,
    RespondWith: string?,
}

export type Line = {
    Character: Character.Character,
    Content: string,
    Choices: { Choice }?,
    RespondSignal: Signal.Signal<Choice>?,
    OnDialogueCallback: () -> ()?,
}

function Scene:Say(character, message, onDialogueCallback)
    table.insert(self.Lines, {
        Character = character,
        Content = tostring(message),
    })
end

function Scene:Ask(character, question, choices, onDialogueCallback)
    if character == self.Protagonist then
        error("Scene:ask() is for interactive question, requiring the protagonist (a.k.a the player) to answer, not NPCs")
    end
    
    local line = {
        Character = character,
        Content = tostring(question),
        Choices = choices,
        RespondSignal = Signal.new()
    }
    table.insert(self.Lines, line)

    return line.RespondSignal
end

function Scene:Respond(choice: Choice)
    if self.State ~= Symbols.SceneCharacterIsAsking then
        error("Character should be asking the protagonist a question in the scene first in order to respond")
    end

    local currentLine = self.Lines[self.CurrentLine]
    for index, acceptableChoice in currentLine.Choices do
        if acceptableChoice == choice then
            currentLine.RespondSignal:Fire(choice)

            if choice.RespondWith then
                self:say(self.Protagonist, acceptableChoice.RespondWith)
            end
        end
    end
end

function Scene:NextLine()
    if self.State == Symbols.SceneCharacterIsAsking then
        error("Scene is required to wait for protagonist response before continuing")
    else
        local nextLine = self.Lines[self.CurrentLineNumber + 1] :: Line?
        if nextLine then
            self.CurrentLineNumber += 1
            if nextLine.Character == self.Protagonist then
                self.State = Symbols.SceneProtagonistIsReplying
            else
                if nextLine.Choices then
                    self.State = Symbols.SceneCharacterIsAsking
                else
                    self.State = Symbols.SceneCharacterIsReplying
                end
            end

            if nextLine.OnDialogueCallback then
                nextLine.OnDialogueCallback()
            end
        else
            self.State = Symbols.SceneIdle
        end

        self.DialogueChanged:Fire(self.State, self.Lines[self.CurrentLineNumber])
    end
end

return Scene