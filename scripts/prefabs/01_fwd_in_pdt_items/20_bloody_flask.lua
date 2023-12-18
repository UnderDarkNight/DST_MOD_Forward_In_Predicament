--------------------------------------------------------------------------
-- 道具
-- 卡尔收藏的血瓶
--------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_glass_horn"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_bloody_flask.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_bloody_flask.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_bloody_flask.xml" ),
}


local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_bloody_flask") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_bloody_flask") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    local scale = 1.5
    inst.Transform:SetScale(scale,scale,scale)

    inst:AddTag("fwd_in_pdt_item_bloody_flask")

    inst.entity:SetPristine()
    ------------------------------------------------------------------------
    --- 动作
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            return doer and doer.prefab == "fwd_in_pdt_carl" and inst.replica.inventoryitem:IsGrandOwner(doer)
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            if inst.components.stackable then
                inst.components.stackable:Get():Remove()
            else
                inst:Remove()
            end

            if doer.components.health then
                doer.components.health:DoDelta(30,nil,inst.prefab)
            end

            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("fwd_in_pdt_special_eat")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_item_bloody_flask",STRINGS.ACTIONS.EAT)
    ------------------------------------------------------------------------


    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_bloody_flask"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_bloody_flask.xml"
    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
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

return Prefab("fwd_in_pdt_item_bloody_flask", fn, assets)