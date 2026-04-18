-- Anime Fighters Simulator: Complete Auto Script
-- Features: Auto Attack, Auto Collect, Auto Open Eggs, Auto Rebirth
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local config = {
    attackDelay = 0.1,  -- Time between attacks (seconds)
    collectDelay = 0.2, -- Time between collecting drops
    detectionRange = 50, -- Range to detect enemies
    collectRange = 100,  -- Range to detect collectibles
    autoOpenEggs = true, -- Enable/disable auto opening eggs
    autoRebirth = true,  -- Enable/disable auto rebirth
    rebirthThreshold = 10000 -- Minimum coins for rebirth
}

-- UI Toggle
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")
screenGui.Name = "AFS_AutoScript"

local toggleFrame = Instance.new("Frame")
toggleFrame.Parent = screenGui
toggleFrame.Position = UDim2.new(0, 10, 0, 10)
toggleFrame.Size = UDim2.new(0, 200, 0, 200)
toggleFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
toggleFrame.BorderSizePixel = 0
toggleFrame.Active = true
toggleFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = toggleFrame
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Size = UDim2.new(0, 200, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Anime Fighters Auto"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16

local attackToggle = Instance.new("TextButton")
attackToggle.Parent = toggleFrame
attackToggle.Position = UDim2.new(0, 10, 0, 40)
attackToggle.Size = UDim2.new(0, 180, 0, 30)
attackToggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
attackToggle.BorderSizePixel = 0
attackToggle.Text = "Auto Attack: ON"
attackToggle.TextColor3 = Color3.new(1, 1, 1)
attackToggle.Font = Enum.Font.SourceSans
attackToggle.TextSize = 14

local collectToggle = Instance.new("TextButton")
collectToggle.Parent = toggleFrame
collectToggle.Position = UDim2.new(0, 10, 0, 80)
collectToggle.Size = UDim2.new(0, 180, 0, 30)
collectToggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
collectToggle.BorderSizePixel = 0
collectToggle.Text = "Auto Collect: ON"
collectToggle.TextColor3 = Color3.new(1, 1, 1)
collectToggle.Font = Enum.Font.SourceSans
collectToggle.TextSize = 14

local eggsToggle = Instance.new("TextButton")
eggsToggle.Parent = toggleFrame
eggsToggle.Position = UDim2.new(0, 10, 0, 120)
eggsToggle.Size = UDim2.new(0, 180, 0, 30)
eggsToggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
eggsToggle.BorderSizePixel = 0
eggsToggle.Text = "Auto Open Eggs: ON"
eggsToggle.TextColor3 = Color3.new(1, 1, 1)
eggsToggle.Font = Enum.Font.SourceSans
eggsToggle.TextSize = 14

local rebirthToggle = Instance.new("TextButton")
rebirthToggle.Parent = toggleFrame
rebirthToggle.Position = UDim2.new(0, 10, 0, 160)
rebirthToggle.Size = UDim2.new(0, 180, 0, 30)
rebirthToggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
rebirthToggle.BorderSizePixel = 0
rebirthToggle.Text = "Auto Rebirth: ON"
rebirthToggle.TextColor3 = Color3.new(1, 1, 1)
rebirthToggle.Font = Enum.Font.SourceSans
rebirthToggle.TextSize = 14

-- Toggle states
local toggleStates = {
    attack = true,
    collect = true,
    eggs = true,
    rebirth = true
}

-- Toggle functions
attackToggle.MouseButton1Click:Connect(function()
    toggleStates.attack = not toggleStates.attack
    attackToggle.Text = "Auto Attack: " .. (toggleStates.attack and "ON" or "OFF")
    attackToggle.BackgroundColor3 = toggleStates.attack and Color3.new(0.2, 0.5, 0.2) or Color3.new(0.2, 0.2, 0.2)
end)

collectToggle.MouseButton1Click:Connect(function()
    toggleStates.collect = not toggleStates.collect
    collectToggle.Text = "Auto Collect: " .. (toggleStates.collect and "ON" or "OFF")
    collectToggle.BackgroundColor3 = toggleStates.collect and Color3.new(0.2, 0.5, 0.2) or Color3.new(0.2, 0.2, 0.2)
end)

eggsToggle.MouseButton1Click:Connect(function()
    toggleStates.eggs = not toggleStates.eggs
    eggsToggle.Text = "Auto Open Eggs: " .. (toggleStates.eggs and "ON" or "OFF")
    eggsToggle.BackgroundColor3 = toggleStates.eggs and Color3.new(0.2, 0.5, 0.2) or Color3.new(0.2, 0.2, 0.2)
end)

rebirthToggle.MouseButton1Click:Connect(function()
    toggleStates.rebirth = not toggleStates.rebirth
    rebirthToggle.Text = "Auto Rebirth: " .. (toggleStates.rebirth and "ON" or "OFF")
    rebirthToggle.BackgroundColor3 = toggleStates.rebirth and Color3.new(0.2, 0.5, 0.2) or Color3.new(0.2, 0.2, 0.2)
end)

-- Initialize toggle colors
attackToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.2)
collectToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.2)
eggsToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.2)
rebirthToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.2)

