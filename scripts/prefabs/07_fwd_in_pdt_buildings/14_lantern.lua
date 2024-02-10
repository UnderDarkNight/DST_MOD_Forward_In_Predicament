--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 迷你传送门，给两个独特的岛进行 传送 进出的。
-- 地面的只能当做 公车站，无法使用。
-- 洞里的就能传送到地下的绚丽之门
-- 外部道具通过 event active 进行传送触发
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_building_banner_light"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_lantern.zip"),
    Asset( "IMAGE", "images/map_icons/fwd_in_pdt_building_lantern.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/map_icons/fwd_in_pdt_building_lantern.xml" ),
    Asset("ANIM", "anim/fwd_in_pdt_building_lantern_moon.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data = {
        ["fwd_in_pdt_building_lantern_moon"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_building_lantern_moon",                   --- 制作完成后切换的 bank
            build = "fwd_in_pdt_building_lantern_moon",                  --- 制作完成后切换的 build
            name = "月光",                    --- 【制作栏】皮肤的名字
            name_color = {255/255,185/255,15/255,255/255},
            minimap = "fwd_in_pdt_building_lantern_moon.tex",                --- 小地图图标
            atlas = "images/map_icons/fwd_in_pdt_building_lantern_moon.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_building_lantern_moon",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
        },

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_building_lantern")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Light:SetIntensity(0.5)		-- 强度
    inst.Light:SetRadius(20)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
    inst.Light:SetFalloff(1)		-- 下降梯度
    inst.Light:SetColour(255 / 255, 255 / 255, 255 / 255)
    inst.Light:Enable(false)

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_lantern.tex")

    inst.AnimState:SetBank("fwd_in_pdt_building_lantern")
    inst.AnimState:SetBuild("fwd_in_pdt_building_lantern")
    inst.AnimState:PlayAnimation("idle",true)
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num,scale_num,scale_num)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_lantern")
    
    inst.entity:SetPristine()


    --- 皮肤API
    Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_building_lantern","fwd_in_pdt_building_lantern","fwd_in_pdt_building_lantern.tex")
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_func"):Init("skin","normal_api")
    end

    if not TheWorld.ismastersim then
        return inst
    end
   
    inst:AddComponent("inspectable")

     -------------------------------------------------------------------------------------
    ---- 掉落列表
    inst:AddComponent("lootdropper")
    inst.components.lootdropper.GetRecipeLoot = function(self,...) 
        local ret_loots = {"yellowgem","rope"}
        for i = 1, 3, 1 do
            if math.random(100) < 0 then
                table.insert(ret_loots,"yellowgem")
            end
            -- if math.random(100) < 30 then
            --     table.insert(ret_loots,"cutstone")
            -- end
            if math.random(100) < 30 then
                table.insert(ret_loots,"rope")
            end
        end
        -- if math.random(100) < 15 then
        --     table.insert(ret_loots,"minifan")
        -- end
        -- if math.random(100) < 15 then
        --     table.insert(ret_loots,"farm_plow_item")
        -- end
        return ret_loots
    end
    --- 敲打拆除
    inst:ListenForEvent("_building_remove",function()
        SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
            pt = Vector3(inst.Transform:GetWorldPosition())
        })
        inst:Remove()
    end)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(function()
        inst:PushEvent("_building_remove")
    end)
--------------------------------------------------------
        local function snow_over_init(inst)
            if TheWorld.state.issnowcovered then
                inst.AnimState:Show("SNOW")
            else
                inst.AnimState:Hide("SNOW")
            end
        end
        snow_over_init(inst)
        inst:WatchWorldState("issnowcovered", snow_over_init)
    -------------------------------------------------------------------------------------
    ----- 灯的开关控制
        inst:ListenForEvent("LIGHT_ON",function()
            inst.AnimState:Hide("LIGHT_OFF")
            inst.AnimState:Show("LIGHT_ON")
            inst.Light:Enable(true)

            if inst.__ground_fx == nil then
                inst.__ground_fx = inst:SpawnChild("fwd_in_pdt_building_banner_light_fx")
                inst.__ground_fx:PushEvent("Set",{pt = Vector3(0,0,0)})
            end
        end)
        inst:ListenForEvent("LIGHT_OFF",function()
            inst.AnimState:Show("LIGHT_OFF")
            inst.AnimState:Hide("LIGHT_ON")
            inst.Light:Enable(false)
            if inst.__ground_fx then
                inst.__ground_fx:Remove()
                inst.__ground_fx = nil
            end
        end)

        local function SwitchTheLight(inst)
            if TheWorld.state.isnight or TheWorld:HasTag("cave") then
                inst:PushEvent("LIGHT_ON")
            else
                inst:PushEvent("LIGHT_OFF")
            end
        end
        inst:DoTaskInTime(0,SwitchTheLight)
        inst:WatchWorldState("isnight",function()
            inst:DoTaskInTime(math.random(3, 8),SwitchTheLight)
        end)
        inst:WatchWorldState("isday",function()
            inst:DoTaskInTime(math.random(3,8),SwitchTheLight)
        end)
    -------------------------------------------------------------------------------------

    return inst
end

local function ground_fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fwd_in_pdt_building_lantern")
    inst.AnimState:SetBuild("fwd_in_pdt_building_lantern")
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num, scale_num, scale_num)
    inst.AnimState:SetMultColour(1, 1, 1, 0.3)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(0)
    inst.AnimState:PlayAnimation("fx",true)
    
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    -- inst:AddTag("NOCLICK")      --- 不可点击
    -- inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    -- inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
    inst:AddTag("structure")

    inst.Transform:SetRotation(math.random(350))

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("Set",function(_,_table)
        if type(_table) == "table" then
            if _table.pt and _table.pt.x then
                inst.Transform:SetPosition(_table.pt.x,0,_table.pt.z)
            end
            inst.Ready = true
        end
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

local function placer_postinit_fn(inst)
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num,scale_num,scale_num)
    inst.AnimState:Hide("SNOW")
end

return Prefab("fwd_in_pdt_building_lantern", fn, assets),
            Prefab("fwd_in_pdt_building_lantern_fx", ground_fx, assets),
            MakePlacer("fwd_in_pdt_building_lantern_placer","fwd_in_pdt_building_lantern", "fwd_in_pdt_building_lantern", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn ,nil, nil)