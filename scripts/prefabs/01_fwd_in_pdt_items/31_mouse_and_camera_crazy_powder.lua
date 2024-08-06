--------------------------------------------------------------------------
-- 道具
-- 癫痫散
--------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_glass_horn"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_mouse_and_camera_crazy_powder.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_mouse_and_camera_crazy_powder.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_mouse_and_camera_crazy_powder.xml" ),
}


local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_mouse_and_camera_crazy_powder") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_mouse_and_camera_crazy_powder") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- local scale = 1.5
    -- inst.Transform:SetScale(scale,scale,scale)
    
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst:AddTag("fwd_in_pdt_item_mouse_and_camera_crazy_powder")

    inst.entity:SetPristine()

    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,doer,right_click)
            return doer.replica.fwd_in_pdt_wellness:Has_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy") and inst.replica.inventoryitem:IsGrandOwner(doer)
        end)
        replica_com:SetSGAction("dolongaction")
        replica_com:SetText("fwd_in_pdt_welness_mouse_and_camera_crazy",STRINGS.ACTIONS.USEITEM)
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
            if inst.components.stackable then
                inst.components.stackable:Get():Remove()
            else
                inst:Remove()
            end

            doer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")


            return true
        end)
    end
    ------------------------------------------------------------------------


    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_welness_mouse_and_camera_crazy"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_welness_mouse_and_camera_crazy.xml"
    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM    
    MakeHauntableLaunch(inst)

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

return Prefab("fwd_in_pdt_welness_mouse_and_camera_crazy", fn, assets)