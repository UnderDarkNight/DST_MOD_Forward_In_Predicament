



---------------------------------------------------------------------------------------------------------------------
----- 苍术药丸
    local atractylodes_macrocephala_pills = {
        test = function(cooker, names, tags)
            return names.fwd_in_pdt_material_atractylodes_macrocephala and names.fwd_in_pdt_material_atractylodes_macrocephala >= 1 and tags.veggie and tags.veggie >= 4
        end,
        name = "fwd_in_pdt_food_atractylodes_macrocephala_pills", -- 料理名
        weight = 10, -- 食谱权重
        priority = 10, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是肉类
        hunger = 0, --吃后回饥饿值
        health = 0, --吃后回血值
        sanity = 0, --吃后回精神值
        stacksize = 4,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_SUPERSLOW, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",
        cookbook_tex = "fwd_in_pdt_food_atractylodes_macrocephala_pills.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_atractylodes_macrocephala_pills.xml",  
        overridebuild = "fwd_in_pdt_food_atractylodes_macrocephala_pills",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", atractylodes_macrocephala_pills) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", atractylodes_macrocephala_pills) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 半夏药丸
    local pinellia_ternata_pills = {
        test = function(cooker, names, tags)
            return names.fwd_in_pdt_material_pinellia_ternata and names.fwd_in_pdt_material_pinellia_ternata >= 1 and tags.veggie and tags.veggie >= 4
        end,
        name = "fwd_in_pdt_food_pinellia_ternata_pills", -- 料理名
        weight = 10, -- 食谱权重
        priority = 10, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是肉类
        hunger = 0, --吃后回饥饿值
        health = 0, --吃后回血值
        sanity = 0, --吃后回精神值
        stacksize = 4,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_SUPERSLOW, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",
        cookbook_tex = "fwd_in_pdt_food_pinellia_ternata_pills.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_pinellia_ternata_pills.xml",  
        overridebuild = "fwd_in_pdt_food_pinellia_ternata_pills",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", pinellia_ternata_pills) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", pinellia_ternata_pills) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 紫苑药丸
    local aster_tataricus_l_f_pills = {
        test = function(cooker, names, tags)
            return names.fwd_in_pdt_material_aster_tataricus_l_f and names.fwd_in_pdt_material_aster_tataricus_l_f >= 1 and tags.veggie and tags.veggie >= 4
        end,
        name = "fwd_in_pdt_food_aster_tataricus_l_f_pills", -- 料理名
        weight = 10, -- 食谱权重
        priority = 10, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是肉类
        hunger = 0, --吃后回饥饿值
        health = 0, --吃后回血值
        sanity = 0, --吃后回精神值
        stacksize = 4,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_SUPERSLOW, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",
        cookbook_tex = "fwd_in_pdt_food_aster_tataricus_l_f_pills.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_aster_tataricus_l_f_pills.xml",  
        overridebuild = "fwd_in_pdt_food_aster_tataricus_l_f_pills",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", aster_tataricus_l_f_pills) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", aster_tataricus_l_f_pills) -- 将食谱添加进便携锅(大厨锅)
---------------------------------------------------------------------------------------------------------------------