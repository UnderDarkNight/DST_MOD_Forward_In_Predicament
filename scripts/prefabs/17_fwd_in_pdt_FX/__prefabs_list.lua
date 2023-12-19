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
    "12_shadow_shell",              --- 暗影护盾
    "13_shadow_feather",            --- 暗影羽毛
    "14_shadow_bats",               --- 暗影主教的蝙蝠
    "15_red_bats",                  --- 红色蝙蝠群
    "16_red_bats_mark",             --- 红色蝙蝠群 标记模式
    "17_explode",                   --- 爆炸

    
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