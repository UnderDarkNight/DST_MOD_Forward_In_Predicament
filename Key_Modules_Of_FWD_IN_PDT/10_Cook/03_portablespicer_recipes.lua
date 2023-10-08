---------------------------------------------------------------------------------------------------------------------
--- 便携香料站 的配方 

---------------------------------------------------------------------------------------------------------------------
-- local cooking = require("cooking")
-- local cooking_ingredients = cooking.ingredients
local meat_food_type = {
    [FOODTYPE.MEAT] = true,     -- 肉类
    [FOODTYPE.INSECT] = true,   -- 虫子
}

local function check_is_meat(prefab)
    -- cooking_ingredients[food_base_prefab] and cooking_ingredients[food_base_prefab].tags and cooking_ingredients[food_base_prefab].tags["sweetener"] 
    local ret_flag = false
    local test_food = SpawnPrefab(prefab)
    if test_food and test_food.components and test_food.components.edible then
        ret_flag = meat_food_type[test_food.components.edible.foodtype] or false
    end
    test_food:Remove()
    return ret_flag
end
---------------------------------------------------------------------------------------------------------------------
----- 臭豆腐沙拉
    local fwd_in_pdt_food_stinky_tofu_salad = {
        test = function(cooker, names, tags)
            -- return (names.fwd_in_pdt_food_stinky_tofu or 0) >=1
            if names.fwd_in_pdt_food_stinky_tofu then
                for cooked_food_prefab, num in pairs(names) do
                    if cooked_food_prefab ~= "fwd_in_pdt_food_stinky_tofu" and not check_is_meat(cooked_food_prefab) then
                        return true
                    end
                end
            end
            return false
        end,
        name = "fwd_in_pdt_food_stinky_tofu_salad", -- 料理名
        weight = 10, -- 食谱权重
        priority = 10, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.VEGGIE, --料理的食物类型，比如这里定义的是肉类
        hunger = 0 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 2,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_stinky_tofu_salad.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_stinky_tofu_salad.xml",  
        overridebuild = "fwd_in_pdt_food_stinky_tofu_salad",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
    }

    AddCookerRecipe("portablespicer", fwd_in_pdt_food_stinky_tofu_salad) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 臭豆腐肉酱
    local fwd_in_pdt_food_stinky_tofu_bolognese = {
        test = function(cooker, names, tags)
                    if names.fwd_in_pdt_food_stinky_tofu then
                        for cooked_food_prefab, num in pairs(names) do
                            if cooked_food_prefab ~= "fwd_in_pdt_food_stinky_tofu" and check_is_meat(cooked_food_prefab) then
                                return true
                            end
                        end
                    end
                    return false
        end,
        name = "fwd_in_pdt_food_stinky_tofu_bolognese", -- 料理名
        weight = 10, -- 食谱权重
        priority = 10, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.MEAT, --料理的食物类型，比如这里定义的是肉类
        hunger = 0 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 2,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_stinky_tofu_bolognese.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_stinky_tofu_bolognese.xml",  
        overridebuild = "fwd_in_pdt_food_stinky_tofu_bolognese",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
    }

    AddCookerRecipe("portablespicer", fwd_in_pdt_food_stinky_tofu_bolognese) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------