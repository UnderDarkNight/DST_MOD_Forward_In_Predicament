local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/18_fwd_in_pdt_projectiles/"
local Prefabs_name_list = {

    -- "01_paddy_rice",                     --- 水稻



}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
