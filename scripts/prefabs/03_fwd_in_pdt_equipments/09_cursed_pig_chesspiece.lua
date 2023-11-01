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
    Asset("ANIM", "anim/fwd_in_pdt_equipment_cursed_pig.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_cursed_pig.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_cursed_pig.xml" ),
}

local function onequip(inst, owner)
    
    owner.AnimState:OverrideSymbol("swap_body", "fwd_in_pdt_equipment_cursed_pig", "swap_body")
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

    inst.AnimState:SetBank("fwd_in_pdt_equipment_cursed_pig")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_cursed_pig")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("heavy")

    inst.entity:SetPristine()
    ---------------------------------------------------------------------------------------------
    -- 物品贸易
        inst:AddComponent("fwd_in_pdt_com_acceptable")
        inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer,right_click)
            if TheWorld.state.isnewmoon and item and item.prefab == "bonestew" then
                return true
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
            if not TheWorld.ismastersim then
                return
            end
            if doer and item and item.components.stackable then
                local num = item.components.stackable.stacksize
                item:Remove()
                ---- 3:1 兑换
                        -- local ret_num = inst.components.fwd_in_pdt_data:Add("food_num",num)
                        -- local coins_num = math.floor(ret_num/3)
                        -- doer.SoundEmitter:PlaySound("dontstarve/pig/oink")
                        -- if coins_num >= 1 then
                        --     doer.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
                        --     TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                        --             target = doer,
                        --             name = "fwd_in_pdt_item_jade_coin_green",
                        --             num = coins_num,
                        --     })
                        --     inst.components.fwd_in_pdt_data:Add("food_num",coins_num*-3)
                        -- end
                --- 1:1 兑换
                doer.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
                TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                        target = doer,
                        name = "fwd_in_pdt_item_jade_coin_green",
                        num = num,
                }) 
                
            end
            return true
        end)
        inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStr("fwd_in_pdt_equipment_glass_pig",STRINGS.ACTIONS.APPLYCONSTRUCTION.OFFER)
    ---------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    ---------------------------------------------------------------------------------------------
    inst:AddComponent("fwd_in_pdt_data")

    ---------------------------------------------------------------------------------------------
    ---- 物品组件
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("spear")
        inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_cursed_pig"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_cursed_pig.xml"
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
        -- inst.components.symbolswapdata:SetData("fwd_in_pdt_equipment_cursed_pig", "swap_body")
    ---------------------------------------------------------------------------------------------
        --- 放到大力士健身房的动画替换
        inst:AddComponent("symbolswapdata")
        inst.components.symbolswapdata:SetData("fwd_in_pdt_equipment_cursed_pig", "swap_body")
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_cursed_pig", fn, assets)