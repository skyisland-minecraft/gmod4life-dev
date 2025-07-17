WarnSystem = WarnSystem or {}
include("warnsystem/sh_config.lua")
include("warnsystem/sh_util.lua")

if SERVER then
    include("warnsystem/sv_warnsystem.lua")
    AddCSLuaFile("warnsystem/cl_warnsystem.lua")
    AddCSLuaFile("warnsystem/sh_config.lua")
    AddCSLuaFile("warnsystem/sh_util.lua")
else
    include("warnsystem/cl_warnsystem.lua")
end