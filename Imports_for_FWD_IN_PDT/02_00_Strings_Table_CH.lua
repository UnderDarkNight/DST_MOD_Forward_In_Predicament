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
                ["succeed_announce"] = "天空一声巨响，VIP会员【 XXXXXX 】闪亮登场",
                ["talker"] = "【负重前行】",
                ["bad_key.str"] = "检测到和其他玩家相同的CD-KEY，请注意隐私保护！！",
                ["check_start"] = "开始检查玩家输入的CD-KEY:  ",
                ["check_fail"] = "玩家输入的CD-KEY无效",
                ["check_server_fail"] = "连接CD-KEY服务器失败",
            },
            ["fwd_in_pdt_other_poison_frog"] = {
                ["name"] = "箭毒娃",                
            },
            ["fwd_in_pdt_event_hit_other_bleed"] = {
                ["Death_Announce"] = "【{XXXX}】死于伤害过高造成的流血，下次别打那么高的伤害了",                
            },
        --------------------------------------------------------------------
        ---- UI
            ["fwd_in_pdt_ui_craftingmenu"] = {        ---- 制作栏
                ["FWD_IN_PDT"] = "负重前行"
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
                ["inspect_str"] = "一个礼物盒",
                ["name.opening_gift_box"] = "新手生存礼盒",
                ["name.vip"] = "VIP 礼物盒",
                ["name.task_scroll"] = "任务礼盒",
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
            ["fwd_in_pdt_item_insulin__syringe"] = {
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
            ["fwd_in_pdt_item_medical_certificate"] = {
                ["name"] = "诊断单",
                ["inspect_str"] = "自己身体的诊断结果",
                ["recipe_desc"] = "自己身体的诊断结果",
                ["item_name_format"] = "XXXX的诊断单"
            },
            ["fwd_in_pdt_item_locked_book"] = {
                ["name"] = "被锁住的书",
                ["inspect_str"] = "得需要点技巧才能解锁",
            },
            ["fwd_in_pdt_item_cursed_pig_skin"] = {
                ["name"] = "被诅咒的猪皮",
                ["inspect_str"] = "可以对猪猪的房子下手了",
            },
            ["fwd_in_pdt_item_book_of_gardening"] = {
                ["name"] = "《园艺之书》",
                ["inspect_str"] = "和园艺有关的书籍",
            },
            ["fwd_in_pdt_item_book_of_newmoon"] = {
                ["name"] = "《新月之书》",
                ["inspect_str"] = "里面写满了和新月相关的内容，还有魔法",
            },
            ["fwd_in_pdt_item_formulated_crystal"] = {
                ["name"] = "配方水晶",
                ["inspect_str"] = "工作台的相关操作配方",
            },
            ["fwd_in_pdt_item_glass_pig_skin"] = {
                ["name"] = "玻璃猪皮",
                ["inspect_str"] = "可以对猪猪的房子下手了",
            },
            ["fwd_in_pdt_item_glass_horn"] = {
                ["name"] = "玻璃牛角",
                ["inspect_str"] = "可以对牛牛出手了",
            },
            ["fwd_in_pdt_item_mod_synopsis"] = {
                ["name"] = "《负重前行》介绍册",
                ["inspect_str"] = "《负重前行》的内容介绍册",
            },
            ["fwd_in_pdt_item_advertising_leaflet"] = {
                ["name"] = "广告单",
                ["inspect_str"] = "一张广告",
                ["name2"] = " （ 已读 ）"
            },
            ["fwd_in_pdt_item_adrenaline_injection"] = {
                ["name"] = "肾上腺素注射剂",
                ["inspect_str"] = "回复少量体质值，短期内使用越多效果越差",
                ["recipe_desc"] = "回复少量体质值，短期内使用越多效果越差",
            },
            ["fwd_in_pdt_item_bloody_flask"] = {
                ["name"] = "卡尔渴望的血瓶",
                ["inspect_str"] = "里面一大瓶鲜血",
                ["recipe_desc"] = "把自己的鲜血装瓶里",
            },
            ["fwd_in_pdt_item_treatment_from_internship_doctor"] = {
                ["name"] = "实习医生",
                ["succeed"] = "这个医生成功找到了你的病症，并进行了针对性治疗",
                ["fail"] = "这个医生太菜了，没能看出你的病症。换个医生吧",
            },
            ["fwd_in_pdt_item_treatment_from_head_doctor"] = {
                ["name"] = "主任医生",
                ["succeed"] = "这个医生成功找到了你的病症，并进行了针对性治疗",
                ["fail"] = "这个医生医术不行，没能看出你的病症。你的病情相当复杂。",
            },
            ["fwd_in_pdt_item_treatment_from_specialist_doctor"] = {
                ["name"] = "主任医生",
                ["succeed"] = "这个医生成功找到了你的病症，并进行了针对性治疗",
                ["fail"] = "你的病情相当复杂，这个专家已经无力回天，也许换一个就行了。",
            },
            ["fwd_in_pdt_item_talisman_that_repels_snakes"] = {
                ["name"] = "避蛇护符",
                ["inspect_str"] = "这东西有一定概率避免遭遇到蛇",
                ["recipe_desc"] = "这东西有一定概率避免遭遇到蛇",
            },
            ["fwd_in_pdt_item_special_wrap"] = {
                ["name"] = "特制打包纸",
                ["inspect_str"] = "这个可以用来打包很多特殊的东西",
                ["recipe_desc"] = "这个可以用来打包很多特殊的东西",
            },
            ["fwd_in_pdt_item_orthopedic_water"] = {
                ["name"] = "正骨水",
                ["inspect_str"] = "用来治疗骨折",
                ["recipe_desc"] = "用来治疗骨折",
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
            ["fwd_in_pdt_material_atractylodes_macrocephala"] = {
                ["name"] = "苍术",
                ["inspect_str"] = "采摘下来的药材",
            },
            ["fwd_in_pdt_material_pinellia_ternata"] = {
                ["name"] = "半夏",
                ["inspect_str"] = "采摘下来的药材",
            },
            ["fwd_in_pdt_material_aster_tataricus_l_f"] = {
                ["name"] = "紫苑",
                ["inspect_str"] = "采摘下来的药材",
            },
            ["fwd_in_pdt_material_chaotic_eyeball"] = {
                ["name"] = "混沌眼球",
                ["inspect_str"] = "这眼球里充满混沌能量",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_1"] = {
                ["name"] = "混沌万能锅碎片 I",
                ["inspect_str"] = "一块图纸碎片",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_2"] = {
                ["name"] = "混沌万能锅碎片 II",
                ["inspect_str"] = "一块图纸碎片",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_3"] = {
                ["name"] = "混沌万能锅碎片 III",
                ["inspect_str"] = "一块图纸碎片",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_4"] = {
                ["name"] = "混沌万能锅碎片 IV",
                ["inspect_str"] = "一块图纸碎片",
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
            ["fwd_in_pdt_equipment_blazing_hambat"] = {
                ["name"] = "炽热火腿",
                ["inspect_str"] = "这火腿很热很热"
            },
            ["fwd_in_pdt_equipment_frozen_hambat"] = {
                ["name"] = "冰冻火腿",
                ["inspect_str"] = "这火腿冻得硬邦邦的"
            },
            ["fwd_in_pdt_equipment_blazing_spear"] = {
                ["name"] = "炽热长矛",
                ["inspect_str"] = "这长矛里充满了炽热"
            },
            ["fwd_in_pdt_equipment_frozen_spear"] = {
                ["name"] = "霜寒长矛",
                ["inspect_str"] = "这长矛里充满了霜寒"
            },
            ["fwd_in_pdt_equipment_repair_staff"] = {
                ["name"] = "修复法杖",
                ["inspect_str"] = "能修理很多东西"
            },
            ["fwd_in_pdt_equipment_glass_pig"] = {
                ["name"] = "玻璃猪雕像",
                ["inspect_str"] = "这雕像栩栩如生，满月的时候可以供奉肉汤"
            },
            ["fwd_in_pdt_equipment_cursed_pig"] = {
                ["name"] = "诅咒猪雕像",
                ["inspect_str"] = "这雕像栩栩如生，新月的时候可以供奉肉汤"
            },
            ["fwd_in_pdt_equipment_glass_beefalo"] = {
                ["name"] = "玻璃牛雕像",
                ["inspect_str"] = "这雕像栩栩如生",
                ["gift_box"] = "牛牛礼包"
            },
            ["fwd_in_pdt_equipment_huge_soybean"] = {
                ["name"] = "巨大豆荚",
                ["inspect_str"] = "这豆荚很大"
            },
            ["fwd_in_pdt_equipment_huge_orange"] = {
                ["name"] = "巨大橙子",
                ["inspect_str"] = "这橙子很大"
            },
            ["fwd_in_pdt_equipment_mole_backpack"] = {
                ["name"] = "零食鼠背包",
                ["inspect_str"] = "还算凑合",
                ["name.panda"] = "熊猫背包",
                ["name.cat"] = "猫钱钱背包",
                ["name.rabbit"] = "粉兔兔背包",
                ["name.snowman"] = "雪人背包",
            },
            ["fwd_in_pdt_equipment_vampire_sword"] = {
                ["name"] = "吸血鬼之剑",
                ["inspect_str"] = "这剑很凶的样子",
                ["recipe_desc"] = "这剑很凶的样子",
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
            ["fwd_in_pdt_food_rice"] = {
                ["name"] = "稻米",
                ["inspect_str"] = "白花花的煞是好看",
            },
            ["fwd_in_pdt_food_wheat_flour"] = {
                ["name"] = "面粉",
                ["inspect_str"] = "白花花的煞是好看",
            },
            ["fwd_in_pdt_food_mango"] = {
                ["name"] = "芒果",
                ["inspect_str"] = "熟透的芒果",
            },
            ["fwd_in_pdt_food_mango_green"] = {
                ["name"] = "青芒果",
                ["inspect_str"] = "还没熟的芒果",
            },
            ["fwd_in_pdt_food_orange"] = {
                ["name"] = "橙子",
                ["inspect_str"] = "黄橙橙的橙子",
            },
            ["fwd_in_pdt_food_soybeans"] = {
                ["name"] = "大豆",
                ["inspect_str"] = "一颗一颗相当饱满",
            },
            ["fwd_in_pdt_food_coffeebeans"] = {
                ["name"] = "咖啡豆",
                ["inspect_str"] = "一颗一颗相当饱满",
            },
            ["fwd_in_pdt_food_dried_fruits_mango"] = {
                ["name"] = "芒果干",
                ["inspect_str"] = "香甜的芒果干",
            },
            ["fwd_in_pdt_food_dried_fruits_berries"] = {
                ["name"] = "浆果干",
                ["inspect_str"] = "香甜的浆果干",
            },
        --------------------------------------------------------------------
        ---- 05_fwd_in_pdt_foods_cooked
            ["fwd_in_pdt_food_mixed_potato_soup"] = {
                ["name"] = "疙瘩汤",
                ["inspect_str"] = "一块一块像是疙瘩",
                ["oneat_desc"] = "解除发烧，提高体温",
            },
            ["fwd_in_pdt_food_steamed_orange_with_honey"] = {
                ["name"] = "蜂蜜蒸橙",
                ["inspect_str"] = "橙子的香味伴随着浓甜的蜜糖",
                ["oneat_desc"] = "解除咳嗽",
            },
            ["fwd_in_pdt_food_scrambled_eggs_with_tomatoes"] = {
                ["name"] = "番茄炒蛋",
                ["inspect_str"] = "经典的番茄和鸡蛋组合",
                ["oneat_desc"] = "一天内VC不会降低",
            },
            ["fwd_in_pdt_food_eggplant_casserole"] = {
                ["name"] = "茄子盒",
                ["inspect_str"] = "经典的茄子料理",
                ["oneat_desc"] = "血糖值降低",
            },
            ["fwd_in_pdt_food_gifts_of_nature"] = {
                ["name"] = "自然的馈赠",
                ["inspect_str"] = "各种自然食材混合烹饪而成",
                ["oneat_desc"] = "血糖值提高",
            },
            ["fwd_in_pdt_food_snake_skin_jelly"] = {
                ["name"] = "蛇皮冻",
                ["inspect_str"] = "弹性很好，但是总感觉有一条蛇住在里面",
                ["oneat_desc"] = "解除蛇毒",
            },
            ["fwd_in_pdt_food_atractylodes_macrocephala_pills"] = {
                ["name"] = "苍术药丸",
                ["inspect_str"] = "能取出体内湿气，提高体温",
                ["oneat_desc"] = "清除潮湿度，稳定体温",
            },
            ["fwd_in_pdt_food_pinellia_ternata_pills"] = {
                ["name"] = "半夏药丸",
                ["inspect_str"] = "能抵御沙尘暴，降低体温",
                ["oneat_desc"] = "降低体温，免疫沙尘暴一小会",
            },
            ["fwd_in_pdt_food_aster_tataricus_l_f_pills"] = {
                ["name"] = "紫苑药丸",
                ["inspect_str"] = "可以治疗咳嗽和发烧",
                ["oneat_desc"] = "解除咳嗽和发烧",
            },
            ["fwd_in_pdt_food_red_mushroom_soup"] = {
                ["name"] = "红伞伞蘑菇汤",
                ["inspect_str"] = "这汤感觉很危险",
                ["special_action_str"] = "喂食",
                ["oneat_desc"] = "不要喂给猪人!!",
            },
            ["fwd_in_pdt_food_green_mushroom_soup"] = {
                ["name"] = "绿伞伞蘑菇汤",
                ["inspect_str"] = "这汤感觉很危险",
                ["special_action_str"] = "喂食",
                ["oneat_desc"] = "出现幻觉",
            },
            ["fwd_in_pdt_food_tofu"] = {
                ["name"] = "豆腐",
                ["inspect_str"] = "这豆腐闪亮亮的",
            },
            ["fwd_in_pdt_food_stinky_tofu"] = {
                ["name"] = "臭豆腐",
                ["inspect_str"] = "这味道让人难以表达",                
            },
            ["fwd_in_pdt_food_cooked_milk"] = {
                ["name"] = "熟牛奶",
                ["inspect_str"] = "煮过的牛奶味道就是香",
                ["oneat_desc"] = "解除咳嗽",
            },
            ["fwd_in_pdt_food_yogurt"] = {
                ["name"] = "酸奶",
                ["inspect_str"] = "酸酸的，挺好吃的"
            },
            ["fwd_in_pdt_food_coffee"] = {
                ["name"] = "咖啡",
                ["inspect_str"] = "提神醒脑",
                ["oneat_desc"] = "增加行走速度一小会",
            },
            ["fwd_in_pdt_food_saline_medicine"] = {
                ["name"] = "生理盐水",
                ["inspect_str"] = "医学用品",
                ["oneat_desc"] = "提高VC",
            },
            ["fwd_in_pdt_food_yogurt_ice_cream"] = {
                ["name"] = "酸奶冰淇淋",
                ["inspect_str"] = "香甜味美",
                ["oneat_desc"] = "降低体温",
            },
            ["fwd_in_pdt_food_mango_ice_drink"] = {
                ["name"] = "杨枝甘露",
                ["inspect_str"] = "充满芒果的香味",
                ["oneat_desc"] = "攻击力增加",
            },
            ["fwd_in_pdt_food_cooked_rice"] = {
                ["name"] = "白米饭",
                ["inspect_str"] = "口感诱人",
                -- ["oneat_desc"] = "可快速采集",
            },
            ["fwd_in_pdt_food_bread"] = {
                ["name"] = "面包",
                ["inspect_str"] = "口感诱人",
                ["oneat_desc"] = "缓慢饱腹",
            },
            ["fwd_in_pdt_food_thousand_year_old_egg"] = {
                ["name"] = "皮蛋",
                ["inspect_str"] = "感觉这蛋还活着",
            },
            ["fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs"] = {
                ["name"] = "皮蛋肉粥",
                ["inspect_str"] = "十分鲜美",
            },
            ["fwd_in_pdt_food_protein_powder"] = {
                ["name"] = "蛋白质粉",
                ["inspect_str"] = "健美人士的最爱",
                ["oneat_desc"] = "肌肉不萎缩",
            },
            ["fwd_in_pdt_food_stinky_tofu_salad"] = {
                ["name"] = "臭豆腐沙拉",
                ["inspect_str"] = "味道难闻，但是很好吃",
            },
            ["fwd_in_pdt_food_stinky_tofu_bolognese"] = {
                ["name"] = "臭豆腐肉酱",
                ["inspect_str"] = "味道难闻，但是很好吃",
            },
        --------------------------------------------------------------------
        ---- 06_fwd_in_pdt_containers
            ["fwd_in_pdt_fish_farm"] = {
                ["name"] = "养鱼池",
                ["inspect_str"] = STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "都能当饲料",
                ["recipe_desc"] = STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "都能当饲料",
            },
            ["fwd_in_pdt_fish_farm_kit"] = {
                ["name"] = "养鱼池",
                ["inspect_str"] = STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "都能当饲料",
                ["recipe_desc"] = STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "都能当饲料",
            },
            ["fwd_in_pdt_moom_jewelry_lamp"] = {
                ["name"] = "天体珠宝灯",
                ["inspect_str"] = "挺有用的灯",
                ["recipe_desc"] = "三种宝石提供三种功能",
            },
            ["fwd_in_pdt_building_special_production_table"] = {
                ["name"] = "多合一制作台",
                ["inspect_str"] = "制作一些特别的东西用的工作台",
                ["recipe_desc"] = "制作一些特别的东西用的工作台",
            },
            ["fwd_in_pdt_building_fermenter"] = {
                ["name"] = "发酵缸",
                ["inspect_str"] = "能用来发酵一些食物",
                ["recipe_desc"] = "能用来发酵一些食物",
                ["inspect_str_burnt"] = "已经烧毁了",
                ["action_str"] = "开始发酵"
            },
            ["fwd_in_pdt_building_special_cookpot"] = {
                ["name"] = "混沌万能锅",
                ["inspect_str"] = "能烹饪出不少食物",
                ["recipe_desc"] = "能烹饪出不少食物",
            },
            ["fwd_in_pdt_container_tv_box"] = {
                ["name"] = "电视机",
                ["inspect_str"] = "这电视机有点不正常",
                ["recipe_desc"] = "这电视机有点不正常",
            },
            ["fwd_in_pdt_building_drying_rack"] = {
                ["name"] = "晾晒架",
                ["inspect_str"] = "能用来风干一些食物",
                ["recipe_desc"] = "能用来风干一些食物",
                ["inspect_str_burnt"] = "已经烧毁了",
                ["action_str"] = "捣鼓"
            },
            ["fwd_in_pdt_container_wallet"] = {
                ["name"] = "钱袋",
                ["inspect_str"] = "用来方便储存钱币的",
                ["recipe_desc"] = "用来方便储存钱币的",
                ["skin.piggy"] = "小猪储存罐"
            },
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
                ["name"] = "特殊物品商店",
                ["inspect_str"] = "这里好多特别的物品",
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
            ["fwd_in_pdt_building_pawnshop"] = {
                ["name"] = "当铺",
                ["inspect_str"] = "这里能卖掉一些东西",
                ["action_str"] = "进入",
            },
            ["fwd_in_pdt_building_atm"] = {
                ["name"] = "ATM",
                ["inspect_str"] = "可以存钱取钱",
            },
            ["fwd_in_pdt_building_bulletin_board"] = {
                ["name"] = "公告栏",
                ["inspect_str"] = "贴有广告，和任务",
            },
            ["fwd_in_pdt_building_hospital"] = {
                ["name"] = "医院",
                ["inspect_str"] = "这里居然有一个医院",
                ["action_str"] = "进入",
            },
            ["fwd_in_pdt_building_doll_clamping_machine"] = {
                ["name"] = "夹娃娃机",
                ["inspect_str"] = "可以试试手气",
                ["action_str"] = "投入",
                ["gift_box.medical_kit"] = "医疗补给包",
                ["gift_box.boss"] = "BOSS掉落补给包",
                ["gift_box.lunar"] = "月光守护者礼包",
                ["gift_box.shadow"] = "暗影守护者礼包",
                ["gift_box.egg"] = "蛋蛋礼盒",
                ["gift_box.coffee"] = "提神礼盒",
                ["gift_box.ruins"] = "铥矿补给包",
                ["gift_box.greenamulet"] = "绿光补给包",
                ["gift_box.eyeturret_item"] = "远古炮台补给包",
                ["gift_box.amulet"] = "可以作死补给包",
                ["gift_box.gems"] = "亮晶晶补给包",
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
            ["fwd_in_pdt_plant_paddy_rice"] = {
                ["name"] = "水稻",
                ["inspect_str"] = "这个只能在水源充足的地方生长",
            },
            ["fwd_in_pdt_plant_paddy_rice_seed"] = {
                ["name"] = "未脱壳的稻米",
                ["inspect_str"] = "脱壳后就能吃了",
            },
            ["fwd_in_pdt_plant_wheat"] = {
                ["name"] = "小麦",
                ["inspect_str"] = "成熟后就能金灿灿的了",
            },
            ["fwd_in_pdt_plant_wheat_seed"] = {
                ["name"] = "麦子",
                ["inspect_str"] = "可以拿去继续种植，也能做成面粉",
            },
            ["fwd_in_pdt_plant_atractylodes_macrocephala"] = {
                ["name"] = "苍术",
                ["inspect_str"] = "风雨本是无心起，奈何花叶倾心落",
            },
            ["fwd_in_pdt_plant_atractylodes_macrocephala_seed"] = {
                ["name"] = "苍术种子",
                ["inspect_str"] = "苍术的种子",
            },
            ["fwd_in_pdt_plant_pinellia_ternata"] = {
                ["name"] = "半夏",
                ["inspect_str"] = "苦尽甘来终有时，一路向阳待花期",
            },
            ["fwd_in_pdt_plant_pinellia_ternata_seed"] = {
                ["name"] = "半夏种子",
                ["inspect_str"] = "半夏的种子",
            },
            ["fwd_in_pdt_plant_aster_tataricus_l_f"] = {
                ["name"] = "紫苑",
                ["inspect_str"] = "多病所须唯药物，差科未动是闲人",
            },
            ["fwd_in_pdt_plant_aster_tataricus_l_f_seed"] = {
                ["name"] = "紫苑种子",
                ["inspect_str"] = "紫苑的种子",
            },
            ["fwd_in_pdt_plant_coffeebush"] = {
                ["name"] = "咖啡丛",
                ["inspect_str"] = "很奇怪的咖啡丛",
            },
            ["fwd_in_pdt_plant_coffeebush_item"] = {
                ["name"] = "咖啡丛",
                ["inspect_str"] = "很奇怪的咖啡丛",
            },
            ["fwd_in_pdt_plant_mango_tree"] = {
                ["name"] = "芒果树",
                ["inspect_str"] = "奇特的芒果树",
            },
            ["fwd_in_pdt_plant_mango_tree_item"] = {
                ["name"] = "芒果树穂",
                ["inspect_str"] = "可以用来种植芒果树",
            },
            ["fwd_in_pdt_plant_bean"] = {
                ["name"] = "大豆",
                ["inspect_str"] = "含有丰富的植物蛋白",
            },
            ["fwd_in_pdt_plant_bean_seed"] = {
                ["name"] = "大豆种子",
                ["inspect_str"] = "可以拿来种植",
            },
            ["fwd_in_pdt_plant_orange"] = {
                ["name"] = "橙子树",
                ["inspect_str"] = "可以得到黄灿灿的橙子",
            },
            ["fwd_in_pdt_plant_orange_seed"] = {
                ["name"] = "橙子树种子",
                ["inspect_str"] = "可以拿来种植",
            },
        --------------------------------------------------------------------
        ---- 10_fwd_in_pdt_minerals
        --------------------------------------------------------------------
        ---- 11_fwd_in_pdt_animals
            ["fwd_in_pdt_animal_snake"] = {
                ["name"] = "蛇",
                ["inspect_str"] = "各处潜伏的蛇",
            },
            ["fwd_in_pdt_animal_frog_hound"] = {
                ["name"] = "二蛤",
                ["inspect_str"] = "这家伙应该是只青蛙变的",
            },
            ["fwd_in_pdt_animal_snake_hound"] = {
                ["name"] = "变异蛇",
                ["inspect_str"] = "这家伙居然有两个头",
            },
            ["fwd_in_pdt_animal_ghost_hound"] = {
                ["name"] = "幽灵猎犬",
                ["inspect_str"] = "这家伙很难缠",
            },
        --------------------------------------------------------------------
        ---- 12_fwd_in_pdt_boss
        --------------------------------------------------------------------
        ---- 13_fwd_in_pdt_pets
        --------------------------------------------------------------------
        ---- 14_fwd_in_pdt_turfs
            ["turf_fwd_in_pdt_turf_snakeskin"] = {
                ["name"] = "蛇皮地毯",
                ["inspect_str"] = "用蛇皮做成的地毯",
            },
            ["turf_fwd_in_pdt_turf_cobbleroad"] = {
                ["name"] = "石砖地皮",
                ["inspect_str"] = "用石砖堆砌成的地皮",
            },
            ["turf_fwd_in_pdt_turf_grasslawn"] = {
                ["name"] = "草格地皮",
                ["inspect_str"] = "用草一个一个格子修整出的",
            },
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
            ["fwd_in_pdt_carl"] = {
                ["death_thirst_for_blood"] = "【{XXXX}】死于对鲜血的渴望，太惨了，还得更加努力获得鲜血才行",
                ["spell_cost_not_enough"] = "血瓶数量不足，需要数量："
            },
        --------------------------------------------------------------------
        ---- 20_fwd_in_pdt_events
        --------------------------------------------------------------------
        ---- 21_fwd_in_pdt_rooms
            ["fwd_in_pdt__rooms_quirky_red_tree"] = {
                ["name"] = "古怪的红叶树",
                ["inspect_str"] = "这树木特别古怪，有种不祥的气息",
                ["wisper_str"] = "附近有一棵很奇怪的树",
            },
            ["fwd_in_pdt__rooms_quirky_red_tree_special"] = {
                ["name"] = "古怪的红叶树",
                ["inspect_str"] = "这树木特别古怪，有种不祥的气息",
                ["wisper_str"] = "附近有一棵很奇怪的树",

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
                ["treatment"] = "吃含糖的食物增加。快速降低则需要胰岛素针。",
            },
            ["fwd_in_pdt_wellness_poison"] = {
                ["name"] = "中毒",
                ["treatment"] = {"清空需要万能解毒剂","想要不再增长，则需要使用对应解毒方法"},
            },
            ["fwd_in_pdt_welness_snake_poison"] = {
                ["name"] = "蛇毒",
                ["treatment"] = "雄黄饮剂",
            },
            ["fwd_in_pdt_welness_frog_poison"] = {
                ["name"] = "青蛙毒",
                ["treatment"] = "万能解毒剂 或者 青腿三明治",
            },
            ["fwd_in_pdt_welness_spider_poison"] = {
                ["name"] = "蜘蛛毒",
                ["treatment"] = { STRINGS.NAMES[string.upper("spidergland")],STRINGS.NAMES[string.upper("healingsalve")] , "万能解毒剂" },
            },
            ["fwd_in_pdt_welness_bee_poison"] = {
                ["name"] = "蜜蜂毒",
                ["treatment"] = { STRINGS.NAMES[string.upper("taffy")] , "万能解毒剂" },
            },
            ["fwd_in_pdt_welness_cough"] = {
                ["name"] = "咳嗽",
                ["treatment"] = { "使用《伤寒病论》","紫菀药丸、熟牛奶、旮瘩汤、蜂蜜蒸橙"},
            },
            ["fwd_in_pdt_welness_fever"] = {
                ["name"] = "发烧",
                ["treatment"] = { "使用《伤寒病论》","紫菀药丸、旮瘩汤、蜂蜜蒸橙"},
            },
            ["fwd_in_pdt_welness_fracture"] = {
                ["name"] = "骨折",
                ["treatment"] = { "使用正骨水（医院购买）"},
                ["debuff_attach_whisper"] = "你一个不小心把自己弄骨折了",
            },
        --------------------------------------------------------------------
        ---- 24_fwd_in_pdt_task_scrolls
            ["fwd_in_pdt_task_scroll__test"] = {
                ["name"] = "任务卷轴",
                ["inspect_str"] = "别人发布的任务",
            },
        --------------------------------------------------------------------
}

