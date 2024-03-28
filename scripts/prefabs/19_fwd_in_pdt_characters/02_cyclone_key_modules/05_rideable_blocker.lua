--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_rideable_blocker",function(inst,replica_com)
        replica_com:SetRefuseSG("fwd_in_pdt_sg_action_refuse")
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_rideable_blocker")
        inst.components.fwd_in_pdt_rideable_blocker:SetOnRefuseFn(function(inst,target)
            -- print("info rider refuse",target)
            local str = GetStringsTable(inst.prefab)["rideable_block"] or ""
            inst.components.talker:Say(str)
        end)
    end
end