local assets =
{
    -- Asset("ANIM", "anim/panda_fisherman_supply_pack.zip"),
    -- Asset( "IMAGE", "images/inventoryimages/panda_fisherman_supply_pack.tex" ),  -- 背包贴图
    -- Asset( "ATLAS", "images/inventoryimages/panda_fisherman_supply_pack.xml" ),
}
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_gift_pack"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("stash_map")
    inst.AnimState:SetBuild("stash_map")
    inst.AnimState:PlayAnimation("idle")

	inst.MiniMapEntity:SetIcon("krampus_sack.png")
	inst:AddTag("treasure_map")
	inst:AddTag("map")
	inst:AddTag("irreplaceable")
	inst:AddTag("nonpotatable")

	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("npc_base_lib")
    inst:AddComponent("npc_everything_data")


    inst:AddComponent("inspectable") --可检查组件
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("stash_map")
	inst.components.inventoryitem.cangoincontainer = true
    inst:AddComponent("named")
    -- inst.components.named:SetName(tostring(_table.Name))
    inst.components.named:SetName(GetStringsTable().name)
    STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper("npc_item_pigman_arena_spell_coin")] = GetStringsTable().inspect_str  --人物检查的描述



    return inst
end

return Prefab("npc_item_treasure_map", fn,assets)