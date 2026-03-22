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
task.defer(function()
loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-TSB"))()
end)

local game = game
local workspace = workspace
local getService = game.GetService

local Players = getService(game, "Players")
local RunService = getService(game, "RunService")
local UserInputService = getService(game, "UserInputService")
local StarterGui = getService(game, "StarterGui")
local VirtualInputManager = getService(game, "VirtualInputManager")
local function isSafeTeleportLocked()
    return _G.SafeTeleportLock == true
end
local JoinLeaveHandlers = { add = {}, remove = {} }
local function registerJoinLeave(kind, fn)
    table.insert(JoinLeaveHandlers[kind], fn)
end
local function handleJoinLeave(kind, plr)
    task.defer(function()
        local skipHandlers = false
        if kind == "add" and (not plr or not plr.Parent) then
            skipHandlers = true
        end
        if not skipHandlers then
            for _, fn in ipairs(JoinLeaveHandlers[kind]) do
                pcall(fn, plr)
            end
        end
    end)
end
Players.PlayerAdded:Connect(function(plr)
    handleJoinLeave("add", plr)
end)
Players.PlayerRemoving:Connect(function(plr)
    handleJoinLeave("remove", plr)
end)
task.defer(function()
local map = workspace:FindFirstChild("Map")
local mainPart = map and map:FindFirstChild("MainPart")
if not mainPart then
    return 
end
local partName = "NOTHING X"
if not workspace:FindFirstChild(partName) then
    local part = Instance.new("Part")
    part.Name = partName
    part.Size = Vector3.new(2048, 1600, 2048)
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
task.defer(function()
task.wait(0.2)
local map = workspace:FindFirstChild("Map")
local mainPart = map and map:FindFirstChild("MainPart")
if not mainPart then
    return 
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local map = workspace:FindFirstChild("Map")
local mainPart = map and map:FindFirstChild("MainPart")
local nothingX = workspace:FindFirstChild("NOTHING X")

if not mainPart or not nothingX then
	return
end

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local spawnPart = mainPart

local function isOutside()
	local pos = hrp.Position
	local cf = nothingX.CFrame
	local localPos = cf:PointToObjectSpace(pos)
	local s = nothingX.Size / 2

	return localPos.X < -s.X or localPos.X > s.X
	or localPos.Y < -s.Y or localPos.Y > s.Y
	or localPos.Z < -s.Z or localPos.Z > s.Z
end

local checkTime = 0
local interval = 0

RunService.Heartbeat:Connect(function(dt)

	if _G.SafeTeleportLock then
		return
	end

	checkTime += dt
	if checkTime < interval then return end
	checkTime = 0

	if not hrp or not hrp.Parent then return end

	if isOutside() then
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero
		hrp.CFrame = spawnPart.CFrame + Vector3.new(0,5,0)
	end
end)

player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
end)
end)
local SaveManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/raw/refs/heads/master/Addons/SaveManager.lua"))()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "NOTHING_X",
    SubTitle = "",
    TabWidth = 30,
    Size = UDim2.fromOffset(400, 450),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})
local Tabs = {
    XXX = Window:AddTab({Title = "", Icon = "menu"}),
	TOG = Window:AddTab({Title = "", Icon = "menu"}),
	PLYR = Window:AddTab({Title = "", Icon = "menu"})
}
Window:SelectTab()
task.defer(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/TSB/ThemesUITBS"))()
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
task.defer(function()
local p=game.Players.LocalPlayer;if p.Character then task.wait(0.3)local h=p.Character:WaitForChild("Humanoid")local a=Instance.new("Animation")a.AnimationId="rbxassetid://13499771836"h:LoadAnimation(a):Play()end;p.CharacterAdded:Connect(function(c)task.wait(0.3)local h=c:WaitForChild("Humanoid")local a=Instance.new("Animation")a.AnimationId="rbxassetid://13497875049"h:LoadAnimation(a):Play()end)end)
task.defer(function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
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
local state = {}
local protectConnections = {}
local allowDestroy = {}
local activeTimers = {}
local function SendNotification(title, text, duration)
    Fluent:Notify({
        Title = title,
        Content = text,
        Duration = duration
    })
end
local function safeDestroyHighlight(plr)
    local char = plr.Character
    if not char then return end
    allowDestroy[plr] = true
    local hl = char:FindFirstChild("SkillHighlight")
    if hl then
        hl:Destroy()
    end
    allowDestroy[plr] = false
end
local function createImmortalHighlight(plr, isStrong)
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    safeDestroyHighlight(plr)
    local hl = Instance.new("Highlight")
    hl.Name = "SkillHighlight"
    hl.Adornee = char
    hl.Parent = char
    hl.FillColor = Color3.fromRGB(0,0,0)
    hl.OutlineColor = isStrong and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,165,0)
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    if protectConnections[plr] then
        protectConnections[plr]:Disconnect()
    end
    protectConnections[plr] = char.DescendantRemoving:Connect(function(obj)
        if obj.Name == "SkillHighlight" and state[plr] ~= nil then
            if allowDestroy[plr] then return end
            task.defer(function()
                if state[plr] == "strong" then
                    createImmortalHighlight(plr, true)
                elseif state[plr] == "weak" then
                    createImmortalHighlight(plr, false)
                end
            end)
        end
    end)
end
local function getSkillType(backpack)
    for _, tool in ipairs(backpack:GetChildren()) do
        if strongSkills[tool.Name] then
            return "strong"
        end
        if weakSkills[tool.Name] then
            return "weak"
        end
    end
    return nil
end
local function cancelTimer(plr)
    activeTimers[plr] = nil
end
local function updatePlayer(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    local backpack = plr:FindFirstChildOfClass("Backpack")
    if not char or not backpack then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if humanoid.Health <= 0 then
        cancelTimer(plr)
        state[plr] = nil
        safeDestroyHighlight(plr)
        return
    end
    local skillType = getSkillType(backpack)
    local lastState = state[plr]
    if skillType == "strong" and lastState ~= "strong" then
        cancelTimer(plr)
        state[plr] = "strong"
        createImmortalHighlight(plr, true)
        SendNotification("SERIOUS MODE", plr.Name.." -ACTIVE", 4)
        return
    end
    if skillType == "weak" and lastState == "strong" then
        state[plr] = "weak"
        createImmortalHighlight(plr, false)
        SendNotification("SERIOUS MODE", plr.Name.." -DEATH", 4)
        local currentId = tick()
        activeTimers[plr] = currentId
        task.delay(9.4, function()
            if activeTimers[plr] ~= currentId then return end
            if state[plr] == "weak" then
                state[plr] = nil
                safeDestroyHighlight(plr)
                SendNotification("SERIOUS MODE", plr.Name.." -END", 4)
            end
        end)
        return
    end
end
local function setupPlayer(plr)
    if plr == LocalPlayer then return end
    local function onCharacter()
        cancelTimer(plr)
        state[plr] = nil
        safeDestroyHighlight(plr)
        local backpack = plr:WaitForChild("Backpack")
        local humanoid = plr.Character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            cancelTimer(plr)
            state[plr] = nil
            safeDestroyHighlight(plr)
        end)
        updatePlayer(plr)
        backpack.ChildAdded:Connect(function()
            updatePlayer(plr)
        end)
        backpack.ChildRemoved:Connect(function()
            updatePlayer(plr)
        end)
    end
    if plr.Character then
        onCharacter()
    end
    plr.CharacterAdded:Connect(onCharacter)
end
for _, plr in ipairs(Players:GetPlayers()) do
    setupPlayer(plr)
end
local function cleanupPlayer(plr)
    cancelTimer(plr)
    state[plr] = nil
    allowDestroy[plr] = nil
    if protectConnections[plr] then
        protectConnections[plr]:Disconnect()
        protectConnections[plr] = nil
    end
end
registerJoinLeave("add", setupPlayer)
registerJoinLeave("remove", cleanupPlayer)
end)
task.defer(function()

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
local player = game.Players.LocalPlayer
local function usunPusteAccessory(char)
	if not char then return end
	for _, obj in ipairs(char:GetChildren()) do
		if obj:IsA("Accessory") then
			if not next(obj:GetChildren()) then
				obj:Destroy()
			end
		end
	end
end
if player.Character then
	usunPusteAccessory(player.Character)
end
player.CharacterAdded:Connect(function(char)
	usunPusteAccessory(char)
end)
local nextAccessoryClean = 0
RunService.Heartbeat:Connect(function()
    if tick() >= nextAccessoryClean then
        nextAccessoryClean = tick() + 0.21
		if not isSafeTeleportLocked() then
			if player.Character then
				usunPusteAccessory(player.Character)
			end
		end
    end
end)
local player = Players.LocalPlayer
local holdingWKey = false
local holdingSKey = false
local holdingAKey = false
local holdingDKey = false
local Speed = 1.5
local state = {
    active = false,
    heartbeat = nil,
    statusParagraph = nil,
    inputBeganConnection = nil,
    inputEndedConnection = nil
}
local function updateMovement()
    if isSafeTeleportLocked() then return end
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
        state.statusParagraph:SetTitle(state.active and "Speed : ON" or "Speed : OFF")
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
if not state.statusParagraph then
    state.statusParagraph = Tabs.XXX:AddParagraph({
        Title = "Speed : OFF",
        Content = ""
    })
end
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
        toggleFly()
    end
end
plr.CharacterAdded:Connect(onCharacterAdded)
local flyState = {
    statusParagraph = nil
}
local function toggleFly()
    flying = not flying

    if flyState.statusParagraph then
        flyState.statusParagraph:SetTitle(flying and "Fly : ON" or "Fly : OFF")
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
    if isSafeTeleportLocked() then
        return
    end
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
if not flyState.statusParagraph then
    flyState.statusParagraph = Tabs.XXX:AddParagraph({
        Title = "Fly : OFF",
        Content = ""
    })
end

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
end)
task.wait(0.1)
local playerChosen = nil
task.defer(function()
local map = workspace:FindFirstChild("Map")
local mainPart = map and map:FindFirstChild("MainPart")
if not mainPart then
    return 
end
local player = game.Players.LocalPlayer
local vim = VirtualInputManager
local character
local hrp
local trashFolder = workspace:WaitForChild("Map"):WaitForChild("Trash")
local TrashKeybind = nil
local trashKeybindRunning = false
local debounce = false
local hasTrashFlag = false
local processedTrash = setmetatable({}, { __mode = "k" })
local hasTrashListeners = {}
local trashState = {
    statusParagraph = nil
}
local trashPlayerState = {
    statusParagraph = nil
}
local function notifyHasTrash()
    for _, fn in ipairs(hasTrashListeners) do
        pcall(fn, hasTrashFlag)
    end
end
local function setTrashPlayerKeybindState(state)
    if TrashPlayerKeybind and TrashPlayerKeybind.SetValue then
        pcall(function()
            TrashPlayerKeybind:SetValue(state)
        end)
    end
end
local function setTrashPlayerParagraph(state)
    if not trashPlayerState.statusParagraph and Tabs and Tabs.PLYR then
        trashPlayerState.statusParagraph = Tabs.PLYR:AddParagraph({
            Title = "Trash Player : OFF",
            Content = ""
        })
    end
    if trashPlayerState.statusParagraph then
        trashPlayerState.statusParagraph:SetTitle(state and "Trash Player : ON" or "Trash Player : OFF")
    end
    setTrashPlayerKeybindState(state)
end
local trashPlayer = {
    running = false,
    thread = nil,
    distance = 5,
    target = nil,
    humConn = nil,
    healthConn = nil,
    charConn = nil,
    charRemovingConn = nil
}
local function stopTrashPlayer()
    if _G.NOTHINGX_TrashPlayer then
        _G.NOTHINGX_TrashPlayer.SetRunning(false)
    end
end
local function clearTrashPlayerWatch()
    if trashPlayer.humConn then trashPlayer.humConn:Disconnect() trashPlayer.humConn = nil end
    if trashPlayer.healthConn then trashPlayer.healthConn:Disconnect() trashPlayer.healthConn = nil end
    if trashPlayer.charConn then trashPlayer.charConn:Disconnect() trashPlayer.charConn = nil end
    if trashPlayer.charRemovingConn then trashPlayer.charRemovingConn:Disconnect() trashPlayer.charRemovingConn = nil end
end
local function attachTrashPlayerWatch(plr)
    if trashPlayer.target == plr and (trashPlayer.humConn or trashPlayer.charConn) then
        return
    end
    clearTrashPlayerWatch()
    trashPlayer.target = plr
    if not plr then return end
    trashPlayer.charConn = plr.CharacterAdded:Connect(function()
        attachTrashPlayerWatch(plr)
    end)
    trashPlayer.charRemovingConn = plr.CharacterRemoving:Connect(function()
    end)
end
local trashAttrConn
local startHasTrashObserver
local hasTrash
local lastDeadTeleport = 0
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
    hasTrashFlag = hasTrash()
    notifyHasTrash()
    if trashAttrConn then
        trashAttrConn:Disconnect()
        trashAttrConn = nil
    end
    if startHasTrashObserver then
        startHasTrashObserver()
    end
end)
hasTrash = function()
    if not character then return false end
    local value = character:GetAttribute("HasTrashcan")
    return value and value ~= ""
