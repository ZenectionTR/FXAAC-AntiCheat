-- autorun/server/anticheat.lua
local function printToConsole(message)
    print("[Server] " .. message)
    -- Eğer konsola mesaj yazdırmak istiyorsanız:
    -- game.ConsoleCommand("echo " .. message .. "\n")
end

-- Hile kontrolü işlevi (örnek olarak hız kontrolü)
local maxSpeed = 600 -- Maksimum hız limiti (ayarlanabilir)
local function checkPlayerSpeed(ply)
    if ply:GetVelocity():Length() > maxSpeed then
		logCheater(ply, "Hız hilesi tespit edildi!")
        ply:Kick("Hız hilesi tespit edildi!")
        -- veya alternatif olarak:
        ply:Ban(0, "Hız hilesi tespit edildi!")
    end
end

-- Hile tespit edilen oyuncu bilgilerini yazmak için fonksiyon
local function logCheater(ply, reason)
    local logMessage = string.format("%s - %s (%s) - %s\n", os.date("%Y-%m-%d %H:%M:%S"), ply:Nick(), ply:SteamID(), reason)
    file.Append("fxaac_cheaters.txt", logMessage)
end

-- FXAAC Online mesajı sunucu başlatıldığında konsola yazdırılır
hook.Add("Initialize", "PrintFXAACMessage", function()
    printToConsole("FXAAC Online - Hile koruma sistemi aktif.")
end)

hook.Add("PlayerSpawn", "CheckPlayerSpeed", function(ply)
    local maxSpeed = 600 -- Maksimum hız limiti (ayarlanabilir)

    -- Oyuncunun hızını kontrol eder
    if ply:GetVelocity():Length() > maxSpeed then
        ply:Kick("Hız hilesi tespit edildi!")
        -- veya alternatif olarak:
        ply:Ban(0, "Hız hilesi tespit edildi!")
    end
end)

-- Hız Hilesi Kontrolü
local maxSpeed = 600 -- Maksimum hız limiti (ayarlanabilir)
local function checkPlayerSpeed(ply)
    if ply:GetVelocity():Length() > maxSpeed then
        ply:Kick("Hız hilesi tespit edildi!")
        -- veya alternatif olarak:
        ply:Ban(0, "Hız hilesi tespit edildi!")
    end
end

hook.Add("PlayerSpawn", "CheckPlayerSpeedOnSpawn", function(ply)
    timer.Simple(1, function() -- Oyuncunun spawn olmasından 1 saniye sonra hız kontrolü yapar
        if IsValid(ply) and ply:IsPlayer() then
            checkPlayerSpeed(ply)
        end
    end)
end)

hook.Add("Move", "CheckPlayerSpeedOnMove", function(ply, mv)
    if ply:IsPlayer() and mv:KeyDown(IN_FORWARD) then
        checkPlayerSpeed(ply)
    end
end)

-- Aimbot Kontrolü
local function checkForAimbot(ply)
    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 10000,
        filter = ply
    })

    -- Eğer hedef oyuncu görüş hattında değilse ve aimbot kullanıyorsa
    if trace.Hit and trace.Entity:IsPlayer() and trace.Entity ~= ply then
		logCheater(ply, "Aimbot tespit edildi!")
        ply:Kick("Aimbot tespit edildi!")
        -- veya alternatif olarak:
        ply:Ban(0, "Aimbot tespit edildi!")
    end
end

hook.Add("Think", "CheckForAimbot", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsValid() and ply:Alive() and not ply:IsAdmin() then
            checkForAimbot(ply)
        end
    end
end)

-- Yüksek Ping Kontrolü
local maxPing = 200 -- Maksimum ping limiti (ayarlanabilir)
local function checkPlayerPing(ply)
    if ply:Ping() > maxPing then
		logCheater(ply, "Yüksek ping tespit edildi!")
        ply:Kick("Yüksek ping tespit edildi!")
    end
end

hook.Add("Think", "CheckPlayerPing", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsValid() and ply:Alive() and not ply:IsAdmin() then
            checkPlayerPing(ply)
        end
    end
end)

-- Triggerbot Kontrolü
local function checkForTriggerbot(ply)
    local trace = ply:GetEyeTrace()
    if trace.Entity:IsPlayer() and ply:GetVelocity():Length() < 5 then
		logCheater(ply, "Triggerbot tespit edildi!")
        ply:Kick("Triggerbot tespit edildi!")
    end
end

hook.Add("PlayerShoot", "CheckTriggerbot", function(ply)
    checkForTriggerbot(ply)
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
			logCheater(attacker, "Duvar hilesi tespit edildi!")
            attacker:Kick("Duvar hilesi tespit edildi!")
        end
    end
end)

local function checkForAimbot(ply)
    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 10000,
        filter = ply
    })

    -- Eğer hedef oyuncu görüş hattında değilse ve aimbot kullanıyorsa
    if trace.Hit and trace.Entity:IsPlayer() and trace.Entity ~= ply then
        ply:Kick("Aimbot tespit edildi!")
        -- veya alternatif olarak:
        ply:Ban(0, "Aimbot tespit edildi!")
    end
end

hook.Add("PlayerSpawn", "CheckPlayerSpeedOnSpawn", function(ply)
    timer.Simple(1, function() -- Oyuncunun spawn olmasından 1 saniye sonra hız kontrolü yapar
        if IsValid(ply) and ply:IsPlayer() then
            checkPlayerSpeed(ply)
            checkForAimbot(ply)
        end
    end)
end)

hook.Add("Move", "CheckPlayerSpeedOnMove", function(ply, mv)
    if ply:IsPlayer() and mv:KeyDown(IN_FORWARD) then
        checkPlayerSpeed(ply)
    end
end)