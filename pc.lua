local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LP, RS, Run, UIS, TS = Services.Players.LocalPlayer, Services.ReplicatedStorage, Services.RunService, Services.UserInputService, Services.TweenService

getgenv().AutoKill = false
getgenv().ESP_Enabled = false
local Owners = {["kp_omnipower"] = true, ["Mixsito"] = true}
local LL_IMAGE = "rbxassetid://138873321650261"

-- // LIMPIEZA DE UI PREVIA
if LP.PlayerGui:FindFirstChild("Zix_PC") then LP.PlayerGui.Zix_PC:Destroy() end

-- // UI BASE
local sg = Instance.new("ScreenGui", LP.PlayerGui); sg.Name = "Zix_PC"; sg.ResetOnSpawn = false

-- // NOTIFICACIONES
local function Notify(title, msg)
    local n = Instance.new("Frame", sg); n.Size = UDim2.new(0, 220, 0, 60); n.Position = UDim2.new(1, 20, 1, -80); n.BackgroundColor3 = Color3.fromRGB(15, 15, 20); n.BorderSizePixel = 0
    Instance.new("UICorner", n); Instance.new("UIStroke", n).Color = Color3.fromRGB(255, 50, 50)
    local tl = Instance.new("TextLabel", n); tl.Size = UDim2.new(1, -10, 0, 25); tl.Position = UDim2.new(0, 10, 0, 5); tl.Text = title; tl.TextColor3 = Color3.new(1, 0, 0); tl.Font = "GothamBold"; tl.TextSize = 14; tl.BackgroundTransparency = 1; tl.TextXAlignment = "Left"
    local ml = Instance.new("TextLabel", n); ml.Size = UDim2.new(1, -10, 0, 20); ml.Position = UDim2.new(0, 10, 0, 25); ml.Text = msg; ml.TextColor3 = Color3.new(1, 1, 1); ml.Font = "Gotham"; ml.TextSize = 12; ml.BackgroundTransparency = 1; ml.TextXAlignment = "Left"
    n:TweenPosition(UDim2.new(1, -240, 1, -80), "Out", "Back", 0.5, true)
    task.wait(3); n:TweenPosition(UDim2.new(1, 20, 1, -80), "In", "Quad", 0.5, true); task.wait(0.6); n:Destroy()
end

-- // SISTEMA DE CHAT (SAY/DIE)
local function SendChat(m)
    pcall(function()
        local TCS = game:GetService("TextChatService")
        if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
            TCS.TextChannels.RBXGeneral:SendAsync(m)
        else
            RS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(m, "All")
        end
        Notify("SAY", "Mensaje: " .. m)
    end)
end

LP.Chatted:Connect(function(msg)
    local low = msg:lower()
    if low:sub(1,5) == "!say " then SendChat(msg:sub(6))
    elseif low == ".die" or low == "die" then if LP.Character then LP.Character.Humanoid.Health = 0 end end
end)

-- // MAIN FRAME Y DRAG
local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 260, 0, 250); Main.Position = UDim2.new(0.5, -130, 0.5, -125); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Main.Visible = false
Instance.new("UICorner", Main); local St = Instance.new("UIStroke", Main); St.Color = Color3.new(1,0,0); St.Thickness = 2

local d, di, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end end)
UIS.InputChanged:Connect(function(i) if i == di and d then local dl = i.Position - ds; Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- // BOTONES (FIX: REFERENCIA SEGURA)
local function CreateBtn(txt, y, cb)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0.9, 0, 0, 50); b.Position = UDim2.new(0.05,0,0,y); b.BackgroundColor3 = Color3.fromRGB(20,20,25); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 12; b.AutoButtonColor = false
    Instance.new("UICorner", b); local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(40,40,45)
    b.MouseButton1Click:Connect(function() pcall(function() cb(b, s) end) end)
    return b, s
end

CreateBtn("ATAQUE MANUAL", 20, function()
    local g, t = LP:GetAttribute("Game"), LP:GetAttribute("Team")
    for _, v in pairs(Services.Players:GetPlayers()) do if v ~= LP and v:GetAttribute("Game") == g and v:GetAttribute("Team") ~= t then RS.KnifeKill:FireServer(v, v) end end
    Notify("ATAQUE", "Ataque manual ejecutado.")
end)

