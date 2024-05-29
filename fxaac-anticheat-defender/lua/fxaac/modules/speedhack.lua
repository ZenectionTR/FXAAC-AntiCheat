-- modules/speedhack.lua
local maxSpeed = 600 -- Maksimum hız limiti (ayarlanabilir)

local function checkPlayerSpeed()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsValid() and ply:Alive() and not ply:IsAdmin() then
            local velocity = ply:GetVelocity():Length()
            if velocity > maxSpeed then
                ply:Kick("Hız hilesi tespit edildi!")
            end
        end
    end
end

hook.Add("Think", "CheckPlayerSpeed", checkPlayerSpeed)