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
	---------------------------------------------------------------------------------------
	-- 02_fwd_in_pdt_materials
		"fwd_in_pdt_material_tree_resin",						--- 树脂
		"fwd_in_pdt_material_snake_skin",						--- 蛇皮
	---------------------------------------------------------------------------------------
	-- 03_fwd_in_pdt_equipments
		"fwd_in_pdt_equipment_blazing_nightmaresword",			--- 炽热影刀
		"fwd_in_pdt_equipment_frozen_nightmaresword",			--- 极寒影刀
		"fwd_in_pdt_equipment_blazing_hambat",					--- 炽热火腿
		"fwd_in_pdt_equipment_frozen_hambat",					--- 极寒火腿
		"fwd_in_pdt_equipment_blazing_spear",					--- 炽热长矛
		"fwd_in_pdt_equipment_frozen_spear",					--- 极寒火腿

		"fwd_in_pdt_equipment_repair_staff",					--- 修复法杖
	---------------------------------------------------------------------------------------
	-- 04_fwd_in_pdt_foods
		"fwd_in_pdt_food_raw_milk",								--- 生牛奶

	---------------------------------------------------------------------------------------
	-- 05_fwd_in_pdt_foods_cooked
		"fwd_in_pdt_food_mixed_potato_soup",					--- 疙瘩汤
		"fwd_in_pdt_food_steamed_orange_with_honey",			--- 蜂蜜蒸橙
		"fwd_in_pdt_food_scrambled_eggs_with_tomatoes",		--- 番茄炒蛋
		"fwd_in_pdt_food_eggplant_casserole",					--- 茄子盒
		"fwd_in_pdt_food_gifts_of_nature",						--- 自然的馈赠
		"fwd_in_pdt_food_snake_skin_jelly",					--- 蛇皮冻
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
		




	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


