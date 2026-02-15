--[[
    ZIXN LOADER V7 - SYNCED CONNECTION
    - Developer: zixn1gga
    - Sistema de Idiomas: Nota y Carga [2026-02-08]
]]

local Services = setmetatable({}, {
    __index = function(t, k) return game:GetService(k) end
})

local LocalPlayer = Services.Players.LocalPlayer
local TweenService = Services.TweenService

-- // CONFIGURACIÓN (REEMPLAZA ESTO)
local GitHubMain = "https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/main.lua"

local Config = {
    BG = Color3.fromRGB(10, 10, 12),
    Accent = Color3.fromRGB(255, 0, 80),
    Links = { Guns = "guns.lol/mixsito", Discord = "discord.gg/zixn" }
}

-- IDIOMAS (Nota y Cargando Motor)
local T = (Services.LocalizationService.RobloxLocaleId:lower():sub(1,2) == "es") 
    and {Load = "Cargando Motor..."} 
    or {Load = "Loading Engine..."}

-----------------------------------------------------------
-- DISEÑO DEL LOADER
-----------------------------------------------------------

local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "ZixnLoader_V7"
sg.ResetOnSpawn = false

local Loader = Instance.new("Frame", sg)
Loader.Size = UDim2.new(0, 300, 0, 320)
Loader.Position = UDim2.new(0.5, -150, 0.5, -160)
Loader.BackgroundColor3 = Config.BG
Loader.BorderSizePixel = 0
Loader.ZIndex = 10
Instance.new("UICorner", Loader).CornerRadius = UDim.new(0, 15)

-- Imagen de Perfil
local Profile = Instance.new("ImageLabel", Loader)
Profile.Size = UDim2.new(0, 90, 0, 90); Profile.Position = UDim2.new(0.5, -45, 0, 30)
Profile.Image = "rbxassetid://138873321650261"; Profile.BackgroundTransparency = 1; Profile.ZIndex = 11
Instance.new("UICorner", Profile).CornerRadius = UDim.new(1, 0)

-- Función para crear líneas de texto con iconos
local function CreateLine(y, icon)
    local f = Instance.new("Frame", Loader); f.Size = UDim2.new(1, -60, 0, 35); f.Position = UDim2.new(0, 30, 0, y); f.BackgroundTransparency = 1
    local img = Instance.new("ImageLabel", f); img.Size = UDim2.new(0, 22, 0, 22); img.Position = UDim2.new(0, 0, 0.5, -11); img.Image = icon; img.BackgroundTransparency = 1; img.ZIndex = 11
    local txt = Instance.new("TextLabel", f); txt.Size = UDim2.new(1, -35, 1, 0); txt.Position = UDim2.new(0, 35, 0, 0); txt.BackgroundTransparency = 1; txt.Font = "Code"; txt.TextColor3 = Color3.fromRGB(180, 180, 180); txt.TextSize = 14; txt.TextXAlignment = 0; txt.Text = ""; txt.ZIndex = 11
    return txt
end

local GunsL = CreateLine(180, "rbxassetid://113219471392614")
local DiscL = CreateLine(220, "rbxassetid://114986496739342")
local LoadL = CreateLine(265, "rbxassetid://138873321650261")

local function TypeWrite(label, text)
    for i = 1, #text do label.Text = string.sub(text, 1, i) task.wait(0.04) end
end

-----------------------------------------------------------
-- EJECUCIÓN Y CONEXIÓN
-----------------------------------------------------------

task.spawn(function()
    -- Efecto de escritura
    TypeWrite(GunsL, Config.Links.Guns)
    TypeWrite(DiscL, Config.Links.Discord)
    TypeWrite(LoadL, T.Load)
    
    task.wait(1.2)
    
    -- Animación de salida suave (hacia arriba)
    local out = TweenService:Create(Loader, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -150, -0.7, 0)
    })
    out:Play()
    out.Completed:Wait()
    
    -- CARGAR EL MAIN SCRIPT (V7)
    local success, err = pcall(function()
        loadstring(game:HttpGet(GitHubMain))()
    end)
    
    if not success then
        warn("ZIXN ERROR: No se pudo conectar al Main Script. Verifica el link de GitHub.")
    end
    
    -- Limpiar el loader de la pantalla
    sg:Destroy()
end)
