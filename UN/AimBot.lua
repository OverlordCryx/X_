local coreGui = game:GetService("CoreGui")
if coreGui:FindFirstChild("ScreenGui") then
    Fluent:Notify({
        Title = "NOTHING X",
        Content = "UI RUNING",
        SubContent = "", 
        Duration = 5
    })
    return
end
task.spawn(function()
loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-UN-AIMBOT"))()
end)
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
	    XXX = Window:AddTab({ Title = "", Icon = "menu" }),
    Settings = Window:AddTab({ Title = "", Icon = "settings" })
}
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/ThemesUI"))()
end)
local proceed = false
Window:Dialog({
    Title = "NOTHING X Load",
    Content = "Load the full script now?",
    Buttons = {
        {
            Title = "NOTHING X Load ..",
            Callback = function()
                proceed = true
            end
        }
    }
})
while not proceed do task.wait(0.1) end
if cancelled then return end

local Options = Fluent.Options
local ConfigLoading = false
local function LoadAllSettings()
    if SaveManager then
        SaveManager:Load("autosave")
        Fluent:Notify({Title = "NOTHING_X", Content = "Settings loaded successfully!", Duration = 3})
    end
end
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
Tabs.Settings:AddButton({
    Title = "Load All Settings",
    Description = "Load your saved config",
    Callback = function()
        LoadAllSettings()
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
    Values = {"All (Auto)", "All Players", "All Objects"},
    Default = "All (Auto)"
})
Tabs.Main:AddParagraph({
    Title = "",
    Content = "-"
})
Tabs.Main:AddToggle("InfiniteDistance", {Title = "Infinite Range (Ignore FOV)", Default = false})
Tabs.Main:AddDropdown("PriorityMode", {Title = "Target Priority", Values = {"Closest to Mouse", "Closest to Player", "Lowest Health"}, Default = "Closest to Mouse"})
Tabs.Main:AddDropdown("TargetPartDropdown", {Title = "Target Part", Values = {"Head", "UpperTorso", "HumanoidRootPart", "Randomized"}, Default = "Head"})
Tabs.Main:AddDropdown("TeamModeDropdown", {Title = "Team Targeting", Values = {"Enemy Only", "Any Player", "Any Objects"}, Default = "Enemy Only"})
Tabs.Main:AddToggle("AllowPlayersAndObjects", {Title = "Target Both Players + Objects", Default = false})
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
local skipTargetUntil = 0
local tpFailTarget = nil
local tpFailStart = 0
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Visible = false
local _RayParams = RaycastParams.new()
_RayParams.FilterType = Enum.RaycastFilterType.Exclude
local CurrentAimKeyEnum = nil
local CurrentAimKeyType = "Mouse"
local lastHumanoidScan = 0
local cachedHumanoidModels = {}
local function RefreshHumanoidModels()
    cachedHumanoidModels = {}
    for _, inst in ipairs(Workspace:GetDescendants()) do
        if inst:IsA("Humanoid") then
            local model = inst.Parent
            if model and model:IsA("Model") and model ~= LocalPlayer.Character then
                table.insert(cachedHumanoidModels, model)
            end
        end
    end
    lastHumanoidScan = tick()
end
local function GetHumanoidModels()
    if tick() - lastHumanoidScan > 2 then
        RefreshHumanoidModels()
    end
    return cachedHumanoidModels
end
local function GetModelTargetPart(model, targetPartName)
    local chosenPart = targetPartName == "Randomized" and (math.random(1, 3) == 1 and "Head" or "UpperTorso") or targetPartName
    return model:FindFirstChild(chosenPart)
        or model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Head")
        or model:FindFirstChildWhichIsA("BasePart")
end
local function GetTargetModel(part)
    if not part then return nil end
    return part:FindFirstAncestorOfClass("Model")
end
local function IsVisibleToCamera(part, model)
    if not part then return false end
    _RayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera, Workspace:FindFirstChild("Ignore"), Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("MapIgnore")}
    local res = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), _RayParams)
    if not res then return true end
    if model and res.Instance:IsDescendantOf(model) then return true end
    return res.Instance == part
