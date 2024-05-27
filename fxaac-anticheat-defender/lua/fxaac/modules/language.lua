-- modules/language.lua
local language = {}

language.translations = {
    en = {
        detectedCheat = "You have been detected for: ",
        kickedByAntiCheat = "Kicked by Anti-Cheat: ",
        bannedByAntiCheat = "Banned by Anti-Cheat: "
    },
    tr = {
        detectedCheat = "Hile tespit edildi: ",
        kickedByAntiCheat = "Anti-Cheat tarafından atıldınız: ",
        bannedByAntiCheat = "Anti-Cheat tarafından banlandınız: "
    }
}

function language.translate(lang, key)
    return language.translations[lang][key] or key
end

return language