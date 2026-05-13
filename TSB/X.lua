local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local REPLIT_URL = "https://415e08a1-1326-4378-b5f8-1523749bb8dd-00-q5eq0jyxczu2.kirk.replit.dev/api"
local MEMBER_LIST = {}
local DISCORD_LINK = "https://discord.gg/Q4r4j6cR2J"
local SAVE_FILE = "NOTHING_X/DC/Discord_Verfy_By_NOTHING_X.file"
if CoreGui:FindFirstChild("DiscordVerfy") then return end
local function saveVerified(id)
    pcall(function()
        writefile(SAVE_FILE, "~" .. id .. "~ //  NOTHING _X  //")
    end)
end
local function getSavedId()
    local id = nil
    pcall(function()
        if isfile(SAVE_FILE) then
            local raw = readfile(SAVE_FILE)
            id = raw:match("~(%d+)~")
        end
    end)
    return id
end
local function checkSave()
    local savedId = getSavedId()
    if savedId and table.find(MEMBER_LIST, savedId) then
        return true
    end
    return false
end
local initialCheckDone = false
local blockedKeys = {
    Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
    Enum.KeyCode.Q, Enum.KeyCode.E, Enum.KeyCode.R, Enum.KeyCode.T,
    Enum.KeyCode.Y, Enum.KeyCode.U, Enum.KeyCode.I, Enum.KeyCode.O,
    Enum.KeyCode.P, Enum.KeyCode.F, Enum.KeyCode.G, Enum.KeyCode.H,
    Enum.KeyCode.J, Enum.KeyCode.K, Enum.KeyCode.L, Enum.KeyCode.Z,
    Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.B,
    Enum.KeyCode.N, Enum.KeyCode.M,
    Enum.KeyCode.Space, Enum.KeyCode.Escape,
    Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift,
    Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl,
    Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt,
    Enum.KeyCode.Tab, Enum.KeyCode.Return,
    Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right,
    Enum.KeyCode.F1, Enum.KeyCode.F2, Enum.KeyCode.F3, Enum.KeyCode.F4,
    Enum.KeyCode.F5, Enum.KeyCode.F6, Enum.KeyCode.F7, Enum.KeyCode.F8,
    Enum.KeyCode.F9, Enum.KeyCode.F10, Enum.KeyCode.F11, Enum.KeyCode.F12,
}
local function sinkAction(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
end
local keyBlockConnection = nil
local savedPosition = nil
local verified = false
local function saveAndTeleport()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            savedPosition = hrp.CFrame
            local pos = hrp.Position
            hrp.CFrame = CFrame.new(pos.X, 700, pos.Z)
            hrp.Anchored = true
        end
    end)
end
local function refreshAndTeleport()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if not hrp.Anchored then
                savedPosition = hrp.CFrame
            end
            local pos = hrp.Position
            hrp.CFrame = CFrame.new(pos.X, 700, pos.Z)
            hrp.Anchored = true
        end
    end)
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DiscordVerfy"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 2147483647
ScreenGui.Enabled = false
ScreenGui.Parent = CoreGui
local DarkBg = Instance.new("Frame")
DarkBg.Size = UDim2.new(1, 0, 1, 0)
DarkBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkBg.BackgroundTransparency = 0.3
DarkBg.BorderSizePixel = 0
DarkBg.ZIndex = 0
DarkBg.Parent = ScreenGui
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 175)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -87)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 18)
StatusLabel.Position = UDim2.new(0, 0, 0, 122)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.ZIndex = 11
StatusLabel.Parent = MainFrame
local lastResult = ""
local function startLock()
    saveAndTeleport()
    ScreenGui.Enabled = true
    ContextActionService:BindActionAtPriority(
        "BlockAllKeys", sinkAction, false, 3000,
        table.unpack(blockedKeys)
    )
    keyBlockConnection = UserInputService.InputBegan:Connect(function() end)
    task.spawn(function()
        while task.wait() do
            if verified then break end
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    if not hrp.Anchored then
                        savedPosition = hrp.CFrame
                        hrp.Anchored = true
                    end
                    if hrp.Position.Y < 690 then
                        local pos = hrp.Position
                        hrp.CFrame = CFrame.new(pos.X, 700, pos.Z)
                    end
                end
            end)
        end
    end)
end
local function slideDown(callback)
    local ss = ScreenGui.AbsoluteSize
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0, MainFrame.AbsolutePosition.X, 0, ss.Y + 20)
    }):Play()
    TweenService:Create(DarkBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    if callback then callback() end
end

local function handleVerifySuccess(isAuto)
    if verified then return end
    verified = true
    if isAuto then
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 120)
        StatusLabel.Text = "Auto-Verified!"
        task.wait(0.5)
    end
    ContextActionService:UnbindAction("BlockAllKeys")
    if keyBlockConnection then keyBlockConnection:Disconnect() end
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if savedPosition then
                hrp.CFrame = savedPosition
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            hrp.Anchored = false
        end
    end)
    slideDown(function()
        ScreenGui:Destroy()
        task.defer(function() loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-TSB-new"))()end)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/NOTHING-X-X-X-NAHH/refs/heads/X/NAH.lua"))()
    end)
