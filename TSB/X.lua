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
    task.spawn(function()
        local skipHandlers = (kind == "add" and (not plr or not plr.Parent))
        if not skipHandlers then
            for _, fn in ipairs(JoinLeaveHandlers[kind]) do
                pcall(fn, plr)
            end
        end
    end)
end
local TrackedPlayers = {}
local TrackedPlayerList = {}
local function rebuildTrackedPlayerList()
    table.clear(TrackedPlayerList)
    for plr in pairs(TrackedPlayers) do
        if plr and plr.Parent == Players then
            table.insert(TrackedPlayerList, plr)
        else
            TrackedPlayers[plr] = nil
        end
    end
end
local function getTrackedPlayers()
    return TrackedPlayerList
end
local function trackPlayer(plr)
    if not plr or TrackedPlayers[plr] then return end
    TrackedPlayers[plr] = true
    rebuildTrackedPlayerList()
    handleJoinLeave("add", plr)
end
local function untrackPlayer(plr)
    if not plr or not TrackedPlayers[plr] then return end
    TrackedPlayers[plr] = nil
    rebuildTrackedPlayerList()
    handleJoinLeave("remove", plr)
end
for _, plr in ipairs(Players:GetPlayers()) do
    TrackedPlayers[plr] = true
end
rebuildTrackedPlayerList()
Players.PlayerAdded:Connect(trackPlayer)
Players.PlayerRemoving:Connect(untrackPlayer)
local VisualFixEnabled = true
local VisualFix = {
    originalSubject = nil,
    target = nil,
    active = false,
    conn = nil
}
function VisualFix:Start(target)
    if not VisualFixEnabled then return end
    self.target = target
    self.active = true
    local camera = workspace.CurrentCamera
    if not self.originalSubject then
        self.originalSubject = camera.CameraSubject
    end
    if self.conn then self.conn:Disconnect() end
    self.conn = RunService.RenderStepped:Connect(function()
        if not self.active then return end
        local camera = workspace.CurrentCamera
        if self.target == "SafeZone" then
        elseif self.target then
            local obj = self.target
            if obj:IsA("Model") then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                if hum then camera.CameraSubject = hum end
            elseif obj:IsA("BasePart") then
                camera.CameraSubject = obj
            end
        end
        local char = Players.LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") then
                    v.LocalTransparencyModifier = 1
                end
            end
        end
    end)
end
function VisualFix:Stop()
    self.active = false
    if self.conn then self.conn:Disconnect() self.conn = nil end
    local camera = workspace.CurrentCamera
    if self.originalSubject then
        camera.CameraSubject = self.originalSubject
        self.originalSubject = nil
    end
    self.target = nil
    local char = Players.LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.LocalTransparencyModifier = 0
            end
        end
    end
end



local SaveManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/raw/refs/heads/master/Addons/SaveManager.lua"))()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "NOTHING_X",
    SubTitle = "",
    TabWidth = 30,
    Size = UDim2.fromOffset(420, 510),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})
