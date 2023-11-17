--------------------------------------------------------------------------
-- 道具
-- 《伤寒病论》
--------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_disease_treatment_book"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_disease_treatment_book.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_disease_treatment_book.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_disease_treatment_book.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_disease_treatment_book") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_disease_treatment_book") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("bookcabinet_item") -- 能够放书架里

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    --- 图层覆盖，sg 的 fwd_in_pdt_read_book_type_cookbook 里面
        inst.read_book_onenter_fn = function(inst,player)
            player.AnimState:OverrideSymbol("book_cook", "fwd_in_pdt_item_disease_treatment_book", "book_cook")
        end
        inst.read_book_onexit_fn = function(inst,player)
            player.AnimState:ClearOverrideSymbol("book_cook")
        end
        inst.read_book_animover_fn = inst.read_book_onexit_fn
        inst.read_book_stopable = true  --- 可移动打断
    --------------------------------------------------------------------------
    -- 交互动作
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            return inst.replica.inventoryitem:IsGrandOwner(doer) and not inst:GetIsWet()    --- 在背包里才能使用            
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            if doer and doer.components.fwd_in_pdt_wellness then
                if doer.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_cough") or doer.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_fever") then
                    inst.components.finiteuses:Use()
                    doer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_cough")
                    doer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_fever")
                    return true
                else
                    if doer.components.fwd_in_pdt_com_action_fail_reason then
                        doer.components.fwd_in_pdt_com_action_fail_reason:Inser_Fail_Talk_Str(GetStringsTable()["action_fail"])
                    end
                    return false
                end
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("fwd_in_pdt_read_book_type_cookbook")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_item_disease_treatment_book",STRINGS.ACTIONS.READ)
    --------------------------------------------------------------------------
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_disease_treatment_book"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_disease_treatment_book.xml"
    
    --------------------------------------------------------------------------
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(10)
        inst.components.finiteuses:SetUses(10)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
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

return Prefab("fwd_in_pdt_item_disease_treatment_book", fn, assets)