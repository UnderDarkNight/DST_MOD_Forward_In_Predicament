loot.components.perishable = nil
doer.components.inventory:GiveItem(theBird)
inst.components.inventory:GiveItem(SpawnPrefab(item_name))

TheNet:GetClientTableForUser(user.userid) ---检查玩家是否是服务器管理员

v:IsValid()

local build = GetBuildForItem(item_key)

ShakeAllCameras(CAMERASHAKE.FULL, 1, 0.5, 0.1, inst, 30)
doer:ShakeCamera(CAMERASHAKE.FULL, 0.7, 0.1, .75)

local player = GLOBAL.UserToPlayer(userid)
AddComponentPostInit("trader", function(Trader)    end) ---- 修改已有组件

inst:GetDistanceSqToInst(inst)
inst:IsNear(otherinst, dist)
inst:GetDistanceSqToPoint(x, y, z)
inst:IsNearPlayer(range, isalive)
inst:GetNearestPlayer(isalive)
inst:GetDistanceSqToClosestPlayer(isalive)
inst:FaceAwayFromPoint(dest, force)

--设置怪物大小
local currentscale = mob.Transform:GetScale() *2.5
mob.Transform:SetScale(currentscale,currentscale,currentscale)	

inst.AnimState:SetScale(0.5,0.5,0.5) --  -- 只缩放动画

inst:FacePoint(target.Transform:GetWorldPosition())
inst:ForceFacePoint(spike.Transform:GetWorldPosition())
inst:FaceAwayFromPoint(dest_point, force_flag)

theMonster:AddComponent("debuffable")
theMonster:RemoveComponent("debuffable")
AddClassPostConstruct("components/builder_replica", function(self) end)
AddComponentPostInit("heavyobstaclephysics", function(self) end)

NPC.components.debuffable:AddDebuff(NPC_ACION_DEBUFF, NPC_ACION_DEBUFF)
NPC.components.debuffable:RemoveDebuff(NPC_ACION_DEBUFF)
NPC:AddDebuff(NPC_ACION_DEBUFF, NPC_ACION_DEBUFF)
NPC:HasDebuff(DEBUFFNAME)
NPC:RemoveDebuff(DEBUFFNAME)

inst:HasTags(tags)
inst:HasOneOfTags(tags)

theMonster:SetBrain(nil)
theMonster:RestartBrain()
theMonster:StopBrain()


inst:OnUsedAsItem(action, doer, target)
inst:IsOnPassablePoint(include_water, floating_platforms_are_not_passable)
inst:IsOnOcean(allow_boats)

targetButterfly.Transform:GetWorldPosition()
targetButterfly.Transform:SetPosition(x,y,z)
SpawnPoint = Vector3(0,0,0)
inst:GetPosition()  -- Vector3 return
local distance = inst:GetDistanceSqToInst(v)

local task = theNPC:DoTaskInTime(400, function() theNPC.TaskNum = 5 end)
task:Cancel()
inst:DoPeriodicTask(0.5, UpdateGroundAnimation, math.random()*0.5)


inst.sg:HasStateTag("gnawing")
theNPC.sg:PushEvent("powerup")
inst.sg:GoToState()

inst:StopBrain()
shark:SetBrain(nil)
------------------------------------------------------------------
inst:AddComponent("activatable")    
inst.components.activatable.OnActivate = OnInvestigated --function when used

local function Attacked_Event(inst,_theTable) 
end
inst:ListenForEvent("AAAAAA", Attacked_Event)
inst:PushEvent("AAAAAA",{A = "66",B ="77"})
inst:RemoveEventCallback("chatterdirty", OnChatterDirty)


inst.SoundEmitter:OverrideVolumeMultiplier(0)
-- kill inst all sounds

FX:ListenForEvent("animqueueover",FX.Remove)
FX:ListenForEvent("animoever",FX.Remove)

DebugSpawn("critterlab")  -- 宠物小窝

theNPC:AddTag("INLIMBO") --- 无法被选中

