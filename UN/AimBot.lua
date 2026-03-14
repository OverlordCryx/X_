local function SafeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    return success and result or nil
end
local Fluent = SafeLoad("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
local SaveManager = SafeLoad("https://github.com/dawid-scripts/Fluent/raw/refs/heads/master/Addons/SaveManager.lua")
local InterfaceManager = SafeLoad("https://github.com/dawid-scripts/Fluent/raw/refs/heads/master/Addons/InterfaceManager.lua")
if not Fluent then return end
local Window = Fluent:CreateWindow({
    Title = "NOTHING_X",
    SubTitle = "",
    TabWidth = 30,
    Size = UDim2.fromOffset(400, 560),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})
local Tabs = {
    Main = Window:AddTab({ Title = "", Icon = "target" }),
    Visuals = Window:AddTab({ Title = "", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "", Icon = "settings" })
}
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/ThemesUI"))()
end)
local Options = Fluent.Options
local ConfigLoading = false
Tabs.Settings:AddButton({
    Title = "Save All Settings",
    Description = "Manually save your current config",
    Callback = function()
        if SaveManager then
            SaveManager:Save("autosave")
            Fluent:Notify({Title = "NOTHING_X", Content = "Settings saved successfully!", Duration = 3})
        end
    end
})
local function DisableAllAimbots(except)
    local list = {
        ManualAimbot = Options.ManualAimbot,
        AimbotAutoShot = Options.AimbotAutoShot,
        AutoAimShot = Options.AutoAimShot,
        TPAutoKill = Options.TPAutoKill
    }
    for id, opt in pairs(list) do
        if id ~= except and opt.Value == true then
            pcall(function() opt:SetValue(false) end)
        end
    end
