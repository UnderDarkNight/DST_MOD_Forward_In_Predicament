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
AddRecipeFilter({name="FWD_IN_PDT", atlas = "images/ui_images/fwd_in_pdt_buildings.xml",	image = "fwd_in_pdt_buildings.tex"})
STRINGS.UI.CRAFTING_FILTERS["FWD_IN_PDT"] = GetStringsTable("fwd_in_pdt_ui_craftingmenu")["FWD_IN_PDT"] or ""
--------------------------------------------------------------------------------------------------------------------------------------------
require("recipes_filter")





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




--------------------------------------------------------------------------------------------------------------------------------------------
---- 稻田风车
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_paddy_windmill","GARDENING")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_paddy_windmill",            --  --  inst.prefab  实体名字
    { Ingredient("boards", 10),Ingredient("rope", 10) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_building_paddy_windmill_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_building_paddy_windmill.xml",
        image = "fwd_in_pdt_building_paddy_windmill.tex",
    },
    {"GARDENING","STRUCTURES","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_paddy_windmill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 天体珠宝灯
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_moom_jewelry_lamp","LIGHT")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_moom_jewelry_lamp",            --  --  inst.prefab  实体名字
    { Ingredient("livinglog", 10),Ingredient("purplegem", 1),Ingredient("yellowgem", 1),Ingredient("moonrockcrater", 1) }, 
    TECH.CELESTIAL_ONE, --- TECH.天体宝球
    {
        -- nounlock=true,（这个东西  会让灯没法放置）
        no_deconstruction=false,
        station_tag = "fwd_in_pdt_tag.moonrockseed",   --- 科技物品必须带这个 tag （ 几乎等于天体宝珠 ）
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_moom_jewelry_lamp_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_moom_jewelry_lamp.xml",
        image = "fwd_in_pdt_moom_jewelry_lamp.tex",
    },
    {"LIGHT","FWD_IN_PDT","STRUCTURES","CRAFTING_STATION"}
)
RemoveRecipeFromFilter("fwd_in_pdt_moom_jewelry_lamp","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 养鱼池
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_fish_farm_kit","FISHING")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_fish_farm_kit",            --  --  inst.prefab  实体名字
    { Ingredient("spoiled_food", 5),Ingredient("rope", 4),Ingredient("silk", 4) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        -- placer = "fwd_in_pdt_fish_farm_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_fish_farm.xml",
        image = "fwd_in_pdt_fish_farm.tex",
    },
    {"GARDENING","FISHING","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_fish_farm","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 制作台
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_special_production_table","PROTOTYPERS")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_special_production_table",            --  --  inst.prefab  实体名字
    { Ingredient("charcoal", 4),Ingredient("boards", 4),Ingredient("cutstone", 4),Ingredient("moonrocknugget", 4)  }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_building_special_production_table_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_building_special_production_table.xml",
        image = "fwd_in_pdt_building_special_production_table.tex",
    },
    {"PROTOTYPERS","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_special_production_table","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 发酵缸
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_fermenter","COOKING")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_fermenter",            --  --  inst.prefab  实体名字
    { Ingredient("ash", 4),Ingredient("poop", 2),Ingredient("compost", 4) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_building_fermenter_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_building_fermenter.xml",
        image = "fwd_in_pdt_building_fermenter.tex",
    },
    {"COOKING","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_fermenter","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 混沌万能锅
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_special_cookpot","COOKING")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_special_cookpot",            --  --  inst.prefab  实体名字
    { Ingredient("fwd_in_pdt_material_chaotic_eyeball", 1),Ingredient("charcoal", 6),Ingredient("twigs", 6),Ingredient("cutstone", 3) }, 
    TECH.LOST, --- TECH.蓝图
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_building_special_cookpot_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_building_special_cookpot.xml",
        image = "fwd_in_pdt_building_special_cookpot.tex",
    },
    {"COOKING","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_special_cookpot","MODS")                       -- -- 在【模组物品】标签里移除这个。


--------------------------------------------------------------------------------------------------------------------------------------------
---- 电视机
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_container_tv_box","CONTAINERS")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_container_tv_box",            --  --  inst.prefab  实体名字
    { Ingredient("trinket_6", 2),Ingredient("boards", 6),Ingredient("cutstone", 6)}, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_container_tv_box_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_container_tv_box.xml",
        image = "fwd_in_pdt_container_tv_box.tex",
        min_spacing = 1,
    },
    {"CONTAINERS","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_special_cookpot","MODS")                       -- -- 在【模组物品】标签里移除这个。



--------------------------------------------------------------------------------------------------------------------------------------------
---- 晾晒架
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_drying_rack","COOKING")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_drying_rack",            --  --  inst.prefab  实体名字
    { Ingredient("cutgrass", 20),Ingredient("boards", 10),Ingredient("twigs", 4) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_building_drying_rack_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_building_drying_rack.xml",
        image = "fwd_in_pdt_building_drying_rack.tex",
    },
    {"COOKING","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_drying_rack","MODS")                       -- -- 在【模组物品】标签里移除这个。


--------------------------------------------------------------------------------------------------------------------------------------------
---- 花栅栏
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_flower_fence_item","STRUCTURES")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_flower_fence_item",            --  --  inst.prefab  实体名字
    { Ingredient("twigs", 3), Ingredient("rope", 1) }, 
    TECH.LOST, --- TECH.蓝图
    {
        -- nounlock=true,
        numtogive = 6,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        atlas = "images/inventoryimages/fwd_in_pdt_building_flower_fence.xml",
        image = "fwd_in_pdt_building_flower_fence.tex",
    },
    {"STRUCTURES","DECOR","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_flower_fence_item","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 灯笼
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_lantern","STRUCTURES")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_lantern",            --  --  inst.prefab  实体名字
    { Ingredient("yellowgem", 1), Ingredient("boards", 5), Ingredient("rope", 5) },
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_building_lantern_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_building_lantern.xml",
        image = "fwd_in_pdt_building_lantern.tex",
    },
    {"STRUCTURES","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_lantern","MODS")                       -- -- 在【模组物品】标签里移除这个。



--------------------------------------------------------------------------------------------------------------------------------------------
---- 红木桌
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_container_mahogany_table","STRUCTURES")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_container_mahogany_table",            --  --  inst.prefab  实体名字
    { Ingredient("bluegem", 1), Ingredient("boards", 2), Ingredient("rope", 5) },
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_container_mahogany_table_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_container_mahogany_table.xml",
        image = "fwd_in_pdt_container_mahogany_table.tex",
    },
    {"STRUCTURES","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_container_mahogany_table","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 冰柜
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_deep_freeze","COOKING")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_deep_freeze",            --  --  inst.prefab  实体名字
    { Ingredient("bluegem", 2), Ingredient("gears", 2), Ingredient("bearger_fur", 1) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_deep_freeze_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_deep_freeze.xml",
        image = "fwd_in_pdt_deep_freeze.tex",
    },
    {"COOKING","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_deep_freeze","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 盆栽
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_potting_a","STRUCTURES")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_potting_a",            --  --  inst.prefab  实体名字
    { Ingredient("petals", 1), Ingredient("cutgrass", 2) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_building_potting_a_placer",                       -------- 建筑放置器,记住不是prefab替换  后面有个placer呢！
        atlas = "images/inventoryimages/fwd_in_pdt_building_potting_a.xml", ---在哪注册的 一定要注意
        image = "fwd_in_pdt_building_potting_a.tex",
    },
    {"STRUCTURES","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_potting_a","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------


