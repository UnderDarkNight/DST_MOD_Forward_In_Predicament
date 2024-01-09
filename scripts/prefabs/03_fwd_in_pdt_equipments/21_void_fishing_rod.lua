------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    虚空鱼竿

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_shield_of_light.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.xml" ),
}
local assets =
{
    Asset("ANIM", "anim/fishingrod.zip"),
    Asset("ANIM", "anim/swap_fishingrod.zip"),
}

local function onequip (inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_fishingrod", "swap_fishingrod")
    owner.AnimState:OverrideSymbol("fishingline", "swap_fishingrod", "fishingline")
    owner.AnimState:OverrideSymbol("FX_fishing", "swap_fishingrod", "FX_fishing")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("fishingline")
    owner.AnimState:ClearOverrideSymbol("FX_fishing")
end

local function onfished(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fishingrod")
    inst.AnimState:SetBuild("fishingrod")
    inst.AnimState:PlayAnimation("idle")

    --fishingrod (from fishingrod component) added to pristine state for optimization
    inst:AddTag("fishingrod")

	inst:AddTag("allow_action_on_impassable")

    inst:AddTag("weapon")


    local floater_swap_data = {sym_build = "swap_fishingrod"}
    MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8}, true, -12, floater_swap_data)

    -- inst.scrapbook_subcat = "tool"

    inst.entity:SetPristine()
    ------------------------------------------------------------------------------
        inst:AddComponent("fwd_in_pdt_com_special_fishingrod")
        inst.components.fwd_in_pdt_com_special_fishingrod:Add_Point_Check_Fn(function(inst,doer,pt)
            -- if TheWorld.Map:IsOceanAtPoint(pt.x, pt.y, pt.z) then
            --     return true
            -- end
            -- 
            -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE  and GROUND.IMPASSABLE == TheWorld.Map:GetTileAtPoint(pt.x,pt.y,pt.z) then
            --     return true
            -- end

            if ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE or TheWorld:HasTag("cave") ) and GROUND.IMPASSABLE == TheWorld.Map:GetTileAtPoint(pt.x,pt.y,pt.z) then
                return true
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_special_fishingrod:Add_Start_Fn(function(inst,doer,pt)
            -- print("6666666666666666666",doer,pt)
            -- doer:GetDistanceSqToPoint(pt.x,pt.y,pt.z) <= 100
            -------------- 配置垂钓时间
                local time = 5
                local percentage = math.random(1000)/1000
                if percentage < 0.1 then
                    time = math.random(30,50)
                elseif percentage < 0.2 then
                    time = math.random(20,30)
                else
                    time = math.random(5,20)
                end
                inst.components.fwd_in_pdt_com_special_fishingrod:Set_Fishing_Time(time)
                if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                    print("fwd_in_pdt_com_special_fishingrod time",time)
                end
        end)
        inst.components.fwd_in_pdt_com_special_fishingrod:Add_Start_Hook_Fn(function(inst,doer,pt)
            local doer_pos = doer:GetPosition()
            local target_pos = Vector3(pt.x,pt.y,pt.z)

            local dir = target_pos - doer_pos
            if doer:GetDistanceSqToPoint(pt.x,pt.y,pt.z) > 40 then
                local test_pt = doer_pos + dir:GetNormalized() * (doer:GetPhysicsRadius(0) + (5))
                inst.components.fwd_in_pdt_com_special_fishingrod.pt = test_pt
            end
            inst.components.finiteuses:Use()    --- 耐久
        end)
        inst.components.fwd_in_pdt_com_special_fishingrod:Add_Hook_End_Fn(function(inst,doer,pt)
            -- SpawnPrefab("pondfish").Transform:SetPosition(pt.x, pt.y, pt.z)
            -- print("++++++++++",pt.x,pt.y,pt.z)


            ---------------------------------------------------------------------------------------
                if not (TheWorld.fwd_in_pdt_events and TheWorld.fwd_in_pdt_events.void_fishing_hook )then
                    SpawnPrefab("fwd_in_pdt_fx_miss"):PushEvent("Set",{
                        pt = pt
                    })
                    return
                end
                local time = inst.components.fwd_in_pdt_com_special_fishingrod.time or 5
            ---------------------------------------------------------------------------------------
                -- local target = SpawnPrefab("pigman")
                local target = TheWorld.fwd_in_pdt_events.void_fishing_hook(time)
                if not target then
                    SpawnPrefab("fwd_in_pdt_fx_miss"):PushEvent("Set",{
                        pt = pt,
                        speed = 0.5
                    })
                    return
                end
                -- if target.components.inventoryitem then
                --     target.Physics:SetActive(false)
                -- end
                -- target.Transform:SetPosition(0, 100, 0)
            ---------------------------------------------------------------------------------------
            --- 获取动画
                local debugstring = target.entity:GetDebugString()
                local bank, build, anim = debugstring:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")
                if (not bank) or (bank:find("FROMNUM")) then
                    bank = target.prefab
                end
                if (not build) or (build:find("FROMNUM")) then
                    build = target.prefab
                end
            ---------------------------------------------------------------------------------------
                local SaveRecord = target:GetSaveRecord()
                local scale = nil
                if target.prefab == "fwd_in_pdt_gift_pack" then
                    scale = 2
                end
                target:Remove()
            ---------------------------------------------------------------------------------------
            ---- 物品丢出来
                local discane = TheWorld.components.fwd_in_pdt_func:Dsitance_T2P(doer,pt) * 2
                TheWorld.components.fwd_in_pdt_func:Trow_Item_2_Player({
                        pt = pt ,
                        prefab = "log",     --- 要丢的物品
                        num = 1,            --- 丢的数量
                        player = doer,       --- 玩家inst
                        speed = discane,
                        item_fn = function(item)
                            item:AddTag("INLIMBO")
                            if bank and build and anim then
                                item.AnimState:SetBuild(build)
                                item.AnimState:SetBank(bank)
                                item.AnimState:PlayAnimation(anim)
                            end
                            
                            if scale then
                                item.AnimState:SetScale(scale,scale,scale)
                            end


                            item.__temp_on_land_fn = function(item)
                                item:RemoveEventCallback("on_landed",item.__temp_on_land_fn)

                                -- print("on_landed",item)
                                item:DoTaskInTime(0.5,function()
                                    if item:IsValid() then
                                        local x,y,z = item.Transform:GetWorldPosition()
                                        item:Remove()
                                        SpawnSaveRecord(SaveRecord).Transform:SetPosition(x, y, z)
                                    end
                                end)
                            end
                            item:ListenForEvent("on_landed",item.__temp_on_land_fn)

                        end,
                })
            ---------------------------------------------------------------------------------------
        end)
    ------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("fishingrod")
    -- inst.components.fishingrod:SetWaitTimes(4, 40)
    -- inst.components.fishingrod:SetStrainTimes(0, 5)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon.attackwear = 4

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("fishingrod")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_shield_of_light"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_void_fishingrod", fn, assets)
