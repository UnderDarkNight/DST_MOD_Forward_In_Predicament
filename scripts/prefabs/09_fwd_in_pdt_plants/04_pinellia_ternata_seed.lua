--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 半夏种子
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_pinellia_ternata.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_plant_pinellia_ternata_seed.tex" ), 
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_plant_pinellia_ternata_seed.xml" ),
}
---------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("deployedplant")

    inst.AnimState:SetBank("fwd_in_pdt_plant_pinellia_ternata")
    inst.AnimState:SetBuild("fwd_in_pdt_plant_pinellia_ternata")
    inst.AnimState:PlayAnimation("seed")
    local scale = 0.5
    inst.AnimState:SetScale(scale,scale,scale)

    inst.entity:SetPristine()
    -------------------------------------------------------------------

    -------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "fwd_in_pdt_plant_pinellia_ternata_seed"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_plant_pinellia_ternata_seed.xml"

        -- inst:AddComponent("fuel")
        -- inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
        inst:AddComponent("cookable")
        inst.components.cookable.product = "seeds_cooked"

        MakeMediumBurnable(inst, TUNING.TINY_BURNTIME)


        inst:AddComponent("deployable")                
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            if pt and pt.x then
                SpawnPrefab("fwd_in_pdt_plant_pinellia_ternata"):PushEvent("_OnPlanted",{pt = pt})
            end            
        end
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)   
        -- inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   
            -------------------------------------------------------------------
            -- --- 落水消失
            --     local function on_landed_init(inst)
            --         if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
            --             local x,y,z = inst.Transform:GetWorldPosition()
            --             SpawnPrefab("fwd_in_pdt_fx_splash_sink"):PushEvent("Set",{
            --                 pt = Vector3(x,0,z),
            --                 scale = Vector3(0.3,0.3,0.3),
            --             })
            --             inst:Remove()
            --         end
            --     end
            --     inst:ListenForEvent("on_landed",on_landed_init)
            -------------------------------------------------------------------
    return inst
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- placer post init
local function placer_postinit_fn(inst)
    -- if inst.components.placer then
    --     inst.components.placer.override_testfn = function(inst)
    --         local x,y,z = inst.Transform:GetWorldPosition()
    --         return CanPlantAtPoint(inst, x, y, z)
    --     end
    -- end

end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_plant_pinellia_ternata_seed", fn, assets),
MakePlacer("fwd_in_pdt_plant_pinellia_ternata_seed_placer", "fwd_in_pdt_plant_pinellia_ternata", "fwd_in_pdt_plant_pinellia_ternata", "step1", nil, false, nil, nil, nil, nil, placer_postinit_fn, nil, nil)

