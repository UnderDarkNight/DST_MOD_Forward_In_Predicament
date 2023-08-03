local assets =
{
    -- Asset("ANIM", "anim/panda_fisherman_supply_pack.zip"),
    -- Asset( "IMAGE", "images/inventoryimages/panda_fisherman_supply_pack.tex" ),  -- 背包贴图
    -- Asset( "ATLAS", "images/inventoryimages/panda_fisherman_supply_pack.xml" ),
}
local function GetStringsTable()
    local prefab_name = "npng_special_pig_chesspiece"
    local LANGUAGE = type(TUNING.__NoPainNoGain_LANGUAGE)=="function" and TUNING.__NoPainNoGain_LANGUAGE() or TUNING.__NoPainNoGain_LANGUAGE
    return TUNING.NoPainNoGain_Strings[LANGUAGE] [prefab_name] or {}
end
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------

local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("chesspiece")
    inst.AnimState:SetBuild("swap_chesspiece_hornucopia_marble")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("npng_special_pig_chesspiece")

    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")
    inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)   ---- 设置角色检查时候的内容
    inst:AddComponent("named")
    inst.components.named:SetName(GetStringsTable().name)           -- 设置物品名字


    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(function()
            SpawnPrefab('collapse_small').Transform:SetPosition(inst.Transform:GetWorldPosition())  --- 烟雾
            inst:Remove()
    end)

    return inst
end
---------------------------------------------------------------------------------
------ 不可搬运的雕像，用来删除猪屋用
local function fn()
    local inst = common_fn()
    
    MakeObstaclePhysics(inst, 1)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    ------激活 成 可背走的雕像
    inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = function(inst,doer)
        ReplacePrefab(inst,"npng_special_pig_chesspiece_item")
    end

    inst.OnBuiltFn = function(_,builder)
        print("build",builder)
        if builder == nil then
            inst:Remove()
        end

        if builder then
            local x,y,z = builder.Transform:GetWorldPosition()

            local houses = {}
            local house_temp = nil
            local house_temp_dis = 100000

            local pigskins = {}
            local ents = TheSim:FindEntities(x, y, z, 20, nil, {"burnt"}, {"npng_tag.pighouse","npng_special_pigskin"}) --- 找猪人房子 和 猪皮
            
            for k, temp_inst in pairs(ents) do
                if temp_inst then

                        if temp_inst:HasTag("npng_special_pigskin") then
                                ------ 先判断 猪皮 的 owner 是玩家还是 背包
                                local owner = temp_inst.components.inventoryitem.owner
                                if owner and not owner:HasTag("player") and owner.components.container and owner.components.inventoryitem then -- 如果在背包里
                                    owner = owner.components.inventoryitem.owner
                                end

                                ------ 确定在玩家身上，加入列表里。
                                if owner and owner:HasTag("player") then
                                    table.insert(pigskins,temp_inst)
                                end
                        elseif temp_inst:HasTag("npng_tag.pighouse") and temp_inst.components.spawner and temp_inst.components.spawner:IsOccupied() then
                                ------ 有猪人在里面的房子。存距离 和 inst
                                houses[temp_inst] = builder:GetDistanceSqToInst(temp_inst)
                                house_temp = temp_inst
                                house_temp_dis = builder:GetDistanceSqToInst(temp_inst)
                        end

                end
            end

            if #pigskins > 0 then   ------ 消耗掉一个玩家身上的猪皮
                pigskins[1]:Remove()
            end

            if house_temp ~= nil then   ---- 消耗掉 距离最近的，有猪人的房子
                for temp, dis in pairs(houses) do
                    if dis < house_temp_dis then
                        house_temp_dis = dis
                        house_temp = temp
                    end
                end

                local pt = Vector3(house_temp.Transform:GetWorldPosition())
                house_temp:Remove()
                inst.Transform:SetPosition(pt.x, 0, pt.z)
                SpawnPrefab('collapse_small').Transform:SetPosition(pt.x,0,pt.z)
            else
                ---- 避免找不到 猪人房子 刷新错位置的
                SpawnPrefab('collapse_small').Transform:SetPosition(builder.Transform:GetWorldPosition())
                inst.Transform:SetPosition(builder.Transform:GetWorldPosition())
            end


        end
    end
    return inst
end
---------------------------------------------------------------------------------
-------- 可搬运的雕像
local PHYSICS_RADIUS = .45

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body","swap_chesspiece_hornucopia_marble", "swap_body")  --- 贴图到背上
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")        --- 清理背上的贴图
end
---------------------------------------------------------------------------------
-- TheWorld.components.npng_database.__pigking_reward_fn
---------------------------------------------------------------------------------
local function item_fn()
    local inst = common_fn()

    inst:AddTag("heavy")

	MakeHeavyObstaclePhysics(inst, PHYSICS_RADIUS)
    inst:SetPhysicsRadiusOverride(PHYSICS_RADIUS)
    
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    ------- 进入物品栏/装备栏  设置图标图标
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false          --- 不能进入背包栏，物品栏

    inst.components.inventoryitem:ChangeImageName("pigskin")
    -- inst.components.inventoryitem.imagename = 'npcdebugstone'
    -- inst.components.inventoryitem.atlasname = 'images/inventoryimages/npcdebugstone.xml'

    inst:AddComponent("heavyobstaclephysics")
    inst.components.heavyobstaclephysics:SetRadius(PHYSICS_RADIUS)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT


    ------------------------------------------------------------------
    inst:AddComponent("trader")
        local function Accept_Check(inst,item,giver)
            -- if TheWorld.state.israining and TheWorld.state.isfullmoon then
            if TheWorld.state.israining then
                    if item then
                        if item.prefab == "bonestew" or item.nameoverride == "bonestew" then    --- 加过料理的 肉汤也算数
                            return true
                        end
                    end
            end

            -- if giver and giver.components.talker then
            --     giver:DoTaskInTime(0.2,function()
            --         giver.components.talker:Say(GetStringsTable().inspect_str)
            --     end)
            -- end
            ---- GetActionFailString  fn in stringutil.lua
            if STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.GIVE[string.upper("npng_special_pig_chesspiece.refuse")] == nil then
                STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.GIVE[string.upper("npng_special_pig_chesspiece.refuse")] = GetStringsTable().inspect_str
            end

            return false , string.upper("npng_special_pig_chesspiece.refuse")
        end
        inst.components.trader:SetAbleToAcceptTest(Accept_Check)

        inst.components.trader:SetAcceptTest(Accept_Check)
        inst.components.trader.onaccept = function(inst,giver,item)
            if giver and giver:HasTag("player") and TheWorld.components.npng_database and TheWorld.components.npng_database.__pigking_reward_fn then
                TheWorld.components.npng_database.__pigking_reward_fn(inst,giver)
            end
        end

    ------------------------------------------------------------------
    return inst
end

return Prefab("npng_special_pig_chesspiece", fn,assets) , Prefab("npng_special_pig_chesspiece_item", item_fn,assets)