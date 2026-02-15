--[[ 
    ZIX UNIVERSAL LOADER V35.1
    - Detecta automáticamente PC o MOBILE.
    - Sintaxis Correcta: loadstring(game:HttpGet("link", true))()
]]

local UIS = game:GetService("UserInputService")

-- // CONFIGURACIÓN DE LINKS
local PC_LINK = "TU_LINK_DE_PC_AQUÍ"
local MOBILE_LINK = "TU_LINK_DE_MOBILE_AQUÍ"

-- // DETECCIÓN DE PLATAFORMA
local isMobile = false

-- Si tiene táctil y no tiene teclado, o es una tablet
if UIS.TouchEnabled and (not UIS.KeyboardEnabled or UIS.OnCanExternalInventoryInterfaceUpdate) then
    isMobile = true
end

-- // EJECUCIÓN
if isMobile then
    print("ZIX: Ejecutando versión MOBILE...")
    loadstring(game:HttpGet(MOBILE_LINK, true))()
else
    print("ZIX: Ejecutando versión PC...")
    loadstring(game:HttpGet(PC_LINK, true))()
end
