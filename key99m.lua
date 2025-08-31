-- 🌲 H2K MOD MENU - 99 NIGHTS IN THE FOREST
-- Kill Aura, Speed, Infinite Jump, NoClip, TP to Camp
-- Compatible Android Krnl - By H2K
-- KEY SYSTEM: "h2sk"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Key del script
local SCRIPT_KEY = "h2sk"
local keyAccepted = false

-- Estados del mod
local ModState = {
    killAura = false,
    speed = false,
    infiniteJump = false,
    noClip = false,
    isOpen = false,
    killAuraRange = 80,
    speedValue = 65
}

local Connections = {}
local icon, menu

-- Limpiar GUIs anteriores
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("H2KNightsForest") then
        LocalPlayer.PlayerGui:FindFirstChild("H2KNightsForest"):Destroy()
    end
    if LocalPlayer.PlayerGui:FindFirstChild("H2KKeySystem") then
        LocalPlayer.PlayerGui:FindFirstChild("H2KKeySystem"):Destroy()
    end
    if game:GetService("CoreGui"):FindFirstChild("H2KIcon") then
        game:GetService("CoreGui"):FindFirstChild("H2KIcon"):Destroy()
    end
end)

-- Crear GUI del sistema de key
local function createKeySystem()
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "H2KKeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    keyGui.Parent = LocalPlayer.PlayerGui
    
    -- Fondo oscuro
    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.Position = UDim2.new(0, 0, 0, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 0.3
    backdrop.BorderSizePixel = 0
    backdrop.Parent = keyGui
    
    -- Frame principal del key system
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 350, 0, 200)
    keyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    keyFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = keyGui
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 15)
    keyCorner.Parent = keyFrame
    
    -- Sombra
    local keyShadow = Instance.new("Frame")
    keyShadow.Size = UDim2.new(1, 12, 1, 12)
    keyShadow.Position = UDim2.new(0, -6, 0, -6)
    keyShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyShadow.BackgroundTransparency = 0.7
    keyShadow.ZIndex = keyFrame.ZIndex - 1
    keyShadow.Parent = keyFrame
    
    local keyShadowCorner = Instance.new("UICorner")
    keyShadowCorner.CornerRadius = UDim.new(0, 21)
    keyShadowCorner.Parent = keyShadow
    
    -- Header del key system
    local keyHeader = Instance.new("Frame")
    keyHeader.Size = UDim2.new(1, 0, 0, 50)
    keyHeader.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    keyHeader.BorderSizePixel = 0
    keyHeader.Parent = keyFrame
    
    local keyHeaderCorner = Instance.new("UICorner")
    keyHeaderCorner.CornerRadius = UDim.new(0, 15)
    keyHeaderCorner.Parent = keyHeader
    
    local keyHeaderGradient = Instance.new("UIGradient")
    keyHeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 139, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 0))
    }
    keyHeaderGradient.Rotation = 45
    keyHeaderGradient.Parent = keyHeader
    
    -- Logo H2K en key system
    local keyLogo = Instance.new("TextLabel")
    keyLogo.Size = UDim2.new(0, 60, 1, 0)
    keyLogo.Position = UDim2.new(0, 15, 0, 0)
    keyLogo.BackgroundTransparency = 1
    keyLogo.Text = "H2K"
    keyLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLogo.TextSize = 20
    keyLogo.Font = Enum.Font.GothamBold
    keyLogo.TextStrokeTransparency = 0
    keyLogo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    keyLogo.Parent = keyHeader
    
    -- Título del key system
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Size = UDim2.new(1, -80, 1, 0)
    keyTitle.Position = UDim2.new(0, 80, 0, 0)
    keyTitle.BackgroundTransparency = 1
    keyTitle.Text = "Key System"
    keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyTitle.TextSize = 16
    keyTitle.Font = Enum.Font.Gotham
    keyTitle.TextXAlignment = Enum.TextXAlignment.Left
    keyTitle.Parent = keyHeader
    
    -- Label de instrucciones
    local instructionLabel = Instance.new("TextLabel")
    instructionLabel.Size = UDim2.new(1, -20, 0, 40)
    instructionLabel.Position = UDim2.new(0, 10, 0, 60)
    instructionLabel.BackgroundTransparency = 1
    instructionLabel.Text = "Enter the key to access H2K Mod Menu\nIngresa la clave para acceder"
    instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    instructionLabel.TextSize = 12
    instructionLabel.Font = Enum.Font.Gotham
    instructionLabel.Parent = keyFrame
    
    -- TextBox para la key
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 35)
    keyInput.Position = UDim2.new(0, 20, 0, 110)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter key here..."
    keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.Gotham
    keyInput.BorderSizePixel = 0
    keyInput.Parent = keyFrame
    
    local keyInputCorner = Instance.new("UICorner")
    keyInputCorner.CornerRadius = UDim.new(0, 8)
    keyInputCorner.Parent = keyInput
    
    local keyInputStroke = Instance.new("UIStroke")
    keyInputStroke.Color = Color3.fromRGB(34, 139, 34)
    keyInputStroke.Thickness = 2
    keyInputStroke.Parent = keyInput
    
    -- Botón de verificar key
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0, 100, 0, 30)
    verifyBtn.Position = UDim2.new(0.5, -50, 0, 155)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    verifyBtn.Text = "VERIFY"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 12
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.BorderSizePixel = 0
    verifyBtn.Parent = keyFrame
    
    local verifyBtnCorner = Instance.new("UICorner")
    verifyBtnCorner.CornerRadius = UDim.new(0, 8)
    verifyBtnCorner.Parent = verifyBtn
    
    local verifyBtnGradient = Instance.new("UIGradient")
    verifyBtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 139, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 0))
    }
    verifyBtnGradient.Rotation = 45
    verifyBtnGradient.Parent = verifyBtn
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 1, -25)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = keyFrame
    
    return {
        gui = keyGui,
        frame = keyFrame,
        input = keyInput,
        verifyBtn = verifyBtn,
        statusLabel = statusLabel
    }
