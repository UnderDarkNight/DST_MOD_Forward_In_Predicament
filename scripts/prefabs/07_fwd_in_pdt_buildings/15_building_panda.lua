----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    熊猫摆件

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_panda.zip"),

}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()


    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_panda.tex")

    inst.AnimState:SetBank("fwd_in_pdt_building_panda")
    inst.AnimState:SetBuild("fwd_in_pdt_building_panda")

    inst.AnimState:PlayAnimation("idle")  -- 后面如果参数是true 就是循环播放 默认应该是false

    inst:AddTag("structure")
    
    inst:AddTag("fwd_in_pdt_building_panda")
    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------------------------
    inst:AddComponent("inspectable") --可检查组件


    -------------------------------------------------------------------------------------
    -- 敲打拆除
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")

    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(function()
        inst.components.lootdropper:DropLoot()----这个才能让官方的敲除实现掉落一半
        inst:PushEvent("_building_remove")
    end)
    -- 敲打拆除触发的特效
    inst:ListenForEvent("_building_remove",function()
        SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
            pt = Vector3(inst.Transform:GetWorldPosition())
        })
        inst:Remove()
    end)
    -----------------------------------------------------------------------------------
    return inst
end
local function placer_postinit_fn(inst)
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num,scale_num,scale_num)
    inst.AnimState:Hide("SNOW")
end
-----------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_building_panda", fn,assets),
    MakePlacer("fwd_in_pdt_building_panda_placer","fwd_in_pdt_building_panda", "fwd_in_pdt_building_panda", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn ,nil, nil)