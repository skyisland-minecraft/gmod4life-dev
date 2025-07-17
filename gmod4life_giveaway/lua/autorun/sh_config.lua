Gmod4Life = Gmod4Life or {}
Gmod4Life.Giveaway = Gmod4Life.Giveaway or {}

Gmod4Life.Giveaway.Config = {
    enabled = true, -- Active (ou pas) l'addons
    interval = 1800, -- (en secondes) 1800 = 30 minutes
    min_players = 5, -- Nombre minimum de joueurs pour lancer le giveaway
    max_players = 0, -- Nombre maximum de joueurs pouvant participer au giveaway
    trigger_chance = 0.8, -- Probabilité de déclencher le giveaway (0.0 à 1.0)
    exclude_admins = false, -- Exclure les admins du giveaway
    min_connection_time = 300, -- Temps minimum de connexion (en secondes) pour participer au giveaway
    player_cooldown = 7200, -- Temps de cooldown (en secondes) entre les giveaway d'un joueur
    prefix = "[Gmod4Life Giveaway] ", -- Préfixe pour les messages de l'addon
    colors = {
        prefix = Color(255, 100, 100),
        winner = Color(100, 255, 100),
        info = Color(100, 100, 255),
        warning = Color(255, 200, 100),
    }
}

Gmod4Life.Giveaway.Rewards = {
    {
        name = "Boîte Mystère Premium",
        weight = 30, -- Poids pour la probabilité (plus élevé = plus probable)
        commands = {
            "sam givebox \"%winner%\" 1",
            "ulx logecho \"%winner%\" a reçu une boîte mystère premium via giveaway"
        },
        announcement = "%winner% a remporté une Boîte Mystère Premium !"
    },
    
    {
        name = "Argent Bonus",
        weight = 40,
        commands = {
            "darkrp_addmoney \"%winner%\" 50000",
            "ulx logecho \"%winner%\" a reçu 50000$ via giveaway"
        },
        announcement = "%winner% a remporté 50,000$ !"
    },
    
    {
        name = "Véhicule Permanent",
        weight = 15,
        commands = {
            "sam givecar \"%winner%\" supercar",
            "ulx logecho \"%winner%\" a reçu un véhicule permanent via giveaway"
        },
        announcement = "%winner% a remporté un véhicule permanent !"
    },
    
    {
        name = "Pack d'Armes VIP",
        weight = 25,
        commands = {
            "sam giveweaponpack \"%winner%\" vip",
            "ulx logecho \"%winner%\" a reçu un pack d'armes VIP via giveaway"
        },
        announcement = "%winner% a remporté un pack d'armes VIP !"
    },
    
    {
        name = "Boost XP 2x",
        weight = 35,
        commands = {
            "sam giveboost \"%winner%\" xp 2 3600",
            "ulx logecho \"%winner%\" a reçu un boost XP 2x via giveaway"
        },
        announcement = "%winner% a remporté un boost XP 2x pendant 1 heure !"
    },
    
    {
        name = "Jackpot Spécial",
        weight = 5, -- Très rare
        commands = {
            "darkrp_addmoney \"%winner%\" 500000",
            "sam givebox \"%winner%\" 5",
            "ulx logecho \"%winner%\" a gagné le JACKPOT SPÉCIAL via giveaway"
        },
        announcement = "🎉 JACKPOT SPÉCIAL ! %winner% a remporté 500,000$ + 5 boîtes mystères ! 🎉"
    }
}

Gmod4Life.Giveaway.Messages = {
    starting = "Un giveaway va bientôt commencer ! Restez connectés pour participer !",
    winner_announce = "Félicitations à %winner% pour avoir remporté : %reward% !",
    better_luck = "Pas de chance cette fois ! Le prochain giveaway aura lieu dans %time% minutes.",
    not_enough_players = "Pas assez de joueurs pour lancer le giveaway. Rejoignez-nous pour augmenter vos chances !",
    disabled = "Le giveaway est actuellement désactivé. Revenez plus tard !",
    countdown = "Le giveaway commence dans %time% secondes ! Préparez-vous !",
    error = "Une erreur est survenue lors du lancement du giveaway. Veuillez réessayer plus tard. ERREUR : %error%"
}

