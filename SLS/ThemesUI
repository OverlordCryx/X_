game:GetService("CoreGui").ScreenGui:GetChildren()[2]:GetChildren()[6].TextButton:Destroy()
game:GetService("CoreGui").ScreenGui:GetChildren()[2]:GetChildren()[6].TextButton:Destroy()
game:GetService("CoreGui").ScreenGui:GetChildren()[2]:GetChildren()[6].TextButton:Destroy()

local CoreGui = game:GetService("CoreGui")
local screenGui = CoreGui:FindFirstChild("ScreenGui")
if not screenGui then return end

local frameGradient = screenGui:GetChildren()[2]:FindFirstChild("Frame")
frameGradient = frameGradient and frameGradient:FindFirstChild("Frame")
local gradient = frameGradient and frameGradient:FindFirstChild("UIGradient")

local scrollingFrame = screenGui:GetChildren()[2]:FindFirstChild("ScrollingFrame")
if not scrollingFrame then
    scrollingFrame = screenGui:GetChildren()[2]:GetChildren()[4] -- fallback
end

-- Funkcja do ustawiania kolorów
local function setColors()
    if gradient then
        gradient.Rotation = 90
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.172, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
    end

    if scrollingFrame then
        for _, obj in ipairs(scrollingFrame:GetDescendants()) do
            if obj:IsA("TextButton") then
                obj.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                obj.ImageColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end

while true do
    game:GetService("CoreGui").ScreenGui:GetChildren()[2].Frame.BackgroundTransparency = 1
game:GetService("CoreGui").ScreenGui:GetChildren()[2].Frame.Background.BackgroundTransparency = 1
game:GetService("CoreGui").ScreenGui:GetChildren()[2].Frame.Frame.BackgroundTransparency = 0.4
game:GetService("CoreGui").ScreenGui:GetChildren()[2]:GetChildren()[6]:GetChildren()[2].BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    game:GetService("CoreGui").ScreenGui:GetChildren()[2]:GetChildren()[4].Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
game:GetService("CoreGui").ScreenGui:GetChildren()[2]:GetChildren()[6].Frame.TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
game:GetService("CoreGui").ScreenGui:GetChildren()[2]:GetChildren()[6].Frame.TextLabel.TextSize = 18
game:GetService("CoreGui").ScreenGui:GetChildren()[2].Frame:GetChildren()[7].UIStroke.Color = Color3.fromRGB(255, 0, 0)
    setColors()
    wait(0.01)
end
