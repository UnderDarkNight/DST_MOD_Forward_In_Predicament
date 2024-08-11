----------------------------------------------------
--- 本文件单纯返还路径
----------------------------------------------------

-- local function sum(a, b)
--     return a + b
-- end

-- local info = debug.getinfo(sum)

-- for k,v in pairs(info) do
--         print(k,':', info[k])
-- end

--------------------------------------------------------------------------
local addr_test = debug.getinfo(1).source           ---- 找到绝对路径

local temp_str_index = string.find(addr_test, "scripts/prefabs/")
local temp_addr = string.sub(addr_test,temp_str_index,-1)
-- print("fake error 6666666666666:",temp_addr)    ---- 找到本文件所处的相对路径

local temp_str_index2 = string.find(temp_addr,"/__prefabs_list.lua")

local Prefabs_addr_base = string.sub(temp_addr,1,temp_str_index2) .. "/"    --- 得到最终文件夹路径

---------------------------------------------------------------------------
-- local Prefabs_addr_base = "scripts/prefabs/01_fwd_in_pdt_items/"               --- 文件夹路径
local prefabs_name_list = {

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
    "11_06_food_effect_a",                              -- 这是一个全部食物的effect，想让建家党也能享受食物buff

    "12_01_character_buff_carl_thirst_for_blood",                 -- 角色卡尔专属buff
    "12_02_character_buff_carl_thirst_for_blood__shadowheart",    -- 角色卡尔专属buff  暗影心房用的
    "12_03_character_buff_carl_shadowheart_damage",               -- 角色卡尔专属buff  暗影心房用的

    "13_fracture",                   -- 骨折
    "14_attack_miss",                   -- 打击miss
    "15_mouse_and_camera_crazy",                   -- 鼠标和镜头癫狂
    "16_attack_miss_blocker",               -- 失明屏蔽器
    
}


---------------------------------------------------------------------------
---- 正在测试的物品
if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    local debugging_name_list = {



    }
    for k, temp in pairs(debugging_name_list) do
        table.insert(prefabs_name_list,temp)
    end
end
---------------------------------------------------------------------------












local ret_addrs = {}
for i, v in ipairs(prefabs_name_list) do
    table.insert(ret_addrs,Prefabs_addr_base..v..".lua")
end
return ret_addrs