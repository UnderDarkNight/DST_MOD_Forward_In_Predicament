require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/attackwall"
require "behaviours/minperiod"
require "behaviours/leash"
require "behaviours/faceentity"
require "behaviours/doaction"
require "behaviours/standstill"
local BrainCommon = require("brains/braincommon")

local HoundBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
    --self.reanimatetime = nil
end)

local SEE_DIST = 30

local MIN_FOLLOW_LEADER = 2
local MAX_FOLLOW_LEADER = 6
local TARGET_FOLLOW_LEADER = (MAX_FOLLOW_LEADER + MIN_FOLLOW_LEADER) / 2

local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 40

local HOUSE_MAX_DIST = 40
local HOUSE_RETURN_DIST = 50

local SIT_BOY_DIST = 10

local function EatFoodAction(inst)
	if inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("wantstoeat") then
		return
	end
    local target = FindEntity(inst, SEE_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnPassablePoint(true) end)
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
end

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

local function GetHome(inst)
    return inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
end

local function GetHomePos(inst)
    local home = GetHome(inst)
    return home ~= nil and home:GetPosition() or nil
end

local function GetNoLeaderLeashPos(inst)
    return GetLeader(inst) == nil and GetHomePos(inst) or nil
end

local function GetWanderPoint(inst)
    local target = GetLeader(inst) or inst:GetNearestPlayer(true)
    return target ~= nil and target:GetPosition() or nil
end

local function ShouldStandStill(inst)
    return inst:HasTag("pet_hound") and not TheWorld.state.isday and not GetLeader(inst) and not inst.components.combat:HasTarget() and inst:IsNear(GetHome(inst), SIT_BOY_DIST)
end



--------------------------------------------------------------------------

local CARCASS_TAGS = { "meat_carcass" }
local CARCASS_NO_TAGS = { "fire" }
function HoundBrain:SelectCarcass()
	self.carcass = FindEntity(self.inst, SEE_DIST, nil, CARCASS_TAGS, CARCASS_NO_TAGS)
	return self.carcass ~= nil
end

function HoundBrain:CheckCarcass()
	return not (self.carcass.components.burnable ~= nil and self.carcass.components.burnable:IsBurning())
		and self.carcass:IsValid()
		and self.carcass:HasTag("meat_carcass")
end

function HoundBrain:GetCarcassPos()
	return self:CheckCarcass() and self.carcass:GetPosition() or nil
end

--------------------------------------------------------------------------
function HoundBrain:Can_Eat_Food()
    local x,y,z = self.inst.Transform:GetWorldPosition()
    local forgs = TheSim:FindEntities(x, y, z, 30, {"frog"}, nil, nil)
    for k, temp_frog in pairs(forgs) do
        if temp_frog and temp_frog:IsValid() and temp_frog.components.combat:HasTarget() then
            self.inst.components.combat:SuggestTarget(temp_frog.components.combat.target)
            return false
        end
    end

    -- 
    local player = self.inst:GetNearestPlayer(true)
    if player and self.inst:GetDistanceSqToInst(player) < 30*30 then
        self.inst.components.combat:SuggestTarget(player)
        return false
    end

    return true
end
--------------------------------------------------------------------------

function HoundBrain:OnStart()
	local root

		local ismutated = self.inst:HasTag("lunar_aligned")
		root = PriorityNode(
        {
            WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "NotJumpingBehaviour",
                PriorityNode({
					BrainCommon.PanicTrigger(self.inst),
                    WhileNode(function() return GetLeader(self.inst) == nil end, "NoLeader", AttackWall(self.inst)),

					--Eat carcass behaviour (for non-mutated hounds)
					WhileNode(
						function()
							return not ismutated and (
								not self.inst.components.combat:HasTarget() or
								self.inst.components.combat:GetLastAttackedTime() + TUNING.HOUND_FIND_CARCASS_DELAY < GetTime()
							)
						end,
						"not attacked",
						IfNode(function() return self:SelectCarcass() end, "eat carcass",
							PriorityNode({
								FailIfSuccessDecorator(
									Leash(self.inst,
										function() return self:GetCarcassPos() end,
										function() return self.inst.components.combat:GetHitRange() + self.carcass:GetPhysicsRadius(0) - 0.5 end,
										function() return self.inst.components.combat:GetHitRange() + self.carcass:GetPhysicsRadius(0) - 1 end,
										true)),
								IfNode(function() return self:CheckCarcass() and not self.inst.components.combat:InCooldown() end, "chomp",
									ActionNode(function() self.inst.sg:HandleEvent("chomp", { target = self.carcass }) end)),
								FaceEntity(self.inst,
									function() return self.carcass end,
									function() return self:CheckCarcass() end),
							}, .25))),
					--

                    WhileNode(function() return not self.inst:HasTag("pet_hound") and GetHome(self.inst) ~= nil end, "No Pet Has Home", ChaseAndAttack(self.inst, 10, 20)),
                    WhileNode(function() return not self.inst:HasTag("pet_hound") and GetHome(self.inst) == nil end, "Not Pet", ChaseAndAttack(self.inst, 100)),

                    Leash(self.inst, GetNoLeaderLeashPos, HOUSE_MAX_DIST, HOUSE_RETURN_DIST),

					IfNode(function() return self:Can_Eat_Food() end, "non-mutated hound eat food",
						DoAction(self.inst, EatFoodAction, "eat food", true)),
                    Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
                    FaceEntity(self.inst, GetLeader, GetLeader),

                    -- StandStill(self.inst, ShouldStandStill),

                    WhileNode(function() return GetHome(self.inst) end, "HasHome", Wander(self.inst, GetHomePos, 8)),
                    Wander(self.inst, GetWanderPoint, 20),
                }, .25)
            ),
        }, .25 )
	

    self.bt = BT(self.inst, root)
end

return HoundBrain
