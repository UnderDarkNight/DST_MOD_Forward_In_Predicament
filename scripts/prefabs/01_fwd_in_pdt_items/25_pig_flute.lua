------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    笛子

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_pig_flute"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_pig_flute.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_pig_flute.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_pig_flute.xml" ),
}


local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_pig_flute") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_pig_flute") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.Transform:SetScale(1.2, 1.2, 1.2)
    -- inst:AddTag("bookcabinet_item") -- 能够放书架里

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    ---- 吹笛
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_play_flute",function()
            local replica_com = inst.replica.fwd_in_pdt_com_play_flute or inst.replica._.fwd_in_pdt_com_play_flute
            replica_com:SetBuild("fwd_in_pdt_item_werepig_flute")
            -- replica_com:SetLayer()
            -- replica_com:SetSound("dontstarve/creatures/werepig/howl")
            replica_com:SetTestFn(function(inst,doer)
                return true
            end)
            replica_com:SetPreActionFn(function(inst,doer)
                -- print("info +++ play flute +++",doer)
            end)

        end)
        inst:AddComponent("fwd_in_pdt_com_play_flute")
        inst.components.fwd_in_pdt_com_play_flute:SetSpellFn(function(inst,doer)
            -- print("cast spell fn",inst,doer)
            local x,y,z = doer.Transform:GetWorldPosition()
            ------- 寻找附近猪人房子
                local range = 20
                local ents = TheSim:FindEntities(x, y, z, range, {"structure"}, {"burnt"}, nil)
                local ents_house = {}
                for k, temp in pairs(ents) do
                    if temp and temp.prefab == "pighouse" then
                        table.insert(ents_house,temp)
                    end
                end
                for k, pighouse in pairs(ents_house) do
                    pighouse.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
                    local temp_pt = Vector3(pighouse.Transform:GetWorldPosition())
                    local pigman = SpawnPrefab("pigman")
                    pigman.Transform:SetPosition(temp_pt.x, 0, temp_pt.z)
                end
            ------- 寻找普通猪人
                local pigmen = TheSim:FindEntities(x, y, z, range, {"pig"}, {"werepig"}, nil)
                for k, pigman in pairs(pigmen) do
                    if pigman.components.hauntable then
                        pigman.components.hauntable:Panic(300)
                    end
                end
            ------- 消耗耐久度
                inst.components.finiteuses:Use()

        end)
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_pig_flute"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_pig_flute.xml"
    
    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)   -- 可被其他物品引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    -------------------------------------------------------------------
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(20)
        inst.components.finiteuses:SetUses(20)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_item_pig_flute", fn, assets)