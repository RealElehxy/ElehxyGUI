-- &b&lElehxy&d&lSMP &c» &r Elite Hub V12 - Lag Fix & Pro ESP
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("ElehxyHubV12") then CoreGui.ElehxyHubV12:Destroy() end

-- SETTINGS
_G.PlayerESP = false
_G.Tracers = false
_G.ExtraInfo = true -- Health/Food
_G.MainColor = Color3.fromRGB(220, 20, 60)

-- 1. OPTIMIERTE GUI
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "ElehxyHubV12"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ELEHXY V12 [LAG FIX]"
title.TextColor3 = _G.MainColor
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function addBtn(name, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

addBtn("Toggle ESP (Health/Food)", function(b)
    _G.PlayerESP = not _G.PlayerESP
    b.BackgroundColor3 = _G.PlayerESP and _G.MainColor or Color3.fromRGB(35, 35, 35)
end)

addBtn("Toggle Tracers", function(b)
    _G.Tracers = not _G.Tracers
    b.BackgroundColor3 = _G.Tracers and _G.MainColor or Color3.fromRGB(35, 35, 35)
end)

-- 2. HIGH-PERFORMANCE ESP LOGIK
local function createInfoGui(parent)
    local billboard = Instance.new("BillboardGui", parent)
    billboard.Name = "ElehxyStats"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 3, 0)

    local container = Instance.new("Frame", billboard)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    Instance.new("UIListLayout", container)

    local healthBar = Instance.new("Frame", container)
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 0, 5)
    healthBar.BackgroundColor3 = Color3.new(1, 0, 0)

    local foodBar = Instance.new("Frame", container)
    foodBar.Name = "FoodBar"
    foodBar.Size = UDim2.new(1, 0, 0, 5)
    foodBar.BackgroundColor3 = Color3.new(1, 0.6, 0)

    return billboard
end

RunService.Heartbeat:Connect(function()
    if not _G.PlayerESP and not _G.Tracers then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") then
            local char = p.Character
            local hum = char.Humanoid
            
            -- Stats Update
            if _G.PlayerESP then
                local stats = char:FindFirstChild("ElehxyStats") or createInfoGui(char)
                stats.Enabled = true
                -- Health
                stats.Frame.HealthBar.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 0, 5)
                -- Food (Apoc 2 spezifisch, falls vorhanden)
                local foodVal = char:FindFirstChild("Food") or {Value = 100} 
                stats.Frame.FoodBar.Size = UDim2.new(foodVal.Value / 100, 0, 0, 5)
            elseif char:FindFirstChild("ElehxyStats") then
                char.ElehxyStats.Enabled = false
            end
            
            -- Tracers (Optimiert)
            local tName = "T_" .. p.Name
            local line = sg:FindFirstChild(tName)
            if _G.Tracers then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        if not line then
                            line = Instance.new("Frame", sg)
                            line.Name = tName
                            line.BorderSizePixel = 0
                            line.AnchorPoint = Vector2.new(0.5, 0.5)
                        end
                        local from = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                        local to = Vector2.new(pos.X, pos.Y)
                        line.Size = UDim2.new(0, (to - from).Magnitude, 0, 1)
                        line.Position = UDim2.new(0, (from.X + to.X) / 2, 0, (from.Y + to.Y) / 2)
                        line.Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
                        line.BackgroundColor3 = _G.MainColor
                        line.Visible = true
                    elseif line then line.Visible = false end
                end
            elseif line then line:Destroy() end
        end
    end
end)

UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.K then frame.Visible = not frame.Visible end end)

print("&b&lElehxy&d&lSMP &c» &r V12 Optimized geladen!")