end
task.spawn(function()
    while true do
        local success, result = pcall(function()
            return game:HttpGet(REPLIT_URL .. "/members")
        end)
        if not success then
            if not verified then
                StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
                StatusLabel.Text = "API Error - Check URL"
                if not initialCheckDone then
                    initialCheckDone = true
                    startLock()
                end
            end
        elseif result ~= lastResult then
            lastResult = result
            local decodeSuccess, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(result)
            end)
            if decodeSuccess and type(decoded) == "table" then
                MEMBER_LIST = decoded
                if not verified and checkSave() then
                    handleVerifySuccess(true)
                end
                if not initialCheckDone then
                    initialCheckDone = true
                    if not verified then
                        startLock()
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)
task.spawn(function()
    if not getSavedId() then
        task.wait(0.5) 
        if not initialCheckDone and not verified then
            initialCheckDone = true
            startLock()
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    if verified or not initialCheckDone then return end
    task.wait(0.1)
    refreshAndTeleport()
end)
local ClickBlocker = Instance.new("TextButton")
ClickBlocker.Size = UDim2.new(1, 0, 1, 0)
ClickBlocker.BackgroundTransparency = 1
ClickBlocker.BorderSizePixel = 0
ClickBlocker.Text = ""
ClickBlocker.ZIndex = 1
ClickBlocker.Active = true
ClickBlocker.AutoButtonColor = false
ClickBlocker.Parent = ScreenGui
local GlowBorder = Instance.new("UIStroke")
GlowBorder.Color = Color3.fromRGB(200, 200, 220)
GlowBorder.Thickness = 1.5
GlowBorder.Transparency = 0.5
GlowBorder.Parent = MainFrame
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 11
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 20)
local TopBarLine = Instance.new("Frame")
TopBarLine.Size = UDim2.new(1, 0, 0, 1)
TopBarLine.Position = UDim2.new(0, 0, 1, -1)
TopBarLine.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
TopBarLine.BackgroundTransparency = 0.6
TopBarLine.BorderSizePixel = 0
TopBarLine.ZIndex = 12
TopBarLine.Parent = TopBar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NOTHING_X"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 13
TitleLabel.Parent = TopBar
local DiscordBtn = Instance.new("ImageButton")
DiscordBtn.Size = UDim2.new(0, 32, 0, 32)
DiscordBtn.Position = UDim2.new(1, -42, 0.5, -16)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.BackgroundTransparency = 0.3
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Image = "rbxassetid://16584754883"
DiscordBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.ScaleType = Enum.ScaleType.Fit
DiscordBtn.ZIndex = 13
DiscordBtn.Parent = TopBar
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)
local Tooltip = Instance.new("TextLabel")
Tooltip.Size = UDim2.new(0, 110, 0, 22)
Tooltip.Position = UDim2.new(1, -114, 1, 4)
Tooltip.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Tooltip.BackgroundTransparency = 0.2
Tooltip.Text = "Copy Discord"
Tooltip.TextColor3 = Color3.fromRGB(200, 200, 220)
Tooltip.TextSize = 10
Tooltip.Font = Enum.Font.Gotham
Tooltip.ZIndex = 20
Tooltip.Visible = false
Tooltip.Parent = TopBar
Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 5)
local CopiedLabel = Instance.new("TextLabel")
CopiedLabel.Size = UDim2.new(0, 80, 0, 22)
CopiedLabel.Position = UDim2.new(1, -84, 1, 4)
CopiedLabel.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
CopiedLabel.BackgroundTransparency = 1
CopiedLabel.Text = "Copied!"
CopiedLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
CopiedLabel.TextTransparency = 1
CopiedLabel.TextSize = 10
CopiedLabel.Font = Enum.Font.GothamBold
CopiedLabel.ZIndex = 20
CopiedLabel.Parent = TopBar
Instance.new("UICorner", CopiedLabel).CornerRadius = UDim.new(0, 5)
DiscordBtn.MouseEnter:Connect(function()
    Tooltip.Visible = true
    TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
end)
DiscordBtn.MouseLeave:Connect(function()
    Tooltip.Visible = false
    TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
end)
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_LINK) end)
    Tooltip.Visible = false
    TweenService:Create(CopiedLabel, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.2, TextTransparency = 0
    }):Play()
    task.delay(1.5, function()
        TweenService:Create(CopiedLabel, TweenInfo.new(0.3), {
            BackgroundTransparency = 1, TextTransparency = 1
        }):Play()
    end)
