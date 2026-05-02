local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local SAVE_FILE = "NOTHING_X_01-load.json"
local originalCFrame = nil 
local Colors = {
    Background = Color3.fromRGB(15, 15, 15), 
    Accent = Color3.fromRGB(255, 0, 0),    
    Glow = Color3.fromRGB(255, 0, 0),
    Button = Color3.fromRGB(30, 30, 30),  
    Text = Color3.fromRGB(0, 0, 0)
}
local function executeChoice(choice)
    if choice == "TSB NEW" then
		task.defer(function() loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-TSB-new"))()end)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/NOTHING-X-X-X-NAHH/refs/heads/X/NAH.lua"))()
    elseif choice == "TSB OLD" then
		task.defer(function() loadstring(game:HttpGet("https://github.com/OverlordCryx/X_/raw/refs/heads/main/DC/API-TSB-old"))()end)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OverlordCryx/X_/refs/heads/main/TSB/XOLD"))()
    end
end
local function saveConfig(choice, autoLoad)
    local data = { choice = choice, autoLoad = autoLoad }
    if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(data)) end
end
local function loadConfig()
    if isfile and isfile(SAVE_FILE) then
        local content = readfile(SAVE_FILE)
        local success, data = pcall(function() return HttpService:JSONDecode(content) end)
        if success then return data end
    end
    return nil
end
local function setCharacterFrozen(state)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        if state then
            if not originalCFrame then originalCFrame = hrp.CFrame end
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 300, 0)
            task.wait(0.1)
            hrp.Anchored = true
        else
            hrp.Anchored = false
            if originalCFrame then hrp.CFrame = originalCFrame end
            originalCFrame = nil 
        end
    end
end
local config = loadConfig()
if config and config.autoLoad then
    print("NOTHING X: Auto-loading " .. config.choice)
    executeChoice(config.choice)
    return 
