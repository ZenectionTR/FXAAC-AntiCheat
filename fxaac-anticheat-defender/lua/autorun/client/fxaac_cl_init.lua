-- autorun/client/anticheat.lua
hook.Add("Think", "CheckPlayerSpeed", function()
    local maxSpeed = 600 -- Maksimum hız limiti (ayarlanabilir)
    local ply = LocalPlayer()

    -- Oyuncunun hızını kontrol eder
    if ply:GetVelocity():Length() > maxSpeed then
        chat.AddText(Color(255, 0, 0), "[Anti-Cheat]: ", Color(255, 255, 255), "Hız sınırını aşıyorsunuz!")
        -- Hız sınırını aşan herhangi bir hareketi iptal edebilirsiniz:
        -- ply:SetVelocity(Vector(0, 0, 0))
    end
end)