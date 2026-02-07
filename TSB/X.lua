task.spawn(function()
local mainPart = workspace.Map and workspace.Map:FindFirstChild("MainPart")
if not mainPart then return end
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
                SendNotification("NOTHING", plr.Name .. "  SERIOUS MODE ON", 5)
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
local maxSpeed = 500
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
    Default = "V",
    Callback = function()
        toggleFlight()
    end
})
setupFlyAnimation()
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
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ToggleUlt   = Tabs.XXX:AddToggle("ulttog",  { Title = "Show Ultimate %",       Default = false })
local ToggleClass = Tabs.XXX:AddToggle("classtog", { Title = "Show Character Name",  Default = false })
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
local function getPlayerNames()
    local names = {"None"}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end
local Dropdown = Tabs.XXX:AddDropdown("Dropdown_player", {
    Title = "Player",
    Values = getPlayerNames(),
    Multi = false,
    Default = "None"
})
local function updateDropdown()
    Dropdown:SetValues(getPlayerNames())
    Dropdown:SetValue("None") 
end
Players.PlayerAdded:Connect(function()
    updateDropdown()
end)
Players.PlayerRemoving:Connect(function()
    updateDropdown()
end)
local Button = Tabs.XXX:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        local selectedPlayerName = Dropdown.Value 
        if selectedPlayerName and selectedPlayerName ~= "None" then
            local targetPlayer = Players:FindFirstChild(selectedPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            else
            end
        else
        end
    end
})
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
