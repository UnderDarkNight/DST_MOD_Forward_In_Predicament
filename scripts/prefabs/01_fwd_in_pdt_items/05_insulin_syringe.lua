--------------------------------------------------------------------------
-- 道具
-- 胰岛素注射器
--------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_insulin_syringe.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_insulin__syringe.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_insulin__syringe.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_item_insulin_syringe") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_insulin_syringe") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.AnimState:SetScale(0.7,0.7,0.7)
    -- MakeInventoryFloatable(inst)
    
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    -- 交互动作
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能使用                    
            end)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("fwd_in_pdt_item_insulin__syringe",STRINGS.ACTIONS.USEITEM)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                if doer and doer.components.fwd_in_pdt_wellness then
                    doer.components.fwd_in_pdt_wellness:DoDelta_Glucose(-30)
                    doer.components.fwd_in_pdt_wellness:ForceRefresh()
                    if inst.components.stackable then
                        inst.components.stackable:Get():Remove()
                    else
                        inst:Remove()
                    end
                    return true
                end
                return false
            end)
        end
    --------------------------------------------------------------------------
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_insulin__syringe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_insulin__syringe.xml"
    inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失
    
    --------------------------------------------------------------------------
    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    --------------------------------------------------------------------------
    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
                -- local x,y,z = inst.Transform:GetWorldPosition()
                -- SpawnPrefab("fwd_in_pdt_fx_splash_sink"):PushEvent("Set",{
                --     pt = Vector3(x,0,z),
                --     -- scale = Vector3(0.3,0.3,0.3),
                -- })
                -- inst:Remove()
            else                                
                inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            inst.onPreBuilt = function(doer,inst)   --- 物品独有
                print("info onPreBuilt test",doer,inst)
            end
            inst.OnBuilt = function(doer,inst)   --- 物品独有
                print("info OnBuilt test",doer,inst)
            end
        end

    -------------------------------------------------------------------    
    return inst
end
return Prefab("fwd_in_pdt_item_insulin__syringe", fn, assets)