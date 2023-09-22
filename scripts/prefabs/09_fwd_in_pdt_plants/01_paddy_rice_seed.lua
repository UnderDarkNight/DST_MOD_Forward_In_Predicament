--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 水稻种子
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_paddy_rice.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_plant_paddy_rice_seed.tex" ), 
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_plant_paddy_rice_seed.xml" ),
}
---------------------------------------------------------------------------------------------------------------------------

    local function CanPlantAtPoint(inst,x,y,z)
        if TheWorld.state.iswinter or TheWorld:HasTag("cave") then
            return false
        end

        if  TheSim:CountEntities(x, y, z, 5.5, {"fwd_in_pdt_building_paddy_windmill"}) == 1 
            and 0 == TheSim:CountEntities(x, y, z, 1.5, {"fwd_in_pdt_building_paddy_windmill"}) 
            and TheWorld.Map:IsDeployPointClear2(Vector3(x,y,z),inst,0) then
            -- and TheWorld.Map:CanDeployPlantAtPoint(Vector3(x,y,z),inst) then
                return true
        end

        return false
    end
---------------------------------------------------------------------------------------------------------------------------
    local function Add_Plant_Com(inst)
        ----- hook 关键组件
        local function hook_inventoryitem(inst)
            if inst.replica.inventoryitem then
                function inst.replica.inventoryitem:CanDeploy(pt, mouseover, deployer, rot)
                    return CanPlantAtPoint(self.inst,pt.x,pt.y,pt.z)                    
                end
            end
        end
        inst:DoTaskInTime(0,hook_inventoryitem)

        if TheWorld.ismastersim then
        --- 种植
                inst:AddComponent("deployable")                
                inst.components.deployable.ondeploy = function(inst, pt, deployer)
                    if pt and pt.x then
                        SpawnPrefab("fwd_in_pdt_plant_paddy_rice").Transform:SetPosition(pt.x, pt.y, pt.z)
                    end            
                end
                inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
                -- inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)   
                inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   
        end
    end
---------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("deployedplant")

    inst.AnimState:SetBank("fwd_in_pdt_plant_paddy_rice")
    inst.AnimState:SetBuild("fwd_in_pdt_plant_paddy_rice")
    inst.AnimState:PlayAnimation("seed")
    local scale = 0.6
    inst.AnimState:SetScale(scale,scale,scale)

    inst.entity:SetPristine()
    -------------------------------------------------------------------
    --- 添加种植相关的组件
        Add_Plant_Com(inst)
    -------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "fwd_in_pdt_plant_paddy_rice_seed"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_plant_paddy_rice_seed.xml"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

        MakeMediumBurnable(inst, TUNING.TINY_BURNTIME)


    -------------------------------------------------------------------
    --- 落水消失
        local function on_landed_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                local x,y,z = inst.Transform:GetWorldPosition()
                SpawnPrefab("fwd_in_pdt_fx_splash_sink"):PushEvent("Set",{
                    pt = Vector3(x,0,z),
                    scale = Vector3(0.3,0.3,0.3),
                })
                inst:Remove()
            end
        end
        inst:ListenForEvent("on_landed",on_landed_init)
    -------------------------------------------------------------------
    return inst
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- placer post init
local function placer_postinit_fn(inst)
    if inst.components.placer then
        inst.components.placer.override_testfn = function(inst)
            local x,y,z = inst.Transform:GetWorldPosition()
            return CanPlantAtPoint(inst, x, y, z)
        end
    end

end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_plant_paddy_rice_seed", fn, assets),
MakePlacer("fwd_in_pdt_plant_paddy_rice_seed_placer", "fwd_in_pdt_plant_paddy_rice", "fwd_in_pdt_plant_paddy_rice", "step1", nil, true, nil, nil, nil, nil, placer_postinit_fn, nil, nil)

