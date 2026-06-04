-- =================================================================
-- 🧠 AI BRAINROT HUB v10 [PREMIUM EDITION] 🚀
-- =================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- // Configurations
local RETURN_POS = CFrame.new(121, 6, -197)
local SCAN_RADIUS = 500
local HOLD_TIME = 2

local AREAS = {
    ["Area 1"] = CFrame.new(148, 29, -81),
    ["Area 2"] = CFrame.new(145, 88, 74),
    ["Area 3"] = CFrame.new(144, 346, 367),
    ["Area 4"] = CFrame.new(123, 728, 837),
    ["Area 5"] = CFrame.new(152, 1198, 1286),
    ["Area 6"] = CFrame.new(144, 2640, 2067),
    ["Area 7"] = CFrame.new(134, 4473, 2854)
}

local currentSelection = AREAS["Area 1"]
local isFarming = false
local godmodeEnabled = false

-- // UI Framework Construction
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AIBrainrotHubV10"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 440)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Auto-align layout for main panel
local Layout = Instance.new("UIListLayout", MainFrame)
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Title Elements
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.9, 0, 0, 35)
Title.Text = "🧠 AI BRAINROT HUB v10 🚀"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
StatusLabel.Text = "STATUS: ⚪ IDLE | AREA 1 SELECTED"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.BackgroundTransparency = 1

-- // Godmode System Thread
local GodmodeBtn = Instance.new("TextButton", MainFrame)
GodmodeBtn.Size = UDim2.new(0.9, 0, 0, 40)
GodmodeBtn.Text = "🛡️ GODMODE: DISABLED"
GodmodeBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 50)
GodmodeBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
GodmodeBtn.Font = Enum.Font.GothamBold
GodmodeBtn.TextSize = 13
Instance.new("UICorner", GodmodeBtn).CornerRadius = UDim.new(0, 8)

GodmodeBtn.MouseButton1Click:Connect(function()
    godmodeEnabled = not godmodeEnabled
    GodmodeBtn.Text = godmodeEnabled and "🛡️ GODMODE: ENABLED" or "🛡️ GODMODE: DISABLED"
    GodmodeBtn.BackgroundColor3 = godmodeEnabled and Color3.fromRGB(40, 100, 60) or Color3.fromRGB(60, 50, 50)
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if godmodeEnabled then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end
    end
end)

-- // Area Selector Scroll Container
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(0.9, 0, 0, 160)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 320)
ScrollFrame.ScrollBarThickness = 6
Instance.new("UICorner", ScrollFrame).CornerRadius = UDim.new(0, 8)

local ScrollLayout = Instance.new("UIListLayout", ScrollFrame)
ScrollLayout.Padding = UDim.new(0, 6)
ScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Populate Areas dynamically with visual selection states
local buttons = {}
for areaName, targetCFrame in pairs(AREAS) do
    local AreaBtn = Instance.new("TextButton", ScrollFrame)
    AreaBtn.Size = UDim2.new(0.95, 0, 0, 38)
    AreaBtn.Text = "📍 " .. areaName
    AreaBtn.Font = Enum.Font.GothamSemibold
    AreaBtn.TextSize = 13
    Instance.new("UICorner", AreaBtn).CornerRadius = UDim.new(0, 6)
    
    -- Default style configuration
    if areaName == "Area 1" then
        AreaBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        AreaBtn.TextColor3 = Color3.new(1, 1, 1)
    else
        AreaBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        AreaBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    buttons[areaName] = AreaBtn

    AreaBtn.MouseButton1Click:Connect(function()
        currentSelection = targetCFrame
        StatusLabel.Text = isFarming and "STATUS: 🟢 FARMING ACTIVE | " .. areaName or "STATUS: ⚪ IDLE | " .. areaName .. " SELECTED"
        
        -- Reset all buttons and highlight chosen option
        for _, btn in pairs(buttons) do
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        AreaBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        AreaBtn.TextColor3 = Color3.new(1, 1, 1)
    end)
end

-- // Farm Button Setup
local FarmBtn = Instance.new("TextButton", MainFrame)
FarmBtn.Size = UDim2.new(0.9, 0, 0, 50)
FarmBtn.Text = "⚡ START AUTO FARM"
FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.Font = Enum.Font.GothamBold
FarmBtn.TextSize = 14
Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0, 8)

FarmBtn.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    FarmBtn.Text = isFarming and "🛑 STOP AUTO FARM" or "⚡ START AUTO FARM"
    FarmBtn.BackgroundColor3 = isFarming and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(0, 160, 80)
    
    -- Update overall state presentation strings
    local activeAreaName = "Area 1"
    for name, cf in pairs(AREAS) do if cf == currentSelection then activeAreaName = name end end
    StatusLabel.Text = isFarming and "STATUS: 🟢 FARMING ACTIVE | " .. activeAreaName or "STATUS: 🔴 STOPPED"
    StatusLabel.TextColor3 = isFarming and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 100, 100)
    
    if isFarming then
        task.spawn(function()
            while isFarming do
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then task.wait(1); continue end
                
                -- Step 1: Teleport to selected zone area location
                char:PivotTo(currentSelection)
                task.wait(0.6) 
                
                -- Step 2: Scan for prompts within 500 studs of current root position
                local targetPrompt = nil
                local minDistance = SCAN_RADIUS
                
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent:IsA("BasePart") then
                        local dist = (obj.Parent.Position - root.Position).Magnitude
                        if dist <= minDistance then
                            minDistance = dist
                            targetPrompt = obj
                        end
                    end
                end
                
                -- Step 3: Teleport directly to target prompt part offset & hold 2 seconds
                if targetPrompt then
                    char:PivotTo(targetPrompt.Parent.CFrame + Vector3.new(0, 3, 0))
                    task.wait(0.4)
                    
                    targetPrompt:InputHoldBegin()
                    task.wait(HOLD_TIME)
                    targetPrompt:InputHoldEnd()
                end
                
                -- Step 4: Safely return home location reference mapping
                char:PivotTo(RETURN_POS)
                task.wait(1.5)
            end
        end)
    end
end)

-- Hide/Show Toggle menu with the 'Insert' Key
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)