# Say

Say what? Say is an agnostic dialogue library and is used with your front end together. We use Say at Frappé to create dialogue-based games like the in-development quiz center.

It is a barebone library but under heavy influences of screenplays, adopting names like Character, Line, Protagonist, etc so you can create your game dialogue in a more familiar setting.

___

> [!WARNING]  
> Say is still in its early development stage, breaking changes may be introduced in the meanwhile. We do not expect Say to be used in production.

Add this package to your `dependencies` in your `wally.toml`, for example:
```toml
Say = "7kayoh/say@0.1.0"
```

___

## Example

> [!NOTE]
> This example may not be using the latest version of Say and is only shown to demostrate the basic usage of the library.

```lua
local Say = require(Packages.Say)

local Scene = Say.Scene
local Character = Say.Character
local Symbols = Say.Symbols

local playerCharacter = Character.new(Players.LocalPlayer.Name, {
    Character = Players.LocalPlayer.Character
})
local NPC = Character.new("NPC", {
    Character = workspace.NPC
})
local newScene = Scene.new(playerCharacter)

newScene.DialogueChanged:Connect(function(state, line)
    if state == Symbols.SceneProtagonistIsReplying or state == Symbols.SceneCharacterIsReplying then
        DialogueUI.CharacterName.Text = line.Character.Name
        DialogueUI.DialogueMessage.Text = line.Content
    elseif State == Symbols.SceneProtagonistIsAsking then
        DialogueUI.CharacterName.Text = line.Character.Name
        DialogueUI.DialogueMessage.Text = line.Content

        -- You can either choose to create the choices now (so while the dialogue UI is entering the question text, the user can choose to answer immediately)
        -- Or, have user wait for the content to be fully typed (or skip the effect), and then hide the dialogue UI and show the choices UI (this can be done in other parts, see MouseButton1Click event), kinda like how it is done in most VNs.
    elseif State == Symbols.SceneIdle then
        -- implement your own UI logic here to react to scene state changes!
    end
end)

DialogueUI.NextLineBtn.MouseButton1Click:Connect(function()
    -- You can implement a skip function for the typewriter effect here, if you plan to implement one for your dialogue UI
    -- If so, skip the effect and return for the first time, only proceed with calling NextLine/showing choices once the typewriter effect is finished.

    if State ~= Symbols.SceneProtagonistIsAsking then
        newScene:NextLine()
    else
        -- If you are opting for the VN-style dialogue, you can create the choices list and hide the dialogue UI here
    end
end)

newScene:Say(playerCharacter, "Hey NPC")
newScene:Say(NPC, "Oh hello there " .. playerCharacter.Name)
do
    userChoice = newScene:Ask(NPC, "How is your day?", {
        {
            Action = "Good",
            RespondWith = "I'm doing good."
        },
            {
            Action = "Awful",
            RespondWith = "It's awful."
        }
    }):Wait()

    if userChoice.Action == "Good" then
        newScene:Say(NPC, "Cool.")
        newScene:Say(NPC, "I- I gotta go, I have a train to catch, maybe see you next time.")
    else
        newScene:Say(NPC, "Oh, well, uhm...", function()
            -- OnDialogueCallback gets called when Scene.NextLine is called to jump to this line.
            -- You can do things like play an animation, create an effect, etc, to make the scene more immersive and reactive.
            -- This is also possible to be used in Scene.Ask, just add the function parameter after the choices parameter.
        end)
        newScene:Say(NPC, "I- I gotta go, I have a train to catch, maybe see you next time?")
    end
end
```

## License
Say is available under the MIT license. See [LICENSE](./LICENSE) for details.

## Author
7kayoh and kitsuu-ne