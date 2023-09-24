return {
    -------------------------------------------------------------------------------------------------------------
    ---- 水稻种子获取
        {
            source = {     
                {                            } ,  {prefab = "seeds" , num = 2, },           {                            },
                {prefab = "seeds" , num = 2, } ,  {prefab = "goldenpickaxe" , use = 1, },   {prefab = "seeds" , num = 2, },
                {                            } ,  {prefab = "seeds" , num = 2, },           {                            },
            },
            ret = {
                prefab = "fwd_in_pdt_plant_paddy_rice_seed",
                num = 4,
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_plant_paddy_rice_seed.tex"),
                image =  "fwd_in_pdt_plant_paddy_rice_seed.tex",
                finish_fn = function(inst,doer,times) --- 给奖励后执行的函数。                   
                    --- times -- 奖励次数
                end,
                item_fn = function(rewarded_items_insts,doer) --- 用来触发某些奖励物品的执行事件
                    
                end,
                
            }
        },
    -------------------------------------------------------------------------------------------------------------
    ---- 稻米脱壳 配方
        {
            -- player_check_fn = function(doer)    --- 检查玩家能不能做这个物品
            --     print("player_check_fn",doer)
            --     return doer and doer.prefab == "woodie"
            -- end,
            source = {     
                {prefab = "fwd_in_pdt_plant_paddy_rice_seed" , num = 1} ,  {                          },   {prefab = "fwd_in_pdt_plant_paddy_rice_seed" , num = 1},
                {                                                     } ,  {prefab = "hammer" ,use = 1},   {                                                     },
                {prefab = "fwd_in_pdt_plant_paddy_rice_seed" , num = 1} ,  {                          },   {prefab = "fwd_in_pdt_plant_paddy_rice_seed" , num = 1},
            },
            ret = {
                prefab = "fwd_in_pdt_food_rice",
                num = 4,
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_food_rice.tex"),
                image =  "fwd_in_pdt_food_rice.tex",
                finish_fn = function(inst,doer,times) --- 给奖励后执行的函数。                    
                    --- times -- 奖励次数
                end,
                item_fn = function(rewarded_items_insts,doer) --- 用来触发某些奖励物品的执行事件
                    
                end,
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 修复法杖
        {
            source = {     
                {prefab = "fwd_in_pdt_item_flame_core" , num = 5} ,  {                                         },   {prefab = "yellowstaff" , remove = true       },
                {                                                    } ,  {prefab = "greenstaff" ,remove = true},   {                                         },
                {prefab = "opalstaff" , remove = true           } ,  {                                         },   {prefab = "fwd_in_pdt_item_ice_core" , num = 5},
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_repair_staff",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_repair_staff.tex"),
                image =  "fwd_in_pdt_equipment_repair_staff.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 炽热长矛
        {
            source = {     
                {prefab = "fwd_in_pdt_item_flame_core" , num = 1} ,  {                               },   {                               },
                {                                               } ,  {prefab = "spear" ,remove = true},   {                               },
                {                                               } ,  {                               },   {                               },
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_blazing_spear",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_blazing_spear.tex"),
                image =  "fwd_in_pdt_equipment_blazing_spear.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 炽热火腿
        {
            source = {     
                {prefab = "fwd_in_pdt_item_flame_core" , num = 5} ,  {                               },   {                               },
                {                                               } ,  {prefab = "hambat" ,remove = true},   {                               },
                {                                               } ,  {                               },   {                               },
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_blazing_hambat",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_blazing_hambat.tex"),
                image =  "fwd_in_pdt_equipment_blazing_hambat.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 炽热暗影剑
        {
            source = {     
                {prefab = "fwd_in_pdt_item_flame_core" , num = 10} ,  {                               },   {                               },
                {                                               } ,  {prefab = "nightsword" ,remove = true},   {                               },
                {                                               } ,  {                               },   {                               },
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_blazing_nightmaresword",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_blazing_nightmaresword.tex"),
                image =  "fwd_in_pdt_equipment_blazing_nightmaresword.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 极寒长矛
        {
            source = {     
                {prefab = "fwd_in_pdt_item_ice_core" , num = 1} ,  {                               },   {                               },
                {                                               } ,  {prefab = "spear" ,remove = true},   {                               },
                {                                               } ,  {                               },   {                               },
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_frozen_spear",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_frozen_spear.tex"),
                image =  "fwd_in_pdt_equipment_frozen_spear.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 极寒火腿
        {
            source = {     
                {prefab = "fwd_in_pdt_item_ice_core" , num = 5} ,  {                               },   {                               },
                {                                               } ,  {prefab = "hambat" ,remove = true},   {                               },
                {                                               } ,  {                               },   {                               },
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_frozen_hambat",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_frozen_hambat.tex"),
                image =  "fwd_in_pdt_equipment_frozen_hambat.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 极寒暗影剑
        {
            source = {     
                {prefab = "fwd_in_pdt_item_ice_core" , num = 10} ,  {                               },   {                               },
                {                                               } ,  {prefab = "nightsword" ,remove = true},   {                               },
                {                                               } ,  {                               },   {                               },
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_frozen_nightmaresword",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_frozen_nightmaresword.tex"),
                image =  "fwd_in_pdt_equipment_frozen_nightmaresword.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------




















}