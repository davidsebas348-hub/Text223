-- ======================
-- SBS HUB COMPLETO FINAL (VERSIÓN SIN ACCIONES)
-- ======================
if not game:IsLoaded() then game.Loaded:Wait() end

-- ======================
-- SERVICIOS
-- ======================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ======================
-- CREAR GUI PRINCIPAL
-- ======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SBS_HUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,500,0,350)
mainFrame.Position = UDim2.new(0.5,-250,0.5,-175)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 2

-- ======================
-- DRAG GUI PRINCIPAL
-- ======================
do
    local dragging, dragStart, startPos, dragInput
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

-- ======================
-- TITULO
-- ======================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.Text = "SBS HUB | BUILD YOUR ESCAPE"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextWrapped = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = mainFrame

local line = Instance.new("Frame", mainFrame)
line.Size = UDim2.new(1,0,0,2)
line.Position = UDim2.new(0,0,0,50)
line.BackgroundColor3 = Color3.fromRGB(255,255,255)

-- ======================
-- FRAMES LATERALES
-- ======================
local leftFrame = Instance.new("Frame", mainFrame)
leftFrame.Size = UDim2.new(0,150,1,-52)
leftFrame.Position = UDim2.new(0,0,0,52)
leftFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local rightFrame = Instance.new("Frame", mainFrame)
rightFrame.Size = UDim2.new(1,-150,1,-52)
rightFrame.Position = UDim2.new(0,150,0,52)
rightFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local midLine = Instance.new("Frame", mainFrame)
midLine.Size = UDim2.new(0,2,1,-52)
midLine.Position = UDim2.new(0,150,0,52)
midLine.BackgroundColor3 = Color3.fromRGB(255,255,255)

-- ======================
-- FUNCION CREAR BOTONES (SIN ACCIONES)
-- ======================
local function createButton(parent,text,y,callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,30)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.Parent = parent
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(40,40,40) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(20,20,20) end)
    -- NO ejecutar callback
end

-- ======================
-- MENUS Y BOTONES
-- ======================
local menuOrder = {"MAIN","PANELS","GUARD","TEAM/TP","ESP A PLAYERS","TOOL(OP)","AUTOWIN","YOUTUBE"}
local menuData = {
    ["MAIN"] = {"DESYNC","LOCALPLAYER","CREAR PISO FLOTANTE","COPIAR TOOLS","INSTANT PROMPT"},
    ["PANELS"] = {"AUTO COLLECT PANELS","AUTO PONER PANELS","ESP PANELS","ESP PANELS V2"},
    ["GUARD"] = {"TRAP GUARD","ESP GUARD"},
    ["TEAM/TP"] = {"REVIVE GUI","TP GUI","AUTO WIN TEAM"},
    ["ESP A PLAYERS"] = {"ESP HIGHLIGHTS","ESP HIGHLIGHTS V2","ESP TO PLAYERS IN THE BACK","ESP TRACERS","ESP DISTANCE + NAME"},
    ["TOOL(OP)"] = {"Trap","Speed","Break","Show","Ghost","Decoy"},
    ["AUTOWIN"] = {"INSTANT WIN"},
    ["YOUTUBE"] = {"YOUTUBE:SBS HUB","SUSCRIBETE:)"}
}

local function clearFrame(frame)
    for _, v in pairs(frame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            v:Destroy()
        end
    end
end

for _, menu in ipairs(menuOrder) do
    createButton(leftFrame, menu, 10 + (_-1)*35, function()
        clearFrame(rightFrame)

        local titleLabel = Instance.new("TextLabel", rightFrame)
        titleLabel.Size = UDim2.new(1,0,0,30)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = menu
        titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 18

        local oy = 40
        for _, opt in ipairs(menuData[menu]) do
            createButton(rightFrame,opt,oy,function()
                -- NO ejecutar nada al hacer click
            end)
            oy = oy + 40
        end
    end)
end

-- ======================
-- ICONO SBS PARA ABRIR/CERRAR CON DRAG
-- ======================
local toggle = Instance.new("TextButton", screenGui)
toggle.Size = UDim2.new(0,60,0,60)
toggle.Position = UDim2.new(1,-80,0,20)
toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggle.Text = "SBS"
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 24
toggle.BorderSizePixel = 0

local corner = Instance.new("UICorner", toggle)
corner.CornerRadius = UDim.new(0.3,0)

do
    local dragging, dragStart, startPos, dragInput
    local function update(input)
        local delta = input.Position - dragStart
        toggle.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggle.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    toggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

local open = true
toggle.MouseButton1Click:Connect(function()
    open = not open
    mainFrame.Visible = open
end)
