local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Consistt/Ui/main/UnLeaked"))()

library.rank = "developer"
local Wm = library:Watermark("Aimbot Example | v" .. library.version ..  " | " .. library:GetUsername() .. " | rank: " .. library.rank)
local FpsWm = Wm:AddWatermark("fps: " .. library.fps)
coroutine.wrap(function()
    while wait(.75) do
        FpsWm:Text("fps: " .. library.fps)
    end
end)()

local Notif = library:InitNotifications()

local LoadingXSX = Notif:Notify("Loading Aimbot, please be patient.", 5, "information")

library.title = "Aimbot"

library:Introduction()
wait(1)
local Init = library:Init()

local AimingTab = Init:NewTab("Aiming")
local SettingsTab = Init:NewTab("Settings")

local AimingSection = AimingTab:NewSection("Aimbot Settings")
local SettingsSection = SettingsTab:NewSection("General Settings")

local enabled = false
local smoothness = 0.1
local keybind = Enum.KeyCode.E
local holdMode = true
local fov = 90

AimingTab:NewToggle("Enable Aimbot", false, function(value)
    enabled = value
end):AddKeybind(Enum.KeyCode.RightControl)

AimingTab:NewSlider("Smoothness", "", true, "%", {min = 0, max = 100, default = 10}, function(value)
    smoothness = value / 100
end)

AimingTab:NewKeybind("Keybind", Enum.KeyCode.E, function(key)
    keybind = Enum.KeyCode[key]
end)

AimingTab:NewToggle("Hold to Aim", true, function(value)
    holdMode = value
end)

AimingTab:NewSlider("FOV", "", true, "°", {min = 1, max = 360, default = 90}, function(value)
    fov = value
end)

local FinishedLoading = Notif:Notify("Loaded Aimbot", 4, "success")

-- Aimbot Functionality
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPosition = player.Character.Head.Position
            local distance = (headPosition - Camera.CFrame.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if enabled then
        local closestPlayer = getClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            local headPosition = closestPlayer.Character.Head.Position
            local direction = (headPosition - Camera.CFrame.Position).unit
            local targetCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == keybind then
        if holdMode then
            enabled = true
        else
            enabled = not enabled
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == keybind and holdMode then
        enabled = false
    end
end)

