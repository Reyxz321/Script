-- Simple Auto Attack for Anime Fighters Simulator
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configuration
local attackRange = 50 -- Detection range in studs
local attackDelay = 0.1 -- Time between attacks

-- Find nearest enemy function
local function findNearestEnemy()
    local nearestEnemy = nil
    local maxDistance = attackRange
    local playerPos = character.PrimaryPart.Position
    
    -- Look for enemies in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and 
           obj ~= character and not Players:GetPlayerFromCharacter(obj) then
            local distance = (obj.PrimaryPart.Position - playerPos).Magnitude
            if distance < maxDistance then
                nearestEnemy = obj
                maxDistance = distance
            end
        end
    end
    
    return nearestEnemy
end

-- Auto attack function
local function autoAttack()
    while true do
        local enemy = findNearestEnemy()
        if enemy and humanoid and humanoid.Health > 0 then
            -- Try different attack methods
            pcall(function()
                -- Method 1: Try to fire a remote event (common in Roblox games)
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Combat"):FireServer()
            end)
            
            pcall(function()
                -- Method 2: Try a different remote event path
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Attack"):FireServer()
            end)
            
            pcall(function()
                -- Method 3: Try to directly control the character
                humanoid:MoveTo(enemy.PrimaryPart.Position)
            end)
        end
        wait(attackDelay)
    end
end

-- Start the auto attack
spawn(autoAttack)

-- Notification
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[Anime Fighters Simulator] Auto Attack script loaded!";
    Color = Color3.fromRGB(0, 255, 0);
    Font = Enum.Font.SourceSansBold;
    Size = 18;
})
