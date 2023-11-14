------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- 批量任务参数组
-------  方案 1  只能 需求 单个物品。
-------  方案 2  则完全自由
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return {
    ["fwd_in_pdt_task_scroll__fertilizer"] = {
        index = "fwd_in_pdt_task_scroll__fertilizer",                   --- 任务index
        atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
        image = "fwd_in_pdt_task_scroll__fertilizer.tex",               --- 卷轴显示的图片
        x = -50,                                                        --- 图片偏移x
        y = 0,                                                          --- 图片偏移y

        item_num = 5,                                                   --- 物品需求数量
        item_prefab = "fertilizer",                                     --- 物品需求的prefab
        gift_box_items = {                                              --- 奖励包裹里的内容
            {"fwd_in_pdt_item_jade_coin_green",5},
            {"fwd_in_pdt_plant_paddy_rice_seed",10},
        }
    },
    ["fwd_in_pdt_task_scroll__yellowstaff"] = {
        index = "fwd_in_pdt_task_scroll__yellowstaff",                   --- 任务index
        atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
        image = "fwd_in_pdt_task_scroll__yellowstaff.tex",               --- 卷轴显示的图片
        x = -50,                                                        --- 图片偏移x
        y = 0,                                                          --- 图片偏移y

        item_num = 1,                                                   --- 物品需求数量
        item_prefab = "yellowstaff",                                     --- 物品需求的prefab
        gift_box_items = {                                              --- 奖励包裹里的内容
            {"fwd_in_pdt_item_jade_coin_green",20},
        }
    },








    ["fwd_in_pdt_task_scroll__ice"] = {
        index = "fwd_in_pdt_task_scroll__ice",                          --- 任务index
        atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",         --- 卷轴显示的图片
        image = "fwd_in_pdt_task_scroll__ice.tex",                      --- 卷轴显示的图片
        x = -50,                                                        --- 图片偏移x
        y = 0,                                                          --- 图片偏移y

        item_num = 40,                                                   --- 物品需求数量
        item_prefab = "ice",                                            --- 物品需求的prefab
        gift_box_items = {                                              --- 奖励包裹里的内容
            {"fwd_in_pdt_item_jade_coin_green",5},
        }
    },






    --------------------------------------------------------------------------------------
    --[[
        ---- 第二套方案。更加自由

        ["fwd_in_pdt_task_scroll__ice"] = {
            index = "fwd_in_pdt_task_scroll__ice",                          --- 任务index
            atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",
            image = "fwd_in_pdt_task_scroll__ice.tex",
            x = -50,
            y = 0,

            submit_fn = function(inst,doer)     --- 提交按钮点击之后会执行的函数
                
            end
        },


    ]]--
    --------------------------------------------------------------------------------------
}