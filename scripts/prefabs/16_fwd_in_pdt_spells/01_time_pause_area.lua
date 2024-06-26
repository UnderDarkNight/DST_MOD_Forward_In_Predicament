------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    时停区域


]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- MakeObstaclePhysics(inst, 0.1)

    -- inst.AnimState:SetBank("cane")
    -- inst.AnimState:SetBuild("swap_cane")
    -- inst.AnimState:PlayAnimation("idle")



    inst.entity:SetPristine()
    ----------------------------------------------------------------------------------
    ---- talker 组件，用来报时
        local TALLER_TALKER_OFFSET = Vector3(0, -700, 0)
        local DEFAULT_TALKER_OFFSET = Vector3(0, -400, 0)
        inst:AddComponent("talker")
        inst.components.talker:SetOffsetFn(function(inst)
            return DEFAULT_TALKER_OFFSET
        end)
    ----------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ----------------------------------------------------------------------------------
    --- 周围一圈坐标获取
        inst.GetSurroundPoints = function(self,CMD_TABLE)
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
                theMid = Vector3( self.Transform:GetWorldPosition() )
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
    ----------------------------------------------------------------------------------
    ---
        inst:AddComponent("inspectable")

    ----------------------------------------------------------------------------------
    --- 时停组件
        inst:AddComponent("fwd_in_pdt_com_time_stopper")
    ----------------------------------------------------------------------------------
        inst:ListenForEvent("Set",function(inst,_table)
            -- _table = {
            --     pt = Vector3(0,0,0),
            --     target = target,
            --     time = 0,
            --     range = 0,
            -- }
            if type(_table) ~= "table" or (_table.pt == nil and _table.target == nil) then
                return
            end
            ------------------------------------------------------------
            ---- 放置位置
                if _table.pt then
                    inst.Transform:SetPosition(_table.pt.x,0,_table.pt.z)
                end
                if _table.target then
                    inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
                end
            ------------------------------------------------------------
            ----
                local range = _table.range or 10
                local x,y,z = inst.Transform:GetWorldPosition()
                local time = (_table.time or 10)

            ------------------------------------------------------------
            ---- 地面圈圈
                local around_points = inst:GetSurroundPoints({
                    target = Vector3(0,0,0),
                    range = range,
                    num = range*3
                })
                local fx_insts = {}
                for k, temp_pt in pairs(around_points) do
                    local temp_fx = inst:SpawnChild("fwd_in_pdt_fx_clock")
                    fx_insts[temp_fx] = true
                    temp_fx:PushEvent("Set",{
                        pt = Vector3(temp_pt.x,0.5,temp_pt.z),
                        color = Vector3(255,0,0),
                        a = 0.7,
                        MultColour_Flag = true,
                    })
                end

                local mid_fx = inst:SpawnChild("fwd_in_pdt_fx_clock")
                fx_insts[mid_fx] = true
                mid_fx:PushEvent("Set",{
                    pt = Vector3(0,3,0),
                    color = Vector3(255,0,0),
                    a = 0.7,
                    MultColour_Flag = true,
                    scale = 3,
                })
                mid_fx.AnimState:SetOrientation(0)
                mid_fx.AnimState:SetLayer(LAYER_WORLD)

                -- inst:DoTaskInTime(time+0.5,function()
                --     for temp_inst, flag in pairs(fx_insts) do
                --         if temp_inst and flag then
                --             temp_inst:Remove()
                --         end
                --     end
                -- end)
            ------------------------------------------------------------
            ---- talker 计时器
                for i = 1, time, 1 do
                    inst:DoTaskInTime(i,function()
                        inst.components.talker:Say("Time : "..tostring(time-i))
                    end)
                end
                inst:DoTaskInTime(time+1,function()
                    inst:Remove()
                end)
            ------------------------------------------------------------
            ---- 定时扫描
                local musthavetags = nil
                local canthavetags = {"INLIMBO","player"}
                local musthaveoneoftags = nil
                local function time_stopper_task()
                    local ents = TheSim:FindEntities(x,y,z,range,musthavetags, canthavetags, musthaveoneoftags)
                    for k, temp_target in pairs(ents) do
                        if not inst.components.fwd_in_pdt_com_time_stopper:Has(temp_target) then
                            inst.components.fwd_in_pdt_com_time_stopper:Add(temp_target)
                        end
                    end
                end
                inst:DoPeriodicTask(0.5,time_stopper_task)
                time_stopper_task()
            ------------------------------------------------------------
            ---- 初始化标记 
                inst.Ready = true
            ------------------------------------------------------------

            ------------------------------------------------------------
        end)
    ----------------------------------------------------------------------------------
        inst:DoTaskInTime(0,function(inst)
            if not inst.Ready then
                inst:Remove()
            end
        end)
    ----------------------------------------------------------------------------------

    -- MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_spell_time_stopper", fn, assets)