--------------------------------------------------------------------------------------------------------
--- 所有 prefab 的加载入口
--- 每个小类里的文件名单，统一用 __prefabs_list.lua  ，注意每个lua文件里的目录str不一样。
--- 
--------------------------------------------------------------------------------------------------------

local file_folders = {
    "__fwd_in_pdt_debugging_prefabs", -- 正在调试内测的东西
    "00_fwd_in_pdt_others",           -- 其他无法归类的
    "01_fwd_in_pdt_items",            -- 物品/道具
    "02_fwd_in_pdt_materials",        -- 单纯的材料
    "03_fwd_in_pdt_equipments",       -- 可穿戴的装备
    "04_fwd_in_pdt_foods",            -- 可以吃的食物 / 或者种子
    "05_fwd_in_pdt_foods_cooked",     -- 烹饪出来的食物 / 或者种子
    "06_fwd_in_pdt_containers",       -- 带容器的东西（装备/建筑 等）
    "07_fwd_in_pdt_buildings",        -- 建筑
    "08_fwd_in_pdt_resources",        -- 无法归类的自然资源
    "09_fwd_in_pdt_plants",           -- 植物 + 种子
    "10_fwd_in_pdt_minerals",         -- 矿物
    "11_fwd_in_pdt_animals",          -- 各类动物/生物
    "12_fwd_in_pdt_boss",             -- BOSS
    "13_fwd_in_pdt_pets",             -- 宠物
    "14_fwd_in_pdt_turfs",            -- 地皮
    "15_fwd_in_pdt_debuffs",          -- Debuffs
    "16_fwd_in_pdt_spells",           -- 技能（一般用于制作栏）
    "17_fwd_in_pdt_FX",               -- 特效 FX
    "18_fwd_in_pdt_projectiles",      -- 弹药
    "19_fwd_in_pdt_characters",       -- 角色
    "20_fwd_in_pdt_events",           -- 事件、资源刷新器等
    "21_fwd_in_pdt_rooms",            -- 房间/岛屿 创建相关资源
    "22_fwd_in_pdt_npc",              -- NPC
}


local function Load_lua_file_2_prefabs_table(tempAddr)
    ---- tempAddr  :      "prefabs/XXX/XXX.lua"
    local function self_load_file_to_prefabs_by_pcall(pcall_retFlag,...)
        local ret_prefabs_table = {}
        local arg = {...}
        if pcall_retFlag == true then
            for i, v in ipairs(arg) do
                if v then
                    table.insert(ret_prefabs_table,v)
                end
            end
        else
            print("Error : Load lua file error : ")
            print("Error:  "..tostring(tempAddr))
            for k, v in pairs(arg) do
                if v then
                    print("Error:  "..v)
                end
            end
        end
        return ret_prefabs_table
    end

    local crash_flag,lua_file = pcall(loadfile,tempAddr)   ---- load lua file
    if crash_flag == true then
        local temp_prefabs = self_load_file_to_prefabs_by_pcall(pcall(lua_file))
        return temp_prefabs
    else
        print("loadfile lua_file  Error ")
        print(lua_file)
        return {}
    end
end


local all_prefabs = {}

for i, temp_folder in ipairs(file_folders) do
    ---- step 1 : 拼接得到小类文件夹路径，用 require 加载这个lua 路径 得到内部列表。
    local full_subclass_addr = "prefabs/"..temp_folder.."/__prefabs_list"              
    local crash_flag,temp_prefabs_addr_list = pcall(require,full_subclass_addr)

    ---- step 2 : 加载没崩溃的时候，根据这个列表，载入目标lua里的所有内容。
    if crash_flag == true then  
                for k, prefab_lua_addr in pairs(temp_prefabs_addr_list) do
                            local temp_prefabs_table = Load_lua_file_2_prefabs_table(prefab_lua_addr)  ----- 得到了每个lua 文件的返回内容。
                            for ii, temp_prefab in ipairs(temp_prefabs_table) do
                                if temp_prefab then
                                    table.insert(all_prefabs,temp_prefab)
                                end
                            end
                end
    else
        print("Load prefabs Error : temp_prefabs_addr_list")      
        print(temp_prefabs_addr_list)
    end

end

return unpack(all_prefabs)     --- unpack for PrefabFiles ( in modmian.lua  ) 