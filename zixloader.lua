--[[ 
  you dont gonna have the src nigga
]]

local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local PC_LINK = "https://raw.githubusercontent.com/zisxgszixsg-cmyk/very-ghoodf-scirptr/refs/heads/main/pc.lua"
local MOBILE_LINK = "https://raw.githubusercontent.com/zisxgszixsg-cmyk/very-ghoodf-scirptr/refs/heads/main/mobile.lua"

-- // Detección Mejorada (Safe Check)
local function GetPlatform()
    -- Si tiene Touch y NO tiene Teclado, es Mobile de calle
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
        return "MOBILE"
    end
    
    -- Si tiene Touch pero detecta teclado (posible emulador o tablet), 
    -- usamos GuiService para ver si la UI es táctil
    if UIS.TouchEnabled and UIS.KeyboardEnabled then
        return "MOBILE"
    end

    -- Check de respaldo para ejecutores de celular que se identifican mal
    if not UIS.KeyboardEnabled and not UIS.MouseEnabled then
        return "MOBILE"
    end

    return "PC"
end

local platform = GetPlatform()

-- // Ejecución con Manejo de Errores
if platform == "MOBILE" then
    warn("ZIX: [PLATFORM DETECTED: MOBILE]")
    local success, err = pcall(function()
        loadstring(game:HttpGet(MOBILE_LINK, true))()
    end)
    if not success then
        print("Error cargando Mobile Link: " .. tostring(err))
        -- Reintento forzado por si el GetHttp falló
        task.wait(1)
        loadstring(game:HttpGet(MOBILE_LINK))()
    end
else
    warn("ZIX: [PLATFORM DETECTED: PC]")
    local success, err = pcall(function()
        loadstring(game:HttpGet(PC_LINK, true))()
    end)
    if not success then
        print("Error cargando PC Link: " .. tostring(err))
    end
end
