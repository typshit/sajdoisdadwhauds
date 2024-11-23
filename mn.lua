local startTick = tick()

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cueshut/saves/main/octohook%20ui%20lib"))({cheatname = "Aimbot", gamename = "Roblox"})
library:init()

local menu = library.NewWindow({title = "Aimbot", size = UDim2.new(0, 500, 0, 300)})

---Tabs
local HomeTab = menu:AddTab("Home")
local AimingTab = menu:AddTab("Aiming")
local BlantantTab = menu:AddTab("Blantant")
local VisualsTab = menu:AddTab("Visuals")
local MiscellaneousTab = menu:AddTab("Miscellaneous")
local SettingsTab = library:CreateSettingsTab(menu)

---Sections
local AimingSection = AimingTab:AddSection("Aimbot Settings", 1)

---Aimbot Settings
local enabled = false
local smoothness = 0.1
local keybind = Enum.KeyCode.E
local holdMode = true
local fov = 90

AimingTab:AddToggle(
    {
        text = "Enable Aimbot",
        flag = "aimbotEnabled",
        callback = function(bool)
            enabled = bool
        end
    }
)

AimingTab:AddSlider(
    {
        text = "Smoothness",
        flag = "smoothness",
        suffix = "%",
        min = 0,
        max = 100,
        increment = 1,
        callback = function(value)
            smoothness = value / 100
        end
    }
)

AimingTab:AddBind(
    {
        text = "Keybind",
        flag = "keybind",
        nomouse = true,
        noindicator = true,
        bind = keybind,
        callback = function(key)
            keybind = key
        end
    }
)

AimingTab:AddToggle(
    {
        text = "Hold to Aim",
        flag = "holdMode",
        callback = function(bool)
            holdMode = bool
        end
    }
)

AimingTab:AddSlider(
    {
        text = "FOV",
        flag = "fov",
        suffix = "°",
        min = 1,
        max = 360,
        increment = 1,
        callback = function(value)
            fov = value
        end
    }
)

---Aimbot Functionality
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