end
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
local function IsAimKeyDown()
    if not CurrentAimKeyEnum then return false end
    if CurrentAimKeyType == "Mouse" then
        return UserInputService:IsMouseButtonPressed(CurrentAimKeyEnum)
    end
    return UserInputService:IsKeyDown(CurrentAimKeyEnum)
end
local function IsHoldAimActive()
    if not IsAimKeyDown() then return false end
    return Options.ManualAimbot.Value or Options.AimbotAutoShot.Value
end
local function ShouldTarget(p)
    if not p or p == LocalPlayer or not p.Character then return false end
    local mode = Options.TeamModeDropdown.Value
    if mode == "Any Player" then return true end
    local pTeam = p.Team
    local myTeam = LocalPlayer.Team
    if mode == "Enemy Only" then
        return pTeam ~= myTeam or (not pTeam and not myTeam)
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
    local mode = Options.TeamModeDropdown.Value
    local allowBoth = Options.AllowPlayersAndObjects.Value
    local wantObjects = (specificPlayer == "All Objects") or (specificPlayer == "All (Auto)" and mode == "Any Objects") or allowBoth
    local wantPlayers = (specificPlayer == "All Players") or (specificPlayer == "All (Auto)" and mode ~= "Any Objects") or allowBoth or (specificPlayer ~= "All (Auto)" and specificPlayer ~= "All Players" and specificPlayer ~= "All Objects")
    if skipTarget and tick() > skipTargetUntil then
        skipTarget = nil
    end
    if wantObjects then
        local models = GetHumanoidModels()
        for i = 1, #models do
            local model = models[i]
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = GetModelTargetPart(model, targetPartName)
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    local mouseDistance = (mouseLoc - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if onScreen or infinite then
                        if mouseDistance < maxFOV then
                            local isVisible = IsVisibleToCamera(part, model)
                            if Options.TPAutoKill.Value or isVisible then
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
    if wantPlayers then
        local players = Players:GetPlayers()
        for i = 1, #players do
            local p = players[i]
            if p.UserId == skipTarget then continue end
            if specificPlayer == "All (Auto)" or specificPlayer == "All Players" or specificPlayer == p.Name or allowBoth then
                if ShouldTarget(p) then
                    local char = p.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local part = GetModelTargetPart(char, targetPartName)
                        if part then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            local mouseDistance = (mouseLoc - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            if onScreen or infinite then
                                if mouseDistance < maxFOV then
                            local isVisible = IsVisibleToCamera(part, char)
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
    end
    return target
end
local ESPContainer = {}
local function EnsureESP(model)
    if not model or ESPContainer[model] then return end
    ESPContainer[model] = {
        Box = Drawing.new("Square"), Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"), HealthFill = Drawing.new("Square")
    }
    local d = ESPContainer[model]
    d.Box.Thickness = 1
    d.Name.Size = 13
    d.Name.Center = true
    d.Name.Outline = true
    d.HealthBar.Filled = true
    d.HealthBar.Color = Color3.fromRGB(0,0,0)
    d.HealthFill.Filled = true
end
local function GetModelRoot(model)
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Head")
        or model:FindFirstChildWhichIsA("BasePart")
end
local function UpdateESP()
    local enabled = Options.ESPToggle.Value; local espColor = Options.ESPColor.Value; local maxDist = Options.ESPDistance.Value
    local updated = {}
    local mode = Options.TeamModeDropdown.Value
    local specificPlayer = Options.PlayerSelection.Value
    local allowBoth = Options.AllowPlayersAndObjects.Value
    local useObjects = (specificPlayer == "All Objects") or (specificPlayer == "All (Auto)" and mode == "Any Objects") or allowBoth
    local usePlayers = (specificPlayer == "All Players") or (specificPlayer == "All (Auto)" and mode ~= "Any Objects") or allowBoth
    if useObjects then
        local models = GetHumanoidModels()
        for i = 1, #models do
            local model = models[i]
            local root = GetModelRoot(model)
            if enabled and root then
                EnsureESP(model)
                local dist = (root.Position - Camera.CFrame.Position).Magnitude
                if dist < maxDist then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local size = Vector2.new(2000 / screenPos.Z, 3000 / screenPos.Z)
                        local pos = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                        local d = ESPContainer[model]
                        if Options.ESPBoxes.Value then d.Box.Size = size; d.Box.Position = pos; d.Box.Color = espColor; d.Box.Visible = true else d.Box.Visible = false end
                        if Options.ESPNames.Value then d.Name.Position = Vector2.new(screenPos.X, pos.Y-15); d.Name.Text = model.Name; d.Name.Color = espColor; d.Name.Visible = true else d.Name.Visible = false end
                        if Options.ESPHealthBar.Value then
                            local hum = model:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local hRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                                d.HealthBar.Size = Vector2.new(4, size.Y); d.HealthBar.Position = Vector2.new(pos.X - 6, pos.Y); d.HealthBar.Visible = true
                                d.HealthFill.Size = Vector2.new(2, size.Y * hRatio); d.HealthFill.Position = Vector2.new(pos.X-5, pos.Y+(size.Y*(1-hRatio))); d.HealthFill.Color = Color3.fromHSV(hRatio*0.3, 1, 1); d.HealthFill.Visible = true
                            end
                        else d.HealthBar.Visible = false; d.HealthFill.Visible = false end
                        updated[model] = true
                    end
                end
            end
        end
    end
    if usePlayers then
        local players = Players:GetPlayers()
        for i = 1, #players do
            local p = players[i]
            if p ~= LocalPlayer and ShouldTarget(p) then
                local char = p.Character
                local root = char and GetModelRoot(char)
                if enabled and root then
                    EnsureESP(char)
                    local dist = (root.Position - Camera.CFrame.Position).Magnitude
                    if dist < maxDist then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            local size = Vector2.new(2000 / screenPos.Z, 3000 / screenPos.Z)
                            local pos = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                            local d = ESPContainer[char]
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
                            updated[char] = true
                        end
                    end
                end
            end
        end
    end
    for model, d in pairs(ESPContainer) do
        if not updated[model] then
            d.Box.Visible = false
            d.Name.Visible = false
            d.HealthBar.Visible = false
            d.HealthFill.Visible = false
        end
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
    FOVCircle.Visible = (not Options.InfiniteDistance.Value) and (Options.AutoAimShot.Value or IsHoldAimActive()) and Options.ShowFOVToggle.Value
    UpdateESP()
    local isAuto = Options.AutoAimShot.Value
    local isTPAuto = Options.TPAutoKill.Value
    local isHoldAim = IsHoldAimActive()
    if isAuto or isTPAuto or isHoldAim then
        local target = nil
        if isTPAuto then
            if currentTarget and currentTarget.Parent then
                target = currentTarget
            else
                target = GetClosestTarget()
                if target then
                    currentTarget = target
                    targetStartTime = tick()
                    skipTarget = nil
                end
            end
        elseif not isHoldAim and currentTarget and currentTarget.Parent then
            local p = Players:GetPlayerFromCharacter(currentTarget.Parent)
            local hum = currentTarget.Parent:FindFirstChildOfClass("Humanoid")
            if p and hum and hum.Health > 0 and ShouldTarget(p) then
                if (tick() - targetStartTime < 2) then
                    target = currentTarget
                else
                    skipTarget = p.UserId
                    skipTargetUntil = tick() + 0.5
                    currentTarget = nil
                end
            else
                currentTarget = nil
            end
        end
        if not target then
            target = GetClosestTarget()
            if target and not isHoldAim then
                currentTarget = target
                targetStartTime = tick()
                skipTarget = nil
            end
        end
        if target and isTPAuto then
            local p = Players:GetPlayerFromCharacter(target.Parent)
            if p then
                if tpFailTarget ~= p.UserId then
                    tpFailTarget = p.UserId
                    tpFailStart = tick()
                elseif (tick() - tpFailStart) > 3.4 then
                    skipTarget = p.UserId
                    skipTargetUntil = tick() + 0.5
                    tpFailTarget = nil
                    tpFailStart = 0
                    currentTarget = nil
                    return
                end
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
                local forceVis = (Options.TeamModeDropdown.Value == "Any Objects") or (Options.PlayerSelection.Value == "All Objects") or Options.AllowPlayersAndObjects.Value
                local tModel = GetTargetModel(target)
                local visibleNow = IsVisibleToCamera(target, tModel)
                if (isAuto or isTPAuto or (isHoldAim and Options.AimbotAutoShot.Value)) and (isTPAuto or (not Options.WallCheck.Value and not forceVis) or visibleNow) then
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
        local names = {"All (Auto)", "All Players", "All Objects"}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        pcall(function() PlayerDropdown:SetValues(names) end)
    end
end)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if char ~= LocalPlayer.Character then
            EnsureESP(char)
        end
    end)
