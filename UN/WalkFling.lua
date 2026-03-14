local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local walkFlingEnabled = false
local walkPower = 100
local character, humanoidRootPart
local Options = Fluent.Options
local syncing = false 
local function updateCharacter(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
end
if localPlayer.Character then
    updateCharacter(localPlayer.Character)
end
localPlayer.CharacterAdded:Connect(updateCharacter)
local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function doWalkFling()
    local root = getRoot(character)
    local vel, movel = nil, 0.1
    while walkFlingEnabled and character and character.Parent and root and root.Parent do
        vel = root.Velocity
        root.Velocity = vel * walkPower + Vector3.new(0, walkPower, 0)
        RunService.RenderStepped:Wait()
        root.Velocity = vel
        RunService.Stepped:Wait()
        root.Velocity = vel + Vector3.new(0, movel, 0)
        movel = movel * -1
        RunService.Heartbeat:Wait()
    end
end
local function setWalkFling(enabled)
    if walkFlingEnabled == enabled then return end
    walkFlingEnabled = enabled
    if not syncing then
        syncing = true
        if Options.WalkFlingToggle then
            Options.WalkFlingToggle:SetValue(enabled)
        end
        syncing = false
    end
    if enabled then
        doWalkFling()
    end
end
local Window = Fluent:CreateWindow({
    Title = "NOTHING_X",
    SubTitle = "",
    TabWidth = 0,
    Size = UDim2.fromOffset(350, 360),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})
local Tabs = {
    Main = Window:AddTab({ Title = "", Icon = "" })
}
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/TSB/ThemesUITBS"))()
end)
Tabs.Main:AddToggle("WalkFlingToggle", {
    Title = "Walk Fling",
    Default = false
}):OnChanged(function(value)
    if syncing then return end
    setWalkFling(value)
end)
Tabs.Main:AddKeybind("WalkFlingKeybind", {
    Title = "Walk Fling",
    Mode = "Toggle",
    Default = "X",
    Callback = function(value)
        if syncing then return end
        setWalkFling(value)
    end
})
Tabs.Main:AddInput("WalkPowerInput", {
    Title = "Walk Fling Power",
    Default = tostring(walkPower),
    Placeholder = "Enter Power or inf",
    Numeric = false,
    Callback = function(value)
        if string.lower(value) == "inf" then
            walkPower = 1e12
        else
            walkPower = tonumber(value) or walkPower
        end
    end
})
Tabs.Main:AddSection("+")
local Toggle = Tabs.Main:AddToggle("antiflingtog", {Title = "Anti Fling", Default = false})
local connection
Toggle:OnChanged(function(value)
    if value then
        connection = game:GetService("RunService").Stepped:Connect(function()
            local localPlayer = game:GetService("Players").LocalPlayer
            local localCharacter = localPlayer.Character
            if not localCharacter or not localCharacter.PrimaryPart then return end
            local localPosition = localCharacter.PrimaryPart.Position
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character.PrimaryPart then
                    local distance = (player.Character.PrimaryPart.Position - localPosition).Magnitude
                    if distance <= 35 then 
                        for _, v in pairs(player.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false 
                            end
                        end
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer and player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true 
                    end
                end
            end
        end
    end
end)
local freezeConnection
Tabs.Main:AddToggle("freezelocaltog", {Title = "Freeze", Default = false}):OnChanged(function(value)
    local char = localPlayer.Character
    if not char or not char.PrimaryPart then return end
    if value then
        freezeConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end)
    else
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
    end
end)
Window:SelectTab(1)
