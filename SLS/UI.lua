
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/XVX"))()
end)
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/Field"))()
end)
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/Delete"))()
end)
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/RJ"))()
end)
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/part%20D"))()
end)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = Fluent:CreateWindow({
    Title = "NOTHING_X",
    SubTitle = "",
    TabWidth = 30,
    Size = UDim2.fromOffset(455, 415),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})
local Tabs = {
    all = Window:AddTab({Title = "", Icon = "list"}),
        hitbox = Window:AddTab({Title = "", Icon = "box"}),
                XXX = Window:AddTab({Title = "", Icon = "code"}),
        XXXV = Window:AddTab({Title = "", Icon = "flag"}),
    keybinds = Window:AddTab({Title = "", Icon = "keyboard"}),
		autogol = Window:AddTab({Title = "", Icon = "menu"}),
    save = Window:AddTab({Title = "", Icon = "save"})
}
Window:SelectTab()
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/ThemesUI"))()
end)
task.spawn(function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local XVIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local isRunning = false
local dubValue = 1
local isTpBallActive = false
local tpConnection
local function teleportFootball(football)
    local team = LocalPlayer.Team
    local goalModel
    if team.Name == "Home" then
        goalModel = workspace.Stadium.Teams.Away.Goal
    elseif team.Name == "Away" then
        goalModel = workspace.Stadium.Teams.Home.Goal
    else
        return
    end
    if goalModel.PrimaryPart then
        football.CFrame = goalModel.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
    else
        local firstPart = goalModel:FindFirstChildWhichIsA("BasePart")
        if firstPart then
            football.CFrame = firstPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

local function TPTowardPlayer()
    local teamPos = LocalPlayer:GetAttribute("TeamPosition") 
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local football = Workspace:FindFirstChild("Misc") and Workspace.Misc:FindFirstChild("Football")
    if not (char and hrp and football) then return end
    football.Position = hrp.Position
    football.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    football.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    if teamPos ~= "GK" then
        hrp.CFrame = CFrame.new(football.Position)
    end
end
local function MID()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCFrame = workspace.Stadium.Field.Grass.CFrame + Vector3.new(0, 50, 0)
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
    end
end
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getEnemyPlayerWithBall(owner)
    local plr = Players:FindFirstChild(owner)
    if plr and plr ~= LocalPlayer then
        return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    end
end
local function getEnemyAgentWithBall()
    local agentsFolder = Workspace:FindFirstChild("Systems") and Workspace.Systems:FindFirstChild("Agents")
    if not agentsFolder then return end
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name
    if not myTeam then return end
    for _, model in ipairs(agentsFolder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("HasBall") and model:GetAttribute("IsHomeOrAway") ~= myTeam then
            return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
        end
    end
end
local function handleFootball(hrp)
    local football = Workspace:FindFirstChild("Misc") and Workspace.Misc:FindFirstChild("Football")
    if not football then return end
    local team = LocalPlayer.Team
    if not team then return end
    local owner = football:GetAttribute("NetworkOwner")
    local teamPos = LocalPlayer:GetAttribute("TeamPosition")
    local player = game.Players.LocalPlayer
    local character = player.Character
    local Xfootball = Workspace.Misc:FindFirstChild("Football")
    if not (character and character:FindFirstChild("HumanoidRootPart")) then return end
    local hrpPos = character.HumanoidRootPart.Position
    local footballPos = football.Position
    if owner ~= LocalPlayer.Name then
        if teamPos ~= "GK" then
            hrp.CFrame = CFrame.new(footballPos + Vector3.new(0, 0, 0))
        end
        Xfootball.Position = hrpPos
        Xfootball.AssemblyLinearVelocity = Vector3.zero
        Xfootball.AssemblyAngularVelocity = Vector3.zero
    else
        if teamPos ~= "GK" then
            MID()
        end
        XVIM:SendMouseButtonEvent(0,0,0,true,game,0)
        XVIM:SendMouseButtonEvent(0,0,0,false,game,0)
        teleportFootball(football)
    end
    if teamPos ~= "GK" then
        local target = (typeof(owner) == "string" and owner ~= LocalPlayer.Name and getEnemyPlayerWithBall(owner))
                       or getEnemyAgentWithBall()
        if target then
            Xfootball.Position = hrpPos
            hrp.CFrame = target.CFrame
            local targetPlayer = Players:FindFirstChild(owner)
            if not targetPlayer or targetPlayer.Team ~= LocalPlayer.Team then
                XVIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                XVIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end
        end
    end
end

local dubautogol = Tabs.autogol:AddInput("Inputautogol", {
    Title = "dub",
    Description = "",
    Default = dubValue, 
    Numeric = true,
    Callback = function(v)
        dubValue = tonumber(v)
    end
})
Tabs.autogol:AddKeybind("Keybind", {
    Title = "Auto Gol :)",
    Mode = "Toggle",
    Default = "F1",
    Callback = function(state)
        isRunning = state
        isTpBallActive = state
        if isTpBallActive then
            tpConnection = RunService.RenderStepped:Connect(TPTowardPlayer)
        else
            if tpConnection then
                tpConnection:Disconnect()
                tpConnection = nil
            end
        end
        if not state then return end
        local char = getChar()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local conn
        conn = RunService.Stepped:Connect(function()
            if not isRunning then 
                conn:Disconnect() 
                return 
            end
            local team = LocalPlayer.Team
            if not team or (team.Name ~= "Home" and team.Name ~= "Away") then return end
            for i = 1, dubValue do  
                if not isRunning then break end  
                handleFootball(hrp)
            end
        end)
    end
})
end)
task.spawn(function()
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "not kick ball (GK)",
    Mode = "Toggle",
    Default = "F3",
    Callback = function()
        task.spawn(function()
            local misc = workspace:FindFirstChild("Misc")
            if not misc then return end
            local footballs = {}
            for _, obj in pairs(misc:GetChildren()) do
                if obj.Name == "Football" then
                    table.insert(footballs, obj)
                end
            end
            if #footballs == 0 then
                misc.ChildAdded:Wait()
                for _, obj in pairs(misc:GetChildren()) do
                    if obj.Name == "Football" then
                        table.insert(footballs, obj)
                    end
                end
            end
            for _, football in pairs(footballs) do
                if football:GetAttribute("Enabled") == nil then
                    football:SetAttribute("Enabled", false)
                end
                local current = football:GetAttribute("Enabled")
                football:SetAttribute("Enabled", not current)
            end
        end)
    end
})
end)
task.spawn(function()
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
Tabs.all:AddSection("Emote")
local SelectedTaunts = {}
local Active = false
local OldTauntsBackup = nil
local function GetAllTaunts()
    local Taunts = {}
    local Folder = ReplicatedStorage.Assets.Items.Taunts
    for _, v in ipairs(Folder:GetChildren()) do
        table.insert(Taunts, v.Name)
    end
    return Taunts
end
local function GetCurrentEquipped()
    local raw = LocalPlayer:GetAttribute("EquippedTaunts")
    if raw and raw ~= "" then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(raw)
        end)
        if ok and typeof(data) == "table" then
            return data
        end
    end
    return {}