end
hasTrashFlag = hasTrash()
notifyHasTrash()
local function getRandomTrashCan()
    local candidates = {}
    local fallback = {}
    for _, model in ipairs(trashFolder:GetChildren()) do
        if model.Name == "Trashcan" and not model:GetAttribute("Broken") then
            table.insert(fallback, model)
            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if part then
                local tooClose = false
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                            or plr.Character:FindFirstChild("UpperTorso")
                            or plr.Character:FindFirstChild("Torso")
                        if root and (root.Position - part.Position).Magnitude < 15 then
                            tooClose = true
                            break
                        end
                    end
                end
                if not tooClose then
                    table.insert(candidates, model)
                end
            end
        end
    end
    if #candidates == 0 then
        candidates = fallback
    end
    if #candidates == 0 then
        return nil
    end
    return candidates[math.random(1, #candidates)]
end
local function click()
    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end
local function useTrashCan(isRunning)
    if debounce then return end
    debounce = true
    if isSafeTeleportLocked() then
        debounce = false
        return
    end
    if hasTrashFlag then 
        debounce = false
        return
    end
    if not hrp or not hrp.Parent then
        debounce = false
        return
    end
    local savedCFrame = hrp.CFrame
    local tries = 0
    local maxTries = 180  
    local bodyGyro
    if not hrp:FindFirstChild("TrashGyro") then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "TrashGyro"
        bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0) 
        bodyGyro.P = 5000
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp
    else
        bodyGyro = hrp.TrashGyro
    end
    local function ensureNoCollide(model)
        if processedTrash[model] then return end
        processedTrash[model] = true
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    local currentTrash = getRandomTrashCan()
    while tries < maxTries and isRunning() do
        if isSafeTeleportLocked() then
            task.wait()
        else
            task.wait()
        if hasTrashFlag then break end 
        if not currentTrash or currentTrash:GetAttribute("Broken") then
            currentTrash = getRandomTrashCan()
            if not currentTrash then
                tries = tries + 1
            else
                ensureNoCollide(currentTrash)
                local targetCFrame = currentTrash.PrimaryPart and currentTrash.PrimaryPart.CFrame
                    or currentTrash:FindFirstChildWhichIsA("BasePart", true).CFrame
                if targetCFrame then
                    hrp.CFrame = targetCFrame * CFrame.new(0, -0.1, 0)
                    bodyGyro.CFrame = CFrame.new(hrp.Position, targetCFrame.Position)
                    click()
                end
                tries = tries + 1
            end
        else
            ensureNoCollide(currentTrash)
            local targetCFrame = currentTrash.PrimaryPart and currentTrash.PrimaryPart.CFrame
                or currentTrash:FindFirstChildWhichIsA("BasePart", true).CFrame
            if targetCFrame then
                hrp.CFrame = targetCFrame * CFrame.new(0, -0.1, 0)
                bodyGyro.CFrame = CFrame.new(hrp.Position, targetCFrame.Position)
                click()
            end
            tries = tries + 1
        end
        end
    end
    if hrp and hrp.Parent then
        hrp.CFrame = savedCFrame
    end
    if bodyGyro then
        bodyGyro:Destroy()
    end
    debounce = false
end
local function deliverTrashToPlayer(targetPlayer, behindDist)
    if not hasTrashFlag then return end
    if not hrp or not hrp.Parent then return end
    if not targetPlayer or not targetPlayer.Character then return end

    local targetRoot =
        targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        or targetPlayer.Character:FindFirstChild("UpperTorso")
        or targetPlayer.Character:FindFirstChild("Torso")

    if not targetRoot then return end

    local offset = behindDist or 0.7
    local jitter = -0.26

    local backOffset = -(targetRoot.CFrame.LookVector) * -(offset)
    local targetPos = targetRoot.Position + backOffset + Vector3.new(0, -2.2 + jitter, 0)

    hrp.CFrame = CFrame.new(targetPos, targetRoot.Position)

    click()
end
local function teleportToMainPart()
    if not hrp or not hrp.Parent then return end
    if not mainPart then return end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = mainPart.CFrame + Vector3.new(0, -3, 0)
end
local function startTrashPlayerLoop()
    if trashPlayer.thread then return end
    trashPlayer.thread = task.defer(function()
        while trashPlayer.running do
            if not isSafeTeleportLocked() then
                startHasTrashObserver()
                if not playerChosen then
                    stopTrashPlayer()
                    break
                end
                if playerChosen and not playerChosen.Character then
                    task.wait()
                    continue
                end
                local targetHum = playerChosen.Character and playerChosen.Character:FindFirstChildOfClass("Humanoid")
                if not targetHum or targetHum.Health <= 0 then
                    if not camLockTrashActive then
                        local now = tick()
                        if now - lastDeadTeleport > 1 then
                            lastDeadTeleport = now
                            teleportToMainPart()
                        end
                    end
                    task.wait()
                    continue
                end
                attachTrashPlayerWatch(playerChosen)
                if hasTrashFlag then
                    if playerChosen then
                        deliverTrashToPlayer(playerChosen, trashPlayer.distance or 0.7)
                    end
                else
                    useTrashCan(function() return trashPlayer.running end)
                end
            end
            task.wait()
        end
        clearTrashPlayerWatch()
        trashPlayer.thread = nil
    end)
end
startHasTrashObserver = function()
    if trashAttrConn then return end
    if not character then return end
    hasTrashFlag = hasTrash()
    notifyHasTrash()
    trashAttrConn = character:GetAttributeChangedSignal("HasTrashcan"):Connect(function()
        hasTrashFlag = hasTrash()
        notifyHasTrash()
    end)
end
local function createTrashKeybind()
    if TrashKeybind then return end
    TrashKeybind = Tabs.XXX:AddKeybind("TrashKeybind", {
        Title = "Get Trash Can",
        Mode = "Toggle",
        Default = "LeftControl",
        Callback = function(state)
            if trashPlayer.running then
                if trashState.statusParagraph then
                    trashState.statusParagraph:SetTitle("Trash : OFF")
                end
                return
            end
            trashKeybindRunning = state
            if trashState.statusParagraph then
                trashState.statusParagraph:SetTitle(state and "Trash : ON" or "Trash : OFF")
            end
            if state then
                if _G.NOTHINGX_TrashPlayer then
                    _G.NOTHINGX_TrashPlayer.SetRunning(false)
                end
                startHasTrashObserver()
                task.defer(function()
                    while trashKeybindRunning do
                        if not isSafeTeleportLocked() then
                            useTrashCan(function() return trashKeybindRunning end)
                        end
                        task.wait()
                    end
                end)
            else
                if trashAttrConn then trashAttrConn:Disconnect() trashAttrConn = nil end
            end
        end
    })
end
if not hasTrashFlag then
    createTrashKeybind()
end
if not trashState.statusParagraph then
    trashState.statusParagraph = Tabs.XXX:AddParagraph({
        Title = "Trash : OFF",
        Content = ""
    })
end
_G.NOTHINGX_TrashPlayer = {
    SetRunning = function(state)
        if state and not playerChosen then
            state = false
        end
        trashPlayer.running = state
        if state then
            trashKeybindRunning = false
            if trashState.statusParagraph then
                trashState.statusParagraph:SetTitle("Trash : OFF")
            end
            startHasTrashObserver()
            attachTrashPlayerWatch(playerChosen)
            startTrashPlayerLoop()
        else
            clearTrashPlayerWatch()
        end
        setTrashPlayerParagraph(state)
        setTrashPlayerKeybindState(state)
    end,
    SetDistance = function(v)
        trashPlayer.distance = v
    end,
    EnsureStatus = function()
        setTrashPlayerParagraph(trashPlayer.running)
    end,
    AttachTarget = function(plr)
        attachTrashPlayerWatch(plr)
    end,
    OnHasTrash = function(fn)
        table.insert(hasTrashListeners, fn)
        pcall(fn, hasTrashFlag)
    end,
    HasTrash = function()
        return hasTrashFlag
    end,
    IsRunning = function()
        return trashPlayer.running
    end
}
end)
task.wait(0.1)
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CamlockEnabled = false
local CamlockTarget = nil
local BasePrediction = 0.135
local FOV = 150
local camlockState = { statusParagraph = nil }
local SCAN_INTERVAL = 1.5
local scanTimer = 0
local CachedTargets = {}
local targetPool = workspace:FindFirstChild("Live")
local function IsAlive(model)
    if not model then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end
