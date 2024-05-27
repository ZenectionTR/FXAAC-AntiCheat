-- modules/anticheat.lua
local admin = require("autorun/modules/admin")
local functions = require("autorun/modules/functions")
local base = require("autorun/modules/base")

local anticheat = {}

-- Log suspicious activity and take action
function anticheat.logSuspiciousActivity(ply, reason, action)
    local logMessage = "[FXAAC] " .. ply:Nick() .. " (" .. ply:SteamID() .. ") detected for " .. reason
    print(logMessage)

    -- Send to Discord
    functions.sendDiscordMessage(logMessage)

    -- Notify admins in-game
    admin.notifyAdmins(logMessage)

    -- Notify the player
    ply:ChatPrint("You have been detected for: " .. reason)

    -- Take action
    if action == "kick" then
        ply:Kick("Kicked by Anti-Cheat: " .. reason)
    elseif action == "ban" then
        ply:Ban(0, "Banned by Anti-Cheat: " .. reason)
    end
end

return anticheat