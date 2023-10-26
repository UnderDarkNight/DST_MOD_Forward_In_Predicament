local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/05_fwd_in_pdt_foods_cooked/"
local Prefabs_name_list = {

    "01_mixed_potato_soup",                          -- 疙瘩汤
    "02_orange_with_honey",                          -- 蜂蜜蒸橙
    "03_scrambled_eggs_with_tomatoes",               -- 番茄炒蛋
    "04_eggplant_casserole",                         -- 茄子盒
    "05_gifts_of_nature",                            -- 自然的馈赠
    "06_snake_skin_jelly",                           -- 蛇皮冻
    "07_atractylodes_macrocephala_pills",            -- 苍术药丸
    "08_pinellia_ternata_pills",                     -- 半夏药丸
    "09_aster_tataricus_l_f_pills",                  -- 紫苑药丸
    "10_red_mushroom_soup",                          -- 红伞伞蘑菇汤
    "11_green_mushroom_soup",                        -- 绿伞伞蘑菇汤
    "12_tofu",                                       -- 豆腐
    "13_stinky_tofu",                                -- 臭豆腐
    "14_cooked_milk",                                -- 熟牛奶
    "15_yogurt",                                     -- 酸奶
    "16_coffee",                                     -- 咖啡
    "17_saline_medicine",                            -- 生理盐水
    "18_yogurt_ice_cream",                           -- 酸奶冰淇淋
    "19_mango_ice_drink",                            -- 杨枝甘露
    "20_cooked_rice",                                -- 白米饭
    "21_bread",                                      -- 面包
    "22_thousand_year_old_egg",                      -- 皮蛋
    "23_congee_with_meat_and_thousand_year_old_eggs",       -- 皮蛋肉粥
    "24_protein_powder",                             -- 蛋白质粉
    "25_stinky_tofu_salad",                          -- 臭豆腐沙拉
    "26_stinky_tofu_bolognese",                      -- 臭豆腐肉酱

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
