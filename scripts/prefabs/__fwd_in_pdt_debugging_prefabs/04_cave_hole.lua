
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("mushroom_light")
    inst.AnimState:SetBuild("mushroom_light")
    inst.AnimState:PlayAnimation("idle")


    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_test_cave_door")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    inst:AddComponent("fwd_in_pdt_data")    

    -----------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")
    inst.components.inspectable:SetDescription("测试洞穴")   ---- 设置角色检查时候的内容
    inst:AddComponent("named")
    inst.components.named:SetName("测试洞穴")           -- 设置物品名字
    --------------------------------------------------------------------------------------------
    -------------- 添加洞穴穿越组件
    inst:AddComponent("worldmigrator")  --- 洞口穿越组件，会自动在 DoTaskInTime 0 的时候初始化 ID。
    inst:DoTaskInTime(0.1,function()
        inst.components.worldmigrator.id = 666555666
        inst.components.worldmigrator.receivedPortal = inst.components.worldmigrator.id
    end)
    --------------------------------------------------------------------------------------------     

    -- inst:DoPeriodicTask(5,function()
    --     print("test DoPeriodicTask",math.random(100))
    -- end)
    --------------------------------------------------------------------------------------------     
    return inst
end

return Prefab("fwd_in_pdt_test_cave_door", fn)