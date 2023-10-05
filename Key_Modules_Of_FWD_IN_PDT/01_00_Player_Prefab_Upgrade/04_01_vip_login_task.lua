--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 测试用的 VIP 玩家每天 进出存档通报一次。
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.fwd_in_pdt_func:VIP_Add_Fn(function()


        local time = inst.components.fwd_in_pdt_func:Get_OS_Time_Num()
        local day_flag = inst.components.fwd_in_pdt_func:Get("vip_daily_announce")
        if day_flag ~= time then
            inst.components.fwd_in_pdt_func:Set("vip_daily_announce",time)
            inst:DoTaskInTime(2,function()
                inst.components.fwd_in_pdt_func:Wisper({
            --     m_colour = {0,0,255} ,                          ---- 内容颜色
            --     s_colour = {255,255,0},                         ---- 发送者颜色
            --     icondata = "profileflair_food_crabroll",        ---- 图标
                message = "天空一声巨响，VIP玩家闪亮登场",                            ---- 文字内容
                -- sender_name = "HHHH555",                        ---- 发送者名字
                })
            end)
        end
        

    end)

    -------------------------- vip 解锁皮肤
        inst.components.fwd_in_pdt_func:VIP_Add_Fn(function()
            inst:DoTaskInTime(1,function()
                local list = {
                    ---- 炽热暗影剑
                        ["fwd_in_pdt_equipment_blazing_nightmaresword"] = {
                            "fwd_in_pdt_equipment_blazing_nightmaresword_sharp",
                        },
                    ---- 极寒暗影剑
                        ["fwd_in_pdt_equipment_frozen_nightmaresword"] = {
                            "fwd_in_pdt_equipment_frozen_nightmaresword_sharp",
                        },
                    ---- 炽热长矛
                        ["fwd_in_pdt_equipment_blazing_spear"] = {
                            "fwd_in_pdt_equipment_blazing_spear_sharp",
                        },
                    ---- 极寒长矛
                        ["fwd_in_pdt_equipment_frozen_spear"] = {
                            "fwd_in_pdt_equipment_frozen_spear_sharp",
                        },

                }
                inst.components.fwd_in_pdt_func:SkinAPI__Unlock_Skin(list)

            end)
        end)

end)