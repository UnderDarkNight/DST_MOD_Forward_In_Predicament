------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- 批量任务参数组
-------  方案 1  只能 需求 单个物品。
-------  方案 2  则完全自由
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return 
{
    --便便桶任务
        ["fwd_in_pdt_task_scroll__fertilizer"] = {
            index = "fwd_in_pdt_task_scroll__fertilizer",                   --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__fertilizer.tex",               --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 5,                                                   --- 物品需求数量
            item_prefab = "fertilizer",                                     --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(1,10)},
                {"fwd_in_pdt_plant_paddy_rice_seed",10},
            }
        },

    --唤星者魔杖任务
        ["fwd_in_pdt_task_scroll__yellowstaff"] = {
            index = "fwd_in_pdt_task_scroll__yellowstaff",                   --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__yellowstaff.tex",               --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 1,                                                   --- 物品需求数量
            item_prefab = "yellowstaff",                                     --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(10,40)},
            }
        },

    --鼹鼠*5任务
        ["fwd_in_pdt_task_scroll__mole"] = {
            index = "fwd_in_pdt_task_scroll__mole",                         --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__mole.tex",                     --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 5,                                                   --- 物品需求数量
            item_prefab = "mole",                                           --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(5,15)},
            }
        },

    --火龙果*10任务
        ["fwd_in_pdt_task_scroll__dragonfruit"] = {
            index = "fwd_in_pdt_task_scroll__dragonfruit",                         --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__dragonfruit.tex",                     --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 10,                                                   --- 物品需求数量
            item_prefab = "dragonfruit",                                    --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(1,10)},
            }
        },

    --肉汤*5任务
        ["fwd_in_pdt_task_scroll__bonestew"] = {
            index = "fwd_in_pdt_task_scroll__bonestew",                         --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__bonestew.tex",                     --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 5,                                                   --- 物品需求数量
            item_prefab = "bonestew",                                       --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(20,30)},
            }
        },

    --花*40任务---花栅栏蓝图
        ["fwd_in_pdt_task_scroll__petals"] = {
        index = "fwd_in_pdt_task_scroll__petals",                         --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__petals.tex",                     --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 40,                                                   --- 物品需求数量
            item_prefab = "petals",                                       --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_building_flower_fence_item_blueprint",1},
            }
        },

    --太妃糖*10任务
        ["fwd_in_pdt_task_scroll__taffy"] = {
            index = "fwd_in_pdt_task_scroll__taffy",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__taffy.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 10,                                                   --- 物品需求数量
            item_prefab = "taffy",                                            --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(20,30)},
            }
        },

    --眼球伞任务
        ["fwd_in_pdt_task_scroll__eyebrellahat"] = {
            index = "fwd_in_pdt_task_scroll__eyebrellahat",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__eyebrellahat.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 1,                                                   --- 物品需求数量
            item_prefab = "eyebrellahat",                                            --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(30,40)},
            }
        },

    --牛角帽任务
        ["fwd_in_pdt_task_scroll__beefalohat"] = {
            index = "fwd_in_pdt_task_scroll__beefalohat",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__beefalohat.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 1,                                                   --- 物品需求数量
            item_prefab = "beefalohat",                                            --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_glass_horn",1},
            }
        },

    --冰*40任务
        ["fwd_in_pdt_task_scroll__ice"] = {
            index = "fwd_in_pdt_task_scroll__ice",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__ice.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 40,                                                   --- 物品需求数量
            item_prefab = "ice",                                            --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(10,20)},
            }
        },

    --芒果*20任务
        ["fwd_in_pdt_task_scroll__mango"] = {
            index = "fwd_in_pdt_task_scroll__mango",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__mango.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 20,                                                   --- 物品需求数量
            item_prefab = "fwd_in_pdt_food_mango",                                            --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_food_mango_ice_drink",1},
            }
        },

    --芒果树穗*10任务
        ["fwd_in_pdt_task_scroll__mango_tree_item"] = {
            index = "fwd_in_pdt_task_scroll__mango_tree_item",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__mango_tree_item.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 10,                                                   --- 物品需求数量
            item_prefab = "fwd_in_pdt_plant_mango_tree_item",                                            --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(40,50)},
            }
        },

    --鸟腿*10任务
        ["fwd_in_pdt_task_scroll__rumstick"] = {
            index = "fwd_in_pdt_task_scroll__rumstick",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__rumstick.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 10,                                                   --- 物品需求数量
            item_prefab = "drumstick",                                            --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(50,60)},
            }
        },

    --树脂*6任务
        ["fwd_in_pdt_task_scroll__tree_resin"] = {
            index = "fwd_in_pdt_task_scroll__tree_resin",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__tree_resin.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 6,                                                   --- 物品需求数量
            item_prefab = "fwd_in_pdt_material_tree_resin",                 --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(50,60)},
            }
        },

    --蜘蛛卵*10任务
        ["fwd_in_pdt_task_scroll__pidereggsack"] = {
            index = "fwd_in_pdt_task_scroll__pidereggsack",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__pidereggsack.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 10,                                                   --- 物品需求数量
            item_prefab = "spidereggsack",                                   --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(20,30)},
            }
        },

    --蝴蝶翅膀*10任务
        ["fwd_in_pdt_task_scroll__butterflywings"] = {
            index = "fwd_in_pdt_task_scroll__butterflywings",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__butterflywings.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 10,                                                   --- 物品需求数量
            item_prefab = "butterflywings",                                   --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"butter",5},
            }
        },

    --蜜脾*10任务
        ["fwd_in_pdt_task_scroll__honeycomb"] = {
            index = "fwd_in_pdt_task_scroll__honeycomb",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__honeycomb.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 10,                                                   --- 物品需求数量
            item_prefab = "honeycomb",                                   --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",5},
            }
        },

    --浓鼻涕*5任务
        ["fwd_in_pdt_task_scroll__phlegm"] = {
            index = "fwd_in_pdt_task_scroll__phlegm",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__phlegm.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 5,                                                   --- 物品需求数量
            item_prefab = "phlegm",                                   --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(50,60)},
            }
        },

    --怪物肉*40任务
        ["fwd_in_pdt_task_scroll__monstermeat"] = {
            index = "fwd_in_pdt_task_scroll__monstermeat",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__monstermeat.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 40,                                                   --- 物品需求数量
            item_prefab = "monstermeat",                                   --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",10},
            }
        },

    --玉龙币*5任务
        ["fwd_in_pdt_task_scroll__green_coin"] = {
            index = "fwd_in_pdt_task_scroll__green_coin",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__green_coin.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 5,                                                   --- 物品需求数量
            item_prefab = "fwd_in_pdt_item_jade_coin_green",                                   --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(10,20)},
            }
        },

    --玉龙币·墨任务
        ["fwd_in_pdt_task_scroll__black_coin"] = {
            index = "fwd_in_pdt_task_scroll__black_coin",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
            image = "fwd_in_pdt_task_scroll__black_coin.tex",                      --- 卷轴显示的图片
            x = -50,                                                        --- 图片偏移x
            y = 0,                                                          --- 图片偏移y

            item_num = 1,                                                   --- 物品需求数量
            item_prefab = "fwd_in_pdt_item_jade_coin_black",                                   --- 物品需求的prefab
            gift_box_items = {                                              --- 奖励包裹里的内容
                {"fwd_in_pdt_item_jade_coin_green",math.random(80,120)},
            }
        },

    ---------------------------------
            --[[
                    --- 方案 2：
                                        ["fwd_in_pdt_task_scroll__black_coin"] = {
                                            index = "fwd_in_pdt_task_scroll__black_coin",                          --- 任务index
                                            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
                                            image = "fwd_in_pdt_task_scroll__black_coin.tex",                      --- 卷轴显示的图片
                                            x = -50,                                                        --- 图片偏移x
                                            y = 0,                                                          --- 图片偏移y

                                            submit_fn = function(inst,doer)
                                                
                                            end
                                        },
            
            ]]--

    
}





 --以下是任务调试所有代码
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__fertilizer")--便便桶任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__yellowstaff")--唤星者魔杖任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__mole")--鼹鼠*5任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__dragonfruit")--火龙果*10任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__bonestew")--肉汤*5任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__petals")--花*40任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__taffy")--太妃糖*10任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__eyebrellahat")--眼球伞任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__beefalohat")--牛角帽任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__ice")--冰*40任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__mango")--芒果*20任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__mango_tree_item")--芒果树穗*10任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__rumstick")--鸟腿*10任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__tree_resin")--树脂*6任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__pidereggsack")--蜘蛛卵*10任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__butterflywings")--蝴蝶翅膀*10任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__honeycomb")--蜂巢*10任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__phlegm")--浓鼻涕*5任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__monstermeat")--怪物肉*40任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__green_coin")--玉龙币*5任务
                        --item:PushEvent("Set","fwd_in_pdt_task_scroll__black_coin")--玉龙币·墨任务
