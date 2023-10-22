if	TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE ~= true	 then
    return
end


--------------------------------------------------------------------------------------------------------------------------------------------
---- 
-- --------------------------------------------------------------------------------------------------------------------------------------------
GLOBAL.STRINGS.NAMES[string.upper("fwd_in_pdt_skin_test_item")] = "item"    -- -- 制造栏里展示的名字
STRINGS.RECIPE_DESC[string.upper("fwd_in_pdt_skin_test_item")] = "物品"  -- --  制造栏里展示的说明
AddRecipeToFilter("fwd_in_pdt_skin_test_item",string.upper("STRUCTURES"))     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_skin_test_item",            --  --  inst.prefab  实体名字
    {Ingredient("log", 1)}, 
    TECH.NONE, --- TECH.NONE
    {
        -- nounlock=true,no_deconstruction=true,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        -- sg_state = "give",                           --------- 动作（inst.sg 里面的）
        -- actionstr = "CARNIVAL_HOSTSHOP",             --------- 按钮文本
        atlas = GetInventoryItemAtlas("horn.tex"),
        image = "horn.tex",
    },
    {string.upper("STRUCTURES")}
)
RemoveRecipeFromFilter("fwd_in_pdt_skin_test_item","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
GLOBAL.STRINGS.NAMES[string.upper("fwd_in_pdt_skin_test_building")] = "building"    -- -- 制造栏里展示的名字
STRINGS.RECIPE_DESC[string.upper("fwd_in_pdt_skin_test_building")] = "建筑"  -- --  制造栏里展示的说明
AddRecipeToFilter("fwd_in_pdt_skin_test_building",string.upper("STRUCTURES"))     ---- 添加物品到目标标签
AddRecipe2(
    "fwd_in_pdt_skin_test_building",            --  --  inst.prefab  实体名字
    {Ingredient("log", 1)}, 
    TECH.NONE, --- TECH.NONE
    {
        -- nounlock=true,no_deconstruction=true,
        -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
        -- sg_state = "give",                           --------- 动作（inst.sg 里面的）
        -- actionstr = "CARNIVAL_HOSTSHOP",             --------- 按钮文本
        placer = "fwd_in_pdt_skin_test_building_placer",                       -------- 建筑放置器
        atlas = GetInventoryItemAtlas("horn.tex"),
        image = "horn.tex",
    },
    {string.upper("STRUCTURES")}
)
RemoveRecipeFromFilter("fwd_in_pdt_skin_test_building","MODS")                       -- -- 在【模组物品】标签里移除这个。
