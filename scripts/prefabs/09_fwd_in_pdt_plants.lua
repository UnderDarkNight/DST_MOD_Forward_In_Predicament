local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/09_fwd_in_pdt_plants/"
local Prefabs_name_list = {

    "01_paddy_rice",                     --- 水稻
    "01_paddy_rice_seed",                --- 水稻种子
    "02_wheat",                          --- 小麦
    "02_wheat_seed",                        --- 麦种
    "03_atractylodes_macrocephala",         --- 苍术
    "03_atractylodes_macrocephala_seed",    --- 苍术种子
    "04_pinellia_ternata",                  --- 半夏
    "04_pinellia_ternata_seed",             --- 半夏种子
    "05_aster_tataricus_l_f",               --- 紫苑
    "05_aster_tataricus_l_f_seed",          --- 紫苑种子
    "06_coffeebush",                        --- 咖啡丛
    "06_coffeebush_item",                   --- 咖啡丛
    "07_mango_tree",                        --- 芒果树
    "07_mango_tree_item",                   --- 芒果树芽穂
    "08_bean",                              --- 大豆
    "08_bean_seed",                         --- 大豆种子
    "09_orange",                            --- 橙子
    "09_orange_seed",                       --- 橙子种子


}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
