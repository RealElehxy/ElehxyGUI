-- &b&lElehxy&d&lSMP &c» &r Elite Hub V11 - Kompatibilitäts-Fix
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Alte Reste entfernen
if CoreGui:FindFirstChild("ElehxyHubV11") then CoreGui.ElehxyHubV11:Destroy() end

-- SETTINGS
_G.PlayerESP = false
_G.Tracers = false
_G.LootESP = false
_G.MainColor = Color3.fromRGB(220, 20, 60)

-- 1. GUI ERSTELLEN (Einfach & Sicher)
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "ElehxyHubV11"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ELEHXY HUB V11 [K]"
title.TextColor3 = _G.MainColor
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUTTON FUNKTION
local function addBtn(name, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- 2. DIE FEATURES
addBtn("Toggle Player ESP", function(b)
    _G.PlayerESP = not _G.PlayerESP
    b.BackgroundColor3 = _G.PlayerESP and _G.MainColor or Color3.fromRGB(40, 40, 40)
end)

addBtn("Toggle Tracers", function(b)
    _G.Tracers = not _G.Tracers
    b.BackgroundColor3 = _G.Tracers and _G.MainColor or Color3.fromRGB(40, 40, 40)
end)

addBtn("Toggle Loot ESP", function(b)
    _G.LootESP = not _G.LootESP
    b.BackgroundColor3 = _G.LootESP and _G.MainColor or Color3.fromRGB(40, 40, 40)
end)

addBtn("Cyan Color", function() _G.MainColor = Color3.fromRGB(0, 255, 255) title.TextColor3 = _G.MainColor end)
addBtn("Red Color", function() _G.MainColor = Color3.fromRGB(220, 20, 60) title.TextColor3 = _G.MainColor end)

-- 3. ESP & TRACERS LOGIK
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            
            -- Highlight (ESP)
            local h = char:FindFirstChild("EliteHighlight")
            if _G.PlayerESP then
                if not h then
                    h = Instance.new("Highlight", char)
                    h.Name = "EliteHighlight"
                end
                h.FillColor = _G.MainColor
            elseif h then h:Destroy() end
            
            -- Tracers (Fallback-Methode ohne Drawing-Library)
            local tName = "Tracer_" .. p.Name
            local existing = sg:FindFirstChild(tName)
            
            if _G.Tracers then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    if not existing then
                        existing = Instance.new("Frame", sg)
                        existing.Name = tName
                        existing.BorderSizePixel = 0
                        existing.AnchorPoint = Vector2.new(0.5, 0.5)
                    end
                    local from = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                    local to = Vector2.new(pos.X, pos.Y)
                    local dist = (to - from).Magnitude
                    existing.Size = UDim2.new(0, dist, 0, 1)
                    existing.Position = UDim2.new(0, (from.X + to.X) / 2, 0, (from.Y + to.Y) / 2)
                    existing.Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
                    existing.BackgroundColor3 = _G.MainColor
                    existing.Visible = true
                elseif existing then existing.Visible = false end
            elseif existing then existing:Destroy() end
        end
    end
end)

-- 4. LOOT LOGIK
spawn(function()
    while wait(5) do
        if _G.LootESP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and (v:FindFirstChild("ItemProxy") or v.Name:find("Crate")) then
                    if not v:FindFirstChild("LootH") then
                        local lh = Instance.new("Highlight", v)
                        lh.Name = "LootH"
                        lh.FillColor = Color3.new(0, 1, 0)
                    end
                end
            end
        end
    end
end)

-- K-Key
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.K then frame.Visible = not frame.Visible end end)

print("&b&lElehxy&d&lSMP &c» &r V11 Geladen!")
