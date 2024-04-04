--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    地图传送：  洞外消耗100点。洞里消耗 10点

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    local HUNGER_COST_NUM = 100
    if TheWorld:HasTag("cave") then
        HUNGER_COST_NUM = 10
    end

    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_map_jumper",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,pt)
            return inst.replica.hunger:GetCurrent() > HUNGER_COST_NUM
            -- return true
        end)
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_com_map_jumper")


        inst.components.fwd_in_pdt_com_map_jumper:SetPreSpellFn(function(inst,pt)
            inst.components.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_event.ToggleMap") ---- 下发关闭地图的命令
            
            inst.components.hunger:DoDelta(-HUNGER_COST_NUM)
            inst:PushEvent("cyclone_change_2_fly")
            
        end)

        inst.components.fwd_in_pdt_com_map_jumper:SetSpellFn(function(inst,pt)


            inst.components.fwd_in_pdt_func:Transform2PT(pt)
            inst:PushEvent("cyclone_change_2_fly")


        end)

    end



end