end
local function convertSelection(input)
    local result = {}
    for k, v in pairs(input) do
        if typeof(k) == "string" and v == true then
            table.insert(result, k)
        elseif typeof(k) == "number" and typeof(v) == "string" then
            table.insert(result, v)
        end
    end
    return result
end
local function ApplyEmotes()
    if not Active then return end
    if #SelectedTaunts > 4 then return end
    LocalPlayer:SetAttribute("EquippedTaunts", HttpService:JSONEncode(SelectedTaunts))
end
local EmoteDropdown = Tabs.all:AddDropdown("EmoteDropdown", {
    Title = "Emote (Max 4)",
    Values = GetAllTaunts(),
    Multi = true,
    Default = {},
    Callback = function(Value)
        SelectedTaunts = convertSelection(Value)
    end
})
Tabs.all:AddToggle("EnableEmotes", {
    Title = "Emote",
    Default = false,
    Callback = function(state)
        Active = state
        if state then
            OldTauntsBackup = GetCurrentEquipped()
            task.wait(0.05)
            ApplyEmotes()
        else
            if OldTauntsBackup then
                LocalPlayer:SetAttribute("EquippedTaunts", HttpService:JSONEncode(OldTauntsBackup))
            end
        end
    end
})
task.spawn(function()
    while task.wait(0.2) do
        if Active then
            ApplyEmotes()
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Active then
        ApplyEmotes()
    elseif OldTauntsBackup then
        LocalPlayer:SetAttribute("EquippedTaunts", HttpService:JSONEncode(OldTauntsBackup))
    end
end)
end)
task.spawn(function()
Tabs.all:AddSection("Jump / Hip Height / Spam / Pass")
local coreGui = game:GetService("CoreGui")
local sjp = 50
local Loop = true
local sj = Tabs.all:AddSlider("Sliderjump", {
    Title = "Jump Power",
    Description = "",
    Default = 50,
    Min = 50,
    Max = 165,
    Rounding = 0.040,
    Callback = function(v)
        sjp = v
    end
})
task.spawn(function()
    while Loop and task.wait(0.1) do
        local screenGui = coreGui:FindFirstChild("ScreenGui")
        if not screenGui then
            Loop = false
            local p = game.Players.LocalPlayer
            if p and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid.JumpPower = 50
            end
            break
        end
        local p = game.Players.LocalPlayer
        if p and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.JumpPower = sjp
        end
    end
end)
local P = game.Players.LocalPlayer
local def, hsx = 2, 2
local iha = false
local function upd()
    local h = P.Character and P.Character:FindFirstChild("Humanoid")
    if h then h.HipHeight = iha and hsx or def end
end
local function check() iha = P.Team and (P.Team.Name=="Home" or P.Team.Name=="Away") end
P.CharacterAdded:Connect(function() check() upd() end)
P:GetPropertyChangedSignal("Team"):Connect(function() check() upd() end)
if P.Character then check() upd() end
Tabs.all:AddInput("InputHipHeight", {
    Title="Hip Height | on match",
    Description="-3-55 | Default 2",
    Default=def,
    Numeric=false,
    Callback=function(v)
        hsx = math.clamp(tonumber(v) or def, -3, 55)
        if iha then upd() end
    end
})
local pls = game:GetService("Players")
local lp = pls.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local coreGui = game:GetService("CoreGui")
local sp = nil
local pd = nil
local ac, tp_spam, tp_pass = false, false, false
local ts = true
local ci = 0
local hasUpdatedForTeam = false
local function updPlayerList()
    local pl = {}
    local validTeams = {game:GetService("Teams"):FindFirstChild("Home"), game:GetService("Teams"):FindFirstChild("Away")}
    for _, p in ipairs(pls:GetPlayers()) do
        if p ~= lp then
            local teamIndicator = (p.Team == lp.Team and lp.Team and table.find(validTeams, lp.Team)) and " (*)" or ""
            table.insert(pl, p.Name .. teamIndicator)
        end
    end
    table.insert(pl, "none")
    if pd then
        pd:SetValues(pl)
        if sp and pls:FindFirstChild(sp.Name) then
            local teamIndicator = (sp.Team == lp.Team and lp.Team and table.find(validTeams, lp.Team)) and " (*)" or ""
            pd:SetValue(sp.Name .. teamIndicator)
        else
            sp = nil
            pd:SetValue("none")
        end
    end
    return pl
end
pd = Tabs.all:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = updPlayerList(),
    Multi = false,
    Default = "none",
    Callback = function(v)
        if v and v ~= "none" then
            local cleanName = v:gsub(" %(%*%)$", "")
            sp = pls:FindFirstChild(cleanName) or nil
        else
            sp = nil
        end
    end
})
task.spawn(function()
    local lastTeam = lp.Team
    while true do
        if lp.Team ~= lastTeam then
            lastTeam = lp.Team
            local validTeams = {game:GetService("Teams"):FindFirstChild("Home"), game:GetService("Teams"):FindFirstChild("Away")}
            if table.find(validTeams, lp.Team) and not hasUpdatedForTeam then
                updPlayerList()
                hasUpdatedForTeam = true
            elseif not table.find(validTeams, lp.Team) then
                hasUpdatedForTeam = false
            end
        end
        task.wait(1)
    end
end)
pls.PlayerAdded:Connect(function(player)
    if player ~= lp then
        local validTeams = {game:GetService("Teams"):FindFirstChild("Home"), game:GetService("Teams"):FindFirstChild("Away")}
        if player.Team == lp.Team and lp.Team and table.find(validTeams, lp.Team) then
            updPlayerList()
        end
    end
end)
pls.PlayerRemoving:Connect(updPlayerList)
local function tpFbToPlayers()
    while tp_spam do
        local fb = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("Football")
        if fb and lp and lp.Character then
            local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if ts then
                    fb.CFrame = hrp.CFrame
                elseif sp and sp.Character then
                    local spHrp = sp.Character:FindFirstChild("HumanoidRootPart")
                    if spHrp then
                        fb.CFrame = spHrp.CFrame
                    end
                end
            end
            ts = not ts
            task.wait(0.04)
        end
    end