temp_player:HasTag("playerghost") 
--------------------------------------------------
inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("icepack") end
--------------------------------------------------
-- -- 特效
SpawnPrefab("shadow_bishop_fx").Transform:SetPosition(theplayer.Transform:GetWorldPosition())           -- 暗影羽毛
SpawnPrefab("crab_king_waterspout").Transform:SetPosition(theplayer.Transform:GetWorldPosition())       -- 水花爆炸
SpawnPrefab("splash").Transform:SetPosition(theplayer.Transform:GetWorldPosition())                     -- 小碎片
SpawnPrefab("lightning").Transform:SetPosition(theplayer.Transform:GetWorldPosition())
SpawnPrefab("sanity_raise").Transform:SetPosition(v.Transform:GetWorldPosition())  -- down
SpawnPrefab("sanity_lower").Transform:SetPosition(v.Transform:GetWorldPosition())   -- up
SpawnPrefab('collapse_big').Transform:SetPosition(theplayer.Transform:GetWorldPosition())  --- 烟雾
SpawnPrefab('collapse_small').Transform:SetPosition(theplayer.Transform:GetWorldPosition())  --- 烟雾
SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)

local S = Class(function(self)
    self.events = {}

    local function Test()
        ThePlayer:DoTaskInTime(1,function()
            local x,y,z = ThePlayer.Transform:GetWorldPosition()
            local testInst = SpawnPrefab("eyeofterror")
            testInst.Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
            testInst:StopBrain() 
             testInst.sg:GoToState("arrive")  -- 眼球从天空出现代码 
         --    testInst.sg:GoToState("flyaway")     -- 飞走
         end)

        ThePlayer:DoTaskInTime(1,function()
            local x,y,z = ThePlayer.Transform:GetWorldPosition()
            local testInst = SpawnPrefab("eyeofterror")
            testInst.Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
            testInst:StopBrain()
            testInst.AnimState:PlayAnimation("arrive")
            testInst:DoTaskInTime(3,function()
                testInst:Remove()
            end)
        end)
        
        ThePlayer:DoTaskInTime(1,function()
            local x,y,z = ThePlayer.Transform:GetWorldPosition()
            local testInst = SpawnPrefab("eyeofterror")
            testInst.Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
            testInst:StopBrain()
            testInst.sg:GoToState("transform")
            testInst:DoTaskInTime(3,function()
                testInst:Remove()
            end)
        end)


        for k, v in pairs(AllPlayers) do
            local ThePlayer = v
            ThePlayer:DoTaskInTime(1,function()
                local x,y,z = ThePlayer.Transform:GetWorldPosition()
                local testInst = SpawnPrefab("eyeofterror_monsterbackpack")
                testInst.Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
                testInst.AnimState:PlayAnimation("arrive")
            end)
        end

        for k, doer in pairs(AllPlayers) do
            doer.NPC_BASE_LIB:CreateNpcNearby2({doer = doer,time = 450, NPC_NAME="carnival_host_npc",debuffname = "npcdebuff_shadowcrow" ,SpawnPoint = Vector3(0,40,0)})
        end


        ThePlayer:DoTaskInTime(0,function()
            local x,y,z = ThePlayer.Transform:GetWorldPosition()
            local testInst = SpawnPrefab("treasure_map_npc_item")
            testInst.Transform:SetPosition(x,10,z)
        end)



    end

end)
local S9 = {

--[[
    critters.lua  -- 小动物 ？


    SpawnPrefab  泰瑞亚新增物品
    shieldofterror -- 盾牌
    eyemask -- 眼睛面具帽子
    eyeofterror.lua         -- 眼球BOSS
    terrarium -- 一个可以拾取放置启动的东西，不知道什么用 -- 挺好看的
    chesspieces.lua  -- 雕塑
    eyeofterror_mini -- 小眼球怪
    eyeofterror_mini_projectile  -- 滚动的小眼球怪（动画，无物理碰撞）
    eyeofterror_mini_grounded -- 小眼球怪的蛋，有实体可攻击，但是不会变成怪物
    eyeofterror_arrive_fx -- 天空出现闪光动画 --但是没有眼睛出现  -有色彩变色代码
    eyeofterror_sinkhole -- 地上减速的洞（类似于蚁狮）
    critter_eyeofterror -- 友好的小眼球，可能是宠物

]]--
}
--------------------------------------------------

