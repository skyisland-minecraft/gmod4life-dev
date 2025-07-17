WarnSystem.Config = {
    -- Configuration générale
    MaxWarns = 5, -- Nombre maximum de warns avant ban
    DefaultWarnDuration = 604800, -- 7 jours en secondes
    
    -- Sanctions automatiques
    AutoActions = {
        [3] = {type = "kick", message = "Trop d'avertissements - Kick automatique"},
        [4] = {type = "ban", duration = 3600, message = "Ban temporaire - 1 heure"},
        [5] = {type = "ban", duration = 86400, message = "Ban temporaire - 24 heures"},
        [6] = {type = "ban", duration = 0, message = "Ban permanent - Trop d'avertissements"}
    },
    
    -- Permissions (compatibilité ULX/SAM)
    WarnPermission = "ulx warn",
    UnwarnPermission = "ulx unwarn",
    ViewWarnsPermission = "ulx seeuserinfo",
    
    -- Couleurs interface
    Colors = {
        Primary = Color(52, 152, 219),
        Success = Color(46, 204, 113),
        Warning = Color(241, 196, 15),
        Danger = Color(231, 76, 60),
        Dark = Color(44, 62, 80),
        Light = Color(236, 240, 241)
    },
    
    -- Base de données
    DatabaseType = "sqlite", -- "sqlite" ou "mysql"
    MySQLConfig = {
        hostname = "localhost",
        username = "root",
        password = "",
        database = "gmod_warns",
        port = 3306
    },
    
    -- Logs
    EnableLogs = true,
    LogFile = "warnsystem_logs.txt",
    
    -- Raisons prédéfinies
    PredefinedReasons = {
        "Freekill",
        "Nocollide abusif",
        "Propos déplacés",
        "Non-respect du RP",
        "Spam micro/chat",
        "Contournement de règles",
        "Comportement toxique",
        "Autre"
    }
}