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

    

}


---------------------------------------------------------------------------
---- 通过开关加载/关闭 角色
if TUNING["Forward_In_Predicament.Config"].ALLOW_CHARACTERS then
    local temp_file_list = {
        "01_01_carl_none",          ---- 皮肤prefab
        "01_02_carl",               ---- 角色prefab

        "02_01_cyclone_nonoe",          ---- 皮肤prefab
        "02_02_cyclone",               ---- 角色prefab
        "02_03_beard_spell_item",               ---- 胡子技能物品
        "02_04_cyclone_skeleton",               ---- 客制化骷髅
    }
    for k, v in pairs(temp_file_list) do
        table.insert(prefabs_name_list,v)
    end
end
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