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
        --------------------------------------------------------------------
        --- others 其他无法归类的
            ["fwd_in_pdt_with_blocked_mods"] = {
                ["mods_ban"] = "检测到有冲突的MOD，本MOD停止加载。有冲突的MOD为：",
                ["prefab_block"] = "检测到有冲突的MOD。为保持本MOD的流畅体验，将终止游戏运行。冲突原因：",
                ["maxsize_block"] = "物品叠堆数量过高。本MOD与这类MOD兼容性较差。为保证本MOD的流畅体验，将关闭游戏。",
                ["has_not_cave"]  = "未检测到有洞穴加载，本MOD功能缺失，将终止游戏运行",
            },
            ["fwd_in_pdt_cd_key_sys"] = {
                ["succeed_announce"] = "天空一声巨响，VIP会员【XXXXXX】闪亮登场",
                ["bad_key.talker"] = "【负重前行】",
                ["bad_key.str"] = "检测到和其他玩家相同的CD-KEY，请注意隐私保护！！",
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
            ["fwd_in_pdt_item_jade_coin_green"] = {
                ["name"] = "玉龙币·翠",
                ["inspect_str"] = "一种玉石做的货币，翠绿且充满活力",
                ["action_str"]  = "转换",
            },
            ["fwd_in_pdt_item_jade_coin_black"] = {
                ["name"] = "玉龙币·墨",
                ["inspect_str"] = "一种玉石做的货币，黑得深邃且悠远",
                ["action_str"]  = "转换",
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
            ["fwd_in_pdt_resource_glacier_huge"] = {
                ["name"] = "巨大的冰川",
                ["inspect_str"] = "这冰川好大，还终年不融化",
            },
            ["fwd_in_pdt_resource_glacier_small"] = {
                ["name"] = "冰川",
                ["inspect_str"] = "这冰川好奇怪，终年不融化",
            },
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
        ---- 20_fwd_in_pdt_events
        --------------------------------------------------------------------
        ---- 21_fwd_in_pdt_rooms
            ["fwd_in_pdt__rooms_quirky_red_tree"] = {
                ["name"] = "古怪的红叶树",
                ["inspect_str"] = "这树木特别古怪，有种不祥的气息",
            },
            ["fwd_in_pdt__rooms_quirky_red_tree_special"] = {
                ["name"] = "古怪的红叶树",
                ["inspect_str"] = "这树木特别古怪，有种不祥的气息",
            },
            ["fwd_in_pdt__rooms_mini_portal_door"] = {
                ["name"] = "迷你传送门",
                ["inspect_str"] = "这门不会出事故吧？",
                ["action_str"] = "使用",
            },
        --------------------------------------------------------------------
}

