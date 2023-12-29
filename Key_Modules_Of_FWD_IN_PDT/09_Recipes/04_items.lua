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
    TECH.NONE, --- TECH.NONE
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

