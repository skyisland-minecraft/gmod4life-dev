function WarnSystem.HasPermission(ply, permission)
    if not IsValid(ply) then return false end
    
    -- Vérification ULX
    if ULib and ULib.ucl then
        return ULib.ucl.query(ply, permission)
    end
    
    -- Vérification SAM
    if sam and sam.permissions then
        return sam.permissions.has_permission(ply, permission)
    end
    
    -- Fallback - vérification admin
    return ply:IsAdmin()
end

function WarnSystem.FormatTime(seconds)
    if seconds <= 0 then return "Permanent" end
    
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    
    if days > 0 then
        return days .. " jour(s), " .. hours .. " heure(s)"
    elseif hours > 0 then
        return hours .. " heure(s), " .. minutes .. " minute(s)"
    else
        return minutes .. " minute(s)"
    end
end

function WarnSystem.GetPlayerByPartialName(name)
    if not name or name == "" then return nil end
    
    local found = {}
    name = string.lower(name)
    
    for _, ply in ipairs(player.GetAll()) do
        if string.find(string.lower(ply:Nick()), name, 1, true) then
            table.insert(found, ply)
        end
    end
    
    return #found == 1 and found[1] or nil
end