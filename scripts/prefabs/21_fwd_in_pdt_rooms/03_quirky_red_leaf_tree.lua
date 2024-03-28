------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt__rooms_quirky_red_tree"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_rooms_quirky_red_leaf_tree.zip"),
}
-------- 地面的树叶特效
local function ground_leaves_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fwd_in_pdt_rooms_quirky_red_leaf_tree")
    inst.AnimState:SetBuild("fwd_in_pdt_rooms_quirky_red_leaf_tree")
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num, scale_num, scale_num)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(0)
    inst.AnimState:PlayAnimation("ground")
    
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
    inst.Transform:SetRotation(math.random(350))

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end
local function base_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.5)

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_minimap_quirky_red_leaf_tree.tex")

    inst.AnimState:SetBank("fwd_in_pdt_rooms_quirky_red_leaf_tree")
    inst.AnimState:SetBuild("fwd_in_pdt_rooms_quirky_red_leaf_tree")
    inst.AnimState:PlayAnimation("idle",true)
    inst.AnimState:SetScale(2, 2, 2)
    inst.AnimState:SetTime(math.random(5000)/1000)

    -- inst:AddTag("fwd_in_pdt__rooms_quirky_red_tree")
    inst:AddTag("structure")
    inst:AddTag("irreplaceable")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("quake_blocker")  --- 屏蔽地震落石

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    -------------------------------------------------------------------------------------
    --- 地面树叶
        inst:SpawnChild("fwd_in_pdt__rooms_quirky_red_tree_ground_fx").Ready = true        
    -------------------------------------------------------------------------------------
    --- 基础执行事件
        inst:ListenForEvent("show_door",function(inst)
            inst.AnimState:Hide("TOP_LEAVES")
            inst.AnimState:Show("STEPS")
            inst.AnimState:Show("DOOR")
            inst:AddTag("show_door")
        end)
        inst:ListenForEvent("hide_door",function(inst)
            inst.AnimState:Show("TOP_LEAVES")
            inst.AnimState:Hide("STEPS")
            inst.AnimState:Hide("DOOR")
            inst:RemoveTag("show_door")
        end)

    ---- 积雪监听执行
        inst:ListenForEvent("hide_snow",function()
            inst.AnimState:HideSymbol("snow")
        end)
        inst:ListenForEvent("show_snow",function()
            inst.AnimState:ShowSymbol("snow")
        end)
        local function snow_over_init(inst)
            if TheWorld.state.issnowcovered then
                inst:PushEvent("show_snow")
            else
                inst:PushEvent("hide_snow")
            end
        end
        snow_over_init(inst)
        inst:WatchWorldState("issnowcovered", snow_over_init)
        inst:PushEvent("hide_door")
    -------------------------------------------------------------------------------------
        inst:DoPeriodicTask(10,function()
            SpawnPrefab(math.random(100)<30 and "fwd_in_pdt_fx_orange_leaves_fall_down" or "fwd_in_pdt_fx_red_leaves_fall_down"):PushEvent("Set",{
                target = inst,
                scale = Vector3(2,2,2),
            })
        end,math.random(100)/10)
    -------------------------------------------------------------------------------------
    

    return inst
end
------------------------------------------------------------------------------------------------------------------
--- 伪装的树木
local function normal_tree()
    local inst = base_fn()

    inst:AddTag("fwd_in_pdt__rooms_quirky_red_tree")

    ---------------------------------------------------------------------------------------------
    --- 伪装交互

        -- STRINGS.ACTIONS.MIGRATE  --游历
        -- STRINGS.TAGS.LOCATION.CAVE  -- 洞穴

            inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
                replica_com:SetTestFn(function(inst,doer,right_click)
                    return true                    
                end)
                replica_com:SetSGAction("give")
                replica_com:SetText("fwd_in_pdt__rooms_quirky_red_tree",STRINGS.ACTIONS.CHECKTRAP)
            end)
            if TheWorld.ismastersim then
                inst:AddComponent("fwd_in_pdt_com_workable")
                inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                    if doer and doer.sg and doer.sg.GoToState then
                        doer.sg:GoToState("electrocute")
                    end
                    return true
                end)
            end
    ---------------------------------------------------------------------------------------------


    if not TheWorld.ismastersim then
        return inst
    end
    ---------------------------------------------------------------------------------------------
    ---- 修改鼠标放上去的颜色
        inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful")
        inst.components.fwd_in_pdt_func:Mouseover_SetColour(190/255,65/255,28/255,255/255)
        inst.components.fwd_in_pdt_func:Mouseover_SetText(STRINGS.ACTIONS.CHECKTRAP .. " ".. GetStringsTable()["name"])
        
    ---------------------------------------------------------------------------------------------

    return inst
