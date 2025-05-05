-- LocalScript (place in StarterPlayerScripts or StarterGui)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LuckToggleUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 140, 0, 50)
toggle.Position = UDim2.new(0.8, 0, 0.4, 0)
toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggle.Text = "2x LUCK: OFF"
toggle.TextScaled = true
toggle.Parent = screenGui

local luckEnabled = false

toggle.MouseButton1Click:Connect(function()
    luckEnabled = not luckEnabled
    toggle.Text = luckEnabled and "2x LUCK: ON" or "2x LUCK: OFF"
    toggle.BackgroundColor3 = luckEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- Trigger server to roll fruit
local rollEvent = ReplicatedStorage:WaitForChild("RollMythicalFruit")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
        rollEvent:FireServer(luckEnabled)
    end
end)

-- ServerScript (place in ServerScriptService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local rollEvent = ReplicatedStorage:FindFirstChild("RollMythicalFruit") or Instance.new("RemoteEvent")
rollEvent.Name = "RollMythicalFruit"
rollEvent.Parent = ReplicatedStorage

local normalFruits = {"Bomb", "Spin", "Ice"} -- Optional
local mythicalFruits = {"Kitsune", "Dragon", "Yeti", "Gas"}

rollEvent.OnServerEvent:Connect(function(player, isLucky)
    local fruitName
    if isLucky then
        fruitName = mythicalFruits[math.random(1, #mythicalFruits)]
    else
        local all = table.clone(normalFruits)
        for _, myth in ipairs(mythicalFruits) do
            table.insert(all, myth)
        end
        fruitName = all[math.random(1, #all)]
    end

    local fruit = game.ServerStorage.Fruits:FindFirstChild(fruitName)
    if fruit then
        fruit:Clone().Parent = player.Backpack
        print(player.Name .. " received fruit: " .. fruitName)
    end
end)
