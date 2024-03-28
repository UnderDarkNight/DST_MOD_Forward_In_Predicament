--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)


    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_map_jumper",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,pt)
            return inst.replica.hunger:GetCurrent() > 100
            -- return true
        end)
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_com_map_jumper")


        inst.components.fwd_in_pdt_com_map_jumper:SetPreSpellFn(function(inst,pt)
            inst.components.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_event.ToggleMap") ---- 下发关闭地图的命令
            
            inst.components.hunger:DoDelta(-100)

        end)

        inst.components.fwd_in_pdt_com_map_jumper:SetSpellFn(function(inst,pt)


            inst.components.fwd_in_pdt_func:Transform2PT(pt)
            inst:PushEvent("change_2_flay")


        end)

    end



end