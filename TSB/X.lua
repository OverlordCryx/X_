task.spawn(function()

local mainPart = workspace.Map and workspace.Map:FindFirstChild("MainPart")
if not mainPart then return end

local partName = "NOTHING X"

if not workspace:FindFirstChild(partName) then
    local part = Instance.new("Part")
    part.Name         = partName
    part.Anchored     = true
    part.CanCollide   = false
    part.Transparency = 1
    part.Material     = Enum.Material.ForceField
    part.BrickColor   = BrickColor.new("Really black")
    part.Size         = Vector3.new(2048, 1400, 2048)
    part.Position     = mainPart.Position
    part.Parent       = workspace
end
	end)

task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local strongSkills = {
    ["Omni Directional Punch"] = true,
    ["Death Counter"] = true,
    ["Serious Punch"] = true,
    ["Table Flip"] = true
}
local weakSkills = {
    ["Consecutive Punches"] = true,
    ["Normal Punch"] = true,
    ["Shove"] = true,
    ["Uppercut"] = true
}
local espEnabled = true
local state = {}
local function createHighlight(char, isStrong)
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hl = char:FindFirstChild("SkillHighlight")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "SkillHighlight"
        hl.Adornee = char
        hl.Parent = char
    end
    hl.FillColor = Color3.fromRGB(0, 0, 0)
    hl.OutlineColor = isStrong and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 165, 0)
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end
local function removeHighlight(char)
    if char then
        local hl = char:FindFirstChild("SkillHighlight")
        if hl then
            hl:Destroy()
        end
    end
end
local function getSkillType(backpack)
    for _, tool in ipairs(backpack:GetChildren()) do
        if strongSkills[tool.Name] then return "strong" end
        if weakSkills[tool.Name] then return "weak" end
    end
end
local function SendNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end
local function updatePlayerHighlight(plr)
    if plr == player then return end 
    local char = plr.Character
    local backpack = plr:FindFirstChildOfClass("Backpack")
    if char and backpack then
        local skillType = getSkillType(backpack)
        local lastState = state[plr]
        if not lastState then
            state[plr] = skillType
            if skillType == "strong" then
                createHighlight(char, true)
                SendNotification("NOTHING", plr.Name .. "SERIOUS MODE-ON", 6)
            end
        else
            if skillType == "strong" then
                if lastState ~= "strong" then
                    createHighlight(char, true)
                    SendNotification("NOTHING X", plr.Name .. " SERIOUS MODE-ON", 6)
                end
                state[plr] = "strong"
            elseif skillType == "weak" and lastState == "strong" then
                createHighlight(char, false)
                state[plr] = "weak"
                SendNotification("NOTHING X", plr.Name .. "SERIOUS MODE-DEATH", 6)
                task.delay(math.random(8,9), function()
                    if state[plr] == "weak" then
                        SendNotification("NOTHING X", plr.Name .. "SERIOUS MODE-END", 6)
                        removeHighlight(char)
                    end
                end)
            end
        end
    end
end
RunService.Heartbeat:Connect(function()
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            updatePlayerHighlight(plr)
        end
    end
end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        updatePlayerHighlight(plr)
    end)
end)
player.CharacterAdded:Connect(function(char)
    task.wait(1)
end)
end)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "NOTHING_X",
    SubTitle = "",
    TabWidth = 0,
    Size = UDim2.fromOffset(333, 430),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})
