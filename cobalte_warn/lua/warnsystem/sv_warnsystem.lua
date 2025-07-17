if not SERVER then return end

util.AddNetworkString("WarnSystem_OpenMenu")
util.AddNetworkString("WarnSystem_WarnPlayer")
util.AddNetworkString("WarnSystem_UnwarnPlayer")
util.AddNetworkString("WarnSystem_GetWarns")
util.AddNetworkString("WarnSystem_SendWarns")
util.AddNetworkString("WarnSystem_ContestWarn")

local function InitDatabase()
    if WarnSystem.Config.DatabaseType == "sqlite" then
        sql.Query([[
            CREATE TABLE IF NOT EXISTS warnsystem_warns (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                steamid VARCHAR(20) NOT NULL,
                admin_steamid VARCHAR(20) NOT NULL,
                reason TEXT NOT NULL,
                date INTEGER NOT NULL,
                duration INTEGER DEFAULT 0,
                active BOOLEAN DEFAULT 1,
                contested BOOLEAN DEFAULT 0
            )
        ]])
    else
        require("mysqloo")
    end
end
hook.Add("Initialize", "WarnSystem_Init", InitDatabase)
WarnSystem.Data = WarnSystem.Data or {}

function WarnSystem.AddWarn(target, admin, reason, duration)
    if not IsValid(target) or not IsValid(admin) then return false end
    
    duration = duration or WarnSystem.Config.DefaultWarnDuration
    local timestamp = os.time()
    
    -- Insertion en base
    local query = sql.Query(string.format([[
        INSERT INTO warnsystem_warns (steamid, admin_steamid, reason, date, duration, active)
        VALUES ('%s', '%s', '%s', %d, %d, 1)
    ]], target:SteamID(), admin:SteamID(), sql.SQLStr(reason), timestamp, duration))
    
    -- Log
    if WarnSystem.Config.EnableLogs then
        WarnSystem.Log(string.format("[WARN] %s warned %s for: %s", 
            admin:Nick(), target:Nick(), reason))
    end
    target:ChatPrint("[WARN] Vous avez reçu un avertissement: " .. reason)
    admin:ChatPrint("[WARN] Avertissement donné à " .. target:Nick())
    WarnSystem.CheckAutoActions(target)
    return true
end
function WarnSystem.RemoveWarn(warnid, admin)
    if not warnid or not IsValid(admin) then return false end
    local query = sql.Query(string.format([[
        UPDATE warnsystem_warns SET active = 0 WHERE id = %d
    ]], warnid))
    if WarnSystem.Config.EnableLogs then
        WarnSystem.Log(string.format("[UNWARN] %s removed warn ID %d", 
            admin:Nick(), warnid))
    end
    return true
end
function WarnSystem.GetPlayerWarns(ply)
    if not IsValid(ply) then return {} end
    local warns = sql.Query(string.format([[
        SELECT * FROM warnsystem_warns 
        WHERE steamid = '%s' AND active = 1 
        ORDER BY date DESC
    ]], ply:SteamID()))
    
    return warns or {}
end
function WarnSystem.GetActiveWarnsCount(ply)
    if not IsValid(ply) then return 0 end
    local result = sql.Query(string.format([[
        SELECT COUNT(*) as count FROM warnsystem_warns 
        WHERE steamid = '%s' AND active = 1
    ]], ply:SteamID()))
    return result and result[1].count or 0
end
function WarnSystem.CheckAutoActions(ply)
    if not IsValid(ply) then return end
    local warnCount = WarnSystem.GetActiveWarnsCount(ply)
    local action = WarnSystem.Config.AutoActions[warnCount]
    if action then
        timer.Simple(1, function()
            if not IsValid(ply) then return end
            
            if action.type == "kick" then
                ply:Kick(action.message)
            elseif action.type == "ban" then
                if ULib then
                    ULib.ban(ply, action.duration, action.message)
                else
                    ply:Ban(action.duration, action.message)
                end
            end
        end)
    end
end
function WarnSystem.Log(message)
    if not WarnSystem.Config.EnableLogs then return end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("[%s] %s\n", timestamp, message)
    
    file.Append(WarnSystem.Config.LogFile, logMessage)
end
timer.Create("WarnSystem_Cleanup", 300, 0, function()
    sql.Query(string.format([[
        UPDATE warnsystem_warns 
        SET active = 0 
        WHERE active = 1 AND duration > 0 AND (date + duration) < %d
    ]], os.time()))
end)
net.Receive("WarnSystem_WarnPlayer", function(len, ply)
    if not WarnSystem.HasPermission(ply, WarnSystem.Config.WarnPermission) then return end
    
    local targetID = net.ReadString()
    local reason = net.ReadString()
    local duration = net.ReadUInt(32)
    
    local target = player.GetBySteamID(targetID)
    if IsValid(target) then
        WarnSystem.AddWarn(target, ply, reason, duration)
    end
end)
net.Receive("WarnSystem_UnwarnPlayer", function(len, ply)
    if not WarnSystem.HasPermission(ply, WarnSystem.Config.UnwarnPermission) then return end
    
    local warnID = net.ReadUInt(32)
    WarnSystem.RemoveWarn(warnID, ply)
end)
net.Receive("WarnSystem_GetWarns", function(len, ply)
    if not WarnSystem.HasPermission(ply, WarnSystem.Config.ViewWarnsPermission) then return end
    
    local targetID = net.ReadString()
    local target = player.GetBySteamID(targetID)
    
    if IsValid(target) then
        local warns = WarnSystem.GetPlayerWarns(target)
        
        net.Start("WarnSystem_SendWarns")
        net.WriteTable(warns)
        net.Send(ply)
    end
end)
concommand.Add("warn", function(ply, cmd, args)
    if not WarnSystem.HasPermission(ply, WarnSystem.Config.WarnPermission) then return end
    
    if #args < 2 then
        ply:ChatPrint("Usage: warn <joueur> <raison>")
        return
    end
    
    local targetName = args[1]
    local reason = table.concat(args, " ", 2)
    
    local target = WarnSystem.GetPlayerByPartialName(targetName)
    if not IsValid(target) then
        ply:ChatPrint("Joueur introuvable: " .. targetName)
        return
    end
    
    WarnSystem.AddWarn(target, ply, reason)
end)