end)
for _, p in ipairs(Players:GetPlayers()) do
    if p.Character and p.Character ~= LocalPlayer.Character then
        EnsureESP(p.Character)
    end
end
local player = Players.LocalPlayer
local holdingWKey = false
local holdingSKey = false
local holdingAKey = false
local holdingDKey = false
local Speed = 1.5
local state = {
    active = false,
    heartbeat = nil,
    inputBeganConnection = nil,
    inputEndedConnection = nil
}
local function updateMovement()
    if not state.active then return end
    local moveVector = Vector3.new(0, 0, 0)
    if holdingWKey then
        moveVector = moveVector + Vector3.new(0, 0, -Speed)
    end
    if holdingSKey then
        moveVector = moveVector + Vector3.new(0, 0, Speed)
    end
    if holdingAKey then
        moveVector = moveVector + Vector3.new(-Speed, 0, 0)
    end
    if holdingDKey then
        moveVector = moveVector + Vector3.new(Speed, 0, 0)
    end
    if moveVector.Magnitude > 0 then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.new(moveVector)
        end
    end
end
local function setSpeed(enabled)
    if state.active == enabled then return end
    state.active = enabled
    
    if not syncing then
        syncing = true
        if Options.SpeedToggle then
            Options.SpeedToggle:SetValue(enabled)
        end
        syncing = false
    end

    if state.active then
        if not state.heartbeat then
            state.heartbeat = RunService.Heartbeat:Connect(updateMovement)
        end
    else
        if state.heartbeat then
            state.heartbeat:Disconnect()
            state.heartbeat = nil
        end
    end