local ABtn, AStroke = CreateBtn("AUTO-KILL: OFF", 85, function(b, s)
    getgenv().AutoKill = not getgenv().AutoKill
    if b and b:IsA("TextButton") then
        b.Text = "AUTO-KILL: " .. (getgenv().AutoKill and "ON" or "OFF")
        b.TextColor3 = getgenv().AutoKill and Color3.new(0,1,0.6) or Color3.new(1,1,1)
        s.Color = getgenv().AutoKill and Color3.new(0,1,0.6) or Color3.fromRGB(40,40,45)
    end
end)

local EBtn, EStroke = CreateBtn("SKELETON ESP: OFF", 150, function(b, s)
    getgenv().ESP_Enabled = not getgenv().ESP_Enabled
    if b and b:IsA("TextButton") then
        b.Text = "SKELETON ESP: " .. (getgenv().ESP_Enabled and "ON" or "OFF")
        b.TextColor3 = getgenv().ESP_Enabled and Color3.new(0,0.8,1) or Color3.new(1,1,1)
        s.Color = getgenv().ESP_Enabled and Color3.new(0,0.8,1) or Color3.fromRGB(40,40,45)
    end
end)

-- // ESP LOGIC
local function CreateESP(p)
    local folder = Instance.new("Folder", sg); folder.Name = "ESP_" .. p.Name
    local Joints = {{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}}
    local Lines = {}
    for i=1, #Joints do local l = Instance.new("CylinderHandleAdornment", folder); l.AlwaysOnTop = true; l.Radius = 0.15; l.Transparency = 0.2; l.ZIndex = 10; Lines[i] = l end
    Run.RenderStepped:Connect(function()
        if getgenv().ESP_Enabled and p.Character and p.Character:FindFirstChild("Humanoid") and p ~= LP and p.Character.Humanoid.Health > 0 then
            local color = (p:GetAttribute("Team") == LP:GetAttribute("Team")) and Color3.new(0,1,0) or Color3.new(1,0,0)
            for i, j in pairs(Joints) do
                local p1, p2 = p.Character:FindFirstChild(j[1]), p.Character:FindFirstChild(j[2])
                if p1 and p2 then
                    local dist = (p1.Position - p2.Position).Magnitude
                    Lines[i].Visible = true; Lines[i].Height = dist; Lines[i].CFrame = CFrame.new(p1.Position, p2.Position) * CFrame.new(0,0, -dist/2); Lines[i].Adornee = workspace.Terrain; Lines[i].Color3 = color
                else Lines[i].Visible = false end
            end
        else for _, l in pairs(Lines) do l.Visible = false end end
    end)
end

-- // BUCLES
Run.Heartbeat:Connect(function() if getgenv().AutoKill then local g, t = LP:GetAttribute("Game"), LP:GetAttribute("Team") for _, v in pairs(Services.Players:GetPlayers()) do if v ~= LP and v:GetAttribute("Game") == g and v:GetAttribute("Team") ~= t then RS.KnifeKill:FireServer(v, v) end end end end)
for _, v in pairs(Services.Players:GetPlayers()) do CreateESP(v) end
Services.Players.PlayerAdded:Connect(CreateESP)

-- // LOADER NEON CORREGIDO
local Loader = Instance.new("Frame", sg); Loader.Size = UDim2.new(0, 300, 0, 350); Loader.Position = UDim2.new(0.5, -150, 0.5, -175); Loader.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Loader)
local LSt = Instance.new("UIStroke", Loader); LSt.Color = Color3.new(1,0,0); LSt.Thickness = 2
local Img = Instance.new("ImageLabel", Loader); Img.Size = UDim2.new(0, 90, 0, 90); Img.Position = UDim2.new(0.5, -45, 0, 25); Img.Image = LL_IMAGE; Img.BackgroundTransparency = 1; Instance.new("UICorner", Img).CornerRadius = UDim.new(1,0)

task.spawn(function()
    local function T(txt, y, col)
        local l = Instance.new("TextLabel", Loader); l.Size = UDim2.new(1,0,0,25); l.Position = UDim2.new(0,0,0,y); l.BackgroundTransparency = 1; l.TextColor3 = col; l.Font = "Code"; l.TextSize = 14; l.Text = ""
        for i=1,#txt do l.Text = txt:sub(1,i); task.wait(0.04) end
    end
    T("Nota: Belfebu Edition", 130, Color3.new(1,1,1)); T("PC VERSION", 155, Color3.new(1,0,0)); T("GUNS.LOL: guns.lol/belfebu", 195, Color3.fromRGB(170,0,255)); T("Cargando Motor Zix...", 290, Color3.new(0.5,0.5,0.5))
    task.wait(2.5); Loader:Destroy(); Main.Visible = true; Notify("SISTEMA", "ZIX V47 Cargado (RightCtrl)")
end)
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)
