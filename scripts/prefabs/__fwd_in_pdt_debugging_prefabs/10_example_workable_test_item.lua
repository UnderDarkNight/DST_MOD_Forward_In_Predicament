

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueprint")
    inst.AnimState:SetBuild("blueprint")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    ---------------------------------------------------------------------------------------------------------------------------
    ----   物品使用组件
    inst:AddComponent("fwd_in_pdt_com_workable")
    inst.components.fwd_in_pdt_com_workable:SetPreActionFn(function(inst,doer)
        print("preaction",doer)
    end)
    inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
        -- print("test +++++++++",doer)
        if inst.replica.inventoryitem:IsGrandOwner(doer) then
            return true
        else
            return right_click
        end
    end)

    inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
        print("on work")
        return true
    end)
    ---------------------------------------------------------------------------------------------------------------------------
    inst:AddComponent("fwd_in_pdt_com_acceptable")
    inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer)
        if item and item.prefab == "poop" then
            return true
        end
        return false
    end)
    inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
        item:Remove()
        return true
    end)
    inst.components.fwd_in_pdt_com_acceptable:SetSGAction("dolongaction")
    inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStr("test_acc","添加")
    -- inst.components.fwd_in_pdt_com_acceptable:SetPreActionFn()

    ---------------------------------------------------------------------------------------------------------------------------




    if not TheWorld.ismastersim then
        return inst
    end



    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("blueprint")



    return inst
end

return Prefab("fwd_in_pdt_excample_workable_test_item", fn)