end
local function autoClicker()
    while ac do
        task.wait(ci)
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait()
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end
Tabs.all:AddKeybind("KeybindSpam", {
    Title = "Spam Ball",
    Mode = "Toggle",
    Default = "B",
    Callback = function()
        ac = not ac
        tp_spam = not tp_spam
        if ac then task.spawn(autoClicker) end
        if tp_spam then task.spawn(tpFbToPlayers) end
    end
})
local function tpFbToPlayersPass()
    while tp_pass do
        local fb = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("Football")
        if fb and lp and lp.Character then
            local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
            local networkOwner = fb:GetAttribute("NetworkOwner")
            if networkOwner and typeof(networkOwner) == "string" then
                local localPlayerTeamPosition = lp:GetAttribute("TeamPosition")
                local targetPlayer = pls:FindFirstChild(networkOwner)
                if targetPlayer and targetPlayer.Character and targetPlayer ~= lp then
                    local targetTeamPosition = targetPlayer:GetAttribute("TeamPosition")
                    local targetTeam = targetPlayer.Team
                    local localTeam = lp.Team
                    if targetTeamPosition ~= "GK" and targetTeam ~= localTeam and (not sp or networkOwner ~= sp.Name) then
                        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetHRP then
                            lp.Character.HumanoidRootPart.CFrame = targetHRP.CFrame
                        end
                    end
                    if networkOwner ~= lp.Name and targetTeamPosition ~= "GK" and (not sp or networkOwner ~= sp.Name) and targetTeam ~= localTeam then
                        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait()
                        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                end
            end
            if hrp then
                if sp and sp.Character then
                    local spHrp = sp.Character:FindFirstChild("HumanoidRootPart")
                    if spHrp then
                        if networkOwner == lp.Name then
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait()
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            fb.Position = spHrp.Position
                            fb.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            fb.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        elseif networkOwner ~= sp.Name then
                            fb.Position = hrp.Position
                            fb.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            fb.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                elseif networkOwner ~= lp.Name then
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait()
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    fb.Position = hrp.Position
                    fb.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    fb.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        task.wait(0.04)
    end
end
Tabs.all:AddKeybind("KeybindPass", {
    Title = "Auto Pass Ball",
    Mode = "Toggle",
    Default = "V",
    Callback = function()
        tp_pass = not tp_pass
        if tp_pass then task.spawn(tpFbToPlayersPass) end
    end
})
coreGui.ChildRemoved:Connect(function(child)
    if child.Name == "ScreenGui" then
        tp_spam = false
        tp_pass = false
        sp = nil
        if pd then pd:SetValue("none") end
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ScreenGui"
        screenGui.Parent = coreGui
    end
end)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
Tabs.all:AddSection("TOG")
local antiTackleRunning = false
local tk = Tabs.all:AddToggle("XXTackledToggle", {
    Title = "Anti Tackled (Q)",
    Default = false,
    Callback = function(value)
        antiTackleRunning = value
        if value then
            task.spawn(function()
                while antiTackleRunning do
                    if not CoreGui:FindFirstChild("ScreenGui") then
                        tk:Set(false)
                        break
                    end
                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then
                        task.wait()
                        continue
                    end
                    local hasBall = LocalPlayer:GetAttribute("HasBall")
                    local teamPosition = LocalPlayer:GetAttribute("TeamPosition")
                    if not hasBall or teamPosition == "GK" then
                        task.wait()
                        continue
                    end
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    task.wait() 
                end
            end)
        end
    end
})
local Toggle = Tabs.all:AddToggle("tog2xspeed", {
    Title = "2x speed",
    Description = "Leftshift",
    Default = false,
    Callback = function(Value) end
})
local defaultSpeed = 16
local speedX = 54
local function setSpeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end
local function setupShiftLogic()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.LeftShift and not gameProcessed and Toggle.Value then
            while UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Toggle.Value do
                setSpeed(speedX)
                task.wait()
            end
            setSpeed(defaultSpeed)
        end
    end)
