--!strict
-- Cmda Client UI - Enhanced Command Console
-- Press ` to open / close

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Cmda = require(script.Parent.Parent)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CmdaConsole"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (Command Bar + Output)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.65, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.175, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Shadow effect
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1
stroke.Transparency = 0.5
stroke.Parent = mainFrame

-- Output Scrolling Frame (history)
local outputFrame = Instance.new("ScrollingFrame")
outputFrame.Name = "Output"
outputFrame.Size = UDim2.new(1, -16, 0.75, -16)
outputFrame.Position = UDim2.new(0, 8, 0, 8)
outputFrame.BackgroundTransparency = 1
outputFrame.BorderSizePixel = 0
outputFrame.ScrollBarThickness = 6
outputFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
outputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
outputFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
outputFrame.Parent = mainFrame

local outputLayout = Instance.new("UIListLayout")
outputLayout.Padding = UDim.new(0, 4)
outputLayout.SortOrder = Enum.SortOrder.LayoutOrder
outputLayout.Parent = outputFrame

-- Command Input Box
local inputBox = Instance.new("TextBox")
inputBox.Name = "Input"
inputBox.Size = UDim2.new(1, -16, 0, 40)
inputBox.Position = UDim2.new(0, 8, 1, -48)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.PlaceholderText = "Enter command... (e.g. kill me)"
inputBox.Text = ""
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.TextScaled = true
inputBox.ClearTextOnFocus = false
inputBox.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- Add some padding to input
local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 12)
inputPadding.Parent = inputBox

-- Function to add message to output
local function addOutput(text: string, color: Color3?)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.Parent = outputFrame

    -- Auto scroll to bottom
    outputFrame.CanvasPosition = Vector2.new(0, outputFrame.AbsoluteCanvasSize.Y)
end

-- Execute command
local function executeCommand()
    local inputText = inputBox.Text
    if inputText == "" then return end

    addOutput(`> {inputText}`, Color3.fromRGB(100, 200, 255))

    local result = Cmda:ExecuteCommand(player, inputText)

    if result then
        addOutput(result, Color3.fromRGB(180, 255, 180))
    end

    inputBox.Text = ""
end

-- Input events
inputBox.FocusLost:Connect(function(enterPressed: boolean)
    if enterPressed then
        executeCommand()
        inputBox:CaptureFocus() -- stay focused after enter
    end
end)

-- Toggle console with ` key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F2 then
        mainFrame.Visible = not mainFrame.Visible

        if mainFrame.Visible then
            inputBox:CaptureFocus()
            addOutput("Cmda Console opened", Color3.fromRGB(150, 150, 255))
        end
    end

    if input.KeyCode == Enum.KeyCode.F2 and mainFrame.Visible then
        mainFrame.Visible = false
    end
end)

-- Initial message
task.delay(1, function()
    if not mainFrame.Visible then
        addOutput("Welcome to Cmda! Press ` to open the console.", Color3.fromRGB(140, 140, 255))
    end
end)

print("[Cmda] Enhanced Client UI loaded - Press ` to open console")
