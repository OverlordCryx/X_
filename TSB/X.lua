local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local SPECIAL_CHARS = {
    "\226\128\139", "\226\128\138", "\226\128\140", "\226\128\141",
    "\194\160", "\226\128\143", "\226\128\142", "\239\187\191",
}
local function addNoise(str)
    local out = {}
    for i = 1, #str do
        local c = str:sub(i,i)
        out[#out+1] = c
        if c == " " and math.random() > 0.4 then
            out[#out+1] = SPECIAL_CHARS[math.random(1,#SPECIAL_CHARS)]
        end
    end
    return table.concat(out)
end
local function stripNoise(str)
    local result = str
    for _, ch in ipairs(SPECIAL_CHARS) do
        result = result:gsub(ch, "")
    end
    return result
end
local function generateToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()"
    local t = {}
    for i = 1, 32 do
        local r = math.random(1, #chars)
        t[#t+1] = chars:sub(r,r)
    end
    return table.concat(t)
end
local FILE_PATH = "NOTHING_X/Verfy/Verfy.file"
local displayName = localPlayer.DisplayName
local userName = localPlayer.Name
local function checkFile()
    if not (isfolder and isfile and readfile and writefile and makefolder) then
        return false, nil
    end
    if not isfile(FILE_PATH) then return false, nil end
    local raw = readfile(FILE_PATH)
    local lines = {}
    for line in raw:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    local line1 = lines[1]
    local line2 = lines[2]
    local line3 = lines[3]
    if not line1 or not line2 or not line3 then return false, nil end
    local clean = stripNoise(line1)
    local fDisplay, fUser, fToken, fBy, fTag =
        clean:match('Verfy %("(.-)"%s*%) %("(.-)"%s*%) %("(.-)"%s*%) %("(.-)"%s*%) %("(.-)"%s*%)')
    if not fDisplay then return false, nil end
    if fUser ~= userName then return false, nil end
    if fDisplay ~= displayName then return false, nil end
    if fBy ~= "BY NOTHING _X" then return false, nil end
    if fTag ~= "TSB" then return false, nil end
    if not fToken or #fToken < 32 then return false, nil end
    local len1 = utf8.len(line1)
    local len2 = utf8.len(line2)
    if not len1 or not len2 or len2 ~= len1 then
        return false, nil
    end
    local digitsOnly = line2:match("^~(%d+)~$")
    if not digitsOnly then
        return false, nil
    end
    if line3 ~= "/\\" then
        return false, nil
    end
    return true, fToken
end
local function generateLongToken(length)
    local digitsNeeded = length - 2
    if digitsNeeded < 1 then digitsNeeded = 1 end
    local t = {"~"}
    for i = 1, digitsNeeded do
        t[#t+1] = tostring(math.random(0, 9))
    end
    t[#t+1] = "~"
    return table.concat(t)
end
local function writeFile(token)
    if not (makefolder and writefile) then return end
    if not isfolder("NOTHING_X") then makefolder("NOTHING_X") end
    if not isfolder("NOTHING_X/Verfy") then makefolder("NOTHING_X/Verfy") end
    local content = string.format(
        'Verfy ("%s") ("%s") ("%s") ("BY NOTHING _X") ("TSB")',
        displayName, userName, token
    )
    local line1 = addNoise(content)
    local utf8Length = utf8.len(line1) or #line1
    local longToken = generateLongToken(utf8Length)
    local line3 = "/\\"
    local fullContent = line1 .. "\n" .. longToken .. "\n" .. line3
    writefile(FILE_PATH, fullContent)
end
local savedCFrame = nil
local savedTransparencies = {}
local TP_POS = Vector3.new(9e9, 9e9, 9e9)
local function tpAway()
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    savedCFrame = hrp.CFrame
    savedTransparencies = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            savedTransparencies[part] = {
                transparency = part.Transparency,
                anchored = part.Anchored,
            }
            part.Transparency = 1
            part.Anchored = true
        elseif part:IsA("Decal") then
            savedTransparencies[part] = {transparency = part.Transparency}
            part.Transparency = 1
        end
    end
    hrp.CFrame = CFrame.new(TP_POS)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end
local function tpBack()
    local char = localPlayer.Character
    if not char or not savedCFrame then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for part, data in pairs(savedTransparencies) do
        pcall(function()
            if part and part.Parent then
                if part:IsA("BasePart") then
                    part.Transparency = data.transparency
                    part.Anchored = data.anchored
                elseif part:IsA("Decal") then
                    part.Transparency = data.transparency
                end
            end
        end)
    end
    hrp.CFrame = savedCFrame
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
end
local fileOk, existingToken = checkFile()
local SESSION_TOKEN = existingToken or generateToken()
UserInputService.MouseIconEnabled = false
UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
local robloxGui = CoreGui:FindFirstChild("RobloxGui")
local settingsShield = robloxGui and robloxGui:FindFirstChild("SettingsShield")
local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
local function forceLockCursor()
    if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
    if UserInputService.MouseIconEnabled then
        UserInputService.MouseIconEnabled = false
    end
    if settingsShield then
        pcall(function()
            if settingsShield.Visible then
                settingsShield.Visible = false
                GuiService:SetMenuIsOpen(false)
            end
        end)
    end
    if not devConsole then
        devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
    end
    if devConsole then
        pcall(function()
            if devConsole.Enabled then
                devConsole.Enabled = false
            end
        end)
    end
end
local cursorLockConn = RunService.RenderStepped:Connect(forceLockCursor)
local cursorLockConn2 = RunService.Heartbeat:Connect(forceLockCursor)
local cursorLockConn3 = UserInputService:GetPropertyChangedSignal("MouseBehavior"):Connect(forceLockCursor)
local cursorLockConn4 = UserInputService:GetPropertyChangedSignal("MouseIconEnabled"):Connect(forceLockCursor)
local camera = Workspace.CurrentCamera
local savedCameraType = camera.CameraType
local savedCameraSubject = camera.CameraSubject
camera.CameraType = Enum.CameraType.Scriptable
local CAMERA_OFFSET = Vector3.new(0, 3, 8) 
local cameraLockConn = RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cf = hrp.CFrame
            camera.CFrame = CFrame.new(cf.Position + cf.LookVector * -CAMERA_OFFSET.Z + Vector3.new(0, CAMERA_OFFSET.Y, 0), cf.Position)
        end
    end
end)
local savedStates = {}
local IGNORE_NAMES = {["Verify"] = true}
local function collectAndDisableGuis(container)
    for _, obj in ipairs(container:GetChildren()) do
        if obj:IsA("ScreenGui") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            if not IGNORE_NAMES[obj.Name] then
                table.insert(savedStates, {gui=obj, enabled=obj.Enabled})
                obj.Enabled = false
            end
        end
    end
end
collectAndDisableGuis(CoreGui)
collectAndDisableGuis(PlayerGui)
local addedConns = {}
local function watchContainer(container)
    local c = container.ChildAdded:Connect(function(child)
        if child:IsA("ScreenGui") or child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
            if not IGNORE_NAMES[child.Name] then
                task.defer(function()
                    table.insert(savedStates, {gui=child, enabled=child.Enabled})
                    child.Enabled = false
                end)
            end
        end
    end)
    table.insert(addedConns, c)
end
watchContainer(CoreGui)
watchContainer(PlayerGui)
local ALL_KEYS = Enum.KeyCode:GetEnumItems()
local ALL_MOUSE = {
    Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2,
    Enum.UserInputType.MouseButton3, Enum.UserInputType.MouseWheel,
    Enum.UserInputType.Touch, Enum.UserInputType.Gamepad1,
}
local blockedKeysList = {}
for _, key in ipairs(ALL_KEYS) do
    if key ~= Enum.KeyCode.R and key ~= Enum.KeyCode.Unknown then
        pcall(function()
            local actionName = "VERIFY_BLOCK_KEY_" .. key.Name
            ContextActionService:BindActionAtPriority(actionName,
                function() return Enum.ContextActionResult.Sink end,
                false, math.huge, key)
            table.insert(blockedKeysList, actionName)
        end)
    end
end
local blockedMouseList = {}
for _, mouseInput in ipairs(ALL_MOUSE) do
    pcall(function()
        local actionName = "VERIFY_BLOCK_MOUSE_" .. mouseInput.Name
        ContextActionService:BindActionAtPriority(actionName,
            function() return Enum.ContextActionResult.Sink end,
            false, math.huge, mouseInput)
        table.insert(blockedMouseList, actionName)
    end)
end
pcall(function()
    ContextActionService:BindActionAtPriority("VERIFY_BLOCK_ESC",
        function() return Enum.ContextActionResult.Sink end,
        false, math.huge + 1000000, Enum.KeyCode.Escape)
    table.insert(blockedKeysList, "VERIFY_BLOCK_ESC")
end)
pcall(function()
    ContextActionService:BindActionAtPriority("VERIFY_BLOCK_F9",
        function() return Enum.ContextActionResult.Sink end,
        false, math.huge + 1000000, Enum.KeyCode.F9)
    table.insert(blockedKeysList, "VERIFY_BLOCK_F9")
end)
local devConsoleConn
pcall(function()
    local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
    if devConsole then
        devConsole.Enabled = false
    end
    devConsoleConn = CoreGui.ChildAdded:Connect(function(child)
        if child.Name == "DevConsoleMaster" then
            pcall(function() child.Enabled = false end)
        end
    end)
end)
local sinkConn = UserInputService.InputBegan:Connect(function(input, gpe)
    return nil
end)
local sinkConn2 = UserInputService.InputChanged:Connect(function(input, gpe)
    return nil
end)
local sinkConn3 = UserInputService.InputEnded:Connect(function(input, gpe)
    return nil
end)
pcall(function()
    StarterGui:SetCore("TopbarEnabled", false)
end)
pcall(function()
    GuiService:SetMenuIsOpen(false)
end)
local menuBlockConn = GuiService.MenuOpened:Connect(function()
    pcall(function()
        GuiService:SetMenuIsOpen(false)
    end)
end)
tpAway()
if fileOk then
    cursorLockConn:Disconnect()
    cursorLockConn2:Disconnect()
    cursorLockConn3:Disconnect()
    cursorLockConn4:Disconnect()
    cameraLockConn:Disconnect()
    menuBlockConn:Disconnect()
    if devConsoleConn then pcall(function() devConsoleConn:Disconnect() end) end
    pcall(function()
        local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
        if devConsole then devConsole.Enabled = true end
    end)
    for _, c in ipairs(addedConns) do c:Disconnect() end
    sinkConn:Disconnect(); sinkConn2:Disconnect(); sinkConn3:Disconnect()
    for _, actionName in ipairs(blockedKeysList) do
        pcall(function() ContextActionService:UnbindAction(actionName) end)
    end
    for _, actionName in ipairs(blockedMouseList) do
        pcall(function() ContextActionService:UnbindAction(actionName) end)
    end
    UserInputService.MouseIconEnabled = true
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    camera.CameraType = savedCameraType
    if savedCameraSubject then camera.CameraSubject = savedCameraSubject end
    pcall(function() StarterGui:SetCore("TopbarEnabled", true) end)
    for _, entry in ipairs(savedStates) do
        pcall(function()
            if entry.gui and entry.gui.Parent then
                entry.gui.Enabled = entry.enabled
            end
        end)
    end
    tpBack()
    local function Execute_YH()
        task.defer(function() loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-TSB-new"))()end)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/NOTHING-X-X-X-NAHH/refs/heads/X/NAH.lua"))()
    end
    Execute_YH()
    return
end
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Verify"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 2147483647
screenGui.Parent = CoreGui
local blocker = Instance.new("TextButton")
blocker.Size = UDim2.new(1,0,1,0)
blocker.BackgroundTransparency = 1
blocker.Text = ""
blocker.ZIndex = 2147483647
blocker.Parent = screenGui
blocker.Activated:Connect(function() end)
local background = Instance.new("Frame")
background.Size = UDim2.new(1,0,1,0)
background.BackgroundColor3 = Color3.fromRGB(8,8,8)
background.BorderSizePixel = 0
background.ZIndex = 1
background.Parent = screenGui
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(4,4,4)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22,22,22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4,4,4)),
})
bgGradient.Rotation = 45
bgGradient.Parent = background
local vignette = Instance.new("ImageLabel")
vignette.Size = UDim2.new(1,0,1,0)
vignette.BackgroundTransparency = 1
vignette.Image = "rbxassetid://1316045217"
vignette.ImageTransparency = 0.2
vignette.ImageColor3 = Color3.fromRGB(0,0,0)
vignette.ZIndex = 2
vignette.Parent = background
local hLines = {}
for i = 1, 14 do
    local l = Instance.new("Frame")
    l.Size = UDim2.new(0,0,0,1)
    l.Position = UDim2.new(0,0,i/15,0)
    l.BackgroundColor3 = Color3.fromRGB(255,255,255)
    l.BackgroundTransparency = 0.93
    l.BorderSizePixel = 0
    l.ZIndex = 2
    l.Parent = background
    hLines[i] = l
    task.delay(0.08+i*0.055, function()
        TweenService:Create(l, TweenInfo.new(1.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
            {Size=UDim2.new(1,0,0,1)}):Play()
    end)
end
local vLinesArr = {}
for i = 1, 10 do
    local l = Instance.new("Frame")
    l.Size = UDim2.new(0,1,0,0)
    l.Position = UDim2.new(i/11,0,0,0)
    l.BackgroundColor3 = Color3.fromRGB(255,255,255)
    l.BackgroundTransparency = 0.95
    l.BorderSizePixel = 0
    l.ZIndex = 2
    l.Parent = background
    vLinesArr[i] = l
    task.delay(0.15+i*0.065, function()
        TweenService:Create(l, TweenInfo.new(1.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
            {Size=UDim2.new(0,1,1,0)}):Play()
    end)
end
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1,0,1,0)
particleContainer.BackgroundTransparency = 1
particleContainer.ZIndex = 3
particleContainer.Parent = background
local particles = {}
for i = 1, 80 do
    local sz = math.random(1,5)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,sz,0,sz)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.BackgroundTransparency = math.random(65,92)/100
    dot.BorderSizePixel = 0; dot.ZIndex = 3; dot.Parent = particleContainer
    local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(1,0); uc.Parent = dot
    local px,py = math.random(),math.random()
    dot.Position = UDim2.new(px,0,py,0)
    particles[i] = {frame=dot,sx=(math.random()-0.5)*0.0006,sy=(math.random()-0.5)*0.0006,
        px=px,py=py,base=math.random(65,90)/100,pt=math.random()*math.pi*2,ps=math.random(60,180)/100}
