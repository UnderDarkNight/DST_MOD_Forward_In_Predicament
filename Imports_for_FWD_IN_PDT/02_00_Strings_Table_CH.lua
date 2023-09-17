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
                ["fertilize"] = "施肥",
                ["fwd_in_pdt_element_cores"] = "附魔",
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
            ["fwd_in_pdt_item_ice_core"] = {
                ["name"] = "极冰冷核",
                ["inspect_str"] = "这里面封存着寒冷"
            },
            ["fwd_in_pdt_item_flame_core"] = {
                ["name"] = "炽焰光核",
                ["inspect_str"] = "这里面封存着火焰"
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
            ["fwd_in_pdt_item_transport_stone"] = {
                ["name"] = "微型传送石",
                ["inspect_str"] = "传送到红树岛或者黑市",
            },
            ["fwd_in_pdt_item_insulin_syringe"] = {
                ["name"] = "胰岛素注射器",
                ["inspect_str"] = "降低血糖用的",
                ["recipe_desc"] = "降低血糖用的注射针剂",
            },
            ["fwd_in_pdt_item_disease_treatment_book"] = {
                ["name"] = "《伤寒病论》",
                ["inspect_str"] = "治疗一些疾病的魔法书",
                ["recipe_desc"] = "治疗一些疾病的魔法书",
                ["action_fail"] = "我现在没有需要治疗的疾病"
            },
            ["fwd_in_pdt_item_book_of_harvest"] = {
                ["name"] = "《丰收赞歌》",
                ["inspect_str"] = "用来庆祝丰收的魔法书",
                ["recipe_desc"] = "用来庆祝丰收的魔法书",
                ["action_fail"] = "暂时没法在这附近使用",
            },
        --------------------------------------------------------------------
        ---- 02_fwd_in_pdt_materials
            ["fwd_in_pdt_material_tree_resin"] = {
                ["name"] = "树脂",
                ["inspect_str"] = "树里的液脂",
            },
            ["fwd_in_pdt_material_snake_skin"] = {
                ["name"] = "蛇皮",
                ["inspect_str"] = "蛇的皮，不是自然蜕皮那种",
            },
            ["fwd_in_pdt_material_realgar"] = {
                ["name"] = "雄黄矿石",
                ["inspect_str"] = "蛇最怕雄黄了",
            },
        --------------------------------------------------------------------
        ---- 03_fwd_in_pdt_equipments
            ["fwd_in_pdt_eq_mirror_whip"] = {
                ["name"] = "镜像鞭子",
                ["inspect_str"] = "某些东西可以被抽得镜像"
            },
            ["fwd_in_pdt_equipment_blazing_nightmaresword"] = {
                ["name"] = "炽热暗影剑",
                ["inspect_str"] = "这东西充满暗影和光热"
            },
            ["fwd_in_pdt_equipment_frozen_nightmaresword"] = {
                ["name"] = "霜寒暗影剑",
                ["inspect_str"] = "这东西充满暗影和寒冷"
            },
        --------------------------------------------------------------------
        ---- 04_fwd_in_pdt_foods
            ["fwd_in_pdt_food_raw_milk"] = {
                ["name"] = "生牛奶",
                ["inspect_str"] = "从牛身上得到的"
            },
            ["fwd_in_pdt_food_andrographis_paniculata_botany"] = {
                ["name"] = "雄黄饮剂",
                ["inspect_str"] = "可以用来解除蛇毒",
                ["recipe_desc"] = "可以用来解除蛇毒",
            },
            ["fwd_in_pdt_food_universal_antidote"] = {
                ["name"] = "万能解毒剂",
                ["inspect_str"] = "可以用来解除各种毒",
                ["recipe_desc"] = "可以用来解除各种毒",
            },
        --------------------------------------------------------------------
        ---- 05_fwd_in_pdt_foods_cooked
            ["fwd_in_pdt_food_mixed_potato_soup"] = {
                ["name"] = "疙瘩汤",
                ["inspect_str"] = "一块一块像是疙瘩"
            },
            ["fwd_in_pdt_food_steamed_orange_with_honey"] = {
                ["name"] = "蜂蜜蒸橙",
                ["inspect_str"] = "橙子的香味伴随着浓甜的蜜糖"
            },
            ["fwd_in_pdt_food_scrambled_eggs_with_tomatoes"] = {
                ["name"] = "番茄炒蛋",
                ["inspect_str"] = "经典的番茄和鸡蛋组合"
            },
            ["fwd_in_pdt_food_eggplant_casserole"] = {
                ["name"] = "茄子盒",
                ["inspect_str"] = "经典的茄子料理"
            },
            ["fwd_in_pdt_food_gifts_of_nature"] = {
                ["name"] = "自然的馈赠",
                ["inspect_str"] = "各种自然食材混合烹饪而成"
            },
            ["fwd_in_pdt_food_snake_skin_jelly"] = {
                ["name"] = "蛇皮冻",
                ["inspect_str"] = "弹性很好，但是总感觉有一条蛇住在里面"
            },
            ["fwd_in_pdt_food_atractylodes_macrocephala_pills"] = {
                ["name"] = "苍术药丸",
                ["inspect_str"] = "能取出体内湿气，提高体温"
            },
            ["fwd_in_pdt_food_pinellia_ternata_pills"] = {
                ["name"] = "半夏药丸",
                ["inspect_str"] = "能抵御沙尘暴，降低体温"
            },
            ["fwd_in_pdt_food_aster_tataricus_l_f_pills"] = {
                ["name"] = "紫苑药丸",
                ["inspect_str"] = "可以治疗咳嗽和发烧"
            },
            ["fwd_in_pdt_food_red_mushroom_soup"] = {
                ["name"] = "红伞伞蘑菇汤",
                ["inspect_str"] = "这汤感觉很危险",
                ["special_action_str"] = "喂食",
            },
            ["fwd_in_pdt_food_green_mushroom_soup"] = {
                ["name"] = "绿伞伞蘑菇汤",
                ["inspect_str"] = "这汤感觉很危险",
                ["special_action_str"] = "喂食",
            },
            ["fwd_in_pdt_food_tofu"] = {
                ["name"] = "豆腐",
                ["inspect_str"] = "这豆腐闪亮亮的"
            },
            ["fwd_in_pdt_food_stinky_tofu"] = {
                ["name"] = "臭豆腐",
                ["inspect_str"] = "这味道让人难以表达"
            },
            ["fwd_in_pdt_food_cooked_milk"] = {
                ["name"] = "熟牛奶",
                ["inspect_str"] = "煮过的牛奶味道就是香"
            },
            ["fwd_in_pdt_food_yogurt"] = {
                ["name"] = "酸奶",
                ["inspect_str"] = "酸酸的，挺好吃的"
            },
            ["fwd_in_pdt_food_coffee"] = {
                ["name"] = "咖啡",
                ["inspect_str"] = "提神醒脑"
            },
            ["fwd_in_pdt_food_saline_medicine"] = {
                ["name"] = "生理盐水",
                ["inspect_str"] = "医学用品"
            },
            ["fwd_in_pdt_food_yogurt_ice_cream"] = {
                ["name"] = "酸奶冰淇淋",
                ["inspect_str"] = "香甜味美"
            },
            ["fwd_in_pdt_food_mango_ice_drink"] = {
                ["name"] = "杨枝甘露",
                ["inspect_str"] = "充满芒果的香味"
            },
            ["fwd_in_pdt_food_cooked_rice"] = {
                ["name"] = "白米饭",
                ["inspect_str"] = "口感诱人"
            },
            ["fwd_in_pdt_food_bread"] = {
                ["name"] = "面包",
                ["inspect_str"] = "口感诱人"
            },
            ["fwd_in_pdt_food_thousand_year_old_egg"] = {
                ["name"] = "皮蛋",
                ["inspect_str"] = "感觉这蛋还活着"
            },
            ["fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs"] = {
                ["name"] = "皮蛋肉粥",
                ["inspect_str"] = "十分鲜美"
            },
            ["fwd_in_pdt_food_protein_powder"] = {
                ["name"] = "蛋白质粉",
                ["inspect_str"] = "健美人士的最爱"
            },
        --------------------------------------------------------------------
        ---- 06_fwd_in_pdt_containers
        --------------------------------------------------------------------
        ---- 07_fwd_in_pdt_buildings
            ["fwd_in_pdt_building_mock_wall_grass"] = {
                ["name"] = "拟态墙·草",
                ["inspect_str"] = "这是一堵墙...而不是植物....",
                ["recipe_desc"] = "伪装成植物的墙",
            },
            ["fwd_in_pdt_building_banner_light"] = {
                ["name"] = "幡灯",
                ["inspect_str"] = "幡旗飘荡",
            },
            ["fwd_in_pdt_building_special_shop"] = {
                ["name"] = "纪念品商店",
                ["inspect_str"] = "这里好像不只是卖纪念品",
                ["action_str"] = "进入",
            },
            ["fwd_in_pdt_building_materials_shop"] = {
                ["name"] = "材料商店",
                ["inspect_str"] = "有时候会进货一些稀有材料，得看运气",
                ["action_str"] = "进入",
            },
            ["fwd_in_pdt_building_cuisines_shop"] = {
                ["name"] = "美食商店",
                ["inspect_str"] = "有好多好多好吃的",
                ["action_str"] = "进入",
            },
            ["fwd_in_pdt_building_hotel"] = {
                ["name"] = "旅馆",
                ["inspect_str"] = "休息的好去处",
                ["action_str"] = "进入",
            },
            ["fwd_in_pdt_building_medical_check_up_machine"] = {
                ["name"] = "健康检查机",
                ["inspect_str"] = "检查身体状况用的",
                ["inspect_str_burnt"] = "已经烧毁不能用了",
                ["recipe_desc"] = "用来检查身体各种指标的",
            },
            ["fwd_in_pdt_building_paddy_windmill"] = {
                ["name"] = "稻田风车",
                ["inspect_str"] = "这风车带来了水源，可以种植稻谷了",
                ["recipe_desc"] = "用来种植稻谷的",
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
                ["mouse_over_text"] = "传送到 "..STRINGS.NAMES.MULTIPLAYER_PORTAL,
            },
        --------------------------------------------------------------------
        ---- 22_fwd_in_pdt_npc
        --------------------------------------------------------------------
        ---- 23_fwd_in_pdt_wellness
            ["fwd_in_pdt_wellness"] = {
                ["name"] = "体质值",
                ["treatment"] = "想办法提高总体体质值",
                ["health_down_death_announce"] = "XXXX 死于体质不够高，太惨了 ~ ",
            },
            ["fwd_in_pdt_wellness_vitamin_c"] = {
                ["name"] = "维他命C",
                ["treatment"] = "多吃富含维他命C的食物",
            },
            ["fwd_in_pdt_wellness_glucose"] = {
                ["name"] = "血糖",
                ["treatment"] = "吃含糖的食物增加。快速降低则需要胰岛素",
            },
            ["fwd_in_pdt_wellness_poison"] = {
                ["name"] = "中毒",
                ["treatment"] = "万能解毒剂",
            },
            ["fwd_in_pdt_welness_snake_poison"] = {
                ["name"] = "蛇毒",
                ["treatment"] = "雄黄 水解酶",
            },
            ["fwd_in_pdt_welness_frog_poison"] = {
                ["name"] = "青蛙毒",
                ["treatment"] = "雄黄 水解酶",
            },
            ["fwd_in_pdt_welness_spider_poison"] = {
                ["name"] = "蜘蛛毒",
                ["treatment"] = STRINGS.NAMES[string.upper("spidergland")],
            },
            ["fwd_in_pdt_welness_bee_poison"] = {
                ["name"] = "蜜蜂毒",
                ["treatment"] = STRINGS.NAMES[string.upper("taffy")],
            },
            ["fwd_in_pdt_welness_cough"] = {
                ["name"] = "咳嗽",
                ["treatment"] = [[
                    · 使用《伤寒病论》
                    · 紫菀药丸、熟牛奶、旮瘩汤、蜂蜜蒸橙
                ]],
            },
            ["fwd_in_pdt_welness_fever"] = {
                ["name"] = "发烧",
                ["treatment"] = [[
                    · 使用《伤寒病论》
                    · 紫菀药丸、熟牛奶、旮瘩汤、蜂蜜蒸橙
                ]],
            },
        --------------------------------------------------------------------
}

