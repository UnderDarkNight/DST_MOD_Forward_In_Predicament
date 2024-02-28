----------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    特殊自制望远镜动作

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_com_telescope"
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
end

local FWD_IN_PDT_COM_SPECIAL_TELESCOPE = Action({priority = 50,distance = 50})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_SPECIAL_TELESCOPE.id = "FWD_IN_PDT_COM_SPECIAL_TELESCOPE"
FWD_IN_PDT_COM_SPECIAL_TELESCOPE.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    -- local item = act.invobject
    -- local doer = act.doer
    return "DEFAULT"
end

FWD_IN_PDT_COM_SPECIAL_TELESCOPE.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    -- local target = act.target
    local doer = act.doer
    local pos = act.pos
    -- local_pt
    -- print("+++++66",item,doer,pos)
    if pos and doer and item and item.components.fwd_in_pdt_com_telescope then
        item.components.fwd_in_pdt_com_telescope:CastSpell(doer,pos.local_pt)
    end

    return true
end
AddAction(FWD_IN_PDT_COM_SPECIAL_TELESCOPE)

--[[
        以下这些只在客户端执行，30FPS

        AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
        AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
        AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
        AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
        AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。
            
]]--


AddComponentAction("POINT", "fwd_in_pdt_com_telescope", function(item, doer, pos, actions, right)   ------ 指定坐标位置用。    
    if right and doer and item and pos and not (doer.replica.rider and doer.replica.rider:IsRiding()) then
            table.insert(actions, ACTIONS.FWD_IN_PDT_COM_SPECIAL_TELESCOPE)
    end
end)


AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_SPECIAL_TELESCOPE,function(player)
    return "fwd_in_pdt_action_telescope"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_SPECIAL_TELESCOPE, function(player)
    return "fwd_in_pdt_action_telescope"
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_SPECIAL_TELESCOPE = {
    DEFAULT = GetStringsTable()["DEFAULT"]
}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    AddStategraphState("wilson",State{
        name = "fwd_in_pdt_action_telescope",
        tags = { "doing", "busy", "canrotate","nointerrupt" },

        onenter = function(inst)
            -- if inst.components.playercontroller ~= nil then
            --     inst.components.playercontroller:Enable(false)
            -- end
            inst.components.locomotor:Stop()

            -- inst.AnimState:PlayAnimation("sing_fail", false)
            -- inst.SoundEmitter:PlaySound("dontstarve_DLC001/characters/wathgrithr/fail")
            inst.AnimState:PlayAnimation("telescope")
            inst.AnimState:PushAnimation("telescope_pst",false)

            local buffaction = inst:GetBufferedAction()
            if buffaction then
                if buffaction.pos then
                    local x,y,z = buffaction:GetActionPoint():Get()                    
                    inst:ForceFacePoint(x, y, z)
                end
            end


        end,
        timeline =
        {
            TimeEvent(1, function(inst)
                inst:PerformBufferedAction()
            end),
            TimeEvent(13 * FRAMES, function(inst)

            end),
        },
        events =
            {
                EventHandler("animqueueover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end

                end),
            },
        onexit = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end

        end,
    })

---------------------------------------------------------------------------------------------------------------------------------------------------------
---- 客户端上的，同 SGWilson_client.lua
    local TIMEOUT = 2
    AddStategraphState("wilson_client",State{
        name = "fwd_in_pdt_action_telescope",
        tags = { "doing", "busy", "canrotate","nointerrupt" },
        server_states = { "fwd_in_pdt_action_telescope" },

        onenter = function(inst)
            -- if inst.components.playercontroller ~= nil then
            --     inst.components.playercontroller:Enable(false)
            -- end
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("telescope")
            inst.AnimState:PushAnimation("telescope_pst",false)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
            -- print("client_fwd_in_pdt_wellness_cough")
        end,

        onupdate = function(inst)
            if inst.sg:ServerStateMatches() then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,
    })