end
local scans = {}
for i = 1,3 do
    local s = Instance.new("Frame")
    s.Size = UDim2.new(1,0,0,i==1 and 3 or i==2 and 1 or 2)
    s.BackgroundColor3 = Color3.fromRGB(255,255,255)
    s.BackgroundTransparency = i==1 and 0.87 or i==2 and 0.94 or 0.90
    s.BorderSizePixel = 0; s.ZIndex = 4; s.Parent = background
    scans[i] = s
end
local flashes = {}
local flashPos = {UDim2.new(0,0,0,0),UDim2.new(1,-120,0,0),UDim2.new(0,0,1,-120),UDim2.new(1,-120,1,-120)}
for i = 1,4 do
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,120,0,120); f.Position = flashPos[i]
    f.BackgroundColor3 = Color3.fromRGB(255,255,255)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ZIndex = 3; f.Parent = background
    local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(1,0); uc.Parent = f
    flashes[i] = f
end
local noiseDots = {}
local noiseContainer = Instance.new("Frame")
noiseContainer.Size = UDim2.new(1,0,1,0); noiseContainer.BackgroundTransparency = 1
noiseContainer.ZIndex = 3; noiseContainer.Parent = background
for i = 1,120 do
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0,1,0,1)
    n.Position = UDim2.new(math.random(),0,math.random(),0)
    n.BackgroundColor3 = Color3.fromRGB(255,255,255)
    n.BackgroundTransparency = math.random(80,98)/100
    n.BorderSizePixel = 0; n.ZIndex = 3; n.Parent = noiseContainer
    noiseDots[i] = n
