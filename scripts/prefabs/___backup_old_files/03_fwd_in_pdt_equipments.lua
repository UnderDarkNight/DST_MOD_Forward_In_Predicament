local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/03_fwd_in_pdt_equipments/"
local Prefabs_name_list = {

    "01_blazing_nightmaresword",    --- 炽热暗影剑
    "02_frozen_nightmaresword",     --- 极寒暗影剑

    "03_blazing_hambat",             --- 炽热火腿棒
    "04_frozen_hambat",             --- 极寒火腿棒

    "05_blazing_spear",             --- 炽热长矛
    "06_frozen_spear",             --- 极寒长矛

    "07_repair_staff",             --- 修复法杖

    "08_glass_pig_chesspiece",     --- 玻璃猪雕像
    "09_cursed_pig_chesspiece",     --- 诅咒猪雕像
    "10_glass_beefalo_chesspiece",     --- 玻璃牛

    "11_huge_soybean",                  --- 巨大豆荚
    "12_huge_orange",                  --- 巨大橙子

    "13_mole_backpack",                  --- 零食鼠背包

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
