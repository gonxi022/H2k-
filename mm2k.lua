-- MURDER MYSTERY 2 ESP & UTILITIES - H2K
-- Detecta roles automáticamente con ESP
-- Optimizado para Android KRNL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiar GUIs anteriores
for _, gui in pairs(PlayerGui:GetChildren()) do
    if gui.Name:find("H2K") then
        gui:Destroy()
    end
end

-- Variables del script
local State = {
    espEnabled = false,
    speedEnabled = false,
    noclipEnabled = false,
    jumpEnabled = false,
    speedValue = 16,
    isMinimized = false
}

local connections = {}
local espLabels = {}

-- Función para detectar roles de jugadores
local function getPlayerRole(player)
    if not player.Character then return "Unknown", Color3.fromRGB(255, 255, 255) end
    
    local backpack = player.Backpack or player.Character
    
    -- Detectar asesino (tiene cuchillo)
    if backpack:FindFirstChild("Knife") or 
       (player.Character:FindFirstChild("Knife")) then
        return "MURDERER", Color3.fromRGB(255, 0, 0)
    end
    
    -- Detectar sheriff (tiene pistola)
    if backpack:FindFirstChild("Gun") or 
       (player.Character:FindFirstChild("Gun")) then
        return "SHERIFF", Color3.fromRGB(0, 0, 255)
    end
    
    -- Detectar detective (tiene revolver o similar)
    if backpack:FindFirstChild("Revolver") or
       (player.Character:FindFirstChild("Revolver")) then
        return "DETECTIVE", Color3.fromRGB(0, 255, 0)
    end
    
    -- Por defecto es inocente
    return "INNOCENT", Color3.fromRGB(255, 255, 255)
end

-- Crear ESP labels
local function createESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("Head") then return end
    
    -- Remover ESP anterior si existe
    if espLabels[player] then
        espLabels[player]:Destroy()
    end
    
    -- Crear BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "H2K_ESP"
    billboard.Parent = character.Head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    
    -- Crear label principal
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboard
    
    -- Crear label de rol
    local roleLabel = Instance.new("TextLabel")
    roleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    roleLabel.Position = UDim2.new(0, 0, 0.6, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.TextSize = 12
    roleLabel.Font = Enum.Font.GothamBold
    roleLabel.TextStrokeTransparency = 0
    roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    roleLabel.Parent = billboard
    
    espLabels[player] = billboard
    
    return billboard
end

-- Actualizar ESP
local function updateESP()
    if not State.espEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local esp = espLabels[player]
            if not esp then
                esp = createESP(player)
            end
            
            if esp then
                local role, color = getPlayerRole(player)
                local roleLabel = esp:FindFirstChild("TextLabel"):FindFirstChild("TextLabel") or esp:GetChildren()[2]
                if roleLabel then
                    roleLabel.Text = role
                    roleLabel.TextColor3 = color
                end
            end
        end
    end
end

-- Toggle ESP
local function toggleESP()
    State.espEnabled = not State.espEnabled
    
    if State.espEnabled then
        connections.espUpdate = RunService.Heartbeat:Connect(updateESP)
    else
        if connections.espUpdate then
            connections.espUpdate:Disconnect()
        end
        -- Remover todos los ESP
        for player, esp in pairs(espLabels) do
            if esp then
                esp:Destroy()
            end
        end
        espLabels = {}
    end
end

-- Toggle Speed
local function toggleSpeed()
    State.speedEnabled = not State.speedEnabled
    
    if State.speedEnabled then
        connections.speed = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = State.speedValue
            end
        end)
    else
        if connections.speed then
            connections.speed:Disconnect()
        end
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        end
    end
end

-- Toggle Noclip
local function toggleNoclip()
    State.noclipEnabled = not State.noclipEnabled
    
    if State.noclipEnabled then
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
        end
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Toggle Infinite Jump
local function toggleJump()
    State.jumpEnabled = not State.jumpEnabled
    
    if State.jumpEnabled then
        connections.jump = UserInputService.JumpRequest:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connections.jump then
            connections.jump:Disconnect()
        end
    end