v.components.combat:DropTarget()

-- ms_playerjoined event -- this gets triggered in player_common, as the prefab is being made, which means it only occurs after the player has selected a character. The client table changes earlier, when they first reach character select.
-- ms_playerspawn event -- similar, just gets pushed a little sooner (ms_playerjoined is put into a DoTaskInTime, although that line is called sooner)
-- ms_newplayercharacterspawned event -- gets triggered after someone picks a character. Unfortunately, the client table changes before that.
-- playeractivated event -- pushed during the spawning of the player, so still too late. For other applications, this is useful because it's pushed after the HUD has been attached to the player.
-- entercharacterselect event -- pushed locally instead of on the server, and still ends up being later than the client table gets updated.
-- ms_playerleft event -- this seems to work well enough for players leaving changing the client table, but it still leaves open how to handle it as they join
inst:ListenForEvent("AAAAAA", Attacked_Event)


local function SetUnderPhysics(inst)
    if inst.isunder ~= true then
        inst.isunder = true
		inst:AddTag("notdrawable")
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        -----------------------------------------------------------
        -- CheckGridOffset
        -- ClearCollidesWith
        -- ClearCollisionMask
        -- ClearLocalCollisionMask
        -- ClearMotorVelOverride
        -- ClearTransformationHistory
        -- CollidesWith
        -- ConstrainTo
        -- GeoProbe
        -- GetCollisionGroup
        -- GetCollisionMask
        -- GetHeight
        -- GetMass
        -- GetMotorSpeed
        -- GetMotorVel
        -- GetRadius
        -- GetVelocity
        -- IsActive
        -- IsPassable
        -- SetActive
        -- SetCapsule
        -- SetCollides
        -- SetCollisionCallback
        -- SetCollisionGroup
        -- SetCollisionMask
        -- SetCylinder
        -- SetDamping
        -- SetDontRemoveOnSleep
        -- SetFriction
        -- SetLocalCollisionMask
        -- SetMass
        -- SetMotorVel
        -- SetMotorVelOverride
        -- SetRestitution
        -- SetRigidBodyEnabled
        -- SetSphere
        -- SetTriangleMesh
        -- SetVel
        -- Stop
        -- TEMPHACK_DisableSleepDeactivation
        -- Teleport
        -- TeleportRespectingInterpolation
        -----------------------------------------------------------
        MakeInventoryPhysics(shark)
        shark.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        shark.Physics:ClearCollisionMask()
        shark.Physics:CollidesWith(COLLISION.WORLD)
        shark.Physics:CollidesWith(COLLISION.OBSTACLES)
        ----------------------------------------------------------------
    end
end



TheSim:FindFirstEntityWithTag(map_id) 

local canthavetags = { "companion","isdead","player","INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" ,"chester","hutch","wall","structure"}
local musthavetags = nil
local musthaveoneoftags = {"pig","rabbit","animal","smallcreature","epic","monster","insect"}
local ents = TheSim:FindEntities(x, 0, z, 3, musthavetags, canthavetags, musthaveoneoftags)


local ents = TheSim:FindEntities(x, y, z, Range,nil,{"wall","structure"},nil)
local ents = TheSim:FindEntities(x, 0, z, radius, nil, NON_COLLAPSIBLE_TAGS, COLLAPSIBLE_TAGS)
local ents = TheSim:FindEntities(x, 0, z, 8, musthavetags, canthavetags, musthaveoneoftags)
local num            = TheSim:CountEntities(x, y, z, CONFFETI_PARTY_DIST, COUNT_PARTYGOERS_TAGS)