end
local ManualAimbotToggle = Tabs.Main:AddToggle("ManualAimbot", {Title = "Manual Aimbot (Hold Key)", Default = false})
ManualAimbotToggle:OnChanged(function()
    if Options.ManualAimbot.Value then DisableAllAimbots("ManualAimbot") end
end)
local AimbotAutoShotToggle = Tabs.Main:AddToggle("AimbotAutoShot", {Title = "Aimbot + Auto Shot (Hold Key)", Default = false})
AimbotAutoShotToggle:OnChanged(function()
    if Options.AimbotAutoShot.Value then DisableAllAimbots("AimbotAutoShot") end
end)
local AutoAimShotToggle = Tabs.Main:AddToggle("AutoAimShot", {Title = "Auto-Aim-Shot", Default = false})
AutoAimShotToggle:OnChanged(function()
    if Options.AutoAimShot.Value then DisableAllAimbots("AutoAimShot") end
end)
local TPAutoKillToggle = Tabs.Main:AddToggle("TPAutoKill", {Title = "TP Auto-Kill", Default = false})
TPAutoKillToggle:OnChanged(function()
    if Options.TPAutoKill.Value then DisableAllAimbots("TPAutoKill") end
end)
local PlayerDropdown = Tabs.Main:AddDropdown("PlayerSelection", {
    Title = "Target Filter",
    Values = {"All Players"},
    Default = "All Players"
})
Tabs.Main:AddParagraph({
    Title = "",
    Content = "-"
})
Tabs.Main:AddToggle("InfiniteDistance", {Title = "Infinite Range (Ignore FOV)", Default = false})
Tabs.Main:AddDropdown("PriorityMode", {Title = "Target Priority", Values = {"Closest to Mouse", "Closest to Player", "Lowest Health"}, Default = "Closest to Mouse"})
Tabs.Main:AddDropdown("TargetPartDropdown", {Title = "Target Part", Values = {"Head", "UpperTorso", "HumanoidRootPart", "Randomized"}, Default = "Head"})
Tabs.Main:AddDropdown("TeamModeDropdown", {Title = "Team Targeting", Values = {"Enemy Only", "Team Only", "Any Player"}, Default = "Enemy Only"})
Tabs.Main:AddSlider("SmoothingSlider", {Title = "Aim Smoothing", Default = 0.5, Min = 0, Max = 1, Rounding = 2})
Tabs.Main:AddSlider("FOVSlider", {Title = "Field of View", Default = 150, Min = 10, Max = 1500, Rounding = 0})
Tabs.Main:AddToggle("ShowFOVToggle", {Title = "Show FOV Circle", Default = false})
Tabs.Main:AddToggle("WallCheck", {Title = "Visibility Check (No Shoot through Walls)", Default = true})
Tabs.Visuals:AddToggle("ESPToggle", {Title = "Master ESP Enable", Default = false})
Tabs.Visuals:AddToggle("ESPBoxes", {Title = "Show Boxes", Default = false})
Tabs.Visuals:AddToggle("ESPHealthBar", {Title = "Show Health Bars", Default = false})
Tabs.Visuals:AddToggle("ESPNames", {Title = "Show Names", Default = false})
Tabs.Visuals:AddColorpicker("ESPColor", {Title = "ESP Color", Default = Color3.fromRGB(255, 255, 255)})
Tabs.Visuals:AddSlider("ESPDistance", {Title = "Max ESP Distance", Default = 1000, Min = 100, Max = 5000, Rounding = 0})
local AimKeybind = Tabs.Settings:AddKeybind("AimKeybind", {Title = "Manual Aim Key", Mode = "Hold", Default = "MouseButton2"})
Tabs.Settings:AddKeybind("AutoAimShotKey", {
    Title = "Auto-Aim-Shot  ",
    Mode = "Toggle",
    Default = "V",
    Callback = function(Value)
        AutoAimShotToggle:SetValue(Value)
    end
})
Tabs.Settings:AddKeybind("TPAutoKillKey", {
    Title = "TP Auto-Kill  ",
    Mode = "Toggle",
    Default = "B",
    Callback = function(Value)
        TPAutoKillToggle:SetValue(Value)
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local lastMemoryCheck = 0
local currentTarget = nil
local targetStartTime = 0
local skipTarget = nil
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Visible = false
local _RayParams = RaycastParams.new()
_RayParams.FilterType = Enum.RaycastFilterType.Exclude
local CurrentAimKeyEnum = nil
local CurrentAimKeyType = "Mouse"
local function UpdateKeyCache()
    local key = Options.AimKeybind.Value
    if not key then return end
    local sM, eM = pcall(function() return Enum.UserInputType[key] end)
    if sM then CurrentAimKeyEnum = eM; CurrentAimKeyType = "Mouse"; return end
    local sK, eK = pcall(function() return Enum.KeyCode[key] end)
    if sK then CurrentAimKeyEnum = eK; CurrentAimKeyType = "Keyboard" end
end
Options.AimKeybind:OnChanged(UpdateKeyCache)
UpdateKeyCache()
local function IsAimingManual()
    if not Options.ManualAimbot.Value then return false end
    if not CurrentAimKeyEnum then return false end
    return CurrentAimKeyType == "Mouse" and UserInputService:IsMouseButtonPressed(CurrentAimKeyEnum) or UserInputService:IsKeyDown(CurrentAimKeyEnum)
end
local function ShouldTarget(p)
    if not p or p == LocalPlayer or not p.Character then return false end
    local mode = Options.TeamModeDropdown.Value
    if mode == "Any Player" then return true end
    local pTeam = p.Team
    local myTeam = LocalPlayer.Team
    if mode == "Enemy Only" then
        return pTeam ~= myTeam or (not pTeam and not myTeam)
    elseif mode == "Team Only" then
        return pTeam == myTeam and (pTeam ~= nil)
    end
    return true
end
local function GetClosestTarget()
    local target, minScore = nil, 999999
    local mouseLoc = UserInputService:GetMouseLocation()
    local targetPartName = Options.TargetPartDropdown.Value
    local priority = Options.PriorityMode.Value
    local infinite = Options.InfiniteDistance.Value or Options.TPAutoKill.Value
    local maxFOV = infinite and 999999 or Options.FOVSlider.Value
    local specificPlayer = Options.PlayerSelection.Value
    local players = Players:GetPlayers()
    for i = 1, #players do
        local p = players[i]
        if p.UserId == skipTarget then continue end
        if specificPlayer == "All Players" or (specificPlayer == p.Name) then
            if ShouldTarget(p) then
                local char = p.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local chosenPart = targetPartName == "Randomized" and (math.random(1, 3) == 1 and "Head" or "UpperTorso") or targetPartName
                    local part = char:FindFirstChild(chosenPart) or char:FindFirstChild("Head")
                    if part then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        local mouseDistance = (mouseLoc - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if onScreen or infinite then
                            if mouseDistance < maxFOV then
                                _RayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera, Workspace:FindFirstChild("Ignore"), Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("MapIgnore")}
                                local res = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), _RayParams)
                                local isVisible = not res or res.Instance:IsDescendantOf(char) or res.Instance == part
                                if Options.TPAutoKill.Value or (not Options.WallCheck.Value or isVisible) then
                                    local currentScore = 0
                                    if priority == "Closest to Mouse" then currentScore = mouseDistance
                                    elseif priority == "Closest to Player" then currentScore = (part.Position - Camera.CFrame.Position).Magnitude
                                    elseif priority == "Lowest Health" then currentScore = hum.Health end
                                    if currentScore < minScore then
                                        target = part
                                        minScore = currentScore
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end
local ESPContainer = {}
local function CreateESP(p)
    if p == LocalPlayer or ESPContainer[p] then return end
    ESPContainer[p] = {
        Box = Drawing.new("Square"), Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"), HealthFill = Drawing.new("Square")
    }
    local d = ESPContainer[p]; d.Box.Thickness = 1; d.Name.Size = 13; d.Name.Center = true; d.Name.Outline = true
    d.HealthBar.Filled = true; d.HealthBar.Color = Color3.fromRGB(0,0,0); d.HealthFill.Filled = true
