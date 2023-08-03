if TUNING["Forward_In_Predicament.Strings"] == nil then
    TUNING["Forward_In_Predicament.Strings"] = {}
end

local this_language = "ch"
-- if TUNING["Forward_In_Predicament.Language"] then
--     if type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() ~= this_language then
--         return
--     elseif type(TUNING["Forward_In_Predicament.Language"]) == "string" and TUNING["Forward_In_Predicament.Language"] ~= this_language then
--         return
--     end
-- end

--------- 默认加载中文文本，如果其他语言的文本缺失，直接调取 中文文本。 03_TUNING_Common_Func.lua
--------------------------------------------------------------------------------------------------
--- 默认显示名字:  name
--- 默认显示描述:  inspect_str
--- 默认制作栏描述: recipe_desc
--------------------------------------------------------------------------------------------------
TUNING["Forward_In_Predicament.Strings"][this_language] = TUNING["Forward_In_Predicament.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            ["fwd_in_pdt_skin_test_item"] = {
                ["name"] = "皮肤测试物品",
                ["inspect_str"] = "inspect单纯的测试皮肤",
                ["recipe_desc"] = "测试描述666",
            },
            ["fwd_in_pdt_with_blocked_mods"] = {
                ["mods_ban"] = "检测到有冲突的MOD，本MOD停止加载。有冲突的MOD为：",
                ["prefab_block"] = "检测到有冲突的MOD。为保持本MOD的流畅体验，将终止游戏运行。冲突原因：",
                ["maxsize_block"] = "物品叠堆数量过高。本MOD与这类MOD兼容性较差。为保证本MOD的流畅体验，将关闭游戏。",
                ["has_not_cave"]  = "未检测到有洞穴加载，本MOD功能缺失，将终止游戏运行",
            },
        --------------------------------------------------------------------
        ---- UI
            ["fwd_in_pdt_ui_craftingmenu"] = {        ---- 制作栏
                ["FWD_IN_PDT_BUILDINGS"] = "黑夜建筑"
            },
        --------------------------------------------------------------------
        ---- actions
            ["fwd_in_pdt_com_skins_tool"] = { 
                ["NEXT"] = "下一个外观",
                ["LAST"] = "上一个外观",
            },
            ["sleeping_tent_action"] = { 
                ["join"] = "睡觉"
            },
            ["fwd_in_pdt_com_whip_action"] = { 
                ["DEFAULT"] = "抽",
                ["MIRROR"] = "镜像"
            },
            ["fwd_in_pdt_com_acceptable"] = { 
                ["DEFAULT"] = "给",
                ["fertilize"] = "施肥"
            },
            ["fwd_in_pdt_com_special_acceptable"] = { 
                ["DEFAULT"] = "给",
                ["fertilize"] = "施肥"
            },
            ["fwd_in_pdt_com_workable"] = { 
                ["DEFAULT"] = "工作",
            },
            ["fwd_in_pdt_com_special_workable"] = { 
                ["DEFAULT"] = "工作",
            },
            ["fwd_in_pdt_com_weapon"] = { 
                ["DEFAULT"] = "执行",
            },
        --------------------------------------------------------------------
        ---- 00_fwd_in_pdt_others
        --------------------------------------------------------------------
        ---- 01_fwd_in_pdt_items
            ["fwd_in_pdt_gift_pack"] = {
                ["name"] = "礼物盒",
                ["inspect_str"] = "一个礼物盒"
            },
        --------------------------------------------------------------------
        ---- 02_fwd_in_pdt_materials
        --------------------------------------------------------------------
        ---- 03_fwd_in_pdt_equipments
            ["fwd_in_pdt_eq_mirror_whip"] = {
                ["name"] = "镜像鞭子",
                ["inspect_str"] = "某些东西可以被抽得镜像"
            },
        --------------------------------------------------------------------
        ---- 04_fwd_in_pdt_foods
        --------------------------------------------------------------------
        ---- 05_fwd_in_pdt_foods_cooked
        --------------------------------------------------------------------
        ---- 06_fwd_in_pdt_containers
        --------------------------------------------------------------------
        ---- 07_fwd_in_pdt_buildings
            ["fwd_in_pdt_building_mock_wall_grass"] = {
                ["name"] = "拟态墙·草",
                ["inspect_str"] = "这是一堵墙...而不是植物....",
                ["recipe_desc"] = "伪装成植物的墙",
            },
        --------------------------------------------------------------------
        ---- 08_fwd_in_pdt_resources
        --------------------------------------------------------------------
        ---- 09_fwd_in_pdt_plants
        --------------------------------------------------------------------
        ---- 10_fwd_in_pdt_minerals
        --------------------------------------------------------------------
        ---- 11_fwd_in_pdt_animals
        --------------------------------------------------------------------
        ---- 12_fwd_in_pdt_boss
        --------------------------------------------------------------------
        ---- 13_fwd_in_pdt_pets
        --------------------------------------------------------------------
        ---- 14_fwd_in_pdt_turfs
        --------------------------------------------------------------------
        ---- 15_fwd_in_pdt_debuffs
        --------------------------------------------------------------------
        ---- 16_fwd_in_pdt_spells
        --------------------------------------------------------------------
        ---- 17_fwd_in_pdt_FX
        --------------------------------------------------------------------
        ---- 18_fwd_in_pdt_projectiles
        --------------------------------------------------------------------
        ---- 19_fwd_in_pdt_characters

        --------------------------------------------------------------------
}