local x,y,z = ThePlayer.Transform:GetWorldPosition()
local testInst = SpawnPrefab("treasure_map_npc_item")
testInst.Transform:SetPosition(x,10,z)

for i, v in ipairs(ents) do
    DestroyEntity(v, inst)
end

---------------------------------
SpawnPrefab("pocketwatch_portal_entrance")  -- 时间裂隙 -- 类似虫洞 -- 固定存在时间
SpawnPrefab("pocketwatch_recall")           -- 物品  -- 溯源表
-- SpawnPrefab("pocketwatch_portal_exit")  -- 没用
SpawnPrefab("pocketwatch_portal_entrance_overlay")  -- 特效，类似时间裂隙 - 可以站上去，无物理碰撞
-- SpawnPrefab("pocketwatch_portal_entrance_underlay")  -- 没用
SpawnPrefab("pocketwatch_weapon_fx")  -- 有BUG，owner == nil 崩溃
SpawnPrefab("pocketwatch_heal_fx_mount") -- 闪光特效，在空中
SpawnPrefab("pocketwatch_heal_fx") -- 闪光特效，在地面高一点

SpawnPrefab("pocketwatch_revive_reviver") -- 没任何反应
SpawnPrefab("brokentool")  -- 特效，物品崩坏
SpawnPrefab("pocketwatch_portal")  -- 可拾取物品 -- 裂缝表
SpawnPrefab("pocketwatch_recall_marker")  -- -------------------------------- 地面上的时钟特效！！！
---------------------------------


doer:Hide()
doer.DynamicShadow:SetSize(0, 0)
doer:DoTaskInTime(10,function() doer:Show() doer.DynamicShadow:SetSize(1.3, .6) end)



doer.components.playercontroller:DoControllerInspectItemFromInvTile(retFood)  -- 检查物品并让角色说出功能

v.components.combat.target = nil
v.components.follower:SetLeader(self.inst)
v.components.follower:KeepLeaderOnAttacked()
v.components.follower.keepdeadleader = true



inst.AnimState:SetAddColour(0, 0, 0, 0)
v.AnimState:SetMultColour(0, 0, 0, .5)
inst.components.colouradder:PushColour("freezable", r, g, b, a)


local newplayer = FindClosestPlayerInRange(x, y, z, TUNING.ANTLION_CAST_RANGE, true)

TheWorld.Map:IsOceanAtPoint(x, 0, z)
local ocean = GLOBAL.FindNearbyOcean(pt, 20)
TheWorld.Map:IsPointNearHole(Vector3(x, 0, z))
-- TheWorld.Map:IsAboveGroundAtPoint(spawnpoint:Get())
TheWorld.Map:IsAboveGroundAtPoint(x,y,z)
-- map point check API in map.lua


local testboat = GetClosestInstWithTag("boat", inst, 20)
if testboat and testboat:IsValid() then
	print("Test for Boat 1: ", Vector3(testboat.Transform:GetWorldPosition() ) )
	local boat_x, boat_y, boat_z = testboat.Transform:GetWorldPosition()
	print("Test for Boat X: ", boat_x)
	print("Test for Boat Y: ", boat_y)
	print("Test for Boat Z: ", boat_z)
	--return Vector3(testboat.Transform:GetWorldPosition() )  --Note: Causes some sort of looping error.
end

-- TheWorld.state.isday
-- TheWorld.state.isdusk
-- TheWorld.state.isnight


-- TheWorld.state.iscaveday
-- TheWorld.state.season == "summer"
-- TheWorld.state.season == "winter"  -- autumn , winter , spring , summer
-- TheWorld.state.isautumn
-- -- TheWorld.state.autumnlength
-- TheWorld.state.iswinter
-- TheWorld.state.isspring
-- TheWorld.state.issummer

-- TheWorld.state.israining
-- TheWorld.state.issnowing

