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
--------------------------------------------------------------------------------------------------------------------------------------------
-- 【笔记】AddRecipe2参数说明

-- name (string)：配方的名称，通常用prefab名
-- ingredients (table)：配方所需的原料表。
-- tech (string)：解锁该配方所需的科技
-- (可选) config (table)：一个可选的配置表，包含 Recipe2 类构造函数中的可选字段。
-- (可选) filters (table)：一个可选的过滤器列表，包含要将配方添加到的过滤器名称。
-- 其中， config表key如下：
-- (可选)placer(string)：放置物 prefab，用于显示一个建筑的临时放置物，在放下建筑后就会消失。
-- (可选) min_spacing (num)：建造物的最小间距。
-- (可选)nounlock (bool)：如果为 false，只能在对应的科技建筑旁制作。否则在初次解锁后，就可以在任意地点制作。
-- (可选)numtogive (num)：制作成功后，玩家将获得的物品数量。
-- (可选)builder_tag (string)：要求具备的制作者标签。如果人物没有此标签，便无法制作物品，可以用于人物的专属物品。
-- (必须)atlas (string)：物品图标所在的 atlas 文件路径，用于制作栏显示图片，其实不填也行，但图标会是空的。
-- (可选)image (string)：物品图标的文件名，其实 atlas 中已包含，不必再填。
-- (可选)testfn (function)：放置时的检测函数，比如有些建筑对地形有特殊要求，可以使用此函数检测。
-- (可选)product (string)：产出物，表示制作成功后产生的物品。默认
-- (可选)build_mode (string)：建造模式，必须使用常量表BUILDMODE，形如BUILDMODE.LAND，具体取值为无限制（NONE）、地上（LAND）和水上（WATER）。
-- (可选)build_distance (num)：建造距离，表示玩家与建筑之间的最大距离。
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
-- 【笔记】过滤器相关
-- 创建自定义过滤器需要用到ModAPI AddRecipeFilter ，流程如下。

-- 首先，定义一个过滤器（filter_def），它是一个table，包含以下key：

-- name (string)：过滤器的 ID，需要将该名称添加到 STRINGS.UI.CRAFTING_FILTERS[name]。
-- atlas (string 或 function)：图标的图集，可以是字符串或函数。
-- image (string 或 function)：显示在制作菜单中的图标，可以是字符串或函数。
-- (可选) image_size (table)：自定义图像尺寸，默认64。
-- (可选) custom_pos (table)：自定义的过滤器位置，默认为false。 如果为 true，则过滤器图标不会被添加到网格中，而是把这个分类下的物品都放在mod物品分类下。
-- recipes (table)：不要使用！ 请创建过滤器后，将过滤器传递给 AddRecipe2() 或 AddRecipeToFilter() 函数。
-- 然后，调用 AddRecipeFilter ，将过滤器传入：

-- AddRecipeFilter(filter_def, index)
-- 其中，index表示过滤器在界面中的位置，如果不提供，则会添加到最后。

-- 最后，在创建配方时，使用 AddRecipe2 或 AddCharacterRecipe 函数，将配方添加到相应的过滤器中。例如：AddRecipe2(name, ingredients, tech, config, filters) ，
-- 其中filters 是一个包含过滤器名称的列表，配方会被添加到这些过滤器中。

-- 下面是一个创建自定义过滤器的示例：

-- -- 加载资源
-- Assets = {
--     Asset("ATLAS", "images/craft_samansha_icon.xml"),
-- }

-- -- 定义一个新的过滤器对象
-- local filter_samansha_def = {
--     name = "SAMANSHA",
--     atlas = "images/craft_samansha_icon.xml",
--     image = "craft_samansha_icon.tex"
-- }

-- -- 添加自定义过滤器
-- AddRecipeFilter(filter_samansha_def, 1) -- 这个1貌似是所在位置
-- STRINGS.UI.CRAFTING_FILTERS.SAMANSHA ="自定义过滤器" -- 制作栏中显示的名字 -- 【注意：这里要全程大写 别写错了】
----------------------------------------------------------------------------------------------------------------------------------------------
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
        -- nounlock=true,（这个东西  会让灯没法放置）true的时候：没有【解锁】 机制，每次制作都得靠近科技
        -- 你要是不确定是false还是true 你就  not nil == true not false == true   not true == false(nil 和 false 在某些机制上是一样的)
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
    {"COOKING","STRUCTURES","FWD_IN_PDT"}
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
---- 熊猫摆件
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_building_panda","STRUCTURES")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_building_panda",            --  --  inst.prefab  实体名字
    { Ingredient("petals", 1), Ingredient("cutgrass", 2) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        -- min_spacing = 0,
        placer = "fwd_in_pdt_building_panda_placer",                       -------- 建筑放置器,记住不是prefab替换  后面有个placer呢！
        atlas = "images/inventoryimages/fwd_in_pdt_building_panda.xml", ---在哪注册的 一定要注意
        image = "fwd_in_pdt_building_panda.tex",
    },
    {"STRUCTURES","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_building_panda","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 草车
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_cutgrass_container","COOKING")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_cutgrass_container",            --  --  inst.prefab  实体名字
    { Ingredient("bluegem", 2), Ingredient("gears", 2), Ingredient("bearger_fur", 1) }, 
    TECH.SCIENCE_TWO, --- TECH.二本科技
    {
        -- nounlock=true,
        no_deconstruction=false,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        placer = "fwd_in_pdt_cutgrass_container_placer",                       -------- 建筑放置器        
        atlas = "images/map_icons/fwd_in_pdt_deep_freeze.xml",
        image = "fwd_in_pdt_deep_freeze.tex",
    },
    {"COOKING","STRUCTURES","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_cutgrass_container","MODS")                       -- -- 在【模组物品】标签里移除这个。


