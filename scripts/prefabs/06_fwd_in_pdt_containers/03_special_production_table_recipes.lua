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


}