end

-- Crear GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H2K_MM2_GUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Icono H2K
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "IconFrame"
    iconFrame.Size = UDim2.new(0, 60, 0, 60)
    iconFrame.Position = UDim2.new(0, 20, 0, 100)
    iconFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    iconFrame.BorderSizePixel = 0
    iconFrame.Active = true
    iconFrame.Draggable = true
    iconFrame.Parent = screenGui
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 30)
    iconCorner.Parent = iconFrame
    
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = Color3.fromRGB(255, 215, 0)
    iconStroke.Thickness = 2
    iconStroke.Parent = iconFrame
    
    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "H2K"
    iconText.TextColor3 = Color3.fromRGB(255, 215, 0)
    iconText.TextScaled = true
    iconText.Font = Enum.Font.GothamBold
    iconText.Parent = iconFrame
    
    local iconButton = Instance.new("TextButton")
    iconButton.Size = UDim2.new(1, 0, 1, 0)
    iconButton.BackgroundTransparency = 1
    iconButton.Text = ""
    iconButton.Parent = iconFrame
    
    -- Menu principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 215, 0)
    mainStroke.Thickness = 2
    mainStroke.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "MURDER MYSTERY 2"
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = header
    
    local logoLabel = Instance.new("TextLabel")
    logoLabel.Size = UDim2.new(0, 60, 0, 30)
    logoLabel.Position = UDim2.new(1, -70, 0, 10)
    logoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoLabel.Text = "H2K"
    logoLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    logoLabel.TextScaled = true
    logoLabel.Font = Enum.Font.GothamBold
    logoLabel.Parent = header
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logoLabel
    
    -- Content
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -70)
    content.Position = UDim2.new(0, 10, 0, 60)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    
    -- Función para crear botones
    local function createButton(text, pos, size, color)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = content
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        return btn
    end
    
    -- ESP Button
    local espBtn = createButton("ESP: OFF", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 40), Color3.fromRGB(100, 50, 150))
    
    -- Speed section
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, -20, 0, 25)
    speedLabel.Position = UDim2.new(0, 10, 0, 60)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "SPEED: 16"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.Parent = content
    
    -- Speed slider
    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(1, -20, 0, 20)
    speedSlider.Position = UDim2.new(0, 10, 0, 90)
    speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    speedSlider.BorderSizePixel = 0
    speedSlider.Parent = content
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = speedSlider
    
    local speedHandle = Instance.new("TextButton")
    speedHandle.Size = UDim2.new(0, 30, 1, 0)
    speedHandle.Position = UDim2.new(0, 0, 0, 0)
    speedHandle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    speedHandle.Text = ""
    speedHandle.Parent = speedSlider
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 10)
    handleCorner.Parent = speedHandle
    
    -- Speed toggle button
    local speedBtn = createButton("SPEED: OFF", UDim2.new(0, 10, 0, 120), UDim2.new(1, -20, 0, 35), Color3.fromRGB(50, 150, 50))
    
    -- Other buttons
    local noclipBtn = createButton("NOCLIP: OFF", UDim2.new(0, 10, 0, 165), UDim2.new(0.48, -5, 0, 35), Color3.fromRGB(150, 100, 50))
    local jumpBtn = createButton("INF JUMP: OFF", UDim2.new(0.52, 5, 0, 165), UDim2.new(0.48, -5, 0, 35), Color3.fromRGB(100, 100, 150))
    
    -- Role legend
    local legendFrame = Instance.new("Frame")
    legendFrame.Size = UDim2.new(1, -20, 0, 80)
    legendFrame.Position = UDim2.new(0, 10, 0, 210)
    legendFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    legendFrame.BorderSizePixel = 0
    legendFrame.Parent = content
    
    local legendCorner = Instance.new("UICorner")
    legendCorner.CornerRadius = UDim.new(0, 10)
    legendCorner.Parent = legendFrame
    
    local legendText = Instance.new("TextLabel")
    legendText.Size = UDim2.new(1, -10, 1, -10)
    legendText.Position = UDim2.new(0, 5, 0, 5)
    legendText.BackgroundTransparency = 1
    legendText.Text = "ROLES:\nMURDERER - RED\nSHERIFF - BLUE\nDETECTIVE - GREEN\nINNOCENT - WHITE"
    legendText.TextColor3 = Color3.fromRGB(255, 255, 255)
    legendText.TextSize = 12
    legendText.Font = Enum.Font.Gotham
    legendText.TextYAlignment = Enum.TextYAlignment.Top
    legendText.Parent = legendFrame
    
    -- Credits
    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Size = UDim2.new(1, -20, 0, 20)
    creditsLabel.Position = UDim2.new(0, 10, 1, -30)
    creditsLabel.BackgroundTransparency = 1
    creditsLabel.Text = "by h2k - Murder Mystery 2 ESP"
    creditsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    creditsLabel.TextSize = 12
    creditsLabel.Font = Enum.Font.GothamBold
    creditsLabel.Parent = content
    
    -- Speed slider logic
    local dragging = false
    speedHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local sliderSize = speedSlider.AbsoluteSize.X - speedHandle.AbsoluteSize.X
            local mousePos = input.Position.X - speedSlider.AbsolutePosition.X
            local clampedPos = math.clamp(mousePos, 0, sliderSize)
            local percentage = clampedPos / sliderSize
            
            speedHandle.Position = UDim2.new(percentage, 0, 0, 0)
            State.speedValue = math.floor(16 + (percentage * 84)) -- 16 to 100
            speedLabel.Text = "SPEED: " .. State.speedValue
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Button events
    iconButton.MouseButton1Click:Connect(function()
        State.isMinimized = not State.isMinimized
        mainFrame.Visible = not State.isMinimized
    end)
    
    espBtn.MouseButton1Click:Connect(function()
        toggleESP()
        espBtn.Text = "ESP: " .. (State.espEnabled and "ON" or "OFF")
        espBtn.BackgroundColor3 = State.espEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 50, 150)
    end)
    
    speedBtn.MouseButton1Click:Connect(function()
        toggleSpeed()
        speedBtn.Text = "SPEED: " .. (State.speedEnabled and "ON" or "OFF")
        speedBtn.BackgroundColor3 = State.speedEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 150, 50)
    end)
    
    noclipBtn.MouseButton1Click:Connect(function()
        toggleNoclip()
        noclipBtn.Text = "NOCLIP: " .. (State.noclipEnabled and "ON" or "OFF")
        noclipBtn.BackgroundColor3 = State.noclipEnabled and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(150, 100, 50)
    end)
    
    jumpBtn.MouseButton1Click:Connect(function()
        toggleJump()
        jumpBtn.Text = "INF JUMP: " .. (State.jumpEnabled and "ON" or "OFF")
        jumpBtn.BackgroundColor3 = State.jumpEnabled and Color3.fromRGB(150, 0, 200) or Color3.fromRGB(100, 100, 150)
    end)
    
    return screenGui
end

-- Manejar nuevos jugadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Esperar a que cargue completamente
        if State.espEnabled then
            createESP(player)
        end
    end)
end)

-- Limpiar ESP cuando jugador se va
Players.PlayerRemoving:Connect(function(player)
    if espLabels[player] then
        espLabels[player]:Destroy()
        espLabels[player] = nil
    end
end)

-- Crear GUI
local gui = createGUI()

print("H2K Murder Mystery 2 ESP cargado!")
print("Funciones:")
print("- ESP con detección automática de roles")
print("- Speed ajustable con slider")
print("- Noclip e Infinite Jump")
print("- Interfaz táctil optimizada para Android")