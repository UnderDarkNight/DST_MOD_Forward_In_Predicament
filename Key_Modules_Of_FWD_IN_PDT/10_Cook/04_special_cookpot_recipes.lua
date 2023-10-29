----------------------------------------------------------------------------------------------
---- 这个文件用来把 食谱添加到 自制 烹饪锅用
---- 为了兼容模组食物，把 代码放到 Time 0 执行
----------------------------------------------------------------------------------------------

local cooking = require("cooking")


AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:DoTaskInTime(0,function()        
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        -- cooking.recipes["portablecookpot"]  ---- 大厨料理锅列表
        -- cooking.recipes["cookpot"]          ---- 普通料理锅列表

        for temp_recipe_name , temp_recipe_data  in pairs(cooking.recipes["portablecookpot"]) do
            if temp_recipe_name and temp_recipe_data then
                temp_recipe_data.no_cookbook = true     ---- 让原来的食谱不进入【模组食谱】一栏
                AddCookerRecipe("fwd_in_pdt_building_special_cookpot",temp_recipe_data)
            end
        end
        for temp_recipe_name , temp_recipe_data  in pairs(cooking.recipes["cookpot"]) do
            if temp_recipe_name and temp_recipe_data then
                temp_recipe_data.no_cookbook = true     ---- 让原来的食谱不进入【模组食谱】一栏
                AddCookerRecipe("fwd_in_pdt_building_special_cookpot",temp_recipe_data)
            end
        end
        
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
        end)
    end
)