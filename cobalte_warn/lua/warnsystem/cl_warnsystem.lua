if not CLIENT then return end

-- Variables globales
local WarnMenu = nil
local WarnsViewMenu = nil
net.Receive("WarnSystem_SendWarns", function()
    local warns = net.ReadTable()
    if WarnsViewMenu and IsValid(WarnsViewMenu) then
        WarnSystem.PopulateWarnsView(WarnsViewMenu, warns)
    end
end)
net.Receive("WarnSystem_OpenMenu", function()
    WarnSystem.OpenWarnMenu()
end)
function WarnSystem.OpenWarnMenu()
    if IsValid(WarnMenu) then
        WarnMenu:Remove()
    end
    local colors = {
        Background = Color(16, 18, 22, 255),
        BackgroundGradient = Color(20, 25, 30, 255),
        Surface = Color(24, 28, 35, 255),
        SurfaceLight = Color(32, 38, 48, 255),
        SurfaceDark = Color(18, 22, 28, 255),
        Primary = Color(99, 102, 241, 255),
        PrimaryHover = Color(79, 70, 229, 255),
        PrimaryGlow = Color(99, 102, 241, 80),
        Secondary = Color(14, 165, 233, 255),
        SecondaryHover = Color(2, 132, 199, 255),
        Success = Color(34, 197, 94, 255),
        SuccessHover = Color(22, 163, 74, 255),
        Warning = Color(245, 158, 11, 255),
        WarningHover = Color(217, 119, 6, 255),
        Danger = Color(239, 68, 68, 255),
        DangerHover = Color(220, 38, 38, 255),
        Text = Color(248, 250, 252, 255),
        TextMuted = Color(148, 163, 184, 255),
        TextDark = Color(100, 116, 139, 255),
        Border = Color(30, 41, 59, 255),
        BorderLight = Color(51, 65, 85, 255),
        Hover = Color(30, 41, 59, 255),
        Selected = Color(99, 102, 241, 25),
        Header = Color(15, 23, 42, 255),
        Input = Color(30, 41, 59, 255),
        InputFocus = Color(51, 65, 85, 255),
        Accent = Color(168, 85, 247, 255),
        AccentHover = Color(147, 51, 234, 255),
        Glass = Color(255, 255, 255, 8),
        Shadow = Color(0, 0, 0, 50),
        Glow = Color(59, 130, 246, 30)
    }
    
    -- Créer le menu principal
    WarnMenu = vgui.Create("DFrame")
    WarnMenu:SetTitle("")
    WarnMenu:SetSize(750, 650)
    WarnMenu:Center()
    WarnMenu:SetDeleteOnClose(true)
    WarnMenu:SetDraggable(true)
    WarnMenu:MakePopup()
    WarnMenu:ShowCloseButton(false)
    
    -- Animation d'ouverture optimisée
    WarnMenu:SetAlpha(0)
    local originalW, originalH = WarnMenu:GetSize()
    local originalX, originalY = WarnMenu:GetPos()
    
    WarnMenu:SetSize(100, 100)
    WarnMenu:Center()
    
    WarnMenu:SizeTo(originalW, originalH, 0.4, 0, 0.5)
    WarnMenu:AlphaTo(255, 0.3, 0.1, nil)
    
    -- Variables pour les animations (optimisées)
    local particles = {}
    local particleUpdateRate = 0.1
    local lastParticleUpdate = 0
    
    -- Générer des particules pour l'effet de fond (réduit pour les perfs)
    for i = 1, 8 do
        table.insert(particles, {
            x = math.random(0, 750),
            y = math.random(0, 650),
            size = math.random(1, 2),
            speed = math.random(10, 30),
            opacity = math.random(15, 35),
            direction = math.random(0, 360)
        })
    end
    
    -- Paint fonction optimisée
    WarnMenu.Paint = function(self, w, h)
        local time = CurTime()
        local glowPulse = math.sin(time * 2) * 0.3 + 0.7
        
        -- Fond principal avec dégradé
        draw.RoundedBox(12, 0, 0, w, h, colors.Background)
        
        -- Effet de verre subtil
        draw.RoundedBox(12, 1, 1, w-2, h-2, colors.Glass)
        
        -- Particules optimisées (mise à jour limitée)
        if time - lastParticleUpdate > particleUpdateRate then
            lastParticleUpdate = time
            
            for _, particle in ipairs(particles) do
                particle.x = particle.x + math.cos(math.rad(particle.direction)) * particle.speed * particleUpdateRate
                particle.y = particle.y + math.sin(math.rad(particle.direction)) * particle.speed * particleUpdateRate
                
                -- Wraparound
                if particle.x > w then particle.x = -particle.size
                elseif particle.x < -particle.size then particle.x = w end
                if particle.y > h then particle.y = -particle.size
                elseif particle.y < -particle.size then particle.y = h end
            end
        end
        
        -- Dessiner les particules
        for _, particle in ipairs(particles) do
            surface.SetDrawColor(colors.Primary.r, colors.Primary.g, colors.Primary.b, particle.opacity * glowPulse)
            surface.DrawRect(particle.x, particle.y, particle.size, particle.size)
        end
        
        -- Header avec effet de profondeur
        draw.RoundedBoxEx(12, 0, 0, w, 80, colors.Header, true, true, false, false)
        
        -- Effet de glow sur le header (optimisé)
        local glowIntensity = math.floor(glowPulse * 3)
        for i = 1, glowIntensity do
            local alpha = (glowIntensity - i + 1) * 25
            draw.RoundedBoxEx(12, -i, -i, w + i*2, 80 + i, 
                Color(colors.Primary.r, colors.Primary.g, colors.Primary.b, alpha), 
                true, true, false, false)
        end
        
        -- Ligne de séparation
        draw.RoundedBox(0, 0, 80, w, 2, colors.Primary)
        
        -- Titre principal
        draw.SimpleText("WARNING SYSTEM", "DermaLarge", 30, 35, colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        -- Sous-titre avec animation subtile
        local subAlpha = math.sin(time * 3) * 30 + 200
        draw.SimpleText("Professional Player Management Interface", "DermaDefault", 30, 55, 
            Color(colors.TextMuted.r, colors.TextMuted.g, colors.TextMuted.b, subAlpha), 
            TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        -- Indicateur de statut
        local statusX = w - 120
        surface.SetDrawColor(colors.Success.r, colors.Success.g, colors.Success.b, 255 * glowPulse)
        surface.DrawRect(statusX, 35, 8, 8)
        draw.SimpleText("ONLINE", "DermaDefault", statusX + 15, 40, colors.Success, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        -- Bordure avec glow subtil
        local borderGlow = math.sin(time * 4) * 0.3 + 0.7
        surface.SetDrawColor(colors.BorderLight.r, colors.BorderLight.g, colors.BorderLight.b, 80 * borderGlow)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    
    -- Bouton de fermeture
    local closeBtn = vgui.Create("DButton", WarnMenu)
    closeBtn:SetText("")
    closeBtn:SetPos(700, 20)
    closeBtn:SetSize(40, 40)
    closeBtn:SetFont("DermaDefaultBold")
    closeBtn:SetTextColor(colors.Text)
    
    closeBtn.Paint = function(self, w, h)
        local isHovered = self:IsHovered()
        local isDown = self:IsDown()
        local bgColor = isHovered and colors.DangerHover or colors.Danger
        
        if isDown then
            bgColor = Color(math.max(0, bgColor.r - 30), math.max(0, bgColor.g - 30), math.max(0, bgColor.b - 30), bgColor.a)
        end
        
        draw.RoundedBox(8, 0, 0, w, h, bgColor)
        
        if isHovered then
            for i = 1, 2 do
                local glowAlpha = (3 - i) * 20
                draw.RoundedBox(8, -i, -i, w + i*2, h + i*2, 
                    Color(colors.Danger.r, colors.Danger.g, colors.Danger.b, glowAlpha))
            end
        end
        
        -- Dessiner le X
        draw.SimpleText("✕", "DermaDefaultBold", w/2, h/2, colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    closeBtn.DoClick = function()
        WarnMenu:AlphaTo(0, 0.2, 0, function()
            if IsValid(WarnMenu) then
                WarnMenu:Remove()
            end
        end)
    end
    
    -- Container principal
    local container = vgui.Create("DPanel", WarnMenu)
    container:SetPos(30, 100)
    container:SetSize(690, 520)
    container.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(colors.Surface.r, colors.Surface.g, colors.Surface.b, 240))
        surface.SetDrawColor(colors.BorderLight.r, colors.BorderLight.g, colors.BorderLight.b, 60)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    
    -- Fonction pour créer des labels
    local function CreateLabel(parent, text, x, y, w, h, prefix)
        local label = vgui.Create("DLabel", parent)
        label:SetPos(x, y)
        label:SetSize(w, h)
        label:SetFont("DermaDefaultBold")
        label:SetTextColor(colors.Text)
        
        local displayText = prefix and (prefix .. " " .. text) or text
        label:SetText(displayText)
        
        return label
    end
    
    -- Fonction pour créer des ComboBox
    local function CreateComboBox(parent, x, y, w, h, prefix)
        local combo = vgui.Create("DComboBox", parent)
        combo:SetPos(x, y)
        combo:SetSize(w, h)
        combo:SetTextColor(colors.Text)
        combo:SetFont("DermaDefault")
        
        combo.Paint = function(self, w, h)
            local isHovered = self:IsHovered()
            local isOpen = self:IsMenuOpen()
            
            local bgColor = colors.Input
            if isOpen then
                bgColor = colors.InputFocus
            elseif isHovered then
                bgColor = colors.Hover
            end
            
            draw.RoundedBox(8, 0, 0, w, h, bgColor)
            
            if isOpen or isHovered then
                surface.SetDrawColor(colors.Primary.r, colors.Primary.g, colors.Primary.b, 60)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            
            -- Préfixe
            if prefix then
                draw.SimpleText(prefix, "DermaDefault", 15, h/2, colors.Primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            
            -- Flèche dropdown
            local arrowColor = isHovered and colors.Primary or colors.TextMuted
            local arrowSize = 6
            local arrowX = w - 20
            local arrowY = h/2
            
            surface.SetDrawColor(arrowColor)
            if isOpen then
                surface.DrawLine(arrowX - arrowSize, arrowY + 2, arrowX, arrowY - 4)
                surface.DrawLine(arrowX, arrowY - 4, arrowX + arrowSize, arrowY + 2)
            else
                surface.DrawLine(arrowX - arrowSize, arrowY - 2, arrowX, arrowY + 4)
                surface.DrawLine(arrowX, arrowY + 4, arrowX + arrowSize, arrowY - 2)
            end
        end
        
        return combo
    end
    
    -- Fonction pour créer des TextEntry
    local function CreateTextEntry(parent, x, y, w, h, placeholder, prefix)
        local entry = vgui.Create("DTextEntry", parent)
        entry:SetPos(x, y)
        entry:SetSize(w, h)
        entry:SetPlaceholderText(placeholder or "")
        entry:SetTextColor(colors.Text)
        entry:SetFont("DermaDefault")
        
        entry.Paint = function(self, w, h)
            local isFocused = self:HasFocus()
            local isHovered = self:IsHovered()
            
            local bgColor = colors.Input
            if isFocused then
                bgColor = colors.InputFocus
            elseif isHovered then
                bgColor = colors.Hover
            end
            
            draw.RoundedBox(8, 0, 0, w, h, bgColor)
            
            if isFocused then
                surface.SetDrawColor(colors.Primary.r, colors.Primary.g, colors.Primary.b, 100)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            
            -- Préfixe
            if prefix then
                draw.SimpleText(prefix, "DermaDefault", 15, h/2, colors.Primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            
            self:DrawTextEntryText(colors.Text, colors.Primary, colors.Text)
        end
        
        return entry
    end
    
    -- Fonction pour créer des boutons
    local function CreateButton(parent, text, x, y, w, h, color, hoverColor, textColor, prefix)
        local btn = vgui.Create("DButton", parent)
        btn:SetText("")
        btn:SetPos(x, y)
        btn:SetSize(w, h)
        
        btn.Paint = function(self, w, h)
            local isHovered = self:IsHovered()
            local isDown = self:IsDown()
            
            local bgColor = isHovered and hoverColor or color
            if isDown then
                bgColor = Color(math.max(0, bgColor.r - 20), math.max(0, bgColor.g - 20), math.max(0, bgColor.b - 20), bgColor.a)
            end
            
            -- Effet de profondeur
            if not isDown then
                draw.RoundedBox(8, 2, 2, w, h, Color(0, 0, 0, 30))
            end
            
            draw.RoundedBox(8, 0, 0, w, h, bgColor)
            
            -- Reflet
            draw.RoundedBoxEx(8, 0, 0, w, h/2, Color(255, 255, 255, 15), true, true, false, false)
            
            -- Texte et préfixe
            local textX = w/2
            if prefix and prefix ~= "" then
                draw.SimpleText(prefix, "DermaDefaultBold", 20, h/2, textColor or colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                textX = w/2 + 10
            end
            
            draw.SimpleText(text, "DermaDefaultBold", textX, h/2, textColor or colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        
        return btn
    end
    
    -- Interface utilisateur
    local yPos = 30
    
    -- Section Player
    CreateLabel(container, "Target Player", 0, yPos, 200, 25, "[P]")
    yPos = yPos + 35
    
    local playerCombo = CreateComboBox(container, 0, yPos, 400, 45, "[P]")
    playerCombo:SetValue("Select a player to warn...")
    
    -- Remplir la liste des joueurs
    local function RefreshPlayerList()
        playerCombo:Clear()
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply ~= LocalPlayer() then
                playerCombo:AddChoice(ply:Nick() .. " (" .. ply:SteamID() .. ")", ply:SteamID())
            end
        end
    end
    
    RefreshPlayerList()
    
    -- Bouton refresh
    local refreshBtn = CreateButton(container, "⟲", 420, yPos, 45, 45, colors.Secondary, colors.SecondaryHover, colors.Text, "")
    refreshBtn.DoClick = RefreshPlayerList
    
    yPos = yPos + 70
    
    -- Section Reason
    CreateLabel(container, "Warning Reason", 0, yPos, 200, 25, "[!]")
    yPos = yPos + 35
    
    local reasonCombo = CreateComboBox(container, 0, yPos, 690, 45, "[!]")
    reasonCombo:SetValue("Select a predefined reason...")
    
    -- Ajouter les raisons prédéfinies
    local predefinedReasons = {
        "[KILL] RDM (Random Death Match)",
        "[KILL] VDM (Vehicle Death Match)",
        "[RP] FailRP (Failure to Roleplay)",
        "[RP] Trolling / Griefing",
        "[CHAT] Spam / Flood",
        "[MIC] Mic Spam",
        "[BEHAV] Inappropriate Behavior",
        "[RULE] Breaking Server Rules",
        "[RP] Metagaming",
        "[QUIT] LTAP (Leaving to Avoid Punishment)"
    }
    for _, reason in ipairs(predefinedReasons) do
        reasonCombo:AddChoice(reason)
    end
    yPos = yPos + 70
    CreateLabel(container, "Custom Reason", 0, yPos, 200, 25, "[E]")
    yPos = yPos + 35
    local customReason = CreateTextEntry(container, 0, yPos, 690, 45, "Enter a custom reason (optional)...", "[E]")
    yPos = yPos + 70
    CreateLabel(container, "Warning Duration", 0, yPos, 200, 25, "[T]")
    yPos = yPos + 35
    local durationCombo = CreateComboBox(container, 0, yPos, 300, 45, "[T]")
    durationCombo:SetValue("7 days")
    durationCombo:AddChoice("[1H] 1 hour", 3600)
    durationCombo:AddChoice("[6H] 6 hours", 21600)
    durationCombo:AddChoice("[1D] 1 day", 86400)
    durationCombo:AddChoice("[3D] 3 days", 259200)
    durationCombo:AddChoice("[7D] 7 days", 604800)
    durationCombo:AddChoice("[30D] 30 days", 2592000)
    durationCombo:AddChoice("[PERM] Permanent", 0)
    local infoPanel = vgui.Create("DPanel", container)
    infoPanel:SetPos(320, yPos)
    infoPanel:SetSize(370, 45)
    infoPanel.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, colors.Surface)
        draw.RoundedBox(8, 0, 0, w, h, Color(colors.Warning.r, colors.Warning.g, colors.Warning.b, 20))
        
        local selectedID = playerCombo:GetSelectedID()
        if selectedID and selectedID > 0 then
            local target = playerCombo:GetOptionData(selectedID)
            if target then
                local warnings = math.random(0, 5)
                local color = warnings > 3 and colors.Danger or (warnings > 1 and colors.Warning or colors.Success)
                local prefix = warnings > 3 and "[!]" or (warnings > 1 and "[?]" or "[OK]")
                
                draw.SimpleText(prefix .. " " .. warnings .. " active warnings", "DermaDefault", 15, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        else
            draw.SimpleText("[INFO] Select a player to view statistics", "DermaDefault", 15, h/2, colors.TextMuted, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    yPos = yPos + 80
    local buttonY = yPos
    local buttonSpacing = 115
    local giveWarnBtn = CreateButton(container, "Give Warning", 0, buttonY, 110, 50, colors.Danger, colors.DangerHover, colors.Text, "[!]")
    giveWarnBtn.DoClick = function()
        local selectedID = playerCombo:GetSelectedID()
        if not selectedID or selectedID <= 0 then
            Derma_Message("Please select a player.", "Warning System", "OK")
            return
        end
        local target = playerCombo:GetOptionData(selectedID)
        local reason = customReason:GetValue()
        if reason == "" then
            reason = reasonCombo:GetValue()
        end
        local duration = durationCombo:GetOptionData(durationCombo:GetSelectedID()) or 604800
        if not target or reason == "" or reason == "Select a predefined reason..." then
            Derma_Message("Please select a player and enter a reason.", "Warning System", "OK")
            return
        end
        giveWarnBtn:SetEnabled(false)
        timer.Simple(0.5, function()
            if IsValid(giveWarnBtn) then
                giveWarnBtn:SetEnabled(true)
            end
            net.Start("WarnSystem_WarnPlayer")
            net.WriteString(target)
            net.WriteString(reason)
            net.WriteUInt(duration, 32)
            net.SendToServer()
            
            WarnMenu:AlphaTo(0, 0.2, 0, function()
                if IsValid(WarnMenu) then
                    WarnMenu:Remove()
                end
            end)
        end)
    end
    local viewWarningsBtn = CreateButton(container, "View Warnings", buttonSpacing, buttonY, 110, 50, colors.Primary, colors.PrimaryHover, colors.Text, "[V]")
    viewWarningsBtn.DoClick = function()
        local selectedID = playerCombo:GetSelectedID()
        if selectedID and selectedID > 0 then
            local target = playerCombo:GetOptionData(selectedID)
            if target and WarnSystem.OpenWarnsView then
                WarnSystem.OpenWarnsView(target)
            end
        else
            Derma_Message("Please select a player first.", "Warning System", "OK")
        end
    end
    local removeWarnBtn = CreateButton(container, "Remove Warning", buttonSpacing * 2, buttonY, 110, 50, colors.Warning, colors.WarningHover, colors.Text, "[R]")
    removeWarnBtn.DoClick = function()
        local selectedID = playerCombo:GetSelectedID()
        if selectedID and selectedID > 0 then
            local target = playerCombo:GetOptionData(selectedID)
            if target then
                Derma_Message("Remove warning functionality would open here.", "Warning System", "OK")
            end
        else
            Derma_Message("Please select a player first.", "Warning System", "OK")
        end
    end
    local settingsBtn = CreateButton(container, "Settings", buttonSpacing * 3, buttonY, 110, 50, colors.Surface, colors.SurfaceLight, colors.Text, "[S]")
    settingsBtn.DoClick = function()
        Derma_Message("Settings panel would open here.", "Warning System", "OK")
    end
    local cancelBtn = CreateButton(container, "Cancel", buttonSpacing * 4, buttonY, 110, 50, colors.SurfaceDark, colors.Surface, colors.Text, "[X]")
    cancelBtn.DoClick = function()
        WarnMenu:AlphaTo(0, 0.2, 0, function()
            if IsValid(WarnMenu) then
                WarnMenu:Remove()
            end
        end)
    end
    local function AnimateElements()
        local elements = {
            {playerCombo, 0.1},
            {refreshBtn, 0.15},
            {reasonCombo, 0.2},
            {customReason, 0.25},
            {durationCombo, 0.3},
            {infoPanel, 0.35},
            {giveWarnBtn, 0.4},
            {viewWarningsBtn, 0.45},
            {removeWarnBtn, 0.5},
            {settingsBtn, 0.55},
            {cancelBtn, 0.6}
        }
        for _, data in ipairs(elements) do
            local element, delay = data[1], data[2]
            if IsValid(element) then
                element:SetAlpha(0)
                local origX, origY = element:GetPos()
                element:SetPos(origX, origY + 20)
                
                timer.Simple(delay, function()
                    if IsValid(element) then
                        element:MoveTo(origX, origY, 0.3, 0, 0.5)
                        element:AlphaTo(255, 0.3, 0, nil)
                    end
                end)
            end
        end
    end
    timer.Simple(0.2, AnimateElements)
    local function ValidateForm()
        local selectedID = playerCombo:GetSelectedID()
        local target = selectedID and selectedID > 0 and playerCombo:GetOptionData(selectedID)
        local reason = customReason:GetValue()
        if reason == "" then
            reason = reasonCombo:GetValue()
        end
        local isValid = target and reason ~= "" and reason ~= "Select a predefined reason..."
        if IsValid(giveWarnBtn) then
            giveWarnBtn:SetEnabled(isValid)
        end
    end
    playerCombo.OnSelect = ValidateForm
    reasonCombo.OnSelect = ValidateForm
    customReason.OnTextChanged = ValidateForm
    ValidateForm()
    WarnMenu.OnKeyCodePressed = function(self, keyCode)
        if keyCode == KEY_ESCAPE then
            self:Close()
        elseif keyCode == KEY_ENTER then
            if IsValid(giveWarnBtn) and giveWarnBtn:IsEnabled() then
                giveWarnBtn:DoClick()
            end
        end
    end
    local statsPanel = vgui.Create("DPanel", container)
    statsPanel:SetPos(0, 460)
    statsPanel:SetSize(690, 40)
    statsPanel:SetAlpha(0)
    statsPanel:AlphaTo(255, 0.5, 1, nil)
    statsPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, colors.SurfaceDark)
        
        local totalPlayers = #player.GetAll()
        local adminsOnline = 0
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply:IsAdmin() then
                adminsOnline = adminsOnline + 1
            end
        end
        local statsText = string.format("[INFO] Server: %d players online | %d admins online | AWarn System v3.0", totalPlayers, adminsOnline)
        draw.SimpleText(statsText, "DermaDefault", w/2, h/2, colors.TextMuted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    if WarnSystem.Config and WarnSystem.Config.PlaySounds then
        surface.PlaySound("buttons/button15.wav")
    end
    WarnMenu.OnRemove = function()
        if WarnSystem.Config and WarnSystem.Config.PlaySounds then
            surface.PlaySound("buttons/button10.wav")
        end
    end
end
function WarnSystem.OpenWarnsView(steamid)
    if IsValid(WarnsViewMenu) then
        WarnsViewMenu:Remove()
    end
    WarnsViewMenu = vgui.Create("DFrame")
    WarnsViewMenu:SetTitle("Historique des Avertissements")
    WarnsViewMenu:SetSize(700, 500)
    WarnsViewMenu:Center()
    WarnsViewMenu:SetDeleteOnClose(true)
    WarnsViewMenu:SetDraggable(true)
    WarnsViewMenu:MakePopup()
    net.Start("WarnSystem_GetWarns")
    net.WriteString(steamid)
    net.SendToServer()
end
function WarnSystem.PopulateWarnsView(frame, warns)
    if not IsValid(frame) then return end
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(10, 40)
    scroll:SetSize(680, 450)
    for i, warn in ipairs(warns) do
        local warnPanel = vgui.Create("DPanel", scroll)
        warnPanel:SetSize(660, 80)
        warnPanel:SetPos(0, (i-1) * 85)
        warnPanel.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(245, 245, 245))
            draw.RoundedBox(4, 0, 0, 5, h, WarnSystem.Config.Colors.Danger)
        end
        local reasonLabel = vgui.Create("DLabel", warnPanel)
        reasonLabel:SetText("Raison: " .. warn.reason)
        reasonLabel:SetPos(15, 10)
        reasonLabel:SetSize(400, 20)
        reasonLabel:SetFont("DermaDefault")
        local dateLabel = vgui.Create("DLabel", warnPanel)
        dateLabel:SetText("Date: " .. os.date("%d/%m/%Y %H:%M", warn.date))
        dateLabel:SetPos(15, 30)
        dateLabel:SetSize(200, 20)
        local durationLabel = vgui.Create("DLabel", warnPanel)
        durationLabel:SetText("Durée: " .. WarnSystem.FormatTime(warn.duration))
        durationLabel:SetPos(15, 50)
        durationLabel:SetSize(200, 20)
        local removeBtn = vgui.Create("DButton", warnPanel)
        removeBtn:SetText("Supprimer")
        removeBtn:SetPos(550, 25)
        removeBtn:SetSize(80, 30)
        removeBtn:SetTextColor(color_white)
        removeBtn.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, WarnSystem.Config.Colors.Danger)
        end
        removeBtn.DoClick = function()
            Derma_Query("Êtes-vous sûr de vouloir supprimer ce warn ?", "Confirmation", "Oui", function()
                net.Start("WarnSystem_UnwarnPlayer")
                net.WriteUInt(warn.id, 32)
                net.SendToServer()
                warnPanel:Remove()
            end, "Non")
        end
    end
end
concommand.Add("warn_menu", function()
    if WarnSystem.HasPermission(LocalPlayer(), WarnSystem.Config.WarnPermission) then
        WarnSystem.OpenWarnMenu()
    end
end)