Gmod4Life.Giveaway.AdminCommands = {
    force_command = "!g4l_giveaway_force",
    toggle_command = "!g4l_giveaway_toggle",
    stats_command = "!g4l_giveaway_status",
    reset_cooldonws = "!g4l_giveaway_reset_cooldowns",
    min_rank = "admin", -- Le rang minimum requis pour exécuter les commandes admin
}

Gmod4Life.Giveaway.Integration = {
    darkrp = true,
    ulx = true,
    sam = true,
    afk_addon = "g4l_afk",
    logging = true,
    discord_webhook = {
        enabled = false,
        url = "",
        username = "Gmod4Life Giveaway",
        avatar_url = ""
    }
}

Gmod4Life.Giveaway.SpecialEvents = {
    happy_hours = {
        enabled = true,
        hours = {18, 19, 20, 21},
        multiplier = 2.0,
        message = "C'est l'heure dubonheur ! Récompenses doublées !"
    },

    custom_events = {
        ["12-25"] = { -- Noël
            name = "Événement de Noël",
            multiplier = 3.0,
            special_rewards = true,
            message = "🎄 Événement de Noël ! Récompenses triplées ! 🎄"
        },
        ["01-01"] = { -- Nouvel An
            name = "Nouvel An",
            multiplier = 2.5,
            special_rewards = true,
            message = "🎊 Bonne année ! Récompenses améliorées ! 🎊"
        }
    }
}

Gmod4Life.Giveaway.Stats = {
    save_stats = true,
    stats_file = "gmod4life_giveaway_stats.json",
    reset_stats_days = 30,
    show_top_winners = true,
    top_winners_count = 10,
}

Gmod4Life.Giveaway.Blacklist = {
    players = {
        -- "766565123456789", -- Exemple de SteamID64 à exclure
    },
    excluded_groups = {
        -- "banned",
        -- "restricted"
    },
    check_bans = true,
    exclude_recent_warns = {
        enabled = true,
        days = 7,
        max_warns = 3
    }
}

Gmod4Life.Giveaway.Advanced = {
    dynamic_weights = false,
    playtime_bonus = {
        enabled = true,
        hours_for_bonus = 10, -- 10 heure de jeu 
        bonus_weight = 1.5
    },
    loyalty_system = {
        enabled = true,
        days_for_bonus = 30,
        bonus_weight = 1.3,
    },
    anti_cheat = {
        enabled = true,
        max_wins_per_day = 3,
        detect_alts = true
    }
}

function Gmod4Life.Giveaway.ValidateConfig()
    local config = Gmod4Life.Giveaway.Config
    if config.interval < 60 then
        config.interval = 60
        print("[Gmod4Life Giveaway] Attention : Intervalle trop court, ajusté à 60 secondes")
    end
    if config.min_players < 1 then
        config.min_players = 1
        print("[Gmod4Life Giveaway] Attention : Nombre minimum de joueurs ajusté à 1")
    end
    if config.trigger_chance < 0 or config.trigger_chance > 1 then
        config.trigger_chance = 0.8
        print("[Gmod4Life Giveaway] Attention : Probabilité ajustée à 0.8")
    end
    local total_weight = 0
    for _, reward in ipairs(Gmod4Life.Giveaway.Rewards) do
        total_weight = total_weight + reward.weight
    end
    if total_weight == 0 then
        print("[Gmod4Life Giveaway] ERREUR : Aucune récompense configurée !")
        return false
    end
    print("[Gmod4Life Giveaway] Configuration validée avec succès !")
    return true
end
if SERVER then
    print("====================================")
    print("  GMOD4LIFE GIVEAWAY SYSTEM")
    print("  Configuration chargée avec succès")
    print("====================================")
end