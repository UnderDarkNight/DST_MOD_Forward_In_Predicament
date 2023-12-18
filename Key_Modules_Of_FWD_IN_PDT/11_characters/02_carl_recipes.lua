


--------------------------------------------------------------------------------------------------------------------------------------------
---- 血瓶
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_item_bloody_flask","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_item_bloody_flask",            --  --  inst.prefab  实体名字
    { Ingredient(CHARACTER_INGREDIENT.HEALTH, 50) }, 
    TECH.NONE, --- TECH.NONE
    {
        nounlock=true,
        no_deconstruction=true,
        builder_tag = "fwd_in_pdt_carl",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        atlas = "images/inventoryimages/fwd_in_pdt_item_bloody_flask.xml",
        image = "fwd_in_pdt_item_bloody_flask.tex",
    },
    {"CHARACTER"}
)
RemoveRecipeFromFilter("fwd_in_pdt_item_bloody_flask","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 吸血鬼之剑
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("fwd_in_pdt_equipment_vampire_sword","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_equipment_vampire_sword",            --  --  inst.prefab  实体名字
    { Ingredient(CHARACTER_INGREDIENT.HEALTH, 800) }, 
    TECH.NONE, --- TECH.NONE
    {
        nounlock=true,
        no_deconstruction=true,
        builder_tag = "fwd_in_pdt_carl",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        atlas = "images/inventoryimages/fwd_in_pdt_equipment_vampire_sword.xml",
        image = "fwd_in_pdt_equipment_vampire_sword.tex",
    },
    {"CHARACTER"}
)
RemoveRecipeFromFilter("fwd_in_pdt_equipment_vampire_sword","MODS")                       -- -- 在【模组物品】标签里移除这个。