end

state.cleanup = function()
    if state.heartbeat then
        state.heartbeat:Disconnect()
        state.heartbeat = nil
    end
    if state.inputBeganConnection then
        state.inputBeganConnection:Disconnect()
        state.inputBeganConnection = nil
    end
    if state.inputEndedConnection then
        state.inputEndedConnection:Disconnect()
        state.inputEndedConnection = nil
    end
    state.active = false
end
Tabs.XXX:AddToggle("SpeedToggle", {
    Title = "Speed",
    Default = false
}):OnChanged(function(value)
    if syncing then return end
    setSpeed(value)
end)

Tabs.XXX:AddKeybind("SpeedKeybind", {
    Title = "Speed",
    Mode = "Toggle",
    Default = "E",
    Callback = function(value)
        if syncing then return end
        setSpeed(value)
    end
})
Tabs.XXX:AddSlider("SpeedSlider", {
    Title = "Speed +/-",
    Default = Speed,
    Min = 0.1,
    Max = 9,
    Rounding = 1.1,
    Callback = function(value)
        Speed = value
    end
})

state.inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then holdingWKey = true
    elseif key == Enum.KeyCode.S then holdingSKey = true
    elseif key == Enum.KeyCode.A then holdingAKey = true
    elseif key == Enum.KeyCode.D then holdingDKey = true
    end
end)
state.inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode
    if key == Enum.KeyCode.W then holdingWKey = false
    elseif key == Enum.KeyCode.S then holdingSKey = false
    elseif key == Enum.KeyCode.A then holdingAKey = false
    elseif key == Enum.KeyCode.D then holdingDKey = false
    end