local function GetRoot(model)
    if not model then return nil end
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Torso")
end
local function RefreshTargets()
    table.clear(CachedTargets)
    targetPool = workspace:FindFirstChild("Live") or targetPool
    if targetPool and targetPool.Parent then
        for _, model in ipairs(targetPool:GetChildren()) do
            if model ~= LocalPlayer.Character and IsAlive(model) then
                local root = GetRoot(model)
                if root then
                    CachedTargets[#CachedTargets + 1] = root
                end
            end
        end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and IsAlive(plr.Character) then
            local root = GetRoot(plr.Character)
            if root then
                CachedTargets[#CachedTargets + 1] = root
            end
        end
    end
end
local function GetClosestTarget()
    local closest = math.huge
    local best = nil
    local screenCenter = Vector2.new(
        Camera.ViewportSize.X/2,
        Camera.ViewportSize.Y/2
    )
    for i = 1, #CachedTargets do
        local root = CachedTargets[i]
        if root and root.Parent and root:IsDescendantOf(workspace) then
            local pos, visible = Camera:WorldToViewportPoint(root.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if dist < closest and dist <= FOV then
                    closest = dist
                    best = root
                end
            end
        end
    end
    return best
end
local function GetPrediction()
    local ping = LocalPlayer:GetNetworkPing() or 0
    return ping * 1.15 + 0.06
end
local camlockConn
local function camlockStep(dt)
    if isSafeTeleportLocked() then
        return
    end
    if not CamlockEnabled then
        CamlockTarget = nil
        if camlockConn then
            camlockConn:Disconnect()
            camlockConn = nil
        end
        return
    end
    if not IsAlive(LocalPlayer.Character) then
        CamlockEnabled = false
        CamlockTarget = nil
        if camlockConn then
            camlockConn:Disconnect()
            camlockConn = nil
        end
        return
    end
    scanTimer = scanTimer + dt
    if scanTimer >= SCAN_INTERVAL then
        scanTimer = 0
        RefreshTargets()
    end
    if CamlockTarget then
        local model = CamlockTarget:FindFirstAncestorOfClass("Model")
        if not model or not IsAlive(model) then
            CamlockTarget = nil
        end
    end
    if not CamlockTarget then
        CamlockTarget = GetClosestTarget()
        if not CamlockTarget then return end
    end
    BasePrediction = GetPrediction()
    local velocity = CamlockTarget.AssemblyLinearVelocity or Vector3.zero
    local predicted = CamlockTarget.Position + velocity * BasePrediction
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, predicted)
end
Tabs.XXX:AddKeybind("camKeybind", {
    Title = "Cam Lock",
    Mode = "Toggle",
    Default = "Z",
    Callback = function(v)
        if v and not IsAlive(LocalPlayer.Character) then return end
        CamlockEnabled = v
        if camlockState.statusParagraph then
            camlockState.statusParagraph:SetTitle(
                v and "CamLock : ON" or "CamLock : OFF"
            )
        end
        if v then
            RefreshTargets()
            CamlockTarget = GetClosestTarget()
            if not camlockConn then
                camlockConn = RunService.RenderStepped:Connect(camlockStep)
            end
        else
            CamlockTarget = nil
            if camlockConn then
                camlockConn:Disconnect()
                camlockConn = nil
            end
        end
    end
})
if not camlockState.statusParagraph then
    camlockState.statusParagraph = Tabs.XXX:AddParagraph({
        Title = "CamLock : OFF",
        Content = ""
    })
end
task.wait(0.1)
local LocalPlayer = Players.LocalPlayer
local speaker = LocalPlayer
local power = 1000
local flingAllPower = 1000
local flingOn = false
local auraFlingOn = false
local clickFlingOn = false
local auraRange = 20
local orbitStepXZ = 0
local orbitStepY = 0
local orbitMax = 1.3
local orbitIncrement = 0.1
local orbitSpeed = 999999999999999
local walkflinging = false
local walkFlingMode = "Normal"
local zero = Vector3.zero
local walkFlingState = {
    statusParagraph = nil
}
local function getRootUniversal(char)
    return char and (
        char:FindFirstChild("HumanoidRootPart") or
        char:FindFirstChild("Torso") or
        char:FindFirstChild("UpperTorso")
    )
end
local function WalkFlingLoop()
    local movel = 0.1
    while walkflinging do
        RunService.Heartbeat:Wait()
        local char = speaker.Character
        local root = getRootUniversal(char)
if char and root then
    if walkFlingMode == "Forward" then
        local vel = root.Velocity
        local lookVector = char.HumanoidRootPart.CFrame.LookVector
        root.Velocity = lookVector * power
        RunService.RenderStepped:Wait()
        root.Velocity = vel
    else 
        local vel = root.Velocity
        root.Velocity = vel * power + Vector3.new(0, power, 0)
        RunService.RenderStepped:Wait()
        root.Velocity = vel
        RunService.Stepped:Wait()
        root.Velocity = vel + Vector3.new(0, movel, 0)
        movel = movel * -1
    end
end
    end
end
Tabs.TOG:AddKeybind("WalkFlingKey", {
    Title = "Walk Fling Toggle",
    Mode = "Toggle",
    Default = "X",
    Callback = function()
        walkflinging = not walkflinging
        if walkFlingState.statusParagraph then
            walkFlingState.statusParagraph:SetTitle(
                walkflinging and "Walk Fling : ON" or "Walk Fling : OFF"
            )
        end
        if walkflinging then
            task.defer(WalkFlingLoop)
        end
    end
})
if not walkFlingState.statusParagraph then
    walkFlingState.statusParagraph = Tabs.TOG:AddParagraph({
        Title = "Walk Fling : OFF",
        Content = ""
    })
end
Tabs.TOG:AddInput("WalkPowerInput", {
    Title = "Walk Fling Power",
    Default = tostring(power),
    Placeholder = "Enter Power or inf",
    Numeric = false,
    Callback = function(Value)
        if Value:lower() == "inf" then
            power = 1e12
        else
            power = tonumber(Value) or power
        end
    end
})
Tabs.TOG:AddDropdown("Dropdown_F_N", {
    Title = "Mode WalkFling",
    Values = {"Normal", "Forward"},
    Multi = false,
    Default = "Normal",
    Callback = function(value)
        walkFlingMode = value
    end
})

Tabs.TOG:AddInput("FlingAllPowerInput", {
    Title = "Fling / Aura Power",
    Default = tostring(flingAllPower),
    Placeholder = "Enter Power or inf",
    Numeric = false,
    Callback = function(Value)
        if Value:lower() == "inf" then
            flingAllPower = 1e12
        else
            flingAllPower = tonumber(Value) or flingAllPower
        end
    end
})
local rangeValues = {}
for i = 5, 450, 5 do
    table.insert(rangeValues, tostring(i))
end
local XXDropdown = Tabs.TOG:AddDropdown("Dropdown_D_F", {
    Title = "Aura Range",
    Values = rangeValues,
    Multi = false,
    Default = "20",
    Callback = function(value)
        auraRange = tonumber(value) or auraRange
    end
})

local function auraFling()
    task.defer(function()
        while auraFlingOn do
            local myChar = LocalPlayer.Character
            local myRoot = getRootUniversal(myChar)
            if myRoot then
                local originalCFrame = myRoot.CFrame
                local p = flingAllPower
                local myPos = myRoot.Position
                local hitAny = false
                for _,player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = getRootUniversal(player.Character)
                        if targetRoot then
                            local dist = (targetRoot.Position - myPos).Magnitude
                            if dist <= auraRange then
                                hitAny = true
                                myRoot.CFrame = targetRoot.CFrame
                                myRoot.AssemblyAngularVelocity = Vector3.new(p,p,p)
                                myRoot.AssemblyLinearVelocity =
                                myRoot.CFrame.LookVector * p + Vector3.new(0,p/2,0)
                            end
                        end
                    end
                end
                if hitAny then
                    task.wait()
                    myRoot.AssemblyAngularVelocity = Vector3.zero
                    myRoot.AssemblyLinearVelocity = Vector3.zero
                    myRoot.CFrame = originalCFrame
                end
            end
            task.wait()
        end
    end)
end
Tabs.TOG:AddToggle("AuraFlingToggle", {
    Title = "Aura Fling",
    Default = false,
    Callback = function(state)
        auraFlingOn = state
        if state then auraFling() end
    end
})

local clickFlingConnection
local clickFlingBusy = false

local function getPlayerFromClickedPart(part)
    local current = part
    while current do
        if current:IsA("Model") then
            local plr = Players:GetPlayerFromCharacter(current)
            if plr and plr ~= LocalPlayer then
                return plr
            end
        end
        current = current.Parent
    end
    return nil
end

local function clickFlingTarget(targetPlayer)
    if clickFlingBusy then return end
    clickFlingBusy = true
    task.defer(function()
        local myChar = LocalPlayer.Character
        local targetChar = targetPlayer and targetPlayer.Character
        local myRoot = getRootUniversal(myChar)
        local targetRoot = getRootUniversal(targetChar)
        if myRoot and targetRoot then
            local savedCFrame = myRoot.CFrame
            local p = flingAllPower
            local t = 0
            local startTime = tick()
            while tick() - startTime < 8 do
                if not clickFlingOn then break end
                targetChar = targetPlayer and targetPlayer.Character
                targetRoot = getRootUniversal(targetChar)
                if not targetRoot or not targetRoot.Parent then break end

                local dt = RunService.Heartbeat:Wait()
                t = t + dt * orbitSpeed

                local orbitDistanceXZ = orbitStepXZ
                local orbitDistanceY = orbitStepY

                orbitStepXZ = orbitStepXZ + orbitIncrement
                orbitStepY = orbitStepY + orbitIncrement

                if orbitStepXZ > orbitMax then orbitStepXZ = 0 end
                if orbitStepY > orbitMax then orbitStepY = 0 end

                local offset = Vector3.new(
                    math.cos(t) * orbitDistanceXZ,
                    orbitDistanceY,
                    math.sin(t) * orbitDistanceXZ
                )

                myRoot.CFrame = targetRoot.CFrame + offset
                myRoot.AssemblyAngularVelocity = Vector3.new(p, p, p)
                myRoot.AssemblyLinearVelocity =
                    targetRoot.CFrame.LookVector * p + Vector3.new(0, p * 0.5, 0)
            end
            myRoot.AssemblyAngularVelocity = zero
            myRoot.AssemblyLinearVelocity = zero
            if myRoot.Parent then
                myRoot.CFrame = savedCFrame
            end
        end
        clickFlingBusy = false
    end)
end

Tabs.TOG:AddToggle("ClickFlingToggle", {
    Title = "Click Fling",
    Default = false,
    Callback = function(state)
        clickFlingOn = state
        if clickFlingConnection then
            clickFlingConnection:Disconnect()
            clickFlingConnection = nil
        end
        if state then
            local mouse = LocalPlayer:GetMouse()
            clickFlingConnection = mouse.Button1Down:Connect(function()
                if not clickFlingOn then return end
                local hitPart = mouse.Target
                local targetPlayer = hitPart and getPlayerFromClickedPart(hitPart)
                if targetPlayer then
                    clickFlingTarget(targetPlayer)
                end
            end)
        end
    end
})


local flingAllConn = nil
local function flingAll()
    if flingAllConn then flingAllConn:Disconnect() end
    local t = 0
    flingAllConn = RunService.Heartbeat:Connect(function(dt)
        if not flingOn then
            if flingAllConn then
                flingAllConn:Disconnect()
                flingAllConn = nil
            end
            local myChar = LocalPlayer.Character
            local myRoot = myChar and getRootUniversal(myChar)
            if myRoot then
                myRoot.AssemblyAngularVelocity = zero
                myRoot.AssemblyLinearVelocity = zero
            end
            return
        end

        local myChar = LocalPlayer.Character
        local myRoot = myChar and getRootUniversal(myChar)
        if not myRoot then return end

        t = t + dt * orbitSpeed
        local p = flingAllPower
        local players = Players:GetPlayers()

        for i = 1, #players do
            local plr = players[i]
            if plr ~= LocalPlayer and plr.Character then
                local targetRoot = getRootUniversal(plr.Character)

                if targetRoot then
                    local orbitDistanceXZ = orbitStepXZ
                    local orbitDistanceY = orbitStepY

                    orbitStepXZ = orbitStepXZ + orbitIncrement
                    orbitStepY = orbitStepY + orbitIncrement

                    if orbitStepXZ > orbitMax then orbitStepXZ = 0 end
                    if orbitStepY > orbitMax then orbitStepY = 0 end

                    local offset = Vector3.new(
                        math.cos(t) * orbitDistanceXZ,
                        orbitDistanceY,
                        math.sin(t) * orbitDistanceXZ
                    )

                    myRoot.CFrame = targetRoot.CFrame + offset
                    myRoot.AssemblyAngularVelocity = Vector3.new(p, p, p)
                    myRoot.AssemblyLinearVelocity =
                        targetRoot.CFrame.LookVector * p +
                        Vector3.new(0, p * 0.5, 0)
                end
            end
        end
    end)
end
Tabs.TOG:AddToggle("FlingAllToggle", {
    Title = "Fling All",
    Default = false,
    Callback = function(state)
        flingOn = state
        if state then
            flingAll()
        end
    end
})


local antifling
local AntiFlingToggle = Tabs.TOG:AddToggle("AntiFling", {
    Title = "Anti Fling",
    Default = false,
    Callback = function(state)
        if state then
            if antifling then
                antifling:Disconnect()
                antifling = nil
            end
            antifling = RunService.Stepped:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= speaker and player.Character then
                        for _, v in pairs(player.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if antifling then
                antifling:Disconnect()
                antifling = nil
            end
        end
    end
})


task.wait(0.1)
local LocalPlayer = Players.LocalPlayer
local attackState = {
    active = false,
    statusParagraph = nil
}
local ATTACK_RATE = 1/120
local MODEL_SCAN_RATE = 0.3
local MAX_TARGET_DISTANCE = 160
local TRASH_DISTANCE = 12
local BACK_OFFSET = 0.97
local MapFolder
local TrashFolder
local LiveFolder
local function refreshFolders()
    MapFolder = workspace:FindFirstChild("Map")
    TrashFolder = MapFolder and MapFolder:FindFirstChild("Trash")
    LiveFolder = workspace:FindFirstChild("Live")
end
refreshFolders()
local Character
local Humanoid
local Root
local function refreshCharacter()
    Character = LocalPlayer.Character
    if not Character then return end
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    Root =
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character.PrimaryPart
        or Character:FindFirstChildWhichIsA("BasePart")
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    refreshCharacter()
end)
refreshCharacter()
local HasTrash = false
local TrashNearby = false
local trashLoopRunning = false
local trashLoopThread
local function startTrashLoop()
    if trashLoopRunning then return end
    trashLoopRunning = true
    trashLoopThread = RunService.Heartbeat:Connect(function()
        if not trashLoopRunning then
            if trashLoopThread then trashLoopThread:Disconnect() trashLoopThread = nil end
            return
        end
        if not isSafeTeleportLocked() then
        if LiveFolder then
            local model = LiveFolder:FindFirstChild(LocalPlayer.Name)
            if model then
                local val = model:GetAttribute("HasTrashcan")
                HasTrash = val and val ~= "" or false
            else
                HasTrash = false
            end
        else
            HasTrash = false
        end

        TrashNearby = false

        if Root and TrashFolder then
            local rootPos = Root.Position

            for _, m in ipairs(TrashFolder:GetChildren()) do
                if m.Name == "Trashcan" and not m:GetAttribute("Broken") then
                    local part = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                    if part then
                        if (rootPos - part.Position).Magnitude < TRASH_DISTANCE then
                            TrashNearby = true
                            break
                        end
                    end
                end
            end
        end
        end
    end)
end
local function stopTrashLoop()
    trashLoopRunning = false
end
local TargetCache = {}
local scanLoopRunning = false
local scanLoopThread
local function isAlive(model)
    local hum = model and model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end
local lastScanTime = 0
local function startScanLoop()
    if scanLoopRunning then return end
    scanLoopRunning = true
    scanLoopThread = RunService.Heartbeat:Connect(function()
        if not scanLoopRunning then
            if scanLoopThread then scanLoopThread:Disconnect() scanLoopThread = nil end
            return
        end
        local now = tick()
        if now - lastScanTime < MODEL_SCAN_RATE then return end
        lastScanTime = now

        if not isSafeTeleportLocked() then
            table.clear(TargetCache)
            if Root then
                local rootPos = Root.Position
                local localChar = Character
                if LiveFolder then
                    for _, model in ipairs(LiveFolder:GetChildren()) do
                        if model ~= localChar and isAlive(model) then
                            local part =
                                model:FindFirstChild("HumanoidRootPart")
                                or model.PrimaryPart
                                or model:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local dist = (rootPos - part.Position).Magnitude
                                if dist < MAX_TARGET_DISTANCE then
                                    table.insert(TargetCache, {part = part, dist = dist})
                                end
                            end
                        end
                    end
                end
                if #TargetCache == 0 then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and isAlive(plr.Character) then
                            local part =
                                plr.Character:FindFirstChild("HumanoidRootPart")
                                or plr.Character.PrimaryPart
                            if part then
                                local dist = (rootPos - part.Position).Magnitude
                                if dist < MAX_TARGET_DISTANCE then
                                    table.insert(TargetCache, {part = part, dist = dist})
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
local function stopScanLoop()
    scanLoopRunning = false
    table.clear(TargetCache)
end
local function getClosestTarget()
    local closest
    local shortest = math.huge
    for i = 1, #TargetCache do
        local entry = TargetCache[i]
        if entry.part and entry.part.Parent then
            if entry.dist < shortest then
                shortest = entry.dist
                closest = entry.part
            end
        end
    end
    return closest
end
local function getAttackTarget()
    if CamlockEnabled then
        local t = CamlockTarget
        if t and t.Parent and t:IsDescendantOf(workspace) then
            local model = t:FindFirstAncestorOfClass("Model")
            local hum = model and model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and Root then
                local dist = (t.Position - Root.Position).Magnitude
                if dist <= MAX_TARGET_DISTANCE then
                    return t
                end
                return nil
            end
            if hum and hum.Health > 0 then
                return t
            end
        end
        return getClosestTarget()
    end
    return getClosestTarget()
end
local holdingMouse = false
local attackLoopRunning = false
local lastAttackTime = 0
local attackLoopThread = nil
local function startAttackLoop()
    if attackLoopRunning then return end
    attackLoopRunning = true
    attackLoopThread = RunService.Heartbeat:Connect(function()
        if not attackLoopRunning then
            if attackLoopThread then attackLoopThread:Disconnect() attackLoopThread = nil end
            return
        end
        local now = tick()
        if now - lastAttackTime < ATTACK_RATE then return end
        lastAttackTime = now

        if not isSafeTeleportLocked() then
            if attackState.active and holdingMouse and Root and not HasTrash and not TrashNearby then
                local target = getAttackTarget()
                if target then
                    if Humanoid then
                        Humanoid.AutoRotate = false
                    end
                    local behindPos =
                        target.Position - (target.CFrame.LookVector * BACK_OFFSET)
                    Root.CFrame = CFrame.lookAt(behindPos, target.Position)
                end
            end
        end
    end)
end
local function stopAttackLoop()
    attackLoopRunning = false
    holdingMouse = false
    if Humanoid then
        Humanoid.AutoRotate = true
    end
end
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not attackState.active then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = false
    end
end)
local function setAttackState(enabled)
    attackState.active = enabled
    if attackState.statusParagraph then
        attackState.statusParagraph:SetTitle(enabled and "Attack TP : ON" or "Attack TP : OFF")
    end
    if enabled then
        refreshFolders()
        refreshCharacter()
        startTrashLoop()
        startScanLoop()
        startAttackLoop()
    else
        stopAttackLoop()
        stopTrashLoop()
        stopScanLoop()
    end
end

Tabs.XXX:AddKeybind("AttackTPKeybind", {
    Title = "Attack TP",
    Mode = "Toggle",
    Default = "T",
    Callback = function()
        setAttackState(not attackState.active)
    end
})
if not attackState.statusParagraph then
    attackState.statusParagraph = Tabs.XXX:AddParagraph({
        Title = "Attack TP : OFF",
        Content = ""
    })
end
task.wait(0.1)
local LocalPlayer = Players.LocalPlayer
local stayPos
local conn
local gyro
local isActive = false 
local function cleanup()
    if conn then
        conn:Disconnect()
        conn = nil
    end
    if gyro then
        gyro:Destroy()
        gyro = nil
    end
    stayPos = nil
end
LocalPlayer.CharacterAdded:Connect(function()
    if isActive then
        cleanup()
        if StayToggle and StayToggle.SetValue then
            StayToggle:SetValue(false)
        end
        isActive = false
    end
end)
StayToggle = Tabs.TOG:AddToggle("StayToggle", {
    Title = "Stay",
    Default = false,
    Callback = function(state)
        isActive = state
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if state then
            stayPos = root.Position
            gyro = Instance.new("BodyGyro")
            gyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
            gyro.P = 1e6
            gyro.CFrame = root.CFrame
            gyro.Parent = root
            conn = RunService.RenderStepped:Connect(function()
                if isSafeTeleportLocked() then
                    return
                end
                if root and stayPos then
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.CFrame = CFrame.new(stayPos) * CFrame.Angles(
                        0,
                        math.rad(root.Orientation.Y),
                        0
                    )
                    if gyro then
                        gyro.CFrame = root.CFrame
                    end
                end
            end)
        else
            cleanup()
        end
    end
})
local player = Players.LocalPlayer
local character
local communicate
local directions = {
    Enum.KeyCode.A,
    Enum.KeyCode.D,
    Enum.KeyCode.S,
}
local DashBlockRunning = false
local DashThread = nil
local Dashblock
local communicateConn
local function createDashToggle()
    if Dashblock then return end
    if not communicate then return end
    Dashblock = Tabs.TOG:AddToggle("DashBlock", {
        Title = "Dash Block FE",
        Default = false,
        Callback = function(state)
            if state and not communicate then
                return
            end
            DashBlockRunning = state
            if state then
                if DashThread then DashThread:Disconnect() end
                DashThread = RunService.Heartbeat:Connect(function()
                    if not DashBlockRunning then
                        if DashThread then DashThread:Disconnect() DashThread = nil end
                        return
                    end
                    if not isSafeTeleportLocked() then
                        if not communicate then
                            DashBlockRunning = false
                            return
                        end
                        for _, dashKey in ipairs(directions) do
                            communicate:FireServer({
                                Dash = dashKey,
                                Key  = Enum.KeyCode.Q,
                                Goal = "KeyPress"
                            })
                        end
                    end
                end)
            end
        end
    })
end
local function setupCharacter(char)
    character = char
    communicate = character:FindFirstChild("Communicate")
    createDashToggle()
    if communicateConn then
        communicateConn:Disconnect()
        communicateConn = nil
    end
    communicateConn = character.ChildAdded:Connect(function(child)
        if child.Name == "Communicate" then
            communicate = child
            createDashToggle()
        end
    end)
end
if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(function(char)
    setupCharacter(char)
end)
task.wait(0.1)
local player = Players.LocalPlayer
_G.SafeTeleportLock = false
local savedPosition = nil
local inSafe = false
local monitorConnection
local antiMoveConnection
local positions = {}
for i = 1, 700 do
	table.insert(positions, CFrame.new(0, i * 1000000000000, 0))
end
local currentIndex = 1
local positionAccumulator = 0
local positionInterval = 0
local function returnBack(character)
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not hrp or not humanoid then return end
	if not savedPosition then return end
	hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
	hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
	hrp.CFrame = savedPosition + Vector3.new(0,1,0)
	task.wait()
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	task.wait(0.1)
	humanoid:ChangeState(Enum.HumanoidStateType.Running)
end
Lowhp = Tabs.TOG:AddToggle("lowhp", {
	Title = "Auto Safe Zone 28% hp back on 40% hp",
	Default = false,
	Callback = function(state)
		if state then
			monitorConnection = RunService.Heartbeat:Connect(function(dt)
				local character = player.Character
				if not character then return end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local hrp = character:FindFirstChild("HumanoidRootPart")
				if not humanoid or not hrp then return end
				if humanoid.Health <= humanoid.MaxHealth * 0.28 and not inSafe then
					_G.SafeTeleportLock = true
					savedPosition = hrp.CFrame
					inSafe = true
					currentIndex = 1
					positionAccumulator = 0
					antiMoveConnection = RunService.Heartbeat:Connect(function(dt2)
						if not inSafe then return end
						positionAccumulator = positionAccumulator + dt2
						if positionAccumulator >= positionInterval then
							positionAccumulator = 0
							currentIndex = currentIndex + 1
							if currentIndex > #positions then
								currentIndex = 1
							end
						end
						hrp.CFrame = positions[currentIndex]
					end)
				end
				if inSafe and humanoid.Health > humanoid.MaxHealth * 0.39 then
					inSafe = false
					_G.SafeTeleportLock = false
					if antiMoveConnection then
						antiMoveConnection:Disconnect()
						antiMoveConnection = nil
					end
					returnBack(character)
				end
			end)
		else
			local character = player.Character
			if monitorConnection then
				monitorConnection:Disconnect()
				monitorConnection = nil
			end
			if antiMoveConnection then
				antiMoveConnection:Disconnect()
				antiMoveConnection = nil
			end
			if inSafe then
				returnBack(character)
			end
			inSafe = false
			_G.SafeTeleportLock = false
		end
	end
})
task.wait(0.1)
local camLockTrashEnabled = false
local camLockTrashHolding = false
local camLockTrashSession = false
local camLockTrashActive = false
local camLockTrashConn = nil
local camLockTrashInputBegan = nil
local camLockTrashInputEnded = nil
local camLockTrashPrevPlayer = nil
local camLockTrashPrevRunning = false

local function getCamlockPlayer()
	local t = CamlockTarget
	if not t or not t.Parent then return nil end
	local model = t:FindFirstAncestorOfClass("Model")
	if not model then return nil end
	return Players:GetPlayerFromCharacter(model)
end

local function stopCamLockTrashActive()
	if not camLockTrashActive then return end
	camLockTrashActive = false
	if _G.NOTHINGX_TrashPlayer then
		_G.NOTHINGX_TrashPlayer.SetRunning(false)
	end
end

local function restoreCamLockTrashSession()
	if not camLockTrashSession then return end
	stopCamLockTrashActive()
	if camLockTrashPrevPlayer ~= nil then
		playerChosen = camLockTrashPrevPlayer
	end
	if camLockTrashPrevRunning and _G.NOTHINGX_TrashPlayer and playerChosen then
		_G.NOTHINGX_TrashPlayer.AttachTarget(playerChosen)
		_G.NOTHINGX_TrashPlayer.SetRunning(true)
	end
	camLockTrashPrevPlayer = nil
	camLockTrashPrevRunning = false
	camLockTrashSession = false
end

local function stopCamLockTrashAll()
	camLockTrashHolding = false
	restoreCamLockTrashSession()
	if camLockTrashConn then
		camLockTrashConn:Disconnect()
		camLockTrashConn = nil
	end
end

local function startCamLockTrashLoop()
	if camLockTrashConn then return end
	camLockTrashConn = RunService.Heartbeat:Connect(function()
		if not camLockTrashEnabled or not camLockTrashHolding then return end
		if isSafeTeleportLocked() then return end
		if not CamlockEnabled then
			stopCamLockTrashActive()
			return
		end
		if not _G.NOTHINGX_TrashPlayer then return end

		local targetPlr = getCamlockPlayer()
		if not targetPlr then
			stopCamLockTrashActive()
			return
		end

		if playerChosen ~= targetPlr then
			playerChosen = targetPlr
		end
		_G.NOTHINGX_TrashPlayer.AttachTarget(targetPlr)
		if not _G.NOTHINGX_TrashPlayer.IsRunning() then
			_G.NOTHINGX_TrashPlayer.SetRunning(true)
		end
		camLockTrashActive = true
	end)
end

local function bindCamLockTrashInput()
	if camLockTrashInputBegan then return end
	camLockTrashInputBegan = UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if not camLockTrashEnabled then return end
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			camLockTrashHolding = true
			if not camLockTrashSession then
				camLockTrashSession = true
				camLockTrashPrevPlayer = playerChosen
				camLockTrashPrevRunning = _G.NOTHINGX_TrashPlayer
					and _G.NOTHINGX_TrashPlayer.IsRunning
					and _G.NOTHINGX_TrashPlayer.IsRunning()
					or false
				if camLockTrashPrevRunning and _G.NOTHINGX_TrashPlayer then
					_G.NOTHINGX_TrashPlayer.SetRunning(false)
				end
			end
			startCamLockTrashLoop()
		end
	end)
	camLockTrashInputEnded = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			stopCamLockTrashAll()
		end
	end)
