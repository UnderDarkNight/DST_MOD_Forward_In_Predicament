
---------------------------------------------------------------------------------------------------------------------
--- 文本表获取
    local function GetStringsTable(name)
        local prefab_name = name or "fwd_in_pdt_gift_pack"
        local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
        return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
    end
--[[
				tags所有标签: 
                fruit-水果度
                monster-怪物度
                sweetener-甜度
                veggie-菜度
                meat-肉度
                frozen-冰度
                fish-鱼度
                egg-蛋度
				decoration-装饰度-蝴蝶翅膀
                fat-油脂度-黄油
                dairy-奶度
                inedible-不可食用度
                seed-种子-桦栗果
                magic-魔法度-噩梦燃料
			]]


---------------------------------------------------------------------------------------------------------------------
----- 疙瘩汤
    local fwd_in_pdt_food_mixed_potato_soup = {
        test = function(cooker, names, tags)
            return (names.ice and names.ice >= 2) 
            and ( (names.potato or 0) + (names.potato_cooked or 0) >= 1) 
            and (tags.veggie and tags.veggie >=2)

            -- local ice_value = names.ice or 0
            -- local potato_value = names.potato or 0
            -- local potato_cooked_value = names.potato_cooked or 0
            -- local veggie_value = tags.veggie or 0
            -- if ice_value == 2 and potato_value + potato_cooked_value >= 1 and veggie_value >=2 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_mixed_potato_soup", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是肉类
        hunger = 150, --吃后回饥饿值
        sanity = 30, --吃后回精神值
        health = 20, --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_mixed_potato_soup.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_mixed_potato_soup.xml",  
        overridebuild = "fwd_in_pdt_food_mixed_potato_soup",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_mixed_potato_soup")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "portablecookpot"
    }

    -- AddCookerRecipe("cookpot", fwd_in_pdt_food_mixed_potato_soup) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_mixed_potato_soup) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_mixed_potato_soup) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 蜂蜜蒸橙
    local fwd_in_pdt_food_steamed_orange_with_honey = {
        test = function(cooker, names, tags)
            return ( names.honey and names.honey >= 1 )
                    and (  names.saltrock and  names.saltrock >=1 )
                    and (  names.fwd_in_pdt_food_orange and  names.fwd_in_pdt_food_orange >=1 )
                    and (  (names.egg or 0) + (names.meat or 0) == 0  )
            -- local honey_value = names.honey or 0
            -- local saltrock_value = names.saltrock or 0
            -- local orange_value = names.fwd_in_pdt_food_orange or 0
            -- local meat_value = tags.meat or 0
            -- local egg_value = tags.egg or 0
            -- if egg_value + meat_value == 0 and honey_value>= 1 and saltrock_value >=1 and orange_value >= 1 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_steamed_orange_with_honey", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 37.5, --吃后回饥饿值
        sanity = 0, --吃后回精神值
        health = 20, --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",   --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_steamed_orange_with_honey.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_steamed_orange_with_honey.xml",  
        overridebuild = "fwd_in_pdt_food_steamed_orange_with_honey",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_steamed_orange_with_honey")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "portablecookpot"
    }

    -- AddCookerRecipe("cookpot", fwd_in_pdt_food_steamed_orange_with_honey) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_steamed_orange_with_honey) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_steamed_orange_with_honey) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 番茄炒蛋
    local fwd_in_pdt_food_scrambled_eggs_with_tomatoes = {
        test = function(cooker, names, tags)
            return ( tags.egg and tags.egg == 2 )
                and ( (names.tomato or 0) + (names.tomato_cooked or 0) >= 1 )
                and ( names.honey and names.honey ==1 )
            -- local tomatoes_value = names.tomato or 0
            -- local tomato_cooked_value = names.tomato_cooked or 0
            -- local egg_value = tags.egg or 0
            -- if egg_value == 2 and tomato_cooked_value + tomatoes_value >= 2  then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_scrambled_eggs_with_tomatoes", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.VEGGIE, --料理的食物类型，比如这里定义的是素食
        hunger = 75 , --吃后回饥饿值
        sanity = 5 , --吃后回精神值
        health = 30 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_scrambled_eggs_with_tomatoes.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_scrambled_eggs_with_tomatoes.xml",  
        overridebuild = "fwd_in_pdt_food_scrambled_eggs_with_tomatoes",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_scrambled_eggs_with_tomatoes")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_scrambled_eggs_with_tomatoes) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_scrambled_eggs_with_tomatoes) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_scrambled_eggs_with_tomatoes) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 茄子盒
    local fwd_in_pdt_food_eggplant_casserole = {
        test = function(cooker, names, tags)
            return ( (names.eggplant or 0 ) + (names.eggplant_cooked or 0) >= 1 )
                and (tags.meat and tags.meat >=1 )
                and ( (tags.monster or 0) < 1)
                and ((names.fwd_in_pdt_food_wheat_flour or 0) + (names.fwd_in_pdt_food_wheat_flour or 0) >=2 )
            -- local eggplant = names.eggplant or 0
            -- local eggplant_cooked = names.eggplant_cooked or 0
            -- local meat = tags.meat or 0
            -- local monster = tags.monster or 0
            -- if meat >=1 and eggplant + eggplant_cooked >= 1 and monster < 1 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_eggplant_casserole", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.MEAT, --料理的食物类型，比如这里定义的是肉类
        hunger = 37.5 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY * 5 , --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_eggplant_casserole.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_eggplant_casserole.xml",  
        overridebuild = "fwd_in_pdt_food_eggplant_casserole",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_eggplant_casserole")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_eggplant_casserole) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_eggplant_casserole) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_eggplant_casserole) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 自然的馈赠
    local fwd_in_pdt_food_gifts_of_nature = {
        test = function(cooker, names, tags)
            return ( names.fwd_in_pdt_material_tree_resin or 0) >= 4
            -- local fwd_in_pdt_material_tree_resin = names.fwd_in_pdt_material_tree_resin or 0
            -- if fwd_in_pdt_material_tree_resin >= 4  then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_gifts_of_nature", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0 , --吃后回饥饿值
        sanity = -30 , --吃后回精神值
        health = -10 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = nil , --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_gifts_of_nature.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_gifts_of_nature.xml",  
        overridebuild = "fwd_in_pdt_food_gifts_of_nature",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_gifts_of_nature")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_gifts_of_nature) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_gifts_of_nature) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_gifts_of_nature) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 蛇皮冻
    local fwd_in_pdt_food_snake_skin_jelly = {
        test = function(cooker, names, tags)
            return ( ( names.fwd_in_pdt_material_snake_skin or 0) >=1 )
                    and ( ( tags.meat  or 0) >=1 )
                    and ( tags.inedible == names.fwd_in_pdt_material_snake_skin )
            -- local fwd_in_pdt_material_snake_skin = names.fwd_in_pdt_material_snake_skin or 0
            -- local meat = tags.meat or 0
            -- local inedible = tags.inedible or 0
            -- if fwd_in_pdt_material_snake_skin >= 1 and meat >= 1 and inedible == fwd_in_pdt_material_snake_skin then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_snake_skin_jelly", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.MEAT, --料理的食物类型，比如这里定义的是肉类
        hunger = 62.5 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = -5 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5 , --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "mid",   --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_snake_skin_jelly.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_snake_skin_jelly.xml",  
        overridebuild = "fwd_in_pdt_food_snake_skin_jelly",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_snake_skin_jelly")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_snake_skin_jelly) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_snake_skin_jelly) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_snake_skin_jelly) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 苍术药丸
    local atractylodes_macrocephala_pills = {
        test = function(cooker, names, tags)
            return names.fwd_in_pdt_material_atractylodes_macrocephala and names.fwd_in_pdt_material_atractylodes_macrocephala >= 1 and tags.veggie and tags.veggie >= 4
        end,
        name = "fwd_in_pdt_food_atractylodes_macrocephala_pills", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0, --吃后回饥饿值
        sanity = 0, --吃后回精神值
        health = 0, --吃后回血值
        stacksize = 4,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_SUPERSLOW, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_atractylodes_macrocephala_pills.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_atractylodes_macrocephala_pills.xml",  
        overridebuild = "fwd_in_pdt_food_atractylodes_macrocephala_pills",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_atractylodes_macrocephala_pills")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", atractylodes_macrocephala_pills) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", atractylodes_macrocephala_pills) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", atractylodes_macrocephala_pills) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 半夏药丸
    local pinellia_ternata_pills = {
        test = function(cooker, names, tags)
            return names.fwd_in_pdt_material_pinellia_ternata and names.fwd_in_pdt_material_pinellia_ternata >= 1 and tags.veggie and tags.veggie >= 4
        end,
        name = "fwd_in_pdt_food_pinellia_ternata_pills", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0, --吃后回饥饿值
        sanity = 0, --吃后回精神值
        health = 0, --吃后回血值
        stacksize = 4,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_SUPERSLOW, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",   --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_pinellia_ternata_pills.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_pinellia_ternata_pills.xml",  
        overridebuild = "fwd_in_pdt_food_pinellia_ternata_pills",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_pinellia_ternata_pills")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", pinellia_ternata_pills) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", pinellia_ternata_pills) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", pinellia_ternata_pills) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 紫苑药丸
    local aster_tataricus_l_f_pills = {
        test = function(cooker, names, tags)
            return names.fwd_in_pdt_material_aster_tataricus_l_f and names.fwd_in_pdt_material_aster_tataricus_l_f >= 1 and tags.veggie and tags.veggie >= 4
        end,
        name = "fwd_in_pdt_food_aster_tataricus_l_f_pills", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999999999999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0, --吃后回饥饿值
        sanity = 0, --吃后回精神值
        health = 0, --吃后回血值
        stacksize = 4,  --- 每次烹饪得到个数
        -- perishtime = TUNING.PERISH_SUPERSLOW, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",   --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_aster_tataricus_l_f_pills.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_aster_tataricus_l_f_pills.xml",  
        overridebuild = "fwd_in_pdt_food_aster_tataricus_l_f_pills",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_aster_tataricus_l_f_pills")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", aster_tataricus_l_f_pills) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", aster_tataricus_l_f_pills) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", aster_tataricus_l_f_pills) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 红伞伞蘑菇汤
    local fwd_in_pdt_food_red_mushroom_soup = {
        test = function(cooker, names, tags)
            return ( (names.red_cap or 0) + (names.red_cap_cooked or 0) >= 4 )
            -- local red_cap = names.red_cap or 0
            -- local red_cap_cooked = names.red_cap_cooked or 0
            -- if red_cap + red_cap_cooked >= 4 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_red_mushroom_soup", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = -100 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_ONE_DAY*10, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "mid",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_red_mushroom_soup.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_red_mushroom_soup.xml",  
        overridebuild = "fwd_in_pdt_food_red_mushroom_soup",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_red_mushroom_soup")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_red_mushroom_soup) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_red_mushroom_soup) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_red_mushroom_soup) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 绿伞伞蘑菇汤
    local fwd_in_pdt_food_green_mushroom_soup = {
        test = function(cooker, names, tags)
            return ( (names.green_cap or 0) + (names.green_cap_cooked or 0) >=4 )
            -- local green_cap = names.green_cap or 0
            -- local green_cap_cooked = names.green_cap_cooked or 0
            -- if green_cap + green_cap_cooked >= 4 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_green_mushroom_soup", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0 , --吃后回饥饿值
        sanity = -100 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_ONE_DAY*10, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "mid",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_green_mushroom_soup.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_green_mushroom_soup.xml",  
        overridebuild = "fwd_in_pdt_food_green_mushroom_soup",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_green_mushroom_soup")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_green_mushroom_soup) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_green_mushroom_soup) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_green_mushroom_soup) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 豆腐
    local fwd_in_pdt_food_tofu = {
        test = function(cooker, names, tags)
            return ( (names.ash or 0 ) >=2 ) and  ( names.fwd_in_pdt_food_soybeans or 0 ) >= 2
            -- local ash = names.ash or 0
            -- local fwd_in_pdt_food_soybeans = names.fwd_in_pdt_food_soybeans or 0
            -- if ash >= 2 and fwd_in_pdt_food_soybeans >= 2 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_tofu", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 25 , --吃后回饥饿值
        sanity = 20 , --吃后回精神值
        health = 1 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_ONE_DAY*8, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_tofu.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_tofu.xml",  
        overridebuild = "fwd_in_pdt_food_tofu",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_tofu")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "portablecookpot"
    }

    -- AddCookerRecipe("cookpot", fwd_in_pdt_food_tofu) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_tofu) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_tofu) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 熟牛奶
    local fwd_in_pdt_food_cooked_milk = {
        test = function(cooker, names, tags)
            return  ( names.ice or 0 ) >=2  and (names.fwd_in_pdt_food_raw_milk or 0) >= 2
            -- local fwd_in_pdt_food_raw_milk = names.fwd_in_pdt_food_raw_milk or 0
            -- local ice = names.ice or 0
            -- if ice >= 2 and fwd_in_pdt_food_raw_milk >= 2 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_cooked_milk", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 10 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = 1 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_ONE_DAY*10, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_cooked_milk.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_cooked_milk.xml",  
        overridebuild = "fwd_in_pdt_food_cooked_milk",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_cooked_milk")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_cooked_milk) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_cooked_milk) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_cooked_milk) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 咖啡
    local fwd_in_pdt_food_coffee = {
        test = function(cooker, names, tags)
            return ( (names.fwd_in_pdt_food_coffeebeans or 0) >= 3 and (names.honey or 0) + (names.royal_jelly or 0) >=1 )
                    or (  names.fwd_in_pdt_food_coffeebeans or 0) >=4
            -- local fwd_in_pdt_food_coffeebeans = names.fwd_in_pdt_food_coffeebeans or 0
            -- local honey = names.honey or 0
            -- local royal_jelly = names.royal_jelly or 0
            -- if fwd_in_pdt_food_coffeebeans >= 4 then
            --     return true
            -- end
            -- if fwd_in_pdt_food_coffeebeans >=3 and ( honey >= 1 or royal_jelly >= 1) then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_coffee", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0 , --吃后回饥饿值
        sanity = -20 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_coffee.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_coffee.xml",  
        overridebuild = "fwd_in_pdt_food_coffee",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_coffee")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_coffee) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_coffee) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_coffee) -- 档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 生理盐水
    local fwd_in_pdt_food_saline_medicine = {
        test = function(cooker, names, tags)
            return (names.saltrock or 0) >= 1 and (names.ice or 0) >= 2 and (tags.veggie or 0) >=1
            -- local saltrock = names.saltrock or 0
            -- local ice = names.ice or 0
            -- local veggie = tags.veggie or 0
            -- if saltrock >= 1 and ice >= 2 and veggie >= 1 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_saline_medicine", -- 料理名
        weight = 100, -- 食谱权重
        priority = 9990, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_MED, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_saline_medicine.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_saline_medicine.xml",  
        overridebuild = "fwd_in_pdt_food_saline_medicine",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_saline_medicine")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_saline_medicine) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_saline_medicine) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_saline_medicine) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 酸奶冰淇淋
    local fwd_in_pdt_food_yogurt_ice_cream = {
        test = function(cooker, names, tags)
            return (names.fwd_in_pdt_food_yogurt or 0) >= 2 and (names.ice or 0)>=1 and (names.twigs or 0) >= 1
            -- local fwd_in_pdt_food_yogurt = names.fwd_in_pdt_food_yogurt or 0
            -- local ice = names.ice or 0
            -- local twigs = names.twigs or 0
            -- if fwd_in_pdt_food_yogurt >= 2 and ice >= 1 and twigs >= 1 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_yogurt_ice_cream", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 12.5 , --吃后回饥饿值
        sanity = 30 , --吃后回精神值
        health = 20 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_yogurt_ice_cream.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_yogurt_ice_cream.xml",  
        overridebuild = "fwd_in_pdt_food_yogurt_ice_cream",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_yogurt_ice_cream")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_yogurt_ice_cream) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_yogurt_ice_cream) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_yogurt_ice_cream) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 杨枝甘露
    local fwd_in_pdt_food_mango_ice_drink = {
        test = function(cooker, names, tags)
            return (names.ice or 0) >= 2 and (names.fwd_in_pdt_food_mango or 0) + (names.fwd_in_pdt_food_mango_green or 0) >=2
            -- local fwd_in_pdt_food_mango = names.fwd_in_pdt_food_mango or 0
            -- local fwd_in_pdt_food_mango_green = names.fwd_in_pdt_food_mango_green or 0
            -- local ice = names.ice or 0
            -- if ice >= 2 and fwd_in_pdt_food_mango_green + fwd_in_pdt_food_mango >= 2  then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_mango_ice_drink", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 0 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY * 5 , --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_mango_ice_drink.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_mango_ice_drink.xml",  
        overridebuild = "fwd_in_pdt_food_mango_ice_drink",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_mango_ice_drink")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "portablecookpot"
    }

    -- AddCookerRecipe("cookpot", fwd_in_pdt_food_mango_ice_drink) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_mango_ice_drink) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_mango_ice_drink) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 白米饭
    local fwd_in_pdt_food_cooked_rice = {
        test = function(cooker, names, tags)
            return ( names.fwd_in_pdt_food_rice or 0 ) >= 4
            -- local fwd_in_pdt_food_rice = names.fwd_in_pdt_food_rice or 0
            -- if fwd_in_pdt_food_rice >= 4 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_cooked_rice", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.VEGGIE, --料理的食物类型，比如这里定义的是素食
        hunger = 120 , --吃后回饥饿值
        sanity = 5 , --吃后回精神值
        health = 3 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_cooked_rice.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_cooked_rice.xml",  
        overridebuild = "fwd_in_pdt_food_cooked_rice",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_cooked_rice")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_cooked_rice) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_cooked_rice) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_cooked_rice) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 面包
    local fwd_in_pdt_food_bread = {
        test = function(cooker, names, tags)
            return (names.fwd_in_pdt_food_wheat_flour or 0) >= 4

            or (name.lg_mianfen or 0) >=4       --海传面粉也行
            -- local fwd_in_pdt_food_wheat_flour = names.fwd_in_pdt_food_wheat_flour or 0
            -- if fwd_in_pdt_food_wheat_flour >= 4 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_bread", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.GOODIES, --料理的食物类型，比如这里定义的是零食
        hunger = 62.5 , --吃后回饥饿值
        sanity = 5 , --吃后回精神值
        health = 3 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_bread.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_bread.xml",  
        overridebuild = "fwd_in_pdt_food_bread",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_bread")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_bread) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_bread) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_bread) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 皮蛋肉粥
    local fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs = {
        test = function(cooker, names, tags)
            return (names.fwd_in_pdt_food_thousand_year_old_egg or 0) >= 1
                and (names.fwd_in_pdt_food_rice or 0) >= 2
                and (tags.meat or 0) >=2
            -- local fwd_in_pdt_food_thousand_year_old_egg = names.fwd_in_pdt_food_thousand_year_old_egg or 0
            -- local fwd_in_pdt_food_rice = names.fwd_in_pdt_food_rice or 0
            -- local meat = tags.meat or 0
            -- if fwd_in_pdt_food_thousand_year_old_egg >= 1 and meat >= 2 and fwd_in_pdt_food_rice >= 2 then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.MEAT, --料理的食物类型，比如这里定义的是肉类
        hunger = 120 , --吃后回饥饿值
        sanity = 5 , --吃后回精神值
        health = 30 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY*5, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs.xml",  
        overridebuild = "fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 蛋白粉
    local fwd_in_pdt_food_protein_powder = {
        test = function(cooker, names, tags)
            return (names.fwd_in_pdt_food_soybeans or 0) >=4
            -- local fwd_in_pdt_food_soybeans = names.fwd_in_pdt_food_soybeans or 0
            -- if fwd_in_pdt_food_soybeans >= 4  then
            --     return true
            -- end
            -- return false
        end,
        name = "fwd_in_pdt_food_protein_powder", -- 料理名
        weight = 10, -- 食谱权重
        priority = 999999999, -- 食谱优先级
        foodtype = GLOBAL.FOODTYPE.VEGGIE, --料理的食物类型，比如这里定义的是素食
        hunger = 0 , --吃后回饥饿值
        sanity = 0 , --吃后回精神值
        health = 0 , --吃后回血值
        stacksize = 1,  --- 每次烹饪得到个数
        perishtime = TUNING.PERISH_TWO_DAY, --腐烂时间
        cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
        potlevel = "low",  --- 锅里的贴图位置 low high  mid
        cookbook_tex = "fwd_in_pdt_food_protein_powder.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
        cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_protein_powder.xml",  
        overridebuild = "fwd_in_pdt_food_protein_powder",          ----- build (zip名字)
        overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
        floater = {"med", nil, 0.55},
        oneat_desc = GetStringsTable("fwd_in_pdt_food_protein_powder")["oneat_desc"],    --- 副作用一栏显示的文本
        cookbook_category = "cookpot"
    }

    AddCookerRecipe("cookpot", fwd_in_pdt_food_protein_powder) -- 将食谱添加进普通锅
    AddCookerRecipe("portablecookpot", fwd_in_pdt_food_protein_powder) -- 将食谱添加进便携锅(大厨锅)
    AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_protein_powder) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- 拍黄瓜
local fwd_in_pdt_food_garlic_cucumber = {
    test = function(cooker, names, tags)
        return (names.garlic or 0) >=1 and (names.ice or 0) >=2 and (names.plantmeat or 0) >=1
        -- local fwd_in_pdt_food_soybeans = names.fwd_in_pdt_food_soybeans or 0
        -- if fwd_in_pdt_food_soybeans >= 4  then
        --     return true
        -- end
        -- return false
    end,
    name = "fwd_in_pdt_food_garlic_cucumber", -- 料理名
    weight = 10, -- 食谱权重
    priority = 999999999999, -- 食谱优先级
    foodtype = GLOBAL.FOODTYPE.GODDIES, --料理的食物类型，比如这里定义的是素食
    hunger = 25 , --吃后回饥饿值
    sanity = 10 , --吃后回精神值
    health = 10 , --吃后回血值
    stacksize = 1,  --- 每次烹饪得到个数
    perishtime = TUNING.PERISH_TWO_DAY, --腐烂时间
    cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
    potlevel = "low",  --- 锅里的贴图位置 low high  mid
    cookbook_tex = "fwd_in_pdt_food_garlic_cucumber.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
    cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_garlic_cucumber.xml",  
    overridebuild = "fwd_in_pdt_food_garlic_cucumber",          ----- build (zip名字)
    overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
    floater = {"med", nil, 0.55},
    oneat_desc = GetStringsTable("fwd_in_pdt_food_garlic_cucumber")["oneat_desc"],    --- 副作用一栏显示的文本
    cookbook_category = "cookpot"
}

AddCookerRecipe("cookpot", fwd_in_pdt_food_garlic_cucumber) -- 将食谱添加进普通锅
AddCookerRecipe("portablecookpot", fwd_in_pdt_food_garlic_cucumber) -- 将食谱添加进便携锅(大厨锅)
AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_garlic_cucumber) --档案馆远古窑，有好多mod作者忽略了这口锅
---------------------------------------------------------------------------------------------------------------------
----- 猫屎咖啡
local fwd_in_pdt_food_coffee_luwak = {
    test = function(cooker, names, tags)
        return (names.fwd_in_pdt_food_coffeebeans or 0) >=3 and (names.fwd_in_pdt_food_cat_feces or 0) >=1

        or (names.lg_coffee or 0) >=3 and (names.fwd_in_pdt_food_cat_feces or 0) >=1 -- 海传咖啡做了兼容
        -- if fwd_in_pdt_food_soybeans >= 4  then
        --     return true
        -- end
        -- return false
    end,
    name = "fwd_in_pdt_food_coffee_luwak", -- 料理名
    weight = 10, -- 食谱权重
    priority = 999999999999, -- 食谱优先级
    foodtype = GLOBAL.FOODTYPE.GODDIES, --料理的食物类型，比如这里定义的是零食
    hunger = 12.5 , --吃后回饥饿值
    sanity = 50 , --吃后回精神值
    health = 8 , --吃后回血值
    stacksize = 1,  --- 每次烹饪得到个数
    perishtime = TUNING.PERISH_TWO_DAY, --腐烂时间
    cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
    potlevel = "low",  --- 锅里的贴图位置 low high  mid
    cookbook_tex = "fwd_in_pdt_food_coffee_luwak.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
    cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_coffee_luwak.xml",  
    overridebuild = "fwd_in_pdt_food_coffee_luwak",          ----- build (zip名字)
    overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
    floater = {"med", nil, 0.55},
    oneat_desc = GetStringsTable("fwd_in_pdt_food_coffee_luwak")["oneat_desc"],    --- 副作用一栏显示的文本
    cookbook_category = "cookpot"
}

AddCookerRecipe("cookpot", fwd_in_pdt_food_coffee_luwak) -- 将食谱添加进普通锅
AddCookerRecipe("portablecookpot", fwd_in_pdt_food_coffee_luwak) -- 将食谱添加进便携锅(大厨锅)
AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_coffee_luwak) --档案馆远古窑，有好多mod作者忽略了这口锅
-------------------------------------------------------------------------------------------------------------------
----- 人肉包子
local fwd_in_pdt_food_meat_buns = {
    test = function(cooker, names, tags)
        return (names.monstermeat or 0) >=2 and (names.fwd_in_pdt_food_wheat_flour or 0) >=2
            and ( --新月那天才能做出来
                    tags.newmoon or --一定要用or
                    TheWorld and TheWorld.state and not TheWorld:HasTag("cave") --洞穴永远是新月，这里得多加个洞穴判定
                    and TheWorld.state.moonphase == "new"
                )
        -- if fwd_in_pdt_food_soybeans >= 4  then
        --     return true
        -- end
        -- return false
    end,
    name = "fwd_in_pdt_food_meat_buns", -- 料理名
    weight = 10, -- 食谱权重
    priority = 999999999999, -- 食谱优先级
    foodtype = GLOBAL.FOODTYPE.GODDIES, --料理的食物类型，比如这里定义的是零食
    hunger = 150 , --吃后回饥饿值
    sanity = 150 , --吃后回精神值
    health = 150 , --吃后回血值
    stacksize = 5,  --- 每次烹饪得到个数
    perishtime = TUNING.PERISH_TWO_DAY*10000, --腐烂时间
    cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
    potlevel = "low",  --- 锅里的贴图位置 low high  mid
    cookbook_tex = "fwd_in_pdt_food_meat_buns.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
    cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_meat_buns.xml",  
    overridebuild = "fwd_in_pdt_food_meat_buns",          ----- build (zip名字)
    overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
    floater = {"med", nil, 0.55},
    oneat_desc = GetStringsTable("fwd_in_pdt_food_meat_buns")["oneat_desc"],    --- 副作用一栏显示的文本
    cookbook_category = "cookpot"
}

AddCookerRecipe("cookpot", fwd_in_pdt_food_meat_buns) -- 将食谱添加进普通锅
AddCookerRecipe("portablecookpot", fwd_in_pdt_food_meat_buns) -- 将食谱添加进便携锅(大厨锅)
AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_meat_buns) --档案馆远古窑，有好多mod作者忽略了这口锅
-------------------------------------------------------------------------------------------------------------------
----- 蛋黄月饼
local fwd_in_pdt_food_egg_mooncake = {
    test = function(cooker, names, tags)
        return (tags.egg or 0) >=4 and (names.fwd_in_pdt_food_wheat_flour or 0) >=2
            
        -- if fwd_in_pdt_food_soybeans >= 4  then
        --     return true
        -- end
        -- return false
    end,
    name = "fwd_in_pdt_food_egg_mooncake", -- 料理名
    weight = 10, -- 食谱权重
    priority = 999999999999, -- 食谱优先级
    foodtype = GLOBAL.FOODTYPE.GODDIES, --料理的食物类型，比如这里定义的是零食
    hunger = 0 , --吃后回饥饿值
    sanity = 0 , --吃后回精神值
    health = 0 , --吃后回血值
    stacksize = 5,  --- 每次烹饪得到个数
    perishtime = nil, --腐烂时间
    cooktime = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1/4 or 30/20, --烹饪时间(单位20s :  数字1 为 20s ,)
    potlevel = "low",  --- 锅里的贴图位置 low high  mid
    cookbook_tex = "fwd_in_pdt_food_egg_mooncake.tex", -- 在游戏内食谱书里的mod食物那一栏里显示的图标，tex在 atlas的xml里定义了，所以这里只写文件名即可
    cookbook_atlas = "images/inventoryimages/fwd_in_pdt_food_egg_mooncake.xml",  
    overridebuild = "fwd_in_pdt_food_egg_mooncake",          ----- build (zip名字)
    overridesymbolname = "png",     ----- scml 的图层名字（图片所在的文件夹名）
    floater = {"med", nil, 0.55},
    oneat_desc = GetStringsTable("fwd_in_pdt_food_egg_mooncake")["oneat_desc"],    --- 副作用一栏显示的文本
    cookbook_category = "cookpot"
}

-- AddCookerRecipe("cookpot", fwd_in_pdt_food_egg_mooncake) -- 将食谱添加进普通锅
AddCookerRecipe("portablecookpot", fwd_in_pdt_food_egg_mooncake) -- 将食谱添加进便携锅(大厨锅)
AddCookerRecipe("archive_cookpot", fwd_in_pdt_food_egg_mooncake) --档案馆远古窑，有好多mod作者忽略了这口锅
-------------------------------------------------------------------------------------------------------------------