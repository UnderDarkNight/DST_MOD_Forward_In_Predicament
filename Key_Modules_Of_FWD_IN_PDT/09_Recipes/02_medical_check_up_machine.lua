--------------------------------------------------------------------------------------------------------------------------------------------
--- 健康检查机及其科技
--------------------------------------------------------------------------------------------------------------------------------------------
-- 【笔记】
-- 添加自定义原型机
-- 有时候我们需要自定义原型机（研究或制作站）在制作菜单中的显示方式。
-- 原型机指的是科学机器、炼金机器、远古制作台等类似的设备，比如过年活动时的神龛。角色站在旁边时可以制作对应的物品。为了实现这个功能，我们可以使用 AddPrototyperDef 函数自定义原型机的显示方式：

-- AddPrototyperDef(prototyper_prefab, prototyper_def)
-- 其中，prototyper_prefab 是用于原型机的 prefab 名，prototyper_def 是一个包含以下属性的表：
-- icon_atlas (string): 图标文档
-- icon_image (string): 图标图片
-- action_str (string): 「建造」按钮显示的字符串，比如神龛显示的是「供奉」
-- is_crafting_station (bool): 是否是制作站，也就是是否只能在停留附近时才能制作对应物品
-- filter_text (string): 在过滤器上的名称
-- 以下是一个创建自定义原型机定义的示例：

-- local prototyper_prefab = "moon_altar"
-- prototyper_def = {
--     icon_atlas = "images/xxxx.xml",
--     icon_image = "moon_altar.tex",
--     is_crafting_station = true,
--     action_str = "生产",
--     filter_text = "月之产品"
-- },
-- AddPrototyperDef(prototyper_prefab, prototyper_def)
----------------------------------------------------------------------------------------------------------------------------------------
--【笔记】
-- 修改 Recipe
-- 有时候我们需要修改游戏中已存在的 Recipe。为了实现这个功能，我们可以使用 AddRecipePostInit

-- AddRecipePostInit(recipe, fn)
-- 其中，recipe 是要修改的 recipe 名，fn 是一个修改函数，传入参数为这个 recipe 对象。

-- 以下是一个修改指定 Recipe 的示例：
-- local function fn(recipe)-- 修改制作栏描述
--     recipe.description = "适合砍树"
-- end
-- AddRecipePostInit("axe", fn)
----------------------------------------------------------------------------------------------------------------------------------------
--【笔记】
-- 修改任意 Recipe
-- 如果我们需要修改所有的 Recipe，可以使用 AddRecipePostInitAny

-- AddRecipePostInitAny(fn)
-- 其中，fn 是一个修改函数，传入参数为 recipe 对象。这个修改会对所有的 recipe 生效。

-- 以下是一个修改任意 Recipe 的示例
-- 其实就是hook写法
-- local function fn(recipe)-- 统一修改制作栏描述
--     local old_str = recipe.description
--     recipe.description = "描述: " .. old_str
-- end

-- AddRecipePostInitAny(fn)
----------------------------------------------------------------------------------------------------------------------------------------
------- 加载和创建个专属建造标签，并靠近才能使用。
                        ------- 科技要单独设置添加
                        -- table.insert(Assets,      Asset("ATLAS", "images/quagmire_hud.xml")                         )     --  -- 载入贴图文件
                        -- table.insert(Assets,      Asset("IMAGE", "images/quagmire_hud.tex")                         )     --  -- 载入贴图文件
                        -- RegisterInventoryItemAtlas("images/quagmire_hud.xml", "images/quagmire_hud.tex")                -- 注册贴图文件【必须要做】

                        --------- 添加活动tag给指定的 prefab，不能大写。 制作栏 左上角 的图标 和 鼠标过去的文字
                        PROTOTYPER_DEFS["fwd_in_pdt_building_medical_check_up_machine"] = {      ----- 必须是 prefab 的名字
                            icon_atlas ="images/map_icons/fwd_in_pdt_building_medical_check_up_machine.xml", 
                            icon_image = "fwd_in_pdt_building_medical_check_up_machine.tex",	
                            is_crafting_station = true,
                            -- action_str = "TRADE",
                            action_str = "USE",
                            filter_text = "  "
                        } -- 正常
                        ----------------------------------------------------------------------------------------
                        RECIPETABS[string.upper("fwd_in_pdt_building_medical_check_up_machine")] = { 
                            str = string.upper("fwd_in_pdt_building_medical_check_up_machine"),
                            sort = 999, 
                            icon = "fwd_in_pdt_building_medical_check_up_machine.tex", 
                            icon_atlas = "images/map_icons/fwd_in_pdt_building_medical_check_up_machine.xml", 
                            crafting_station = true,
                            shop = true
                        }
                        ----------------------------------------------------------------------------------------
                        local TechTree = require("techtree")
                        TechTree.Create_____temp_old = TechTree.Create
                        TechTree.Create = function(t)
                            t = t or {}
                            for i, v in ipairs(TechTree.AVAILABLE_TECH) do
                                t[v] = t[v] or 0
                            end
                            return t
                        end

                        table.insert(TechTree.AVAILABLE_TECH,string.upper("fwd_in_pdt_building_medical_check_up_machine")) ---- 添加到科技树
                        table.insert(TechTree.BONUS_TECH,string.upper("fwd_in_pdt_building_medical_check_up_machine")) ---- 有奖励的科技树

                        -------------------- 科技参数
                        TECH.NONE[string.upper("fwd_in_pdt_building_medical_check_up_machine")] = 0
                        -- for k, v in pairs(TECH) do
                        --     TECH[k][string.upper("fwd_in_pdt_building_medical_check_up_machine")] = 0
                        -- end
                        TECH[string.upper("fwd_in_pdt_building_medical_check_up_machine")] = {
                            [string.upper("fwd_in_pdt_building_medical_check_up_machine")] = 1,
                        }
                        for k,v in pairs(TUNING.PROTOTYPER_TREES) do    ---------- 给其他标签注入0参数
                            v[string.upper("fwd_in_pdt_building_medical_check_up_machine")] = 0
                        end

                        TUNING.PROTOTYPER_TREES[string.upper("fwd_in_pdt_building_medical_check_up_machine")] = TechTree.Create({   ---- 靠近inst 的时候触发科技树标记位切换
                            [string.upper("fwd_in_pdt_building_medical_check_up_machine")] = 1,
                        })

                        ------- 给其他的添加科技类别 --- TECH.NONE  ---- 这个可能就是 builder_replica 造成崩溃的原因
                        for i, v in pairs(AllRecipes) do
                            if v.level[string.upper("fwd_in_pdt_building_medical_check_up_machine")] == nil then
                                v.level[string.upper("fwd_in_pdt_building_medical_check_up_machine")] = 0
                            end
                        end
                        TechTree.Create = TechTree.Create_____temp_old
                        TechTree.Create_____temp_old = nil