-- TheWorld.state.timeinphase > .8
-- TheWorld.state.temperature <= -15
-- TheWorld.state.cycles
-- TheWorld.state.wetness
-- TheWorld.state.iswet
-- TheWorld.state.phase
-- TheWorld.state.nightmarephase
-- TheWorld.state.remainingdaysinseason <= 3
-- TheWorld.state.isnewmoon
-- TheWorld.state.isfullmoon
-- TheWorld.state.iswaxingmoon
-- TheWorld.state.moonphase ~= "new"
-- TheWorld.state.moonphase == "full"
-- TheWorld.state.iscavefullmoon
-- TheWorld.state.snowlevel
-- TheWorld.state.isalterawake
-- TheWorld.state.pop
-- TheWorld.state.precipitationrate
-- TheWorld.state.issnowcovered
-- local year =
--         TheWorld.state.autumnlength +
--         TheWorld.state.winterlength +
--         TheWorld.state.springlength +
--         TheWorld.state.summerlength
local function OnPhase(inst, phase)
    _isday = phase == "day"
    if phase == "dusk" then
    end
end
inst:SpawnChild(name)

inst:WatchWorldState("phase", OnPhaseChange)
self:WatchWorldState("cycles", OnCyclesChanged)
self:StopWatchingWorldState("cycles", OnCyclesChanged)
inst:WatchWorldState("israining", OnIsRaining)
inst:WatchWorldState("isnight", function() ToggleUpdate() end)
inst:WatchWorldState("isday", ToggleUpdate)
inst:WatchWorldState("iswinter", ToggleUpdate)
self:WatchWorldState("season", OnSeasonChange)
self:WatchWorldState("isautumn", QueueSummonHerd)
self:WatchWorldState("iswinter", QueueHerdMigration)
inst:WatchWorldState("phase", function(inst, phase) self:checktraineesleep(phase) end )

inst:WatchWorldState("startdusk", function()
    inst.components.talker:Say(GetString(inst, "ANNOUNCE_DUSK"))
end)
-- local function OnIsFullmoon(inst, TheWorld.state.isfullmoon)

-- end
inst:WatchWorldState("isfullmoon", OnIsFullmoon)
inst:WatchWorldState("stopsummer", OnStopSummer)
inst:WatchWorldState("stopwinter", OnStopWinter)
inst:WatchWorldState("iscavefullmoon", OnCaveFullMoon)
inst:WatchWorldState("stopday", OnStopDay)
inst:WatchWorldState("startday", replant)
inst:WatchWorldState("isalterawake", fns.OnAlterNight)
-- entityscript.lua


inst.AnimState:GetBuild()


inst._fx = SpawnPrefab("forcefieldfx")
inst._fx.entity:SetParent(owner.entity)
inst._fx.Transform:SetPosition(0, 0.2, 0)



inst.components.colouradder:OnSetColour(255,255,255,0.1)


doer:PushEvent("respawnfromghost", { source = self.inst })
ThePlayer:PushEvent("respawnfromghost", { source = ThePlayer })


local _x, _y = TheSim:GetScreenPos(self.target.AnimState:GetSymbolPosition(self.target_symbol[i], self.world_offset.x, self.world_offset.y, self.world_offset.z))



function player.NPC_BASE_LIB:GetSpawnPoint2(target, Distance)
    ----- target is NPC or Vectro3_point
    -- -- Create random refresh points
    local pt = nil
    if target.x == nil then
        pt = Vector3(target.Transform:GetWorldPosition())
    else
        pt = target
    end

    local theta = math.random() * 2 * PI
    -- local radius = math.random(20, 25)
    local radius = Distance

    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    if offset then
        return pt + offset
    else
        return nil
    end
end


item:HasTag("preparedfood") --- 烹饪出来的食物

---- 击退玩家
ThePlayer:PushEvent("knockback", {
    knocker = TheSim:FindFirstEntityWithTag("multiplayer_portal"),  --- 往远离该inst的方向击飞
    radius = 3,             --- 测试不出有啥用
    strengthmult = 2,       --- 击退力度
    forcelanded = false,    --- 软硬着陆，true 为不倒下着陆。
})