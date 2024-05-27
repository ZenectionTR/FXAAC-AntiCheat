local admin = {}

function admin.notifyAdmins(message)
    if not istable(player.GetAll()) then return end

    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:IsAdmin() then
            ply:ChatPrint(message)
        end
    end
end

function admin.isAdmin(ply)
    return IsValid(ply) and ply:IsAdmin()
end

return admin