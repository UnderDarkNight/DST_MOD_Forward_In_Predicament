--------------------------------------------------------------------------
-- 道具
-- 《新月之书》
--------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_formulated_crystal"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_formulated_crystal.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_formulated_crystal.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_formulated_crystal.xml" ),
}



local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_formulated_crystal") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_formulated_crystal") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.Transform:SetScale(1.2, 1.2, 1.2)
    inst:AddTag("bookcabinet_item") -- 能够放书架里

    inst.entity:SetPristine()

    --------------------------------------------------------------------------
        inst.__net_entity_player = net_entity(inst.GUID,"fwd_in_pdt_item_formulated_crystal","fwd_in_pdt_item_formulated_crystal")
        inst:ListenForEvent("fwd_in_pdt_item_formulated_crystal",function()
            local player = inst.__net_entity_player:value()
            if ThePlayer and player and ThePlayer == player and ThePlayer.HUD then
                ThePlayer.HUD:fwd_in_pdt_special_production_formulated_crystal_widget_open()
            end
        end)
    --------------------------------------------------------------------------
    -- 交互动作
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            return inst.replica.inventoryitem:IsGrandOwner(doer)
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            if doer then
                inst.__net_entity_player:set(doer)
                inst:DoTaskInTime(0.5,function()
                    inst.__net_entity_player:set(inst)                    
                end)
                return true
            end

            return false
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("give")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_item_formulated_crystal",STRINGS.ACTIONS.READ)
    --------------------------------------------------------------------------
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_formulated_crystal"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_formulated_crystal.xml"
    
    --------------------------------------------------------------------------
    -- inst:AddComponent("stackable") -- 可堆叠
    -- inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    --------------------------------------------------------------------------
    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)   -- 可被其他物品引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
            else                                
                inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_item_formulated_crystal", fn, assets)