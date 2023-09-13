----------------------------------------------------
--- 本文件单纯返还路径
----------------------------------------------------
--------------------------------------------------------------------------
local addr_test = debug.getinfo(1).source           ---- 找到绝对路径

local temp_str_index = string.find(addr_test, "scripts/prefabs/")
local temp_addr = string.sub(addr_test,temp_str_index,-1)
-- print("fake error 6666666666666:",temp_addr)    ---- 找到本文件所处的相对路径

local temp_str_index2 = string.find(temp_addr,"/__prefabs_list.lua")

local Prefabs_addr_base = string.sub(temp_addr,1,temp_str_index2) .. "/"    --- 得到最终文件夹路径

---------------------------------------------------------------------------

-- local Prefabs_addr_base = "scripts/prefabs/05_fwd_in_pdt_foods_cooked/"
local prefabs_name_list = {
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