end)
local UserIDLabel = Instance.new("TextLabel")
UserIDLabel.Size = UDim2.new(0.82, 0, 0, 16)
UserIDLabel.Position = UDim2.new(0.09, 0, 0, 54)
UserIDLabel.BackgroundTransparency = 1
UserIDLabel.Text = "User ID"
UserIDLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
UserIDLabel.TextSize = 10
UserIDLabel.Font = Enum.Font.GothamSemibold
UserIDLabel.TextXAlignment = Enum.TextXAlignment.Left
UserIDLabel.ZIndex = 11
UserIDLabel.Parent = MainFrame
local UserIDBox = Instance.new("TextBox")
UserIDBox.Size = UDim2.new(0.82, 0, 0, 40)
UserIDBox.Position = UDim2.new(0.09, 0, 0, 72)
UserIDBox.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
UserIDBox.PlaceholderText = "Enter your User ID..."
UserIDBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
UserIDBox.Text = ""
UserIDBox.TextColor3 = Color3.fromRGB(220, 220, 240)
UserIDBox.TextSize = 13
UserIDBox.Font = Enum.Font.Gotham
UserIDBox.ClearTextOnFocus = true 
UserIDBox.ZIndex = 11
UserIDBox.Parent = MainFrame
Instance.new("UICorner", UserIDBox).CornerRadius = UDim.new(0, 10)
local BlurEffect = Instance.new("UIStroke")
BlurEffect.Color = Color3.fromRGB(100, 150, 220)
BlurEffect.Transparency = 0.7
BlurEffect.Thickness = 0.8
BlurEffect.Parent = UserIDBox
local UIDBStroke = Instance.new("UIStroke")
UIDBStroke.Color = Color3.fromRGB(100, 100, 120)
UIDBStroke.Transparency = 0.4
UIDBStroke.Thickness = 1.5
UIDBStroke.Parent = UserIDBox
UserIDBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = UserIDBox.Text:gsub("[^0-9%.]", "")
    if #text > 25 then
        text = text:sub(1, 25)
    end
    if UserIDBox.Text ~= text then
        UserIDBox.Text = text
    end
end)
UserIDBox.Focused:Connect(function()
    TweenService:Create(BlurEffect, TweenInfo.new(0.2), {
        Transparency = 0.3, Color = Color3.fromRGB(150, 180, 255)
    }):Play()
    TweenService:Create(UIDBStroke, TweenInfo.new(0.2), {
        Transparency = 0.1, Color = Color3.fromRGB(150, 180, 255)
    }):Play()
end)
UserIDBox.FocusLost:Connect(function()
    TweenService:Create(BlurEffect, TweenInfo.new(0.2), {
        Transparency = 0.7, Color = Color3.fromRGB(100, 150, 220)
    }):Play()
    TweenService:Create(UIDBStroke, TweenInfo.new(0.2), {
        Transparency = 0.4, Color = Color3.fromRGB(100, 100, 120)
    }):Play()
end)
local ProgressBG = Instance.new("Frame")
ProgressBG.Size = UDim2.new(0.82, 0, 0, 3)
ProgressBG.Position = UDim2.new(0.09, 0, 0, 152)
ProgressBG.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ProgressBG.BackgroundTransparency = 0.4
ProgressBG.BorderSizePixel = 0
ProgressBG.ZIndex = 11
ProgressBG.Visible = false
ProgressBG.Parent = MainFrame
Instance.new("UICorner", ProgressBG).CornerRadius = UDim.new(1, 0)
local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(220, 220, 240)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 12
ProgressFill.Parent = ProgressBG
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

local verifying = false
task.spawn(function()
    while task.wait(0.1) do
        if verified or verifying then break end
        local currentText = UserIDBox.Text
        if currentText ~= "" then
            if currentText == "404." or table.find(MEMBER_LIST, currentText) then
                verifying = true
                UserIDBox.TextEditable = false 
                UserIDBox:ReleaseFocus() 
                StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 120)
                StatusLabel.Text = (currentText == "404." and "NOTHING _X" or "Verified")
                ProgressBG.Visible = true
                ProgressFill.Size = UDim2.new(0, 0, 1, 0)
                TweenService:Create(ProgressFill, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 1, 0)
                }):Play()
                task.wait(1.3)
                if currentText ~= "404." then
                    saveVerified(currentText)
                end
                handleVerifySuccess(false)
                break
            elseif #currentText >= 10 then
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                StatusLabel.Text = "Not in Server"
                TweenService:Create(UIDBStroke, TweenInfo.new(0.1), {
                    Color = Color3.fromRGB(255, 80, 80), Transparency = 0
                }):Play()
                task.delay(0.5, function()
                    TweenService:Create(UIDBStroke, TweenInfo.new(0.3), {
                        Transparency = 0.4, Color = Color3.fromRGB(100, 100, 120)
                    }):Play()
                end)
                task.delay(1, function()
                    if StatusLabel.Text == "Not in Server" then
                        TweenService:Create(StatusLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                        task.wait(0.4)
                        StatusLabel.Text = ""
                        StatusLabel.TextTransparency = 0
                    end
                end)
            end
        end
    end
end)
