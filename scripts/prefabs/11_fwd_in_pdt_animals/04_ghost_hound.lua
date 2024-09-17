local assets =
{
    -- Asset("ANIM", "anim/hound_basic.zip"),
    -- Asset("ANIM", "anim/hound_basic_water.zip"),
    -- Asset("ANIM", "anim/hound_ocean.zip"),
    -- Asset("ANIM", "anim/hound_red_ocean.zip"),
    -- Asset("ANIM", "anim/hound_ice_ocean.zip"),
    -- Asset("ANIM", "anim/hound_mutated.zip"),
    -- Asset("ANIM", "anim/hound_hedge_ocean.zip"),
    -- Asset("ANIM", "anim/hound_hedge_action.zip"),
    -- Asset("ANIM", "anim/hound_hedge_action_water.zip"),
    -- Asset("SOUND", "sound/hound.fsb"),



    Asset("ANIM", "anim/fwd_in_pdt_animal_ghost_hound.zip"),

}


-- local brain = require("brains/houndbrain")
local brain = require("brains/04_fwd_in_pdt_ghost_hound_brain")

local sounds =
{
    pant = "dontstarve/creatures/hound/pant",
    attack = "dontstarve/creatures/hound/attack",
    bite = "dontstarve/creatures/hound/bite",
    bark = "dontstarve/creatures/hound/bark",
    death = "dontstarve/creatures/hound/death",
    sleep = "dontstarve/creatures/hound/sleep",
    growl = "dontstarve/creatures/hound/growl",
    howl = "dontstarve/creatures/together/clayhound/howl",
    hurt = "dontstarve/creatures/hound/hurt",
}




local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
local FREEZABLE_TAGS = { "freezable" }

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or (inst.components.follower and inst.components.follower.leader and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local function ShouldSleep(inst)
    return inst:HasTag("pet_hound")
        and not TheWorld.state.isday
        and not (inst.components.combat and inst.components.combat.target)
        and not (inst.components.burnable and inst.components.burnable:IsBurning())
        and (not inst.components.homeseeker or inst:IsNear(inst.components.homeseeker.home, SLEEP_NEAR_HOME_DISTANCE))
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_CANT_TAGS = { "merm" }
local LUNAR_RETARGET_CANT_TAGS = { "merm", "lunar_aligned" }
local function retargetfn(inst)
    if not inst.components.health:IsDead() and not (inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep()) then
        local target_dist = inst.islunar and TUNING.LUNARFROG_TARGET_DIST or TUNING.FROG_TARGET_DIST
        local cant_tags   = inst.islunar and LUNAR_RETARGET_CANT_TAGS or RETARGET_CANT_TAGS

        return FindEntity(inst, target_dist, function(guy)
            if not guy.components.health:IsDead() then
                return guy.components.inventory ~= nil
            end
        end,
        RETARGET_MUST_TAGS, -- see entityreplica.lua
        cant_tags
        )
    end
end

-- local function KeepTarget(inst, target)
--     if inst.sg:HasStateTag("statue") then
--         return false
--     end
--     local leader = inst.components.follower.leader
--     local playerleader = leader ~= nil and leader:HasTag("player")
--     local ispet = inst:HasTag("pet_hound")
--     return (leader == nil or
--             (ispet and not playerleader) or
--             inst:IsNear(leader, TUNING.HOUND_FOLLOWER_RETURN_DIST))
--         and inst.components.combat:CanTarget(target)
--         and (not (ispet or leader ~= nil) or
--             inst:IsNear(target, TUNING.HOUND_FOLLOWER_TARGET_KEEP))
-- end


local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("ghost") and not dude.components.health:IsDead() end, 5)
end

local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(data.target, 30,
    function(dude) 
        return dude:HasTag("ghost") and not dude.components.health:IsDead() 
    end,5)
end

