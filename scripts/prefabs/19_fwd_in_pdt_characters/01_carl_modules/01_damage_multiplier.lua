--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    攻击系数白天为0.8，黄昏1.0，夜间2.0


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local function damage_multiplier_fn()
        local num = 1
        if TheWorld.state.isday then
            num = 0.8
        elseif TheWorld.state.isdusk then
            num = 1
        elseif TheWorld.state.isnight then
            num = 2
        end
        inst.components.combat.damagemultiplier = num
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            TheNet:Announce("攻击力系数改为："..tostring(num))
        end
    end

    inst:DoTaskInTime(0,damage_multiplier_fn)
    inst:WatchWorldState("isday",damage_multiplier_fn)
    inst:WatchWorldState("isdusk",damage_multiplier_fn)
    inst:WatchWorldState("isnight",damage_multiplier_fn)



end