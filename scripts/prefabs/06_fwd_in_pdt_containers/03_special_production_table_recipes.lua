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
    ---- 小麦种子 配方
        {
            source = {     
                {prefab = "seeds" , num = 2, }, {                                    },     {prefab = "seeds" , num = 2, },
                {                            }, {prefab = "goldenpickaxe" , use = 1, },     {                            } ,
                {prefab = "seeds" , num = 2, }, {                                    },     {prefab = "seeds" , num = 2, },
            },
            ret = {
                prefab = "fwd_in_pdt_plant_wheat_seed",
                num = 4,
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_plant_wheat_seed.tex"),
                image =  "fwd_in_pdt_plant_wheat_seed.tex",
                finish_fn = function(inst,doer,times) --- 给奖励后执行的函数。                    
                    --- times -- 奖励次数
                end,
                item_fn = function(rewarded_items_insts,doer) --- 用来触发某些奖励物品的执行事件
                    
                end,
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 面粉
        {
            source = {     
                {                            }, {prefab = "fwd_in_pdt_plant_wheat_seed" , num = 2},     {                            } ,
                {                            }, {prefab = "fwd_in_pdt_plant_wheat_seed" , num = 2},     {                            } ,
                {                            }, {prefab = "hammer",use = 1                        },     {                            } ,
            },
            ret = {
                prefab = "fwd_in_pdt_food_wheat_flour",
                num = 2,
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_food_wheat_flour.tex"),
                image =  "fwd_in_pdt_food_wheat_flour.tex",
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
                item_fn = function(insts,doer)
                    --- 有皮肤的解锁皮肤
                    for k, v in pairs(insts or {}) do
                        if v then
                            doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(v)
                        end
                    end
                end
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
                item_fn = function(insts,doer)
                    --- 有皮肤的解锁皮肤
                    for k, v in pairs(insts or {}) do
                        if v then
                            doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(v)
                        end
                    end
                end
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
                item_fn = function(insts,doer)
                    --- 有皮肤的解锁皮肤
                    for k, v in pairs(insts or {}) do
                        if v then
                            doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(v)
                        end
                    end
                end
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
                item_fn = function(insts,doer)
                    --- 有皮肤的解锁皮肤
                    for k, v in pairs(insts or {}) do
                        if v then
                            doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(v)
                        end
                    end
                end
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
                item_fn = function(insts,doer)
                    --- 有皮肤的解锁皮肤
                    for k, v in pairs(insts or {}) do
                        if v then
                            doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(v)
                        end
                    end
                end
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
                item_fn = function(insts,doer)
                    --- 有皮肤的解锁皮肤
                    for k, v in pairs(insts or {}) do
                        if v then
                            doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(v)
                        end
                    end
                end
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 极寒暗影剑
        {
            source = {     
                {prefab = "fwd_in_pdt_item_ice_core" , num = 10 } ,  {                                     },   {                               },
                {                                               } ,  {prefab = "nightsword" ,remove = true},   {                               },
                {                                               } ,  {                                    },   {                               },
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_frozen_nightmaresword",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_frozen_nightmaresword.tex"),
                image =  "fwd_in_pdt_equipment_frozen_nightmaresword.tex",
                item_fn = function(insts,doer)
                    --- 有皮肤的解锁皮肤
                    for k, v in pairs(insts or {}) do
                        if v then
                            doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(v)
                        end
                    end
                end
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 月亮玻璃
        {
            source = {     
                {prefab = "fwd_in_pdt_material_tree_resin" , num = 1} , {prefab = "fwd_in_pdt_material_tree_resin" , num = 1} ,  {prefab = "fwd_in_pdt_material_tree_resin" , num = 1} ,
                {prefab = "fwd_in_pdt_material_tree_resin" , num = 1} , {prefab = "torch" , use = 10                        } ,  {prefab = "fwd_in_pdt_material_tree_resin" , num = 1} ,
                {prefab = "fwd_in_pdt_material_tree_resin" , num = 1}  ,{prefab = "fwd_in_pdt_material_tree_resin" , num = 1} ,  {prefab = "fwd_in_pdt_material_tree_resin" , num = 1} ,
            },
            ret = {
                prefab = "moonglass",
                num = 1,
                atlas =  GetInventoryItemAtlas("moonglass.tex"),
                image =  "moonglass.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 被诅咒的猪皮
        {
            source = {     
                { prefab = "nightmarefuel" , num = 1 } , {                                } ,  { prefab = "ash" , num = 1           } ,
                {                                    } , { prefab = "pigskin" , num = 1   } ,  {                                    } ,
                { prefab = "ash" , num = 1           } , {                                } ,  { prefab = "nightmarefuel" , num = 1 } ,
            },
            ret = {
                prefab = "fwd_in_pdt_item_cursed_pig_skin",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_item_cursed_pig_skin.tex"),
                image =  "fwd_in_pdt_item_cursed_pig_skin.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 玻璃猪皮
        {
            source = {     
                { prefab = "moonglass" , num = 1        } , {                                } ,  { prefab = "moonrocknugget" , num = 1  } ,
                {                                       } , { prefab = "pigskin" , num = 1   } ,  {                                      } ,
                { prefab = "moonrocknugget" , num = 1   } , {                                } ,  { prefab = "moonglass" , num = 1       } ,
            },
            ret = {
                prefab = "fwd_in_pdt_item_glass_pig_skin",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_item_glass_pig_skin.tex"),
                image =  "fwd_in_pdt_item_glass_pig_skin.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 玻璃牛角
        {
            source = {     
                { prefab = "moonglass" , num = 1   } , { prefab = "moonglass" , num = 1   } ,  { prefab = "moonglass" , num = 1  } ,
                { prefab = "moonglass" , num = 1   } , { prefab = "horn" , num = 1        } ,  { prefab = "moonglass" , num = 1  } ,
                { prefab = "moonglass" , num = 1   } , { prefab = "moonglass" , num = 1   } ,  { prefab = "moonglass" , num = 1  } ,
            },
            ret = {
                prefab = "fwd_in_pdt_item_glass_horn",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_item_glass_horn.tex"),
                image =  "fwd_in_pdt_item_glass_horn.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 《伤寒病论》
        {
            source = {     
                { prefab = "featherpencil" , num = 1 } , {                                                    } ,  { prefab = "featherpencil" , num = 1 } ,
                {                                    } , { prefab = "fwd_in_pdt_item_locked_book" , num = 1   } ,  {                                    } ,
                {                                    } , {                                                    } ,  {                                    } ,
            },
            ret = {
                prefab = "fwd_in_pdt_item_disease_treatment_book",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_item_disease_treatment_book.tex"),
                image =  "fwd_in_pdt_item_disease_treatment_book.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 《丰收之书》
        {
            source = {     
                { prefab = "twigs" , num = 1                            } , { prefab = "featherpencil" , num = 1                 } ,  { prefab = "cutgrass" , num = 1                    } ,
                { prefab = "fwd_in_pdt_plant_paddy_rice_seed" , num = 1 } , { prefab = "fwd_in_pdt_item_locked_book" , num = 1   } ,  { prefab = "fwd_in_pdt_plant_wheat_seed" , num = 1 } ,
                { prefab = "cutgrass" , num = 1                         } , {                                                    } ,  { prefab = "twigs" , num = 1                       } ,
            },
            ret = {
                prefab = "fwd_in_pdt_item_book_of_harvest",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_item_book_of_harvest.tex"),
                image =  "fwd_in_pdt_item_book_of_harvest.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 《园艺之书》
        {
            source = {     
                { prefab = "featherpencil" , num = 1 } , { prefab = "petals_evil" , num = 1                   } ,  { prefab = "petals" , num = 1        } ,
                { prefab = "twigs" , num = 1         } , { prefab = "fwd_in_pdt_item_locked_book" , num = 1   } ,  { prefab = "twigs" , num = 1         } ,
                { prefab = "petals" , num = 1        } , {                                                    } ,  { prefab = "featherpencil" , num = 1 } ,
            },
            ret = {
                prefab = "fwd_in_pdt_item_book_of_gardening",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_item_book_of_gardening.tex"),
                image =  "fwd_in_pdt_item_book_of_gardening.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 《新月之书》
        {
            source = {     
                { prefab = "moonrocknugget" , num = 1 } , {                                                    } ,  { prefab = "nightmarefuel" , num = 1  } ,
                {                                     } , { prefab = "fwd_in_pdt_item_locked_book" , num = 1   } ,  {                                     } ,
                { prefab = "nightmarefuel" , num = 1  } , {                                                    } ,  { prefab = "moonrocknugget" , num = 1 } ,
            },
            ret = {
                prefab = "fwd_in_pdt_item_book_of_newmoon",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_item_book_of_newmoon.tex"),
                image =  "fwd_in_pdt_item_book_of_newmoon.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 鼹鼠背包
        {
            source = {     
                { prefab = "mole" , num = 1 } , { prefab = "molehat" , num = 1  } ,  { prefab = "mole" , num = 1  } ,
                {                           } , { prefab = "mole" , num = 1     } ,  {                            } ,
                { prefab = "mole" , num = 1 } , {                               } ,  { prefab = "mole" , num = 1  } ,
            },
            ret = {
                prefab = "fwd_in_pdt_equipment_mole_backpack",
                num = 1,
                overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_equipment_mole_backpack.tex"),
                image =  "fwd_in_pdt_equipment_mole_backpack.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    ---- 混沌眼球
        {
            source = {     
                { prefab = "deerclops_eyeball" , num = 1 } , {                                            } ,  { prefab = "deerclops_eyeball" , num = 1  } ,
                {                                        } , { prefab = "deerclops_eyeball" , num = 1     } ,  {                            } ,
                { prefab = "nightmarefuel" , num = 1     } , {                                            } ,  { prefab = "nightmarefuel" , num = 1  } ,
            },
            ret = {
                prefab = "fwd_in_pdt_material_chaotic_eyeball",
                num = 1,
                -- overwrite_str = "x 1",
                atlas =  GetInventoryItemAtlas("fwd_in_pdt_material_chaotic_eyeball.tex"),
                image =  "fwd_in_pdt_material_chaotic_eyeball.tex",
            }
        },
    -------------------------------------------------------------------------------------------------------------




















}