local function GetReturnPos(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = 2
    local angle = math.random() * 2 * PI
    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function DoReturn(inst)
    --print("DoReturn", inst)
    if inst.components.homeseeker ~= nil and inst.components.homeseeker:HasHome() then
        if inst:HasTag("pet_hound") then
            if inst.components.homeseeker.home:IsAsleep() and not inst:IsNear(inst.components.homeseeker.home, HOME_TELEPORT_DIST) then
                inst.Physics:Teleport(GetReturnPos(inst.components.homeseeker.home))
            end
        elseif inst.components.homeseeker.home.components.childspawner ~= nil then
            inst.components.homeseeker.home.components.childspawner:GoHome(inst)
        end
    end
end

local function OnEntitySleep(inst)
    --print("OnEntitySleep", inst)
    if not TheWorld.state.isday then
        DoReturn(inst)
    end
end

local function OnStopDay(inst)
    --print("OnStopDay", inst)
    if inst:IsAsleep() then
        DoReturn(inst)
    end
end


local function OnSave(inst, data)
    -- data.ispet = inst:HasTag("pet_hound") or nil
    -- --print("OnSave", inst, data.ispet)
    -- data.hedgeitem = inst.hedgeitem
end

local function OnLoad(inst, data)
    -- --print("OnLoad", inst, data.ispet)
	-- if data ~= nil then
	-- 	if data.ispet then
	-- 		inst:AddTag("pet_hound")
	-- 		if inst.sg ~= nil then
	-- 			inst.sg:GoToState("idle")
	-- 		end
	-- 	end
	-- 	if data.hedgeitem then
	-- 		inst.hedgeitem = data.hedgeitem
	-- 	end
	-- end
end
-----------------------------------------------------------------------------
--- 独有机制
local function unique_mechanics_setup(inst)

    ---------------------------------------------------------------------------------------------
    ----- 被杀死的瞬间，有35%概率 裂变成4-8 只鬼魂
            inst:ListenForEvent("minhealth",function()  --- 被杀死的瞬间  裂变
                if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and math.random(1000)/1000 > 0.35 then
                    return
                end

                local x,y,z = inst.Transform:GetWorldPosition()
                -- inst:Remove()
                -- SpawnPrefab("fwd_in_pdt_fx_explode"):PushEvent("Set",{
                --     pt = Vector3(x,y,z),
                --     scale = 1.5,
                --     color = Vector3(139/255,69/255,20/255),
                --     MultColour_Flag = true,
                -- })
                local NearestPlayer = inst:GetNearestPlayer(true)

                local monster_num = math.random(4,8)
                for i = 1, monster_num, 1 do
                    local monster = SpawnPrefab("ghost")
                    monster.Transform:SetPosition(x, y, z)
                    if NearestPlayer then
                        monster.components.combat:SuggestTarget(NearestPlayer)
                    end
                end

            end)    
    ---------------------------------------------------------------------------------------------
    --- 打卡尔是 6 倍伤害
        inst.components.combat.customdamagemultfn = function(inst,target,...)
            if target and target:HasTag("fwd_in_pdt_carl") then
                return 6
            else
                return 1
            end
        end
    ---------------------------------------------------------------------------------------------
    -- 减伤
        -- if self.inst.components.damagetyperesist ~= nil then
        --     damagetypemult = damagetypemult * self.inst.components.damagetyperesist:GetResist(attacker, weapon)
        -- end
        inst:AddComponent("damagetyperesist")
        inst.components.damagetyperesist:AddResist("player",inst,0.2,"monster_dmg_down")

    ---------------------------------------------------------------------------------------------
    -- 刷灯光
        inst:SpawnChild("minerhatlight")
    ---------------------------------------------------------------------------------------------

end
-----------------------------------------------------------------------------

local function fncommon()
	

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetFourFaced()

    inst:AddTag("scarytoprey")
    inst:AddTag("scarytooceanprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("ghost")             --- 归类为鬼魂
    inst:AddTag("canbestartled")
    inst:AddTag("fwd_in_pdt_animal_ghost_hound")

    inst.AnimState:SetBank("hound")
    inst.AnimState:SetBuild("fwd_in_pdt_animal_ghost_hound")
    inst.AnimState:PlayAnimation("idle")

	inst.AnimState:OverrideSymbol("shadow_ripple", "hound_ocean", "shadow_ripple")
    inst.AnimState:OverrideSymbol("water_ripple", "hound_ocean", "water_ripple")

    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end



	inst.sounds = sounds

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.HOUND_SPEED

    inst:SetStateGraph("SGhound")

    -------------------------------------------------------------------------------------------
    ---- 两栖行动
            inst:AddComponent("embarker")
            inst.components.embarker.embark_speed = inst.components.locomotor.runspeed
            inst.components.embarker.antic = true

            inst.components.locomotor:SetAllowPlatformHopping(true)

            inst:AddComponent("amphibiouscreature")
            inst.components.amphibiouscreature:SetBanks("hound", "hound_water")
            inst.components.amphibiouscreature:SetEnterWaterFn(
                function(inst)
                    inst.landspeed = inst.components.locomotor.runspeed
                    inst.components.locomotor.runspeed = TUNING.HOUND_SWIM_SPEED
                    inst.hop_distance = inst.components.locomotor.hop_distance
                    inst.components.locomotor.hop_distance = 4

                end)
            inst.components.amphibiouscreature:SetExitWaterFn(
                function(inst)
                    if inst.landspeed then
                        inst.components.locomotor.runspeed = inst.landspeed
                    end
                    if inst.hop_distance then
                        inst.components.locomotor.hop_distance = inst.hop_distance
                    end
                end)

            inst.components.locomotor.pathcaps = { allowocean = true }
    -------------------------------------------------------------------------------------------
	

    inst:SetBrain(brain)

    inst:AddComponent("follower")
	-- inst.components.follower.OnChangedLeader = OnChangedLeader

    inst:AddComponent("entitytracker")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(2000)  -- TUNING.HOUND_HEALTH

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(40)  -- TUNING.HOUND_DAMAGE
    inst.components.combat:SetAttackPeriod(TUNING.HOUND_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    -- inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetHurtSound(inst.sounds.hurt)
	inst.components.combat.lastwasattackedtime = -math.huge --for brain

    inst:AddComponent("lootdropper")
    
    inst.components.lootdropper:AddChanceLoot("fishmeat", 1)
    inst.components.lootdropper:AddChanceLoot("messagebottleempty", 1)
    inst.components.lootdropper:AddChanceLoot("ancienttree_seed", 1)




    inst:AddComponent("inspectable")



    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetStrongStomach(true) -- can eat monster meat!

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

    -- MakeHauntablePanic(inst)

    inst:WatchWorldState("stopday", OnStopDay)
    inst.OnEntitySleep = OnEntitySleep

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)

    MakeMediumFreezableCharacter(inst, "hound_body")
    -- MakeMediumBurnableCharacter(inst, "hound_body")

    unique_mechanics_setup(inst)
    return inst
end



return Prefab("fwd_in_pdt_animal_ghost_hound", fncommon, assets)
