--[[
    H2K Steal A Fish Mod Menu
    Advanced GUI with all requested features
    Compatible with KRNL Android
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Variables
local GUI = nil
local MainFrame = nil
local isMinimized = false
local isDragging = false
local dragStart = nil
local startPos = nil

-- Settings
local Settings = {
    Speed = 16,
    DefaultSpeed = 16,
    NoClip = false,
    InfiniteJump = false,
    AutoSteal = false,
    SpeedEnabled = false
}

-- Cleanup existing GUI
if CoreGui:FindFirstChild("H2KStealFishGUI") then
    CoreGui:FindFirstChild("H2KStealFishGUI"):Destroy()
end

-- Create Main GUI
GUI = Instance.new("ScreenGui")
GUI.Name = "H2KStealFishGUI"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

-- Main Frame
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = GUI
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = false -- We'll handle dragging manually

-- Corner Radius
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow Effect
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Parent = GUI
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(0.5, -173, 0.5, -198)
Shadow.Size = UDim2.new(0, 354, 0, 404)
Shadow.ZIndex = MainFrame.ZIndex - 1

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 12)
ShadowCorner.Parent = Shadow

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Fix header corners (only top)
local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)

-- Logo Icon (H2K)
local LogoIcon = Instance.new("TextLabel")
LogoIcon.Name = "LogoIcon"
LogoIcon.Parent = Header
LogoIcon.BackgroundTransparency = 1
LogoIcon.Position = UDim2.new(0, 15, 0, 0)
LogoIcon.Size = UDim2.new(0, 40, 1, 0)
LogoIcon.Font = Enum.Font.SourceSansBold
LogoIcon.Text = "H2K"
LogoIcon.TextColor3 = Color3.fromRGB(0, 150, 255)
LogoIcon.TextScaled = true
LogoIcon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
LogoIcon.TextStrokeTransparency = 0.5

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 65, 0, 0)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Steal A Fish Mod"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = Header
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -40, 0, 10)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextScaled = true

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)

-- Functions
local function createButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 140, 235)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

local function createToggle(parent, text, position, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Position = position
    frame.Size = UDim2.new(1, -20, 0, 40)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = frame
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(1, -50, 0, 10)
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.SourceSansBold
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggle
    
    local isOn = defaultValue
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggle.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        toggle.Text = isOn and "ON" or "OFF"
        if callback then
            callback(isOn)
        end
    end)
    
    return frame, toggle
end

local function createSlider(parent, text, position, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Position = position
    frame.Size = UDim2.new(1, -20, 0, 50)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.SourceSans
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Parent = frame
    sliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBG.BorderSizePixel = 0
    sliderBG.Position = UDim2.new(0, 0, 0, 25)
    sliderBG.Size = UDim2.new(1, 0, 0, 20)
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderBG
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBG
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderBG
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, -5)
    sliderButton.Size = UDim2.new(0, 20, 0, 30)
    sliderButton.Text = ""
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = sliderButton
    
    local currentValue = default
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativePos = math.clamp((mouse.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * relativePos)
            
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativePos, -10, 0, -5)
            label.Text = text .. ": " .. currentValue
            
            if callback then
                callback(currentValue)
            end
        end
    end)
    
    return frame
end

local function notify(title, text)
    local notif = Instance.new("Frame")
    notif.Parent = GUI
    notif.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    notif.BorderSizePixel = 0
    notif.Position = UDim2.new(1, 10, 0, 10)
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.ZIndex = 10
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Parent = notif
    notifTitle.BackgroundTransparency = 1
    notifTitle.Position = UDim2.new(0, 10, 0, 5)
    notifTitle.Size = UDim2.new(1, -20, 0, 20)
    notifTitle.Font = Enum.Font.SourceSansBold
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.TextSize = 14
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local notifText = Instance.new("TextLabel")
    notifText.Parent = notif
    notifText.BackgroundTransparency = 1
    notifText.Position = UDim2.new(0, 10, 0, 25)
    notifText.Size = UDim2.new(1, -20, 0, 30)
    notifText.Font = Enum.Font.SourceSans
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(200, 200, 200)
    notifText.TextSize = 12
    notifText.TextWrapped = true
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Slide in animation
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(1, -260, 0, 10)}):Play()
    
    -- Auto remove after 3 seconds
    task.wait(3)
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 0, 10)}):Play()
    task.wait(0.3)
    notif:Destroy()