end
setupShiftLogic()
LocalPlayer.CharacterAdded:Connect(setupShiftLogic)
local mctRunning = false
local mct = Tabs.all:AddToggle("MoveCharacterToggle", { 
    Title = "Delete any Block from the pitch", 
    Default = false,
    Callback = function(value)
        mctRunning = value
        if value then
            task.spawn(function()
                while mctRunning do
                    for _, team in pairs({"Home", "Away"}) do
                        local gkFolder = workspace.Stadium.Teams[team].Barriers.Goalkeeper
                        local penalties = workspace.Stadium.Teams[team].Penalties.Barriers
                        for _, obj in pairs(gkFolder:GetChildren()) do
                            if obj:IsA("BasePart") then obj.CanCollide = false end
                        end
                        for _, obj in pairs(penalties:GetChildren()) do
                            if obj:IsA("BasePart") then obj.CanCollide = false end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})
local mctX = Tabs.all:AddToggle("MoveBX", { 
    Title = "Delete Barriers X", 
    Default = false,
    Callback = function(value)
        local barriersFolder = workspace.Stadium.Field.Barriers
        for _, obj in ipairs(barriersFolder:GetChildren()) do
            if obj.Name == "Character" and obj:IsA("BasePart") then
                obj.CanCollide = not value
            end
        end
    end
})
local alw = Tabs.all:AddToggle("TackledToggle", { Title = "Tackled Anti Stay", Default = false })
local ft = Tabs.all:AddToggle("FreezeToggle", { Title = "Disable Freeze", Default = false })
local cuat = Tabs.all:AddToggle("CanUseAbilitiesToggle", { Title = "Enable Controls", Default = false })
local ilr = false
local function mainLoop()
    while ilr do
        if alw.Value then
            LocalPlayer:SetAttribute("Tackled", false)
        end
        if ft.Value then
            LocalPlayer:SetAttribute("DisableControls", false)
            LocalPlayer:SetAttribute("Freeze", false)
        end
        if cuat.Value then
            LocalPlayer:SetAttribute("CanUseAbilities", true)
        end
        task.wait()
    end
end
local function checkLoop()
    if ft.Value or cuat.Value or alw.Value then
        if not ilr then
            ilr = true
            task.spawn(mainLoop)
        end
    else
        ilr = false
    end
end
ft:OnChanged(checkLoop)
cuat:OnChanged(checkLoop)
alw:OnChanged(checkLoop)
local screenGui = CoreGui:FindFirstChild("ScreenGui")
if screenGui then
    screenGui.Destroying:Connect(function()
        ft:SetValue(false)
        cuat:SetValue(false)
        alw:SetValue(false)
    end)
end
local moveFieldToggle = Tabs.all:AddToggle("MoveFieldToggle", {
    Title = "Field",
    Default = false,
    Callback = function(value)
        local field = workspace.Stadium.Field.Bounds:FindFirstChild("Field")
        if not field then return end
        local currentSize = field.Size
        if value then
            field.Size = Vector3.new(currentSize.X, 0, currentSize.Z)
        else
            field.Size = Vector3.new(currentSize.X, 81.67, currentSize.Z)
        end
    end
})
end)
task.spawn(function()
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "Tp ball",
    Mode = "Toggle",
    Default = "LeftControl",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
local football = game.workspace.Misc.Football
        if character and character:FindFirstChild("HumanoidRootPart") and football then
            football.Position = character.HumanoidRootPart.Position
            football.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            football.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
})
end)
task.spawn(function()
local player = game.Players.LocalPlayer
local function TPGOL()
    local football = workspace.Misc:FindFirstChild("Football")
    if not football then
        return
    end
    local team = player.Team
    local goalModel
    if team.Name == "Home" then
        goalModel = workspace.Stadium.Teams.Away.Goal
    elseif team.Name == "Away" then
        goalModel = workspace.Stadium.Teams.Home.Goal
    else
        return
    end
    if goalModel.PrimaryPart then
        football.CFrame = goalModel.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
    else
        local firstPart = goalModel:FindFirstChildWhichIsA("BasePart")
        if firstPart then
            football.CFrame = firstPart.CFrame + Vector3.new(0, 3, 0)
        else
        end
    end
end
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "Gol",
    Mode = "Toggle",
    Default = "G",
    Callback = TPGOL,
    debounce = false
})
end)
task.spawn(function()
local istp = false
local p = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local grass = workspace:WaitForChild("Stadium"):WaitForChild("Field"):WaitForChild("Grass")
local cp = nil
local function createPart()
    if not cp then
        cp = Instance.new("Part")
        cp.Name = "H"
        cp.Size = Vector3.new(0, 0, 0)
        cp.Material = Enum.Material.Neon
        cp.Transparency = 1
        cp.Color = Color3.new(0, 0, 0)
		cp.Shape = Enum.PartType.Ball
        cp.Position = grass.Position + Vector3.new(0, 60, 0)
        cp.Anchored = true
        cp.CanCollide = true
        cp.Parent = workspace
    end
    return cp
end
local function tpFootball()
    local fb = workspace.Misc:FindFirstChild("Football")
    if not fb then
        return
    end
    if not istp then
        istp = true
        fb.AssemblyLinearVelocity = Vector3.zero
        fb.AssemblyAngularVelocity = Vector3.zero
        local part = createPart()
        local tp = part.Position + Vector3.new(0, 2, 0)
        fb.CFrame = CFrame.new(tp)
        task.wait(0.1)
        istp = false
    end
end
if Tabs and Tabs.keybinds then
    Tabs.keybinds:AddKeybind("Keybind", {
        Title = "Stuck ball",
        Mode = "Toggle",
        Default = "H",
        Callback = function()
            tpFootball()
        end
    })
end
end)
task.spawn(function()
Tabs.XXX:AddButton({
    Title = "Join  Pro Server",
    Callback = function()
        local id =  126195208568849
        local p = game.Players.LocalPlayer
        if p then
            game:GetService("TeleportService"):Teleport(id, p)
        end
    end
})
Tabs.XXX:AddButton({
    Title = "Join  7v7 Server",
    Callback = function()
        local iid =  127060568647054
        local pp = game.Players.LocalPlayer
        if pp then
            game:GetService("TeleportService"):Teleport(iid, pp)
        end
    end
})
Tabs.XXX:AddButton({
    Title = "Respawn",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})
end)
task.spawn(function()
local ks, vma = 80, 80
local ce = false
local p = game.Players.LocalPlayer
local h, hrp
local uis = game:GetService("UserInputService")
local ws = game:GetService("Workspace")
local savedCFrame 
local bp 
local controlCoroutine
local function setupChar(c)
    h = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")
    if ce then
        h.WalkSpeed = 0
    else
        h.WalkSpeed = 16
    end
end
p.CharacterAdded:Connect(setupChar)
if p.Character then setupChar(p.Character) end
local s = Tabs.XXX:AddInput("SpeedInput", {
    Title = "Speed -/+",
    Description = "10-250",
    Default = 80,
    Numeric = true,
    Callback = function(v)
        local value = tonumber(v)
        if value then
            ks = math.clamp(value, 10, 250)
        end
    end
})
local vs = Tabs.XXX:AddInput("VerticalInput", {
    Title = "up (X)|down (Z)",
    Description = "10-110",
    Default = 80,
    Numeric = true,
    Callback = function(v)
        local value = tonumber(v)
        if value then
            vma = math.clamp(value, 10, 110)
        end
    end
})
local function startControlLoop()
    if not hrp then return end
    bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bp.P = 1e4
    bp.D = 100
    bp.Position = hrp.Position
    bp.Parent = hrp
    controlCoroutine = coroutine.create(function()
        while ce do
            if hrp and bp then
                bp.Position = savedCFrame.Position 
                h.WalkSpeed = 0
            end
            wait(0.03)
        end
    end)
    coroutine.resume(controlCoroutine)
end
local function stopControlLoop()
    ce = false
    if bp then
        bp:Destroy()
        bp = nil
    end
    if h then
        h.WalkSpeed = 16
    end
    savedCFrame = nil
    controlCoroutine = nil
end
local function togControls()
    if not ce then
        if hrp then
            savedCFrame = hrp.CFrame
        end
        ce = true
        startControlLoop()
    else
        stopControlLoop()
    end
end
local function getValidFootballs()
    local footballs = {}
    for _, obj in ipairs(ws.Misc:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("football") then
            table.insert(footballs, obj)
        end
    end
    return footballs
end
local function moveFbVert(dir)
    if not hrp then warn("No HRP") return end
    local footballs = getValidFootballs()
    if #footballs == 0 then return end
    local ma = dir == "up" and vma or -vma
    for _, fb in ipairs(footballs) do
        fb.Anchored = false
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, ma, 0)
        bv.MaxForce = Vector3.new(10000, 10000, 10000)
        bv.Parent = fb
        game.Debris:AddItem(bv, 0.1)
    end
end
local function kickFbInDir(dir)
    if not hrp then warn("No HRP") return end
    local footballs = getValidFootballs()
    if #footballs == 0 then return end
    local ld
    if dir == "forward" then ld = hrp.CFrame.LookVector
    elseif dir == "backward" then ld = -hrp.CFrame.LookVector
    elseif dir == "left" then ld = -hrp.CFrame.RightVector
    elseif dir == "right" then ld = hrp.CFrame.RightVector
    end
    for _, fb in ipairs(footballs) do
        fb.Anchored = false
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = ld * ks
        bv.MaxForce = Vector3.new(10000, 10000, 10000)
        bv.Parent = fb
        game.Debris:AddItem(bv, 0.1)
    end
end
Tabs.XXX:AddKeybind("Keybind", {
    Title = "control",
    Mode = "Toggle",
    Default = "One",
    Callback = function()
        togControls()
    end
})
uis.InputBegan:Connect(function(i, gp)
    if ce then
        if i.KeyCode == Enum.KeyCode.W and not gp then
            kickFbInDir("forward")
        elseif i.KeyCode == Enum.KeyCode.S and not gp then
            kickFbInDir("backward")
        elseif i.KeyCode == Enum.KeyCode.A and not gp then
            kickFbInDir("left")
        elseif i.KeyCode == Enum.KeyCode.D and not gp then
            kickFbInDir("right")
        end
        if i.KeyCode == Enum.KeyCode.X and not gp then
            moveFbVert("up")
        elseif i.KeyCode == Enum.KeyCode.Z and not gp then
            moveFbVert("down")
        end
    end
end)
end)
task.spawn(function()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnimationService = game:GetService("Animation")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local flightEnabled = false
local bodyVelocity = nil
local bodyGyro = nil
local speed = 100
local maxSpeed = 250
local moveDirection = Vector3.new(0, 0, 0)
local flyAnimation = nil
local animationTrack = nil
local function setupFlyAnimation()
    flyAnimation = Instance.new("Animation")
    flyAnimation.AnimationId = "rbxassetid://3541044388"
    animationTrack = humanoid:LoadAnimation(flyAnimation)
    animationTrack.Priority = Enum.AnimationPriority.Action
end
local function updateCharacter(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    setupFlyAnimation()
    if flightEnabled then
        toggleFlight()
        toggleFlight()
    end
end
player.CharacterAdded:Connect(updateCharacter)
local Slider = Tabs.XXX:AddSlider("SliderSpeedV", {
    Title = "(fly) Speed -/+",
    Description = "",
    Default = 100,
    Min = 10,
    Max = maxSpeed,
    Rounding = 0,
    Callback = function(Value)
        speed = Value
    end
})
local function toggleFlight()
    if flightEnabled then
        flightEnabled = false
        humanoid.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        if animationTrack then
            animationTrack:Stop()
        end
        humanoid.WalkSpeed = 16
    else
        flightEnabled = true
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = 0
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 10000
        bodyGyro.D = 500
        bodyGyro.Parent = rootPart
        if animationTrack then
            animationTrack:Play()
        end
    end
end
local function updateMovement()
    if not flightEnabled then return end
    local move = Vector3.new(0, 0, 0)
    local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
    local backward = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
    local left = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0
    local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
    local camCF = camera.CFrame
    move = move + camCF.LookVector * (forward - backward)
    move = move + camCF.RightVector * (right - left)
    if move.Magnitude > 0 then
        move = move.Unit
    end
    moveDirection = move * speed
end
RunService.RenderStepped:Connect(function()
    if flightEnabled and bodyVelocity and bodyGyro then
        bodyVelocity.Velocity = moveDirection
        local camLook = camera.CFrame.LookVector
        if moveDirection.Magnitude > 0 then
            bodyGyro.CFrame = CFrame.new(Vector3.new(0, 0, 0), moveDirection.Unit)
        else
            bodyGyro.CFrame = CFrame.new(Vector3.new(0, 0, 0), camLook)
        end
    end
end)
UserInputService.InputChanged:Connect(updateMovement)
UserInputService.InputBegan:Connect(updateMovement)
UserInputService.InputEnded:Connect(updateMovement)
Tabs.XXX:AddKeybind("Keybind", {
    Title = "Fly",
    Mode = "Toggle",
    Default = "Two",
    Callback = function()
        toggleFlight()
    end
})
setupFlyAnimation()
end)
task.spawn(function()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local holdingWKey = false
local holdingSKey = false
local holdingAKey = false
local holdingDKey = false
local Speed = 1
local state = {
    active = false,
    heartbeat = nil,
    statusParagraph = nil,
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
state.toggle = function()
    state.active = not state.active
    if state.statusParagraph then
        state.statusParagraph:SetTitle(state.active and "ON" or "OFF")
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
    if state.statusParagraph then
        state.statusParagraph:Destroy()
        state.statusParagraph = nil
    end
    state.active = false
end
Tabs.XXX:AddKeybind("SpeedToggle", {
    Title = "Speed",
    Mode = "Toggle",
    Default = "F",
    Callback = function()
        state.toggle()
    end
})
Tabs.XXX:AddSlider("SpeedSlider", {
    Title = "Speed +/-",
    Default = Speed,
    Min = 0.1,
    Max = 3,
    Rounding = 1.1,
    Callback = function(value)
        Speed = value
    end
})
if not state.statusParagraph then
    state.statusParagraph = Tabs.XXX:AddParagraph({
        Title = "OFF",
        Content = ""
    })
end
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
end)
task.spawn(function()
local Players = game:GetService("Players")
local XVZVIM = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local active = false
local function isGK()
    return LocalPlayer:GetAttribute("TeamPosition") == "GK"
end
local function tapE()
    XVZVIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    XVZVIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end
local function enemyPlayerHRP(ownerName)
    local player = Players:FindFirstChild(ownerName)
    if player and player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            return char.HumanoidRootPart
        end
    end
end
local function enemyAgentHRP()
    local sys = Workspace:FindFirstChild("Systems")
    local agents = sys and sys:FindFirstChild("Agents")
    if not agents then return end
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name
    if not myTeam then return end
    for _, agent in ipairs(agents:GetChildren()) do
        if agent:IsA("Model") and agent:GetAttribute("HasBall") == true then
            local side = agent:GetAttribute("IsHomeOrAway")
            if side and side ~= myTeam then
                return agent:FindFirstChild("HumanoidRootPart") or agent.PrimaryPart
            end
        end
    end
end
Tabs.keybinds:AddKeybind("AltBind", {
    Title = "Steal Ball",
    Mode = "Toggle",
    Default = "Three",
    Callback = function()
        if isGK() then
            active = false
            return
        end
        active = not active
        if not active then return end
        task.spawn(function()
            while active do
                if isGK() then
                    active = false
                    break
                end
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local misc = Workspace:FindFirstChild("Misc")
                local ball = misc and misc:FindFirstChild("Football")
                if not hrp or not ball then
                    active = false
                    break
                end
                local teamName = LocalPlayer.Team and LocalPlayer.Team.Name
                if teamName ~= "Home" and teamName ~= "Away" then
                    active = false
                    break
                end
                local owner = ball:GetAttribute("NetworkOwner")
                if owner == LocalPlayer.Name then
                    active = false
                    break
                end
                local target
                if typeof(owner) == "string" then
                    target = enemyPlayerHRP(owner)
                end
                if not target then
                    target = enemyAgentHRP()
                end
                if target then
                    hrp.CFrame = target.CFrame
                    tapE()
                end
                if owner ~= LocalPlayer.Name then
                    ball.CFrame = hrp.CFrame
                    ball.AssemblyLinearVelocity = Vector3.new()
                    ball.AssemblyAngularVelocity = Vector3.new()
                end
                task.wait(0.1)
            end
        end)
    end
})
end)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local function getNearestPlayer()
    local football = Workspace.Misc:FindFirstChild("Football")
    if not football then return nil end
    local closestPlayer, shortestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and 
           player.Team == LocalPlayer.Team and 
           player.Character and 
           player.Character.PrimaryPart and 
           player.Character.Humanoid.Health > 0 then
            local distance = (player.Character.PrimaryPart.Position - football.Position).Magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end
local function tpFootballToNearestPlayer()
    local football = Workspace.Misc:FindFirstChild("Football")
    if not football then return end
    local nearestPlayer = getNearestPlayer()
    if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character.PrimaryPart then
        local targetPosition = nearestPlayer.Character.PrimaryPart.Position + Vector3.new(0, 0, 0)
        football.AssemblyLinearVelocity = Vector3.zero
        football.AssemblyAngularVelocity = Vector3.zero
        football.CFrame = CFrame.new(targetPosition)
    end
end
if Tabs and Tabs.keybinds then
    Tabs.keybinds:AddKeybind("TeleportFootball", {
        Title = "Tp ball close Teammate",
        Mode = "Toggle",
        Default = "Four",
        Callback = tpFootballToNearestPlayer
    })
end
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
end)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeamsService = game:GetService("Teams")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local positions7v7 = {"None","CF", "LF", "RF", "CM", "LB", "RB", "GK"}
local positions4v4 = {"None","CF", "LF", "RF", "GK"}
local teams = {"None", "Random", "Home", "Away"}
local placeId = game.PlaceId
local currentPositions = positions7v7
if placeId == 12177325772 then
    currentPositions = positions4v4
elseif placeId == 127060568647054 or placeId == 126195208568849 then
    currentPositions = positions7v7
else
    currentPositions = positions7v7 
end
local TeamDropdown = Tabs.XXXV:AddDropdown("Dropdown_Team", {
    Title = "Team",
    Values = teams,
    Multi = false,
    Default = "None"
})
local PositionDropdown = Tabs.XXXV:AddDropdown("Dropdown_Position", {
    Title = "Position",
    Values = currentPositions,
    Multi = false,
    Default = "None"
})
local preChosenTeam = nil
local AutoToggle = Tabs.XXXV:AddToggle("Tog_Auto", {
    Title = "AUTO Join",
    Default = false
})
local AutoScoreToggle = Tabs.XXXV:AddToggle("Tog_ScoreJoin", {
    Title = "AUTO Join Win Team (on Last 3 sek | On Lobby)",
    Default = false
})
local function hasScreenGui()
    return CoreGui:FindFirstChild("ScreenGui") ~= nil
end
local function getRequestJoinEvent()
    local gamemodeComm = ReplicatedStorage:FindFirstChild("__GamemodeComm")
    if not gamemodeComm then return nil end
    local reFolder = gamemodeComm:FindFirstChild("RE")
    if not reFolder then return nil end
    return reFolder:FindFirstChild("_RequestJoin")
end
local function joinTeam(teamName, position, force)
    if teamName == "None" or position == "None" then return end
    if teamName == "Random" then
        if LocalPlayer.Team and LocalPlayer.Team.Name ~= "None" then
            return
        end
        if not preChosenTeam then
            preChosenTeam = (math.random(1, 2) == 1) and "Home" or "Away"
        end
        teamName = preChosenTeam
    end
    if not force and LocalPlayer.Team and (LocalPlayer.Team.Name == "Home" or LocalPlayer.Team.Name == "Away") then
        if teamName ~= "Random" then
            force = true
        else
            return
        end
    end
    local requestJoinEvent = getRequestJoinEvent()
    if requestJoinEvent then
        local teamObj = TeamsService:FindFirstChild(teamName)
        if teamObj then
            local args = {{Team = teamObj, TeamPosition = position}}
            pcall(function()
                requestJoinEvent:FireServer(unpack(args))
                preChosenTeam = nil
            end)
        end
    end
end
local function getRandomPosition()
    return currentPositions[math.random(1, #currentPositions)]
end
local function getScoresAndTime()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("GameGui")
    if not gui then return nil end
    local scoreboard = gui:FindFirstChild("Scoreboard")
    if not scoreboard then return nil end
    local homeScore = tonumber(scoreboard.Home.Score.Text) or 0
    local awayScore = tonumber(scoreboard.Away.Score.Text) or 0
    local timeText = scoreboard.Timer.TimeLeft.Text
    local minutes, seconds = string.match(timeText, "(%d+):(%d+)")
    minutes = tonumber(minutes) or 0
    seconds = tonumber(seconds) or 0
    local totalSeconds = minutes * 60 + seconds
    return homeScore, awayScore, totalSeconds
end
local JoinButton = Tabs.XXXV:AddButton({
    Title = "Join",
    Callback = function()
        joinTeam(TeamDropdown.Value, PositionDropdown.Value, true) 
    end
})
task.spawn(function()
    while true do
        task.wait()
        if not hasScreenGui() then
            AutoToggle:Set(false)
            AutoScoreToggle:Set(false)
        end
        if AutoToggle.Value then
            if not LocalPlayer.Team or LocalPlayer.Team.Name == "None" or TeamDropdown.Value ~= "Random" then
                joinTeam(TeamDropdown.Value, PositionDropdown.Value, false)
            else
                preChosenTeam = nil
            end
        end
        if AutoScoreToggle.Value then
            if not LocalPlayer.Team or LocalPlayer.Team.Name == "None" then
                local homeScore, awayScore, timeLeft = getScoresAndTime()
                if not homeScore or not awayScore or not timeLeft then continue end
                if timeLeft <= 3 then
                    local targetTeam = "Home"
                    if awayScore > homeScore then
                        targetTeam = "Away"
                    end
                    joinTeam(targetTeam, getRandomPosition(), true)
                end
            end
        end
    end
end)
local dsx, dsy, dsz = 4.521276473999023, 5.7297587394714355, 2.397878408432007
local dt, dc = 1, Color3.fromRGB(255, 255, 255)
local hsx, hsy, hsz = dsx, dsy, dsz
local ht, hc = dt, dc
local iha = false
local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local hb = c:FindFirstChild("Hitbox")
local function updRealHb()
    if hb then
        hb.Size = Vector3.new(hsx, hsy, hsz)
        hb.Transparency = ht
        hb.Color = hc
    end
end
local function resetHbToDefault()
    if hb then
        hb.Size = Vector3.new(dsx, dsy, dsz)
        hb.Transparency = dt
        hb.Color = dc
    end
end
local function moveOldHbToNewHb()
    local nhp = c:FindFirstChild("Hitbox")
    if nhp and hb then
        hb.CFrame = nhp.CFrame
        if iha then
            updRealHb()
        else
            resetHbToDefault()
        end
    end
end
p.CharacterAdded:Connect(function(newChar)
    c = newChar
    hb = c:WaitForChild("Hitbox", 10)
end)
local tog = Tabs.hitbox:AddToggle("MyToggle", {
    Title = "ON Hitbox ",
    Default = false
})
tog:OnChanged(function()
    iha = tog.Value
    if iha then
        updRealHb() 
    else
        resetHbToDefault() 
    end
end)
tog:SetValue(false)
local ix = Tabs.hitbox:AddInput("InputX", {
    Title = "Hitbox (X)",
    Description = "1-2048",
    Default = dsx, 
    Numeric = true,
    Callback = function(v)
        hsx = tonumber(v)
        if iha then
            updRealHb()
        end
    end
})
local iy = Tabs.hitbox:AddInput("InputY", {
    Title = "Hitbox (Y)",
    Description = "1-2048",
    Default = dsy, 
    Numeric = true,
    Callback = function(v)
        hsy = tonumber(v)
        if iha then
            updRealHb()
        end
    end
})
local iz = Tabs.hitbox:AddInput("InputZ", {
    Title = "Hitbox (Z)",
    Description = "1-2048",
    Default = dsz, 
    Numeric = true,
    Callback = function(v)
        hsz = tonumber(v)
        if iha then
            updRealHb()
        end
    end
})
local ts = Tabs.hitbox:AddSlider("TransparencySlider", {
    Title = "Transparency",
    Description = "",
    Default = dt, 
    Min = 0,
    Max = 1,
    Rounding = 1.1,
    Callback = function(v)
        ht = v
        if iha then
            updRealHb()
        end
    end
})
ts:SetValue(dt)
local cp = Tabs.hitbox:AddColorpicker("Colorpicker", {
    Title = "Hitbox Color",
    Default = dc 
})
cp:OnChanged(function()
    hc = cp.Value
    if iha then
        updRealHb()
    end
end)
game:GetService("RunService").Heartbeat:Connect(function()
    if iha then
        moveOldHbToNewHb()
    end
end)
local coreGui = game:GetService("CoreGui")
game:GetService("RunService").RenderStepped:Connect(function()
    local hasGui = coreGui:FindFirstChild("ScreenGui")
    if not hasGui and iha then
        iha = false
        tog:SetValue(false)
        resetHbToDefault()
    end
end)
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/pop"))()
end)
task.spawn(function()
wait(5)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local LocalPlayer = Players.LocalPlayer
_G.InfiniteEvade = false
local InfiniteStaminaEnabled = false
local StaminaThread = nil
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Defaults = require(ReplicatedStorage.Shared.Defaults.Movement)
local SharedStates = require(ReplicatedStorage.Shared.SharedInterfaceStates)
local MaxStamina = Defaults.Stamina.Maximum
local StaminaValue = SharedStates.Stamina.Amount
function EnableInfiniteStamina(state)
    InfiniteStaminaEnabled = state
    if state then
        StaminaThread = task.spawn(function()
            while InfiniteStaminaEnabled do
                pcall(function()
                    StaminaValue:set(MaxStamina)
                end)
                task.wait()
            end
        end)
        Fusion.Observer(StaminaValue):onChange(function()
            if InfiniteStaminaEnabled then
                StaminaValue:set(MaxStamina)
            end
        end)
    else
        if StaminaThread then
            task.cancel(StaminaThread)
            StaminaThread = nil
        end
    end
end
local ActionController = Knit.GetController("ActionController")
local ActionService = Knit.GetService("ActionService")
local AnimationController = Knit.GetController("AnimationController")
local MovementController = Knit.GetController("MovementController")
local MatchController = Knit.GetController("MatchController")
local Attributes = require(ReplicatedStorage.Shared.Attributes)
local Enums = require(ReplicatedStorage.Shared.Enums)
local OldPlayAnim = AnimationController.PlayAnimationFromPlayer
AnimationController.PlayAnimationFromPlayer = function(self, player, anim, ...)
    if _G.InfiniteEvade and player == LocalPlayer and anim then
        local name = anim.Name:lower()
        if name:find("fall") or name:find("tackle") or name:find("stun") or name:find("ground") then
            return nil
        end
    end
    return OldPlayAnim(self, player, anim, ...)
end
local OldReloadSpeed = MovementController.ReloadSpeed
MovementController.ReloadSpeed = function(self, ...)
    if _G.InfiniteEvade and LocalPlayer:GetAttribute(Attributes.Agents.WasTackled) then
        return nil
    end
    return OldReloadSpeed(self, ...)
end
local function SetCollision(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanTouch = not state
            part.CanQuery = not state
        end
    end
end
local function InfiniteEvadeLoop()
    if not _G.InfiniteEvade then return end
    LocalPlayer:SetAttribute(Attributes.Agents.WasTackled, nil)
    local FootballComponent = MatchController:GetComponent("Football")
    if FootballComponent:HasFootball() then
        if not ActionController.SingletonActionTimegate:IsLocked() then
            SetCollision(true)
            ActionService.PerformAction:Fire(Enums.Action.Server.Evade)
            LocalPlayer:SetAttribute(Attributes.Agents.IsEvadingClient, true)
            LocalPlayer:SetAttribute(Attributes.Agents.IsEvadingClient, nil)
            SetCollision(false)
        end
    end
end
game:GetService("RunService").Heartbeat:Connect(function()
    if _G.InfiniteEvade then
        pcall(InfiniteEvadeLoop)
    end
end)
EnableInfiniteStamina(true)
_G.InfiniteEvade = true
	end)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("HUB")
SaveManager:BuildConfigSection(Tabs.save)
SaveManager:LoadAutoloadConfig()
