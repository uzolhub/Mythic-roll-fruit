
-- Main 2X Luck Script (Client & Server)
if not game:IsLoaded() then game.Loaded:Wait() end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local UserInputService = game:GetService("UserInputService")

-- Setup RemoteEvent for 2X Luck toggle
local toggleEvent = ReplicatedStorage:FindFirstChild("LuckToggleEvent") or Instance.new("RemoteEvent")
toggleEvent.Name = "LuckToggleEvent"
toggleEvent.Parent = ReplicatedStorage

local rollFunction = ReplicatedStorage:FindFirstChild("RollFruit") or Instance.new("RemoteFunction")
rollFunction.Name = "RollFruit"
rollFunction.Parent = ReplicatedStorage

-- Server Script Setup
if game:GetService("RunService"):IsServer() then
    local PlayersLuck = {}

    toggleEvent.OnServerEvent:Connect(function(player, isEnabled)
        PlayersLuck[player.UserId] = isEnabled
    end)

    rollFunction.OnServerInvoke = function(player)
        local isLucky = PlayersLuck[player.UserId]
        local fruits
        if isLucky then
            fruits = {"Kitsune", "Dragon", "Yeti", "Gas"}
        else
            fruits = {"Kitsune", "Dragon", "Yeti", "Gas", "Bomb", "Chop", "Spin", "Flame"}
        end
        return fruits[math.random(1, #fruits)]
    end
end

-- Client Script UI
if game:GetService("RunService"):IsClient() then
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "LuckGui"

    local toggle = Instance.new("TextButton", gui)
    toggle.Name = "LuckToggle"
    toggle.Size = UDim2.new(0, 150, 0, 50)
    toggle.Position = UDim2.new(0.5, -75, 0.9, 0)
    toggle.Text = "2X Luck: OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.TextScaled = true

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.Text = "2X Luck: " .. (enabled and "ON" or "OFF")
        ReplicatedStorage:WaitForChild("LuckToggleEvent"):FireServer(enabled)
    end)
end
