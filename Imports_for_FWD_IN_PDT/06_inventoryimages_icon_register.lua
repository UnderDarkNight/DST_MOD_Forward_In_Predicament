---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\inventoryimages 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {

	---------------------------------------------------------------------------------------
	-- 01_fwd_in_pdt_items
		"fwd_in_pdt_item_ice_core"	, 							--- 冰核心
		"fwd_in_pdt_item_flame_core"	, 						--- 火核心
		"fwd_in_pdt_item_jade_coin_green"	, 					--- 玉龙币·翠
		"fwd_in_pdt_item_jade_coin_black"	, 					--- 玉龙币·墨
		"fwd_in_pdt_item_transport_stone"	, 					--- 传送石
		"fwd_in_pdt_item_insulin__syringe"	, 					--- 胰岛素注射器
		"fwd_in_pdt_item_disease_treatment_book"	, 			--- 《伤寒病论》
		"fwd_in_pdt_item_book_of_harvest"	, 					--- 《丰收之书》
		"fwd_in_pdt_item_medical_certificate"	, 				--- 诊断单
		"fwd_in_pdt_item_locked_book"	, 						--- 被锁住的书
		"fwd_in_pdt_item_cursed_pig_skin"	,				    --- 被诅咒的猪皮
		"fwd_in_pdt_item_book_of_gardening"	,				    --- 《园艺之书》
		"fwd_in_pdt_item_book_of_newmoon"	,				    --- 《新月之书》
		"fwd_in_pdt_item_formulated_crystal"	,				--- 工作台配方水晶
		"fwd_in_pdt_item_glass_pig_skin"	,				    --- 玻璃猪皮
		"fwd_in_pdt_item_glass_horn"	,				  	    --- 玻璃号角
		"fwd_in_pdt_item_advertising_leaflet"	, 				--- 广告单
		"fwd_in_pdt_item_adrenaline_injection"	, 				--- 肾上腺素注射剂
		"fwd_in_pdt_item_bloody_flask"	, 						--- 卡尔的血瓶
		"fwd_in_pdt_item_treatment_from_internship_doctor"	, 	--- 实习医生的治疗
		"fwd_in_pdt_item_treatment_from_head_doctor"	, 		--- 主任医生的治疗
		"fwd_in_pdt_item_treatment_from_internship_doctor"	, 	--- 专家医生的治疗
		"fwd_in_pdt_item_talisman_that_repels_snakes",			--- 避蛇护符
		"fwd_in_pdt_item_pig_flute",							--- 猪猪笛子
		"fwd_in_pdt_item_werepig_flute",						--- 疯猪笛子
		"fwd_in_pdt_item_compressed_cyclone",					--- 压缩气旋
		"fwd_in_pdt_item_vitamin_a_oral_solution",				--- 维生素A口服液
		"fwd_in_pdt_item_special_packer",						--- 特殊打包纸
		"fwd_in_pdt_item_special_wraped_box",					--- 打包盒子
		"fwd_in_pdt_item_mouse_and_camera_crazy_powder",		--- 癫痫散
	---------------------------------------------------------------------------------------
	-- 02_fwd_in_pdt_materials
		"fwd_in_pdt_material_tree_resin",							--- 树脂
		"fwd_in_pdt_material_snake_skin",							--- 蛇皮
		"fwd_in_pdt_material_realgar",								--- 雄黄矿
		"fwd_in_pdt_material_atractylodes_macrocephala",			--- 苍术
		"fwd_in_pdt_material_pinellia_ternata",						--- 半夏
		"fwd_in_pdt_material_aster_tataricus_l_f",					--- 紫苑
		"fwd_in_pdt_material_chaotic_eyeball",						--- 混沌眼球
		"fwd_in_pdt_material_chaotic_cookpot_puzzle_1",				--- 混沌万能锅碎片
		"fwd_in_pdt_material_chaotic_cookpot_puzzle_2",				--- 混沌万能锅碎片
		"fwd_in_pdt_material_chaotic_cookpot_puzzle_3",				--- 混沌万能锅碎片
		"fwd_in_pdt_material_chaotic_cookpot_puzzle_4",				--- 混沌万能锅碎片
		"fwd_in_pdt_material_frog_hound_skin",						--- 二蛤皮

	---------------------------------------------------------------------------------------
	-- 03_fwd_in_pdt_equipments
		"fwd_in_pdt_equipment_blazing_nightmaresword",			--- 炽热影刀
		"fwd_in_pdt_equipment_frozen_nightmaresword",			--- 极寒影刀
		"fwd_in_pdt_equipment_blazing_hambat",					--- 炽热火腿
		"fwd_in_pdt_equipment_frozen_hambat",					--- 极寒火腿
		"fwd_in_pdt_equipment_blazing_spear",					--- 炽热长矛
		"fwd_in_pdt_equipment_frozen_spear",					--- 极寒火腿
		"fwd_in_pdt_equipment_repair_staff",					--- 修复法杖
		"fwd_in_pdt_equipment_glass_pig",						--- 玻璃猪雕像
		"fwd_in_pdt_equipment_cursed_pig",						--- 诅咒猪雕像
		"fwd_in_pdt_equipment_glass_beefalo",					--- 玻璃牛雕像
		"fwd_in_pdt_equipment_huge_soybean",					--- 巨大豆荚
		"fwd_in_pdt_equipment_huge_orange",						--- 巨大橙子
		"fwd_in_pdt_equipment_mole_backpack",					--- 鼹鼠背包
		"fwd_in_pdt_equipment_vampire_sword",					--- 吸血鬼剑
		"fwd_in_pdt_equipment_vampire_sword_laser",				--- 吸血鬼剑-激光皮肤
		"fwd_in_pdt_equipment_loong_balloon",					--- 龙气球
		"fwd_in_pdt_equipment_balloon_evil_dragon",				--- 邪龙气球
		"fwd_in_pdt_equipment_balloon_evil_dragon_green",		--- 邪龙气球（皮肤）
		"fwd_in_pdt_equipment_balloon_bobble_loong",			--- 泡泡龙气球
		"fwd_in_pdt_equipment_balloon_bobble_loong_green",		--- 泡泡龙气球（皮肤）
		"fwd_in_pdt_equipment_magic_spatula",					--- 魔法锅铲
		"fwd_in_pdt_equipment_shield_of_light",					--- 光之护盾
		"fwd_in_pdt_void_fishingrod",							--- 虚空鱼竿
		"fwd_in_pdt_void_fishingrod_flower",					--- 虚空鱼竿（皮肤）
		"fwd_in_pdt_equipment_telescope",						--- 望远镜
		"fwd_in_pdt_frog_hound_skin_raincoat",					--- 哈皮雨衣
		"fwd_in_pdt_equipment_ocean_fork",						--- 填海叉子
	---------------------------------------------------------------------------------------
	-- 04_fwd_in_pdt_foods
		"fwd_in_pdt_food_raw_milk",								--- 生牛奶
		"fwd_in_pdt_food_andrographis_paniculata_botany", 	    --- 雄黄饮剂
		"fwd_in_pdt_food_universal_antidote", 	   				--- 万能解毒剂
		"fwd_in_pdt_food_rice", 	    						--- 脱壳的稻米
		"fwd_in_pdt_food_wheat_flour", 	    					--- 面粉
		"fwd_in_pdt_food_mango", 	    						--- 芒果
		"fwd_in_pdt_food_mango_green", 	    					--- 绿芒果
		"fwd_in_pdt_food_orange", 	    						--- 橙子
		"fwd_in_pdt_food_soybeans", 	    					--- 大豆
		"fwd_in_pdt_food_coffeebeans", 	    					--- 咖啡豆
		"fwd_in_pdt_food_dried_fruits_mango", 	    			--- 芒果干
		"fwd_in_pdt_food_dried_fruits_berries",					--- 浆果干
		"fwd_in_pdt_food_dried_fruits_watermelons",				--- 西瓜干
		"fwd_in_pdt_food_dried_fruits_pineananas",				--- 松萝干
		"fwd_in_pdt_food_dried_fruits_dragonfruits",			--- 火龙果干
		"fwd_in_pdt_food_dried_fruits_durians",					--- 榴莲干
		"fwd_in_pdt_food_dried_fruits_pomegranates",			--- 石榴干
		"fwd_in_pdt_food_dried_fruits_cave_bananas",			--- 香蕉干
		"fwd_in_pdt_food_dried_fish",							--- 鱼干
		"fwd_in_pdt_food_large_intestine",						--- 猪大肠
		"fwd_in_pdt_food_chicken_feet",							--- 鸡爪
		"fwd_in_pdt_food_pig_liver",							--- 猪肝
		"fwd_in_pdt_food_cat_feces",							--- 猫屎
		"fwd_in_pdt_food_pericarpium_citri_reticulatae",		--- 陈皮
	---------------------------------------------------------------------------------------
	-- 05_fwd_in_pdt_foods_cooked
		"fwd_in_pdt_food_mixed_potato_soup",					--- 疙瘩汤
		"fwd_in_pdt_food_steamed_orange_with_honey",			--- 蜂蜜蒸橙
		"fwd_in_pdt_food_scrambled_eggs_with_tomatoes",			--- 番茄炒蛋
		"fwd_in_pdt_food_eggplant_casserole",					--- 茄子盒
		"fwd_in_pdt_food_gifts_of_nature",						--- 自然的馈赠
		"fwd_in_pdt_food_snake_skin_jelly",						--- 蛇皮冻
		"fwd_in_pdt_food_atractylodes_macrocephala_pills",		--- 苍术药丸
		"fwd_in_pdt_food_pinellia_ternata_pills",				--- 半夏药丸
		"fwd_in_pdt_food_aster_tataricus_l_f_pills",			--- 紫苑药丸
		"fwd_in_pdt_food_red_mushroom_soup",					--- 红伞伞蘑菇汤
		"fwd_in_pdt_food_green_mushroom_soup",					--- 绿伞伞蘑菇汤
		"fwd_in_pdt_food_tofu",									--- 豆腐
		"fwd_in_pdt_food_stinky_tofu",							--- 臭豆腐
		"fwd_in_pdt_food_cooked_milk",							--- 熟牛奶
		"fwd_in_pdt_food_yogurt",								--- 酸奶
		"fwd_in_pdt_food_coffee",								--- 咖啡
		"fwd_in_pdt_food_saline_medicine",						--- 生理盐水
		"fwd_in_pdt_food_yogurt_ice_cream",						--- 酸奶冰淇淋
		"fwd_in_pdt_food_mango_ice_drink",						--- 杨枝甘露
		"fwd_in_pdt_food_cooked_rice",							--- 白米饭
		"fwd_in_pdt_food_bread",								--- 面包
		"fwd_in_pdt_food_thousand_year_old_egg",				--- 皮蛋
		"fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs",				--- 皮蛋肉粥
		"fwd_in_pdt_food_protein_powder",						--- 蛋白质粉
		"fwd_in_pdt_food_stinky_tofu_salad",					--- 臭豆腐沙拉
		"fwd_in_pdt_food_stinky_tofu_bolognese",				--- 臭豆腐肉酱
		"fwd_in_pdt_food_garlic_cucumber",						--- 拍黄瓜
		"fwd_in_pdt_food_coffee_luwak",							--- 猫屎咖啡
		"fwd_in_pdt_food_meat_buns",							--- 人肉包子
		"fwd_in_pdt_food_egg_mooncake",							--- 蛋黄月饼


	---------------------------------------------------------------------------------------
	-- 06_fwd_in_pdt_containers
		"fwd_in_pdt_container_wallet",							-- 钱包
		"fwd_in_pdt_container_wallet_piggy",					-- 钱包（皮肤）
	---------------------------------------------------------------------------------------
	-- 07_fwd_in_pdt_buildings
		"fwd_in_pdt_building_flower_fence",						-- 花围栏
		"fwd_in_pdt_building_flower_fence_purple",						-- 花围栏（皮肤）
		"fwd_in_pdt_building_flower_fence_vines",						-- 花围栏（皮肤）
		"fwd_in_pdt_building_flower_fence_mushroom",					-- 花围栏（皮肤）
		"fwd_in_pdt_building_lantern",							-- 灯笼
		"fwd_in_pdt_building_potting_a",						-- 盆栽
	---------------------------------------------------------------------------------------
	-- 09_fwd_in_pdt_plants
		"fwd_in_pdt_plant_paddy_rice_seed",								--- 未脱壳的稻米
		"fwd_in_pdt_plant_wheat_seed",									--- 麦子
		"fwd_in_pdt_plant_atractylodes_macrocephala_seed",				--- 苍术种子
		"fwd_in_pdt_plant_pinellia_ternata_seed",						--- 半夏种子
		"fwd_in_pdt_plant_aster_tataricus_l_f_seed",					--- 紫苑种子
		"fwd_in_pdt_plant_coffeebush_item",							    --- 咖啡树
		"fwd_in_pdt_plant_mango_tree_item",							    --- 芒果树芽
		"fwd_in_pdt_plant_bean_seed",							    	--- 大豆种子
		"fwd_in_pdt_plant_orange_seed",							    	--- 橙子种子
		"fwd_in_pdt_coffeebush",										--- 咖啡
		"fwd_in_pdt_dug_coffeebush",									--- 咖啡丛
	---------------------------------------------------------------------------------------
	--- 19_fwd_in_pdt_characters 
		"fwd_in_pdt_widget_cyclone_recipe_health",								--- 物品栏的图标
	---------------------------------------------------------------------------------------
	--- 24_fwd_in_pdt_task_scrolls 
		"fwd_in_pdt_task_scroll",										--- 任务卷轴
	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


