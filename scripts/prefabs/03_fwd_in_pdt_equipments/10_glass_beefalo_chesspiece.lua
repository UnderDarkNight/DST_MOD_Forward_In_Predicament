--------------------------------------------------------------------------
--[[

    重要笔记：
        图层文件夹 swap_body
        player_encumbered.scml
        swap_body-0   			 【注意】【用不上】往右走的时候，和 10 同时显示，注意透明
        swap_body-1	  			 【注意】【用不上】刚搬起来的瞬间。可以透明
        swap_body-2   					【用不上】
        swap_body-3	  		【重要】往上走的时候（包括骑牛往上）
        swap_body-4	  					【用不上】
        swap_body-5   					【用不上】
        swap_body-6   			 【注意】【用不上】牛背上的时候，向下走+左右，和 9 同时显示，注意透明
        swap_body-7   					【用不上】
        swap_body-8   					【用不上】
        swap_body-9			【向下走】【重要】
        swap_body-10		【向右走】【重要】
        swap_body-11						【用不上】【向上走】
]]--

--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_glass_beefalo.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_glass_beefalo.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_glass_beefalo.xml" ),
}

local function onequip(inst, owner)
    
    owner.AnimState:OverrideSymbol("swap_body", "fwd_in_pdt_equipment_glass_beefalo", "swap_body")
    -- owner.AnimState:Show("ARM_carry")
    -- owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    -- owner.AnimState:Hide("ARM_carry")
    -- owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_body")
end
local PHYSICS_RADIUS = 0.45

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeHeavyObstaclePhysics(inst, PHYSICS_RADIUS)
    inst:SetPhysicsRadiusOverride(PHYSICS_RADIUS)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_glass_beefalo")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_glass_beefalo")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("heavy")

    inst.entity:SetPristine()
    ---------------------------------------------------------------------------------------------
    -- 花费数额
        inst.__cost_num = 5
        if TheWorld.ismastersim then
            require("prefabs/03_fwd_in_pdt_equipments/10_glass_beefalo_chesspiece_events")(inst)
        end
    ---------------------------------------------------------------------------------------------
    -- 物品贸易
    
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if item and item.prefab == "beefalofeed" and item.replica.stackable and item.replica.stackable:StackSize() >= inst.__cost_num then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("give")     --- sg 动作
            replica_com:SetText("fwd_in_pdt_equipment_glass_pig",STRINGS.ACTIONS.APPLYCONSTRUCTION.OFFER)   --- 交互显示的文本
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_acceptable")
            inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                if not (inst and item and doer) then
                    return false
                end
    
                if item.replica.stackable:StackSize() < inst.__cost_num then
                    return false
                end
    
                -- if doer and item and item.components.stackable then
                --     local num = item.components.stackable.stacksize
                --     item:Remove()
                --     doer.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
                --     doer.SoundEmitter:PlaySound("dontstarve/pig/oink")
                --     TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                --             target = doer,
                --             name = "fwd_in_pdt_item_jade_coin_green",
                --             num = num,
                --     })
                -- end
                doer.SoundEmitter:PlaySound("dontstarve/beefalo/puke_out")
                item.components.stackable:Get(5):Remove()
                inst:PushEvent("item_accepted",doer)
                return true
            end)
        end        
    ---------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    ---------------------------------------------------------------------------------------------
    ---- 物品组件
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("spear")
        inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_glass_beefalo"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_glass_beefalo.xml"
        inst.components.inventoryitem:SetSinks(true)
        inst.components.inventoryitem.cangoincontainer = false

    ---------------------------------------------------------------------------------------------
    --- 超重组件
        inst:AddComponent("heavyobstaclephysics")
        inst.components.heavyobstaclephysics:SetRadius(PHYSICS_RADIUS)
    ---------------------------------------------------------------------------------------------
    --- 损毁掉落
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({"nightmarefuel"})
    ---------------------------------------------------------------------------------------------
    --- 穿戴
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT
    ---------------------------------------------------------------------------------------------
    --- 拆毁
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function()
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition())
            })
            inst.components.lootdropper:DropLoot()
            inst:Remove()
        end)
    ---------------------------------------------------------------------------------------------
        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    ---------------------------------------------------------------------------------------------
        -- inst:AddComponent("submersible")
        -- inst:AddComponent("symbolswapdata")
        -- inst.components.symbolswapdata:SetData("fwd_in_pdt_equipment_glass_beefalo", "swap_body")
    ---------------------------------------------------------------------------------------------
            --- 放到大力士健身房的动画替换
            inst:AddComponent("symbolswapdata")
            inst.components.symbolswapdata:SetData("fwd_in_pdt_equipment_glass_beefalo", "swap_body")
        ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_glass_beefalo", fn, assets)