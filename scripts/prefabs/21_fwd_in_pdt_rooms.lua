local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/21_fwd_in_pdt_rooms/"
local Prefabs_name_list = {

    "01_island_creater",            --- 岛屿创建器
    "02_resources_occupancy_sign",  --- 资源占位符
    "03_quirky_red_leaf_tree",      --- 传送树，下洞穴的
    "04_mini_portal_door",      --- 迷你传送门。给两个独特岛屿用的
    
}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
