----------------------------------------------------------------------------------------------
---- 这个文件用来把 食谱添加到 自制 烹饪锅用
---- 为了兼容模组食物，把 代码放到 Time 0 执行
----------------------------------------------------------------------------------------------

local cooking = require("cooking")


AddPrefabPostInit(
    "world",
    function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end
        inst:DoTaskInTime(0,function()
            pcall(function()
                
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
                            -- ----------------------------------------------------------------------
                            --     pcall(function()
                            --         ---- 尝试兼容 烹饪配方显示  workshop-727774324
                            --         -- if type(GLOBAL.AddCookingPot) == "function" then
                            --         --     pcall(GLOBAL.AddCookingPot,"fwd_in_pdt_building_special_cookpot")
                            --         -- end
                            --         global("COOKINGPOTS")
                            --         COOKINGPOTS = COOKINGPOTS or {}
                            --         COOKINGPOTS["fwd_in_pdt_building_special_cookpot"] = {}
                            --     end)
                            --     ----------------------------------------------------------------------
                            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
            end)
        end)
    end
)



-- print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
-- local cmd = {
--     ["GetIsClient"] = false,
--     ["GetIsHosting"]= false,
--     ["GetIsMasterSimulation"]= false,
--     ["GetIsServer"]= false,
--     ["GetIsServerAdmin"]= false,
--     ["GetIsServerOwner"]= false,
--     ["IsDedicated"]= false,
-- }
-- -- local TheNet_Temp = getmetatable(TheNet).__index
-- -- for index, value in pairs(TheNet_Temp) do
-- --     if type(value) == "function" then
-- --         pcall(function()
-- --             print(index, TheNet[index](TheNet))
-- --         end)
-- --     end
-- -- end
-- for index, v in pairs(cmd) do
--     print(index,TheNet[index](TheNet))
-- end

-- print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
