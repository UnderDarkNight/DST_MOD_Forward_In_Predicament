local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/04_fwd_in_pdt_foods/"
local Prefabs_name_list = {

    "01_raw_milk",                           --- 生牛奶
    "02_andrographis_paniculata_botany",     --- 雄黄饮剂
    "03_universal_antidote",                 --- 万能解毒剂
    "04_rise",                               --- 脱壳的稻米
    "05_wheat_flour",                        --- 面粉
    "06_mango",                              --- 芒果（两种）
    "07_orange",                             --- 橙子
    "08_soybeans",                           --- 大豆
    "09_coffebeans",                         --- 咖啡豆

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
