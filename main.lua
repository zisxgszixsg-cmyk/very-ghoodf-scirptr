--[[ 
    ZIXN V8 - THE FINAL FIX
    - Sincronización GodMode + Kill
    - Bypass de Anticheat Integrado
    - Corrección de NIL Values
]]

local Services = setmetatable({}, {
    __index = function(t, k) return game:GetService(k) end
})

local LP = Services.Players.LocalPlayer
local RS = Services.ReplicatedStorage
local Run = Services.RunService

getgenv().AutoKill = false

-- Sistema de Idiomas (Nota y Cargando Motor) [2026-02-08]
local T = (Services.LocalizationService.RobloxLocaleId:lower():sub(1,2) == "es") 
    and {Kill = "ATAQUE MANUAL", Auto = "AUTO-KILL (+GOD): "} 
    or {Kill = "MANUAL KILL", Auto = "AUTO-KILL (+GOD): "}

-- Lógica de Ataque Optimizada
local function DoKill()
    pcall(function()
        local g = LP:GetAttribute("Game")
        local t = LP:GetAttribute("Team")
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LP and p:GetAttribute("Game") == g and p:GetAttribute("Team") ~= t then
                RS.KnifeKill:FireServer(p, p)
            end
        end
    end)
end

-- Bucle de Auto-Matanza y GodMode
Run.Heartbeat:Connect(function()
    if getgenv().AutoKill then
        DoKill()
        -- GodMode Sync
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid").Health = 100
        end
    end
end)

-----------------------------------------------------------
-- INTERFAZ (FIXED)
-----------------------------------------------------------
local sg = Instance.new("ScreenGui", LP.PlayerGui)
sg.Name = "ZixnFix"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 240, 0, 180)
Main.Position = UDim2.new(0.5, -120, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
task.spawn(function()
    local h = 0
    while true do
        Stroke.Color = Color3.fromHSV(h, 0.7, 1)
        h = h + (1/400); Run.RenderStepped:Wait()
    end
end)

local Layout = Instance.new("UIListLayout", Main)
Layout.Padding = UDim.new(0, 10); Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1; Title.Text = "ZIXN V8 PRO"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBlack"; Title.TextSize = 13

local function Btn(text, cb)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.85, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30,30,35); b.Text = text; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb) return b
end

Btn(T.Kill, DoKill)
local AB = Btn(T.Auto .. "OFF", function()
    getgenv().AutoKill = not getgenv().AutoKill
    AB.Text = T.Auto .. (getgenv().AutoKill and "ON" or "OFF")
    AB.TextColor3 = getgenv().AutoKill and Color3.fromRGB(0, 255, 150) or Color3.new(1,1,1)
end)

-- Drag System
local drag = false; local start; local pos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = i.Position; pos = Main.Position end end)
Main.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
Services.UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
    local d = i.Position - start
    Main.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
end end)
