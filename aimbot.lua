local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

-- Configuration
_G.AimbotEnabled = true
_G.TeamCheck = true -- If set to true then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.
_G.Sensitivity = 0.2 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.
_G.CircleSides = 64 -- How many sides the FOV circle would have.
_G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
_G.CircleTransparency = 0.7 -- Transparency of the circle.
_G.CircleRadius = 80 -- The radius of the circle / FOV.
_G.CircleFilled = false -- Determines whether or not the circle is filled.
_G.CircleVisible = true -- Determines whether or not the circle is visible.
_G.CircleThickness = 2 -- The thickness of the circle.

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

-- ============================================================================
-- GUI CREATION
-- ============================================================================

local GUISize = UDim2.new(0, 300, 0, 450)
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "AimbotGui"
MainGui.ResetOnSpawn = false
MainGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = GUISize
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = MainGui
MainFrame.Draggable = true
MainFrame.Active = true

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "AIMBOT SETTINGS"
TitleLabel.Parent = MainFrame

-- Separator
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, 0, 0, 2)
Separator.Position = UDim2.new(0, 0, 0, 30)
Separator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Separator.BorderSizePixel = 0
Separator.Parent = MainFrame

-- Aimbot Enabled Toggle
local AimbotLabel = Instance.new("TextLabel")
AimbotLabel.Size = UDim2.new(0.6, 0, 0, 25)
AimbotLabel.Position = UDim2.new(0, 10, 0, 40)
AimbotLabel.BackgroundTransparency = 1
AimbotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotLabel.TextSize = 14
AimbotLabel.Font = Enum.Font.Gotham
AimbotLabel.Text = "Aimbot Enabled:"
AimbotLabel.TextXAlignment = Enum.TextXAlignment.Left
AimbotLabel.Parent = MainFrame

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(0, 40, 0, 25)
AimbotToggle.Position = UDim2.new(0.65, 0, 0, 40)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.TextSize = 12
AimbotToggle.Font = Enum.Font.Gotham
AimbotToggle.Text = "ON"
AimbotToggle.Parent = MainFrame

AimbotToggle.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    AimbotToggle.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    AimbotToggle.Text = _G.AimbotEnabled and "ON" or "OFF"
end)

-- Team Check Toggle
local TeamLabel = Instance.new("TextLabel")
TeamLabel.Size = UDim2.new(0.6, 0, 0, 25)
TeamLabel.Position = UDim2.new(0, 10, 0, 75)
TeamLabel.BackgroundTransparency = 1
TeamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamLabel.TextSize = 14
TeamLabel.Font = Enum.Font.Gotham
TeamLabel.Text = "Team Check:"
TeamLabel.TextXAlignment = Enum.TextXAlignment.Left
TeamLabel.Parent = MainFrame

local TeamToggle = Instance.new("TextButton")
TeamToggle.Size = UDim2.new(0, 40, 0, 25)
TeamToggle.Position = UDim2.new(0.65, 0, 0, 75)
TeamToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
TeamToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamToggle.TextSize = 12
TeamToggle.Font = Enum.Font.Gotham
TeamToggle.Text = "ON"
TeamToggle.Parent = MainFrame

TeamToggle.MouseButton1Click:Connect(function()
    _G.TeamCheck = not _G.TeamCheck
    TeamToggle.BackgroundColor3 = _G.TeamCheck and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    TeamToggle.Text = _G.TeamCheck and "ON" or "OFF"
end)

-- Circle Visible Toggle
local CircleVisibleLabel = Instance.new("TextLabel")
CircleVisibleLabel.Size = UDim2.new(0.6, 0, 0, 25)
CircleVisibleLabel.Position = UDim2.new(0, 10, 0, 110)
CircleVisibleLabel.BackgroundTransparency = 1
CircleVisibleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CircleVisibleLabel.TextSize = 14
CircleVisibleLabel.Font = Enum.Font.Gotham
CircleVisibleLabel.Text = "Circle Visible:"
CircleVisibleLabel.TextXAlignment = Enum.TextXAlignment.Left
CircleVisibleLabel.Parent = MainFrame