end
local rings = {}
for i = 1, 3 do
    local ring = Instance.new("Frame")
    ring.Size = UDim2.new(0,0,0,0)
    ring.Position = UDim2.new(0.5,0,0.5,0)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    ring.ZIndex = 2
    ring.Parent = background
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = ring
    local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(1,0); uc.Parent = ring
    rings[i] = {frame=ring, stroke=stroke}
end
local glowBox = Instance.new("Frame")
glowBox.Size = UDim2.new(0,560,0,380)
glowBox.Position = UDim2.new(0.5,-280,0.5,-190)
glowBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
glowBox.BackgroundTransparency = 0.95
glowBox.BorderSizePixel = 0; glowBox.ZIndex = 5; glowBox.Parent = background
local gc = Instance.new("UICorner"); gc.CornerRadius = UDim.new(0,20); gc.Parent = glowBox
local gStroke = Instance.new("UIStroke")
gStroke.Color = Color3.fromRGB(255,255,255); gStroke.Transparency = 0.65
gStroke.Thickness = 1.5; gStroke.Parent = glowBox
local container = Instance.new("Frame")
container.Size = UDim2.new(0,520,0,340)
container.Position = UDim2.new(0.5,-260,0.5,-170)
container.BackgroundTransparency = 1; container.ZIndex = 6; container.Parent = background
local corners = {}
local cDefs = {
    {UDim2.new(0,-10,0,-10),UDim2.new(0,28,0,2)},{UDim2.new(0,-10,0,-10),UDim2.new(0,2,0,28)},
    {UDim2.new(1,-18,0,-10),UDim2.new(0,28,0,2)},{UDim2.new(1,-2,0,-10),UDim2.new(0,2,0,28)},
    {UDim2.new(0,-10,1,-2),UDim2.new(0,28,0,2)},{UDim2.new(0,-10,1,-18),UDim2.new(0,2,0,28)},
    {UDim2.new(1,-18,1,-2),UDim2.new(0,28,0,2)},{UDim2.new(1,-2,1,-18),UDim2.new(0,2,0,28)},
}
for i,d in ipairs(cDefs) do
    local c = Instance.new("Frame")
    c.Position=d[1]; c.Size=d[2]
    c.BackgroundColor3=Color3.fromRGB(255,255,255)
    c.BackgroundTransparency=0.2; c.BorderSizePixel=0; c.ZIndex=7; c.Parent=container
    corners[i] = c