end

------------------------------------------------------------------------------------------------------------------
---- 洞里需要带灯光,需要阻挡落石 等
local function special_tree_in_cave(inst)
    inst.entity:AddLight()

    inst.Light:SetIntensity(0.9)		-- 强度
    inst.Light:SetRadius(5)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
    inst.Light:SetFalloff(0.07)		-- 下降梯度
    inst.Light:SetColour(255 / 255, 165 / 255, 0 / 255)
    inst.Light:Enable(true)

    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 13)
    inst.components.playerprox:SetOnPlayerNear(function()
        inst:PushEvent("show_door")
    end)
    inst.components.playerprox:SetOnPlayerFar(function()
        inst:PushEvent("hide_door")
    end)


end
------------------------------------------------------------------------------------------------------------------
---- 洞外的有特殊条件就能看见楼梯
local function special_tree_outside(inst)
    if not TheWorld.ismastersim then
        return
    end

    ---------------------------------------------------------------------------------------------------------------------
    --- 玩家拥有指定物品，靠近才能直接显示真的。
        local function player_has_the_item(player)
            local weapon = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if weapon and weapon.components.tool then
                return weapon.components.tool:CanDoAction(ACTIONS.CHOP)
            end
            return false
        end
        ----------------------------------------------------------
        --- 挂在玩家身上的 event
        inst.__onequipt_check_event_for_player = function(player,_table)
            player:DoTaskInTime(0.5,function()
                if player_has_the_item(player) then
                    if not inst:HasTag("show_door") then
                        inst:PushEvent("show_door")
                    end
                elseif inst:HasTag("show_door") then
                    inst:PushEvent("hide_door")
                end
            end)
        end


        local playerprox = inst:AddComponent("playerprox")
        inst.components.playerprox:SetTargetMode(playerprox.TargetModes.AllPlayers) --- 检测每一个进出的玩家
        inst.components.playerprox:SetPlayerAliveMode(playerprox.AliveModes.DeadOrAlive)    --- 不管死没死，都检测

        inst.components.playerprox:SetDist(15, 20)
        inst.components.playerprox:SetOnPlayerNear(function(inst,player)
            -- inst:PushEvent("show_door")
            if not (player and player:HasTag("player") and player.components.playercontroller)then
                return
            end
            if not inst:HasTag("show_door") and player_has_the_item(player) then
                inst:PushEvent("show_door")
            end
            if not player:HasTag("fwd_in_pdt__rooms_quirky_red_tree_special.__onequipt_check_event_for_player") then
                player:ListenForEvent("equip",inst.__onequipt_check_event_for_player)
                player:ListenForEvent("unequip",inst.__onequipt_check_event_for_player)
                player:AddTag("fwd_in_pdt__rooms_quirky_red_tree_special.__onequipt_check_event_for_player")
            end
            ------ 靠近说话
                local function wisper2player()
                    player.components.fwd_in_pdt_func:Wisper({
                        m_colour = {190/255,65/255,28/255} ,                          ---- 内容颜色
                        -- s_colour = {255,255,0},                         ---- 发送者颜色
                        -- icondata = "profileflair_shadowhand",        ---- 图标
                        message = GetStringsTable()["wisper_str"],                                 ---- 文字内容
                        -- sender_name = "",                               ---- 发送者名字
                    })
                end
                local index_str = "player_close."..player.userid
                if not inst.components.fwd_in_pdt_func:Get(index_str) then
                    inst.components.fwd_in_pdt_func:Set(index_str,true)
                    wisper2player()
                else
                    if math.random(1000) <= 100 then
                        wisper2player()
                    end
                end
        end)
        inst.components.playerprox:SetOnPlayerFar(function(inst,player)
            -- inst:PushEvent("hide_door")
            if not (player and player:HasTag("player") and player.components.playercontroller)then
                return
            end
            player:RemoveTag("fwd_in_pdt__rooms_quirky_red_tree_special.__onequipt_check_event_for_player")
            player:RemoveEventCallback("equip",inst.__onequipt_check_event_for_player)
            player:RemoveEventCallback("unequip",inst.__onequipt_check_event_for_player)

            local x,y,z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 19, {"player"})
            if #ents == 0 and inst:HasTag("show_door") then
                inst:PushEvent("hide_door")
            end

        end)

    --------------------------------------------------------------------------
    --- 周期性找附近的树换位置.重载存档也会执行。
    --- 在玩家加载范围外才执行
        local function find_new_location(inst)
            local x,y,z = inst.Transform:GetWorldPosition()
            local trees = TheSim:FindEntities(x, y, z,50, {"fwd_in_pdt__rooms_quirky_red_tree"})
            if #trees > 0 then
                local old_pt = Vector3(x,y,z)
                local tar_tree = trees[math.random(#trees)]
                local new_pt = Vector3(tar_tree.Transform:GetWorldPosition())
                inst.Transform:SetPosition(new_pt.x,new_pt.y,new_pt.z)
                tar_tree.Transform:SetPosition(old_pt.x,old_pt.y,old_pt.z)
            end
        end
        inst:WatchWorldState("cycles", function()
            if inst:IsAsleep() then     
                find_new_location(inst)
            end
        end)
        inst:DoTaskInTime(1,find_new_location)
    --------------------------------------------------------------------------
    --- 离开加载范围的时候 重置动画
        inst:ListenForEvent("entitysleep",function()
            inst:PushEvent("hide_door")
            -- print("info entitysleep",inst)
        end)
    --------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------

local function special_tree()
    local inst = base_fn()

    inst:AddTag("fwd_in_pdt__rooms_quirky_red_tree_special")

    --------------------------------------
    --- 根据洞里洞外切换组件和功能
        if TheWorld:HasTag("cave") then
            special_tree_in_cave(inst)
        else
            special_tree_outside(inst)
        end
    --------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    ---------------------------------------------------------
    ---- 穿越洞穴用的组件，ID需要独特
        inst:AddComponent("worldmigrator")
        inst:DoTaskInTime(1,function()
            inst.components.worldmigrator.id  = 6101
            inst.components.worldmigrator.receivedPortal = 6101	
        end)
    ---------------------------------------------------------
        
    -----------------------------------------------------------
    ---------------------------------------------------------------------------------------------
    ---- 修改鼠标放上去的颜色
        inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful")
        if not TheWorld:HasTag("cave") then
            inst.components.fwd_in_pdt_func:Mouseover_SetColour( 236/255 , 131/255 , 67/255 ,200/255)
            inst.components.fwd_in_pdt_func:Mouseover_SetText(STRINGS.ACTIONS.CHECKTRAP .. " ".. GetStringsTable()["name"])
        else
            inst.components.fwd_in_pdt_func:Mouseover_SetText(STRINGS.ACTIONS.ENTER_GYM .. " ".. GetStringsTable()["name"])            
        end

    ---------------------------------------------------------------------------------------------

    return inst
end


return Prefab("fwd_in_pdt__rooms_quirky_red_tree", normal_tree, assets),
        Prefab("fwd_in_pdt__rooms_quirky_red_tree_special", special_tree, assets),
            Prefab("fwd_in_pdt__rooms_quirky_red_tree_ground_fx", ground_leaves_fn, assets)