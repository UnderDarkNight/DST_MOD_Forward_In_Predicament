------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 暗影心房修改，可以给 卡尔 吃
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




AddPrefabPostInit(
    "shadowheart",
    function(inst)



        ------------------------------------------------------------------------
        --- 动作
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
                return doer and doer.prefab == "fwd_in_pdt_carl" and inst.replica.inventoryitem:IsGrandOwner(doer)
            end)
            inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
                if not TheWorld.ismastersim then
                    return
                end
                if inst.components.stackable then
                    inst.components.stackable:Get():Remove()
                else
                    inst:Remove()
                end

                doer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_carl_thirst_for_blood__shadowheart")
                doer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_carl_shadowheart_damage")

                if doer.components.health then
                    doer.components.health:DoDelta(100,nil,inst.prefab)
                end
                if doer.components.sanity then
                    doer.components.sanity:DoDelta(50)
                end
                if doer.components.hunger then
                    doer.components.hunger:DoDelta(150)
                end

                return true
            end)
            inst.components.fwd_in_pdt_com_workable:SetSGAction("fwd_in_pdt_special_eat")
            inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_shadowheart",STRINGS.ACTIONS.EAT)
        ------------------------------------------------------------------------


    end
)