local CircleVisibleToggle = Instance.new("TextButton")
CircleVisibleToggle.Size = UDim2.new(0, 40, 0, 25)
CircleVisibleToggle.Position = UDim2.new(0.65, 0, 0, 110)
CircleVisibleToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
CircleVisibleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
CircleVisibleToggle.TextSize = 12
CircleVisibleToggle.Font = Enum.Font.Gotham
CircleVisibleToggle.Text = "ON"
CircleVisibleToggle.Parent = MainFrame

CircleVisibleToggle.MouseButton1Click:Connect(function()
    _G.CircleVisible = not _G.CircleVisible
    CircleVisibleToggle.BackgroundColor3 = _G.CircleVisible and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    CircleVisibleToggle.Text = _G.CircleVisible and "ON" or "OFF"
    FOVCircle.Visible = _G.CircleVisible
end)

-- Circle Radius Slider
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(1, -20, 0, 20)
RadiusLabel.Position = UDim2.new(0, 10, 0, 145)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusLabel.TextSize = 12
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.Text = "FOV Radius: " .. tostring(_G.CircleRadius)
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.Parent = MainFrame

local RadiusSlider = Instance.new("TextBox")
RadiusSlider.Size = UDim2.new(1, -20, 0, 25)
RadiusSlider.Position = UDim2.new(0, 10, 0, 165)
RadiusSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RadiusSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusSlider.TextSize = 14
RadiusSlider.Font = Enum.Font.Gotham
RadiusSlider.Text = tostring(_G.CircleRadius)
RadiusSlider.Parent = MainFrame

RadiusSlider.FocusLost:Connect(function()
    local value = tonumber(RadiusSlider.Text)
    if value and value > 0 and value < 500 then
        _G.CircleRadius = value
        RadiusLabel.Text = "FOV Radius: " .. tostring(_G.CircleRadius)
    else
        RadiusSlider.Text = tostring(_G.CircleRadius)
    end
end)

-- Sensitivity Slider
local SensitivityLabel = Instance.new("TextLabel")
SensitivityLabel.Size = UDim2.new(1, -20, 0, 20)
SensitivityLabel.Position = UDim2.new(0, 10, 0, 200)
SensitivityLabel.BackgroundTransparency = 1
SensitivityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SensitivityLabel.TextSize = 12
SensitivityLabel.Font = Enum.Font.Gotham
SensitivityLabel.Text = "Sensitivity: " .. tostring(_G.Sensitivity)
SensitivityLabel.TextXAlignment = Enum.TextXAlignment.Left
SensitivityLabel.Parent = MainFrame

local SensitivitySlider = Instance.new("TextBox")
SensitivitySlider.Size = UDim2.new(1, -20, 0, 25)
SensitivitySlider.Position = UDim2.new(0, 10, 0, 220)
SensitivitySlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SensitivitySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SensitivitySlider.TextSize = 14
SensitivitySlider.Font = Enum.Font.Gotham
SensitivitySlider.Text = tostring(_G.Sensitivity)
SensitivitySlider.Parent = MainFrame

SensitivitySlider.FocusLost:Connect(function()
    local value = tonumber(SensitivitySlider.Text)
    if value and value > 0 and value < 5 then
        _G.Sensitivity = value
        SensitivityLabel.Text = "Sensitivity: " .. tostring(_G.Sensitivity)
    else
        SensitivitySlider.Text = tostring(_G.Sensitivity)
    end
end)

-- Transparency Slider
local TransparencyLabel = Instance.new("TextLabel")
TransparencyLabel.Size = UDim2.new(1, -20, 0, 20)
TransparencyLabel.Position = UDim2.new(0, 10, 0, 255)
TransparencyLabel.BackgroundTransparency = 1
TransparencyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TransparencyLabel.TextSize = 12
TransparencyLabel.Font = Enum.Font.Gotham
TransparencyLabel.Text = "Transparency: " .. tostring(math.floor(_G.CircleTransparency * 100)) .. "%"
TransparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
TransparencyLabel.Parent = MainFrame

