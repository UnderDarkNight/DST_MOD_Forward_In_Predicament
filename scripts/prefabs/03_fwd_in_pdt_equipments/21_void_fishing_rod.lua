------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    虚空鱼竿

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_void_fishingrod.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_void_fishingrod.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_void_fishingrod.xml" ),  


    Asset("ANIM", "anim/fwd_in_pdt_void_fishingrod_flower.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_void_fishingrod_flower.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_void_fishingrod_flower.xml" ),  -- 花枝皮肤

}

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_void_fishingrod_flower"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_void_fishingrod_flower",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_void_fishingrod_flower",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_void_fishingrod_flower.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_void_fishingrod_flower",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = "花枝",                                                                         --- 【制作栏】皮肤的名字
            name_color = {0/255,255/255,0/255,255/255},
            onequip_bank = "fwd_in_pdt_void_fishingrod_flower"
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_void_fishingrod")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------


local function onequip (inst, owner)
    local skinname = tostring(inst.skinname)
    local bank = skins_data_item[skinname] and skins_data_item[skinname].onequip_bank

    owner.AnimState:OverrideSymbol("swap_object", bank or "fwd_in_pdt_void_fishingrod", "swap_fishingrod")
    owner.AnimState:OverrideSymbol("fishingline", bank or "fwd_in_pdt_void_fishingrod", "fishingline")
    owner.AnimState:OverrideSymbol("FX_fishing", bank or "fwd_in_pdt_void_fishingrod", "FX_fishing")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
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

    inst.AnimState:SetBank("fwd_in_pdt_void_fishingrod")
    inst.AnimState:SetBuild("fwd_in_pdt_void_fishingrod")
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
    ---- Skin API Register
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_void_fishingrod","fwd_in_pdt_void_fishingrod")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")
            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_void_fishingrod","images/inventoryimages/fwd_in_pdt_void_fishingrod.xml")
        end
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
                if TheWorld.fwd_in_pdt_events and TheWorld.fwd_in_pdt_events.get_fishing_time then
                    time = TheWorld.fwd_in_pdt_events.get_fishing_time()
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
                local bank ,build,anim = nil,nil,nil
                if target.AnimState then
                    local debugstring = target.entity:GetDebugString()
                    bank, build, anim = debugstring:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")
                    if (not bank) or (bank:find("FROMNUM")) and target.AnimState.GetBank then
                        -- bank = target.prefab
                        bank = target.AnimState:GetBank()
                    end
                    if (not build) or (build:find("FROMNUM")) then
                        build = target.AnimState:GetBuild()
                    end
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

    -- inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("fishingrod")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_void_fishingrod"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_void_fishingrod.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("IDLE")
                inst.AnimState:Show("WATER")
            else                                
                inst.AnimState:Show("IDLE")
                inst.AnimState:Hide("WATER")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_void_fishingrod", fn, assets)
