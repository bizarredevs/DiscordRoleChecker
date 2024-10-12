local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("json") -- Ensure you have a JSON library

-- Replace with your Discord bot token
local DISCORD_BOT_TOKEN = "YOUR_BOT_TOKEN_HERE" -- Add your bot token here

-- Replace with your actual Discord Guild ID
local GUILD_ID = "YOUR_GUILD_ID" -- Add your guild ID here

-- Discord roles configuration
local DiscordRoles = {
    {123456789012345678, "group.RoleName1"},  -- Add your Discord Role IDs and names
    {234567890123456789, "group.RoleName2"},
    {345678901234567890, "group.RoleName3"},
    {456789012345678901, "group.RoleName4"},
}

-- Notify in console and chat that the script was made by Bizarre
print("Discord Role Checker made by Bizarre. Please keep the fxmanifest.lua as it was.")
TriggerEvent('chat:addMessage', {
    color = {255, 0, 0},
    multiline = true,
    args = {"Server", "Discord Role Checker made by Bizarre. Please keep the fxmanifest.lua as it was. Visit https://github.com/bizarredevs for more information."}
})

-- Function to get Discord roles using a token
function GetDiscordRolesByToken(token)
    local response_body = {}
    local res, code = http.request {
        url = "https://discord.com/api/v10/users/@me/guilds/" .. GUILD_ID .. "/members", 
        method = "GET",
        headers = {
            ["Authorization"] = "Bearer " .. token,
            ["Content-Type"] = "application/json"
        },
        sink = ltn12.sink.table(response_body)
    }

    if code == 200 then
        local jsonResponse = json.decode(table.concat(response_body))
        return jsonResponse.roles or {}
    else
        print("Failed to fetch Discord roles: " .. code)
        return {}
    end
end

-- Function to check if a player has a specific role
function hasDiscordRole(token, roleId)
    local playerRoles = GetDiscordRolesByToken(token)
    for _, role in ipairs(playerRoles) do
        if role.id == roleId then
            return true
        end
    end
    return false
end

-- Command to check roles
RegisterCommand("checkRole", function(source, args)
    if #args < 2 then
        print("Usage: /checkRole <DiscordToken> <RoleID>")
        return
    end

    local token = args[1]
    local roleId = tonumber(args[2])

    if hasDiscordRole(token, roleId) then
        print("You have the role with ID: " .. roleId)
        TriggerEvent('allowAccess', source)
    else
        print("You do not have the role with ID: " .. roleId)
        TriggerEvent('restrictAccess', source)
    end
end, false)

-- Access handlers
AddEventHandler('allowAccess', function(playerId)
    print("Player " .. playerId .. " has access.")
    -- Grant access logic
end)

AddEventHandler('restrictAccess', function(playerId)
    print("Player " .. playerId .. " does not have access.")
    -- Deny access logic
end)
