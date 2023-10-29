------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 升级烹饪锅，可以使用【混沌眼球】升级成【混沌万能烹饪锅】
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "cookpot",
    function(inst)

        inst:AddComponent("fwd_in_pdt_com_acceptable")
        inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer,right_click)
            if item and item.prefab == "fwd_in_pdt_material_chaotic_eyeball" then
                return true
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_acceptable:SetSGAction("fwd_in_pdt_special_pick")
        inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStr("fwd_in_pdt_material_chaotic_eyeball",STRINGS.ACTIONS.APPLYMODULE)
        inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
            if not TheWorld.ismastersim then
                return
            end
            local succeed_flag = false
            if math.random(1000) <= 600 then
                succeed_flag = true
            end
            local x,y,z = inst.Transform:GetWorldPosition()
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{target = inst})
            item:Remove()
            inst:Remove()
            if succeed_flag then
                SpawnPrefab("fwd_in_pdt_building_special_cookpot").Transform:SetPosition(x, y, z)
            end
            return succeed_flag
        end)


        if not TheWorld.ismastersim then
            return
        end


    end
)