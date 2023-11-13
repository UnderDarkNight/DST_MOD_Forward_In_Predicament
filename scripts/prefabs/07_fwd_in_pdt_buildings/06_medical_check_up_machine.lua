--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 健康检查机器
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_medical_check_up_machine"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_medical_check_up_machine.zip"),

    ------- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_building_medical_check_up_machine_punk.zip"),
}

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data = {
        ["fwd_in_pdt_building_medical_check_up_machine_punk"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_building_medical_check_up_machine_punk",                   --- 制作完成后切换的 bank
            build = "fwd_in_pdt_building_medical_check_up_machine_punk",                  --- 制作完成后切换的 build
            name = "punk",                    --- 【制作栏】皮肤的名字
            minimap = "fwd_in_pdt_building_medical_check_up_machine_punk.tex",                --- 小地图图标
            atlas = "images/map_icons/fwd_in_pdt_building_medical_check_up_machine_punk.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_building_medical_check_up_machine_punk",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
        },

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_building_medical_check_up_machine")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
-------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_medical_check_up_machine.tex")
--{anim="level1", sound="dontstarve/common/campfire", radius=2, intensity=.75, falloff=.33, colour = {197/255,197/255,170/255}},
    -- inst.Light:SetFalloff(1)
    -- inst.Light:SetIntensity(.5)
    -- inst.Light:SetRadius(1)
    -- inst.Light:Enable(false)
    -- inst.Light:SetColour(180/255, 195/255, 50/255)

    inst.AnimState:SetBank("fwd_in_pdt_building_medical_check_up_machine")
    inst.AnimState:SetBuild("fwd_in_pdt_building_medical_check_up_machine")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_medical_check_up_machine")

    inst.entity:SetPristine()

    -------------------------------------------------------------------------------------
    --- 皮肤API
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_building_medical_check_up_machine","fwd_in_pdt_building_medical_check_up_machine","fwd_in_pdt_building_medical_check_up_machine.tex")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")

        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fwd_in_pdt_data")
    ----------------------------------------------------------------
    ---- 玩家检查说的话
        inst:AddComponent("inspectable")
        inst.components.inspectable.descriptionfn = function()
            if inst:HasTag("burnt") then
                return GetStringsTable()["inspect_str_burnt"]
            else
                return GetStringsTable()["inspect_str"]
            end
        end
    ----------------------------------------------------------------
    ----- 玩家靠近
        local playerprox = inst:AddComponent("playerprox")
        inst.components.playerprox:SetTargetMode(playerprox.TargetModes.AllPlayers) --- 检测每一个进出的玩家
        inst.components.playerprox:SetPlayerAliveMode(playerprox.AliveModes.AliveOnly)    --- 只检测活着的

        inst.components.playerprox:SetDist(5.5, 7)
        inst.components.playerprox:SetOnPlayerNear(function(inst,player)
            if inst:HasTag("burnt") or player:HasTag("playerghost") then
                return
            end
            if player.components.fwd_in_pdt_wellness then
                player.components.fwd_in_pdt_wellness:HudShowOhters(true)
            end
        end)
        inst.components.playerprox:SetOnPlayerFar(function(inst,player)
            if inst:HasTag("burnt") or player:HasTag("playerghost") then
                return
            end
            if player.components.fwd_in_pdt_wellness then
                player.components.fwd_in_pdt_wellness:HudShowOhters(false)
            end
        end)
        inst:ListenForEvent("_player_hud_close",function()
            for player, v in pairs(inst.components.playerprox.closeplayers) do
                if player and not player:HasTag("playerghost") and player.components.fwd_in_pdt_wellness then
                    player.components.fwd_in_pdt_wellness:HudShowOhters(false)
                end
            end
        end)
    ----------------------------------------------------------------
    --- 敲打拆除
        inst:ListenForEvent("_building_remove",function()
            inst:PushEvent("_player_hud_close")
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition())
            })
            inst:Remove()
        end)
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(function()
            inst:PushEvent("_building_remove")
        end)
        inst.components.workable:SetOnWorkCallback(function()
            if not inst:HasTag("burnt") then
                inst.AnimState:PlayAnimation("hit")
                inst.AnimState:PushAnimation("idle",true)
            else
                inst:PushEvent("_building_remove")
            end
        end)    
    --------------------------------------------------------
    ---- 积雪检查
        local function snow_init(inst)
            if TheWorld.state.issnowcovered then
                inst.AnimState:Show("SNOW")
            else
                inst.AnimState:Hide("SNOW")
            end    
        end
        inst:WatchWorldState("issnowcovered", snow_init)
        snow_init(inst)
    --------------------------------------------------------
    ---- 燃烧
        MakeMediumBurnable(inst, nil, nil, true)
        inst:ListenForEvent("onburnt", function()          --- 烧完后执行
            inst.components.fwd_in_pdt_data:Set("burnt",true)
            inst.AnimState:PlayAnimation("burnt")
            inst:AddTag("burnt")
            snow_init(inst)
            inst:PushEvent("_player_hud_close")
        end)
        inst:DoTaskInTime(0,function()
            if inst.components.fwd_in_pdt_data:Get("burnt") then
                inst:PushEvent("onburnt")
            end
        end)
    --------------------------------------------------------
    ---- 玩家刚刚完成建造
        inst:ListenForEvent("onbuilt", function()
            inst.AnimState:PlayAnimation("place")
            inst.AnimState:PushAnimation("idle",true)
        end)

    --------------------------------------------------------
    inst:AddComponent("prototyper") ---- 靠近触发科技的交易系统
    -- inst.components.prototyper.onturnon = prototyper_onturnon
    -- inst.components.prototyper.onturnoff = prototyper_onturnoff
    -- inst.components.prototyper.onactivate = prototyper_onactivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES[string.upper("fwd_in_pdt_building_medical_check_up_machine")]
    inst:ListenForEvent("onburnt",function()
        inst:RemoveComponent("prototyper")
    end)
    --------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_building_medical_check_up_machine", fn, assets),
        MakePlacer("fwd_in_pdt_building_medical_check_up_machine_placer", "fwd_in_pdt_building_medical_check_up_machine", "fwd_in_pdt_building_medical_check_up_machine", "idle")