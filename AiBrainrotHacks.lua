-- Grok's 1+ Wings Brainrot Farm - Optimized + Custom Prompts
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local autoFarmEnabled = false
local promptsPerCycle = 3

-- GUI
local screen = Instance.new("ScreenGui")
screen.Name = "WingsBrainrotHub"
screen.ResetOnSpawn = false
screen.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 540)
main.Position = UDim2.new(0.5, -210, 0.5, -270)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
main.Active = true
main.Draggable = true
main.Parent = screen

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "1+ Wings Brainrot Farm"
title.TextColor3 = Color3.fromRGB(120, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -80)
scroll.Position = UDim2.new(0, 10, 0, 70)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = scroll

local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 55)
    btn.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 90, 90)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    btn.Parent = scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.TextColor3 = enabled and Color3.fromRGB(90, 255, 90) or Color3.fromRGB(255, 90, 90)
        callback(enabled)
    end)
end

-- Prompts Per Cycle
local promptLabel = Instance.new("TextLabel")
promptLabel.Size = UDim2.new(1, -10, 0, 30)
promptLabel.BackgroundTransparency = 1
promptLabel.Text = "Prompts per Cycle: 3"
promptLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
promptLabel.Font = Enum.Font.Gotham
promptLabel.TextScaled = true
promptLabel.Parent = scroll

local promptBox = Instance.new("TextBox")
promptBox.Size = UDim2.new(1, -10, 0, 40)
promptBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
promptBox.Text = "3"
promptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
promptBox.Font = Enum.Font.GothamBold
promptBox.TextScaled = true
promptBox.Parent = scroll
Instance.new("UICorner", promptBox).CornerRadius = UDim.new(0, 10)

promptBox.FocusLost:Connect(function()
    local num = tonumber(promptBox.Text)
    if num and num > 0 then
        promptsPerCycle = math.floor(num)
        promptLabel.Text = "Prompts per Cycle: " .. promptsPerCycle
    else
        promptBox.Text = tostring(promptsPerCycle)
    end
end)

-- ==================== POSITIONS ====================
local mainFarmPos = Vector3.new(109, 3, 6074)
local returnPos = Vector3.new(29, 3, -57)

local function safeTeleport(pos)
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    root.CFrame = CFrame.new(pos + Vector3.new(0, 8, 0))
    print("📍 TP →", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
    task.wait(0.65)
end

-- ==================== FIND NEAREST PROMPT (200 studs) ====================
local function findNearestPrompt()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closestPrompt = nil
    local closestDistance = math.huge

    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local parent = prompt.Parent
            if parent and parent:IsA("BasePart") then
                local distance = (parent.Position - root.Position).Magnitude
                if distance < closestDistance and distance < 200 then
                    closestDistance = distance
                    closestPrompt = prompt
                end
            end
        end
    end
    return closestPrompt
end

-- ==================== HOLD PROMPT ====================
local function holdPrompt(prompt)
    if not prompt or not prompt.Enabled then return false end
    print("🎯 Holding prompt...")
    prompt:InputHoldBegin()
    task.wait(1.1)
    prompt:InputHoldEnd()
    task.wait(0.3)
    return true
end

-- ==================== MAIN LOOP ====================
local function autoFarmLoop()
    while autoFarmEnabled do
        safeTeleport(mainFarmPos)
        
        local promptsDone = 0
        while promptsDone < promptsPerCycle and autoFarmEnabled do
            local nearestPrompt = findNearestPrompt()
            
            if nearestPrompt then
                local promptPart = nearestPrompt.Parent
                if promptPart and promptPart:IsA("BasePart") then
                    safeTeleport(promptPart.Position)
                    holdPrompt(nearestPrompt)
                    promptsDone += 1
                end
            else
                print("⚠️ No more prompts found nearby")
                break
            end
        end
        
        safeTeleport(returnPos)
        task.wait(1.4)
    end
end

-- Toggle
createToggle("Auto Farm (1+ Wings)", function(state)
    autoFarmEnabled = state
    if state then
        print("✅ Farm Started - " .. promptsPerCycle .. " prompts per cycle")
        spawn(autoFarmLoop)
    else
        print("⛔ Farm Stopped")
    end
end)

print("✅ Grok's Brainrot Farm Loaded Successfully!")
print("Range: 200 studs | Custom prompts per cycle supported")