end
local function UpdateESP()
    local enabled = Options.ESPToggle.Value; local espColor = Options.ESPColor.Value; local maxDist = Options.ESPDistance.Value
    for p, d in pairs(ESPContainer) do
        local char = p.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
        if enabled and root and ShouldTarget(p) then
            local dist = (root.Position - Camera.CFrame.Position).Magnitude
            if dist < maxDist then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local size = Vector2.new(2000 / screenPos.Z, 3000 / screenPos.Z)
                    local pos = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                    if Options.ESPBoxes.Value then d.Box.Size = size; d.Box.Position = pos; d.Box.Color = espColor; d.Box.Visible = true else d.Box.Visible = false end
                    if Options.ESPNames.Value then d.Name.Position = Vector2.new(screenPos.X, pos.Y-15); d.Name.Text = p.Name; d.Name.Color = espColor; d.Name.Visible = true else d.Name.Visible = false end
                    if Options.ESPHealthBar.Value then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local hRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            d.HealthBar.Size = Vector2.new(4, size.Y); d.HealthBar.Position = Vector2.new(pos.X - 6, pos.Y); d.HealthBar.Visible = true
                            d.HealthFill.Size = Vector2.new(2, size.Y * hRatio); d.HealthFill.Position = Vector2.new(pos.X-5, pos.Y+(size.Y*(1-hRatio))); d.HealthFill.Color = Color3.fromHSV(hRatio*0.3, 1, 1); d.HealthFill.Visible = true
                        end
                    else d.HealthBar.Visible = false; d.HealthFill.Visible = false end
                    continue
                end
            end
        end
        d.Box.Visible = false; d.Name.Visible = false; d.HealthBar.Visible = false; d.HealthFill.Visible = false
    end
end
RunService.Heartbeat:Connect(function()
    if tick() - lastMemoryCheck > 2 then
        lastMemoryCheck = tick()
        local ramUsage = Stats:GetTotalMemoryUsageMb()
        if ramUsage > 4608 then
            if Options.AutoAimShot.Value or Options.ManualAimbot.Value or Options.AimbotAutoShot.Value or Options.TPAutoKill.Value then
                pcall(function()
                    Options.AutoAimShot:SetValue(false)
                    Options.ManualAimbot:SetValue(false)
                    Options.AimbotAutoShot:SetValue(false)
                    Options.TPAutoKill:SetValue(false)
                end)
                Fluent:Notify({Title = "RAM SAFETY", Content = "Extreme RAM usage detected. Disabling Aimbot system.", Duration = 8})
            end
        end
    end
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Options.FOVSlider.Value
    FOVCircle.Visible = (not Options.InfiniteDistance.Value) and (Options.ManualAimbot.Value or Options.AutoAimShot.Value) and Options.ShowFOVToggle.Value
    UpdateESP()
    local isAuto = Options.AutoAimShot.Value
    local isTPAuto = Options.TPAutoKill.Value
    local isManual = IsAimingManual()
    if isAuto or isTPAuto or isManual then
        local target = nil
        if not isManual and currentTarget and currentTarget.Parent then
            local p = Players:GetPlayerFromCharacter(currentTarget.Parent)
            local hum = currentTarget.Parent:FindFirstChildOfClass("Humanoid")
            if p and hum and hum.Health > 0 and ShouldTarget(p) then
                if (tick() - targetStartTime < 2) then
                    target = currentTarget
                else
                    skipTarget = p.UserId
                    currentTarget = nil
                end
            else
                currentTarget = nil
            end
        end
        if not target then
            target = GetClosestTarget()
            if target and not isManual then
                currentTarget = target
                targetStartTime = tick()
                skipTarget = nil
            end
        end
        if target then
            local targetPos = target.Position
            local smoothing = 1 - Options.SmoothingSlider.Value
            if isTPAuto then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local targetRoot = target.Parent:FindFirstChild("HumanoidRootPart")
                if root and targetRoot then
                    local backPos = (targetRoot.CFrame * CFrame.new(0, 0, 3.5)).Position
                    root.CFrame = CFrame.lookAt(backPos, target.Position)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                    smoothing = 0 
                end
            end
            local tHum = target.Parent:FindFirstChildOfClass("Humanoid")
            if not tHum or tHum.Health <= 0 then 
                currentTarget = nil
                return 
            end
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), smoothing)
            if typeof(mouse1click) == "function" then
                if isAuto or isTPAuto or (isManual and Options.AimbotAutoShot.Value) then
                    mouse1click()
                end
            end
        end
    else
        currentTarget = nil
    end
end)
task.spawn(function()
    while task.wait(5) do
        local names = {"All Players"}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        pcall(function() PlayerDropdown:SetValues(names) end)
    end
end)
Players.PlayerAdded:Connect(CreateESP)
for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Window:SelectTab(1)
if SaveManager then
    pcall(function()
        SaveManager:SetLibrary(Fluent); SaveManager:SetFolder("NOTHING_X/settings")
    end)
end
