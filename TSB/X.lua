task.spawn(function()
local mainPart = workspace.Map and workspace.Map:FindFirstChild("MainPart")
if not mainPart then
end
local partName = "NOTHING X"
if not workspace:FindFirstChild(partName) then
    local part = Instance.new("Part")
    part.Name = partName
    part.Size = Vector3.new(2048, 1450, 2048)
    part.CFrame = mainPart.CFrame
    part.Color = Color3.new(0, 0, 0)
    part.Material = Enum.Material.Air 
    part.Reflectance = 1 
    part.Transparency = 1 
    part.Locked = true
    part.CastShadow = false
    part.Archivable = false
    part.EnableFluidForces = false
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Anchored = true
    part.Parent = workspace
end
	end)
task.spawn(function()
task.wait(3)
local mainPart = workspace.Map and workspace.Map:FindFirstChild("MainPart")
if not mainPart then
end
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local nothingX = workspace["NOTHING X"]
local spawnPart = workspace.Map.MainPart
local function isOutside()
	local pos = hrp.Position
	local cf = nothingX.CFrame
	local localPos = cf:PointToObjectSpace(pos)
	local s = nothingX.Size / 2
	return localPos.X < -s.X or localPos.X > s.X or
	       localPos.Y < -s.Y or localPos.Y > s.Y or
	       localPos.Z < -s.Z or localPos.Z > s.Z
end
RunService.Heartbeat:Connect(function()
	if not hrp or not hrp.Parent then return end
	if isOutside() then
		hrp.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
		task.wait()   
	end
end)
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	hrp = newChar:WaitForChild("HumanoidRootPart", 5)
end)
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
                SendNotification("NOTHING X", plr.Name .. "  SERIOUS MODE ON", 5)
            end
        else
            if skillType == "strong" then
                if lastState ~= "strong" then
                    createHighlight(char, true)
                    SendNotification("NOTHING X", plr.Name .. "  SERIOUS MODE ON", 5)
                end
                state[plr] = "strong"
            elseif skillType == "weak" and lastState == "strong" then
                createHighlight(char, false)
                state[plr] = "weak"
                SendNotification("NOTHING X", plr.Name .. "  SERIOUS MODE DEATH", 7)
                task.delay(math.random(8,9), function()
                    if state[plr] == "weak" then
                        SendNotification("NOTHING X", plr.Name .. "  SERIOUS MODE END", 5)
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
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/TSB/ThemesUITBS"))()
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
    Max = 6,
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
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local cam = workspace.CurrentCamera
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local flying = false
local bv, bg = nil, nil
local speed = 250
local maxSpeed = 800
local velocity = Vector3.new()
local currentVel = Vector3.new()
local accel = 16
local decel = 11
local tiltMax = 14
local flyAnim = Instance.new("Animation")
flyAnim.AnimationId = "rbxassetid://3541044388"
local track = nil
local function setupAnimation()
    if track then
        track:Stop()
        track:Destroy()
    end
    track = hum:LoadAnimation(flyAnim)
    track.Priority = Enum.AnimationPriority.Action4
end
local function onCharacterAdded(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
    setupAnimation()
    if flying then
        flying = false
        task.wait(0.1)
        toggleFly()
    end
end
plr.CharacterAdded:Connect(onCharacterAdded)
setupAnimation()
local function toggleFly()
    flying = not flying
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
    local forward = UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0
    local backward = UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0
    local left = UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0
    local right = UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0
    local z = forward - backward
    local x = right - left
    local mult = 1
    return z, x, mult
end
RS.Heartbeat:Connect(function(dt)
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
Tabs.XXX:AddKeybind("FlyIY", {
    Title = "Fly",
    Default = "R",
    Mode = "Toggle",
    Callback = toggleFly
})
Tabs.XXX:AddSlider("FlySpeedIY", {
    Title = "Fly Speed",
    Min = 35,
    Max = maxSpeed,
    Default = speed,
    Rounding = 0,
    Callback = function(v)
        speed = v
    end
})
end)
task.spawn(function()
local mainPart = workspace.Map and workspace.Map:FindFirstChild("MainPart")
if not mainPart then
end
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
    for i = 1, 6 do
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
    local maxTries = 1000  
    while tries < maxTries and running do
        if hasTrash() then break end
        local trash = getClosestTrashCan()
        if not trash then
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
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local CamlockEnabled = false
local BasePrediction = 0.15 
local FOV = 150
local CamlockTarget = nil
local function IsAlive(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end
local function getAllHumanoidModels(parent)
    local results = {}
    for _, obj in ipairs(parent:GetChildren()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and hrp then
                table.insert(results, obj)
            end
        end
        if obj:IsA("Folder") or obj:IsA("Model") then
            local subResults = getAllHumanoidModels(obj)
            for _, v in ipairs(subResults) do
                table.insert(results, v)
            end
        end
    end
    return results
end
local function GetClosestTarget()
    local closestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local nearest = nil
    for _, model in ipairs(getAllHumanoidModels(Workspace)) do
        if model ~= LocalPlayer.Character then
            local root = model:FindFirstChild("HumanoidRootPart")
            if root then
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
    return nearest
end
local function GetPingPrediction()
    local ping = LocalPlayer:GetNetworkPing() 
    return ping * 1.2 
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
            Content = "Cam Lock: OFF (you dead)",
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
        BasePrediction = GetPingPrediction()
        local targetPos = CamlockTarget.Position + (CamlockTarget.AssemblyLinearVelocity * BasePrediction)
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
    Title = "Walk Fling Power",
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
local mapFolder = workspace:FindFirstChild("Map")
local trashFolder = mapFolder and mapFolder:FindFirstChild("Trash")
local liveFolder = workspace:FindFirstChild("Live")
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getHumanoidRootOrTorso(character)
    return character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
end
local function getLiveModel()
    if not liveFolder then return nil end
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
    if not trashFolder then return nil end
    maxDist = maxDist or TRASH_DISTANCE
    local char = getCharacter()
    local hrp = getHumanoidRootOrTorso(char)
    if not hrp then return nil end
    local closest = nil
    local shortest = maxDist
    for _, m in ipairs(trashFolder:GetChildren()) do
        if m.Name ~= "Trashcan" then continue end
        if m:GetAttribute("Broken") then continue end
        local part = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
        if not part then continue end
        local dist = (hrp.Position - part.Position).Magnitude
        if dist < shortest then
            shortest = dist
            closest = m
        end
    end
    return closest
end
local function getAllHumanoidModels(parent)
    local results = {}
    for _, obj in ipairs(parent:GetChildren()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and hrp then
                table.insert(results, obj)
            end
            local subResults = getAllHumanoidModels(obj)
            for _, v in ipairs(subResults) do
                table.insert(results, v)
            end
        elseif obj:IsA("Folder") or obj:IsA("Model") then
            local subResults = getAllHumanoidModels(obj)
            for _, v in ipairs(subResults) do
                table.insert(results, v)
            end
        end
    end
    return results
end
local function getClosestTarget()
    local char = getCharacter()
    local localPart = getHumanoidRootOrTorso(char)
    if not localPart then return nil end
    local closestTarget = nil
    local shortestDistance = math.huge
    local humanoidModels = getAllHumanoidModels(Workspace)
    for _, model in ipairs(humanoidModels) do
        if model == char then continue end 
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (hrp.Position - localPart.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestTarget = hrp
            end
        end
    end
    return closestTarget
end
local function teleportBehindTarget()
    if hasTrash() then return end
    if trashFolder and getClosestTrash(TRASH_DISTANCE) then return end
    local char = getCharacter()
    local localPart = getHumanoidRootOrTorso(char)
    if not localPart then return end
    local targetPart = getClosestTarget()
    if not targetPart then return end
    local behindPosition = targetPart.Position - (targetPart.CFrame.LookVector * 1.4)
	local behindPosition = targetPart.Position - (targetPart.CFrame.LookVector * 1.4)
    local behindPosition = targetPart.Position - (targetPart.CFrame.LookVector * 1.4)
	local behindPosition = targetPart.Position - (targetPart.CFrame.LookVector * 1.4)			
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
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local hasUltimate = LocalPlayer:GetAttribute("Ultimate") ~= nil
local hasCharacter = LocalPlayer:GetAttribute("Character") ~= nil
local ToggleUlt
if hasUltimate then
    ToggleUlt = Tabs.XXX:AddToggle("ulttog", { Title = "Show Ultimate %", Default = false })
end
local ToggleClass
if hasCharacter then
    ToggleClass = Tabs.XXX:AddToggle("classtog", { Title = "Show Character Name", Default = false })
end
local ClassColors = {
    ["Bald"]     = Color3.fromRGB(220, 220, 220),
    ["Hunter"]   = Color3.fromRGB( 60, 170, 255),
    ["Monster"]  = Color3.fromRGB(230,  60,  90),
    ["Cyborg"]   = Color3.fromRGB(110, 230, 140),
    ["Ninja"]    = Color3.fromRGB(180, 110, 240),
    ["Batter"]   = Color3.fromRGB(255, 170,  80),
    ["Blade"]    = Color3.fromRGB(240, 220, 100),
    ["Esper"]    = Color3.fromRGB(255, 130, 220),
    ["Purple"]   = Color3.fromRGB(220, 100, 255),
    ["Tech"]     = Color3.fromRGB( 80, 240, 230),
    ["KJ"]       = Color3.fromRGB(255,  90,  90),
}
local function GetClassColor(name)
    return ClassColors[name] or Color3.fromRGB(200, 200, 200)
end
local function UpdateBillboard(player)
    if player == LocalPlayer then return end
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end
    local bb = head:FindFirstChild("CombinedInfoBB")
    if not ToggleUlt.Value and not ToggleClass.Value then
        if bb then bb:Destroy() end
        return
    end
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "CombinedInfoBB"
        bb.Adornee = head
        bb.AlwaysOnTop = true
        bb.MaxDistance = 140
        bb.StudsOffset = Vector3.new(0, 4.2, 0)       
        bb.Size = UDim2.new(5, 0, 1.2, 0)
        bb.LightInfluence = 0
        bb.ResetOnSpawn = false
        bb.Parent = head
        local ultLabel = Instance.new("TextLabel")
        ultLabel.Name = "UltLabel"
        ultLabel.Size = UDim2.new(1, 0, 0.5, 0)
        ultLabel.Position = UDim2.new(0, 0, 0, 0)
        ultLabel.BackgroundTransparency = 1
        ultLabel.Font = Enum.Font.GothamBold
        ultLabel.TextSize = 22
        ultLabel.TextXAlignment = Enum.TextXAlignment.Center
        ultLabel.TextStrokeTransparency = 0.6
        ultLabel.TextStrokeColor3 = Color3.new(0,0,0)
        ultLabel.Visible = false
        ultLabel.Parent = bb
        local classLabel = Instance.new("TextLabel")
        classLabel.Name = "ClassLabel"
        classLabel.Size = UDim2.new(1, 0, 0.5, 0)
        classLabel.Position = UDim2.new(0, 0, 0.52, 0)   
        classLabel.BackgroundTransparency = 1
        classLabel.Font = Enum.Font.GothamSemibold
        classLabel.TextSize = 22
        classLabel.TextXAlignment = Enum.TextXAlignment.Center
        classLabel.TextStrokeTransparency = 0.6
        classLabel.TextStrokeColor3 = Color3.new(0,0,0)
        classLabel.Visible = false
        classLabel.Parent = bb
    end
    local ultLabel   = bb:FindFirstChild("UltLabel")
    local classLabel = bb:FindFirstChild("ClassLabel")
    local visibleLines = 0
    if ultLabel then
        if ToggleUlt.Value then
            local ult = player:GetAttribute("Ultimate") or 0
            local val = math.clamp(math.round(tonumber(ult) or 0), 0, 100)
            ultLabel.Text = val .. "%"
            ultLabel.TextColor3 = (val > 0) and Color3.fromRGB(255, 210, 90) or Color3.fromRGB(220, 220, 130)
            ultLabel.Visible = true
            visibleLines += 1
        else
            ultLabel.Visible = false
        end
    end
    if classLabel then
        if ToggleClass.Value then
            local name = player:GetAttribute("Character") or "???"
            classLabel.Text = name
            classLabel.TextColor3 = GetClassColor(name)
            classLabel.Visible = true
            visibleLines += 1
        else
            classLabel.Visible = false
        end
    end
    if visibleLines == 1 then
        bb.Size = UDim2.new(5, 0, 0.6, 0)
        if ultLabel.Visible then
            ultLabel.Position = UDim2.new(0, 0, 0.25, 0)   
        elseif classLabel.Visible then
            classLabel.Position = UDim2.new(0, 0, 0.25, 0)
        end
    elseif visibleLines == 2 then
        bb.Size = UDim2.new(5, 0, 1.2, 0)
        ultLabel.Position   = UDim2.new(0, 0, 0, 0)
        classLabel.Position = UDim2.new(0, 0, 0.52, 0)
    else
        bb.Size = UDim2.new(5, 0, 0.6, 0)
    end
end
local function UpdateAll()
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer then
            UpdateBillboard(plr)
        end
    end
end
local conn
local function ManageHeartbeat()
    if ToggleUlt.Value or ToggleClass.Value then
        if not conn then
            conn = RunService.Heartbeat:Connect(function()
                if tick() % 0.4 > 0.12 then return end
                UpdateAll()
            end)
        end
    else
        if conn then conn:Disconnect() conn = nil end
    end
end
ToggleUlt:OnChanged(function()
    UpdateAll()
    ManageHeartbeat()
end)
ToggleClass:OnChanged(function()
    UpdateAll()
    ManageHeartbeat()
end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.7)
        UpdateBillboard(plr)
    end)
    plr:GetAttributeChangedSignal("Ultimate"):Connect(function()
        if ToggleUlt.Value then UpdateBillboard(plr) end
    end)
    plr:GetAttributeChangedSignal("Character"):Connect(function()
        if ToggleClass.Value then UpdateBillboard(plr) end
    end)
end)
task.delay(1.5, function()
    if ToggleUlt.Value or ToggleClass.Value then
        UpdateAll()
    end
end)
end)
task.spawn(function()
Tabs.XXX:AddButton({
    Title = "Lay",
    Callback = function()
        local player = game.Players.LocalPlayer  
        local character = player.Character
        if not character then return end
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end
        humanoid.Sit = true
        task.wait(0.1)
        local root = humanoid.RootPart
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)  
        end
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
})
end)
task.spawn(function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local playerChosen = nil        
local viewing = false
local currentTarget = nil
local viewDied = nil
local viewChanged = nil
local dropdownMap = {}
local function buildDropdownValues()
    dropdownMap = {}
    local values = { "None" }
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local display = plr.DisplayName .. " (@" .. plr.Name .. ")"
            table.insert(values, display)
            dropdownMap[display] = plr
        end
    end
    return values
end
local Dropdown = Tabs.XXX:AddDropdown("Dropdown_player", {
    Title = "Player",
    Values = buildDropdownValues(),
    Multi = false,
    Default = "None",
    Callback = function(value)
        playerChosen = dropdownMap[value]
    end
})
local function refreshDropdown()
    local oldTarget = playerChosen
    local values = buildDropdownValues()
    Dropdown:SetValues(values)
    local restored = false
    for display, plr in pairs(dropdownMap) do
        if plr == oldTarget then
            Dropdown:SetValue(display)
            restored = true
            break
        end
    end
    if not restored then
        playerChosen = nil
        Dropdown:SetValue("None")
    end
end
Players.PlayerAdded:Connect(refreshDropdown)
Players.PlayerRemoving:Connect(function(plr)
    if viewing and currentTarget == plr then
        ViewToggle:SetValue(false)
    end
    refreshDropdown()
end)
Tabs.XXX:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        if not playerChosen then return end
        local char = playerChosen.Character
        local myChar = LocalPlayer.Character
        if not (char and myChar) then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if hrp and myHrp then
            myHrp.CFrame = hrp.CFrame
        end
    end
})
local function startView(targetPlayer)
    if viewDied then viewDied:Disconnect() end
    if viewChanged then viewChanged:Disconnect() end
    if not (targetPlayer and targetPlayer.Character) then return end
    local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    currentTarget = targetPlayer
    viewing = true
    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = hum
    viewDied = targetPlayer.CharacterAdded:Connect(function(char)
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        if viewing and currentTarget == targetPlayer then
            Camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
        end
    end)
    viewChanged = Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        if viewing and currentTarget == targetPlayer and targetPlayer.Character then
            local h = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then
                Camera.CameraSubject = h
            end
        end
    end)
end
local function stopView()
    viewing = false
    currentTarget = nil
    if viewDied then viewDied:Disconnect() viewDied = nil end
    if viewChanged then viewChanged:Disconnect() viewChanged = nil end
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            Camera.CameraSubject = hum
        end
    end
end
local ViewToggle
ViewToggle = Tabs.XXX:AddToggle("Viewtog", {
    Title = "View Player",
    Default = false,
    Callback = function(state)
        if not state then
            stopView()
            return
        end
        if not playerChosen then
            ViewToggle:SetValue(false)
            return
        end
        startView(playerChosen)
    end
})
local mainPart = workspace.Map and workspace.Map:FindFirstChild("MainPart")
if not mainPart then
end
local ButtonDummy = Tabs.XXX:AddButton({
    Title = "Teleport to Weakest Dummy",
    Callback = function()
        local dummy = workspace.Live:FindFirstChild("Weakest Dummy")
        if dummy and dummy:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = dummy.HumanoidRootPart.CFrame
        else
        end
    end
})
end)