end

-- Create UI Elements
local yPos = 0

-- Speed Slider
createSlider(ContentFrame, "Speed", UDim2.new(0, 10, 0, yPos), 16, 200, Settings.Speed, function(value)
    Settings.Speed = value
    if Settings.SpeedEnabled then
        local char = Player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
end)
yPos = yPos + 60

-- Speed Toggle
createToggle(ContentFrame, "🚀 Speed Boost", UDim2.new(0, 10, 0, yPos), Settings.SpeedEnabled, function(state)
    Settings.SpeedEnabled = state
    local char = Player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = state and Settings.Speed or Settings.DefaultSpeed
    end
    notify("Speed Boost", state and "Enabled" or "Disabled")
end)
yPos = yPos + 50

-- NoClip Toggle
createToggle(ContentFrame, "👻 NoClip", UDim2.new(0, 10, 0, yPos), Settings.NoClip, function(state)
    Settings.NoClip = state
    notify("NoClip", state and "Enabled" or "Disabled")
end)
yPos = yPos + 50

-- Infinite Jump Toggle
createToggle(ContentFrame, "🦘 Infinite Jump", UDim2.new(0, 10, 0, yPos), Settings.InfiniteJump, function(state)
    Settings.InfiniteJump = state
    notify("Infinite Jump", state and "Enabled" or "Disabled")
end)
yPos = yPos + 50

-- Auto Steal Toggle
createToggle(ContentFrame, "🤖 Auto Steal Fish", UDim2.new(0, 10, 0, yPos), Settings.AutoSteal, function(state)
    Settings.AutoSteal = state
    notify("Auto Steal", state and "Started" or "Stopped")
end)
yPos = yPos + 50

-- Instant Steal Button
createButton(ContentFrame, "🐟 Instant Steal Fish", UDim2.new(0, 10, 0, yPos), function()
    spawn(function()
        notify("Stealing", "Teleporting to all fish...")
        local char = Player.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local originalPos = hrp.Position
        local fishCount = 0
        
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("collect") or part.Name:lower():find("fish")) then
                hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                fishCount = fishCount + 1
                task.wait(0.1)
            end
        end
        
        hrp.CFrame = CFrame.new(originalPos)
        notify("Success", "Collected " .. fishCount .. " fish!")
    end)
end)
yPos = yPos + 45

-- Remove Walls Button
createButton(ContentFrame, "🧱 Remove Walls & Glass", UDim2.new(0, 10, 0, yPos), function()
    local count = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name == "Wall" or v.Name == "Glass") then
            v:Destroy()
            count = count + 1
        end
    end
    notify("Removed", count .. " walls/glass removed!")
end)
yPos = yPos + 45

-- Instant Interact Button
createButton(ContentFrame, "⚡ Instant Interact", UDim2.new(0, 10, 0, yPos), function()
    local count = 0
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt)
            count = count + 1
        end
    end
    notify("Interacted", count .. " prompts activated!")
end)

-- Update canvas size
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 100)

-- Dragging System
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Shadow.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset - 2, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 2)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Minimize Function
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 50)}):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.3), {Size = UDim2.new(0, 354, 0, 54)}):Play()
        ContentFrame.Visible = false
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 400)}):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.3), {Size = UDim2.new(0, 354, 0, 404)}):Play()
        ContentFrame.Visible = true
        MinimizeBtn.Text = "-"
    end
end)

-- NoClip Functionality
local noClipConnection
local function enableNoClip()
    if noClipConnection then noClipConnection:Disconnect() end
    noClipConnection = RunService.Stepped:Connect(function()
        if Settings.NoClip and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- Infinite Jump Functionality
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- Auto Steal Fish Functionality
spawn(function()
    while true do
        if Settings.AutoSteal and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name:lower():find("collect") or part.Name:lower():find("fish")) then
                        if (hrp.Position - part.Position).Magnitude > 5 then
                            hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- Character Respawned Event
Player.CharacterAdded:Connect(function()
    task.wait(1)
    if Settings.SpeedEnabled and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = Settings.Speed
    end
    enableNoClip()
end)

-- Initialize
enableNoClip()
notify("H2K Loaded", "Steal A Fish mod menu ready!")

print("H2K Steal A Fish Mod Menu loaded successfully!")