-------------------------------------------------------------------------------------------------------------------------------
--- 零食鼠背包
-------------------------------------------------------------------------------------------------------------------------------
    local function GetStringsTable(name)
        local prefab_name = name or "fwd_in_pdt_equipment_mole_backpack"
        local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
        return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
    end
-------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_mole_backpack.zip"),

    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_mole_backpack_panda.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_panda.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_panda.xml" ),
    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_mole_backpack_cat.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_cat.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_cat.xml" ),
    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_mole_backpack_rabbit.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_rabbit.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_rabbit.xml" ),
    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_mole_backpack_snowman.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_snowman.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_snowman.xml" ),
}

local containers = require "containers"
local params = containers.params

-- 背包界面注册 跟官方的糖果袋子是一样的参数
params.fwd_in_pdt_mole_backpack = {
    widget = {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        -- pos = Vector3(-5, -120, 0),
        pos = Vector3(-5, -130, 0)
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1
}
-- for y = 0, 7 do
--     table.insert(params.fwd_in_pdt_mole_backpack.widget.slotpos, Vector3(-156, -75 * y + 212, 0))
--     table.insert(params.fwd_in_pdt_mole_backpack.widget.slotpos,Vector3(-156 + 75, -75 * y + 212, 0))
-- end
for y = 0, 6 do
    table.insert(params.fwd_in_pdt_mole_backpack.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
    table.insert(params.fwd_in_pdt_mole_backpack.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_equipment_mole_backpack_panda"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_mole_backpack_panda",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_mole_backpack_panda",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_panda.xml",   --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_mole_backpack_panda",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = GetStringsTable()["name.panda"],                                          --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_mole_backpack_panda"
        },
        ["fwd_in_pdt_equipment_mole_backpack_cat"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_mole_backpack_cat",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_mole_backpack_cat",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_cat.xml",   --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_mole_backpack_cat",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = GetStringsTable()["name.cat"],                                          --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_mole_backpack_cat"
        },
        ["fwd_in_pdt_equipment_mole_backpack_rabbit"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_mole_backpack_rabbit",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_mole_backpack_rabbit",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_rabbit.xml",   --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_mole_backpack_rabbit",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = GetStringsTable()["name.rabbit"],                                          --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_mole_backpack_rabbit"
        },
        ["fwd_in_pdt_equipment_mole_backpack_snowman"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_mole_backpack_snowman",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_mole_backpack_snowman",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_mole_backpack_snowman.xml",   --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_mole_backpack_snowman",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = GetStringsTable()["name.snowman"],                                          --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_mole_backpack_snowman"
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_equipment_mole_backpack")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------

local function onequip(inst, owner)
    local skinname = tostring(inst.skinname)
    local bank = skins_data_item[skinname] and skins_data_item[skinname].onequip_bank

    owner.AnimState:OverrideSymbol("backpack",bank or "fwd_in_pdt_equipment_mole_backpack", "swap_body")
    owner.AnimState:OverrideSymbol("swap_body",bank or "fwd_in_pdt_equipment_mole_backpack", "swap_body")    
    inst.components.container:Open(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    inst.components.container:Close(owner)
end

local function onequiptomodel(inst, owner)
    inst.components.container:Close(owner)
end

-- local function AcceptTest(inst,item,giver)
-- 	if item.prefab == "bluegem"  then
-- 		if inst.bluegem < 3 then
-- 			return true
-- 		else
-- 			giver.components.talker:Say("背包已经可以反鲜了")
-- 		end
--     else
--         giver.components.talker:Say("需要蓝宝石")
-- 	end
-- 	return false
-- end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    -- inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("fwd_in_pdt_equipment_mole_backpack")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_mole_backpack")
    inst.AnimState:PlayAnimation("idle")

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("backpack")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    -- local swap_data = {bank = "fwd_in_pdt_equipment_mole_backpack", anim = "idle"}
    -- MakeInventoryFloatable(inst, "med", 0.1, 0.65, nil, nil, swap_data)
    MakeInventoryFloatable(inst, "med", 0.1, 0.65)

    inst.entity:SetPristine()

    --------------------------------------------------------------------
    --- 容器安装
        if TheWorld.ismastersim then
            inst:AddComponent("container")
            inst.components.container:WidgetSetup("fwd_in_pdt_mole_backpack")
        else
            inst.OnEntityReplicated = function()
                local container = inst.replica.container or inst.replica._.container
                if container then
                    container:WidgetSetup("fwd_in_pdt_mole_backpack")
                end
            end
        end
    --------------------------------------------------------------------
    --------------------------------------------------------------------
    ---- Skin API Register
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_equipment_mole_backpack","fwd_in_pdt_equipment_mole_backpack")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_equipment_mole_backpack","images/inventoryimages/fwd_in_pdt_equipment_mole_backpack.xml")
            inst.components.inventoryitem.cangoincontainer = false

            inst:AddComponent("named")
            inst.components.named:SetName_fwd_in_pdt(GetStringsTable()["name"])
        end
    --------------------------------------------------------------------
    if not TheWorld.ismastersim then

        return inst
    end

    inst:AddTag("meteor_protection") --防止被流星破坏
        --因为有容器组件，所以不会被猴子、食人花、坎普斯等拿走
    inst:AddTag("nosteal") --防止被火药猴偷走
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst:AddComponent("inspectable")

    -- inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.cangoincontainer = false

    -- inst:AddComponent("trader")   --交易组件
	-- inst.components.trader:SetAcceptTest(AcceptTest)  

    inst:AddComponent("equippable")
    -- inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BEIBAO or EQUIPSLOTS.BAG or EQUIPSLOTS.BODY
    inst.components.equippable.equipslot = TUNING["Forward_In_Predicament.equip_slot"]:GetBackpackType() or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    MakeHauntableLaunchAndDropFirstItem(inst)
    ------------------------------------------------------------------------------------------------------------
    --- 背包机制
        local light_items_prefab_list = {
            ["wormlight"] = true,          --- 发光浆果
            ["wormlight_lesser"] = true,   --- 小发光浆果
            ["lightbulb"] = true,          --- 荧光果
        }
        inst:ListenForEvent("itemget",function(inst,_table)

            if _table and _table.item and light_items_prefab_list[_table.item.prefab] then
                local tempItem = _table.item                
                if tempItem.components.perishable then
                    tempItem.components.perishable:StopPerishing()
                    tempItem.components.perishable:SetPercent(1)
                end

                if inst.__light == nil then
                    inst.__light = inst:SpawnChild("minerhatlight")                    
                end

            end
        end)

        inst:ListenForEvent("itemlose",function(inst,_table)
            if _table and _table.prev_item then
                local tempItem = _table.prev_item
                if tempItem.components.perishable then
                    tempItem.components.perishable:StartPerishing()
                end
            end
            local light_on_flag = false
            inst.components.container:ForEachItem(function(item)
                if item and item.prefab and light_items_prefab_list[item.prefab] then
                    light_on_flag = true
                end
            end)
            if light_on_flag == false and inst.__light then
                inst.__light:Remove()
                inst.__light = nil
            end
        end)
    ------------------------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_mole_backpack", fn, assets)
