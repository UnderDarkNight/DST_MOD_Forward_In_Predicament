--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 迷你传送门，给两个独特的岛进行 传送 进出的。
-- 地面的只能当做 公车站，无法使用。
-- 洞里的就能传送到地下的绚丽之门
-- 外部道具通过 event active 进行传送触发
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt__rooms_mini_portal_door"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_rooms_mini_portal_door.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.1)

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_minimap_mini_portal_door.tex")

    inst.AnimState:SetBank("fwd_in_pdt_rooms_mini_portal_door")
    inst.AnimState:SetBuild("fwd_in_pdt_rooms_mini_portal_door")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt__rooms_mini_portal_door")

    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    -- 使用传送门


        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function()
            if TheWorld:HasTag("cave") or TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                return true
            else
                return false
            end
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            if doer then
                local portal_door = TheSim:FindFirstEntityWithTag("multiplayer_portal")
                if portal_door then
                    local x,y,z = portal_door.Transform:GetWorldPosition()
                    doer.components.fwd_in_pdt_func:Transform2PT(x,0,z)
                    -----------------------------------------------------------------
                    --- 让玩家面向摄像机，以及触发门的特效
                        local camera_down_pt = doer.components.fwd_in_pdt_func:TheCamera_GetDownVec() or Vector3(0,0,0)
                        portal_door:PushEvent("rez_player", doer)
                        doer:ForceFacePoint( x+camera_down_pt.x  ,0, z+camera_down_pt.z )

                    -- Spawn a light if it's dark
                        if ( TheWorld:HasTag("cave") or not TheWorld.state.isday ) and #TheSim:FindEntities(x, y, z, 4, { "spawnlight" }) <= 0 then
                            SpawnPrefab("spawnlight_multiplayer").Transform:SetPosition(x, y, z)
                        end
                    -----------------------------------------------------------------
                else
                    return false
                end
            end
            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt__rooms_mini_portal_door",GetStringsTable()["action_str"])
        inst.components.fwd_in_pdt_com_workable:SetSGAction("give")


    -------------------------------------------------------------------------------------

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
    ---- 传送申请
        inst:ListenForEvent("active",function(inst,player)
            if player and player:HasTag("player") and player.components.fwd_in_pdt_func and player.components.fwd_in_pdt_func.Transform2PT and player.userid then
                local x,y,z = inst.Transform:GetWorldPosition()
                y = 0
                if math.random(100) < 50 then
                    x = x + math.random(80)/100
                else
                    x = x - math.random(80)/100                    
                end
                if math.random(100) < 50 then
                    z = z + math.random(80)/100
                else
                    z = z - math.random(80)/100                    
                end
                player.components.fwd_in_pdt_func:Transform2PT(x,y,z)
            end
        end)
    -------------------------------------------------------------------------------------
    ---- 鼠标放上去的文本和改色
        inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful")
        inst.components.fwd_in_pdt_func:Mouseover_SetColour(104/255,60/255,87/255,200/255)
        if TheWorld:HasTag("cave") or TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            inst.components.fwd_in_pdt_func:Mouseover_SetText(GetStringsTable()["mouse_over_text"])
        end
    -------------------------------------------------------------------------------------
    

    return inst
end
return Prefab("fwd_in_pdt__rooms_mini_portal_door", fn, assets)