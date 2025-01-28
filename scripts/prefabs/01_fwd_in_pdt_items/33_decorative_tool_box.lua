------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    装饰工具盒

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_werepig_flute"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_decorative_tool_box.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_decorative_tool_box.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_decorative_tool_box.xml" ),
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function test_fn(inst,target,doer,right_click)
        if TUNING.FWD_IN_PDT_DECORATION_FN and TUNING.FWD_IN_PDT_DECORATION_FN.Test then
            return TUNING.FWD_IN_PDT_DECORATION_FN:Test(target.prefab)
        end
        if target.prefab == "pighouse" then
            return true
        end
    end
    local function replica_com_install(inst,replica_com)
        replica_com:SetTestFn(test_fn)
        -- replica_com:SetSGAction("dolongaction")
        replica_com:SetSGAction("give")
        replica_com:SetText("fwd_in_pdt_item_decorative_tool_box","开始装饰")
    end
    local function acive_fn(inst,target,doer)
        local debuff_prefab = "fwd_in_pdt_debuff_canvas"
        local debuff_inst = nil
        local test_num = 1000
        while test_num > 0 do
            debuff_inst = target:GetDebuff(debuff_prefab)
            if debuff_inst and debuff_inst:IsValid() then
                break
            end
            target:AddDebuff(debuff_prefab,debuff_prefab)
            test_num = test_num - 1
        end
        if not debuff_inst then
            return false
        end
        target:DoTaskInTime(2,function()
            debuff_inst:PushEvent("start",doer)
            inst.components.finiteuses:Use()
        end)
        -- if TheWorld.ismastersim then
        --     inst:AddComponent("fwd_in_pdt_com_workable")
        --     inst.components.finiteuses:Use()
        -- end
        return true
    end
    local function give_com_install(inst)
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_item_use_to",replica_com_install)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("fwd_in_pdt_com_item_use_to")
        inst.components.fwd_in_pdt_com_item_use_to:SetActiveFn(acive_fn)
        
        -- inst:AddComponent("fwd_in_pdt_com_workable")
        -- inst.components.finiteuses:Use()
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_decorative_tool_box") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_decorative_tool_box") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.Transform:SetScale(1.2, 1.2, 1.2)
    -- inst:AddTag("bookcabinet_item") -- 能够放书架里
    
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分
    inst:AddTag("fwd_in_pdt_tag.cursor_sight")

    inst.entity:SetPristine()
    give_com_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("cane")
        -- inst.components.inventoryitem.imagename = "fwd_in_pdt_item_werepig_flute"
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_werepig_flute.xml"
    --------------------------------------------------------------------------
    --------------------------------------------------------------------------
    --- 耐久度
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    --------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_item_decorative_tool_box", fn, assets)