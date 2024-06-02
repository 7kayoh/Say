local Package = script.Parent
local Packages = Package.Parent

local Dash = require(Packages.Dash)

local Character = Dash.class("Scene", function(name: string, metadata: { [string]: any })
    return {
        Name = name,
        Metadata = metadata,
    }
end)

export type Character = Dash.Class<{
    Name: string,
    Metadata: { [string]: any }
}>

return Character