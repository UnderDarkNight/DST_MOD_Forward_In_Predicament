------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- 批量任务参数组
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return {
    ["fwd_in_pdt_task_scroll__fertilizer"] = {
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
        atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",
        image = "fwd_in_pdt_task_scroll__yellowstaff.tex",
        x = -50,
        y = 0,

        item_num = 1,
        item_prefab = "yellowstaff",
        gift_box_items = {
            {"fwd_in_pdt_item_jade_coin_green",20},
        }
    },





    ["fwd_in_pdt_task_scroll__ice"] = {
        atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",
        image = "fwd_in_pdt_task_scroll__ice.tex",
        x = -50,
        y = 0,

        item_num = 40,
        item_prefab = "ice",
        gift_box_items = {
            {"fwd_in_pdt_item_jade_coin_green",5},
        }
    },
}