end
local nothingLabel = Instance.new("TextLabel")
nothingLabel.Size = UDim2.new(1,0,0,36); nothingLabel.Position = UDim2.new(0,0,0,10)
nothingLabel.BackgroundTransparency = 1; nothingLabel.Text = "NOTHING _X"
nothingLabel.TextColor3 = Color3.fromRGB(155,155,155); nothingLabel.TextSize = 15
nothingLabel.Font = Enum.Font.GothamBold; nothingLabel.TextXAlignment = Enum.TextXAlignment.Center
nothingLabel.TextTransparency = 1; nothingLabel.ZIndex = 7; nothingLabel.Parent = container
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,0,0,95); titleLabel.Position = UDim2.new(0,0,0,58)
titleLabel.BackgroundTransparency = 1; titleLabel.Text = "Verify"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255); titleLabel.TextSize = 76
titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextTransparency = 1; titleLabel.ZIndex = 7; titleLabel.Parent = container
local playerInfoLabel = Instance.new("TextLabel")
playerInfoLabel.Size = UDim2.new(1,0,0,24); playerInfoLabel.Position = UDim2.new(0,0,0,155)
playerInfoLabel.BackgroundTransparency = 1
playerInfoLabel.Text = "@"..userName..(displayName ~= userName and ("  ("..displayName..")") or "")
playerInfoLabel.TextColor3 = Color3.fromRGB(120,120,120); playerInfoLabel.TextSize = 13
playerInfoLabel.Font = Enum.Font.Gotham; playerInfoLabel.TextXAlignment = Enum.TextXAlignment.Center
playerInfoLabel.TextTransparency = 1; playerInfoLabel.ZIndex = 7; playerInfoLabel.Parent = container
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0,0,0,2); divider.Position = UDim2.new(0.5,0,0,185)
divider.BackgroundColor3 = Color3.fromRGB(255,255,255); divider.BorderSizePixel = 0
divider.ZIndex = 7; divider.Parent = container
local divDots = {}
for i = 1,5 do
    local dd = Instance.new("Frame")
    dd.Size = UDim2.new(0,4,0,4); dd.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dd.BackgroundTransparency = 1; dd.BorderSizePixel = 0; dd.ZIndex = 7; dd.Parent = container
    local ddc = Instance.new("UICorner"); ddc.CornerRadius = UDim.new(1,0); ddc.Parent = dd
    divDots[i] = dd
