--------------------------------------------------------------------------------------------------------------------------------------------
--- 健康检查机及其科技
--------------------------------------------------------------------------------------------------------------------------------------------




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
            -- no_deconstruction=true,
            -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
            placer = "fwd_in_pdt_building_medical_check_up_machine_placer",                       -------- 建筑放置器        
            atlas = "images/map_icons/fwd_in_pdt_building_medical_check_up_machine.xml",
            image = "fwd_in_pdt_building_medical_check_up_machine.tex",
        },
        {"PROTOTYPERS","RESTORATION"}
    )
    RemoveRecipeFromFilter("fwd_in_pdt_building_medical_check_up_machine","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 胰岛素注射器(暂留)
--------------------------------------------------------------------------------------------------------------------------------------------
                -- AddRecipeToFilter("fwd_in_pdt_item_insulin_syringe",string.upper("fwd_in_pdt_building_medical_check_up_machine"))     ---- 添加物品到目标标签
                -- AddRecipe2(
                --     "fwd_in_pdt_item_insulin_syringe",            --  --  inst.prefab  实体名字
                --     { Ingredient("spidergland", 10),Ingredient("stinger", 2) }, 
                --     TECH[string.upper("fwd_in_pdt_building_medical_check_up_machine")], --- TECH.NONE
                --     {
                --         nounlock=true,
                --         -- no_deconstruction=true,
                --         -- builder_tag = "npng_tag.has_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
                --         -- placer = "fwd_in_pdt_building_medical_check_up_machine_placer",                       -------- 建筑放置器        
                --         atlas = "images/inventoryimages/fwd_in_pdt_item_insulin_syringe.xml",
                --         image = "fwd_in_pdt_item_insulin_syringe.tex",
                --     },
                --     {string.upper("fwd_in_pdt_building_medical_check_up_machine")}
                -- )
                -- RemoveRecipeFromFilter("fwd_in_pdt_item_insulin_syringe","MODS")                       -- -- 在【模组物品】标签里移除这个。
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
        TECH[string.upper("fwd_in_pdt_building_medical_check_up_machine")], --- TECH.NONE
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
        },
        {string.upper("fwd_in_pdt_building_medical_check_up_machine")}
    )
    RemoveRecipeFromFilter(cmd_table.prefab,"MODS")                       -- -- 在【模组物品】标签里移除这个。
end

--------------------------------------------------------------------------------------------------------------------------------------------
--- 胰岛素注射器debug。排头的第一个容易出现无法制作的情况，没空查看原因。用一个隐藏的替代。
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_item_insulin_syringe",
        Ingredients = { },
        builder_tag = "fwd_in_pdt_test33333333333366666",
        atlas = "images/inventoryimages/fwd_in_pdt_item_insulin_syringe.xml",
        image = "fwd_in_pdt_item_insulin_syringe.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 胰岛素注射器
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_item_insulin_syringe",
        Ingredients = { Ingredient("spidergland", 10),Ingredient("stinger", 2)  },
        atlas = "images/inventoryimages/fwd_in_pdt_item_insulin_syringe.xml",
        image = "fwd_in_pdt_item_insulin_syringe.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 雄黄解毒剂
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_food_andrographis_paniculata_botany",
        Ingredients = { Ingredient("spidergland", 1),Ingredient("honey", 1),Ingredient("fwd_in_pdt_material_realgar", 1)  },
        atlas = "images/inventoryimages/fwd_in_pdt_food_andrographis_paniculata_botany.xml",
        image = "fwd_in_pdt_food_andrographis_paniculata_botany.tex",
    })
--------------------------------------------------------------------------------------------------------------------------------------------
--- 万能解毒剂 
--------------------------------------------------------------------------------------------------------------------------------------------
    Add_Recipe_2_Machine({
        prefab = "fwd_in_pdt_food_universal_antidote",
        Ingredients = { Ingredient("spidergland", 10),Ingredient("honey", 10),Ingredient("fwd_in_pdt_material_realgar", 10),Ingredient("froglegs", 10)  },
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