--------------------------------------------------------------------------------------------------------------------------------------------
---- 健康检查机
-- --------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("fwd_in_pdt_building_medical_check_up_machine","PROTOTYPERS")     ---- 添加物品到目标标签
    AddRecipe2(
        "fwd_in_pdt_building_medical_check_up_machine",            --  --  inst.prefab  实体名字
        { Ingredient("cutstone", 2),Ingredient("transistor", 2),Ingredient("boards", 2) }, 
        TECH.SCIENCE_TWO, --- TECH.NONE
        {
            -- nounlock=true,
            no_deconstruction=false,
            -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
            placer = "fwd_in_pdt_building_medical_check_up_machine_placer",                       -------- 建筑放置器        
            atlas = "images/map_icons/fwd_in_pdt_building_medical_check_up_machine.xml",
            image = "fwd_in_pdt_building_medical_check_up_machine.tex",
        },
        {"PROTOTYPERS","RESTORATION","FWD_IN_PDT"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_building_medical_check_up_machine","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 胰岛素注射器(暂留)
--------------------------------------------------------------------------------------------------------------------------------------------
                -- AddRecipeToFilter("fwd_in_pdt_item_insulin__syringe",string.upper("fwd_in_pdt_building_medical_check_up_machine"))     ---- 添加物品到目标标签
                -- AddRecipe2(
                --     "fwd_in_pdt_item_insulin__syringe",            --  --  inst.prefab  实体名字
                --     { Ingredient("spidergland", 10),Ingredient("stinger", 2) }, 
                --     TECH[string.upper("fwd_in_pdt_building_medical_check_up_machine")], --- TECH.NONE
                --     {
                --         nounlock=true,
                --         -- no_deconstruction=true,
                --         -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
                --         -- placer = "fwd_in_pdt_building_medical_check_up_machine_placer",                       -------- 建筑放置器        
                --         atlas = "images/inventoryimages/fwd_in_pdt_item_insulin__syringe.xml",
                --         image = "fwd_in_pdt_item_insulin__syringe.tex",
                --     },
                --     {string.upper("fwd_in_pdt_building_medical_check_up_machine")}
                -- )
                -- RemoveRecipeFromFilter("fwd_in_pdt_item_insulin__syringe","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
local function Add_Recipe_2_Machine(cmd_table)
    -- cmd_table = {
    --     prefab = "",
    --     Ingredients = {},
    --     atlas = "",
    --     image = "",
    --     placer = "",
    --     builder_tag = "",
    --     numtogive = 1,
    --     actionstr = "",      --- 文本文字
    --     sg_state = "",       --- sg
    -- }
    AddRecipeToFilter(cmd_table.prefab,string.upper("fwd_in_pdt_building_medical_check_up_machine")) 
    AddRecipe2(
        cmd_table.prefab,            --  --  inst.prefab  实体名字
        cmd_table.Ingredients or {}, 
        -- TECH[string.upper("fwd_in_pdt_building_medical_check_up_machine")], --- TECH.NONE
        TECH.NONE, --- TECH.NONE
        {
            nounlock=true,
            no_deconstruction=true,
            atlas = cmd_table.atlas,
            image = cmd_table.image,
            placer = cmd_table.placer,
            builder_tag = cmd_table.builder_tag,
            numtogive = cmd_table.numtogive,
            sg_state = cmd_table.sg_state,
            actionstr = cmd_table.actionstr,
            station_tag = "fwd_in_pdt_building_medical_check_up_machine",
        },
        {string.upper("fwd_in_pdt_building_medical_check_up_machine")}
    )
    RemoveRecipeFromFilter(cmd_table.prefab,"MODS")                       -- -- 在【模组物品】标签里移除这个。
end

--------------------------------------------------------------------------------------------------------------------------------------------
--- 胰岛素注射器debug。排头的第一个容易出现无法制作的情况，没空查看原因。用一个隐藏的替代。
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_item_insulin__syringe",
        Ingredients = { },
        builder_tag = "fwd_in_pdt_test33333333333366666",
        atlas = "images/inventoryimages/fwd_in_pdt_item_insulin__syringe.xml",
        image = "fwd_in_pdt_item_insulin__syringe.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 胰岛素注射器
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_item_insulin__syringe",
        Ingredients = { Ingredient("bird_egg", 3),Ingredient("stinger", 2)  },
        atlas = "images/inventoryimages/fwd_in_pdt_item_insulin__syringe.xml",
        image = "fwd_in_pdt_item_insulin__syringe.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 肾上腺素注射剂
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_item_adrenaline_injection",
        Ingredients = { Ingredient("spidergland", 10),Ingredient("stinger", 5) ,Ingredient("froglegs", 5) },
        atlas = "images/inventoryimages/fwd_in_pdt_item_adrenaline_injection.xml",
        image = "fwd_in_pdt_item_adrenaline_injection.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 雄黄解毒剂
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_food_andrographis_paniculata_botany",
        Ingredients = { Ingredient("fwd_in_pdt_material_tree_resin", 2),Ingredient("fwd_in_pdt_material_realgar", 2)  },
        atlas = "images/inventoryimages/fwd_in_pdt_food_andrographis_paniculata_botany.xml",
        image = "fwd_in_pdt_food_andrographis_paniculata_botany.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 万能解毒剂 
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_food_universal_antidote",
        Ingredients = { Ingredient("fwd_in_pdt_material_snake_skin", 1),Ingredient("stinger", 2),Ingredient("fwd_in_pdt_material_realgar", 1),Ingredient("froglegs", 2)  },
        atlas = "images/inventoryimages/fwd_in_pdt_food_universal_antidote.xml",
        image = "fwd_in_pdt_food_universal_antidote.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 诊断单 
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_item_medical_certificate",
        Ingredients = { Ingredient("papyrus", 1) },
        -- atlas = GetInventoryItemAtlas("scandata.tex"),
        atlas = "images/inventoryimages/fwd_in_pdt_item_medical_certificate.xml",
        image = "fwd_in_pdt_item_medical_certificate.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 正骨水 
--------------------------------------------------------------------------------------------------------------------------------------------
Add_Recipe_2_Machine({
    prefab = "fwd_in_pdt_item_orthopedic_water",
    Ingredients = { Ingredient("boneshard", 10),Ingredient("ice", 5) },
    -- atlas = GetInventoryItemAtlas("scandata.tex"),
    atlas = "images/inventoryimages/fwd_in_pdt_item_orthopedic_water.xml",
    image = "fwd_in_pdt_item_orthopedic_water.tex",
})
--------------------------------------------------------------------------------------------------------------------------------------------
--- 维生素A口服液 
--------------------------------------------------------------------------------------------------------------------------------------------
Add_Recipe_2_Machine({
    prefab = "fwd_in_pdt_item_vitamin_a_oral_solution",
    Ingredients = { Ingredient("fwd_in_pdt_food_pig_liver", 2),Ingredient("ice", 5) },
    -- atlas = GetInventoryItemAtlas("scandata.tex"),
    atlas = "images/inventoryimages/fwd_in_pdt_item_vitamin_a_oral_solution.xml",
    image = "fwd_in_pdt_item_vitamin_a_oral_solution.tex",
})
--------------------------------------------------------------------------------------------------------------------------------------------
--- 癫痫散 
--------------------------------------------------------------------------------------------------------------------------------------------
Add_Recipe_2_Machine({
    prefab = "fwd_in_pdt_item_mouse_and_camera_crazy_powder",
    Ingredients = { Ingredient("fwd_in_pdt_food_pig_liver", 1),Ingredient("fwd_in_pdt_food_large_intestine", 1),Ingredient("boneshard", 2) },
    -- atlas = GetInventoryItemAtlas("scandata.tex"),
    atlas = "images/inventoryimages/fwd_in_pdt_item_mouse_and_camera_crazy_powder.xml",
    image = "fwd_in_pdt_item_mouse_and_camera_crazy_powder.tex",
})
--------------------------------------------------------------------------------------------------------------------------------------------
