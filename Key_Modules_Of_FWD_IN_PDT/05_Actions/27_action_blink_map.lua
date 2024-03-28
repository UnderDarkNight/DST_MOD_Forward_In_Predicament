----------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name or "FWD_IN_PDT_BLINK_MAP")
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------


local function ArriveAnywhere()
    return true
end

local FWD_IN_PDT_BLINK_MAP = Action({ priority=999, customarrivecheck=ArriveAnywhere, rmb=true, mount_valid=false, map_action=true, })  
FWD_IN_PDT_BLINK_MAP.id = "FWD_IN_PDT_BLINK_MAP"
FWD_IN_PDT_BLINK_MAP.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    if act.doer then
        return "DEFAULT"
    end
end

FWD_IN_PDT_BLINK_MAP.fn = function(act)    --- 只在服务端执行~
    -- local inst = act.invobject
    -- local inst = act.target
    local doer = act.doer
    -- local pos = act.pos or {}
    -- local pt = pos.local_pt

    local act_pos = act:GetActionPoint()
    local x,y,z = act_pos:Get()

    

    if doer then
        if doer.components.fwd_in_pdt_com_map_jumper then
            doer.components.fwd_in_pdt_com_map_jumper:CastPreSpell(Vector3(x,y,z))
        end
        
        if doer.sg then            
                doer.sg:GoToState("portal_jumpin_fwd_in_pdt", {dest = act_pos, from_map = true,})
                doer:DoTaskInTime(1,function()
                    if doer:GetDistanceSqToPoint(act_pos:Get()) < 3 then
                        doer.components.fwd_in_pdt_com_map_jumper:CastSpell(Vector3(x,y,z))
                    end
                end)
        end


    end

    return true
end



AddAction(FWD_IN_PDT_BLINK_MAP)
STRINGS.ACTIONS.FWD_IN_PDT_BLINK_MAP = {
    DEFAULT = GetStringsTable()["DEFAULT"] or "跳跳跳跳跳",
}
STRINGS.FWD_IN_PDT_BLINK_MAP = ACTIONS.FWD_IN_PDT_BLINK_MAP.mod_name

