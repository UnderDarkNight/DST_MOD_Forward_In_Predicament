------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 通用、常用的基础 api 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function main_com(self)
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 物品获取相关
        function self:Throw_Out_Items(CMD_TABLE)
            -- local _cmd_table = {
            --     target = Vector3() or Inst , or nil
            --     name = "log",
            --     num = 1,    -- default
            --     range = 8, -- default
            --     height = 3,-- default
            --     random_height = nil
            --     fn = function(item)
            -- }

            if CMD_TABLE == nil then
                return
            end

            local thePoint = nil
            if  CMD_TABLE.target == nil then
                thePoint = Vector3( self.inst.Transform:GetWorldPosition() )
            elseif CMD_TABLE.target.x then
                thePoint = CMD_TABLE.target
            elseif CMD_TABLE.target.prefab then
                thePoint = Vector3( CMD_TABLE.target.Transform:GetWorldPosition() )
            else
                return
            end

            local range = CMD_TABLE.range or 8
            local num = CMD_TABLE.num or 1
            local height = CMD_TABLE.height or 3
            local name = CMD_TABLE.name or "log"
            local random_height = CMD_TABLE.random_height or false



            local function SpawnItem(thePoint,ItemName,Range,throwHight)

                local theItem = SpawnPrefab(ItemName)
                if theItem == nil then
                    return
                end

                local pt = thePoint + Vector3(0,2,0)
                theItem.Transform:SetPosition(pt:Get())
                -- local down = TheCamera:GetDownVec()
                -- local angle = math.atan2(down.z, down.x) + (math.random()*60)*DEGREES
                local angle = math.random(2*PI*100)/100
                local sp = math.random(Range)
                -- theItem.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
                -- SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
                theItem.Physics:SetVel(sp*math.cos(angle), throwHight, sp*math.sin(angle))
                return theItem
            end


            local theSpawnItemsList ={}
            for i = 1, num, 1 do
                if random_height == true then
                    local tempItem = SpawnItem(thePoint,name,range,math.random(height))
                    if CMD_TABLE.fn then CMD_TABLE.fn(tempItem) end
                    table.insert(theSpawnItemsList,tempItem)
                else                    
                    local tempItem = SpawnItem(thePoint,name,range,height)
                    if CMD_TABLE.fn then CMD_TABLE.fn(tempItem) end
                    table.insert(theSpawnItemsList,tempItem)
                end
                -- table.insert(theSpawnItemsList,tempItem)
            end
            return theSpawnItemsList
        
        end
        function self:GiveItemByName(name,num)
            if type(name) ~= "string" or type(num) ~= "number" or num == 0 then
                return
            end

            local container = self.inst.components.inventory
            if container == nil then
                container = self.inst.components.container
            end

            if container == nil then
                return
            end

            if num == 1 then    ----------------------------------------- 单个物品，尝试给物品套上皮肤
                local item = SpawnPrefab(name)
                self:Change_Item_Skin(item)   
                container:GiveItem(item)
            else    ----------------------------------------------------- 多个物品，为了避免卡顿，测试能否叠加
                local stack_test_item = SpawnPrefab(name)
                if stack_test_item == nil then
                    return
                end
                if stack_test_item.components.stackable == nil then
                    for i = 1, num, 1 do
                        container:GiveItem(SpawnPrefab(name) or SpawnPrefab("log"))
                    end
                else
                    local max_size = stack_test_item.components.stackable.maxsize   -- 获取叠堆数量
                    local Rest_num = num % max_size                                 -- 不够整组的数量
                    local Group_num = math.ceil(  (num - Rest_num)/max_size   )     -- 组数
                    if Group_num > 0 then
                        for i = 1, Group_num, 1 do
                            local ret_item = SpawnPrefab(name)
                            ret_item.components.stackable.stacksize = ret_item.components.stackable.maxsize
                            container:GiveItem(ret_item)
                        end
                    end

                    if Rest_num > 0 then
                        local res_item = SpawnPrefab(name)
                        res_item.components.stackable.stacksize = Rest_num
                        container:GiveItem(res_item)
                    end
                end

                stack_test_item:Remove()
            end

        end

        function self:Get_Item_Stack_Max_Num(name)
            local flg,ret = pcall(function()
                                    local item = SpawnPrefab(name)
                                    if item.components.stackable == nil then
                                        item:Remove()
                                        return 1
                                    end

                                    local num = item.components.stackable.maxsize
                                    item:Remove()
                                    return num
                                end)
            if flg then
                return ret
            else
                return 1
            end
        end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end
