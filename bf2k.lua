-- H2K BLOX FRUITS ULTIMATE SCRIPT - ADVANCED VERSION
-- Multi-Tab GUI con todas las funciones principales
-- Optimizado para Android KRNL - BY H2K

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiar GUIs anteriores
for _, gui in pairs(PlayerGui:GetChildren()) do
    if gui.Name:find("H2K") then
        gui:Destroy()
    end
end

-- Estado del script
local ScriptState = {
    -- Main Tab
    autoFarm = false,
    killAura = false,
    fastAttack = false,
    autoStats = false,
    autoQuest = false,
    
    -- Player Tab
    walkSpeed = 16,
    jumpPower = 50,
    infiniteEnergy = false,
    noclip = false,
    fly = false,
    
    -- Teleport Tab
    selectedIsland = "Starter Island",
    autoTeleportNPC = false,
    
    -- Misc Tab
    autoRaid = false,
    fruitNotifier = false,
    removeTextures = false,
    
    -- GUI
    isMinimized = false,
    currentTab = "Main"
}

local connections = {}
local lastTapTime = 0

-- Islas del juego
local Islands = {
    "Starter Island", "Marine Fortress", "Jungle", "Pirate Village",
    "Desert", "Frozen Village", "Marine Base", "Skylands", 
    "Prison", "Colosseum", "Magma Village", "Underwater City",
    "Fountain City", "Shank Room", "Mob Island", "Port Town",
    "Hydra Island", "Floating Turtle", "Mansion", "Castle on the Sea"
}

-- Buscar RemoteEvents del juego
local function findGameRemotes()
    local remotes = {}
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:find("attack") or name:find("damage") or name:find("combat") or
               name:find("skill") or name:find("ability") or name:find("fruit") then
                remotes[obj.Name] = obj
            end
        end
    end
    
    return remotes
end

-- Funciones principales
local function toggleAutoFarm()
    ScriptState.autoFarm = not ScriptState.autoFarm
    
    if ScriptState.autoFarm then
        connections.autoFarm = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            -- Buscar NPCs enemigos cercanos
            for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    if npc.Humanoid.Health > 0 then
                        local distance = (character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                        
                        if distance < 100 then
                            -- Teletransportarse al NPC
                            character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            
                            -- Atacar usando tool equipado
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                                
                                -- Disparar RemoteEvents
                                for _, remote in pairs(tool:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer()
                                    end
                                end
                            end
                        end
                        break
                    end
                end
            end
        end)
    else
        if connections.autoFarm then
            connections.autoFarm:Disconnect()
            connections.autoFarm = nil
        end
    end
end

local function toggleKillAura()
    ScriptState.killAura = not ScriptState.killAura
    
    if ScriptState.killAura then
        connections.killAura = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local rootPart = character.HumanoidRootPart
            local tool = character:FindFirstChildOfClass("Tool")
            
            -- Atacar enemigos en rango
            for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                    if enemy.Humanoid.Health > 0 then
                        local distance = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                        
                        if distance <= 50 then
                            if tool then
                                tool:Activate()
                                
                                -- Usar habilidades de la fruta/fighting style
                                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") then
                                        local name = remote.Name:lower()
                                        if name:find("skill") or name:find("ability") then
                                            remote:FireServer()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        if connections.killAura then
            connections.killAura:Disconnect()
            connections.killAura = nil
        end
    end
end

local function toggleFastAttack()
    ScriptState.fastAttack = not ScriptState.fastAttack
    
    if ScriptState.fastAttack then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FireServer" and string.find(self.Name, "Attack") then
                for i = 1, 5 do  -- Multiplicar ataques
                    oldNamecall(self, ...)
                end
                return
            end
            
            return oldNamecall(self, ...)
        end)
    end
end

local function toggleAutoStats()
    ScriptState.autoStats = not ScriptState.autoStats
    
    if ScriptState.autoStats then
        connections.autoStats = RunService.Heartbeat:Connect(function()
            -- Buscar RemoteEvent para stats
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and remote.Name:find("Stat") then
                    remote:FireServer("Melee", 1)  -- Distribuir en Melee
                    wait(0.1)
                    remote:FireServer("Defense", 1)  -- Distribuir en Defense
                    wait(0.1)
                end
            end
            wait(5)  -- Pausa entre distribuciones
        end)
    else
        if connections.autoStats then
            connections.autoStats:Disconnect()
            connections.autoStats = nil
        end
    end