local BLINK_MAP_MUST = { "CLASSIFIED", "globalmapicon", "fogrevealer" }
ACTIONS_MAP_REMAP[ACTIONS.FWD_IN_PDT_BLINK_MAP.code] = function(act, targetpos)
    -----------------------------------------------------
    -- 这部分代码会在地图上以 30FPS 执行
    -----------------------------------------------------
    local doer = act.doer
    if doer == nil then
        return nil
    end

    -- if doer.replica.sanity and doer.replica.sanity:GetCurrent() < 51 then
    --     return nil
    -- end
       
    -- if not TheWorld.Map:IsAboveGroundAtPoint(targetpos.x,targetpos.y,targetpos.z) then
    --     return nil
    -- end

    if not doer.replica.fwd_in_pdt_com_map_jumper:Test(Vector3(targetpos.x,targetpos.y,targetpos.z)) then
        return nil
    end

    -- print(" +++++++++++++++++++ ",targetpos,act.invobject)
    local act_remap = BufferedAction(doer, nil, ACTIONS.FWD_IN_PDT_BLINK_MAP, act.invobject, targetpos)
    return act_remap
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------    
    local function DoWortoxPortalTint(inst, val)
        if val > 0 then
            inst.components.colouradder:PushColour("portaltint", 154 / 255 * val, 23 / 255 * val, 19 / 255 * val, 0)
            val = 1 - val
            inst.AnimState:SetMultColour(val, val, val, 1)
        else
            inst.components.colouradder:PopColour("portaltint")
            inst.AnimState:SetMultColour(1, 1, 1, 1)
        end
    end
    local function ToggleOnPhysics(inst)
        inst.sg.statemem.isphysicstoggle = nil
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)
    end

    local function ToggleOffPhysics(inst)
        inst.sg.statemem.isphysicstoggle = true
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------- SG

    AddStategraphState("wilson",State{
        name = "portal_jumpin_fwd_in_pdt",
        tags = { "busy", "pausepredict", "nodangle", "nomorph" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("wortox_portal_jumpin")
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("wortox_portal_jumpin_fx").Transform:SetPosition(x, y, z)
            inst.sg:SetTimeout(11 * FRAMES)
            inst.sg.statemem.from_map = data and data.from_map or nil
            local dest = data and data.dest or nil
            if dest ~= nil then
                inst.sg.statemem.dest = dest
                inst:ForceFacePoint(dest:Get())
            else
                inst.sg.statemem.dest = Vector3(x, y, z)
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction(10)
            end

        end,

        onupdate = function(inst)
            if inst.sg.statemem.tints ~= nil then
                DoWortoxPortalTint(inst, table.remove(inst.sg.statemem.tints))
                if #inst.sg.statemem.tints <= 0 then
                    inst.sg.statemem.tints = nil
                end
            end
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/infection_post", nil, .7)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
            end),
            TimeEvent(2 * FRAMES, function(inst)
                inst.sg.statemem.tints = { 1, .6, .3, .1 }
                PlayFootstep(inst)
            end),
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:AddStateTag("noattack")
                inst.components.health:SetInvincible(true)
                inst.DynamicShadow:Enable(false)
            end),
        },

        ontimeout = function(inst)
            inst.sg.statemem.portaljumping = true
            inst.sg:GoToState("portal_jumpout_fwd_in_pdt", {dest = inst.sg.statemem.dest, from_map = inst.sg.statemem.from_map})
        end,

        onexit = function(inst)
            if not inst.sg.statemem.portaljumping then
                inst.components.health:SetInvincible(false)
                inst.DynamicShadow:Enable(true)
                DoWortoxPortalTint(inst, 0)
            end
        end,
    })

    AddStategraphState("wilson",State{
        name = "portal_jumpout_fwd_in_pdt",
        tags = { "busy", "nopredict", "nomorph", "noattack", "nointerrupt" },

        onenter = function(inst, data)
            ToggleOffPhysics(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("wortox_portal_jumpout")
            inst:ResetMinimapOffset()
            if data and data.from_map then
                inst:SnapCamera()
            end
            local dest = data and data.dest or nil
            if dest ~= nil then
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:RemotePausePrediction(10)
                end
                inst.Physics:Teleport(dest:Get())
                if TheWorld and TheWorld.components.walkableplatformmanager then -- NOTES(JBK): Workaround for teleporting too far causing the client to lose sync.
                    TheWorld.components.walkableplatformmanager:PostUpdate(0)
                end
            else
                dest = inst:GetPosition()
            end
            SpawnPrefab("wortox_portal_jumpout_fx").Transform:SetPosition(dest:Get())
            -- SpawnPrefab("sanity_raise").Transform:SetPosition(dest:Get())
            inst.DynamicShadow:Enable(false)
            inst.sg:SetTimeout(14 * FRAMES)
            DoWortoxPortalTint(inst, 1)
            inst.components.health:SetInvincible(true)
            inst:PushEvent("soulhop")

            -- pcall(function()
            --     inst:DoTaskInTime(0,function()
            --         if inst == ThePlayer then
            --             ThePlayer.HUD.controls:HideMap()
            --         end
            --     end)
            -- end)
        end,

        onupdate = function(inst)
            if inst.sg.statemem.tints ~= nil then
                DoWortoxPortalTint(inst, table.remove(inst.sg.statemem.tints))
                if #inst.sg.statemem.tints <= 0 then
                    inst.sg.statemem.tints = nil
                end
            end
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out") end),
            TimeEvent(5 * FRAMES, function(inst)
                inst.sg.statemem.tints = { 0, .4, .7, .9 }
            end),
            TimeEvent(7 * FRAMES, function(inst)
                inst.components.health:SetInvincible(false)
                inst.sg:RemoveStateTag("noattack")
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
            end),
            TimeEvent(8 * FRAMES, function(inst)
                inst.DynamicShadow:Enable(true)
                ToggleOnPhysics(inst)
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            inst.components.health:SetInvincible(false)
            inst.DynamicShadow:Enable(true)
            DoWortoxPortalTint(inst, 0)
            if inst.sg.statemem.isphysicstoggle then
                ToggleOnPhysics(inst)
            end
        end,
    })
----------------------------------------------------------------------------------------------------------------------------------------------------------------