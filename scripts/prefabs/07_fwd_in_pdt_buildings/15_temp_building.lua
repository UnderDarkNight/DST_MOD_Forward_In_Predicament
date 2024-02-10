----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    测试 用的 建筑

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_container_tv_box.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_container_tv_box_laser.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CONSTRUCTION_PLANS["fwd_in_pdt_building_test_building"] = { Ingredient("moonrocknugget", 10), Ingredient("rope", 5), Ingredient("turf_carpetfloor", 5) }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()


    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_container_tv_box.tex")

    inst.AnimState:SetBank("fwd_in_pdt_container_tv_box")
    inst.AnimState:SetBuild("fwd_in_pdt_container_tv_box")
    inst.AnimState:PlayAnimation("idle",true)

    -- local scale = 1.5
    -- inst.AnimState:SetScale(scale, scale, scale)

    inst:AddTag("structure")
    inst:AddTag("chest")
    inst:AddTag("fwd_in_pdt_container_tv_box")



    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") --可检查组件


    -----------------------------------------------------------------------------------
    inst:AddComponent("constructionsite")
    inst.components.constructionsite:SetConstructionPrefab("construction_repair_container")
    inst.components.constructionsite:SetOnConstructedFn(function(inst)
        
    end)
    -----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_building_test_building", fn,assets)