local function replica(self)
    
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function normal_api(self)
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        --- 坐标、距离相关
            function self:Distance_Points(PointA,PointB)
                return ((PointA.x - PointB.x) ^ 2 + (PointA.z - PointB.z) ^ 2) ^ (0.5)
            end
    
            function self:Distance_Targets(tar1,tar2)
                return self:Distance_Points(Vector3(tar1.Transform:GetWorldPosition()), Vector3(tar2.Transform:GetWorldPosition()))
            end
    
            function self:Dsitance_T2P(tar,point)
                return self:Distance_Points(Vector3(tar.Transform:GetWorldPosition()),point)
            end
    
            function self:GetSpawnPoint(target, Distance)
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
    
            function self:GetRandomPoint(caster, teleportee, target_in_ocean)
                local function getrandomposition(caster, teleportee, target_in_ocean)
                    if teleportee == nil then
                        teleportee = caster
                    end
            
                    if target_in_ocean then
                        local pt = TheWorld.Map:FindRandomPointInOcean(20)
                        if pt ~= nil then
                            return pt
                        end
                        local from_pt = teleportee:GetPosition()
                        local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16)
                                        or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16)
                                        or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16)
                                        or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
                        if offset ~= nil then
                            return from_pt + offset
                        end
                        return teleportee:GetPosition()
                    else
                        local centers = {}
                        for i, node in ipairs(TheWorld.topology.nodes) do
                            if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
                                table.insert(centers, {x = node.x, z = node.y})
                            end
                        end
                        if #centers > 0 then
                            local pos = centers[math.random(#centers)]
                            return Point(pos.x, 0, pos.z)
                        else
                            return caster:GetPosition()
                        end
                    end
                end
                return getrandomposition(caster,teleportee,target_in_ocean)
            end
    
            function self:GetSurroundPoints(CMD_TABLE)
                -- local CMD_TABLE = {
                --     target = inst or Vector3(),
                --     range = 8,
                --     num = 8
                -- }
                if CMD_TABLE == nil then
                    return
                end
                local theMid = nil
                if CMD_TABLE.target == nil then
                    theMid = Vector3( self.inst.Transform:GetWorldPosition() )
                elseif CMD_TABLE.target.x then
                    theMid = CMD_TABLE.target
                elseif CMD_TABLE.target.prefab then
                    theMid = Vector3( CMD_TABLE.target.Transform:GetWorldPosition() )
                else
                    return
                end
                -- --------------------------------------------------------------------------------------------------------------------
                -- -- 8 points
                -- local retPoints = {}
                -- for i = 1, 8, 1 do
                --     local tempDeg = (PI/4)*(i-1)
                --     local tempPoint = theMidPoint + Vector3( Range*math.cos(tempDeg) ,  0  ,  Range*math.sin(tempDeg)    )
                --     table.insert(retPoints,tempPoint)
                -- end
                -- --------------------------------------------------------------------------------------------------------------------
                local num = CMD_TABLE.num or 8
                local range = CMD_TABLE.range or 8
                local retPoints = {}
                for i = 1, num, 1 do
                    local tempDeg = (2*PI/num)*(i-1)
                    local tempPoint = theMid + Vector3( range*math.cos(tempDeg) ,  0  ,  range*math.sin(tempDeg)    )
                    table.insert(retPoints,tempPoint)
                end
    
                return retPoints
    
    
            end
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else               
        replica(fwd_in_pdt_func)
    end
    normal_api(fwd_in_pdt_func)
end