local Tabs = {
    XXX = Window:AddTab({Title = "", Icon = ""}),
}
Window:SelectTab()
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/SLS/ThemesUI"))()
end)
task.spawn(function()
local speaker = game.Players.LocalPlayer
local speed = 25
local jpower = 50
local HumanModCons = {}
local function SetupWalkSpeed(Char, Human)
    local function WalkSpeedChange()
        if Char and Human then
            Human.WalkSpeed = speed
        end
    end
    WalkSpeedChange() 
    HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or nil
    HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or nil
    HumanModCons.wsLoop = Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
    HumanModCons.wsCA = speaker.CharacterAdded:Connect(function(nChar)
        Char, Human = nChar, nChar:WaitForChild("Humanoid")
        SetupWalkSpeed(Char, Human) 
    end)
end
local function SetupJumpPower(Char, Human)
    local function JumpPowerChange()
        if Char and Human then
            if Human.UseJumpPower then
                Human.JumpPower = jpower
            else
                Human.JumpHeight = jpower
            end
        end
    end
    JumpPowerChange() 
    HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or nil
    HumanModCons.jpCA = (HumanModCons.jpCA and HumanModCons.jpCA:Disconnect() and false) or nil
    HumanModCons.jpLoop = Human:GetPropertyChangedSignal(Human.UseJumpPower and "JumpPower" or "JumpHeight"):Connect(JumpPowerChange)
    HumanModCons.jpCA = speaker.CharacterAdded:Connect(function(nChar)
        Char, Human = nChar, nChar:WaitForChild("Humanoid")
        SetupJumpPower(Char, Human) 
    end)
end
if speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
    local Char = speaker.Character
    local Human = Char:FindFirstChildWhichIsA("Humanoid")
    SetupWalkSpeed(Char, Human)
    SetupJumpPower(Char, Human)
end
speaker.CharacterAdded:Connect(function(Char)
    local Human = Char:WaitForChild("Humanoid")
    SetupWalkSpeed(Char, Human)
    SetupJumpPower(Char, Human)
end)
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
    Default = "E",
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
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local character
local hrp
local trashFolder = workspace:WaitForChild("Map"):WaitForChild("Trash")
local running = false
local debounce = false
local function setupCharacter(char)
    character = char
    hrp = character:WaitForChild("HumanoidRootPart")
end
if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    setupCharacter(char)
end)
local function hasTrash()
    local value = character:GetAttribute("HasTrashcan")
    return value and value ~= ""
end
local function reallyHasNoTrash() 
    for i = 1, 10 do
        if hasTrash() then
            return false
        end
        task.wait() 
    end
    return true
