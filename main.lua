--[[
    ZIXN MAIN V7 - SYNCED EDITION
    - GodMode se activa con el Auto-Clicker
    - Ultra Fast Kill & Anti-Cheat Bypass
]]

local Services = setmetatable({}, {
    __index = function(t, k) return game:GetService(k) end
})

local LocalPlayer = Services.Players.LocalPlayer
local ReplicatedStorage = Services.ReplicatedStorage
local RunService = Services.RunService
local UserInputService = Services.UserInputService

-- // ESTADO GLOBAL
getgenv().AutoKillEnabled = false
getgenv().GodModeEnabled = false -- Ahora inicia en false

-- // TRADUCCIONES [2026-02-08]
local T = (Services.LocalizationService.RobloxLocaleId:lower():sub(1,2) == "es") 
    and {Kill = "ATAQUE INSTANTÁNEO", Auto = "AUTO-CLICKER: "} 
    or {Kill = "INSTANT KILL", Auto = "AUTO-CLICKER: "}

-----------------------------------------------------------
-- ANTI-DETECCIÓN
-----------------------------------------------------------
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and (tostring(self) == "MainEvent" or tostring(self):find("Detect")) then
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-----------------------------------------------------------
-- LÓGICA DE COMBATE Y GODMODE
-----------------------------------------------------------

local function FastKill()
    pcall(function()
        local gameAttr = LocalPlayer:GetAttribute("Game")
        local teamAttr = LocalPlayer:GetAttribute("Team")
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p:GetAttribute("Game") == gameAttr and p:GetAttribute("Team") ~= teamAttr then
                ReplicatedStorage.KnifeKill:FireServer(p, p)
            end
        end
    end)
end

-- Bucle Principal (Maneja Kill y GodMode)
task.spawn(function()
    while true do
        if getgenv().AutoKillEnabled then
            -- Atacar
            FastKill()
            
            -- Mantener Vida (GodMode Activo)
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = hum.MaxHealth end
            end
            
            RunService.Heartbeat:Wait() 
        else
            task.wait(0.3)
        end
    end
end)

-----------------------------------------------------------
-- INTERFAZ
-----------------------------------------------------------

local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "Zixn_Ultra_V7"
sg.ResetOnSpawn = false

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 250, 0, 200)
Main.Position = UDim2.new(0.5, -125, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
task.spawn(function()
    local h = 0
    while true do
        Stroke.Color = Color3.fromHSV(h, 0.7, 1)
        h = h + (1/400); RunService.RenderStepped:Wait()
    end
end)

local Layout = Instance.new("UIListLayout", Main)
Layout.Padding = UDim.new(0, 10); Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1; Title.Text = "ZIXN1GGA V7 - SYNC"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBlack"; Title.TextSize = 13

local function CreateBtn(text, cb)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.85, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.Text = text; b.TextColor3 = Color3.new(1, 1, 1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb) return b
end

CreateBtn(T.Kill, FastKill)

local AutoBtn = CreateBtn(T.Auto .. "OFF", function()
    getgenv().AutoKillEnabled = not getgenv().AutoKillEnabled
    
    if getgenv().AutoKillEnabled then
        AutoBtn.Text = T.Auto .. "ON (+GOD)"
        AutoBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        AutoBtn.Text = T.Auto .. "OFF"
        AutoBtn.TextColor3 = Color3.new(1, 1, 1)
    end
end)

-- Arrastre Suave
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end end)
Main.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end end)