end
setCharacterFrozen(true)
local charAddedConn
charAddedConn = player.CharacterAdded:Connect(function()
    task.wait(0.5)
    setCharacterFrozen(true)
end)
if CoreGui:FindFirstChild("TSB_SelectionUI") then
    CoreGui.TSB_SelectionUI:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TSB_SelectionUI"; ScreenGui.Parent = CoreGui; ScreenGui.IgnoreGuiInset = true 
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); Overlay.BackgroundTransparency = 1; Overlay.Active = true; Overlay.Parent = ScreenGui
local GlowFrame = Instance.new("Frame")
GlowFrame.Name = "Glow"; GlowFrame.Size = UDim2.new(0, 430, 0, 270); GlowFrame.Position = UDim2.new(0.5, 0, 0.5, 0); GlowFrame.AnchorPoint = Vector2.new(0.5, 0.5); GlowFrame.BackgroundColor3 = Colors.Accent; GlowFrame.BackgroundTransparency = 1; GlowFrame.Parent = Overlay
Instance.new("UICorner", GlowFrame).CornerRadius = UDim.new(0, 20)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"; MainFrame.Size = UDim2.new(0, 420, 0, 260); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.BackgroundColor3 = Colors.Background; MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true; MainFrame.BackgroundTransparency = 1; MainFrame.Parent = Overlay
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local UIStroke = Instance.new("UIStroke", MainFrame); UIStroke.Color = Colors.Accent; UIStroke.Thickness = 3.5; UIStroke.Transparency = 1
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 80); Title.BackgroundTransparency = 1; Title.Text = "NOTHING X"; Title.TextColor3 = Colors.Accent; Title.TextTransparency = 1; Title.TextSize = 38; Title.Font = Enum.Font.GothamBold; Title.Parent = MainFrame
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -40, 0, 80); ButtonContainer.Position = UDim2.new(0.5, 0, 0.45, 0); ButtonContainer.AnchorPoint = Vector2.new(0.5, 0.5); ButtonContainer.BackgroundTransparency = 1; ButtonContainer.Parent = MainFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal; UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center; UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder; UIListLayout.Padding = UDim.new(0, 30); UIListLayout.Parent = ButtonContainer
local function createButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 55); btn.BackgroundColor3 = Colors.Button; btn.Text = text; btn.TextColor3 = Colors.Text; btn.TextTransparency = 1; btn.Font = Enum.Font.GothamBold; btn.TextSize = 20; btn.AutoButtonColor = false; btn.LayoutOrder = order; btn.Parent = ButtonContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local s = Instance.new("UIStroke", btn); s.Color = Colors.Accent; s.Thickness = 2; s.Transparency = 1
    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 0, 0), Size = UDim2.new(0, 150, 0, 60)}):Play() 
        TweenService:Create(s, TweenInfo.new(0.3), {Thickness = 4}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Colors.Button, Size = UDim2.new(0, 140, 0, 55)}):Play() 
        TweenService:Create(s, TweenInfo.new(0.3), {Thickness = 2}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        local isToggled = MainFrame.RememberMe.ToggleBox.Indicator.BackgroundTransparency == 0
        if isToggled then saveConfig(text, true) end
        if charAddedConn then charAddedConn:Disconnect() end
        setCharacterFrozen(false)
        executeChoice(text) 
        local fadeOut = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        TweenService:Create(GlowFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        fadeOut:Play(); fadeOut.Completed:Connect(function() ScreenGui:Destroy() end)
    end)
    return btn, s
end
local TSBNew, NewStroke = createButton("TSB NEW", 1)
local TSBOld, OldStroke = createButton("TSB OLD", 3)
local ORLabel = Instance.new("TextLabel")
ORLabel.Size = UDim2.new(0, 40, 0, 55); ORLabel.BackgroundTransparency = 1; ORLabel.Text = "OR"; ORLabel.TextColor3 = Colors.Accent; ORLabel.TextTransparency = 1; ORLabel.Font = Enum.Font.GothamBold; ORLabel.TextSize = 20; ORLabel.LayoutOrder = 2; ORLabel.Parent = ButtonContainer
local RememberMe = Instance.new("Frame")
RememberMe.Name = "RememberMe"; RememberMe.Size = UDim2.new(0, 240, 0, 40); RememberMe.Position = UDim2.new(0.5, 0, 0.82, 0); RememberMe.AnchorPoint = Vector2.new(0.5, 0.5); RememberMe.BackgroundTransparency = 1; RememberMe.Parent = MainFrame
local ToggleBox = Instance.new("TextButton")
ToggleBox.Name = "ToggleBox"; ToggleBox.Size = UDim2.new(0, 26, 0, 26); ToggleBox.Position = UDim2.new(0, 0, 0.5, 0); ToggleBox.AnchorPoint = Vector2.new(0, 0.5); ToggleBox.BackgroundColor3 = Colors.Button; ToggleBox.Text = ""; ToggleBox.AutoButtonColor = false; ToggleBox.Parent = RememberMe
local ToggleIndicator = Instance.new("Frame")
ToggleIndicator.Name = "Indicator"; ToggleIndicator.Size = UDim2.new(0, 16, 0, 16); ToggleIndicator.Position = UDim2.new(0.5, 0, 0.5, 0); ToggleIndicator.AnchorPoint = Vector2.new(0.5, 0.5); ToggleIndicator.BackgroundColor3 = Colors.Accent; ToggleIndicator.BackgroundTransparency = 1; ToggleIndicator.Parent = ToggleBox
Instance.new("UICorner", ToggleIndicator).CornerRadius = UDim.new(0, 5); Instance.new("UICorner", ToggleBox).CornerRadius = UDim.new(0, 7)
local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(1, -40, 1, 0); ToggleLabel.Position = UDim2.new(0, 40, 0, 0); ToggleLabel.BackgroundTransparency = 1; ToggleLabel.Text = "Remember choice"; ToggleLabel.TextColor3 = Color3.fromRGB(180, 180, 180); ToggleLabel.TextTransparency = 1; ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left; ToggleLabel.Font = Enum.Font.GothamBold; ToggleLabel.TextSize = 18; ToggleLabel.Parent = RememberMe
ToggleBox.MouseButton1Click:Connect(function()
    local active = ToggleIndicator.BackgroundTransparency == 0
    TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Back), {BackgroundTransparency = active and 1 or 0, Size = active and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 16, 0, 16)}):Play()
end)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.1)
TweenService:Create(Overlay, TweenInfo.new(0.8), {BackgroundTransparency = 0.5}):Play()
TweenService:Create(MainFrame, TweenInfo.new(1, Enum.EasingStyle.Back), {Size = UDim2.new(0, 420, 0, 260), BackgroundTransparency = 0}):Play()
task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(GlowFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.6, Size = UDim2.new(0, 460, 0, 300)}):Play()
        task.wait(2)
        TweenService:Create(GlowFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 1, Size = UDim2.new(0, 420, 0, 260)}):Play()
        task.wait(2)
    end
end)
task.wait(0.5)
TweenService:Create(UIStroke, TweenInfo.new(1), {Transparency = 0}):Play()
TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(0.2)
TweenService:Create(TSBNew, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
TweenService:Create(NewStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
task.wait(0.1)
TweenService:Create(ORLabel, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
task.wait(0.1)
TweenService:Create(TSBOld, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
TweenService:Create(OldStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
task.wait(0.2)
TweenService:Create(ToggleLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
ContextActionService:BindAction("TSB_FreezeKeys", function() return Enum.ContextActionResult.Sink end, false, Enum.KeyCode.Tab, Enum.KeyCode.Escape, Enum.KeyCode.L, Enum.KeyCode.R, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.Slash, Enum.KeyCode.LeftShift, Enum.KeyCode.F, Enum.KeyCode.E, Enum.KeyCode.Q)
ScreenGui.Destroying:Connect(function() ContextActionService:UnbindAction("TSB_FreezeKeys") end)