end
local function getClosestTrashCan()
    local closest
    local shortest = math.huge
    for _, model in ipairs(trashFolder:GetChildren()) do
        if model.Name == "Trashcan" and not model:GetAttribute("Broken") then
            local dist = (hrp.Position - model:GetModelCFrame().Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = model
            end
        end
    end
    return closest
end
local function click()
    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end
local function useTrashCan()
    if debounce then return end
    debounce = true
    if hasTrash() then
        debounce = false
        return
    end
    local savedCFrame = hrp.CFrame
    local tries = 0
    local maxTries = 40   
    while tries < maxTries and running do
        if hasTrash() then break end
        local trash = getClosestTrashCan()
        if not trash then
            task.wait(0.4)
            tries += 1
            continue
        end
        hrp.CFrame = trash:GetModelCFrame() * CFrame.new(0, 0, 0) 
        if reallyHasNoTrash() then
            click()
        end
        tries += 1
    end
    if hrp and hrp.Parent then
        hrp.CFrame = savedCFrame
    end
    task.wait()
    debounce = false
end
Tabs.XXX:AddKeybind("TrashKeybind", {
    Title = "Get Trash Can",
    Mode = "Toggle",
    Default = "LeftControl",
    Callback = function(state)
        running = state
        if state then
            Fluent:Notify({
                Title = "X_^",
                Content = "AUTO TRASH → ON",
                Duration = 3
            })
            task.spawn(function()
                while running do
                    useTrashCan()
                    task.wait() 
                end
            end)
        else
            Fluent:Notify({
                Title = "X_^",
                Content = "AUTO TRASH → OFF",
                Duration = 3
            })
        end
    end
})
end)
task.spawn(function()
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local LocalPlayer      = Players.LocalPlayer
local Camera           = Workspace.CurrentCamera
local CamlockEnabled   = false
local Prediction       = 0.135
local FOV              = 150
local CamlockTarget    = nil
local function IsAlive(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end
local function GetClosestTarget()
    local closestDistance = math.huge
    local screenCenter    = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local nearest         = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum  = player.Character:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < closestDistance and dist <= FOV then
                        closestDistance = dist
                        nearest = root
                    end
                end
            end
        end
    end
    local live = Workspace:FindFirstChild("Live")
    if live then
        local dummy = live:FindFirstChild("Weakest Dummy")
        if dummy and dummy:FindFirstChild("HumanoidRootPart") then
            local root = dummy.HumanoidRootPart
            local hum  = dummy:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < closestDistance and dist <= FOV then
                        nearest = root
                    end
                end
            end
        end
    end
    return nearest
end
RunService.RenderStepped:Connect(function()
    if not CamlockEnabled then
        CamlockTarget = nil
        return
    end
    if not IsAlive(LocalPlayer.Character) then
        CamlockEnabled = false
        CamlockTarget = nil
        Fluent:Notify({
            Title = "X_^",
            Content = "Cam Lock: OFF (you died)",
            Duration = 4
        })
        return
    end
    if CamlockTarget and (not CamlockTarget.Parent or not CamlockTarget:IsDescendantOf(Workspace)) then
        CamlockTarget = nil
    end
    if CamlockTarget and not IsAlive(CamlockTarget.Parent) then
        CamlockTarget = nil
    end
    if not CamlockTarget then
        CamlockTarget = GetClosestTarget()
    end
    if CamlockTarget then
        local targetPos = CamlockTarget.Position + (CamlockTarget.AssemblyLinearVelocity * Prediction)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end
end)
Tabs.XXX:AddKeybind("camKeybind", {
    Title = "Lock Cam",
    Mode = "Toggle",
    Default = "Z",           
    Callback = function(value)    
        if value and not IsAlive(LocalPlayer.Character) then
            Fluent:Notify({
                Title = "X_^",
                Content = "Cannot enable Cam Lock - you are dead",
                Duration = 3
            })
            return
        end
        CamlockEnabled = value
        if value then
            CamlockTarget = GetClosestTarget()
            Fluent:Notify({
                Title = "X_^",
                Content = "Cam Lock: ON",
                Duration = 3
            })
        else
            CamlockTarget = nil
            Fluent:Notify({
                Title = "X_^",
                Content = "Cam Lock: OFF",
                Duration = 3
            })
        end
    end
})
end)
task.spawn(function()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local tpEnabled = false
Tabs.XXX:AddKeybind("camKeybind", {
	Title = "TP Click",
	Mode = "Toggle",
	Default = "C",
	Callback = function(value)
		tpEnabled = value
	end
})
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if not tpEnabled then return end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local character = player.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local target = mouse.Target
	if not target then return end 
	if not (target:IsA("BasePart") or target:IsA("Terrain")) then
		return
	end
	hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
end)
end)
task.spawn(function()
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local walkFlingEnabled = false
local walkPower = 100
local character, humanoidRootPart
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
local function toggleWalkFling()
    walkFlingEnabled = not walkFlingEnabled
    Fluent:Notify({
        Title = "X_^",
        Content = "Walk Fling: " .. (walkFlingEnabled and "ON" or "OFF"),
        Duration = 3
    })
    if not walkFlingEnabled then return end
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
Tabs.XXX:AddKeybind("WalkFlingKeybind", {
    Title = "Walk Fling",
    Mode = "Toggle",
    Default = "X",
    Callback = toggleWalkFling
})
Tabs.XXX:AddInput("WalkPowerInput", {
    Title = "",
    Default = tostring(walkPower),
    Placeholder = "Enter Walk Power",
    Numeric = true,
    Callback = function(value)
        walkPower = tonumber(value) or walkPower
    end
})
local Toggle = Tabs.XXX:AddToggle("antiflingtog", {Title = "Anti Fling", Default = false})
local connection
Toggle:OnChanged(function(value)
    if value then
        connection = RunService.Stepped:Connect(function()
            local localCharacter = localPlayer.Character
            if not localCharacter or not localCharacter.PrimaryPart then return end
            local localPosition = localCharacter.PrimaryPart.Position
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character.PrimaryPart then
                    local distance = (player.Character.PrimaryPart.Position - localPosition).Magnitude
                    if distance <= 20 then
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
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end
end)
end)
task.spawn(function()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Toggle = Tabs.XXX:AddToggle("attacktog", {
    Title = "Attack TP",
    Default = false
})
local TRASH_DISTANCE = 11
local trashFolder = workspace:WaitForChild("Map"):WaitForChild("Trash")
local liveFolder = workspace:WaitForChild("Live")
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getHumanoidRootOrTorso(character)
    return character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
end
local function getLiveModel()
    for _, model in ipairs(liveFolder:GetChildren()) do
        if model:IsA("Model") and model.Name:find(LocalPlayer.Name) then
            return model
        end
    end
    return nil
end
local function hasTrash()
    local character = getLiveModel()
    if not character then return false end
    local value = character:GetAttribute("HasTrashcan")
    return value and value ~= ""
end
local function getClosestTrash(maxDist)
    maxDist = maxDist or TRASH_DISTANCE
    local char = getCharacter()
    local hrp = getHumanoidRootOrTorso(char)
    if not hrp then return nil end
    local best, bestDist = nil, maxDist
    for _, m in ipairs(trashFolder:GetChildren()) do
        if m.Name ~= "Trashcan" then continue end
        if m:GetAttribute("Broken") then continue end
        local part =
            m.PrimaryPart
            or m:FindFirstChild("Handle")
            or m:FindFirstChildWhichIsA("BasePart")
        if not part then continue end
        local dist = (hrp.Position - part.Position).Magnitude
        if dist < bestDist then
            bestDist = dist
            best = {
                model = m,
                part = part,
                dist = dist
            }
        end
    end
    return best
end
local function getClosestTarget()
    local char = getCharacter()
    local localPart = getHumanoidRootOrTorso(char)
    if not localPart then return nil end
    local closestTarget = nil
    local shortestDistance = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPart = getHumanoidRootOrTorso(player.Character)
                if targetPart then
                    local dist = (targetPart.Position - localPart.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestTarget = targetPart
                    end
                end
            end
        end
    end
    local dummy = liveFolder:FindFirstChild("Weakest Dummy")
    if dummy and dummy:IsA("Model") then
        local humanoid = dummy:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local targetPart = getHumanoidRootOrTorso(dummy)
            if targetPart then
                local dist = (targetPart.Position - localPart.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestTarget = targetPart
                end
            end
        end
    end
    return closestTarget
end
local function teleportBehindTarget()
    if hasTrash() then return end
    if getClosestTrash(TRASH_DISTANCE) then return end
    local char = getCharacter()
    local localPart = getHumanoidRootOrTorso(char)
    if not localPart then return end
    local targetPart = getClosestTarget()
    if not targetPart then return end
    local behindPosition =
        targetPart.Position - (targetPart.CFrame.LookVector * 1.2)
    localPart.CFrame = CFrame.new(behindPosition)
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not Toggle.Value then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        teleportBehindTarget()
    end
end)
end)
task.spawn(function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ToggleULT = Tabs.XXX:AddToggle("ulttog", {
    Title = "ult %",
    Default = false
})
local ToggleHP = Tabs.XXX:AddToggle("hptog", {
    Title = "hp bar",
    Default = false
})
local function createULTBillboard(player)
    if player == LocalPlayer then return nil end
    local char = player.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    local old = head:FindFirstChild("UltimatePercentDisplay")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "UltimatePercentDisplay"
    bb.Adornee = head
    bb.Size = UDim2.new(3.8, 0, 1.6, 0)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 140
    bb.LightInfluence = 0
    bb.Parent = head
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 255, 0)
    txt.TextStrokeTransparency = 0.6
    txt.TextStrokeColor3 = Color3.new(0, 0, 0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 20
    txt.Text = "0%"
    txt.Parent = bb
    return bb
end
local connectionULT
ToggleULT:OnChanged(function(enabled)
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createULTBillboard(player)
            end
        end
        connectionULT = RunService.Heartbeat:Connect(function(dt)
            if tick() % 0.4 > dt then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = player.Character
                    if char and char:FindFirstChild("Head") then
                        local bb = char.Head:FindFirstChild("UltimatePercentDisplay") or createULTBillboard(player)
                        if bb then
                            local label = bb:FindFirstChildWhichIsA("TextLabel")
                            if label then
                                local ult = player:GetAttribute("Ultimate") or 0
                                local value = math.clamp(math.round(tonumber(ult) or 0), 0, 100)
                                label.Text = value .. "%"
                                label.TextColor3 = (value == 0) and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 190, 60)
                            end
                        end
                    end
                end
            end
        end)
    else
        if connectionULT then
            connectionULT:Disconnect()
            connectionULT = nil
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local bb = head:FindFirstChild("UltimatePercentDisplay")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end)
local function restoreRobloxDisplays(humanoid)
    if humanoid then
        humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.Always
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
    end
end
local function hideRobloxHPBar(humanoid)
    if humanoid then
        humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    end
end
local function createHPBar(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    hideRobloxHPBar(humanoid)
    local old = head:FindFirstChild("CustomHPBar")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "CustomHPBar"
    bb.Adornee = head
    bb.Size = UDim2.new(3.2, 0, 0.4, 0)
    bb.StudsOffset = Vector3.new(0, 1.2, 0)
    bb.AlwaysOnTop = false
    bb.MaxDistance = 80
    bb.LightInfluence = 0
    bb.Parent = head
    local bg = Instance.new("Frame")
    bg.Name = "Frame"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bg.BorderSizePixel = 0
    bg.Parent = bb
    local cornerBg = Instance.new("UICorner")
    cornerBg.CornerRadius = UDim.new(0, 4)
    cornerBg.Parent = bg
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.BorderSizePixel = 0
    fill.Parent = bg
    local cornerFill = Instance.new("UICorner")
    cornerFill.CornerRadius = UDim.new(0, 4)
    cornerFill.Parent = fill
    return bb
end
local connectionHP
ToggleHP:OnChanged(function(enabled)
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createHPBar(player)
            end
        end
        connectionHP = RunService.Heartbeat:Connect(function()
            if tick() % 0.4 > 0.05 then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = player.Character
                    if char and char:FindFirstChild("Head") then
                        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then
                            local bar = char.Head:FindFirstChild("CustomHPBar") or createHPBar(player)
                            if bar and bar:FindFirstChild("Frame") and bar.Frame:FindFirstChild("Fill") then
                                local fill = bar.Frame.Fill
                                local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                                fill.Size = UDim2.new(percent, 0, 1, 0)
                                fill.BackgroundColor3 = Color3.new(1 - percent, percent, 0)
                            end
                            hideRobloxHPBar(humanoid)
                        end
                    end
                end
            end
        end)
    else
        if connectionHP then
            connectionHP:Disconnect()
            connectionHP = nil
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local bar = head:FindFirstChild("CustomHPBar")
                    if bar then bar:Destroy() end
                end
                local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                restoreRobloxDisplays(humanoid)
            end
        end
    end
end)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if ToggleULT.Value then createULTBillboard(player) end
        if ToggleHP.Value then createHPBar(player) end
    end)
end)
task.delay(1.5, function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if ToggleULT.Value then createULTBillboard(player) end
            if ToggleHP.Value then createHPBar(player) end
        end
    end
end)
end)