local Tabs = {
    XXX = Window:AddTab({Title = "", Icon = "info"}),
	TOG = Window:AddTab({Title = "", Icon = "sliders-horizontal"}),
	PLYR = Window:AddTab({Title = "", Icon = "users"}),
    	KEY = Window:AddTab({Title = "", Icon = "keyboard"})
}
local UIStatus = {
    attack = nil,
    camlock = nil,
    walkfling = nil,
    trash = nil,
    target = nil
}
local forceUpdateTargetStatusParagraph
local setDropdownVisualTarget
local getPlayerFromTargetRoot
local getPriorityTargetPlayer
local watchChosenTarget
local targetState
local buildDropdownValues
local dropdownMap
Window:SelectTab()
task.defer(function()loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/TSB/ThemesUITBS"))()end)
task.defer(function() loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-TSB"))()end)

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
while not proceed do task.wait(0.05) end
if not proceed then return end

local p=game:GetService("Players").LocalPlayer;if({[3808081382]=true,[10449761463]=true})[game.GameId] or ({[3808081382]=true,[10449761463]=true})[game.PlaceId] then local function a(c,i)local h=c:WaitForChild("Humanoid")local an=Instance.new("Animation")an.AnimationId="rbxassetid://"..i;h:LoadAnimation(an):Play()end;if p.Character then task.wait(0.1) a(p.Character,"17141153099") end;p.CharacterAdded:Connect(function(c) task.wait(0.1) a(c,"13497875049") end) end

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
    if Fluent then
        Fluent:Notify({
            Title = title,
            Content = text,
            Duration = duration
        })
    end
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
            task.spawn(function()
                if state[plr] == "strong" then
                    createImmortalHighlight(plr, true)
                elseif state[plr] == "weak" then
                    createImmortalHighlight(plr, false)
                end
            end)
        end
    end)
end
local function getTeleportFollowCFrame(targetRoot, targetVel, backOffset, verticalOffset)
    local basePos = targetRoot.Position
    local moveDir
    if targetVel and targetVel.Magnitude > 1 then
        moveDir = targetVel.Unit
    else
        moveDir = targetRoot.CFrame.LookVector
    end
    local horizontalDir = Vector3.new(moveDir.X, 0, moveDir.Z)
    if horizontalDir.Magnitude <= 0.05 then
        horizontalDir = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
    end
    if horizontalDir.Magnitude <= 0.05 then
        horizontalDir = Vector3.zAxis
    else
        horizontalDir = horizontalDir.Unit
    end
    local followPos = basePos - (horizontalDir * (backOffset or 0))
    if verticalOffset and verticalOffset ~= 0 then
        followPos = followPos + Vector3.new(0, verticalOffset, 0)
    end
    return CFrame.lookAt(followPos, basePos)
end
local TPVariantMode = "Aggressive"
local TPVariantSettings = {
    ["Aggressive"] = {
        groundBack = 0.28,
        groundVertical = -0.35,
        fallBack = 0.03,
        fallVertical = -1.95,
        riseBack = 0.08,
        riseVertical = -1.2,
        autoBack = 0.04,
        autoVertical = -0.2,
        trashBack = 0.45,
        trashVertical = -2.45,
        playerBack = 0,
        playerVertical = 0
    },
    ["Direct"] = {
        groundBack = 0,
        groundVertical = 0,
        fallBack = 0,
        fallVertical = -1.6,
        riseBack = 0,
        riseVertical = -0.8,
        autoBack = 0,
        autoVertical = 0,
        trashBack = 0.2,
        trashVertical = -2.2,
        playerBack = 0,
        playerVertical = 0
    },
    ["Under"] = {
        groundBack = 0.12,
        groundVertical = -1.15,
        fallBack = 0.02,
        fallVertical = -2.2,
        riseBack = 0.05,
        riseVertical = -1.5,
        autoBack = 0.03,
        autoVertical = -1,
        trashBack = 0.25,
        trashVertical = -2.8,
        playerBack = 0.05,
        playerVertical = -1
    },
    ["Above"] = {
        groundBack = 0.25,
        groundVertical = 1.1,
        fallBack = 0.05,
        fallVertical = 0.4,
        riseBack = 0.08,
        riseVertical = 0.9,
        autoBack = 0.08,
        autoVertical = 0.75,
        trashBack = 0.35,
        trashVertical = -1.2,
        playerBack = 0.1,
        playerVertical = 0.9
    },
    ["Behind"] = {
        groundBack = 1.05,
        groundVertical = 0,
        fallBack = 0.9,
        fallVertical = -1.1,
        riseBack = 1,
        riseVertical = -0.2,
        autoBack = 1.15,
        autoVertical = 0,
        trashBack = 1.05,
        trashVertical = -2.2,
        playerBack = 1,
        playerVertical = 0
    }
}
local function getTpVariantConfig()
    return TPVariantSettings[TPVariantMode] or TPVariantSettings["Aggressive"]
end
local function getAttackTeleportOffsets(targetVel)
    local config = getTpVariantConfig()
    local y = targetVel and targetVel.Y or 0
    if y < -8 then
        return config.fallBack, config.fallVertical
    end
    if y > 8 then
        return config.riseBack, config.riseVertical
    end
    return config.groundBack, config.groundVertical
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
        allowDestroy[plr] = true
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
        SendNotification("SERIOUS MODE", plr.Name.." -DEATH", 6)
        local currentId = tick()
        activeTimers[plr] = currentId
        task.delay(9.4, function()
            if activeTimers[plr] ~= currentId then return end
            if state[plr] == "weak" then
                state[plr] = nil
                allowDestroy[plr] = true
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
        allowDestroy[plr] = true
        safeDestroyHighlight(plr)
        local backpack = plr:WaitForChild("Backpack")
        local humanoid = plr.Character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            cancelTimer(plr)
            state[plr] = nil
            allowDestroy[plr] = true
            safeDestroyHighlight(plr)
        end)
        backpack.ChildAdded:Connect(function()
            updatePlayer(plr)
        end)
        backpack.ChildRemoved:Connect(function()
            updatePlayer(plr)
        end)
        updatePlayer(plr)
    end
    if plr.Character then
        onCharacter()
    end
    plr.CharacterAdded:Connect(onCharacter)
end
for _, plr in ipairs(getTrackedPlayers()) do
    setupPlayer(plr)
end
Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(function(plr)
    cancelTimer(plr)
    state[plr] = nil
    allowDestroy[plr] = true
    safeDestroyHighlight(plr)
    if protectConnections[plr] then
        protectConnections[plr]:Disconnect()
        protectConnections[plr] = nil
    end
    allowDestroy[plr] = nil
end)
local speaker = Players.LocalPlayer
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
local player = Players.LocalPlayer
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
local player = game.Players.LocalPlayer
local function safeDeleteAnimationPlayer(characterHandler)
    local success, result = pcall(function()
        for i = 1, 5 do  
            local animationPlayer = characterHandler:FindFirstChild("AnimationPlayer")
            if animationPlayer then
                animationPlayer:Destroy()
                return true
            end
            wait(0.1)
        end
        return false
    end)
    if not success then
    end
end
local function handleCharacter(character)
    local characterHandler
    local success, result = pcall(function()
        characterHandler = character:FindFirstChild("CharacterHandler")
    end)
    if success and characterHandler then
        safeDeleteAnimationPlayer(characterHandler)
        pcall(function()
            characterHandler.ChildAdded:Connect(function(child)
                pcall(function()
                    if child.Name == "AnimationPlayer" then
                        child:Destroy()
                    end
                end)
            end)
        end)
    end
end
pcall(function()
    if player.Character then
        handleCharacter(player.Character)
    end
end)
pcall(function()
    player.CharacterAdded:Connect(handleCharacter)
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
Tabs.KEY:AddKeybind("SpeedToggle", {
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
    Max = 45,
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
Tabs.KEY:AddKeybind("FlyIY", {
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
if not UIStatus.attack then
    UIStatus.attack = Tabs.XXX:AddParagraph({
        Title = "Attack TP : OFF",
        Content = ""
    })
end
if not UIStatus.camlock then
    UIStatus.camlock = Tabs.XXX:AddParagraph({
        Title = "CamLock : OFF",
        Content = ""
    })
end
if not UIStatus.walkfling then
    UIStatus.walkfling = Tabs.XXX:AddParagraph({
        Title = "Walk Fling : OFF",
        Content = ""
    })
end
if workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Trash") and not UIStatus.trash then
    UIStatus.trash = Tabs.XXX:AddParagraph({
        Title = "Trash : OFF",
        Content = ""
    })
end
if not UIStatus.target then
    UIStatus.target = Tabs.XXX:AddParagraph({
        Title = "Target : None",
        Content = ""
    })
end
if targetState and not targetState.statusParagraph then
    targetState.statusParagraph = UIStatus.target
end
local playerChosen = nil
local map = workspace:FindFirstChild("Map")
local mainPart = map and map:FindFirstChild("MainPart")
local player = Players.LocalPlayer
local vim = VirtualInputManager
local character
local hrp
local trashFolder = map and map:FindFirstChild("Trash")
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
    if not trashFolder then return end
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
    if not trashFolder then
        return nil
    end
    local candidates = {}
    local fallback = {}
    for _, model in ipairs(trashFolder:GetChildren()) do
        if model.Name == "Trashcan" and not model:GetAttribute("Broken") then
            table.insert(fallback, model)
            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if part then
                local tooClose = false
                for _, plr in ipairs(getTrackedPlayers()) do
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
    if not trashFolder then
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
            if hasTrashFlag then break end 
            if not currentTrash or currentTrash:GetAttribute("Broken") then
                currentTrash = getRandomTrashCan()
            end
            if currentTrash then
                ensureNoCollide(currentTrash)
                local targetCFrame = currentTrash.PrimaryPart and currentTrash.PrimaryPart.CFrame
                    or currentTrash:FindFirstChildWhichIsA("BasePart", true).CFrame
                if targetCFrame then
                    VisualFix:Start(currentTrash)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    character:PivotTo(targetCFrame * CFrame.new(0, -0.4, 0))
                    bodyGyro.CFrame = CFrame.new(hrp.Position, targetCFrame.Position)
                    click()
                end
            end
            tries = tries + 1
            RunService.Heartbeat:Wait()
        end
    end
    VisualFix:Stop()
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
    local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.zero
    if targetVel.Magnitude > 1000 then 
        targetVel = Vector3.zero
    end
    local prediction = Vector3.zero
    local config = getTpVariantConfig()
    local offset = behindDist or config.trashBack or 0.7
    local verticalOffset = config.trashVertical or -2.46
    VisualFix:Start(targetRoot)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local targetProxy = {
        Position = targetRoot.Position + prediction,
        CFrame = targetRoot.CFrame
    }
    character:PivotTo(getTeleportFollowCFrame(targetProxy, targetVel + prediction, offset, verticalOffset))
    click()
end
local function teleportToMainPart()
    if not hrp or not hrp.Parent then return end
    if not mainPart then return end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    character:PivotTo(mainPart.CFrame + Vector3.new(0, -3, 0))
end
local function startTrashPlayerLoop()
    if trashPlayer.thread then return end
    trashPlayer.thread = task.spawn(function()
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
                        lastDeadTeleport = tick()
                        teleportToMainPart()
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
        VisualFix:Stop()
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
    TrashKeybind = Tabs.KEY:AddKeybind("TrashKeybind", {
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
                task.spawn(function()
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


if trashFolder and not hasTrashFlag then
    createTrashKeybind()
end
if trashFolder and not trashState.statusParagraph then
    trashState.statusParagraph = UIStatus.trash
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

local workspace = game:GetService("Workspace")
local DropDownYKeybind = nil
local dropDownLastUse = 0
local dropDownCooldown = 2
local dropDownActive = false
local dropDownSpeed = 500 
local function setWorkspaceCollisionState(enabled, cache)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if enabled then
                local saved = cache[obj]
                if saved then
                    obj.CanCollide = saved.CanCollide
                    obj.CanTouch = saved.CanTouch
                    obj.CanQuery = saved.CanQuery
                end
            else
                cache[obj] = {
                    CanCollide = obj.CanCollide,
                    CanTouch = obj.CanTouch,
                    CanQuery = obj.CanQuery
                }
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
            end
        end
    end
end
local function teleportLocalPlayerDown()
    local character = Players.LocalPlayer and Players.LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not hrp then return end
    local now = tick()
    if dropDownActive or now - dropDownLastUse < dropDownCooldown then return end
    dropDownLastUse = now
    dropDownActive = true
    local collisionCache = {}
    setWorkspaceCollisionState(false, collisionCache)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
    local targetY = -150
    local lastStep = tick()
    while hrp.Position.Y > targetY do
        if not character.Parent or not hrp.Parent then break end
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
        local nowStep = tick()
        local dt = nowStep - lastStep
        lastStep = nowStep
        local stepDistance = math.min(dropDownSpeed * dt, hrp.Position.Y - targetY)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        character:PivotTo(hrp.CFrame + Vector3.new(0, -stepDistance, 0))
        task.wait()
    end
    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if humanoid and humanoid.Parent then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.spawn(function()
            if humanoid and humanoid.Parent then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
    setWorkspaceCollisionState(true, collisionCache)
    dropDownActive = false
end
local function createDropDownYKeybind()
    if DropDownYKeybind then return end
    DropDownYKeybind = Tabs.KEY:AddKeybind("DropDownYKeybind", {
        Title = "TP Down (Kill Void)",
        Mode = "Toggle",
        Default = "Backquote",
        Callback = function(state)
            if not state then return end
            teleportLocalPlayerDown()
            task.spawn(function()
if DropDownYKeybind and typeof(DropDownYKeybind.SetValue) == "function" then
    pcall(function()
        DropDownYKeybind:SetValue(false)
    end)
end
            end)
        end
    })
end
createDropDownYKeybind()
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CamlockEnabled = false
local CamlockTarget = nil
local BasePrediction = 0.08
local FOV = 150
local camlockState = { statusParagraph = UIStatus.camlock }
local SCAN_INTERVAL = 0.12
local scanTimer = 0
local CachedTargets = {}
local targetPool = workspace:FindFirstChild("Live")
local lastCamlockVisualPlayer = false
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
            if model ~= LocalPlayer.Character and IsAlive(model) and not Players:GetPlayerFromCharacter(model) then
                local root = GetRoot(model)
                if root then
                    CachedTargets[#CachedTargets + 1] = root
                end
            end
        end
    end
    for _, plr in ipairs(getTrackedPlayers()) do
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
    return ping * 0.9 + 0.015
end
local function syncCamlockVisualTarget()
    local visualPlayer = getPlayerFromTargetRoot and getPlayerFromTargetRoot(CamlockTarget) or nil
    if visualPlayer == lastCamlockVisualPlayer then
        return
    end
    lastCamlockVisualPlayer = visualPlayer
    setDropdownVisualTarget(visualPlayer)
    forceUpdateTargetStatusParagraph()
end
local camlockConn
local function camlockStep(dt)
    if isSafeTeleportLocked() then
        return
    end
    if not CamlockEnabled then
        CamlockTarget = nil
        lastCamlockVisualPlayer = false
        forceUpdateTargetStatusParagraph()
        if camlockConn then
            camlockConn:Disconnect()
            camlockConn = nil
        end
        return
    end
    if not IsAlive(LocalPlayer.Character) then
        CamlockEnabled = false
        CamlockTarget = nil
        lastCamlockVisualPlayer = false
        forceUpdateTargetStatusParagraph()
        if camlockConn then
            camlockConn:Disconnect()
            camlockConn = nil
        end
        return
    end
    scanTimer = scanTimer + dt
    if not CamlockTarget and scanTimer < SCAN_INTERVAL then
        return
    end
    if scanTimer >= SCAN_INTERVAL then
        scanTimer = 0
        RefreshTargets()
    end
    if CamlockTarget then
        local model = CamlockTarget:FindFirstAncestorOfClass("Model")
        if not model or not IsAlive(model) then
            CamlockTarget = nil
            syncCamlockVisualTarget()
        end
    end
    if not CamlockTarget then
        CamlockTarget = GetClosestTarget()
        syncCamlockVisualTarget()
        if not CamlockTarget then return end
    end
    BasePrediction = GetPrediction()
    local targetVel = CamlockTarget.AssemblyLinearVelocity or Vector3.zero
    if targetVel.Magnitude > 1000 then
        targetVel = Vector3.zero
    end
    local predictionOffset = targetVel * BasePrediction
    if predictionOffset.Magnitude > 5 then
        predictionOffset = predictionOffset.Unit * 5
    end
    local predicted = CamlockTarget.Position + predictionOffset
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predicted)
end
Tabs.KEY:AddKeybind("camKeybind", {
    Title = "Cam Lock",
    Mode = "Toggle",
    Default = "Z",
    Callback = function(v)
        if v and not IsAlive(LocalPlayer.Character) then return end
        CamlockEnabled = v
        if not camlockState.statusParagraph then
            camlockState.statusParagraph = UIStatus.camlock
        end
        if camlockState.statusParagraph then
            camlockState.statusParagraph:SetTitle(
                v and "CamLock : ON" or "CamLock : OFF"
            )
        end
        if v then
            RefreshTargets()
            CamlockTarget = GetClosestTarget()
            syncCamlockVisualTarget()
            if not camlockConn then
                camlockConn = RunService.RenderStepped:Connect(camlockStep)
            end
        else
            CamlockTarget = nil
            lastCamlockVisualPlayer = false
            setDropdownVisualTarget(nil)
            forceUpdateTargetStatusParagraph()
            if camlockConn then
                camlockConn:Disconnect()
                camlockConn = nil
            end
        end
    end
})
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
    statusParagraph = UIStatus.walkfling
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
Tabs.KEY:AddKeybind("WalkFlingKey", {
    Title = "Walk Fling Toggle",
    Mode = "Toggle",
    Default = "X",
    Callback = function()
        walkflinging = not walkflinging
        if not walkFlingState.statusParagraph then
            walkFlingState.statusParagraph = UIStatus.walkfling
        end
        if walkFlingState.statusParagraph then
            walkFlingState.statusParagraph:SetTitle(
                walkflinging and "Walk Fling : ON" or "Walk Fling : OFF"
            )
        end
        Fluent:Notify({
            Title = "NOTHING X",
            Content = "Walk Fling: " .. (walkflinging and "ON" or "OFF"),
            Duration = 2
        })
        if walkflinging then
            task.spawn(WalkFlingLoop)
        end
    end
})
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
    task.spawn(function()
        while auraFlingOn do
            local myChar = LocalPlayer.Character
            local myRoot = getRootUniversal(myChar)
            if myRoot then
                local originalCFrame = myRoot.CFrame
                local p = flingAllPower
                local myPos = myRoot.Position
                local hitAny = false
                for _,player in pairs(getTrackedPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = getRootUniversal(player.Character)
                        if targetRoot then
                            local dist = (targetRoot.Position - myPos).Magnitude
                            if dist <= auraRange then
                                hitAny = true
                                VisualFix:Start(targetRoot)
                                myRoot.AssemblyLinearVelocity = Vector3.zero
                                myRoot.AssemblyAngularVelocity = Vector3.zero
                                myChar:PivotTo(targetRoot.CFrame)
                                task.wait() 
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
                    myChar:PivotTo(originalCFrame)
                    VisualFix:Stop()
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
    task.spawn(function()
        local myChar = LocalPlayer.Character
        local targetChar = targetPlayer and targetPlayer.Character
        local myRoot = getRootUniversal(myChar)
        local targetRoot = getRootUniversal(targetChar)
        if myRoot and targetRoot then
            local savedCFrame = myRoot.CFrame
            VisualFix:Start(targetRoot)
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
            VisualFix:Stop()
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
local flingTargetIndex = 1
local function flingAll()
    if flingAllConn then flingAllConn:Disconnect() end
    flingTargetIndex = 1
    local t = 0
    VisualFix:Start(nil) 
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
            VisualFix:Stop()
            return
        end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and getRootUniversal(myChar)
        if not myRoot then return end
        local p = flingAllPower
        local players = getTrackedPlayers()
        local targets = {}
        for i = 1, #players do
            local plr = players[i]
            if plr ~= LocalPlayer and plr.Character then
                local targetRoot = getRootUniversal(plr.Character)
                if targetRoot then table.insert(targets, targetRoot) end
            end
        end
        if #targets == 0 then return end
        if flingTargetIndex > #targets then flingTargetIndex = 1 end
        local targetRoot = targets[flingTargetIndex]
        t = t + dt * orbitSpeed
        orbitStepXZ = orbitStepXZ + orbitIncrement
        orbitStepY = orbitStepY + orbitIncrement
        if orbitStepXZ > orbitMax then orbitStepXZ = 0 end
        if orbitStepY > orbitMax then orbitStepY = 0 end
        local offset = Vector3.new(
            math.cos(t) * orbitStepXZ,
            orbitStepY,
            math.sin(t) * orbitStepXZ
        )
        myRoot.CFrame = targetRoot.CFrame + offset
        myRoot.AssemblyAngularVelocity = Vector3.new(p, p, p)
        myRoot.AssemblyLinearVelocity =
            targetRoot.CFrame.LookVector * p +
            Vector3.new(0, p * 0.5, 0)
        flingTargetIndex = flingTargetIndex + 1
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
                for _, player in pairs(getTrackedPlayers()) do
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
local function initAttackTargeting()
local LocalPlayer = Players.LocalPlayer
local AttackMouse = LocalPlayer:GetMouse()
local attackState = {
    active = false,
    statusParagraph = UIStatus.attack
}
local ZERO_DELAY_ALL_TP = true
local ATTACK_RATE = 0
local MODEL_SCAN_RATE = 0
local MAX_TARGET_DISTANCE = 2000
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
    task.defer(refreshCharacter)
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
                        if model ~= localChar and isAlive(model) and not Players:GetPlayerFromCharacter(model) then
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
                for _, plr in ipairs(getTrackedPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and isAlive(plr.Character) then
                        local char = plr.Character
                        local part =
                            char:FindFirstChild("HumanoidRootPart")
                            or char.PrimaryPart
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
    end)
end
local function stopScanLoop()
    scanLoopRunning = false
    table.clear(TargetCache)
end
local function getClosestTarget()
    if ZERO_DELAY_ALL_TP and Root then
        local closest
        local shortest = math.huge
        local rootPos = Root.Position
        local localChar = Character
        if LiveFolder then
            for _, model in ipairs(LiveFolder:GetChildren()) do
                if model ~= localChar and isAlive(model) and not Players:GetPlayerFromCharacter(model) then
                    local part =
                        model:FindFirstChild("HumanoidRootPart")
                        or model.PrimaryPart
                        or model:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local dist = (rootPos - part.Position).Magnitude
                        if dist < MAX_TARGET_DISTANCE and dist < shortest then
                            shortest = dist
                            closest = part
                        end
                    end
                end
            end
        end
        for _, plr in ipairs(getTrackedPlayers()) do
            if plr ~= LocalPlayer and plr.Character and isAlive(plr.Character) then
                local char = plr.Character
                local part =
                    char:FindFirstChild("HumanoidRootPart")
                    or char.PrimaryPart
                if part then
                    local dist = (rootPos - part.Position).Magnitude
                    if dist < MAX_TARGET_DISTANCE and dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
        return closest
    end
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
            if hum and hum.Health > 0 then
                return t
            end
        end
    end
    if playerChosen and playerChosen.Character and isAlive(playerChosen.Character) then
        local root = getRootUniversal(playerChosen.Character)
        if root then return root end
    end
    return getClosestTarget()
end
local holdingMouse = false
local attackLoopRunning = false
local lastAttackTime = 0
local attackLoopThread = nil
local function isAttackHoldActive()
    return holdingMouse or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end
local function performAttackTeleport()
    if isSafeTeleportLocked() then
        return
    end
    if not (attackState.active and isAttackHoldActive() and Root and not HasTrash and not TrashNearby) then
        VisualFix:Stop()
        return
    end
    local target = getAttackTarget()
    if not target then
        VisualFix:Stop()
        return
    end
    VisualFix:Start(target)
    if Humanoid then
        Humanoid.AutoRotate = false
    end
    local targetVel = target.AssemblyLinearVelocity or Vector3.zero
    if targetVel.Magnitude > 1000 then
        targetVel = Vector3.zero
    end
    local prediction = Vector3.zero
    if not ZERO_DELAY_ALL_TP then
        local ping = LocalPlayer:GetNetworkPing() or 0
        prediction = targetVel * (ping * 1.05)
        if prediction.Magnitude > 10 then
            prediction = prediction.Unit * 10
        end
    end
    local combinedVel = targetVel + prediction
    local isAirTarget = math.abs(combinedVel.Y) > 8
    local tpVelocity = (targetVel.Magnitude > 300) and (targetVel.Unit * 180) or (targetVel * 1.35)
    local directPush = (target.Position + prediction) - Root.Position
    if directPush.Magnitude > 0.001 then
        tpVelocity = tpVelocity + (directPush.Unit * (isAirTarget and 340 or 220))
    end
    Root.AssemblyLinearVelocity = Vector3.zero
    Root.AssemblyAngularVelocity = Vector3.zero
    local attackBackOffset, attackVerticalOffset = getAttackTeleportOffsets(combinedVel)
    local targetProxy = {
        Position = target.Position + prediction,
        CFrame = target.CFrame
    }
    Character:PivotTo(getTeleportFollowCFrame(targetProxy, targetVel + prediction, attackBackOffset, attackVerticalOffset))
end
local function startAttackLoop()
    if attackLoopRunning then return end
    attackLoopRunning = true
    attackLoopThread = (ZERO_DELAY_ALL_TP and RunService.RenderStepped or RunService.Heartbeat):Connect(function()
        if not attackLoopRunning then
            if attackLoopThread then attackLoopThread:Disconnect() attackLoopThread = nil end
            VisualFix:Stop()
            return
        end
        if not ZERO_DELAY_ALL_TP then
            local now = tick()
            if now - lastAttackTime < ATTACK_RATE then return end
            lastAttackTime = now
        end
        performAttackTeleport()
    end)
end
local function stopAttackLoop()
    attackLoopRunning = false
    holdingMouse = false
    if Humanoid then
        Humanoid.AutoRotate = true
    end
end
AttackMouse.Button1Down:Connect(function()
    holdingMouse = true
    if not attackState.active then return end
    refreshCharacter()
    performAttackTeleport()
end)
AttackMouse.Button1Up:Connect(function()
    holdingMouse = false
end)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = true
        if attackState.active then
            refreshCharacter()
            performAttackTeleport()
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = false
    end
end)
local function setAttackState(enabled)
    attackState.active = enabled
    if not attackState.statusParagraph then
        attackState.statusParagraph = UIStatus.attack
    end
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
Tabs.KEY:AddKeybind("AttackTPKeybind", {
    Title = "Attack TP",
    Mode = "Toggle",
    Default = "T",
    Callback = function()
        local nextState = not attackState.active
        setAttackState(nextState)
        Fluent:Notify({
            Title = "NOTHING X",
            Content = "Attack TP: " .. (nextState and "ON" or "OFF"),
            Duration = 2
        })
    end
})
targetState = {
    statusParagraph = UIStatus.target
}
local lastTargetStatusTitle = nil
local function getTargetDisplayNameFromRoot(targetRoot)
    if not (targetRoot and targetRoot.Parent) then return nil end
    local model = targetRoot:FindFirstAncestorOfClass("Model")
    if not model then return nil end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    local plr = Players:GetPlayerFromCharacter(model)
    if plr and plr.Parent == Players then
        return plr.DisplayName
    end
    return model.Name
end
getPlayerFromTargetRoot = function(targetRoot)
    if not (targetRoot and targetRoot.Parent) then return nil end
    local model = targetRoot:FindFirstAncestorOfClass("Model")
    if not model then return nil end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    return Players:GetPlayerFromCharacter(model)
end
getPriorityTargetPlayer = function()
    if CamlockEnabled then
        local camlockPlayer = getPlayerFromTargetRoot(CamlockTarget)
        if camlockPlayer and camlockPlayer.Parent == Players then
            return camlockPlayer
        end
    end
    if playerChosen and playerChosen.Parent == Players then
        return playerChosen
    end
    return nil
end
local chosenTargetHumConn = nil
local chosenTargetCharConn = nil
local chosenTargetRemovingConn = nil
local chosenTargetHeartbeatConn = nil
local function disconnectChosenTargetWatch()
    if chosenTargetHumConn then
        chosenTargetHumConn:Disconnect()
        chosenTargetHumConn = nil
    end
    if chosenTargetCharConn then
        chosenTargetCharConn:Disconnect()
        chosenTargetCharConn = nil
    end
    if chosenTargetRemovingConn then
        chosenTargetRemovingConn:Disconnect()
        chosenTargetRemovingConn = nil
    end
    if chosenTargetHeartbeatConn then
        chosenTargetHeartbeatConn:Disconnect()
        chosenTargetHeartbeatConn = nil
    end
end
local function clearChosenTarget()
    disconnectChosenTargetWatch()
    dropdownChosen = nil
    playerChosen = nil
    _G.playerChosen = nil
    if setDropdownVisualTarget then
        setDropdownVisualTarget(nil)
    end
    if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning and _G.NOTHINGX_TrashPlayer.IsRunning() then
        _G.NOTHINGX_TrashPlayer.SetRunning(false)
    end
    if viewing and ViewToggle and ViewToggle.SetValue then
        ViewToggle:SetValue(false)
    end
end
watchChosenTarget = function(plr)
    disconnectChosenTargetWatch()
    if not (plr and plr.Parent == Players) then return end
    chosenTargetHeartbeatConn = RunService.Heartbeat:Connect(function()
        if playerChosen ~= plr then return end
        if not plr.Parent then
            clearChosenTarget()
            forceUpdateTargetStatusParagraph()
        end
    end)
end
local function hasChosenTarget()
    if playerChosen and playerChosen.Parent == Players then
        return true
    end
    if playerChosen then
        clearChosenTarget()
    end
    return false
end
local function updateTargetStatusParagraph()
    local paragraph = (targetState and targetState.statusParagraph) or UIStatus.target
    if not paragraph then return end
    if targetState and not targetState.statusParagraph then
        targetState.statusParagraph = paragraph
    end
    if playerChosen and not hasChosenTarget() then
        forceUpdateTargetStatusParagraph()
        return
    end
    local nextTitle = "Target : None"
    if CamlockEnabled then
        local camlockName = getTargetDisplayNameFromRoot(CamlockTarget)
        if camlockName then
            nextTitle = "Target : " .. camlockName
        end
    end
    if nextTitle == "Target : None" and playerChosen and playerChosen.Parent == Players then
        nextTitle = "Target : " .. playerChosen.DisplayName
    end
    if nextTitle ~= lastTargetStatusTitle then
        lastTargetStatusTitle = nextTitle
        paragraph:SetTitle(nextTitle)
    end
end
forceUpdateTargetStatusParagraph = function()
    lastTargetStatusTitle = nil
    updateTargetStatusParagraph()
end
task.spawn(function()
    while true do
        updateTargetStatusParagraph()
        task.wait(0.05)
    end
end)
local Dropdown
local refreshDropdown
local startView
local lastFullRefreshTime = 0
local lastMouseTargetSetTick = 0
setDropdownVisualTarget = function(plr)
    if not Dropdown or not Dropdown.SetValues or not Dropdown.SetValue then return end

    local values = buildDropdownValues()
    local selectedDisplay = "None"

    if plr and plr.Parent == Players then
        selectedDisplay = plr.DisplayName .. " (@" .. plr.Name .. ")"
        dropdownMap[selectedDisplay] = plr
        local found = false
        for i = 1, #values do
            if values[i] == selectedDisplay then
                found = true
                break
            end
        end
        if not found then
            table.insert(values, selectedDisplay)
        end
    end

    pcall(function()
        Dropdown:SetValues(values)
    end)
    pcall(function()
        Dropdown:SetValue(selectedDisplay)
    end)
end
local function triggerMouseTargetSet()
    local now = tick()
    if now - lastMouseTargetSetTick < 0.05 then
        return
    end
    lastMouseTargetSetTick = now

    local Lp = Players.LocalPlayer
    local Plrs = Players
    
    if hasChosenTarget() then
        clearChosenTarget()
        setDropdownVisualTarget(nil)
        forceUpdateTargetStatusParagraph()
        return
    end

    local mouse = Lp:GetMouse()
    local cam = workspace.CurrentCamera
    local target = nil
    
    local function checkAlive(model)
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0
    end

    local mouseTarget = mouse.Target
    if mouseTarget then
        local model = mouseTarget:FindFirstAncestorOfClass("Model")
        local p = model and Plrs:GetPlayerFromCharacter(model)
        if p and p ~= Lp and checkAlive(model) then
            target = p
        end
    end

    if not target then
        local closestWorldDist = math.huge
        local hitPos = mouse.Hit.p
        local Players_ = getTrackedPlayers()
        for i = 1, #Players_ do
            local plr = Players_[i]
            if plr ~= Lp and plr.Character then
                local char = plr.Character
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                if root then
                    local d = (root.Position - hitPos).Magnitude
                    if d < closestWorldDist and d < 350 then
                        closestWorldDist = d
                        target = plr
                    end
                end
            end
        end
    end

    if not target then
        local closestDist = math.huge
        local mouseLoc = Vector2.new(mouse.X, mouse.Y)
        local Players_ = getTrackedPlayers()
        for i = 1, #Players_ do
            local plr = Players_[i]
            if plr ~= Lp and plr.Character then
                local char = plr.Character
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                if root then
                    local pos, visible = cam:WorldToViewportPoint(root.Position)
                    if visible then
                        local distance = (mouseLoc - Vector2.new(pos.X, pos.Y)).Magnitude
                            if distance < closestDist and distance < 260 then
                                closestDist = distance
                                target = plr
                            end
                    end
                end
            end
        end
    end

    if target then
        playerChosen = target
        _G.playerChosen = target
        watchChosenTarget(target)
        setDropdownVisualTarget(target)
        forceUpdateTargetStatusParagraph()
        if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning and _G.NOTHINGX_TrashPlayer.IsRunning() then
            _G.NOTHINGX_TrashPlayer.AttachTarget(target)
        end
        if viewing then
            startView(target)
        end
    end
end
Tabs.KEY:AddKeybind("MouseTargetSet", {
    Title = "Set Target (Mouse)",
    Default = "C",
    Mode = "Toggle",
    Callback = function(pressed)
        if not pressed then return end
        triggerMouseTargetSet()
    end
})
end
initAttackTargeting()

local function initDefenseAndUtilityUI()
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
                    VisualFix:Start("SafeZone")
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
                    VisualFix:Stop()
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
            VisualFix:Stop()
		end
	end
})
local camLockTrashEnabled = false
local camLockTrashHolding = false
local camLockTrashSession = false
local camLockTrashActive = false
local camLockTrashConn = nil
local camLockTrashInputBegan = nil
local camLockTrashInputEnded = nil
local camLockTrashPrevPlayer = nil
local camLockTrashPrevRunning = false
local function isAlivePlayerTarget(plr)
	if not (plr and plr.Parent == Players) then
		return false
	end
	local char = plr.Character
	if not char then
		return false
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("UpperTorso")
		or char:FindFirstChild("Torso")
	return hum ~= nil and hum.Health > 0 and root ~= nil
end
local function getCamlockPlayer()
	if CamlockEnabled then
		local t = CamlockTarget
		if t and t.Parent then
			local model = t:FindFirstAncestorOfClass("Model")
			if model then
				local hum = model:FindFirstChildOfClass("Humanoid")
				local plr = Players:GetPlayerFromCharacter(model)
				if hum and hum.Health > 0 and plr then
					return plr
				end
			end
		end
	end
	if playerChosen and playerChosen.Parent == Players then return playerChosen end
	return nil
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
		_G.playerChosen = camLockTrashPrevPlayer
	end
	if camLockTrashPrevRunning and _G.NOTHINGX_TrashPlayer and isAlivePlayerTarget(playerChosen) then
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
		if not _G.NOTHINGX_TrashPlayer then return end
		local targetPlr = getCamlockPlayer()
		if not isAlivePlayerTarget(targetPlr) then
			stopCamLockTrashActive()
			return
		end
		if playerChosen ~= targetPlr then
			playerChosen = targetPlr
			_G.playerChosen = targetPlr
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
if trashFolder then
	Tabs.TOG:AddToggle("camlocktrash", {
		Title = "Cam-Lock/target/ Trash Cant (Hold Right)",
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
end
end
initDefenseAndUtilityUI()
Tabs.TOG:AddToggle("VisualFixToggle", {
    Title = "Visual TP Fix (Smooth View)",
    Default = false,
    Callback = function(state)
        VisualFixEnabled = state
        if not state then VisualFix:Stop() end
    end
})
Tabs.TOG:AddDropdown("TpVariantAll", {
    Title = "TP Variant All",
    Values = {"Aggressive", "Direct", "Under", "Above", "Behind"},
    Multi = false,
    Default = "Behind",
    Callback = function(value)
        TPVariantMode = value or "Behind"
    end
})
local ToggleUlt
local ToggleClass
local ToggleDetectUlt
local function initUltEspUI()
local LocalPlayer = Players.LocalPlayer
local hasUltimate = LocalPlayer:GetAttribute("Ultimate") ~= nil
local hasCharacter = LocalPlayer:GetAttribute("Character") ~= nil
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
                task.spawn(function()
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
    if ToggleDetectUlt and ToggleDetectUlt.Value then
        if val >= 100 then
            if UltEspState.active[plr] and not UltEspState.timer[plr] then
                hideUltEsp(plr)
                UltEspState.active[plr] = false
            end
            return
        end
        if prev and prev >= 100 and val < prev then
            UltEspState.active[plr] = true
            startUltTimer(plr)
            createUltEsp(plr)
            return
        end
        if val > 0 and val < 100 and not UltEspState.timer[plr] then
            finishUltEsp(plr)
        end
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
    for _, plr in ipairs(getTrackedPlayers()) do
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
            for _, plr in ipairs(getTrackedPlayers()) do
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
task.delay(1.5, function()
    local showUlt = ToggleUlt and ToggleUlt.Value
    local showClass = ToggleClass and ToggleClass.Value
    if showUlt or showClass then
        UpdateAll()
    end
end)
end
initUltEspUI()

local function initPlayerTargetUI()
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local viewing = false
local currentTarget = nil
local viewDied = nil
local viewChanged = nil
dropdownMap = dropdownMap or {}
local dropdownChosen = nil
local flingOneOn = false
local flingOneConnection = nil
local autoTpOn = false
local autoTpConnection = nil
local TrashPlayerKeybind = nil
RefreshToggle = nil
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
lastFullRefreshTime = lastFullRefreshTime or 0
buildDropdownValues = function()
    dropdownMap = {}
    local values = { "None" }
    local seen = { ["None"] = true }
    local function pushPlayer(plr)
        if not (plr and plr.Parent == Players) then return end
        if plr == LocalPlayer then return end
        local display = plr.DisplayName .. " (@" .. plr.Name .. ")"
        if seen[display] then return end
        seen[display] = true
        dropdownMap[display] = plr
        table.insert(values, display)
    end
    if RefreshToggle and RefreshToggle.Value == true then
        for _, plr in ipairs(getTrackedPlayers()) do
            pushPlayer(plr)
        end
    else
        pushPlayer(getPriorityTargetPlayer())
        pushPlayer(dropdownChosen)
    end
    return values
end
startView = function(targetPlayer)
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
    flingOneConnection = (ZERO_DELAY_ALL_TP and RunService.RenderStepped or RunService.Heartbeat):Connect(function(dt)
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
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
        myChar:PivotTo(targetRoot.CFrame + offset)
        local p = FLING_INF_POWER
        myRoot.AssemblyAngularVelocity = Vector3.new(p, p, p)
        myRoot.AssemblyLinearVelocity =
            myRoot.CFrame.LookVector * p + Vector3.new(0, p/2, 0)
    end)
end
local function startAutoTp()
    if autoTpConnection then autoTpConnection:Disconnect() end
    autoTpConnection = (ZERO_DELAY_ALL_TP and RunService.RenderStepped or RunService.Heartbeat):Connect(function()
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
        local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.zero
        if targetVel.Magnitude > 1000 then
            targetVel = Vector3.zero
        end
        local prediction = Vector3.zero
        if not ZERO_DELAY_ALL_TP then
            local ping = LocalPlayer:GetNetworkPing() or 0
            prediction = targetVel * ping
            if prediction.Magnitude > 10 then
                prediction = prediction.Unit * 10
            end
        end
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
        local config = getTpVariantConfig()
        local targetProxy = {
            Position = targetRoot.Position + prediction,
            CFrame = targetRoot.CFrame
        }
        myChar:PivotTo(getTeleportFollowCFrame(targetProxy, targetVel + prediction, config.autoBack, config.autoVertical))
    end)
end
Dropdown = Tabs.PLYR:AddDropdown("Dropdown_player", {
    Title = "Player",
    Values = buildDropdownValues(),
    Multi = false,
    Default = "None",
Callback = function(value)
    dropdownChosen = dropdownMap[value]
    playerChosen = dropdownChosen
    _G.playerChosen = dropdownChosen
    if playerChosen and playerChosen.Character then
        watchChosenTarget(playerChosen)
        forceUpdateTargetStatusParagraph()
    end
    if not playerChosen then
        dropdownChosen = nil
        forceUpdateTargetStatusParagraph()
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
refreshDropdown = function()
    local oldTarget = dropdownChosen or playerChosen or getPriorityTargetPlayer()
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
        dropdownChosen = nil
        playerChosen = nil
        _G.playerChosen = nil
        Dropdown:SetValue("None")
        forceUpdateTargetStatusParagraph()
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
local function triggerFullRefresh()
    lastFullRefreshTime = tick()
    refreshDropdown()
    task.delay(11.1, function()
        refreshDropdown() 
    end)
end
local nextRefresh = 0
local function scheduleDropdownRefresh()
    local thisRefresh = tick() + 0.15
    nextRefresh = thisRefresh
    task.delay(0.15, function()
        if nextRefresh == thisRefresh then
            refreshDropdown()
        end
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
    if autoTpOn and playerChosen == plr then
        AutoTpToggle:SetValue(false)
    end
    if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning() and playerChosen == plr then
        _G.NOTHINGX_TrashPlayer.SetRunning(false)
    end
    scheduleDropdownRefresh()
end)
local lastManualRefresh = 0
RefreshToggle = Tabs.PLYR:AddToggle("RefreshToggle", {
    Title = "List Player",
    Default = false,
    Callback = function(state)
        if state then
            local now = tick()
            if now - lastManualRefresh < 11 then
                task.spawn(function()
                    RefreshToggle:SetValue(false)
                end)
                return
            end
            lastManualRefresh = now
            triggerFullRefresh()
            task.delay(11, function()
                if RefreshToggle.Value then
                    RefreshToggle:SetValue(false)
                end
            end)
        else
            lastFullRefreshTime = 0
            refreshDropdown()
        end
    end
})
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
            myHrp.AssemblyLinearVelocity = Vector3.zero
            myHrp.AssemblyAngularVelocity = Vector3.zero
            local config = getTpVariantConfig()
            local targetVel = hrp.AssemblyLinearVelocity or Vector3.zero
            local targetProxy = {
                Position = hrp.Position,
                CFrame = hrp.CFrame
            }
            myChar:PivotTo(getTeleportFollowCFrame(targetProxy, targetVel, config.playerBack, config.playerVertical))
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
    TrashPlayerKeybind = Tabs.KEY:AddKeybind("TrashPlayerKeybind", {
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
    Title = "Fix Camera",
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
                LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
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
end
initPlayerTargetUI()

local function disableTeleportFeaturesForVoidProtection()
    VisualFix:Stop()
    if autoTpOn then
        if AutoTpToggle and AutoTpToggle.SetValue then
            AutoTpToggle:SetValue(false)
        else
            autoTpOn = false
            if autoTpConnection then
                autoTpConnection:Disconnect()
                autoTpConnection = nil
            end
        end
    end
    if flingOneOn then
        if FlingOneToggle and FlingOneToggle.SetValue then
            FlingOneToggle:SetValue(false)
        else
            flingOneOn = false
            if flingOneConnection then
                flingOneConnection:Disconnect()
                flingOneConnection = nil
            end
        end
    end
    if _G.NOTHINGX_TrashPlayer and _G.NOTHINGX_TrashPlayer.IsRunning and _G.NOTHINGX_TrashPlayer.IsRunning() then
        _G.NOTHINGX_TrashPlayer.SetRunning(false)
    end
end

_G.NOTHINGX_Protection = _G.NOTHINGX_Protection or {}
_G.NOTHINGX_Protection.defaultCFrame = CFrame.new(0, 0, 0)
_G.NOTHINGX_Protection.boundarySize = Vector3.new(100000, 0, 100000)
_G.NOTHINGX_Protection.lastSafePosition = nil

function _G.NOTHINGX_Protection.getMainPart()
    local map = workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("MainPart")
end

function _G.NOTHINGX_Protection.getReferenceCFrame()
    local mainPart = _G.NOTHINGX_Protection.getMainPart()
    return (mainPart and mainPart.CFrame) or _G.NOTHINGX_Protection.defaultCFrame
end

function _G.NOTHINGX_Protection.isOutsideBoundary(position)
    local cf = _G.NOTHINGX_Protection.getReferenceCFrame()
    local localPos = cf:PointToObjectSpace(position)
    local halfSize = _G.NOTHINGX_Protection.boundarySize / 2
    return localPos.X < -halfSize.X or localPos.X > halfSize.X
        or localPos.Z < -halfSize.Z or localPos.Z > halfSize.Z
end

function _G.NOTHINGX_Protection.getGroundSupportResult(hrp)
    if not hrp or not hrp.Parent then
        return nil
    end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {hrp.Parent}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    return workspace:Raycast(hrp.Position, Vector3.new(0, -8, 0), params)
end

function _G.NOTHINGX_Protection.updateLastSafePosition(hrp, minY)
    if not hrp or not hrp.Parent then
        return false
    end
    if minY and hrp.Position.Y < minY then
        return false
    end
    if _G.NOTHINGX_Protection.isOutsideBoundary(hrp.Position) then
        return false
    end
    local groundResult = _G.NOTHINGX_Protection.getGroundSupportResult(hrp)
    if not groundResult or not groundResult.Instance then
        return false
    end
    _G.NOTHINGX_Protection.lastSafePosition = hrp.CFrame
    return true
end

function _G.NOTHINGX_Protection.getRescueCFrame()
    return _G.NOTHINGX_Protection.lastSafePosition or _G.NOTHINGX_Protection.getReferenceCFrame()
end

function _G.NOTHINGX_Protection.resetVelocity(hrp)
    if not hrp or not hrp.Parent then
        return
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

function _G.NOTHINGX_Protection.teleportCharacter(character, hrp, targetCFrame)
    _G.SafeTeleportLock = true
    disableTeleportFeaturesForVoidProtection()
    local rescueCFrame = targetCFrame or _G.NOTHINGX_Protection.getRescueCFrame()
    if not rescueCFrame then
        _G.SafeTeleportLock = false
        return false
    end
    for _ = 1, 15 do
        _G.NOTHINGX_Protection.resetVelocity(hrp)
        character:PivotTo(rescueCFrame + Vector3.new(0, 5, 0))
        task.wait()
    end
    _G.SafeTeleportLock = false
    return true
end

local function initBoundaryProtection()
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
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
	_G.NOTHINGX_Protection.updateLastSafePosition(hrp)
	if _G.NOTHINGX_Protection.isOutsideBoundary(hrp.Position) then
        local rescueCFrame = _G.NOTHINGX_Protection.getRescueCFrame()
        local ok, err = pcall(function()
            _G.NOTHINGX_Protection.teleportCharacter(character, hrp, rescueCFrame)
        end)
        _G.SafeTeleportLock = false
        if not ok then
            warn("Boundary protection teleport failed:", err)
        end
	end
end)
player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
end)
end
initBoundaryProtection()

local function initVoidProtection()

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local NPC_NAME = "X"
local CREATE_POS = Vector3.new(0, -50, 0)
local MAX_RETRIES = 10
local VOID_Y = nil
local function spawnNPC()
    local old = Workspace:FindFirstChild(NPC_NAME)
    if old then old:Destroy() end
    local model = Instance.new("Model")
    model.Name = NPC_NAME
    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2,5,1)
    root.Position = CREATE_POS
    root.Parent = model
	root.Anchored = false 
    root.CanCollide = false
	root.Color = Color3.fromRGB(255, 165, 0)  
root.Material = Enum.Material.ForceField
root.Transparency = 0.5
    local hum = Instance.new("Humanoid")
    hum.Parent = model
    model.PrimaryPart = root
    model.Parent = Workspace
    local saved = false
    local hbConnection
    local function saveAndDestroy(reason)
        if saved then return end
        saved = true
        if root then
            VOID_Y = root.Position.Y
			  print("VOID")
        else
            warn(" - :", reason)
        end
        if hbConnection then
            hbConnection:Disconnect()
        end

pcall(function()
    if model then
        model:Destroy()
    end
end)
    end
    hum.Died:Connect(function()
        saveAndDestroy("Humanoid.Died")
    end)
    root.Destroying:Connect(function()
        saveAndDestroy("Root.Destroying")
    end)
    hbConnection = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent then
            saveAndDestroy("Heartbeat fail")
        end
    end)
end
for i = 1, MAX_RETRIES do
    spawnNPC()
    task.wait()
    if VOID_Y then
        break
    end
    if i == MAX_RETRIES then
        warn("---")
    end
end
local BUFFER = 210
local function protect(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    while character.Parent do
        task.wait()
        _G.NOTHINGX_Protection.updateLastSafePosition(hrp, VOID_Y and (VOID_Y + BUFFER) or nil)
        if VOID_Y and hrp.Position.Y < (VOID_Y + BUFFER) then
            local rescueCFrame = _G.NOTHINGX_Protection.getRescueCFrame()
            if rescueCFrame then
                local ok, err = pcall(function()
                    _G.NOTHINGX_Protection.teleportCharacter(character, hrp, rescueCFrame)
                end)
                _G.SafeTeleportLock = false
                if not ok then
                    warn("Void protection teleport failed:", err)
                end
                print("^")
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
end
initVoidProtection()
