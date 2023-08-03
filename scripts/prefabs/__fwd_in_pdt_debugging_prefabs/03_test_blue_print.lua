local function OnTeach(inst, learner)
    learner:PushEvent("learnrecipe", { teacher = inst, recipe = inst.components.teacher.recipe })
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueprint")
    inst.AnimState:SetBuild("blueprint")
    inst.AnimState:PlayAnimation("idle")

    --Sneak these into pristine state for optimization
    inst:AddTag("_named")

    inst:SetPrefabName("blueprint")

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_named")

    inst:AddComponent("inspectable")
    -- inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("blueprint")

	inst:AddComponent("erasablepaper")

    inst:AddComponent("named")
    inst:AddComponent("teacher")
    inst.components.teacher.onteach = OnTeach

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
    
    --------------------------------------------------------------------------------------------
    inst.is_rare = false      ----- 是否稀有，有不同的外观，还有是否可燃。
    if not inst.is_rare then
        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
    else
        inst.AnimState:SetBank("blueprint_rare")
        inst.AnimState:SetBuild("blueprint_rare")
        inst.components.inventoryitem:ChangeImageName("blueprint_rare")
    end
    --------------------------------------------------------------------------------------------

    MakeHauntableLaunch(inst)


    inst.components.teacher:SetRecipe("los_golden_whip")    --- 蓝图解锁的prefab 名字
    inst.components.named:SetName("测试用的蓝图")

    return inst
end

return Prefab("test_blue_print", fn)