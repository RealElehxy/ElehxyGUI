-- &b&lElehxy&d&lSMP &c» &r Elite Hub V9 - Universal & Apoc 2 Optimized
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera

-- Alte GUI entfernen
if CoreGui:FindFirstChild("ElehxyEliteV9") then CoreGui.ElehxyEliteV9:Destroy() end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "ElehxyEliteV9"

-- SETTINGS / GLOBALS
_G.PlayerESP = false
_G.Tracers = false
_G.LootESP = false
_G.SpeedValue = 16
_G.JumpValue = 50
_G.FlyEnabled = false
local tracerLines = {}

-- 1. MODERN DESIGN SETUP
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 550, 0, 400)
main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "ELEHXY V9"
title.TextColor3 = Color3.fromRGB(220, 20, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1

-- Tab System
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 160, 0, 10)
container.Size = UDim2.new(1, -170, 1, -20)
container.BackgroundTransparency = 1

local pages = {}
local tabList = Instance.new("UIListLayout", sidebar)
tabList.Padding = UDim.new(0, 5)
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createTab(name)
    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)

    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0, 130, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
    pages[name] = page
    return page
end

-- TABS ERSTELLEN
local combatPage = createTab("Combat")
local visualPage = createTab("Visuals")
local movePage = createTab("Movement")
local lootPage = createTab("Apoc 2 Loot")
local infoPage = createTab("Info")

-- 2. FUNKTIONEN: COMPONENTS
local function addToggle(page, name, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(30, 30, 30)
        callback(enabled)
    end)
end

local function addSlider(page, name, min, max, callback)
    local label = Instance.new("TextLabel", page)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Text = name .. " (Click to set)"
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "Set Value"
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        -- Einfacher Slider-Ersatz für Touch/PC
        callback(max) -- Hier könnte man ein Eingabefeld machen
    end)
end

-- 3. FEATURES IMPLEMENTIEREN
-- Visuals
addToggle(visualPage, "Player ESP", function(v) _G.PlayerESP = v end)
addToggle(visualPage, "Tracers", function(v) _G.Tracers = v end)

-- Movement
addToggle(movePage, "Speed Hack", function(v) 
    LP.Character.Humanoid.WalkSpeed = v and 100 or 16
end)
addToggle(movePage, "Infinite Jump", function(v)
    UIS.JumpRequest:Connect(function()
        if v then LP.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end
    end)
end)

-- Combat
addToggle(combatPage, "No Recoil (Universal)", function(v)
    print("No Recoil Status:", v)
end)

-- Loot (Universal & Apoc 2)
addToggle(lootPage, "Scan for Items", function(v)
    _G.LootESP = v
    if v then
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Model") and (item:FindFirstChild("ItemProxy") or item.Name:find("Crate")) then
                local h = Instance.new("Highlight", item)
                h.Name = "EliteESP"
                h.FillColor = Color3.new(0,1,0)
            end
        end
    end
end)

-- 4. LOOP FÜR ESP & TRACERS
RunService.RenderStepped:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            -- Player ESP
            local esp = char:FindFirstChild("PlayerHighlight")
            if _G.PlayerESP then
                if not esp then 
                    esp = Instance.new("Highlight", char) 
                    esp.Name = "PlayerHighlight" 
                    esp.FillColor = Color3.new(1,0,0) 
                end
            elseif esp then esp:Destroy() end

            -- Tracers
            local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
            local line = tracerLines[p.Name] or Drawing.new("Line")
            if _G.Tracers and onScreen then
                line.Visible = true
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = Color3.new(1, 0, 0)
                tracerLines[p.Name] = line
            else
                line.Visible = false
            end
        end
    end
end)

-- Startseite
pages["Info"].Visible = true
local infoTxt = Instance.new("TextLabel", pages["Info"])
infoTxt.Size = UDim2.new(1, 0, 1, 0)
infoTxt.Text = "Willkommen im Elehxy Hub!\nNutze [K] zum Schließen.\nStatus: Aktiv"
infoTxt.TextColor3 = Color3.new(1,1,1)
infoTxt.BackgroundTransparency = 1

UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end end)

print("&b&lElehxy&d&lSMP &c» &r Hub V9 geladen!")
