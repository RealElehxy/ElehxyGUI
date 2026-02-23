-- &b&lElehxy&d&lSMP &c» &r Elite Hub V8 - Ultra Designer UI
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Alte GUI entfernen
if CoreGui:FindFirstChild("ElehxyEliteV8") then CoreGui.ElehxyEliteV8:Destroy() end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "ElehxyEliteV8"

-- MAIN FRAME (Das Gehäuse)
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

-- GLOW / SCHATTEN EFFEKT
local shadow = Instance.new("ImageLabel", main)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015667231" -- Schatten Textur
shadow.ImageColor3 = Color3.fromRGB(220, 20, 60)
shadow.ImageTransparency = 0.6
shadow.ZIndex = 0

-- SEITENLEISTE
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
sidebar.BorderSizePixel = 0

local sidebarCorner = Instance.new("UICorner", sidebar)
sidebarCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "ELEHXY V8"
title.TextColor3 = Color3.fromRGB(220, 20, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

-- TAB CONTAINER
local tabContainer = Instance.new("ScrollingFrame", sidebar)
tabContainer.Size = UDim2.new(1, 0, 1, -60)
tabContainer.Position = UDim2.new(0, 0, 0, 60)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 0
local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.Padding = UDim.new(0, 5)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENT BEREICH
local pageContainer = Instance.new("Frame", main)
pageContainer.Position = UDim2.new(0, 150, 0, 15)
pageContainer.Size = UDim2.new(1, -165, 1, -30)
pageContainer.BackgroundTransparency = 1

local pages = {}

-- FUNKTION: TAB ERSTELLEN
local function createTab(name, iconID)
    local page = Instance.new("ScrollingFrame", pageContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 8)

    local tabBtn = Instance.new("TextButton", tabContainer)
    tabBtn.Size = UDim2.new(0, 120, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 14
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
        -- Kleiner Effekt
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(220, 20, 60)}):Play()
        wait(0.3)
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end)

    pages[name] = page
    return page
end

-- TABS
local combatPage = createTab("Combat")
local visualPage = createTab("Visuals")
local lootPage = createTab("Loot")
local settingsPage = createTab("Settings")

-- FUNKTION: TOGGLE BUTTONS
local function addToggle(page, name, callback)
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(1, -5, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 30, 0, 20)
    btn.Position = UDim2.new(1, -40, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        btn.BackgroundColor3 = toggled and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(50, 50, 50)
        callback(toggled)
    end)
end

-- BEISPIEL BUTTONS
addToggle(combatPage, "Silent Aim", function(v) print("Silent Aim:", v) end)
addToggle(visualPage, "Player ESP", function(v) print("ESP:", v) end)
addToggle(lootPage, "Rare Loot Only", function(v) print("Loot Filter:", v) end)

-- KILL SWITCH
local killBtn = Instance.new("TextButton", settingsPage)
killBtn.Size = UDim2.new(1, -5, 0, 40)
killBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
killBtn.Text = "UNLOAD HUB"
killBtn.TextColor3 = Color3.new(1, 1, 1)
killBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", killBtn)
killBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- DEFAULT PAGE
pages["Visuals"].Visible = true

-- HIDE MIT K
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end end)

print("&b&lElehxy&d&lSMP &c» &r Elite Hub V8 geladen. GitHub-ready!")
