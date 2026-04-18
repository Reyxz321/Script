-- Direct Auto Attack Script for Anime Fighters Simulator
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local attackRange = 50

-- Function to find and attack enemies
local function attackLoop()
    while true do
        local playerPos = character.PrimaryPart.Position
        
        -- Find all enemies in range
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and 
               obj ~= character and not Players:GetPlayerFromCharacter(obj) then
                local distance = (obj.PrimaryPart.Position - playerPos).Magnitude
                
                if distance <= attackRange then
                    -- Try different attack methods
                    pcall(function()
                        game:GetService("ReplicatedStorage").Events.Combat:FireServer()
                    end)
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.Attack:FireServer()
                    end)
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").RemoteEvents.Melee:FireServer()
                    end)
                end
            end
        end
        
        wait(0.1)
    end
end

-- Start the attack loop
spawn(attackLoop)
