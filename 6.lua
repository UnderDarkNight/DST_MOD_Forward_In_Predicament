


local player = UserToPlayer('OU_XXXXXXXXXXXXX')
if player == nil then
    UserToPlayer('OU_XXXXXXXXXXXXX').components.talker:Say('该玩家与你不在同一世界！命令无法生效。')
end
local function onturnon(inst)
    if inst._stage == 3 then
        if
            inst.AnimState:IsCurrentAnimation('proximity_pre') or inst.AnimState:IsCurrentAnimation('proximity_loop') or
                inst.AnimState:IsCurrentAnimation('place3')
         then
            inst.AnimState:PushAnimation('proximity_pre')
        else
            inst.AnimState:PlayAnimation('proximity_pre')
        end
        inst.AnimState:PushAnimation('proximity_loop', true)
    end
end
local function onturnoff(inst)
    if inst._stage == 3 then
        inst.AnimState:PlayAnimation('proximity_pst')
        inst.AnimState:PushAnimation('idle3', false)
    end
end
if player ~= nil and player.Transform then
    if 'log' == 'klaus' then
        local pos = player:GetPosition()
        local minplayers = math.huge
        local spawnx, spawnz
        FindWalkableOffset(
            pos,
            math.random() * 2 * PI,
            33,
            16,
            true,
            true,
            function(pt)
                local count = #FindPlayersInRangeSq(pt.x, pt.y, pt.z, 625)
                if count < minplayers then
                    minplayers = count
                    spawnx, spawnz = pt.x, pt.z
                    return count <= 0
                end
                return false
            end
        )
        if spawnx == nil then
            local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 3, 8, false, true)
            if offset ~= nil then
                spawnx, spawnz = pos.x + offset.x, pos.z + offset.z
            end
        end
        local klaus = SpawnPrefab('klaus')
        klaus.Transform:SetPosition(spawnx or pos.x, 0, spawnz or pos.z)
        klaus:SpawnDeer()
        klaus.components.knownlocations:RememberLocation('spawnpoint', pos, false)
        klaus.components.spawnfader:FadeIn()
    else
        local x, y, z = player.Transform:GetWorldPosition()
        for i = 1, 1 or 1 do
            local inst = SpawnPrefab('log', 'log', nil, 'OU_XXXXXXXXXXXXX')
            if inst ~= nil and inst.components then
                if inst.components.skinner ~= nil and IsRestrictedCharacter(inst.prefab) then
                    inst.components.skinner:SetSkinMode('normal_skin')
                end
                if inst.components.inventoryitem ~= nil then
                    if player.components and player.components.inventory then
                        player.components.inventory:GiveItem(inst)
                    end
                else
                    inst.Transform:SetPosition(x, y, z)
                    if 'log' == 'deciduoustree' then
                        inst:StartMonster(true)
                    end
                end
                if not inst.components.health then
                    if inst.components.perishable then
                        inst.components.perishable:SetPercent(1)
                    end
                    if inst.components.finiteuses then
                        inst.components.finiteuses:SetPercent(1)
                    end
                    if inst.components.fueled then
                        inst.components.fueled:SetPercent(1)
                    end
                    if inst.components.temperature then
                        inst.components.temperature:SetTemperature(25)
                    end
                    if 1 ~= 1 and inst.components.follower then
                        inst.components.follower:SetLeader(player)
                    end
                    if 'log' == 'moon_altar' then
                        inst._stage = 3
                        inst.AnimState:PlayAnimation('idle3')
                        inst:AddComponent('prototyper')
                        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.MOON_ALTAR_FULL
                        inst.components.prototyper.onturnon = onturnon
                        inst.components.prototyper.onturnoff = onturnoff
                        inst.components.lootdropper:SetLoot({'moon_altar_idol', 'moon_altar_glass', 'moon_altar_seed'})
                    end
                end
            end
        end
    end
end
