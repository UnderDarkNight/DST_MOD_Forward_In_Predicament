local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/23_fwd_in_pdt_wellness/"
local Prefabs_name_list = {

    "01_base_wellness",     -- 体质值
    "02_vitamin_c",         -- VC值
    "03_glucose",           -- 血糖值
    "03_glucose",           -- 血糖值
    "04_01_poison",            -- 中毒值
    "04_02_poison_blocker",            -- 中毒屏蔽计数器

    "05_snake_poison",            -- 蛇毒
    "06_frog_poison",             -- 青蛙毒
    "07_spider_poison",           -- 蜘蛛毒
    "08_bee_poison",              -- 蜜蜂毒

    "09_cough",                   -- 咳嗽
    "10_fever",                   -- 发烧

    "11_01_food_effect_green_mushroom_soup",            -- 绿蘑菇汤 的debuff
    "11_02_food_effect_coffee",                         -- 咖啡 的buff
    "11_03_food_effect_mango_ice_drink",                -- 杨枝甘露 的 buff
    "11_04_food_effect_thousand_year_old_egg",          -- 皮蛋 的 buff
    "11_05_food_effect_protein_powder",                 -- 蛋白质粉 的 buff

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
