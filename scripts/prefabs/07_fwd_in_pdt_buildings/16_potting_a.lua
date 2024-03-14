----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    盆栽

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_potting_a.zip"),
}

local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()


    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_potting_a.tex")

    inst.AnimState:SetBank("fwd_in_pdt_building_potting_a")
    inst.AnimState:SetBuild("fwd_in_pdt_building_potting_a")
    inst.AnimState:PlayAnimation("idle",true)

    local scale = 1.5
    inst.AnimState:SetScale(scale, scale, scale)

    inst:AddTag("structure")
    -- inst:AddTag("chest")
    inst:AddTag("fwd_in_pdt_building_potting_a")



    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") --可检查组件


    -----------------------------------------------------------------------------------
    --意外发现了 可以建造升级   类似于老奶奶的房子  没空琢磨先放这里了
    -- inst:AddComponent("constructionsite")
    -- inst.components.constructionsite:SetConstructionPrefab("construction_repair_container")
    -- inst.components.constructionsite:SetOnConstructedFn(function(inst)

    -- end)
    -----------------------------------------------------------------------------------
    --敲打拆除的状态
    inst:ListenForEvent("_building_remove",function()
        SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
            pt = Vector3(inst.Transform:GetWorldPosition())
        })
        inst:Remove()
    end)
    --敲打拆除
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(function()
        inst.components.lootdropper:DropLoot()----这个才能让官方的敲除实现掉落一半
        inst:PushEvent("_building_remove")
    end)
    -----------------------------------------------------------------------------------
    ---- 积雪检查
        local function snow_init(inst)
            if TheWorld.state.issnowcovered then
                inst.AnimState:Show("SNOW")
            else
                inst.AnimState:Hide("SNOW")
            end    
        end
        inst:WatchWorldState("issnowcovered", snow_init)
        snow_init(inst)
    -----------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------
    return inst
end

local function placer_postinit_fn(inst)
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num,scale_num,scale_num)
    inst.AnimState:Hide("SNOW")
end
-----------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_building_potting_a", fn,assets),
    MakePlacer("fwd_in_pdt_building_potting_a_placer","fwd_in_pdt_building_potting_a", "fwd_in_pdt_building_potting_a", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn ,nil, nil)