end

local function unbindCamLockTrashInput()
	if camLockTrashInputBegan then
		camLockTrashInputBegan:Disconnect()
		camLockTrashInputBegan = nil
	end
	if camLockTrashInputEnded then
		camLockTrashInputEnded:Disconnect()
		camLockTrashInputEnded = nil
	end
end

Tabs.TOG:AddToggle("camlocktrash", {
	Title = "Cam-Lock Trash Cant (Hold Right)",
	Default = false,
	Callback = function(state)
		camLockTrashEnabled = state
		if state then
			bindCamLockTrashInput()
		else
			unbindCamLockTrashInput()
			stopCamLockTrashAll()
		end
	end
})
task.wait(0.1)
task.defer(function()

local LocalPlayer = Players.LocalPlayer
local hasUltimate = LocalPlayer:GetAttribute("Ultimate") ~= nil
local hasCharacter = LocalPlayer:GetAttribute("Character") ~= nil
local ToggleUlt
local ToggleClass
local ToggleDetectUlt
if hasUltimate then
    ToggleUlt = Tabs.TOG:AddToggle("ulttog", { Title = "Show Ultimate %", Default = false })
    ToggleDetectUlt = Tabs.TOG:AddToggle("detectult", { Title = "Detect Use Ult (ESP Yellow)", Default = false })
end
if hasCharacter then
    ToggleClass = Tabs.TOG:AddToggle("classtog", { Title = "Show Character Name", Default = false })
end
local ULT_USE_DURATION = 50.3
local UltEspState = {
    esp = {},
    timer = {},
    conns = {},
    lastUlt = {},
    active = {},
    allowDestroy = {},
    protectConnections = {}
}
local function safeDestroyUltEsp(plr)
    UltEspState.allowDestroy[plr] = true
    local hl = UltEspState.esp[plr]
    if hl then
        hl:Destroy()
    end
    UltEspState.esp[plr] = nil
    UltEspState.allowDestroy[plr] = false
end
local function clearUltProtect(plr)
    local c = UltEspState.protectConnections[plr]
    if c then c:Disconnect() end
    UltEspState.protectConnections[plr] = nil
end
local function hideUltEsp(plr)
    safeDestroyUltEsp(plr)
    clearUltProtect(plr)
end
local function finishUltEsp(plr)
    UltEspState.active[plr] = false
    UltEspState.timer[plr] = nil
    hideUltEsp(plr)
end
local function createUltEsp(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
    local className = plr:GetAttribute("Character")
    if className == "Bald" then return end
    safeDestroyUltEsp(plr)
    local hl = Instance.new("Highlight")
    hl.Name = "UltUseESP"
    hl.Adornee = char
    hl.FillColor = Color3.fromRGB(0, 0, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    UltEspState.esp[plr] = hl
    clearUltProtect(plr)
    UltEspState.protectConnections[plr] = char.DescendantRemoving:Connect(function(obj)
        if obj.Name == "UltUseESP" and UltEspState.active[plr] then
            if UltEspState.allowDestroy[plr] then return end
            if ToggleDetectUlt and ToggleDetectUlt.Value then
                task.defer(function()
                    if UltEspState.active[plr] then
                        createUltEsp(plr)
                    end
                end)
            end
        end
    end)
end
local function startUltTimer(plr)
    local id = tick()
    UltEspState.timer[plr] = id
    task.delay(ULT_USE_DURATION, function()
        if UltEspState.timer[plr] ~= id then return end
        UltEspState.active[plr] = false
        UltEspState.timer[plr] = nil
        if ToggleDetectUlt and ToggleDetectUlt.Value then
            hideUltEsp(plr)
        end
    end)
end
local function onUltimateChanged(plr)
    local val = tonumber(plr:GetAttribute("Ultimate") or 0) or 0
    local prev = UltEspState.lastUlt[plr]
    UltEspState.lastUlt[plr] = val
    if prev == nil then return end
    if prev >= 100 and val <= 0 then
        UltEspState.active[plr] = true
        startUltTimer(plr)
        if ToggleDetectUlt and ToggleDetectUlt.Value then
            createUltEsp(plr)
        end
        return
    end
    if val > 0 then
        finishUltEsp(plr)
    end
end
local function clearDetectConns(plr)
    local c = UltEspState.conns[plr]
    if not c then return end
    for _, conn in pairs(c) do
        if conn then conn:Disconnect() end
    end
    UltEspState.conns[plr] = nil
end
local function setupDetectPlayer(plr)
    if plr == LocalPlayer then return end
    clearDetectConns(plr)
    UltEspState.conns[plr] = {}
    local c = UltEspState.conns[plr]
    UltEspState.lastUlt[plr] = tonumber(plr:GetAttribute("Ultimate") or 0) or 0
    c.ult = plr:GetAttributeChangedSignal("Ultimate"):Connect(function()
        onUltimateChanged(plr)
    end)
    c.charAttr = plr:GetAttributeChangedSignal("Character"):Connect(function()
        if plr:GetAttribute("Character") == "Bald" then
            finishUltEsp(plr)
        end
    end)
    c.charAdded = plr.CharacterAdded:Connect(function(char)
        hideUltEsp(plr)
        task.wait(0.1)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if c.died then c.died:Disconnect() end
            c.died = hum.Died:Connect(function()
                finishUltEsp(plr)
            end)
        end
        if UltEspState.active[plr] and ToggleDetectUlt and ToggleDetectUlt.Value then
            createUltEsp(plr)
        end
    end)
    if plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            c.died = hum.Died:Connect(function()
                finishUltEsp(plr)
            end)
        end
    end
end
local function hideAllUltEsp()
    for plr, _ in pairs(UltEspState.esp) do
        hideUltEsp(plr)
    end
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
    local showUlt = ToggleUlt and ToggleUlt.Value
    local showClass = ToggleClass and ToggleClass.Value
    if not showUlt and not showClass then
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
    if showUlt then
        local ult = player:GetAttribute("Ultimate") or 0
        local val = math.clamp(math.round(tonumber(ult) or 0), 0, 100)
        ultLabel.Text = val .. "%"
        ultLabel.TextColor3 = (val > 0) and Color3.fromRGB(255, 210, 90) or Color3.fromRGB(220, 220, 130)
        ultLabel.Visible = true
        visibleLines = visibleLines + 1
    else
        ultLabel.Visible = false
    end
end
if classLabel then
    if showClass then
        local name = player:GetAttribute("Character") or "???"
        classLabel.Text = name
        classLabel.TextColor3 = GetClassColor(name)
        classLabel.Visible = true 
        visibleLines = visibleLines + 1
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
        ultLabel.Position = UDim2.new(0, 0, 0, 0)
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
local billboardInterval = 0.4
local billboardTimer = 0
local function ManageHeartbeat()
    local showUlt = ToggleUlt and ToggleUlt.Value
    local showClass = ToggleClass and ToggleClass.Value

    if showUlt or showClass then
        if not conn then
            billboardTimer = 0
            conn = RunService.Heartbeat:Connect(function(dt)
                if isSafeTeleportLocked() then
                    return
                end
                billboardTimer = billboardTimer + dt
                if billboardTimer < billboardInterval then return end
                billboardTimer = 0
                UpdateAll()
            end)
        end
    else
        if conn then
            conn:Disconnect()
            conn = nil
        end
    end
end
if ToggleUlt then
    ToggleUlt:OnChanged(function()
        UpdateAll()
        ManageHeartbeat()
    end)
end
if ToggleClass then
    ToggleClass:OnChanged(function()
        UpdateAll()
        ManageHeartbeat()
    end)
end
if ToggleDetectUlt then
    ToggleDetectUlt:OnChanged(function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                setupDetectPlayer(plr)
                if UltEspState.active[plr] then
                    createUltEsp(plr)
                end
            end
        else
            hideAllUltEsp()
        end
    end)
end
local function onBillboardPlayerAdded(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.7)
        UpdateBillboard(plr)
    end)
    if ToggleUlt then
        plr:GetAttributeChangedSignal("Ultimate"):Connect(function()
            if ToggleUlt.Value then UpdateBillboard(plr) end
        end)
    end
    if ToggleClass then
        plr:GetAttributeChangedSignal("Character"):Connect(function()
            if ToggleClass.Value then UpdateBillboard(plr) end
        end)
    end
    if ToggleDetectUlt then
        setupDetectPlayer(plr)
    end
end
local function onBillboardPlayerRemoving(plr)
    finishUltEsp(plr)
    clearDetectConns(plr)
    UltEspState.lastUlt[plr] = nil
    UltEspState.active[plr] = nil
    UltEspState.allowDestroy[plr] = nil
    UltEspState.protectConnections[plr] = nil
end
local bbPendingAdd = {}
local bbPendingRemove = {}
local bbProcessing = false
local function getBillboardDelay()
    local pending = 0
    for _ in pairs(bbPendingAdd) do pending = pending + 1 end
    for _ in pairs(bbPendingRemove) do pending = pending + 1 end
    if pending >= 15 then
        return 0.5
    elseif pending >= 8 then
        return 0.35
    elseif pending >= 4 then
        return 0.25
    else
        return 0.15
    end
end
local function processBillboardPending()
    bbProcessing = false
    for plr in pairs(bbPendingAdd) do
        bbPendingAdd[plr] = nil
        pcall(onBillboardPlayerAdded, plr)
    end
    for plr in pairs(bbPendingRemove) do
        bbPendingRemove[plr] = nil
        pcall(onBillboardPlayerRemoving, plr)
    end
end
local function scheduleBillboardPending()
    if bbProcessing then return end
    bbProcessing = true
    task.delay(0.1, processBillboardPending)
end
registerJoinLeave("add", function(plr)
    bbPendingAdd[plr] = true
    scheduleBillboardPending()
end)
registerJoinLeave("remove", function(plr)
    bbPendingRemove[plr] = true
    scheduleBillboardPending()
end)
if ToggleDetectUlt then
    for _, plr in ipairs(Players:GetPlayers()) do
        setupDetectPlayer(plr)
    end
end
task.delay(1.5, function()
    local showUlt = ToggleUlt and ToggleUlt.Value
    local showClass = ToggleClass and ToggleClass.Value
    if showUlt or showClass then
        UpdateAll()
    end
end)
end)
task.wait(0.1)
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local viewing = false
local currentTarget = nil
local viewDied = nil
local viewChanged = nil
local dropdownMap = {}
local flingOneOn = false
local flingOneConnection = nil
local autoTpOn = false
local autoTpConnection = nil
local TrashPlayerKeybind = nil
local FLING_INF_POWER = 1e12
local orbitStepXZ = 0
local orbitStepY = 0
local orbitMax = 1.3
local orbitIncrement = 0.1
local orbitSpeed = 999999999999999999999
local function getRootUniversal(char)
    return char and (
        char:FindFirstChild("HumanoidRootPart") or
        char:FindFirstChild("Torso") or
        char:FindFirstChild("UpperTorso")
    )
end
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
            if h then Camera.CameraSubject = h end
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
        if hum then Camera.CameraSubject = hum end
    end
end
local function startFlingOne()
    if flingOneConnection then flingOneConnection:Disconnect() end

    flingOneConnection = RunService.Heartbeat:Connect(function(dt)
        if isSafeTeleportLocked() then
            return
        end
        if not flingOneOn then return end
        if not playerChosen then return end
        if not playerChosen.Parent then
            FlingOneToggle:SetValue(false)
            return
        end

        local myChar = LocalPlayer.Character
        local targetChar = playerChosen.Character
        if not (myChar and targetChar) then
            FlingOneToggle:SetValue(false)
            return
        end

        local myRoot = getRootUniversal(myChar)
        local targetRoot = getRootUniversal(targetChar)
        if not (myRoot and targetRoot) then
            FlingOneToggle:SetValue(false)
            return
        end

        orbitStepXZ = orbitStepXZ + orbitIncrement
        orbitStepY = orbitStepY + orbitIncrement

        if orbitStepXZ > orbitMax then orbitStepXZ = 0 end
        if orbitStepY > orbitMax then orbitStepY = 0 end

        local t = tick() * orbitSpeed
        local offset = Vector3.new(
            math.cos(t) * orbitStepXZ,
            orbitStepY,
            math.sin(t) * orbitStepXZ
        )

        myRoot.CFrame = targetRoot.CFrame + offset

        local p = FLING_INF_POWER
        myRoot.AssemblyAngularVelocity = Vector3.new(p, p, p)
        myRoot.AssemblyLinearVelocity =
            myRoot.CFrame.LookVector * p + Vector3.new(0, p/2, 0)
    end)
end
local function startAutoTp()
    if autoTpConnection then autoTpConnection:Disconnect() end
    autoTpConnection = RunService.Heartbeat:Connect(function()
        if isSafeTeleportLocked() then
            return
        end
        if not autoTpOn then return end
        if not playerChosen then return end
        local myChar = LocalPlayer.Character
        local targetChar = playerChosen.Character
        if not (myChar and targetChar) then return end
        local myRoot = getRootUniversal(myChar)
        local targetRoot = getRootUniversal(targetChar)
        if not (myRoot and targetRoot) then return end
        myRoot.CFrame = targetRoot.CFrame
    end)
end
local Dropdown = Tabs.PLYR:AddDropdown("Dropdown_player", {
    Title = "Player",
    Values = buildDropdownValues(),
    Multi = false,
    Default = "None",
Callback = function(value)
    playerChosen = dropdownMap[value]

    if not playerChosen then
        if autoTpOn then AutoTpToggle:SetValue(false) end
        if flingOneOn then FlingOneToggle:SetValue(false) end
        if viewing then ViewToggle:SetValue(false) end
        if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning() then
            _G.NOTHINGX_TrashPlayer.SetRunning(false)
        end
        return
    end

    if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning() then
        _G.NOTHINGX_TrashPlayer.AttachTarget(playerChosen)
    end

    if viewing then
        startView(playerChosen)
    end
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
        if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning() then
            _G.NOTHINGX_TrashPlayer.SetRunning(false)
        end
    end
end
local function onDropdownPlayerAdded()
    refreshDropdown()
end
local function onDropdownPlayerRemoving(plr)
    if viewing and currentTarget == plr then
        ViewToggle:SetValue(false)
    end
    if flingOneOn and playerChosen == plr then
        FlingOneToggle:SetValue(false)
    end
    if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning() and playerChosen == plr then
        _G.NOTHINGX_TrashPlayer.SetRunning(false)
    end
    refreshDropdown()
end
local dropdownRefreshPending = false
local function scheduleDropdownRefresh()
    if dropdownRefreshPending then return end
    dropdownRefreshPending = true
    local pending = (#JoinLeaveQueue - JoinLeaveHead + 1)
    if pending < 0 then pending = 0 end
    local delay = 0.7
    if pending >= 12 then
        delay = 1.2
    elseif pending >= 6 then
        delay = 0.9
    end
    task.delay(delay, function()
        dropdownRefreshPending = false
        refreshDropdown()
    end)
end
registerJoinLeave("add", function()
    scheduleDropdownRefresh()
end)
registerJoinLeave("remove", function(plr)
    if viewing and currentTarget == plr then
        ViewToggle:SetValue(false)
    end
    if flingOneOn and playerChosen == plr then
        FlingOneToggle:SetValue(false)
    end
    if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning() and playerChosen == plr then
        _G.NOTHINGX_TrashPlayer.SetRunning(false)
    end
    scheduleDropdownRefresh()
end)
Tabs.PLYR:AddButton({
    Title = "TP Player",
    Callback = function()
        if not playerChosen then return end
        local char = playerChosen.Character
        local myChar = LocalPlayer.Character
        if not (char and myChar) then return end
        local hrp = getRootUniversal(char)
        local myHrp = getRootUniversal(myChar)
        if hrp and myHrp then
            myHrp.CFrame = hrp.CFrame
        end
    end
})
AutoTpToggle = Tabs.PLYR:AddToggle("AutoTpToggle", {
    Title = "Auto TP Player",
    Default = false,

    Callback = function(state)
        if state then
            if not playerChosen then
                AutoTpToggle:SetValue(false)
                return
            end

            if flingOneOn then
                FlingOneToggle:SetValue(false)
            end

            autoTpOn = true
            startAutoTp()
        else
            autoTpOn = false
            if autoTpConnection then
                autoTpConnection:Disconnect()
                autoTpConnection = nil
            end
        end
    end
})

local function createTrashPlayerKeybind()
    if TrashPlayerKeybind then return end
    TrashPlayerKeybind = Tabs.PLYR:AddKeybind("TrashPlayerKeybind", {
        Title = "Trash Player",
        Mode = "Toggle",
        Default = "V",
        Callback = function(state)
            if _G.NOTHINGX_TrashPlayer then
                local nextState = state
                if nextState and not playerChosen then
                    nextState = false
                end
                _G.NOTHINGX_TrashPlayer.SetRunning(nextState)
            end
        end
    })
    if _G.NOTHINGX_TrashPlayer then
        _G.NOTHINGX_TrashPlayer.EnsureStatus()
    end
end

local function removeTrashPlayerKeybind()
    if not TrashPlayerKeybind then return end
    if _G.NOTHINGX_TrashPlayer then
        _G.NOTHINGX_TrashPlayer.SetRunning(false)
    end
    pcall(function()
        if TrashPlayerKeybind.SetValue then
            TrashPlayerKeybind:SetValue(false)
        end
    end)
    pcall(function()
        if TrashPlayerKeybind.Destroy then
            TrashPlayerKeybind:Destroy()
        end
    end)
    TrashPlayerKeybind = nil
end

local function shouldCreateTrashPlayerKeybindOnce()
    local map = workspace:FindFirstChild("Map")
    local mainPart = map and map:FindFirstChild("MainPart")
    if not mainPart then return false end
    if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.HasTrash then
        return not _G.NOTHINGX_TrashPlayer.HasTrash()
    end
    return true
end

if shouldCreateTrashPlayerKeybindOnce() then
    createTrashPlayerKeybind()
else
    removeTrashPlayerKeybind()
end

ViewToggle = Tabs.PLYR:AddToggle("Viewtog", {
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
FlingOneToggle = Tabs.PLYR:AddToggle("FlingOneToggle", {
    Title = "Fling Player",
    Default = false,

    Callback = function(state)
        if state then
            if not playerChosen then
                FlingOneToggle:SetValue(false)
                return
            end

            if autoTpOn then
                AutoTpToggle:SetValue(false)
            end

            flingOneOn = true
            startFlingOne()
        else
            flingOneOn = false
            if flingOneConnection then
                flingOneConnection:Disconnect()
                flingOneConnection = nil
            end
        end
    end
})
task.wait(0.2)
Tabs.TOG:AddButton({
    Title = "Lay",
    Callback = function()
        local player = Players.LocalPlayer  
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
local FixCam = Tabs.TOG:AddButton({
    Title = "Rest Camera",
    Callback = function()
	local player = Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end
})
local map = workspace:FindFirstChild("Map")
local mainPart = map and map:FindFirstChild("MainPart")
if map and mainPart then
    local ButtonDummy = Tabs.TOG:AddButton({
        Title = "Teleport to Weakest Dummy",
        Callback = function()
            local live = workspace:FindFirstChild("Live")
            local dummy = live and live:FindFirstChild("Weakest Dummy")
            if dummy
            and dummy:FindFirstChild("HumanoidRootPart")
            and LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame =
                    dummy.HumanoidRootPart.CFrame
            end
        end
    })
end
Tabs.TOG:AddButton({
    Title = "Save All Settings",
    Description = "Manually save your current config",
    Callback = function()
        if SaveManager then
            SaveManager:Save("XVX")
            Fluent:Notify({
                Title = "NOTHING_X",
                Content = "Settings saved successfully!",
                Duration = 3
            })
        end
    end
})
if SaveManager then
    pcall(function()
        SaveManager:SetLibrary(Fluent)
        SaveManager:SetFolder("NOTHING_X/settings")
        SaveManager:Load("XVX")
		    Fluent:Notify({
            Title = "NOTHING_X",
            Content = "Settings loaded successfully!",
            Duration = 3
        })
    end)
end
task.defer(function()
local player = game.Players.LocalPlayer
local lastSafePosition = nil
local VOID_Y = -300
local BUFFER = 100 
local function isGrounded(hrp)
    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -6, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {hrp.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return result ~= nil
end
local function resetVelocity(hrp)
    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
    hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
    hrp.Velocity = Vector3.new(0,0,0) 
end
local function tripleFixTP(hrp, pos)
    for i = 1, 3 do
        resetVelocity(hrp)
        hrp.CFrame = CFrame.new(pos.X, pos.Y + 5, pos.Z)
        task.wait() 
    end
end
local function protect(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    while character and character.Parent do
        task.wait()
        if hrp.Position.Y > (VOID_Y + BUFFER) and isGrounded(hrp) then
            lastSafePosition = hrp.Position
        end
        if hrp.Position.Y < (VOID_Y + BUFFER) then
            if lastSafePosition then
                tripleFixTP(hrp, lastSafePosition)
            end
        end
    end
end
if player.Character then
    task.spawn(protect, player.Character)
end
player.CharacterAdded:Connect(function(char)
    task.spawn(protect, char)
end)
end)
