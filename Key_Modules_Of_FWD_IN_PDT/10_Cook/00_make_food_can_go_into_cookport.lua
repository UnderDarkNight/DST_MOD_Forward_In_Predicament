--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 添加一些原本不能进烹饪锅的东西进去

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local cooking = require("cooking")
local ingredients = cooking.ingredients
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 添加函数，做防冲突处理
    local function AddIngredientValues_Fwd_In_Pdt(prefab_or_table,_table)
        if type(_table) ~= "table" then
            return
        end

        if type(prefab_or_table) == "string"  then
                    local prefab = prefab_or_table
                    if ingredients[prefab] == nil then
                        ---------- 原本就没的东西
                        AddIngredientValues({prefab},_table)
                    else
                        -- local target_ingredient = ingredients[prefab]
                        for name, value in pairs(_table) do
                            if name and value then
                                if ingredients[prefab][name] == nil then
                                    ingredients[prefab][name] = value
                                elseif ingredients[prefab][name] < value then
                                    ingredients[prefab][name] = value
                                end
                            end
                        end

                    end
        elseif type(prefab_or_table) == "table" then

            for k, prefab in pairs(prefab_or_table) do
                AddIngredientValues_Fwd_In_Pdt(prefab,_table)
            end
            
        end
    end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddIngredientValues_Fwd_In_Pdt("saltrock",{inedible = 1})       --- 盐晶
AddIngredientValues_Fwd_In_Pdt("ash",{inedible = 1})            --- 灰烬