-- Find nearest enemy function
local function findNearestEnemy()
    local nearestEnemy = nil
    local maxDistance = config.detectionRange
    local playerPos = character.PrimaryPart.Position
    
    -- Check for enemies in workspace (may need adjustment based on game structure)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and 
           obj.Name ~= player.Name and not Players:FindFirstChild(obj.Name) then
            local distance = (obj.PrimaryPart.Position - playerPos).Magnitude
            if distance < maxDistance then
                nearestEnemy = obj
                maxDistance = distance
            end
        end
    end
    
    return nearestEnemy
end

-- Auto collect drops/coins function
local function autoCollect()
    while true do
        if toggleStates.collect then
            local playerPos = character.PrimaryPart.Position
            
            -- Find all collectibles (coins, drops, etc.)
            for _, obj in pairs(workspace:GetChildren()) do
                -- Check if object is a collectible (may need adjustment based on game)
                if (obj.Name:lower():find("coin") or obj.Name:lower():find("drop") or 
                    obj.Name:lower():find("cash") or obj:FindFirstChild("ClickDetector") or
                    obj:FindFirstChild("Collectible")) then
                    
                    local distance = (obj.Position - playerPos).Magnitude
                    
                    -- If within collect range, collect it
                    if distance < config.collectRange then
                        -- Method 1: Teleport to collectible and back
                        local oldPos = character.PrimaryPart.CFrame
                        character.PrimaryPart.CFrame = CFrame.new(obj.Position)
                        wait(0.1)
                        character.PrimaryPart.CFrame = oldPos
                        
                        -- Method 2: Fire remote event if available
                        -- game:GetService("ReplicatedStorage").Events.Collect:FireServer(obj)
                    end
                end
            end
        end
        wait(config.collectDelay)
    end
end

-- Auto attack function
local function autoAttack()
    while true do
        if toggleStates.attack then
local function autoAttack()
    while true do
        if toggleStates.attack then
            local enemy = findNearestEnemy()
            if enemy and humanoid and humanoid.Health > 0 then
                -- Attack the nearest enemy
                -- This may need adjustment based on the game's attack system
                game:GetService("ReplicatedStorage").Events.Attack:FireServer(enemy)
                
                -- Alternative attack method if the above doesn't work
                -- player:Kick() -- This is just a placeholder, replace with actual attack method
            end
        end
        wait(config.attackDelay)
    end
end

-- Auto open eggs function
local function autoOpenEggs()
    while true do
        if toggleStates.eggs then
            -- Find egg/chest objects and interact with them
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name:lower():find("egg") or obj.Name:lower():find("chest") then
                    game:GetService("ReplicatedStorage").Events.OpenEgg:FireServer(obj)
                    wait(1) -- Delay between opening eggs
                end
            end
        end
        wait(5) -- Check for eggs every 5 seconds
    end
end

-- Auto rebirth function
local function autoRebirth()
    while true do
        if toggleStates.rebirth then
            -- Check if player has enough currency for rebirth
            local playerStats = player:WaitForChild("leaderstats")
            if playerStats and playerStats:FindFirstChild("Coins") and playerStats.Coins.Value >= config.rebirthThreshold then
                game:GetService("ReplicatedStorage").Events.Rebirth:FireServer()
            end
        end
        wait(10) -- Check for rebirth every 10 seconds
    end
end

-- Start all functions
spawn(autoAttack)
spawn(autoCollect)
spawn(autoOpenEggs)
spawn(autoRebirth)

-- Notification
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[Anime Fighters Simulator] Complete Auto Script loaded!";
    Color = Color3.fromRGB(0, 255, 0);
    Font = Enum.Font.SourceSansBold;
    Size = 18;
})
