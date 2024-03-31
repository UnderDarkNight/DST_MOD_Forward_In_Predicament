--------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------
---- 避蛇护符
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_item_talisman_that_repels_snakes","REFINE")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_item_talisman_that_repels_snakes",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
        TECH.MAGIC_THREE, --- 魔法三本
        {
            -- nounlock=true,
            no_deconstruction=false,
            -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
            -- placer = "fwd_in_pdt_item_talisman_that_repels_snakes",                       -------- 建筑放置器        
            atlas = "images/inventoryimages/fwd_in_pdt_item_talisman_that_repels_snakes.xml",
            image = "fwd_in_pdt_item_talisman_that_repels_snakes.tex",
        },
        {"REFINE","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_item_talisman_that_repels_snakes","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 龙气球
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_loong_balloon","DECOR")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_loong_balloon",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_material_tree_resin", 2)}, 
        TECH.SCIENCE_ONE, --- TECH.一本科技
        {
            no_deconstruction=false,     
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_loong_balloon.xml",
            image = "fwd_in_pdt_equipment_loong_balloon.tex",
        },
        {"DECOR","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_loong_balloon","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 邪龙气球
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_balloon_evil_dragon","DECOR")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_balloon_evil_dragon",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_material_tree_resin", 2)}, 
        TECH.SCIENCE_ONE, --- TECH.一本科技
        {
            no_deconstruction=false,     
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_balloon_evil_dragon.xml",
            image = "fwd_in_pdt_equipment_balloon_evil_dragon.tex",
        },
        {"DECOR","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_balloon_evil_dragon","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 泡泡龙气球
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_balloon_bobble_loong","DECOR")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_balloon_bobble_loong",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_material_tree_resin", 2)}, 
        TECH.SCIENCE_ONE, --- TECH.一本科技
        {
            no_deconstruction=false,     
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong.xml",
            image = "fwd_in_pdt_equipment_balloon_bobble_loong.tex",
        },
        {"DECOR","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_balloon_bobble_loong","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 魔法锅铲
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_magic_spatula","CRAFTING_STATION")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_magic_spatula",            --  --  inst.prefab  实体名字
        { Ingredient("minotaurhorn", 1) ,Ingredient("nightmarefuel", 10 ) }, 
        TECH.ANCIENT_FOUR, --- 完整的远古塔
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_magic_spatula.xml",
            image = "fwd_in_pdt_equipment_magic_spatula.tex",
        },
        {"MAGIC","COOKING","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_magic_spatula","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 光之护盾
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_shield_of_light","CRAFTING_STATION")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_shield_of_light",            --  --  inst.prefab  实体名字
        { Ingredient("yellowamulet", 1) ,Ingredient("ruinshat", 3 ),Ingredient("armorruins", 3 )  }, 
        TECH.ANCIENT_FOUR, --- 完整的远古塔
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.xml",
            image = "fwd_in_pdt_equipment_shield_of_light.tex",
        },
        {"MAGIC","ARMOUR","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_shield_of_light","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 虚空钓竿
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_void_fishingrod","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_void_fishingrod",            --  --  inst.prefab  实体名字
        { Ingredient("spidereggsack", 4) }, 
        TECH.SCIENCE_ONE, --- THCH.一本科技
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_void_fishingrod.xml",
            -- atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fwd_in_pdt_void_fishingrod.tex",
        },
        {"MAGIC","FISHING","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_void_fishingrod","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 望远镜
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_telescope","TOOLS")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_telescope",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_material_tree_resin", 20),Ingredient("livinglog", 8),Ingredient("moonglass", 1) }, 
        TECH.SCIENCE_TWO, --- THCH.一本科技
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_telescope.xml",
            -- atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fwd_in_pdt_equipment_telescope.tex",
        },
        {"TOOLS","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_telescope","MODS")                       -- -- 在【模组物品】标签里移除这个。


--------------------------------------------------------------------------------------------------------------------------------------------
---- 猪人笛子
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_item_pig_flute","TOOLS")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_item_pig_flute",            --  --  inst.prefab  实体名字
        { Ingredient("pigskin", 4),Ingredient("livinglog", 4) }, 
        TECH.SCIENCE_ONE, --- THCH.一本科技
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_item_pig_flute.xml",
            -- atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fwd_in_pdt_item_pig_flute.tex",
        },
        {"TOOLS","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_item_pig_flute","MODS")                       -- -- 在【模组物品】标签里移除这个。


--------------------------------------------------------------------------------------------------------------------------------------------
---- 疯猪笛子
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_item_werepig_flute","TOOLS")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_item_werepig_flute",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_item_cursed_pig_skin", 2),Ingredient("livinglog", 4) }, 
        TECH.SCIENCE_ONE, --- THCH.一本科技
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_item_werepig_flute.xml",
            -- atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fwd_in_pdt_item_werepig_flute.tex",
        },
        {"TOOLS","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_item_werepig_flute","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 蛇皮地毯
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("turf_fwd_in_pdt_turf_snakeskin","TOOLS")     ---- 添加物品到目标标签
    AddRecipe2(
        "turf_fwd_in_pdt_turf_snakeskin",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_material_snake_skin", 1),Ingredient("rope", 1) }, 
        TECH.SCIENCE_TWO, --- THCH.二本科技
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_turf_snakeskin.xml",
            -- atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fwd_in_pdt_turf_snakeskin.tex",
        },
        {"TOOLS","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("turf_fwd_in_pdt_turf_snakeskin","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 石砖地毯
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("turf_fwd_in_pdt_turf_cobbleroad","TOOLS")     ---- 添加物品到目标标签
    AddRecipe2(
        "turf_fwd_in_pdt_turf_cobbleroad",            --  --  inst.prefab  实体名字
        { Ingredient("cutstone", 2) }, 
        TECH.SCIENCE_TWO, --- THCH.二本科技
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_turf_cobbleroad.xml",
            -- atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fwd_in_pdt_turf_cobbleroad.tex",
        },
        {"TOOLS","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("turf_fwd_in_pdt_turf_cobbleroad","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 草格地毯
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("turf_fwd_in_pdt_turf_grasslawn","TOOLS")     ---- 添加物品到目标标签
    AddRecipe2(
        "turf_fwd_in_pdt_turf_grasslawn",            --  --  inst.prefab  实体名字
        { Ingredient("rope", 2) }, 
        TECH.SCIENCE_TWO, --- THCH.二本科技
        {
            no_deconstruction=false,
            atlas = "images/inventoryimages/fwd_in_pdt_turf_grasslawn.xml",
            -- atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fwd_in_pdt_turf_grasslawn.tex",
        },
        {"TOOLS","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("turf_fwd_in_pdt_turf_grasslawn","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 哈皮雨衣
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_frog_hound_skin_raincoat","RAIN")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_frog_hound_skin_raincoat",            --  --  inst.prefab  实体名字
        { Ingredient("fwd_in_pdt_material_frog_hound_skin", 2),Ingredient("rope", 2)}, 
        TECH.SCIENCE_TWO, --- TECH.一本科技
        {
            no_deconstruction=false,     
            atlas = "images/inventoryimages/fwd_in_pdt_frog_hound_skin_raincoat.xml",
            image = "fwd_in_pdt_frog_hound_skin_raincoat.tex",
        },
        {"RAIN","SUMMER","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_frog_hound_skin_raincoat","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 填海叉
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_ocean_fork","TOOLS")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_ocean_fork",            --  --  inst.prefab  实体名字
        { Ingredient("hermit_cracked_pearl", 1),Ingredient("pitchfork", 1)}, 
        TECH.LOST, --- TECH.蓝图
        {
            no_deconstruction=false,     
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_ocean_fork.xml",
            image = "fwd_in_pdt_equipment_ocean_fork.tex",
        },
        {"TOOLS","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_ocean_fork","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 唤月者魔杖
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_opalstaff_maker","CRAFTING_STATION")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_opalstaff_maker",            --  --  inst.prefab  实体名字
    { Ingredient("opalpreciousgem", 1),Ingredient("livinglog", 4),Ingredient("nightmarefuel", 10) }, 
    TECH.ANCIENT_FOUR, 
    {
        no_deconstruction=false,
        -- numtogive = 3,
        -- sg_state="moonlightcoda_sg_form_log",
        -- builder_tag = "moonlightcoda",
        -- atlas = "images/inventoryimages/moonlightcoda_item_moon_island_detector.xml",
        atlas = GetInventoryItemAtlas("opalstaff.tex"),
        image = "opalstaff.tex",
    },
    {"WEAPONS","MAGIC","FWD_IN_PDT"}
)
RemoveRecipeFromFilter("fwd_in_pdt_opalstaff_maker","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------