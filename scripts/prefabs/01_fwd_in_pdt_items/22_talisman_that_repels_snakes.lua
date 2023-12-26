--------------------------------------------------------------------------
-- 道具
-- 避蛇护符
--------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_glass_horn"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_talisman_that_repels_snakes.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_talisman_that_repels_snakes.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_talisman_that_repels_snakes.xml" ),
}


local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_talisman_that_repels_snakes") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_talisman_that_repels_snakes") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画


    inst:AddTag("fwd_in_pdt_item_talisman_that_repels_snakes")

    inst.entity:SetPristine()



    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(100)
        inst.components.finiteuses:SetUses(100)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
        inst:ListenForEvent("effect",function()
            inst.components.finiteuses:Use(1)
        end)
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_talisman_that_repels_snakes"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_talisman_that_repels_snakes.xml"

    
    MakeHauntableLaunch(inst)

    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("idle_water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)

    return inst
end

return Prefab("fwd_in_pdt_item_talisman_that_repels_snakes", fn, assets)