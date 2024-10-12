# Discord Role Checker for FiveM

This script allows you to check if a player has specific Discord roles when they join your FiveM server. It provides functionality to restrict access to certain features, such as vehicles and weapons, based on their Discord roles.

## Features

- Check for Discord roles using a bot token.
- Restrict access to features based on role presence.
- Easy installation and setup process.

## Installation

### Step 1: Create the Resource Folder

1. Navigate to your FiveM server's `resources` directory.
2. Create a new folder named `DiscordRoleChecker`.

### Step 2: Create `fxmanifest.lua`

1. Inside the `DiscordRoleChecker` folder, create a file named `fxmanifest.lua` with the following content:

    ```lua
    fx_version 'cerulean'
    game 'gta5'

    author 'Bizarre'
    description 'Discord Role Checker'
    version '1.0.0'

    client_script 'role_checker.lua'
    ```

### Step 3: Create `role_checker.lua`

1. In the same folder, create a file named `role_checker.lua` and add the following code:

    ```lua
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
    ```

### Step 4: Fill in Your Bot Token and Guild ID

- **Bot Token**: Replace `YOUR_BOT_TOKEN_HERE` with your actual Discord bot token.
- **Guild ID**: Replace `YOUR_GUILD_ID` with your Discord server (guild) ID.

### Step 5: Add the Resource to Your Server

1. Open your `server.cfg` file (found in the main server directory).
2. Add the following line at the bottom:

    ```plaintext
    start DiscordRoleChecker
    ```

### Step 6: Restart Your Server

- Restart your FiveM server to load the new resource.

## Usage

In-game, players can use the command:


Replace `<DiscordToken>` with their Discord token and `<RoleID>` with the role ID they want to check.

## Important Notes

- Keep your Discord bot token secret.
- Ensure that your server has access to the required libraries (like `socket` and `json`).
- This script was created by Bizarre. For more information, visit [GitHub](https://github.com/bizarredevs).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
