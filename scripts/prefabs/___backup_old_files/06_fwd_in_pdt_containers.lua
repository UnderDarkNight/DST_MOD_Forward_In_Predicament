local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/06_fwd_in_pdt_containers/"
local Prefabs_name_list = {

    "01_fish_farm",                           --- 养鱼池
    "02_moon_jewelry_lamp",                   --- 天体宝珠灯
    "03_special_production_table",            --- 特殊工作台
    "04_fermenter",                           --- 发酵缸
    "05_special_cookpot",                     --- 万能烹饪锅

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
