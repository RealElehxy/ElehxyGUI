-- &b&lElehxy&d&lSMP &c» &r Elite Hub V10 - Final Stability & Color Update
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera

-- Alte GUI entfernen
if CoreGui:FindFirstChild("ElehxyEliteV10") then CoreGui.ElehxyEliteV10:Destroy() end

-- SETTINGS
_G.PlayerESP = false
_G.Tracers = false
_G.LootESP = false
_G.TracerColor = Color3.fromRGB(255, 0, 0)
local tracerLines = {}

-- 1. STABILE GUI STRUKTUR
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "ElehxyEliteV10"

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 400, 0, 350)
main.Position = UDim2.new(0.5, -200, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
main.Active = true
main.Draggable = true

-- Titel
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ELEHXY ELITE V10 [K]"
title.TextColor3 = Color3.fromRGB(220, 20, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

-- Scroll Bereich für Buttons
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8)

-- 2. FUNKTIONEN FÜR DIE BUTTONS
local function makeToggle(name, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(30, 30, 30)
        callback(state)
    end)
end

local function makeColorBtn(name, color)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = color
    btn.Text = "Set Tracer Color: " .. name
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        _G.TracerColor = color
    end)
end

-- 3. FEATURES
makeToggle("Player ESP", function(v) _G.PlayerESP = v end)
makeToggle("Player Tracers (Lines)", function(v) _G.Tracers = v end)
makeToggle("Universal Loot ESP", function(v) _G.LootESP = v end)

-- Farbauswahl für die Linien
makeColorBtn("Red", Color3.fromRGB(255, 0, 0))
makeColorBtn("Cyan", Color3.fromRGB(0, 255, 255))
makeColorBtn("Green", Color3.fromRGB(0, 255, 0))
makeColorBtn("Yellow", Color3.fromRGB(255, 255, 0))

-- 4. DIE LOGIK (ESP & TRACERS)
RunService.RenderStepped:Connect(function()
    if not screenGui or not screenGui.Parent then return end
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- PLAYER ESP (Highlight)
            local char = p.Character
            local esp = char:FindFirstChild("EliteHighlight")
            if _G.PlayerESP then
                if not esp then
                    esp = Instance.new("Highlight", char)
                    esp.Name = "EliteHighlight"
                    esp.FillColor = _G.TracerColor
                    esp.OutlineColor = Color3.new(1,1,1)
                end
            elseif esp then esp:Destroy() end

            -- TRACERS (Lines)
            local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
            if _G.Tracers and onScreen then
                local line = tracerLines[p.Name] or Drawing.new("Line")
                line.Visible = true
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = _G.TracerColor
                line.Thickness = 1.5
                line.Transparency = 1
                tracerLines[p.Name] = line
            else
                if tracerLines[p.Name] then
                    tracerLines[p.Name].Visible = false
                end
            end
        end
    end
end)

-- 5. LOOT SCANNER LOOP
spawn(function()
    while wait(5) do
        if _G.LootESP then
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("Model") and (item:FindFirstChild("ItemProxy") or item.Name:find("Crate")) then
                    if not item:FindFirstChild("LootHighlight") then
                        local h = Instance.new("Highlight", item)
                        h.Name = "LootHighlight"
                        h.FillColor = Color3.new(0, 1, 0)
                        h.FillTransparency = 0.5
                    end
                end
            end
        end
    end
end)

-- Menü mit K öffnen/schließen
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)

print("&b&lElehxy&d&lSMP &c» &r Elite Hub V10 ist scharfgeschaltet!")
