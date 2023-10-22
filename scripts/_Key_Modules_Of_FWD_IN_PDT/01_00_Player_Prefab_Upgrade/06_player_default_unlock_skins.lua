-----------------------------------------------------------------------------------------------------------------------------------------
---- 默认直接送给玩家的解锁列表
-----------------------------------------------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim or TheWorld:HasTag("cave") then
        return
    end


    inst:DoTaskInTime(1,function()
            local list = {
                ----------------------------------------------------------------
                ---- 鼹鼠背包
                    ["fwd_in_pdt_equipment_mole_backpack"] = {
                        "fwd_in_pdt_equipment_mole_backpack_panda",
                    },
                ----------------------------------------------------------------

            }

            inst.components.fwd_in_pdt_func:SkinAPI__Unlock_Skin(list)

    end)
end)







