-- Role Checker Script for FiveM
local DiscordRoles = {
    {123456789012345678, "group.RoleName1"},  -- Replace with actual Discord Role ID and name
    {234567890123456789, "group.RoleName2"},
    {345678901234567890, "group.RoleName3"},
    {456789012345678901, "group.RoleName4"},
}

-- Function to check if a player has a specific role
function hasDiscordRole(playerId, roleId)
    local playerRoles = GetPlayerDiscordRoles(playerId) -- Assuming this function exists to get player roles
    for _, role in ipairs(playerRoles) do
        if role == roleId then
            return true
        end
    end
    return false
end

-- Example of restricting vehicle access based on roles
AddEventHandler('playerSpawned', function()
    local playerId = source
    for _, role in ipairs(DiscordRoles) do
        local roleId, roleName = role[1], role[2]
        if hasDiscordRole(playerId, roleId) then
            -- Allow access to vehicles or features
            print("Player " .. playerId .. " has access to " .. roleName)
            -- Here you can add more functionality to give access
        else
            -- Restrict access
            print("Player " .. playerId .. " does not have access to " .. roleName)
            -- Implement restrictions here
        end
    end
end)

-- Function to get Discord roles for a player (This is a placeholder)
function GetPlayerDiscordRoles(playerId)
    -- Here you will implement the logic to get roles from Discord
    return {}  -- Return the roles as an array of role IDs
end
