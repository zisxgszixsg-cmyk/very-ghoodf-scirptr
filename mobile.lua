local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LP, RS, Run, TS = Services.Players.LocalPlayer, Services.ReplicatedStorage, Services.RunService, Services.TweenService

getgenv().AutoKill = false
getgenv().ESP_Enabled = false
local LL_IMAGE = "rbxassetid://138873321650261"

-- // LIMPIEZA INICIAL
if LP.PlayerGui:FindFirstChild("Zix_Mobile") then LP.PlayerGui.Zix_Mobile:Destroy() end

local sg = Instance.new("ScreenGui", LP.PlayerGui); sg.Name = "Zix_Mobile"; sg.ResetOnSpawn = false

-- // NOTIFICACIONES
local function Notify(title, msg)
    local n = Instance.new("Frame", sg); n.Size = UDim2.new(0, 200, 0, 50); n.Position = UDim2.new(0.5, -100, 0, -60); n.BackgroundColor3 = Color3.fromRGB(15, 15, 20); n.BorderSizePixel = 0
    Instance.new("UICorner", n); Instance.new("UIStroke", n).Color = Color3.fromRGB(255, 50, 50)
    local tl = Instance.new("TextLabel", n); tl.Size = UDim2.new(1,0,0,20); tl.Position = UDim2.new(0,10,0,5); tl.Text = title; tl.TextColor3 = Color3.new(1,0,0); tl.Font = "GothamBold"; tl.TextSize = 12; tl.BackgroundTransparency = 1; tl.TextXAlignment = "Left"
    local ml = Instance.new("TextLabel", n); ml.Size = UDim2.new(1,0,0,20); ml.Position = UDim2.new(0,10,0,22); ml.Text = msg; ml.TextColor3 = Color3.new(1,1,1); ml.Font = "Gotham"; ml.TextSize = 10; ml.BackgroundTransparency = 1; ml.TextXAlignment = "Left"
    n:TweenPosition(UDim2.new(0.5, -100, 0, 20), "Out", "Back", 0.5, true)
    task.wait(2.5); n:TweenPosition(UDim2.new(0.5, -100, 0, -60), "In", "Quad", 0.5, true); task.wait(0.6); n:Destroy()
end

-- // COMANDOS DE CHAT
local function SendChat(m)
    pcall(function()
        local TCS = game:GetService("TextChatService")
        if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
            TCS.TextChannels.RBXGeneral:SendAsync(m)
        else
            RS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(m, "All")
        end
        Notify("CHAT", "Enviado con éxito")
    end)
end

LP.Chatted:Connect(function(msg)
    local low = msg:lower()
    if low:sub(1,5) == "!say " then SendChat(msg:sub(6))
    elseif low == ".die" or low == "die" then if LP.Character then LP.Character.Humanoid.Health = 0 end end
end)

-- // UI PRINCIPAL
local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 260, 0, 310); Main.Position = UDim2.new(0.5, -130, 0.5, -155); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Main.Visible = false
Instance.new("UICorner", Main); local St = Instance.new("UIStroke", Main); St.Color = Color3.new(1,0,0); St.Thickness = 2

-- // DRAG SYSTEM (MÓVIL)
local function MakeDrag(f)
    local dragging, dragStart, startPos
    f.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = f.Position end
    end)
    f.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    f.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end
MakeDrag(Main)

-- // BOLITA FLOTANTE
local Ball = Instance.new("ImageButton", sg); Ball.Size = UDim2.new(0, 55, 0, 55); Ball.Position = UDim2.new(0.1, 0, 0.15, 0); Ball.Image = LL_IMAGE; Ball.Visible = false; Ball.BackgroundColor3 = Color3.new(0,0,0); Ball.ZIndex = 10; Instance.new("UICorner", Ball).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Ball).Color = Color3.new(1,0,0)
MakeDrag(Ball)
Ball.MouseButton1Click:Connect(function() Main.Visible = true; Ball.Visible = false end)

-- // BOTONES DE CONTROL (MINIMIZAR Y CERRAR)
local Mini = Instance.new("TextButton", Main); Mini.Size = UDim2.new(0, 30, 0, 30); Mini.Position = UDim2.new(0.72, 0, 0, 5); Mini.Text = "—"; Mini.TextColor3 = Color3.new(1,0,0); Mini.BackgroundTransparency = 1; Mini.TextSize = 25
Mini.MouseButton1Click:Connect(function() Main.Visible = false; Ball.Visible = true end)

local ExitBtn = Instance.new("TextButton", Main); ExitBtn.Size = UDim2.new(0, 30, 0, 30); ExitBtn.Position = UDim2.new(0.87, 0, 0, 5); ExitBtn.Text = "X"; ExitBtn.TextColor3 = Color3.new(1,0,0); ExitBtn.BackgroundTransparency = 1; ExitBtn.TextSize = 22; ExitBtn.Font = "GothamBold"
ExitBtn.MouseButton1Click:Connect(function() 
    getgenv().AutoKill = false
    getgenv().ESP_Enabled = false
    sg:Destroy() 
end)

