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
            no_deconstruction=true,
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
        TECH.SCIENCE_ONE, --- TECH.二本科技
        {
            no_deconstruction=true,     
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
        TECH.SCIENCE_ONE, --- TECH.二本科技
        {
            no_deconstruction=true,     
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
            no_deconstruction=true,     
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong.xml",
            image = "fwd_in_pdt_equipment_balloon_bobble_loong.tex",
        },
        {"DECOR","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_balloon_bobble_loong","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 魔法锅铲
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_magic_spatula","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_magic_spatula",            --  --  inst.prefab  实体名字
        { Ingredient("minotaurhorn", 1) ,Ingredient("nightmarefuel", 10 ) }, 
        TECH.ANCIENT_FOUR, --- 完整的远古塔
        {
            no_deconstruction=true,
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_magic_spatula.xml",
            image = "fwd_in_pdt_equipment_magic_spatula.tex",
        },
        {"MAGIC","COOKING","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_equipment_magic_spatula","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 光之护盾
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("fwd_in_pdt_equipment_shield_of_light","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_equipment_shield_of_light",            --  --  inst.prefab  实体名字
        { Ingredient("yellowamulet", 1) ,Ingredient("ruinshat", 3 ),Ingredient("armorruins", 3 )  }, 
        TECH.ANCIENT_FOUR, --- 完整的远古塔
        {
            no_deconstruction=true,
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
        TECH.SCIENCE_ONE, --- THCH.二本科技
        {
            no_deconstruction=true,
            -- atlas = "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.xml",
            atlas = GetInventoryItemAtlas("fishingrod.tex"),
            image = "fishingrod.tex",
        },
        {"MAGIC","FISHING","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_void_fishingrod","MODS")                       -- -- 在【模组物品】标签里移除这个。

