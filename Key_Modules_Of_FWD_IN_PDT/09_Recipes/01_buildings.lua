----------------------------------------------------------------------------------------------------------------------------------------------
--- 新建一个分类，然后往这个分类里加自己的东西

----------------------------------------------------------------------------------------------------------------------------------------------
-- AddRecipeFilter({name="PANDA_SPELL",atlas = "images/spell_images/SpellTag.xml",	image = "SpellTag.tex"},2)
local function GetStringsTable(prefab_name)
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name) or {}
end


----------------------------------------------------------------------------------------------------------------------------------------------
-- 添加分类栏目
table.insert(Assets,      Asset("ATLAS", "images/ui_images/fwd_in_pdt_buildings.xml")                         )     --  -- 载入贴图文件
table.insert(Assets,      Asset("IMAGE", "images/ui_images/fwd_in_pdt_buildings.tex")                         )     --  -- 载入贴图文件
RegisterInventoryItemAtlas("images/ui_images/fwd_in_pdt_buildings.xml", "fwd_in_pdt_buildings.tex")  -- 注册贴图文件【必须要做】
AddRecipeFilter({name="FWD_IN_PDT_BUILDINGS", atlas = "images/ui_images/fwd_in_pdt_buildings.xml",	image = "fwd_in_pdt_buildings.tex"})
STRINGS.UI.CRAFTING_FILTERS["FWD_IN_PDT_BUILDINGS"] = GetStringsTable("fwd_in_pdt_ui_craftingmenu")["FWD_IN_PDT_BUILDINGS"] or ""
--------------------------------------------------------------------------------------------------------------------------------------------






-- --------------------------------------------------------------------------------------------------------------------------------------------
-- ---- 拟态墙-草
-- -- --------------------------------------------------------------------------------------------------------------------------------------------
-- AddRecipeToFilter("fwd_in_pdt_building_mock_wall_grass_item",string.upper("FWD_IN_PDT_BUILDINGS"))     ---- 添加物品到目标标签
-- GLOBAL.STRINGS.NAMES[string.upper("fwd_in_pdt_building_mock_wall_grass_item")] =  GetStringsTable("fwd_in_pdt_building_mock_wall_grass").name   -- -- 制造栏里展示的名字
-- GLOBAL.STRINGS.RECIPE_DESC[string.upper("fwd_in_pdt_building_mock_wall_grass_item")] = GetStringsTable("fwd_in_pdt_building_mock_wall_grass").recipe_desc  -- --  制造栏里展示的说明
-- AddRecipe2(
--     "fwd_in_pdt_building_mock_wall_grass_item",            --  --  inst.prefab  实体名字
--     {Ingredient("log", 1)}, 
--     TECH.NONE, --- TECH.NONE
--     {
--         -- nounlock=true,
--         -- no_deconstruction=true,
--         -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
--         -- placer = "fwd_in_pdt_building_mock_wall_grass_item",                       -------- 建筑放置器        
--         atlas = "images/inventoryimages1.xml",
--         image = "dug_grass.tex",
--     },
--     {string.upper("FWD_IN_PDT_BUILDINGS")}
-- )
-- RemoveRecipeFromFilter("fwd_in_pdt_building_mock_wall_grass_item","MODS")                       -- -- 在【模组物品】标签里移除这个。




-- --------------------------------------------------------------------------------------------------------------------------------------------
-- ---- 健康检查机
-- -- --------------------------------------------------------------------------------------------------------------------------------------------
-- -- AddRecipeToFilter("fwd_in_pdt_building_medical_check_up_machine","PROTOTYPERS")     ---- 添加物品到目标标签
-- AddRecipe2(
--     "fwd_in_pdt_building_medical_check_up_machine",            --  --  inst.prefab  实体名字
--     { Ingredient("cutstone", 2),Ingredient("transistor", 2),Ingredient("boards", 2) }, 
--     TECH.SCIENCE_TWO, --- TECH.NONE
--     {
--         -- nounlock=true,
--         -- no_deconstruction=true,
--         -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
--         placer = "fwd_in_pdt_building_medical_check_up_machine_placer",                       -------- 建筑放置器        
--         atlas = "images/map_icons/fwd_in_pdt_building_medical_check_up_machine.xml",
--         image = "fwd_in_pdt_building_medical_check_up_machine.tex",
--     },
--     {"PROTOTYPERS","RESTORATION"}
-- )
-- RemoveRecipeFromFilter("fwd_in_pdt_building_medical_check_up_machine","MODS")                       -- -- 在【模组物品】标签里移除这个。




