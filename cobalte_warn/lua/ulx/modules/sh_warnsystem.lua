if not ulx then return end

local CATEGORY_NAME = "Warning System"

function ulx.warn(calling_ply, target_ply, reason, duration)
    duration = duration or WarnSystem.Config.DefaultWarnDuration
    
    if SERVER then
        WarnSystem.AddWarn(target_ply, calling_ply, reason, duration)
    end
    
    ulx.fancyLogAdmin(calling_ply, "#A warned #T for: #s", target_ply, reason)
end

local warn = ulx.command(CATEGORY_NAME, "ulx warn", ulx.warn, "!warn")
warn:addParam{type = ULib.cmds.PlayerArg}
warn:addParam{type = ULib.cmds.StringArg, hint = "reason"}
warn:addParam{type = ULib.cmds.NumArg, hint = "duration (seconds)", ULib.cmds.optional, min = 0}
warn:defaultAccess(ULib.ACCESS_ADMIN)
warn:help("Warn a player")

function ulx.unwarn(calling_ply, warn_id)
    if SERVER then
        WarnSystem.RemoveWarn(warn_id, calling_ply)
    end
    
    ulx.fancyLogAdmin(calling_ply, "#A removed warn ID: #s", warn_id)
end

local unwarn = ulx.command(CATEGORY_NAME, "ulx unwarn", ulx.unwarn, "!unwarn")
unwarn:addParam{type = ULib.cmds.NumArg, hint = "warn ID"}
unwarn:defaultAccess(ULib.ACCESS_ADMIN)
unwarn:help("Remove a warn by ID")

function ulx.warnmenu(calling_ply)
    if CLIENT then
        WarnSystem.OpenWarnMenu()
    else
        net.Start("WarnSystem_OpenMenu")
        net.Send(calling_ply)
    end
end

local warnmenu = ulx.command(CATEGORY_NAME, "ulx warnmenu", ulx.warnmenu, "!warnmenu")
warnmenu:defaultAccess(ULib.ACCESS_ADMIN)
warnmenu:help("Open warn menu")