end
local pressLabel = Instance.new("TextLabel")
pressLabel.Size = UDim2.new(1,0,0,40); pressLabel.Position = UDim2.new(0,0,0,210)
pressLabel.BackgroundTransparency = 1; pressLabel.Text = '> Press "R" <'
pressLabel.TextColor3 = Color3.fromRGB(200,200,200); pressLabel.TextSize = 26
pressLabel.Font = Enum.Font.Gotham; pressLabel.TextXAlignment = Enum.TextXAlignment.Center
pressLabel.TextTransparency = 1; pressLabel.ZIndex = 7; pressLabel.Parent = container
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(0,0,0,1); statusBar.Position = UDim2.new(0,0,0,275)
statusBar.BackgroundColor3 = Color3.fromRGB(200,200,200)
statusBar.BackgroundTransparency = 0.6; statusBar.BorderSizePixel = 0
statusBar.ZIndex = 7; statusBar.Parent = container
local tokenLabel = Instance.new("TextLabel")
tokenLabel.Size = UDim2.new(1,0,0,18); tokenLabel.Position = UDim2.new(0,0,0,290)
tokenLabel.BackgroundTransparency = 1
tokenLabel.Text = "TOKEN: "..SESSION_TOKEN:sub(1,8).."••••••••"
tokenLabel.TextColor3 = Color3.fromRGB(60,60,60); tokenLabel.TextSize = 10
tokenLabel.Font = Enum.Font.Code; tokenLabel.TextXAlignment = Enum.TextXAlignment.Center
tokenLabel.TextTransparency = 0.4; tokenLabel.ZIndex = 7; tokenLabel.Parent = container
task.delay(0.15, function()
    TweenService:Create(nothingLabel,TweenInfo.new(1.0,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {TextTransparency=0.25}):Play()
end)
task.delay(0.45, function()
    titleLabel.Position = UDim2.new(0,0,0,85)
    TweenService:Create(titleLabel,TweenInfo.new(1.1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {TextTransparency=0,Position=UDim2.new(0,0,0,58)}):Play()
end)
task.delay(0.75, function()
    TweenService:Create(playerInfoLabel,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {TextTransparency=0}):Play()
end)
task.delay(1.1, function()
    TweenService:Create(divider,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,360,0,2),Position=UDim2.new(0.5,-180,0,185)}):Play()
    task.delay(0.85, function()
        local positions = {-160,-80,0,80,160}
        for i,dd in ipairs(divDots) do
            dd.Position = UDim2.new(0.5,positions[i]-2,0,182)
            TweenService:Create(dd,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                {BackgroundTransparency=0.2}):Play()
        end
    end)
end)
task.delay(1.6, function()
    TweenService:Create(pressLabel,TweenInfo.new(0.9,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {TextTransparency=0}):Play()
end)
task.delay(1.8, function()
    TweenService:Create(statusBar,TweenInfo.new(1.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {Size=UDim2.new(1,0,0,1)}):Play()
end)
task.spawn(function()
    while screenGui.Parent do
        TweenService:Create(glowBox,TweenInfo.new(2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {BackgroundTransparency=0.86}):Play()
        task.wait(2.2)
        TweenService:Create(glowBox,TweenInfo.new(2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {BackgroundTransparency=0.97}):Play()
        task.wait(2.2)
    end
end)
task.spawn(function()
    while screenGui.Parent do
        TweenService:Create(gStroke,TweenInfo.new(2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {Transparency=0.3}):Play()
        task.wait(2.2)
        TweenService:Create(gStroke,TweenInfo.new(2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {Transparency=0.85}):Play()
        task.wait(2.2)
    end
end)
task.spawn(function()
    while screenGui.Parent do
        for _,c in ipairs(corners) do
            TweenService:Create(c,TweenInfo.new(1.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                {BackgroundTransparency=0.8}):Play()
        end
        task.wait(1.6)
        for _,c in ipairs(corners) do
            TweenService:Create(c,TweenInfo.new(1.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                {BackgroundTransparency=0.05}):Play()
        end
        task.wait(1.6)
    end
end)
local scanSpeeds = {3.5,5.5,7}; local scanDelays = {0,2,4}
for i,s in ipairs(scans) do
    task.spawn(function()
        task.wait(scanDelays[i])
        while screenGui.Parent do
            s.Position = UDim2.new(0,0,0,-4)
            TweenService:Create(s,TweenInfo.new(scanSpeeds[i],Enum.EasingStyle.Linear),
                {Position=UDim2.new(0,0,1,4)}):Play()
            task.wait(scanSpeeds[i]+1)
        end
    end)
end
task.spawn(function()
    while screenGui.Parent do
        task.wait(3+math.random()*4)
        local f = flashes[math.random(1,4)]
        TweenService:Create(f,TweenInfo.new(0.1,Enum.EasingStyle.Linear),{BackgroundTransparency=0.65}):Play()
        task.wait(0.12)
        TweenService:Create(f,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
            {BackgroundTransparency=1}):Play()
    end
end)
task.spawn(function()
    task.wait(2.2)
    while screenGui.Parent do
        task.wait(1.8+math.random()*3)
        for i = 1,math.random(2,6) do
            pressLabel.TextTransparency = 0.75
            task.wait(0.055); pressLabel.TextTransparency = 0; task.wait(0.055)
        end
    end
end)
task.spawn(function()
    while screenGui.Parent do
        TweenService:Create(nothingLabel,TweenInfo.new(3.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {Position=UDim2.new(0,0,0,16)}):Play()
        task.wait(3.5)
        TweenService:Create(nothingLabel,TweenInfo.new(3.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {Position=UDim2.new(0,0,0,10)}):Play()
        task.wait(3.5)
    end
end)
task.spawn(function()
    task.wait(2)
    while screenGui.Parent do
        TweenService:Create(divider,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {Size=UDim2.new(0,400,0,2)}):Play()
        task.wait(2)
        TweenService:Create(divider,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
            {Size=UDim2.new(0,300,0,2)}):Play()
        task.wait(2)
    end
end)
task.spawn(function()
    task.wait(2.5)
    while screenGui.Parent do
        for i,dd in ipairs(divDots) do
            task.delay((i-1)*0.1, function()
                TweenService:Create(dd,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                    {BackgroundTransparency=0.7}):Play()
                task.wait(0.5)
                TweenService:Create(dd,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                    {BackgroundTransparency=0.1}):Play()
            end)
        end
        task.wait(2)
    end
end)
local ringIdx = 1
task.spawn(function()
    while screenGui.Parent do
        task.wait(2.5)
        local r = rings[ringIdx]
        ringIdx = ringIdx % 3 + 1
        r.frame.Size = UDim2.new(0,0,0,0)
        r.frame.Position = UDim2.new(0.5,0,0.5,0)
        r.stroke.Transparency = 0.6
        TweenService:Create(r.frame,TweenInfo.new(2.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
            {Size=UDim2.new(0,900,0,900),Position=UDim2.new(0.5,-450,0.5,-450)}):Play()
        TweenService:Create(r.stroke,TweenInfo.new(2.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
            {Transparency=1}):Play()
    end
end)
local gradAngle = 45
task.spawn(function()
    while screenGui.Parent do
        gradAngle = gradAngle+0.12
        if gradAngle >= 360 then gradAngle = 0 end
        bgGradient.Rotation = gradAngle
        task.wait(0.04)
    end
end)
task.spawn(function()
    while screenGui.Parent do
        task.wait(0.08)
        for _,n in ipairs(noiseDots) do
            if math.random() > 0.7 then
                n.Position = UDim2.new(math.random(),0,math.random(),0)
                n.BackgroundTransparency = math.random(80,98)/100
            end
        end
    end
end)
RunService.Heartbeat:Connect(function(dt)
    for _,p in ipairs(particles) do
        p.px=p.px+p.sx; p.py=p.py+p.sy
        if p.px>1 then p.px=0 elseif p.px<0 then p.px=1 end
        if p.py>1 then p.py=0 elseif p.py<0 then p.py=1 end
        p.pt=p.pt+dt*p.ps*0.7
        local pulse=(math.sin(p.pt)+1)/2
        p.frame.BackgroundTransparency=math.clamp(p.base+pulse*0.18,0,0.99)
        p.frame.Position=UDim2.new(p.px,0,p.py,0)
    end
end)
local function Execute_YH()
        task.defer(function() loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-TSB-new"))()end)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/NOTHING-X-X-X-NAHH/refs/heads/X/NAH.lua"))()
end
local function restoreAll()
    pcall(function() cursorLockConn:Disconnect() end)
    pcall(function() cursorLockConn2:Disconnect() end)
    pcall(function() cursorLockConn3:Disconnect() end)
    pcall(function() cursorLockConn4:Disconnect() end)
    pcall(function() cameraLockConn:Disconnect() end)
    pcall(function() menuBlockConn:Disconnect() end)
    if devConsoleConn then pcall(function() devConsoleConn:Disconnect() end) end
    pcall(function()
        local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
        if devConsole then devConsole.Enabled = true end
    end)
    for _,c in ipairs(addedConns) do c:Disconnect() end
    pcall(function() sinkConn:Disconnect() end)
    pcall(function() sinkConn2:Disconnect() end)
    pcall(function() sinkConn3:Disconnect() end)
    for _, actionName in ipairs(blockedKeysList) do
        pcall(function() ContextActionService:UnbindAction(actionName) end)
    end
    for _, actionName in ipairs(blockedMouseList) do
        pcall(function() ContextActionService:UnbindAction(actionName) end)
    end
    UserInputService.MouseIconEnabled = true
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    camera.CameraType = savedCameraType
    if savedCameraSubject then camera.CameraSubject = savedCameraSubject end
    pcall(function() StarterGui:SetCore("TopbarEnabled", true) end)
    for _,entry in ipairs(savedStates) do
        pcall(function()
            if entry.gui and entry.gui.Parent then
                entry.gui.Enabled = entry.enabled
            end
        end)
    end
    writeFile(SESSION_TOKEN)
    Execute_YH()
    screenGui:Destroy()
    tpBack()
end
local pressed = false
UserInputService.InputBegan:Connect(function(input)
    if pressed then return end
    if input.KeyCode ~= Enum.KeyCode.R then return end
    pressed = true
    local RED = Color3.fromRGB(215,30,30)
    local fast = TweenInfo.new(0.1,Enum.EasingStyle.Linear)
    TweenService:Create(titleLabel,fast,{TextColor3=RED}):Play()
    TweenService:Create(pressLabel,fast,{TextColor3=RED}):Play()
    TweenService:Create(playerInfoLabel,fast,{TextColor3=RED}):Play()
    TweenService:Create(nothingLabel,fast,{TextColor3=Color3.fromRGB(190,20,20)}):Play()
    TweenService:Create(divider,fast,{BackgroundColor3=RED}):Play()
    TweenService:Create(glowBox,fast,{BackgroundColor3=RED}):Play()
    TweenService:Create(gStroke,fast,{Color=RED}):Play()
    TweenService:Create(statusBar,fast,{BackgroundColor3=RED}):Play()
    for _,c in ipairs(corners) do TweenService:Create(c,fast,{BackgroundColor3=RED}):Play() end
    for _,dd in ipairs(divDots) do TweenService:Create(dd,fast,{BackgroundColor3=RED}):Play() end
    for _,p in ipairs(particles) do
        TweenService:Create(p.frame,TweenInfo.new(0.2,Enum.EasingStyle.Linear),{BackgroundColor3=RED}):Play()
    end
    for _,l in ipairs(hLines) do TweenService:Create(l,fast,{BackgroundColor3=RED}):Play() end
    for _,l in ipairs(vLinesArr) do TweenService:Create(l,fast,{BackgroundColor3=RED}):Play() end
    for _,s in ipairs(scans) do TweenService:Create(s,fast,{BackgroundColor3=RED}):Play() end
    for _,f in ipairs(flashes) do f.BackgroundColor3 = RED end
    for _,r in ipairs(rings) do r.stroke.Color = RED end
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 2, 2)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 5, 5)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 2, 2)),
    })
    TweenService:Create(background, fast, {BackgroundColor3 = Color3.fromRGB(12, 4, 4)}):Play()
    task.spawn(function()
        for i = 1,20 do
            container.Position = UDim2.new(0.5,-260+math.random(-9,9),0.5,-170+math.random(-6,6))
            glowBox.Position = UDim2.new(0.5,-280+math.random(-5,5),0.5,-190+math.random(-4,4))
            task.wait(0.03)
        end
        container.Position = UDim2.new(0.5,-260,0.5,-170)
        glowBox.Position = UDim2.new(0.5,-280,0.5,-190)
    end)
    task.spawn(function()
        TweenService:Create(titleLabel,TweenInfo.new(0.07,Enum.EasingStyle.Linear),{TextSize=88}):Play()
        task.wait(0.1)
        TweenService:Create(titleLabel,TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
            {TextSize=76}):Play()
    end)
    task.delay(2.2, restoreAll)
end)
