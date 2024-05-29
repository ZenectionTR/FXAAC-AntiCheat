-- modules/functions.lua
local base = require("modules/base")

local functions = {}

-- Send a message to Discord
function functions.sendDiscordMessage(message)
    http.Post(base.config.discordWebhookURL, {
        content = message
    })
end

return functions