end

-- Función para mostrar notificación
local function showNotification(title, message, color, duration)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "H2KNotification"
    notifGui.Parent = LocalPlayer.PlayerGui
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 70)
    notif.Position = UDim2.new(0.5, -150, 0, -80)
    notif.BackgroundColor3 = color
    notif.BorderSizePixel = 0
    notif.Parent = notifGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = title .. "\n" .. message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextSize = 12
    notifText.Font = Enum.Font.GothamBold
    notifText.TextStrokeTransparency = 0.3
    notifText.Parent = notif
    
    -- Animación
    notif:TweenPosition(
        UDim2.new(0.5, -150, 0, 20),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.5,
        true,
        function()
            task.wait(duration or 3)
            notif:TweenPosition(
                UDim2.new(0.5, -150, 0, -80),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Back,
                0.3,
                true,
                function()
                    notifGui:Destroy()
                end
            )
        end
    )
end

-- Sistema completo del mod
local function initializeModMenu()
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    local originalWalkSpeed = Humanoid.WalkSpeed
    local campPosition = Vector3.new(0, 8, 0)
    local lastTapTime = 0
    
    -- Referencias del juego
    local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
    local CharactersFolder = Workspace:WaitForChild("Characters")
    
    -- Herramientas con sus IDs
    local toolsDamageIDs = {
        ["Old Axe"] = "1_8982038982",
        ["Good Axe"] = "112_8982038982", 
        ["Strong Axe"] = "116_8982038982",
        ["Chainsaw"] = "647_8992824875",
        ["Spear"] = "196_8999010016",
        ["Knife"] = "324_8999010016"
    }
    
    -- Función para obtener herramienta equipable
    local function getToolWithDamageID()
        for toolName, damageID in pairs(toolsDamageIDs) do
            local tool = LocalPlayer.Inventory:FindFirstChild(toolName)
            if tool then
                return tool, damageID
            end
        end
        return nil, nil
    end
    
    -- Función para equipar herramienta
    local function equipTool(tool)
        if tool then
            pcall(function()
                RemoteEvents.EquipItemHandle:FireServer("FireAllClients", tool)
            end)
        end
    end
    
    -- Kill Aura Function
    local function toggleKillAura()
        ModState.killAura = not ModState.killAura
        
        if ModState.killAura then
            Connections.killAuraLoop = RunService.Heartbeat:Connect(function()
                if not ModState.killAura then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local tool, damageID = getToolWithDamageID()
                if not tool or not damageID then return end
                
                equipTool(tool)
                
                for _, mob in pairs(CharactersFolder:GetChildren()) do
                    if mob:IsA("Model") and mob ~= character then
                        local part = mob.PrimaryPart or mob:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local distance = (part.Position - hrp.Position).Magnitude
                            if distance <= ModState.killAuraRange then
                                pcall(function()
                                    RemoteEvents.ToolDamageObject:InvokeServer(
                                        mob, tool, damageID, CFrame.new(part.Position)
                                    )
                                end)
                            end
                        end
                    end
                end
                
                wait(0.1)
            end)
        else
            if Connections.killAuraLoop then
                Connections.killAuraLoop:Disconnect()
                Connections.killAuraLoop = nil
            end
        end
    end
    
    -- Speed Function
    local function toggleSpeed()
        ModState.speed = not ModState.speed
        
        if ModState.speed then
            Humanoid.WalkSpeed = ModState.speedValue
            Connections.speedConnection = Humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and ModState.speed then
                    Humanoid.WalkSpeed = ModState.speedValue
                end
            end)
        else
            if Connections.speedConnection then
                Connections.speedConnection:Disconnect()
                Connections.speedConnection = nil
            end
            Humanoid.WalkSpeed = originalWalkSpeed
        end
    end
    
    -- Infinite Jump Function
    local function toggleInfiniteJump()
        ModState.infiniteJump = not ModState.infiniteJump
        
        if ModState.infiniteJump then
            Connections.jumpConnection = UserInputService.JumpRequest:Connect(function()
                if ModState.infiniteJump and Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if Connections.jumpConnection then
                Connections.jumpConnection:Disconnect()
                Connections.jumpConnection = nil
            end
        end
    end
    
    -- NoClip Function
    local function toggleNoClip()
        ModState.noClip = not ModState.noClip
        
        if ModState.noClip then
            Connections.noClipLoop = RunService.Stepped:Connect(function()
                if ModState.noClip then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if Connections.noClipLoop then
                Connections.noClipLoop:Disconnect()
                Connections.noClipLoop = nil
            end
            
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
    
    -- TP to Camp Function
    local function teleportToCamp()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(campPosition)
        end
    end
    
    -- Crear slider personalizado
    local function createSlider(parent, position, size, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = size
        sliderFrame.Position = position
        sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = parent
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 4)
        sliderCorner.Parent = sliderFrame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderFrame
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 4)
        fillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(1, 0, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.Parent = sliderFrame
        
        local currentValue = default
        
        local function updateSlider(input)
            local relativePos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * relativePos)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            callback(currentValue)
        end
        
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                updateSlider(input)
                
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        sliderButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if input.UserInputState ~= Enum.UserInputState.End then
                    updateSlider(input)
                end
            end
        end)
        
        return {
            frame = sliderFrame,
            getValue = function() return currentValue end,
            setValue = function(value)
                currentValue = math.clamp(value, min, max)
                sliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
            end
        }
    end
    
    -- Crear icono flotante H2K
    local function createFloatingIcon()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "H2KIcon"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = game:GetService("CoreGui")
        
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, 55, 0, 55)
        iconFrame.Position = UDim2.new(1, -75, 0, 20)
        iconFrame.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        iconFrame.BorderSizePixel = 0
        iconFrame.Parent = screenGui
        
        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(1, 0)
        iconCorner.Parent = iconFrame
        
        local iconGradient = Instance.new("UIGradient")
        iconGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 139, 34)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 0))
        }
        iconGradient.Rotation = 45
        iconGradient.Parent = iconFrame
        
        local iconShadow = Instance.new("Frame")
        iconShadow.Size = UDim2.new(1, 8, 1, 8)
        iconShadow.Position = UDim2.new(0, -4, 0, -4)
        iconShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        iconShadow.BackgroundTransparency = 0.6
        iconShadow.ZIndex = iconFrame.ZIndex - 1
        iconShadow.Parent = iconFrame
        
        local shadowCorner = Instance.new("UICorner")
        shadowCorner.CornerRadius = UDim.new(1, 0)
        shadowCorner.Parent = iconShadow
        
        local iconText = Instance.new("TextLabel")
        iconText.Size = UDim2.new(1, 0, 1, 0)
        iconText.BackgroundTransparency = 1
        iconText.Text = "H2K"
        iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
        iconText.TextSize = 18
        iconText.Font = Enum.Font.GothamBold
        iconText.TextStrokeTransparency = 0
        iconText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        iconText.Parent = iconFrame
        
        local iconButton = Instance.new("TextButton")
        iconButton.Size = UDim2.new(1, 0, 1, 0)
        iconButton.BackgroundTransparency = 1
        iconButton.Text = ""
        iconButton.Parent = iconFrame
        
        -- Hacer icono draggable
        local isDragging = false
        local dragStart = nil
        local startPos = nil
        
        iconFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                startPos = iconFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)
        
        iconFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if isDragging then
                    local delta = input.Position - dragStart
                    iconFrame.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end
        end)
        
        return {
            gui = screenGui,
            frame = iconFrame,
            button = iconButton
        }
    end
    
    -- Crear mod menu principal
    local function createModMenu()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "H2KNightsForest"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = game:GetService("CoreGui")
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 340, 0, 480)
        mainFrame.Position = UDim2.new(0.5, -170, 0.5, -240)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
        mainFrame.BorderSizePixel = 0
        mainFrame.Visible = false
        mainFrame.Parent = screenGui
        
        local mainCorner = Instance.new("UICorner")
        mainCorner.CornerRadius = UDim.new(0, 15)
        mainCorner.Parent = mainFrame
        
        local shadow = Instance.new("Frame")
        shadow.Size = UDim2.new(1, 12, 1, 12)
        shadow.Position = UDim2.new(0, -6, 0, -6)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.7
        shadow.ZIndex = mainFrame.ZIndex - 1
        shadow.Parent = mainFrame
        
        local shadowCorner = Instance.new("UICorner")
        shadowCorner.CornerRadius = UDim.new(0, 21)
        shadowCorner.Parent = shadow
        
        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 50)
        header.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        header.BorderSizePixel = 0
        header.Parent = mainFrame
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 15)
        headerCorner.Parent = header
        
        local headerGradient = Instance.new("UIGradient")
        headerGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 139, 34)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 0))
        }
        headerGradient.Rotation = 45
        headerGradient.Parent = header
        
        local logo = Instance.new("TextLabel")
        logo.Size = UDim2.new(0, 60, 1, 0)
        logo.Position = UDim2.new(0, 15, 0, 0)
        logo.BackgroundTransparency = 1
        logo.Text = "H2K"
        logo.TextColor3 = Color3.fromRGB(255, 255, 255)
        logo.TextSize = 20
        logo.Font = Enum.Font.GothamBold
        logo.TextStrokeTransparency = 0
        logo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        logo.Parent = header
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -120, 1, 0)
        title.Position = UDim2.new(0, 80, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "99 Nights Forest"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 16
        title.Font = Enum.Font.Gotham
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = header
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -40, 0, 10)
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        closeBtn.Text = "×"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 18
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = header
        
        local closeBtnCorner = Instance.new("UICorner")
        closeBtnCorner.CornerRadius = UcloseBtnCorner.CornerRadius = UDim.new(0, 8)
        closeBtnCorner.Parent = closeBtn
        
        -- ScrollingFrame para el contenido
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -10, 1, -60)
        scrollFrame.Position = UDim2.new(0, 5, 0, 55)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(34, 139, 34)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 650)
        scrollFrame.Parent = mainFrame
        
        local content = Instance.new("Frame")
        content.Size = UDim2.new(1, -10, 0, 650)
        content.Position = UDim2.new(0, 5, 0, 0)
        content.BackgroundTransparency = 1
        content.Parent = scrollFrame
        
        -- Kill Aura Section con Slider
        local killAuraSection = Instance.new("Frame")
        killAuraSection.Size = UDim2.new(1, 0, 0, 80)
        killAuraSection.Position = UDim2.new(0, 0, 0, 0)
        killAuraSection.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
        killAuraSection.BorderSizePixel = 0
        killAuraSection.Parent = content
        
        local killAuraCorner = Instance.new("UICorner")
        killAuraCorner.CornerRadius = UDim.new(0, 10)
        killAuraCorner.Parent = killAuraSection
        
        local killAuraLabel = Instance.new("TextLabel")
        killAuraLabel.Size = UDim2.new(1, -70, 0, 25)
        killAuraLabel.Position = UDim2.new(0, 15, 0, 5)
        killAuraLabel.BackgroundTransparency = 1
        killAuraLabel.Text = "Kill Aura"
        killAuraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        killAuraLabel.TextSize = 14
        killAuraLabel.Font = Enum.Font.GothamBold
        killAuraLabel.TextXAlignment = Enum.TextXAlignment.Left
        killAuraLabel.Parent = killAuraSection
        
        local killAuraRangeLabel = Instance.new("TextLabel")
        killAuraRangeLabel.Size = UDim2.new(1, -70, 0, 20)
        killAuraRangeLabel.Position = UDim2.new(0, 15, 0, 30)
        killAuraRangeLabel.BackgroundTransparency = 1
        killAuraRangeLabel.Text = "Range: 80 studs"
        killAuraRangeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        killAuraRangeLabel.TextSize = 11
        killAuraRangeLabel.Font = Enum.Font.Gotham
        killAuraRangeLabel.TextXAlignment = Enum.TextXAlignment.Left
        killAuraRangeLabel.Parent = killAuraSection
        
        local killAuraToggle = Instance.new("TextButton")
        killAuraToggle.Size = UDim2.new(0, 60, 0, 25)
        killAuraToggle.Position = UDim2.new(1, -65, 0, 5)
        killAuraToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        killAuraToggle.Text = "OFF"
        killAuraToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        killAuraToggle.TextSize = 11
        killAuraToggle.Font = Enum.Font.GothamBold
        killAuraToggle.Parent = killAuraSection
        
        local killAuraToggleCorner = Instance.new("UICorner")
        killAuraToggleCorner.CornerRadius = UDim.new(0, 6)
        killAuraToggleCorner.Parent = killAuraToggle
        
        -- Slider para Kill Aura Range
        local killAuraSlider = createSlider(killAuraSection, UDim2.new(0, 15, 0, 55), UDim2.new(1, -80, 0, 15), 20, 200, 80, function(value)
            ModState.killAuraRange = value
            killAuraRangeLabel.Text = "Range: " .. value .. " studs"
        end)
        
        -- Speed Section con Slider
        local speedSection = Instance.new("Frame")
        speedSection.Size = UDim2.new(1, 0, 0, 80)
        speedSection.Position = UDim2.new(0, 0, 0, 90)
        speedSection.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
        speedSection.BorderSizePixel = 0
        speedSection.Parent = content
        
        local speedCorner = Instance.new("UICorner")
        speedCorner.CornerRadius = UDim.new(0, 10)
        speedCorner.Parent = speedSection
        
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(1, -70, 0, 25)
        speedLabel.Position = UDim2.new(0, 15, 0, 5)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Speed"
        speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedLabel.TextSize = 14
        speedLabel.Font = Enum.Font.GothamBold
        speedLabel.TextXAlignment = Enum.TextXAlignment.Left
        speedLabel.Parent = speedSection
        
        local speedValueLabel = Instance.new("TextLabel")
        speedValueLabel.Size = UDim2.new(1, -70, 0, 20)
        speedValueLabel.Position = UDim2.new(0, 15, 0, 30)
        speedValueLabel.BackgroundTransparency = 1
        speedValueLabel.Text = "Speed: x65"
        speedValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        speedValueLabel.TextSize = 11
        speedValueLabel.Font = Enum.Font.Gotham
        speedValueLabel.TextXAlignment = Enum.TextXAlignment.Left
        speedValueLabel.Parent = speedSection
        
        local speedToggle = Instance.new("TextButton")
        speedToggle.Size = UDim2.new(0, 60, 0, 25)
        speedToggle.Position = UDim2.new(1, -65, 0, 5)
        speedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        speedToggle.Text = "OFF"
        speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedToggle.TextSize = 11
        speedToggle.Font = Enum.Font.GothamBold
        speedToggle.Parent = speedSection
        
        local speedToggleCorner = Instance.new("UICorner")
        speedToggleCorner.CornerRadius = UDim.new(0, 6)
        speedToggleCorner.Parent = speedToggle
        
        -- Slider para Speed
        local speedSlider = createSlider(speedSection, UDim2.new(0, 15, 0, 55), UDim2.new(1, -80, 0, 15), 16, 200, 65, function(value)
            ModState.speedValue = value
            speedValueLabel.Text = "Speed: x" .. value
            if ModState.speed then
                Humanoid.WalkSpeed = value
            end
        end)
        
        -- Infinite Jump Section
        local jumpSection = Instance.new("Frame")
        jumpSection.Size = UDim2.new(1, 0, 0, 50)
        jumpSection.Position = UDim2.new(0, 0, 0, 180)
        jumpSection.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
        jumpSection.BorderSizePixel = 0
        jumpSection.Parent = content
        
        local jumpCorner = Instance.new("UICorner")
        jumpCorner.CornerRadius = UDim.new(0, 10)
        jumpCorner.Parent = jumpSection
        
        local jumpLabel = Instance.new("TextLabel")
        jumpLabel.Size = UDim2.new(1, -70, 1, 0)
        jumpLabel.Position = UDim2.new(0, 15, 0, 0)
        jumpLabel.BackgroundTransparency = 1
        jumpLabel.Text = "Infinite Jump\nSalto infinito"
        jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpLabel.TextSize = 12
        jumpLabel.Font = Enum.Font.Gotham
        jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
        jumpLabel.Parent = jumpSection
        
        local jumpToggle = Instance.new("TextButton")
        jumpToggle.Size = UDim2.new(0, 60, 0, 25)
        jumpToggle.Position = UDim2.new(1, -65, 0.5, -12.5)
        jumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        jumpToggle.Text = "OFF"
        jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpToggle.TextSize = 11
        jumpToggle.Font = Enum.Font.GothamBold
        jumpToggle.Parent = jumpSection
        
        local jumpToggleCorner = Instance.new("UICorner")
        jumpToggleCorner.CornerRadius = UDim.new(0, 6)
        jumpToggleCorner.Parent = jumpToggle
        
        -- NoClip Section
        local noClipSection = Instance.new("Frame")
        noClipSection.Size = UDim2.new(1, 0, 0, 50)
        noClipSection.Position = UDim2.new(0, 0, 0, 240)
        noClipSection.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
        noClipSection.BorderSizePixel = 0
        noClipSection.Parent = content
        
        local noClipCorner = Instance.new("UICorner")
        noClipCorner.CornerRadius = UDim.new(0, 10)
        noClipCorner.Parent = noClipSection
        
        local noClipLabel = Instance.new("TextLabel")
        noClipLabel.Size = UDim2.new(1, -70, 1, 0)
        noClipLabel.Position = UDim2.new(0, 15, 0, 0)
        noClipLabel.BackgroundTransparency = 1
        noClipLabel.Text = "NoClip\nCamina a través de paredes"
        noClipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        noClipLabel.TextSize = 12
        noClipLabel.Font = Enum.Font.Gotham
        noClipLabel.TextXAlignment = Enum.TextXAlignment.Left
        noClipLabel.Parent = noClipSection
        
        local noClipToggle = Instance.new("TextButton")
        noClipToggle.Size = UDim2.new(0, 60, 0, 25)
        noClipToggle.Position = UDim2.new(1, -65, 0.5, -12.5)
        noClipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        noClipToggle.Text = "OFF"
        noClipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        noClipToggle.TextSize = 11
        noClipToggle.Font = Enum.Font.GothamBold
        noClipToggle.Parent = noClipSection
        
        local noClipToggleCorner = Instance.new("UICorner")
        noClipToggleCorner.CornerRadius = UDim.new(0, 6)
        noClipToggleCorner.Parent = noClipToggle
        
        -- TP to Camp Button
        local campSection = Instance.new("Frame")
        campSection.Size = UDim2.new(1, 0, 0, 50)
        campSection.Position = UDim2.new(0, 0, 0, 300)
        campSection.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
        campSection.BorderSizePixel = 0
        campSection.Parent = content
        
        local campCorner = Instance.new("UICorner")
        campCorner.CornerRadius = UDim.new(0, 10)
        campCorner.Parent = campSection
        
        local campBtn = Instance.new("TextButton")
        campBtn.Size = UDim2.new(1, -20, 0, 35)
        campBtn.Position = UDim2.new(0, 10, 0.5, -17.5)
        campBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        campBtn.Text = "🔥 Teleport to Camp"
        campBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        campBtn.TextSize = 14
        campBtn.Font = Enum.Font.GothamBold
        campBtn.Parent = campSection
        
        local campBtnCorner = Instance.new("UICorner")
        campBtnCorner.CornerRadius = UDim.new(0, 8)
        campBtnCorner.Parent = campBtn
        
        local campBtnGradient = Instance.new("UIGradient")
        campBtnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 139, 34)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 0))
        }
        campBtnGradient.Rotation = 45
        campBtnGradient.Parent = campBtn
        
        -- Credits
        local credits = Instance.new("TextLabel")
        credits.Size = UDim2.new(1, 0, 0, 30)
        credits.Position = UDim2.new(0, 0, 0, 370)
        credits.BackgroundTransparency = 1
        credits.Text = "by H2K"
        credits.TextColor3 = Color3.fromRGB(150, 150, 150)
        credits.TextSize = 16
        credits.Font = Enum.Font.GothamBold
        credits.Parent = content
        
        return {
            gui = screenGui,
            mainFrame = mainFrame,
            scrollFrame = scrollFrame,
            content = content,
            closeBtn = closeBtn,
            killAuraToggle = killAuraToggle,
            speedToggle = speedToggle,
            jumpToggle = jumpToggle,
            noClipToggle = noClipToggle,
            campBtn = campBtn,
            killAuraSlider = killAuraSlider,
            speedSlider = speedSlider
        }
    end
    
    -- Función para alternar visibilidad del menu
    local function toggleMenu()
        ModState.isOpen = not ModState.isOpen
        menu.mainFrame.Visible = ModState.isOpen
        
        if ModState.isOpen then
            menu.mainFrame.Size = UDim2.new(0, 0, 0, 0)
            menu.mainFrame:TweenSize(
                UDim2.new(0, 340, 0, 480),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Back,
                0.3,
                true
            )
        end
    end
    
    -- Función para actualizar UI de toggle
    local function updateToggleUI(button, enabled)
        if enabled then
            button.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
            button.Text = "ON"
            
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(34, 139, 34)
            }):Play()
        else
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Text = "OFF"
            
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            }):Play()
        end
    end
    
    -- Mostrar notificación de éxito
    showNotification("H2K MOD MENU", "Iniciando menu h2k", Color3.fromRGB(34, 139, 34), 3)
    
    -- Crear icono y menu
    icon = createFloatingIcon()
    menu = createModMenu()
    
    -- Eventos del icono
    icon.button.MouseButton1Click:Connect(function()
        icon.frame:TweenSize(
            UDim2.new(0, 50, 0, 50),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.1,
            true,
            function()
                icon.frame:TweenSize(
                    UDim2.new(0, 55, 0, 55),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.1,
                    true
                )
            end
        )
        toggleMenu()
    end)
    
    -- Eventos del menu principal
    menu.closeBtn.MouseButton1Click:Connect(function()
        ModState.isOpen = false
        menu.mainFrame:TweenSize(
            UDim2.new(0, 0, 0, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Back,
            0.2,
            true,
            function()
                menu.mainFrame.Visible = false
            end
        )
    end)
    
    -- Eventos de funcionalidades
    menu.killAuraToggle.MouseButton1Click:Connect(function()
        toggleKillAura()
        updateToggleUI(menu.killAuraToggle, ModState.killAura)
    end)
    
    menu.speedToggle.MouseButton1Click:Connect(function()
        toggleSpeed()
        updateToggleUI(menu.speedToggle, ModState.speed)
    end)
    
    menu.jumpToggle.MouseButton1Click:Connect(function()
        toggleInfiniteJump()
        updateToggleUI(menu.jumpToggle, ModState.infiniteJump)
    end)
    
    menu.noClipToggle.MouseButton1Click:Connect(function()
        toggleNoClip()
        updateToggleUI(menu.noClipToggle, ModState.noClip)
    end)
    
    menu.campBtn.MouseButton1Click:Connect(function()
        teleportToCamp()
        
        -- Feedback visual
        TweenService:Create(menu.campBtn, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -25, 0, 30)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(menu.campBtn, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -20, 0, 35)
        }):Play()
    end)
    
    -- Hacer draggable el menu
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    menu.mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = menu.mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    menu.mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                menu.mainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    -- Auto-actualización del character
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        RootPart = newChar:WaitForChild("HumanoidRootPart")
        originalWalkSpeed = Humanoid.WalkSpeed
        
        -- Reaplica estados activos
        if ModState.speed then
            Humanoid.WalkSpeed = ModState.speedValue
            if Connections.speedConnection then
                Connections.speedConnection:Disconnect()
            end
            Connections.speedConnection = Humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and ModState.speed then
                    Humanoid.WalkSpeed = ModState.speedValue
                end
            end)
        end
        
        if ModState.killAura then
            toggleKillAura()
            toggleKillAura()
        end
        
        if ModState.noClip then
            toggleNoClip()
            toggleNoClip()
        end
    end)
    
    -- Doble tap para minimizar el ícono flotante
    icon.button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local currentTime = tick()
            if currentTime - lastTapTime < 0.3 then
                icon.frame.Visible = false
                menu.mainFrame.Visible = true
                ModState.isOpen = false
            end
            lastTapTime = currentTime
        end
    end)
    
    print("🌲 H2K Mod Menu for 99 Nights in the Forest - Loaded Successfully! 🌲")
    print("📱 Optimized for Android Krnl")
    print("🎯 Features: Kill Aura, Speed, Infinite Jump, NoClip, TP to Camp")
    print("💚 Click the H2K icon to start using the mod menu - by H2K")
