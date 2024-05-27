-- modules/aimbot.lua
local function isAimbotDetected(ply)
    local aimVector = ply:GetAimVector()
    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + aimVector * 10000,
        filter = ply
    })

    if trace.Hit and trace.Entity:IsPlayer() and trace.Entity ~= ply then
        return true
    end
    return false
end

hook.Add("Think", "CheckForAimbot", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsValid() and ply:Alive() and not ply:IsAdmin() then
            if isAimbotDetected(ply) then
                ply:Kick("Aimbot tespit edildi!")
            end
        end
    end
end)