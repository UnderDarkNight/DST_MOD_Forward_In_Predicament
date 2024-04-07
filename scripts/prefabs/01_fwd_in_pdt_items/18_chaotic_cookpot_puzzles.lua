--[[


    混沌万能锅碎片


]]--


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_material_chaotic_cookpot_puzzles.zip"),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_1.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_1.tex" ),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_2.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_2.tex" ),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_3.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_3.tex" ),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_4.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_4.tex" ),
}

local function make_fn(num)
    num = tostring(num)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(1,0.6)
    -- inst.AnimState:SetScale(2,2,2)
    
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("fwd_in_pdt_material_chaotic_cookpot_puzzles")
    inst.AnimState:SetBank("fwd_in_pdt_material_chaotic_cookpot_puzzles")
    inst.AnimState:PlayAnimation("idle_"..num)

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    -----------------------------------------------------------------------------------
    ---- 组合拼图
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能使用                
            end)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("fwd_in_pdt_material_chaotic_cookpot_puzzles",STRINGS.ACTIONS.BOAT_MAGNET_ACTIVATE)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                local item_prefabs = {
                    ["fwd_in_pdt_material_chaotic_cookpot_puzzle_1"] = true,
                    ["fwd_in_pdt_material_chaotic_cookpot_puzzle_2"] = true,
                    ["fwd_in_pdt_material_chaotic_cookpot_puzzle_3"] = true,
                    ["fwd_in_pdt_material_chaotic_cookpot_puzzle_4"] = true,
                }
                local item_insts = {}
                doer.components.inventory:ForEachItem(function(item)
                    if item and item.prefab and item_prefabs[item.prefab] then
                        item_insts[item.prefab] = item
                    end
                end)
                for prefab_name, v in pairs(item_prefabs) do    ---- 不够4种
                    if item_insts[prefab_name] == nil then
                        return false
                    end
                end
                for k, v in pairs(item_insts) do
                    v:Remove()
                end
    
                local blueprint_prefab = "fwd_in_pdt_building_special_cookpot_blueprint"
                if not PrefabExists(blueprint_prefab) then  ---- 不知道为什么，有时候蓝图prefab会丢失。
                    doer:PushEvent("learnrecipe", { teacher = doer, recipe = "fwd_in_pdt_building_special_cookpot" })
                    return true
                end
                doer.components.inventory:GiveItem(SpawnPrefab(blueprint_prefab))
                return true
            end)
        end
    -----------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_material_chaotic_cookpot_puzzle_"..num
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_material_chaotic_cookpot_puzzle_"..num..".xml"    

    MakeHauntableLaunch(inst)

    return inst
end

local ret = {}
for i = 1, 4, 1 do
    local fn = function()        
        return make_fn(i)
    end
    table.insert(ret,   Prefab("fwd_in_pdt_material_chaotic_cookpot_puzzle_"..tostring(i),fn,assets)       )
end

return unpack(ret)