end

-- Crear sistema de key
local keySystem = createKeySystem()

-- Eventos del sistema de key
keySystem.verifyBtn.MouseButton1Click:Connect(function()
    local enteredKey = keySystem.input.Text
    
    if enteredKey == SCRIPT_KEY then
        -- Key correcta
        keyAccepted = true
        keySystem.statusLabel.Text = "✅ Key correcta! Iniciando..."
        keySystem.statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Animación de cierre del key system
        keySystem.frame:TweenSize(
            UDim2.new(0, 0, 0, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Back,
            0.3,
            true,
            function()
                keySystem.gui:Destroy()
                -- Inicializar el mod menu
                initializeModMenu()
            end
        )
    else
        -- Key incorrecta
        keySystem.statusLabel.Text = "❌ Key incorrecta! Intenta de nuevo"
        keySystem.statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        keySystem.input.Text = ""
        
        -- Animación de error
        local originalPos = keySystem.frame.Position
        for i = 1, 3 do
            keySystem.frame:TweenPosition(
                UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 10, originalPos.Y.Scale, originalPos.Y.Offset),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.1,
                true,
                function()
                    keySystem.frame:TweenPosition(
                        UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 10, originalPos.Y.Scale, originalPos.Y.Offset),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.1,
                        true,
                        function()
                            if i == 3 then
                                keySystem.frame.Position = originalPos
                            end
                        end
                    )
                end
            )
            task.wait(0.2)
        end
        
        -- Mostrar notificación de error
        showNotification("H2K KEY SYSTEM", "Key incorrecta", Color3.fromRGB(255, 0, 0), 2)
    end
end)

-- También permitir verificar con Enter
keySystem.input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        keySystem.verifyBtn.MouseButton1Click:Fire()
    end
end)

-- Animación de entrada del key system
keySystem.frame.Size = UDim2.new(0, 0, 0, 0)
keySystem.frame:TweenSize(
    UDim2.new(0, 350, 0, 200),
    Enum.EasingDirection.Out,
    Enum.EasingStyle.Back,
    0.5,
    true
)

print("🔐 H2K Key System Loaded - Enter key: h2sk")
print("🌲 99 Nights in the Forest Mod Menu")
print("💚 by H2K")