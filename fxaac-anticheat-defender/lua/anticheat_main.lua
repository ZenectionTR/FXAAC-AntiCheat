local admin = require("fxaac/modules/admin")
local anticheat = require("fxaac/modules/anticheat")
local banbypass = require("fxaac/modules/banbypass")
local base = require("fxaac/modules/base")
local config = require("fxaac/modules/config")
local custom = require("fxaac/modules/custom")
local exploit = require("fxaac/modules/exploit")
local functions = require("fxaac/modules/functions")
local language = require("fxaac/modules/language")
local networking = require("fxaac/modules/networking")
local security = require("fxaac/modules/security")
local server = require("fxaac/modules/server")

-- Check player speed for speedhack
hook.Add("Think", "CheckPlayerSpeed", function()
    if not config.settings.enableAntiCheat then return end

    for _, ply in ipairs(player.GetAll()) do
        if ply:IsValid() and ply:Alive() and not admin.isAdmin(ply) then
            local velocity = ply:GetVelocity():Length()
            if velocity > base.config.maxSpeed then
                anticheat.logSuspiciousActivity(ply, "speedhack (velocity: " .. velocity .. ")", "kick")
            end
        end
    end
end)

-- Check for weapon speed hacks
hook.Add("PlayerSwitchWeapon", "CheckWeaponSwitch", function(ply, oldWeapon, newWeapon)
    if not config.settings.enableAntiCheat then return end

    if not admin.isAdmin(ply) then
        local currentTime = CurTime()
        if ply.lastWeaponSwitch and (currentTime - ply.lastWeaponSwitch < base.config.minWeaponSwitchTime) then
            anticheat.logSuspiciousActivity(ply, "weapon switch hack", "kick")
        end
        ply.lastWeaponSwitch = currentTime
    end
end)

-- Check for high jumps
hook.Add("OnPlayerHitGround", "CheckHighJumps", function(ply, inWater, onFloater, speed)
    if not config.settings.enableAntiCheat then return end

    if not admin.isAdmin(ply) then
        if speed > base.config.maxJumpSpeed then
            anticheat.logSuspiciousActivity(ply, "high jump (speed: " .. speed .. ")", "kick")
        end
    end
end)

-- Check for noclip usage
hook.Add("PlayerNoClip", "CheckNoclip", function(ply, desiredState)
    if not config.settings.enableAntiCheat then return end

    if not admin.isAdmin(ply) and desiredState then
        anticheat.logSuspiciousActivity(ply, "noclip hack", "kick")
        return false
    end
end)

-- Check for teleportation
hook.Add("PlayerPostThink", "CheckTeleportation", function(ply)
    if not config.settings.enableAntiCheat then return end

    if not admin.isAdmin(ply) then
        if not ply.lastPosition then
            ply.lastPosition = ply:GetPos()
            return
        end

        local distance = ply:GetPos():DistToSqr(ply.lastPosition)
        if distance > base.config.maxTeleportDistance then
            anticheat.logSuspiciousActivity(ply, "teleportation hack (distance: " .. distance .. ")", "kick")
        end

        ply.lastPosition = ply:GetPos()
    end
end)

-- Check for aimbot
hook.Add("StartCommand", "CheckAimbot", function(ply, cmd)
    if not config.settings.enableAntiCheat then return end

    if not admin.isAdmin(ply) and ply:Alive() then
        local aimVector = cmd:GetViewAngles()
        local aimDirection = aimVector:Forward()

        for _, target in ipairs(player.GetAll()) do
            if target ~= ply and target:Alive() then
                local targetDirection = (target:GetPos() - ply:GetPos()):GetNormalized()
                local dotProduct = aimDirection:Dot(targetDirection)

                if dotProduct > 0.95 then -- Adjust threshold as needed
                    anticheat.logSuspiciousActivity(ply, "aimbot detection", "kick")
                    break
                end
            end
        end
    end
end)

-- Duvar Hilesi Kontrolü
hook.Add("EntityTakeDamage", "CheckWallhack", function(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if attacker:IsPlayer() and target:IsPlayer() then
        local trace = util.TraceLine({
            start = attacker:GetShootPos(),
            endpos = target:GetShootPos(),
            filter = attacker
        })

        if trace.HitWorld then
            attacker:Kick("Duvar hilesi tespit edildi!")
        end
    end
end)

-- Otomatik Atış (Triggerbot) Kontrolü
hook.Add("PlayerShoot", "CheckTriggerbot", function(ply)
    local trace = ply:GetEyeTrace()
    if trace.Entity:IsPlayer() and ply:GetVelocity():Length() < 5 then
        ply:Kick("Triggerbot tespit edildi!")
    end
end)

-- Yüksek Ping Kontrolü
hook.Add("Think", "CheckPlayerPing", function()
    local maxPing = 200 -- Maksimum ping limiti
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsValid() and ply:Alive() and not ply:IsAdmin() then
            if ply:Ping() > maxPing then
                ply:Kick("Yüksek ping tespit edildi!")
            end
        end
    end
end)

-- Konsola Bilgilendirme Mesajı
hook.Add("Initialize", "PrintAntiCheatMessage", function()
    print("FXAAC Online - Hile koruma sistemi aktif.")
end)

-- Konsola Bilgilendirme Mesajı
hook.Add("Initialize", "PrintAntiCheatMessage", function()
    print("FXAAC Online - Hile koruma sistemi aktif.")
end)

-- Check for health hacks
hook.Add("PlayerTick", "CheckHealth", function(ply)
    if not config.settings.enableAntiCheat then return end

    if not admin.isAdmin(ply) and ply:Alive() then
        if ply:Health() > base.config.maxHealth then
            anticheat.logSuspiciousActivity(ply, "health hack (health: " .. ply:Health() .. ")", "kick")
        end
    end
end)

-- Load message
print("[Anti-Cheat] Modular anti-cheat system loaded.")