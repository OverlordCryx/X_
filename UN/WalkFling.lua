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
loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-UN"))()
end)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
    TabWidth = 29,
    Size = UDim2.fromOffset(410, 370),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})
local Tabs = {
    Main = Window:AddTab({ Title = "", Icon = "menu" }),
    XXX = Window:AddTab({ Title = "", Icon = "menu" })
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
