--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 材料商店
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_paddy_windmill"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_paddy_windmill.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_building_paddy_windmill_pink.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_building_paddy_windmill___paddy.zip"),
}

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_building_paddy_windmill_pink"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_building_paddy_windmill_pink",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_building_paddy_windmill_pink",                              --- 制作完成后切换的 build
            atlas = "images/map_icons/fwd_in_pdt_building_paddy_windmill_pink.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_building_paddy_windmill_pink",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            minimap = "fwd_in_pdt_building_paddy_windmill_pink.tex",                --- 小地图图标
            -- name = "尖锐",                                                                         --- 【制作栏】皮肤的名字
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_building_paddy_windmill")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    -- inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_paddy_windmill.tex")

    MakeObstaclePhysics(inst, 1.5)


    inst.AnimState:SetBank("fwd_in_pdt_building_paddy_windmill")
    inst.AnimState:SetBuild("fwd_in_pdt_building_paddy_windmill")
    inst.AnimState:PlayAnimation("idle",true)
    inst.AnimState:SetTime(math.random(100)/10)

    inst:AddTag("structure")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("fwd_in_pdt_building_paddy_windmill")
    
    inst.entity:SetPristine()

    -------------------------------------------------------
    ---- Skin API Register
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_building_paddy_windmill","fwd_in_pdt_building_paddy_windmill","fwd_in_pdt_building_paddy_windmill.tex")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")            
        end
    -------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
   

    inst:AddComponent("inspectable")


    -------------------------------------------------------------------------------------
    ---- 积雪监听执行
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
    ---- 稻田
        inst:DoTaskInTime(0,function()
            local paddy = SpawnPrefab("fwd_in_pdt_building_paddy_windmill___paddy")
            paddy:PushEvent("Link",inst)
            inst:ListenForEvent("onremove",function()
                paddy:Remove()
            end)
        end)
    -- -------------------------------------------------------------------------------------
    -- ---- 掉落列表
    --     inst:AddComponent("lootdropper")
    --     -- inst.components.lootdropper.GetRecipeLoot = function(self,...) 
    --     --     local ret_loots = {"boards","rope"}
    --     --     for i = 1, 3, 1 do
    --     --         if math.random(100) < 30 then
    --     --             table.insert(ret_loots,"boards")
    --     --         end
    --     --         -- if math.random(100) < 30 then
    --     --         --     table.insert(ret_loots,"cutstone")
    --     --         -- end
    --     --         if math.random(100) < 30 then
    --     --             table.insert(ret_loots,"rope")
    --     --         end
    --     --     end
    --     --     -- if math.random(100) < 15 then
    --     --     --     table.insert(ret_loots,"minifan")
    --     --     -- end
    --     --     -- if math.random(100) < 15 then
    --     --     --     table.insert(ret_loots,"farm_plow_item")
    --     --     -- end
    --     --     return ret_loots
    --     -- end
    -- -------------------------------------------------------------------------------------
    ---- 被敲打拆除
        local function remove_rice_plant(inst)
        end
        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(10)
        -- inst.components.workable:SetOnWorkCallback(onhit)
        inst.components.workable:SetOnFinishCallback(function()
            inst.components.lootdropper:DropLoot()----这个才能让官方的敲击实现掉落一半
            local fx = SpawnPrefab("collapse_big")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            --------------------------------------------------
            remove_rice_plant(inst)
            inst.components.lootdropper:DropLoot()
            --------------------------------------------------
            inst:Remove()
        end)
    -------------------------------------------------------------------------------------

    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 稻田
    local function paddy_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("fwd_in_pdt_building_paddy_windmill___paddy")
        inst.AnimState:SetBuild("fwd_in_pdt_building_paddy_windmill___paddy")
        local scale_num = 2.025
        inst.AnimState:SetScale(scale_num, scale_num, scale_num)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetSortOrder(3)
        inst.AnimState:PlayAnimation("idle",true)
        
        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")      --- 不可点击
        inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
        inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
        -- inst.Transform:SetRotation(math.random(350))

        if not TheWorld.ismastersim then
            return inst
        end

        -------------------------------------------------------------------------------------
        ---- 积雪监听执行
            local function snow_over_init(inst)
                if TheWorld.state.issnowcovered then
                    inst.AnimState:Show("SNOW")
                    inst.AnimState:Hide("BASE")
                else
                    inst.AnimState:Hide("SNOW")
                    inst.AnimState:Show("BASE")
                end
            end
            inst:WatchWorldState("issnowcovered", snow_over_init)
    -------------------------------------------------------------------------------------
        inst:ListenForEvent("Link",function(inst,target)
            if target then
                inst.Transform:SetPosition(target.Transform:GetWorldPosition())
                inst.Ready = true
            end
        end)
        inst:DoTaskInTime(0,function()
            if inst.Ready ~= true then
                inst:Remove()
            else
                snow_over_init(inst)
            end
        end)


        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- placer post init
    local function placer_postinit_fn(inst)
        if inst.components.placer then
            inst.components.placer.snap_to_tile = true
            inst.components.placer.override_testfn = function(inst)
                -- print("+++++++++++",inst.Transform:GetWorldPosition())
                local x,y,z = inst.Transform:GetWorldPosition()
                -------------------------------------------------
                -- --- 洞里不能制作
                --     if TheWorld:HasTag("cave") then
                --         return false
                --     end
                -------------------------------------------------
                --- 海洋地块屏蔽
                    local tile_pt = {
                        Vector3(x-4,0,z-4),Vector3(x - 0,0,z-4),Vector3(x+4,0,z-4),
                        Vector3(x-4,0,z-0),Vector3(x - 0,0,z-0),Vector3(x+4,0,z-0),
                        Vector3(x-4,0,z+4),Vector3(x - 0,0,z+4),Vector3(x+4,0,z+4),
                    }
                    for k, temp_pt in pairs(tile_pt) do
                        -- if TheWorld.Map:IsOceanAtPoint(temp_pt.x, 0, temp_pt.z) then
                        --     return false
                        -- end
                        if not TheWorld.Map:IsLandTileAtPoint(temp_pt.x,0,temp_pt.z) then
                            return false
                        end
                    end
                    
                -------------------------------------------------
                --- 附近有风车
                    local other_windmill = TheSim:FindEntities(x, 0, z, 11.5, {"fwd_in_pdt_building_paddy_windmill"} )
                    if #other_windmill > 0 then
                        return false
                    end
                -------------------------------------------------
                ---- 沙漠绿洲，猪王，月台，绚丽之门
                    local important_ent_prefab= {
                        "oasislake",                        --- 沙漠绿洲泉水


                        "charlie_stage_post",               --- 查理舞台

                        "monkeyisland_portal",              --- 非自然传送门（猴岛）
                        "monkeyqueen",                      --- 猴岛女王
                        "monkeypillar",                     --- 猴岛女王附近的柱子

                        "grotto_pool_big",                  --- 洞穴巨型玻璃池
                        "grotto_pool_small",                --- 洞穴小型玻璃池
                    }
                    local ret_block_tags = {
                        "epic",
                    }
                    for k, v in pairs(important_ent_prefab) do
                        table.insert(ret_block_tags,"fwd_in_pdt_tag."..v)
                    end
                    
                    local important_ent = TheSim:FindEntities(x, 0, z, 15.5, nil, nil, ret_block_tags)
                    if #important_ent > 0 then
                        return false
                    end
                -------------------------------------------------
                --- 半径范围内屏蔽
                    local canthavetags = {"CLASSIFIED","NOBLOCK","NOCLICK","player","INLIMBO","FX","animal","smallcreature","flight","character","smallcreature","insect","companion","invisible","chester","hutch"}
                    local musthavetags = nil
                    local musthaveoneoftags = {
                        "structure",    --- 建筑一类
                        -- "blocker",      --- 
                        "multiplayer_portal",                --- 绚丽之门
                    }
                    local important_ent_prefab2 = {
                        "cave_entrance",                    --- 洞穴入口
                        "cave_exit",                        --- 洞穴出口
                        "cave_hole",                        --- 坑洞
                        "pigking",                          --- 猪王
                        "pond",                             --- 池塘
                        "pond_mos",                         --- 沼泽池塘
                        "pond_cave",                        --- 洞穴池塘
                        "lava_pond",                        --- 岩浆池
                        "moonbase",                         --- 月亮祭台
                        "hotspring",                        --- 月岛温泉
                        "wormhole",                         --- 虫洞
                        "wormhole_limited_1",               --- 生病的虫洞
                        "beequeenhive",                     --- 蜂王巢穴的坑
                        "beequeenhivegrown",                --- 蜂王巢穴
                        "gravestone",                       --- 墓碑
                        "walrus_camp",                      --- 海象营地
                    }
                    for k, v in pairs(important_ent_prefab2) do
                        table.insert(musthaveoneoftags,"fwd_in_pdt_tag."..v)
                    end
                    local ents = TheSim:FindEntities(x, 0, z, 7, musthavetags, canthavetags, musthaveoneoftags)
                    if #ents > 0 then
                        return false
                    end
                -------------------------------------------------
                --- 可放置
                    if not TheWorld.Map:IsDeployPointClear(Vector3(x,0,z),inst,2.5,nil,nil,nil,canthavetags) then
                        return false
                    end
                -------------------------------------------------
                return true
            end
        end
        local fx = inst:SpawnChild("fwd_in_pdt_building_paddy_windmill___paddy")
        fx.Ready = true
        fx.AnimState:SetMultColour(1,1,1,0.5)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_building_paddy_windmill", fn, assets),
MakePlacer("fwd_in_pdt_building_paddy_windmill_placer", "fwd_in_pdt_building_paddy_windmill", "fwd_in_pdt_building_paddy_windmill", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil),
    Prefab("fwd_in_pdt_building_paddy_windmill___paddy", paddy_fn, assets)