end)

local plr = Players.LocalPlayer
local cam = workspace.CurrentCamera
local RS = RunService
local UIS = UserInputService
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local flying = false
local bv, bg = nil, nil
local speed = 280
local maxSpeed = 1000
local velocity = Vector3.new()
local currentVel = Vector3.new()
local accel = 16
local decel = 11
local tiltMax = 14
local track = nil
local function onCharacterAdded(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
    if flying then
        flying = false
        task.wait(0.1)
        setFly(true)
    end
end
plr.CharacterAdded:Connect(onCharacterAdded)
local flyState = {}
local function setFly(enabled)
    if flying == enabled then return end
    flying = enabled

    if not syncing then
        syncing = true
        if Options.FlyToggle then
            Options.FlyToggle:SetValue(enabled)
        end
        syncing = false
    end

    if flying then
        hum.PlatformStand = true
        hum.WalkSpeed = 0

        bv = Instance.new("BodyPosition")
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bv.Position = root.Position
        bv.D = 2000
        bv.P = 18000
        bv.Parent = root

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        bg.P = 28000
        bg.D = 2200
        bg.Parent = root

        if track then track:Play(0.2, 1, 1.2) end
    else
        hum.PlatformStand = false
        hum.WalkSpeed = 16

        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        if track then track:Stop(0.3) end

        velocity = Vector3.new()
        currentVel = Vector3.new()
    end
end

local function getMovementInput()
    local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
    local backward = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
    local left = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0
    local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
    local z = forward - backward
    local x = right - left
    local mult = 1
    return z, x, mult
end
RunService.Heartbeat:Connect(function(dt)
    if not flying or not bv or not bg or not root or not root.Parent then
        return
    end
    local z, x, mult = getMovementInput()
    local camLook = cam.CFrame.LookVector
    local camRight = cam.CFrame.RightVector
    local inputDir = (camLook * z) + (camRight * x)
    local targetVel = Vector3.new()
    if inputDir.Magnitude > 0.01 then
        targetVel = inputDir.Unit * (speed * mult)
    end
    local lerpSpeed = (targetVel.Magnitude > 0) and accel or decel
    velocity = velocity:Lerp(targetVel, dt * lerpSpeed)
    currentVel = currentVel:Lerp(velocity, dt * 22)
    bv.Position = root.Position + currentVel * dt * 65
    if currentVel.Magnitude > 3 then
        local moveDir = currentVel.Unit
        local tilt = -x * math.rad(tiltMax)
        local targetCF = CFrame.lookAt(Vector3.new(), moveDir) * CFrame.Angles(0, 0, tilt)
        bg.CFrame = bg.CFrame:Lerp(targetCF, dt * 16)
    else
        bg.CFrame = bg.CFrame:Lerp(CFrame.lookAt(Vector3.new(), camLook), dt * 11)
    end
    if track then
        if currentVel.Magnitude > 14 and z > 0.6 then
            if not track.IsPlaying then
                track:Play(0.1, 1, 1.1)
            end
        else
            if track.IsPlaying then
                track:Stop(0.25)
            end
        end
    end
end)

Tabs.XXX:AddToggle("FlyToggle", {
    Title = "Fly",
    Default = false
}):OnChanged(function(value)
    if syncing then return end
    setFly(value)
end)

Tabs.XXX:AddKeybind("FlyKeybind", {
    Title = "Fly",
    Default = "R",
    Mode = "Toggle",
    Callback = function(value)
        if syncing then return end
        setFly(value)
    end
})

Tabs.XXX:AddSlider("FlySpeedIY", {
    Title = "Fly +/-",
    Min = 35,
    Max = maxSpeed,
    Default = speed,
    Rounding = 0,
    Callback = function(v)
        speed = v
    end
})
Window:SelectTab(1)
if SaveManager then
    pcall(function()
        SaveManager:SetLibrary(Fluent)
        SaveManager:SetFolder("NOTHING_X/settings")
        SaveManager:Load("autosave")
    end)
end
