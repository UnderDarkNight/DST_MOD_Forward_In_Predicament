local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/17_fwd_in_pdt_FX/"
local Prefabs_name_list = {

    "01_fx_knowledge_flash",    --- 知识闪光
    "02_fx_collapse",           --- 烟雾
    "03_recipe_funcion",        --- 函数符号
    "04_recipe_star",            --- 星星
    "05_waterspout",            --- 水花爆炸(三叉戟)
    "06_splash_sink",            --- 水花爆炸（物品掉落）
    "07_ice_broke_up",            --- 冰块爆炸
    "08_orange_leaves_fall_down",            --- 橙色树叶落下
    "09_flame_up",            --- 火焰冒出
    "10_red_leaves_fall_down",            --- 红色树叶落下
    "11_sky_door",            --- 天空的传送门
}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
