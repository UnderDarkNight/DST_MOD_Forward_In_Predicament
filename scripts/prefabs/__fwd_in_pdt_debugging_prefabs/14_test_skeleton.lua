local assets =
{
    Asset("ANIM", "anim/skeletons.zip"),
}

local prefabs =
{
    "boneshard",
    "collapse_small",
    "scrapbook_page",
}

SetSharedLootTable('skeleton',
{
    {'boneshard',   1.00},
    {'boneshard',   1.00},
    {'scrapbook_page', 0.05},
})

local function getdesc(inst, viewer)
    if inst.char ~= nil and not viewer:HasTag("playerghost") then
        local mod = GetGenderStrings(inst.char)
        local desc = GetDescription(viewer, inst, mod)
        local name = inst.playername or STRINGS.NAMES[string.upper(inst.char)]

        --no translations for player killer's name
        if inst.pkname ~= nil then
            return string.format(desc, name, inst.pkname)
        end

        --permanent translations for death cause
        if inst.cause == "unknown" then
            inst.cause = "shenanigans"
        elseif inst.cause == "moose" then
            inst.cause = math.random() < .5 and "moose1" or "moose2"
        end

        --viewer based temp translations for death cause
        local cause =
            inst.cause == "nil"
            and (viewer == "waxwell" and
                "charlie" or
                "darkness")
            or inst.cause

        return string.format(desc, name, STRINGS.NAMES[string.upper(cause)] or STRINGS.NAMES.SHENANIGANS)
    end
end

local function decay(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst:Remove()
    SpawnPrefab("ash").Transform:SetPosition(x, y, z)
    SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
end

local function SetSkeletonDescription(inst, char, playername, cause, pkname, userid)
    inst.char = char
    inst.playername = playername
	inst.userid = userid
    inst.pkname = pkname
    inst.cause = pkname == nil and cause:lower() or nil
    inst.components.inspectable.getspecialdescription = getdesc
end

local function SetSkeletonAvatarData(inst, client_obj)      ------- 设置检查显示的内容
    inst.components.playeravatardata:SetData(client_obj)
end

local function onhammered(inst)                         ---------- 锤子锤够次数后
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("rock")
    inst:Remove()
end



local function onsaveplayer(inst, data)
    data.char = inst.char
    data.playername = inst.playername
	data.userid = inst.userid
    data.pkname = inst.pkname
    data.cause = inst.cause
    if inst.skeletonspawntime ~= nil then
        local time = GetTime()
        if time > inst.skeletonspawntime then
            data.age = time - inst.skeletonspawntime
        end
    end
end

local function onloadplayer(inst, data)

    if data ~= nil and data.char ~= nil and (data.cause ~= nil or data.pkname ~= nil) then
        inst.char = data.char
        inst.playername = data.playername --backward compatibility for nil playername
		inst.userid = data.userid
        inst.pkname = data.pkname --backward compatibility for nil pkname
        inst.cause = data.cause
        if inst.components.inspectable ~= nil then
            inst.components.inspectable.getspecialdescription = getdesc
        end
        if data.age ~= nil and data.age > 0 then
            inst.skeletonspawntime = -data.age
        end

        if data.avatar ~= nil then
            --Load legacy data
            inst.components.playeravatardata:OnLoad(data.avatar)
        end
    end
end



local function fnplayer()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeSmallObstaclePhysics(inst, 0.25)

    inst.AnimState:SetBank("ruins_vase")
    inst.AnimState:SetBuild("ruins_vase")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("playerskeleton")

    inst:AddComponent("playeravatardata")
    inst.components.playeravatardata:AddPlayerData(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("lootdropper")
    -- inst.components.lootdropper:SetChanceLootTable('skeleton')  ------ 设置拆掉后掉落什么，可以自定义掉落物品，和普通建筑一样。这里是选择了统一的掉落列表。
    inst.components.lootdropper:SetLoot({"goldnugget","goldnugget"})

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)      ------ 锤子拆
    inst.components.workable:SetWorkLeft(3) 
    inst.components.workable:SetOnFinishCallback(onhammered)    ------ 拆完后执行

    inst.OnLoad = onloadplayer                              --- 存档加载的时候执行
    inst.OnSave = onsaveplayer                              --- 存档保存的时候执行
    inst.SetSkeletonDescription = SetSkeletonDescription    --- 储存死亡原因
    inst.SetSkeletonAvatarData = SetSkeletonAvatarData      --- 角色外观数据储存用的函数
    inst.Decay = decay                                      --- 腐烂衰变的执行函数，这里是变成灰。 找不到在哪被调用到，留着避免bug
    inst.skeletonspawntime = GetTime()                      --- 记录死亡时间用的
    TheWorld:PushEvent("ms_skeletonspawn", inst)            --- 发送记录，通知TheWorld 有角色死亡

    return inst
end

return Prefab("my_test_skeleton", fnplayer, assets, prefabs)

--- 用法： 在 角色的prefab 的 master_postinit 里，使用   inst.skeleton_prefab = "my_test_skeleton"