local TransparencySlider = Instance.new("TextBox")
TransparencySlider.Size = UDim2.new(1, -20, 0, 25)
TransparencySlider.Position = UDim2.new(0, 10, 0, 275)
TransparencySlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TransparencySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
TransparencySlider.TextSize = 14
TransparencySlider.Font = Enum.Font.Gotham
TransparencySlider.Text = tostring(math.floor(_G.CircleTransparency * 100))
TransparencySlider.Parent = MainFrame

TransparencySlider.FocusLost:Connect(function()
    local value = tonumber(TransparencySlider.Text)
    if value and value >= 0 and value <= 100 then
        _G.CircleTransparency = value / 100
        TransparencyLabel.Text = "Transparency: " .. tostring(value) .. "%"
    else
        TransparencySlider.Text = tostring(math.floor(_G.CircleTransparency * 100))
    end
end)

-- Thickness Slider
local ThicknessLabel = Instance.new("TextLabel")
ThicknessLabel.Size = UDim2.new(1, -20, 0, 20)
ThicknessLabel.Position = UDim2.new(0, 10, 0, 310)
ThicknessLabel.BackgroundTransparency = 1
ThicknessLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ThicknessLabel.TextSize = 12
ThicknessLabel.Font = Enum.Font.Gotham
ThicknessLabel.Text = "Thickness: " .. tostring(_G.CircleThickness)
ThicknessLabel.TextXAlignment = Enum.TextXAlignment.Left
ThicknessLabel.Parent = MainFrame

local ThicknessSlider = Instance.new("TextBox")
ThicknessSlider.Size = UDim2.new(1, -20, 0, 25)
ThicknessSlider.Position = UDim2.new(0, 10, 0, 330)
ThicknessSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ThicknessSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ThicknessSlider.TextSize = 14
ThicknessSlider.Font = Enum.Font.Gotham
ThicknessSlider.Text = tostring(_G.CircleThickness)
ThicknessSlider.Parent = MainFrame

ThicknessSlider.FocusLost:Connect(function()
    local value = tonumber(ThicknessSlider.Text)
    if value and value >= 0 and value <= 10 then
        _G.CircleThickness = value
        ThicknessLabel.Text = "Thickness: " .. tostring(_G.CircleThickness)
    else
        ThicknessSlider.Text = tostring(_G.CircleThickness)
    end
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(1, 0, 0, 30)
CloseButton.Position = UDim2.new(0, 0, 1, -30)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "CLOSE GUI"
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    MainGui:Destroy()
end)

-- ============================================================================
-- AIMBOT LOGIC
-- ============================================================================

local function GetClosestPlayer()
	local MaximumDistance = _G.CircleRadius
	local Target = nil
	local ClosestDistance = MaximumDistance

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name and v.Character then
			if _G.TeamCheck and v.Team == LocalPlayer.Team then
				continue
			end
			
			local HumanoidRootPart = v.Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = v.Character:FindFirstChild("Humanoid")
			
			if HumanoidRootPart and Humanoid and Humanoid.Health > 0 then
				local ScreenPoint = Camera:WorldToScreenPoint(HumanoidRootPart.Position)
				local MouseLocation = UserInputService:GetMouseLocation()
				local VectorDistance = (Vector2.new(MouseLocation.X, MouseLocation.Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
				
				if VectorDistance < ClosestDistance then
					ClosestDistance = VectorDistance
					Target = v
				end
			end
		end
	end

	return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    if Holding and _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local AimPart = Target.Character:FindFirstChild(_G.AimPart)
            if AimPart then
                TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, AimPart.Position)}):Play()
            end
        end
    end
end)
