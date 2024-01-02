-----------------------------------------------------------------------------------------------------------------------------------------
---- 默认直接送给玩家的解锁列表
-----------------------------------------------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim or TheWorld:HasTag("cave") then
        return
    end

    if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then  --- 靠版本记忆新增皮肤
        local version_flag = inst.components.fwd_in_pdt_func:Get("default_unlock_by_mod_version")
        local current_version = TUNING["Forward_In_Predicament.mod_info"].version
        if current_version and version_flag == current_version then
            return
        end
        inst.components.fwd_in_pdt_func:Set("default_unlock_by_mod_version",current_version)
    end

    inst:DoTaskInTime(1,function()
            local list = {
                ----------------------------------------------------------------
                ---- 鼹鼠背包
                    ["fwd_in_pdt_equipment_mole_backpack"] = {
                        "fwd_in_pdt_equipment_mole_backpack_panda",
                    },
                ----------------------------------------------------------------
                ---- 邪龙气球
                    ["fwd_in_pdt_equipment_balloon_evil_dragon"] = {
                        "fwd_in_pdt_equipment_balloon_evil_dragon_green",
                    },
                ----------------------------------------------------------------
                ---- 泡泡龙气球
                    ["fwd_in_pdt_equipment_balloon_bobble_loong"] = {
                        "fwd_in_pdt_equipment_balloon_bobble_loong_green",
                    },
                ----------------------------------------------------------------

            }

            inst.components.fwd_in_pdt_func:SkinAPI__Unlock_Skin(list)

    end)
end)







