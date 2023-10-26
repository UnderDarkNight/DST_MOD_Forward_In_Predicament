local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/01_fwd_in_pdt_items/"
local Prefabs_name_list = {

    "00_gift_pack",
    "01_ice_core",                       ---- 冰核心
    "02_flame_core",                     ---- 火核心
    "03_jade_coin",                      -- 玉龙币 （绿、黑）
    "04_transport_stone",                -- 传送石，直接传送到岛上的
    "05_insulin_syringe",                -- 胰岛素注射器
    "06_disease_treatment_book",         -- 《伤寒病论》
    "07_book_of_harvest",                -- 《丰收之书》
    "08_medical_certificate",            -- 诊断单
    "09_locked_book",                    -- 被锁住的书
    "10_cursed_pig_skin",                -- 被诅咒的猪皮
    "11_book_of_gardening",              -- 《园艺之书》
    "12_book_of_newmoon",                -- 《新月之书》
    "13_formulated_crystal",             -- 工作台配方水晶
    "14_glass_pig_skin",                 -- 玻璃猪皮
    "15_glass_horn",                     -- 玻璃号角
    "16_synopsis",                       -- MOD说明书
    "17_advertising_leaflet",            -- 广告单

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
