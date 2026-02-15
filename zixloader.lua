--[[ 
YOU DONT GONNA HAVE THE SRC CODE NIGGA 
   LOL
]]

local UIS = game:GetService("UserInputService")

local PC_LINK = "https://raw.githubusercontent.com/zisxgszixsg-cmyk/very-ghoodf-scirptr/refs/heads/main/pc.lua"
local MOBILE_LINK = "https://raw.githubusercontent.com/zisxgszixsg-cmyk/very-ghoodf-scirptr/refs/heads/main/mobile.lua"

local isMobile = false

if UIS.TouchEnabled and (not UIS.KeyboardEnabled or UIS.OnCanExternalInventoryInterfaceUpdate) then
    isMobile = true
end

if isMobile then
    print("ZIX: Ejecutando versión MOBILE...")
    loadstring(game:HttpGet(MOBILE_LINK, true))()
else
    print("ZIX: Ejecutando versión PC...")
    loadstring(game:HttpGet(PC_LINK, true))()
end
