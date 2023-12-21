local trace = function() end

local assets=
{
	Asset("ANIM", "anim/snake_build.zip"),
	Asset("ANIM", "anim/snake_basic.zip"),
}

local prefabs =
{
	
}

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = {"FX", "NOCLICK","DECOR","INLIMBO"}

local function ShouldWakeUp(inst)
	return not TheWorld.state.iscaveday
           or (inst.components.combat and inst.components.combat.target)
           or (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           or (inst.components.burnable and inst.components.burnable:IsBurning() )
           or (inst.components.follower and inst.components.follower.leader)
end

local function ShouldSleep(inst)
	return TheWorld.state.iscaveday
           and not (inst.components.combat and inst.components.combat.target)
           and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           and not (inst.components.burnable and inst.components.burnable:IsBurning() )
           and not (inst.components.follower and inst.components.follower.leader)
end

local function OnNewTarget(inst, data)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end


local function retargetfn(inst)
	local dist = TUNING.SPIDER_TARGET_DIST
	local notags = {"FX", "NOCLICK","INLIMBO", "wall", "snake", "structure"}
	return FindEntity(inst, dist, function(guy)
		return  inst.components.combat:CanTarget(guy)
	end, nil, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (TUNING.SPIDER_TARGET_DIST*TUNING.SPIDER_TARGET_DIST*4*4) and not target:HasTag("aquatic")
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(
		data.attacker,
		SHARE_TARGET_DIST,
		function(dude)
			return dude:HasTag("snake") and not dude.components.health:IsDead()
		end,
		5
	)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(
		data.target,
		SHARE_TARGET_DIST,
		function(dude)
			return dude:HasTag("snake") and not dude.components.health:IsDead()
		end,
		5
	)
end

local function DoReturn(inst)
	--print("DoReturn", inst)
	if inst.components.homeseeker and inst.components.homeseeker:HasHome()  then
		inst.components.homeseeker.home.components.spawner:GoHome(inst)
	end
end

local function OnDay(inst)
	--print("OnNight", inst)
	if inst:IsAsleep() then
		DoReturn(inst)
	end
end


local function OnEntitySleep(inst)
	--print("OnEntitySleep", inst)
	if TheWorld.state.iscaveday then
		DoReturn(inst)
	end
end

local function SanityAura(inst, observer)  --- 掉San 光环
    -- if observer.prefab == "webber" then
    --     return 0
    -- end
    return -TUNING.SANITYAURA_SMALL
end
-----------------------------------------------------------------------------
--- 独有机制
    local function unique_mechanics_setup(inst)
		
		------ 世界死够 50 条后 变异
			inst:ListenForEvent("minhealth",function()
					local num = TheWorld.components.fwd_in_pdt_data:Add("fwd_in_pdt_animal_snake.death",1)
					if num >= ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 5 or 50 )  then
						TheWorld.components.fwd_in_pdt_data:Set("fwd_in_pdt_animal_snake.death",0)
						local x,y,z = inst.Transform:GetWorldPosition()
						inst:Remove()
						SpawnPrefab("fwd_in_pdt_fx_explode"):PushEvent("Set",{
							pt = Vector3(x,y,z),
							scale = 1.5,
							color = Vector3(139/255,69/255,20/255),
							MultColour_Flag = true,
						})
						SpawnPrefab("fwd_in_pdt_animal_snake_hound").Transform:SetPosition(x, y, z)

					end
			end)
    end
-----------------------------------------------------------------------------

local function fn()
	local inst = CreateEntity()


	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddPhysics()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	inst.Transform:SetFourFaced()

	inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("snake")
	inst:AddTag("canbetrapped")	

	MakeCharacterPhysics(inst, 10, .5)

	inst.AnimState:SetBank("snake")
	inst.AnimState:SetBuild("snake_build")
	inst.AnimState:PlayAnimation("idle")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("knownlocations")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = 3
	inst:SetStateGraph("01_fwd_in_pdt_SGsnake")

	local brain = require "brains/01_fwd_in_pdt_snakebrain"
	inst:SetBrain(brain)

	inst:AddComponent("follower")

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
	inst.components.eater:SetCanEatHorrible()

	inst.components.eater.strongstomach = true -- can eat monster meat!

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(220)
	--inst.components.health.poison_damage_scale = 0 -- immune to poison


	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(10)
	inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRetargetFunction(3, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/snake/hurt")
	inst.components.combat:SetRange(2,3)

	inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot("monstermeat", 0.5)
    inst.components.lootdropper:AddChanceLoot("fwd_in_pdt_material_snake_skin", 0.5)

	inst.components.lootdropper.numrandomloot = 0

	inst:AddComponent("inspectable")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = SanityAura

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetNocturnal(true)
	--inst.components.sleeper:SetResistance(1)
	-- inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
	-- inst.components.sleeper:SetSleepTest(ShouldSleep)
	-- inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	inst:ListenForEvent("newcombattarget", OnNewTarget)

	inst.OnEntitySleep = OnEntitySleep

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

    unique_mechanics_setup(inst)
	return inst
end

local function commonfn()
	local inst = fn()

    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY

	return inst
end


return Prefab("fwd_in_pdt_animal_snake", commonfn, assets, prefabs)