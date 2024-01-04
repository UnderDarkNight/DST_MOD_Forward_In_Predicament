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

    "13_mole_backpack",                  --- 鼹鼠背包

    "14_vampire_sword",                     --- 蝙蝠剑

    "15_ballon_in_hand_fx",             --- 气球 FX 统一，节省prefab
    "16_loong_balloon",                 --- 龙气球
    "17_balloon_evil_dragon",           --- 邪龙气球
    "18_bobble_loong",                  --- 泡泡龙气球

    "19_magic_spatula",                  --- 魔法锅铲
    "20_shield_of_light",                --- 光之护盾

    
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