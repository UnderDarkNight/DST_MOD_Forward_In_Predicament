require "prefabutil"

local cooking = require("cooking")

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_special_cookpot.zip"),
    Asset("ANIM", "anim/cook_pot_food.zip"),
    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
}

local prefabs =
{
    "collapse_small",
}


local assets_archive =
{
    Asset("ANIM", "anim/cook_pot.zip"),
    Asset("ANIM", "anim/cookpot_archive.zip"),
    Asset("ANIM", "anim/cook_pot_food.zip"),
    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
    Asset("MINIMAP_IMAGE", "cookpot_archive"),
}

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)

	if v.overridebuild then
        table.insert(assets, Asset("ANIM", "anim/"..v.overridebuild..".zip"))
        table.insert(assets_archive, Asset("ANIM", "anim/"..v.overridebuild..".zip"))
	end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") and inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
        inst.components.stewer:Harvest()
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("hit_cooking")
            inst.AnimState:PushAnimation("cooking_loop", true)
            inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
        elseif inst.components.stewer:IsDone() then
            inst.AnimState:PlayAnimation("hit_full")
            inst.AnimState:PushAnimation("idle_full", true)
        else
            if inst.components.container ~= nil and inst.components.container:IsOpen() then
                inst.components.container:Close()
                --onclose will trigger sfx already
            else
                inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
            end
            inst.AnimState:PlayAnimation("hit_empty")
            inst.AnimState:PushAnimation("idle_empty", true)
        end
    end
end

--anim and sound callbacks

local function startcookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)
    end
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pre_loop",true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        if not inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("idle_empty",true)
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function SetProductSymbol(inst, product, overridebuild)
    inst.AnimState:ClearOverrideSymbol("swap_cooked")

    local recipe = cooking.GetRecipe(inst.prefab, product)
    local potlevel = recipe ~= nil and recipe.potlevel or nil
    local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or "cook_pot_food"
    local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

    -- if potlevel == "high" then
    --     inst.AnimState:Show("swap_high")
    --     inst.AnimState:Hide("swap_mid")
    --     inst.AnimState:Hide("swap_low")
    -- elseif potlevel == "low" then
    --     inst.AnimState:Hide("swap_high")
    --     inst.AnimState:Hide("swap_mid")
    --     inst.AnimState:Show("swap_low")
    -- else
    --     inst.AnimState:Hide("swap_high")
    --     inst.AnimState:Show("swap_mid")
    --     inst.AnimState:Hide("swap_low")
    -- end
    -- print("info SetProductSymbol",build,overridesymbol)
    -- inst.AnimState:OverrideSymbol("swap_cooked", build, overridesymbol) ---- 用官方的这一条出状况了
    
    if cooking.IsModCookerFood(product) then
        inst.AnimState:OverrideSymbol("swap_cooked", build, overridesymbol)
    else
        inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", overridesymbol)
    end

end

local function spoilfn(inst)
    if not inst:HasTag("burnt") then
        inst.components.stewer.product = inst.components.stewer.spoiledproduct
        SetProductSymbol(inst, inst.components.stewer.product)
    end
end

local function ShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        SetProductSymbol(inst, product, IsModCookingProduct(inst.prefab, product) and product or nil)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pst")
        inst.AnimState:PushAnimation("idle_full", true)
        ShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
    end
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_full",true)
        ShowProduct(inst)
    end
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_loop")
        inst.AnimState:ClearOverrideSymbol("swap_cooked")
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    end
end

local function harvestfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty",true)
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function getstatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or (inst.components.stewer:IsDone() and "DONE")
        or (not inst.components.stewer:IsCooking() and "EMPTY")
        or (inst.components.stewer:GetTimeToCook() > 15 and "COOKING_LONG")
        or "COOKING_SHORT"
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle_empty", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
    end
end

local function onloadpostpass(inst, newents, data)
    if data and data.additems and inst.components.container then
        for i, itemname in ipairs(data.additems)do
            local ent = SpawnPrefab(itemname)
            inst.components.container:GiveItem( ent )
        end
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_special_cookpot.tex")

    MakeObstaclePhysics(inst, .5)

    inst.Light:Enable(false)
    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)

    inst:AddTag("structure")

    --stewer (from stewer component) added to pristine state for optimization
    inst:AddTag("stewer")

    inst.AnimState:SetBank("fwd_in_pdt_building_special_cookpot")
    inst.AnimState:SetBuild("fwd_in_pdt_building_special_cookpot")
    inst.AnimState:PlayAnimation("idle_empty",true)
    inst.scrapbook_anim = "idle_empty"
    local scale = 1.5
    inst.AnimState:SetScale(scale, scale, scale)
    MakeSnowCoveredPristine(inst)

    inst.scrapbook_specialinfo = "CROCKPOT"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("cookpot")
        end
        return inst
    end

    inst:AddComponent("stewer")
    inst.components.stewer.onstartcooking = startcookfn
    inst.components.stewer.oncontinuecooking = continuecookfn
    inst.components.stewer.oncontinuedone = continuedonefn
    inst.components.stewer.ondonecooking = donecookfn
    inst.components.stewer.onharvest = harvestfn
    inst.components.stewer.onspoil = spoilfn

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("cookpot")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    --inst.components.hauntable:SetOnHauntFn(OnHaunt)


    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.OnLoadPostPass = onloadpostpass

    --------------------------------------------------------
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
    --------------------------------------------------------
    ---- 拆除的时候掉落物品
        inst.components.lootdropper.GetRecipeLoot = function()
            if inst:HasTag("burnt") then
                return {"charcoal","charcoal","rocks"}
            else
                return{"charcoal","charcoal","charcoal","cutstone","cutstone"}
            end
        end
    --------------------------------------------------------

    return inst
end

----------------------------------------------------------------------
local function placer_postinit_fn(inst)
    -- inst.AnimState:Hide("BLUE")
    -- inst.AnimState:Hide("YELLOW")
    -- inst.AnimState:Hide("RED")
    local scale = 1.5
    inst.AnimState:SetScale(scale,scale,scale)
    inst.AnimState:PlayAnimation("cooking_loop",true)
end


return Prefab("fwd_in_pdt_building_special_cookpot", fn,assets),
        MakePlacer("fwd_in_pdt_building_special_cookpot_placer", "fwd_in_pdt_building_special_cookpot", "fwd_in_pdt_building_special_cookpot", "idle_empty", nil, nil, nil, nil, nil, nil, placer_postinit_fn)