-- // CREADOR DE BOTONES DINÁMICO
local function CreateBtn(txt, y, cb)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0.9, 0, 0, 55); b.Position = UDim2.new(0.05,0,0,y); b.BackgroundColor3 = Color3.fromRGB(20,20,25); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 12; b.AutoButtonColor = false
    Instance.new("UICorner", b); local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(45,45,50)
    b.MouseButton1Click:Connect(function() pcall(function() cb(b, s) end) end)
end

CreateBtn("ATAQUE MANUAL", 45, function()
    local g, t = LP:GetAttribute("Game"), LP:GetAttribute("Team")
    for _, v in pairs(Services.Players:GetPlayers()) do if v ~= LP and v:GetAttribute("Game") == g and v:GetAttribute("Team") ~= t then RS.KnifeKill:FireServer(v, v) end end
    Notify("ATAQUE", "Manual ejecutado")
end)

CreateBtn("AUTO-KILL: OFF", 115, function(b, s)
    getgenv().AutoKill = not getgenv().AutoKill
    b.Text = "AUTO-KILL: " .. (getgenv().AutoKill and "ON" or "OFF")
    b.TextColor3 = getgenv().AutoKill and Color3.new(0,1,0.6) or Color3.new(1,1,1)
    s.Color = getgenv().AutoKill and Color3.new(0,1,0.6) or Color3.fromRGB(45,45,50)
end)

CreateBtn("SKELETON ESP: OFF", 185, function(b, s)
    getgenv().ESP_Enabled = not getgenv().ESP_Enabled
    b.Text = "SKELETON ESP: " .. (getgenv().ESP_Enabled and "ON" or "OFF")
    b.TextColor3 = getgenv().ESP_Enabled and Color3.new(0,0.8,1) or Color3.new(1,1,1)
    s.Color = getgenv().ESP_Enabled and Color3.new(0,0.8,1) or Color3.fromRGB(45,45,50)
end)

-- // ESP SKELETON (FIX: NIL WITH TEXT SAFE)
local function CreateESP(p)
    local f = Instance.new("Folder", sg); f.Name = "ESP_" .. p.Name
    local Joints = {{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}}
    local Lines = {}
    for i=1, #Joints do local l = Instance.new("CylinderHandleAdornment", f); l.AlwaysOnTop = true; l.Radius = 0.12; l.Transparency = 0.2; l.ZIndex = 5; Lines[i] = l end
    Run.RenderStepped:Connect(function()
        if sg.Parent and getgenv().ESP_Enabled and p.Character and p.Character:FindFirstChild("Humanoid") and p ~= LP and p.Character.Humanoid.Health > 0 then
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

-- // LOOPS ACTIVOS
Run.Heartbeat:Connect(function() if getgenv().AutoKill then local g, t = LP:GetAttribute("Game"), LP:GetAttribute("Team") for _, v in pairs(Services.Players:GetPlayers()) do if v ~= LP and v:GetAttribute("Game") == g and v:GetAttribute("Team") ~= t then RS.KnifeKill:FireServer(v, v) end end end end)
for _, v in pairs(Services.Players:GetPlayers()) do CreateESP(v) end
Services.Players.PlayerAdded:Connect(CreateESP)

-- // LOADER NEON PRO
local Loader = Instance.new("Frame", sg); Loader.Size = UDim2.new(0, 300, 0, 350); Loader.Position = UDim2.new(0.5, -150, 0.5, -175); Loader.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Loader)
local LSt = Instance.new("UIStroke", Loader); LSt.Color = Color3.new(1,0,0); LSt.Thickness = 2
local Img = Instance.new("ImageLabel", Loader); Img.Size = UDim2.new(0, 90, 0, 90); Img.Position = UDim2.new(0.5, -45, 0, 25); Img.Image = LL_IMAGE; Img.BackgroundTransparency = 1; Instance.new("UICorner", Img).CornerRadius = UDim.new(1,0)

task.spawn(function()
    local function T(txt, y, col)
        local l = Instance.new("TextLabel", Loader); l.Size = UDim2.new(1,0,0,25); l.Position = UDim2.new(0,0,0,y); l.BackgroundTransparency = 1; l.TextColor3 = col; l.Font = "Code"; l.TextSize = 14; l.Text = ""
        for i=1,#txt do l.Text = txt:sub(1,i); task.wait(0.04) end
    end
    T("Nota: Belfebu Edition", 130, Color3.new(1,1,1)); T("MOBILE VERSION", 155, Color3.new(1,0,0)); T("GUNS.LOL: guns.lol/belfebu", 195, Color3.fromRGB(170,0,255)); T("Cargando Motor Mobile...", 300, Color3.new(0.5,0.5,0.5))
    task.wait(2.5); Loader:Destroy(); Main.Visible = true; Notify("SISTEMA", "ZIX MOBILE V48 LISTO")
end)
