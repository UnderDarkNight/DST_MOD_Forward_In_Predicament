--------------------------------------------------------------------------
-- 道具
-- 玻璃牛角
--------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_glass_horn"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_glass_horn.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_glass_horn.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_glass_horn.xml" ),
}


local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_glass_horn") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_glass_horn") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("fwd_in_pdt_item_glass_horn")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    --- 动作
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer)                
            end)
            replica_com:SetSGAction("fwd_in_pdt_play_horn")
            replica_com:SetText("fwd_in_pdt_play_horn",STRINGS.ACTIONS.CASTSPELL.MUSIC)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                doer:DoTaskInTime(1,function()                
                    local x,y,z = doer.Transform:GetWorldPosition()
                    local beefalos = TheSim:FindEntities(x, y, z, 15, {"beefalo","largecreature"}, nil, nil)
                    local target = nil
                    for k, temp in pairs(beefalos) do
                        if temp and temp.components.follower then
                            local leader = temp.components.follower:GetLeader()
                            if leader == nil or not leader.components.inventoryitem then
                                target = temp
                                break
                            end
    
                        end
                    end
                    if target then
                        inst:Remove()
                        SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                            target = target
                        })
                        SpawnPrefab("fwd_in_pdt_equipment_glass_beefalo").Transform:SetPosition(target.Transform:GetWorldPosition())
                        target:Remove()
                    end
                end)
                return true
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_glass_horn"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_glass_horn.xml"
    
    MakeHauntableLaunch(inst)



    return inst
end

return Prefab("fwd_in_pdt_item_glass_horn", fn, assets)