end

local function setWalkSpeed(speed)
    ScriptState.walkSpeed = speed
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
    end
end

local function toggleNoclip()
    ScriptState.noclip = not ScriptState.noclip
    
    if ScriptState.noclip then
        connections.noclip = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
    end
end

local function teleportToIsland(islandName)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Coordenadas básicas de islas (se pueden expandir)
    local islandCoords = {
        ["Starter Island"] = Vector3.new(1, 20, 1),
        ["Marine Fortress"] = Vector3.new(-2840, 20, 2069),
        ["Jungle"] = Vector3.new(-1249, 20, -2262),
        ["Desert"] = Vector3.new(1199, 20, -243)
    }
    
    local coord = islandCoords[islandName]
    if coord then
        character.HumanoidRootPart.CFrame = CFrame.new(coord)
    end
end

-- Crear GUI con pestañas
local function createAdvancedGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H2K_BloxFruits_Ultimate"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 150, 255)
    mainStroke.Thickness = 2
    mainStroke.Parent = mainFrame
    
    -- Header con logo H2K
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    -- Logo H2K estético
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(0, 70, 0, 30)
    logoFrame.Position = UDim2.new(0, 10, 0, 10)
    logoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoFrame.BorderSizePixel = 0
    logoFrame.Parent = header
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logoFrame
    
    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = Color3.fromRGB(255, 215, 0)
    logoStroke.Thickness = 2
    logoStroke.Parent = logoFrame
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "H2K"
    logo.TextColor3 = Color3.fromRGB(0, 150, 255)
    logo.TextSize = 16
    logo.Font = Enum.Font.GothamBold
    logo.TextStrokeTransparency = 0
    logo.TextStrokeColor3 = Color3.fromRGB(255, 215, 0)
    logo.Parent = logoFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -160, 1, 0)
    title.Position = UDim2.new(0, 90, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "BLOX FRUITS ULTIMATE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0.5
    title.Parent = header
    
    -- Botón minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -40, 0, 10)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    minimizeBtn.TextSize = 16
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 15)
    minimizeCorner.Parent = minimizeBtn
    
    -- Sistema de pestañas
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 40)
    tabContainer.Position = UDim2.new(0, 10, 0, 60)
    tabContainer.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabContainer
    
    -- Función para crear botones de pestañas
    local function createTabButton(text, position, parent)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 80, 1, -10)
        tabBtn.Position = position
        tabBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
        tabBtn.Text = text
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 12
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = parent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = tabBtn
        
        return tabBtn
    end
    
    -- Botones de pestañas
    local mainTabBtn = createTabButton("MAIN", UDim2.new(0, 10, 0, 5), tabContainer)
    local playerTabBtn = createTabButton("PLAYER", UDim2.new(0, 100, 0, 5), tabContainer)
    local teleportTabBtn = createTabButton("TELEPORT", UDim2.new(0, 190, 0, 5), tabContainer)
    local miscTabBtn = createTabButton("MISC", UDim2.new(0, 280, 0, 5), tabContainer)
    
    -- Contenido de pestañas
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -120)
    contentFrame.Position = UDim2.new(0, 10, 0, 110)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Función para crear botones estilizados
    local function createStyledButton(text, pos, size, color, parent)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = parent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(255, 255, 255)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.7
        btnStroke.Parent = btn
        
        return btn
    end
    
    -- MAIN TAB CONTENT
    local mainTab = Instance.new("Frame")
    mainTab.Name = "MainTab"
    mainTab.Size = UDim2.new(1, 0, 1, 0)
    mainTab.BackgroundTransparency = 1
    mainTab.Parent = contentFrame
    
    local autoFarmBtn = createStyledButton("AUTO FARM: OFF", UDim2.new(0, 10, 0, 10), UDim2.new(0, 130, 0, 35), Color3.fromRGB(0, 150, 0), mainTab)
    local killAuraBtn = createStyledButton("KILL AURA: OFF", UDim2.new(0, 150, 0, 10), UDim2.new(0, 130, 0, 35), Color3.fromRGB(200, 0, 0), mainTab)
    local fastAttackBtn = createStyledButton("FAST ATTACK: OFF", UDim2.new(0, 290, 0, 10), UDim2.new(0, 130, 0, 35), Color3.fromRGB(255, 140, 0), mainTab)
    
    local autoStatsBtn = createStyledButton("AUTO STATS: OFF", UDim2.new(0, 10, 0, 55), UDim2.new(0, 130, 0, 35), Color3.fromRGB(100, 0, 200), mainTab)
    local autoQuestBtn = createStyledButton("AUTO QUEST: OFF", UDim2.new(0, 150, 0, 55), UDim2.new(0, 130, 0, 35), Color3.fromRGB(0, 200, 200), mainTab)
    
    -- PLAYER TAB CONTENT
    local playerTab = Instance.new("Frame")
    playerTab.Name = "PlayerTab"
    playerTab.Size = UDim2.new(1, 0, 1, 0)
    playerTab.BackgroundTransparency = 1
    playerTab.Visible = false
    playerTab.Parent = contentFrame
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 100, 0, 25)
    speedLabel.Position = UDim2.new(0, 10, 0, 10)
    speedLabel.BackgroundColor3 = Color3.fromRGB(50, 60, 70)
    speedLabel.Text = "Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 12
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.BorderSizePixel = 0
    speedLabel.Parent = playerTab
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 6)
    speedCorner.Parent = speedLabel
    
    local speedSlider = Instance.new("TextButton")
    speedSlider.Size = UDim2.new(0, 200, 0, 25)
    speedSlider.Position = UDim2.new(0, 120, 0, 10)
    speedSlider.BackgroundColor3 = Color3.fromRGB(70, 80, 90)
    speedSlider.Text = "DRAG TO CHANGE SPEED"
    speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedSlider.TextSize = 10
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.BorderSizePixel = 0
    speedSlider.Parent = playerTab
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = speedSlider
    
    local noclipBtn = createStyledButton("NOCLIP: OFF", UDim2.new(0, 10, 0, 45), UDim2.new(0, 130, 0, 35), Color3.fromRGB(150, 0, 150), playerTab)
    local flyBtn = createStyledButton("FLY: OFF", UDim2.new(0, 150, 0, 45), UDim2.new(0, 130, 0, 35), Color3.fromRGB(0, 100, 150), playerTab)
    
    -- TELEPORT TAB CONTENT
    local teleportTab = Instance.new("Frame")
    teleportTab.Name = "TeleportTab"
    teleportTab.Size = UDim2.new(1, 0, 1, 0)
    teleportTab.BackgroundTransparency = 1
    teleportTab.Visible = false
    teleportTab.Parent = contentFrame
    
    local islandDropdown = Instance.new("TextButton")
    islandDropdown.Size = UDim2.new(1, -20, 0, 35)
    islandDropdown.Position = UDim2.new(0, 10, 0, 10)
    islandDropdown.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
    islandDropdown.Text = "SELECT ISLAND: Starter Island"
    islandDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    islandDropdown.TextSize = 12
    islandDropdown.Font = Enum.Font.Gotham
    islandDropdown.BorderSizePixel = 0
    islandDropdown.Parent = teleportTab
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 8)
    dropdownCorner.Parent = islandDropdown
    
    local teleportBtn = createStyledButton("TELEPORT TO ISLAND", UDim2.new(0, 10, 0, 55), UDim2.new(1, -20, 0, 35), Color3.fromRGB(0, 200, 100), teleportTab)
    
    -- MISC TAB CONTENT
    local miscTab = Instance.new("Frame")
    miscTab.Name = "MiscTab"
    miscTab.Size = UDim2.new(1, 0, 1, 0)
    miscTab.BackgroundTransparency = 1
    miscTab.Visible = false
    miscTab.Parent = contentFrame
    
    local autoRaidBtn = createStyledButton("AUTO RAID: OFF", UDim2.new(0, 10, 0, 10), UDim2.new(0, 130, 0, 35), Color3.fromRGB(200, 100, 0), miscTab)
    local fruitNotifierBtn = createStyledButton("FRUIT NOTIFY: OFF", UDim2.new(0, 150, 0, 10), UDim2.new(0, 130, 0, 35), Color3.fromRGB(255, 0, 255), miscTab)
    
    -- Créditos H2K
    local creditsFrame = Instance.new("Frame")
    creditsFrame.Size = UDim2.new(1, -20, 0, 30)
    creditsFrame.Position = UDim2.new(0, 10, 1, -80)
    creditsFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    creditsFrame.BorderSizePixel = 0
    creditsFrame.Parent = mainFrame
    
    local creditsCorner = Instance.new("UICorner")
    creditsCorner.CornerRadius = UDim.new(0, 10)
    creditsCorner.Parent = creditsFrame
    
    local creditsGradient = Instance.new("UIGradient")
    creditsGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
    }
    creditsGradient.Rotation = 45
    creditsGradient.Parent = creditsFrame
    
    local creditsText = Instance.new("TextLabel")
    creditsText.Size = UDim2.new(1, 0, 1, 0)
    creditsText.BackgroundTransparency = 1
    creditsText.Text = "BY H2K - ULTIMATE BLOX FRUITS SCRIPT"
    creditsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    creditsText.TextSize = 12
    creditsText.Font = Enum.Font.GothamBold
    creditsText.TextStrokeTransparency = 0.3
    creditsText.Parent = creditsFrame
    
    -- Ícono minimizado H2K
    local miniIcon = Instance.new("Frame")
    miniIcon.Name = "MiniIcon"
    miniIcon.Size = UDim2.new(0, 70, 0, 70)
    miniIcon.Position = UDim2.new(0, 30, 0, 120)
    miniIcon.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    miniIcon.BorderSizePixel = 0
    miniIcon.Active = true
    miniIcon.Draggable = true
    miniIcon.Visible = false
    miniIcon.Parent = screenGui
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 35)
    miniCorner.Parent = miniIcon
    
    local miniStroke = Instance.new("UIStroke")
    miniStroke.Color = Color3.fromRGB(255, 215, 0)
    miniStroke.Thickness = 3
    miniStroke.Parent = miniIcon
    
    local miniGradient = Instance.new("UIGradient")
    miniGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
    }
    miniGradient.Rotation = 45
    miniGradient.Parent = miniIcon
    
    local miniText = Instance.new("TextLabel")
    miniText.Size = UDim2.new(1, 0, 1, 0)
    miniText.BackgroundTransparency = 1
    miniText.Text = "H2K"
    miniText.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniText.TextSize = 16
    miniText.Font = Enum.Font.GothamBold
    miniText.TextStrokeTransparency = 0
    miniText.TextStrokeColor3 = Color3.fromRGB(255, 215, 0)
    miniText.Parent = miniIcon
    
    local miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(1, 0, 1, 0)
    miniButton.BackgroundTransparency = 1
    miniButton.Text = ""
    miniButton.Parent = miniIcon
    
    -- Función para cambiar pestañas
    local function switchTab(tabName)
        ScriptState.currentTab = tabName
        
        -- Ocultar todas las pestañas
        mainTab.Visible = false
        playerTab.Visible = playerTab.Visible = false
        teleportTab.Visible = false
        miscTab.Visible = false
        
        -- Resetear colores de botones
        mainTabBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
        playerTabBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
        teleportTabBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
        miscTabBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
        
        -- Mostrar pestaña seleccionada
        if tabName == "Main" then
            mainTab.Visible = true
            mainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        elseif tabName == "Player" then
            playerTab.Visible = true
            playerTabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        elseif tabName == "Teleport" then
            teleportTab.Visible = true
            teleportTabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        elseif tabName == "Misc" then
            miscTab.Visible = true
            miscTabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end
    end
    
    -- Eventos de botones de pestañas
    mainTabBtn.MouseButton1Click:Connect(function() switchTab("Main") end)
    playerTabBtn.MouseButton1Click:Connect(function() switchTab("Player") end)
    teleportTabBtn.MouseButton1Click:Connect(function() switchTab("Teleport") end)
    miscTabBtn.MouseButton1Click:Connect(function() switchTab("Misc") end)
    
    -- Eventos de botones principales
    autoFarmBtn.MouseButton1Click:Connect(function()
        toggleAutoFarm()
        autoFarmBtn.Text = "AUTO FARM: " .. (ScriptState.autoFarm and "ON" or "OFF")
        autoFarmBtn.BackgroundColor3 = ScriptState.autoFarm and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 150, 0)
    end)
    
    killAuraBtn.MouseButton1Click:Connect(function()
        toggleKillAura()
        killAuraBtn.Text = "KILL AURA: " .. (ScriptState.killAura and "ON" or "OFF")
        killAuraBtn.BackgroundColor3 = ScriptState.killAura and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(200, 0, 0)
    end)
    
    fastAttackBtn.MouseButton1Click:Connect(function()
        toggleFastAttack()
        fastAttackBtn.Text = "FAST ATTACK: " .. (ScriptState.fastAttack and "ON" or "OFF")
        fastAttackBtn.BackgroundColor3 = ScriptState.fastAttack and Color3.fromRGB(255, 180, 0) or Color3.fromRGB(255, 140, 0)
    end)
    
    autoStatsBtn.MouseButton1Click:Connect(function()
        toggleAutoStats()
        autoStatsBtn.Text = "AUTO STATS: " .. (ScriptState.autoStats and "ON" or "OFF")
        autoStatsBtn.BackgroundColor3 = ScriptState.autoStats and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(100, 0, 200)
    end)
    
    autoQuestBtn.MouseButton1Click:Connect(function()
        ScriptState.autoQuest = not ScriptState.autoQuest
        autoQuestBtn.Text = "AUTO QUEST: " .. (ScriptState.autoQuest and "ON" or "OFF")
        autoQuestBtn.BackgroundColor3 = ScriptState.autoQuest and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(0, 200, 200)
    end)
    
    noclipBtn.MouseButton1Click:Connect(function()
        toggleNoclip()
        noclipBtn.Text = "NOCLIP: " .. (ScriptState.noclip and "ON" or "OFF")
        noclipBtn.BackgroundColor3 = ScriptState.noclip and Color3.fromRGB(200, 0, 200) or Color3.fromRGB(150, 0, 150)
    end)
    
    flyBtn.MouseButton1Click:Connect(function()
        ScriptState.fly = not ScriptState.fly
        flyBtn.Text = "FLY: " .. (ScriptState.fly and "ON" or "OFF")
        flyBtn.BackgroundColor3 = ScriptState.fly and Color3.fromRGB(0, 150, 200) or Color3.fromRGB(0, 100, 150)
        
        if ScriptState.fly then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = character.HumanoidRootPart
                
                connections.fly = RunService.Heartbeat:Connect(function()
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local camera = workspace.CurrentCamera
                        local direction = camera.CFrame.LookVector
                        bodyVelocity.Velocity = direction * 50
                    end
                end)
            end
        else
            if connections.fly then
                connections.fly:Disconnect()
                connections.fly = nil
            end
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local bodyVelocity = character.HumanoidRootPart:FindFirstChild("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
        end
    end)
    
    -- Slider de velocidad
    local dragging = false
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativePos = math.clamp((input.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
            local newSpeed = math.floor(16 + (relativePos * 84)) -- 16-100
            setWalkSpeed(newSpeed)
            speedLabel.Text = "Speed: " .. newSpeed
        end
    end)
    
    -- Teleport events
    teleportBtn.MouseButton1Click:Connect(function()
        teleportToIsland(ScriptState.selectedIsland)
    end)
    
    -- Dropdown de islas
    local dropdownOpen = false
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(1, 0, 0, 200)
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(40, 50, 60)
    dropdownList.BorderSizePixel = 0
    dropdownList.ScrollBarThickness = 6
    dropdownList.Visible = false
    dropdownList.Parent = islandDropdown
    
    local dropdownListCorner = Instance.new("UICorner")
    dropdownListCorner.CornerRadius = UDim.new(0, 8)
    dropdownListCorner.Parent = dropdownList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = dropdownList
    
    -- Crear opciones del dropdown
    for i, island in pairs(Islands) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, -12, 0, 30)
        option.BackgroundColor3 = Color3.fromRGB(50, 60, 70)
        option.Text = island
        option.TextColor3 = Color3.fromRGB(255, 255, 255)
        option.TextSize = 11
        option.Font = Enum.Font.Gotham
        option.BorderSizePixel = 0
        option.Parent = dropdownList
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 6)
        optionCorner.Parent = option
        
        option.MouseButton1Click:Connect(function()
            ScriptState.selectedIsland = island
            islandDropdown.Text = "SELECT ISLAND: " .. island
            dropdownList.Visible = false
            dropdownOpen = false
        end)
        
        option.MouseEnter:Connect(function()
            option.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)
        
        option.MouseLeave:Connect(function()
            option.BackgroundColor3 = Color3.fromRGB(50, 60, 70)
        end)
    end
    
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, #Islands * 32)
    
    islandDropdown.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        dropdownList.Visible = dropdownOpen
    end)
    
    -- Misc tab events
    autoRaidBtn.MouseButton1Click:Connect(function()
        ScriptState.autoRaid = not ScriptState.autoRaid
        autoRaidBtn.Text = "AUTO RAID: " .. (ScriptState.autoRaid and "ON" or "OFF")
        autoRaidBtn.BackgroundColor3 = ScriptState.autoRaid and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(200, 100, 0)
    end)
    
    fruitNotifierBtn.MouseButton1Click:Connect(function()
        ScriptState.fruitNotifier = not ScriptState.fruitNotifier
        fruitNotifierBtn.Text = "FRUIT NOTIFY: " .. (ScriptState.fruitNotifier and "ON" or "OFF")
        fruitNotifierBtn.BackgroundColor3 = ScriptState.fruitNotifier and Color3.fromRGB(255, 100, 255) or Color3.fromRGB(255, 0, 255)
        
        if ScriptState.fruitNotifier then
            connections.fruitNotifier = RunService.Heartbeat:Connect(function()
                for _, fruit in pairs(workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
                        -- Crear notificación
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "🍎 FRUIT SPAWNED!";
                            Text = "Fruit detected nearby!";
                            Duration = 3;
                        })
                        break
                    end
                end
            end)
        else
            if connections.fruitNotifier then
                connections.fruitNotifier:Disconnect()
                connections.fruitNotifier = nil
            end
        end
    end)
    
    -- Minimizar/Maximizar
    minimizeBtn.MouseButton1Click:Connect(function()
        ScriptState.isMinimized = not ScriptState.isMinimized
        mainFrame.Visible = not ScriptState.isMinimized
        miniIcon.Visible = ScriptState.isMinimized
    end)
    
    miniButton.MouseButton1Click:Connect(function()
        ScriptState.isMinimized = false
        mainFrame.Visible = true
        miniIcon.Visible = false
    end)
    
    -- Doble tap para minimizar el ícono flotante
    miniButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local currentTime = tick()
            if currentTime - lastTapTime < 0.3 then
                miniIcon.Visible = false
                mainFrame.Visible = true
                ScriptState.isMinimized = false
            end
            lastTapTime = currentTime
        end
    end)
    
    -- Inicializar pestaña principal
    switchTab("Main")
    
    -- Efectos visuales adicionales
    local function addGlow(object, color)
        local glow = Instance.new("ImageLabel")
        glow.Size = UDim2.new(1, 20, 1, 20)
        glow.Position = UDim2.new(0, -10, 0, -10)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        glow.ImageColor3 = color
        glow.ImageTransparency = 0.7
        glow.Parent = object
        glow.ZIndex = object.ZIndex - 1
    end
    
    -- Agregar efectos a botones principales
    addGlow(autoFarmBtn, Color3.fromRGB(0, 255, 0))
    addGlow(killAuraBtn, Color3.fromRGB(255, 0, 0))
    addGlow(fastAttackBtn, Color3.fromRGB(255, 140, 0))
    
    -- Animación del logo H2K
    local logoTween = TweenService:Create(logo, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextStrokeColor3 = Color3.fromRGB(0, 150, 255)
    })
    logoTween:Play()
    
    -- Animación del header
    local headerTween = TweenService:Create(headerGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
        Rotation = 180
    })
    headerTween:Play()
    
    -- Notificación de carga
    game.StarterGui:SetCore("SendNotification", {
        Title = "H2K BLOX FRUITS";
        Text = "Script loaded successfully! ✅";
        Duration = 5;
        Icon = "rbxassetid://0";
    })
end

-- Auto-reconexión si el jugador se desconecta
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(2)
    -- Restablecer velocidades y configuraciones
    if ScriptState.walkSpeed ~= 16 then
        setWalkSpeed(ScriptState.walkSpeed)
    end
    
    -- Reactivar funciones activas
    if ScriptState.noclip then
        toggleNoclip()
        toggleNoclip()
    end
end)

-- Función de limpieza al cerrar
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
end)

-- Protección anti-detección básica
local function antiDetection()
    for _, obj in pairs(getgc()) do
        if type(obj) == "function" and islclosure(obj) then
            local info = debug.getinfo(obj)
            if info.source:find("anti") or info.source:find("detect") then
                hookfunction(obj, function() return true end)
            end
        end
    end
end

-- Ejecutar protección
spawn(antiDetection)

-- Crear y mostrar GUI
createAdvancedGUI()

-- Mensaje final en consola
print("🎮 H2K BLOX FRUITS ULTIMATE SCRIPT LOADED SUCCESSFULLY! 🎮")
print("📱 Optimized for Android KRNL")
print("⚡ All features activated and ready to use!")
print("🔥 Created by H2K - Ultimate Gaming Experience")