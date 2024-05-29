-- modules/base.lua
local base = {}

-- Base configuration
base.config = {
    maxSpeed = 600,
    maxJumpSpeed = 1000,
    maxHealth = 100,
    minWeaponSwitchTime = 0.2,
    maxTeleportDistance = 250000, -- squared distance for teleport detection
    discordWebhookURL = "YOUR_DISCORD_WEBHOOK_URL"
}

return base