----------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    特殊自制钓鱼

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_com_acceptable"
--     return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
-- end

local function CheckOceanFishingCastRange(doer, dest)
	local doer_pos = doer:GetPosition()
	local target_pos = Vector3(dest:GetPoint())
	local dir = target_pos - doer_pos

	-- local test_pt = doer_pos + dir:GetNormalized() * (doer:GetPhysicsRadius(0) + 1.5)
	local test_pt = doer_pos + dir:GetNormalized() * (doer:GetPhysicsRadius(0) + (-1))

    -- print("IsVisualGroundAtPoint",TheWorld.Map:IsVisualGroundAtPoint(test_pt.x, 0, test_pt.z))
    -- print("GetPlatformAtPoint",TheWorld.Map:GetPlatformAtPoint(test_pt.x, test_pt.z) ~= nil)
    if TheWorld.Map:IsVisualGroundAtPoint(test_pt.x, 0, test_pt.z) or TheWorld.Map:GetPlatformAtPoint(test_pt.x, test_pt.z) ~= nil then
        -- if FindVirtualOceanEntity(test_pt.x, 0, test_pt.z) ~= nil then
        --     return true
        -- end
        if true then
            local equippedTool = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equippedTool and equippedTool.components.fwd_in_pdt_com_special_fishingrod then
                return equippedTool.components.fwd_in_pdt_com_special_fishingrod:Point_Test(doer,test_pt)
            end
        end

		return false
	else
        return true
	end




end
local FWD_IN_PDT_COM_SPECIAL_FISHING = Action({priority = 50,customarrivecheck=CheckOceanFishingCastRange})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_SPECIAL_FISHING.id = "FWD_IN_PDT_COM_SPECIAL_FISHING"
FWD_IN_PDT_COM_SPECIAL_FISHING.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    local item = act.invobject
    -- local target = act.target
    local doer = act.doer
    if item and item.components.fwd_in_pdt_com_special_fishingrod then
        if doer and doer.sg and doer.sg:HasStateTag("nibble") and item.components.fwd_in_pdt_com_special_fishingrod:IsCatched() then
            return "HOOK"
        end
        -- if doer and doer.sg and doer.sg:HasStateTag("fwd_in_pdt_catchfish") then
        --     return nil
        -- end
    end
    -- print("GGG+++++",doer,item)
    return "START"
end

FWD_IN_PDT_COM_SPECIAL_FISHING.fn = function(act)    --- 只在服务端执行~
    -- local item = act.invobject
    -- local target = act.target
    -- local doer = act.doer
    -- local pos = act.pos

    return true
end
AddAction(FWD_IN_PDT_COM_SPECIAL_FISHING)

--[[
        以下这些只在客户端执行，30FPS

        AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
        AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
        AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
        AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
        AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。
            
]]--


AddComponentAction("POINT", "fwd_in_pdt_com_special_fishingrod", function(item, doer, pos, actions, right)   ------ 指定坐标位置用。    
    if right and doer and item and pos and not (doer.replica.rider and doer.replica.rider:IsRiding()) then
        if item.components.fwd_in_pdt_com_special_fishingrod:Point_Test(doer,pos) then
            table.insert(actions, ACTIONS.FWD_IN_PDT_COM_SPECIAL_FISHING)
        end
    end
end)


AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_SPECIAL_FISHING,function(player)

    local item = player.bufferedaction.invobject
    -- local target = act.target
    -- local doer = act.doer
    -- local pos = act.pos
    if item then
        if player.sg and player.sg:HasStateTag("nibble") and item.components.fwd_in_pdt_com_special_fishingrod:IsCatched() then
            return "fwd_in_pdt_catchfish"
        else
            return "fwd_in_pdt_fishing_pre"
        end
    end
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_SPECIAL_FISHING, function(player)
    local item = player.bufferedaction.invobject
    -- local target = act.target
    -- local doer = act.doer
    -- local pos = act.pos
    if item then
        if player.sg and player.sg:HasStateTag("nibble") and item.components.fwd_in_pdt_com_special_fishingrod:IsCatched() then
            return "fwd_in_pdt_catchfish"
        else
            return "fwd_in_pdt_fishing_pre"
        end
    end
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_SPECIAL_FISHING = {
    START = "钓",
    HOOK = "收杆",
}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local TIMEOUT = 2
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 开始钓鱼
    AddStategraphState("wilson",State{
        name = "fwd_in_pdt_fishing_pre",
        tags = { "prefish", "fishing", "fwd_in_pdt_fishing_pre" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("fishing_pre")
            inst.AnimState:PushAnimation("fishing_cast")
            inst.AnimState:PushAnimation("fishing_idle", true)
        end,

        timeline =
        {
            TimeEvent(13*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_cast") 
            end),
            -- TimeEvent(15*FRAMES, function(inst) inst:PerformBufferedAction() end), -- 会清空 player.bufferedaction
            TimeEvent(15*FRAMES, function(inst)
                
                local BufferedAction = inst:GetBufferedAction()
                local item =  BufferedAction.invobject
                local pos = BufferedAction.pos
                local pt = BufferedAction:GetActionPoint()
    
                if item and item.components.fwd_in_pdt_com_special_fishingrod then
                    item.components.fwd_in_pdt_com_special_fishingrod:Start_Fishing(inst,pt)
                end
                inst:PerformBufferedAction()

            end),
        },

        events =
        {
            EventHandler("fwd_in_pdt_com_special_fishingrod.catched", function(inst)
                inst.sg:GoToState("fwd_in_pdt_fishing_nibble") --- 晃荡
            end),
            EventHandler("fwd_in_pdt_com_special_fishingrod.unequiped", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            local equippedTool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equippedTool and equippedTool.components.fwd_in_pdt_com_special_fishingrod then
                equippedTool.components.fwd_in_pdt_com_special_fishingrod:CancelFishingTask()
            end

        end,
    })
    ------------------------------------------------------------------------------------------------
    AddStategraphState("wilson_client",State{
        name = "fwd_in_pdt_fishing_pre",
        tags = { "prefish", "fishing" ,"fwd_in_pdt_fishing_pre"},
		server_states = { "fishing_pre", "fishing" },
      
        onenter = function(inst)
            inst.AnimState:PlayAnimation("fishing_pre")
            inst.AnimState:PushAnimation("fishing_lag")
            inst.AnimState:PushAnimation("fishing_idle",true)
            inst.components.locomotor:Stop()
            inst:PerformPreviewBufferedAction()
            inst.entity:FlattenMovementPrediction()
            inst.entity:SetIsPredictingMovement(false)

            local function ClearCachedServerState(inst)
                if inst.player_classified ~= nil then
                    inst.player_classified.currentstate:set_local(0)
                end
            end
			ClearCachedServerState(inst)
        end,

        onupdate = function(inst)
            if not inst:HasTag("fishing") then
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", "noanim")
            end
            if inst:HasTag("fwd_in_pdt_fishing_nibble") then
                inst.sg:GoToState("fwd_in_pdt_fishing")                    
            end
        end,

        onexit = function(inst)
            inst.entity:SetIsPredictingMovement(true)
        end,
    })
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 鱼上钩了
    AddStategraphState("wilson",State{
        name = "fwd_in_pdt_fishing_nibble",
        tags = { "fishing", "nibble","fwd_in_pdt_fishing_nibble" },

        onenter = function(inst)

            inst.AnimState:PlayAnimation("bite_light_pre")
            inst.AnimState:PushAnimation("bite_light_loop", true)
            -- inst.sg:SetTimeout(1 + math.random())
            inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishinwater", "splash")
            inst:AddTag("fwd_in_pdt_fishing_nibble")
        end,


        events =
        {
            EventHandler("fwd_in_pdt_com_special_fishingrod.unequiped", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("splash")
            inst:RemoveTag("fwd_in_pdt_fishing_nibble")
        end,

    })
    ------------------------------------------------------------------------------------------------
    AddStategraphState("wilson_client",State{
        name = "fwd_in_pdt_fishing_nibble",
        tags = {  "fishing", "nibble","fwd_in_pdt_fishing_nibble" },
        server_states = { "fwd_in_pdt_fishing_nibble" },
    
        onenter = function(inst)
            -- if inst.components.playercontroller ~= nil then
            --     inst.components.playercontroller:Enable(false)
            -- end
            inst.AnimState:PlayAnimation("bite_light_pre")
            inst.AnimState:PushAnimation("bite_light_loop", true)

            inst.components.locomotor:Stop()
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 起钓鱼
    AddStategraphState("wilson",State{
        name = "fwd_in_pdt_catchfish",
        tags = { "fishing", "catchfish", "busy","fwd_in_pdt_catchfish" },

        onenter = function(inst)

            local equippedTool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equippedTool and equippedTool.components.fwd_in_pdt_com_special_fishingrod then
                equippedTool.components.fwd_in_pdt_com_special_fishingrod:Start_Hook()
                local build = equippedTool.components.fwd_in_pdt_com_special_fishingrod:GetFishBuild()
                if build then
                    inst.AnimState:OverrideSymbol("fish01", build, "fish01")
                end
            end


            -- local build = build
            inst.AnimState:PlayAnimation("fish_catch")
            --print("Using ", build, " to swap out fish01")
            -- inst.AnimState:OverrideSymbol("fish01", build, "fish01")

            -- inst.AnimState:OverrideSymbol("fish_body", build, "fish_body")
            -- inst.AnimState:OverrideSymbol("fish_eye", build, "fish_eye")
            -- inst.AnimState:OverrideSymbol("fish_fin", build, "fish_fin")
            -- inst.AnimState:OverrideSymbol("fish_head", build, "fish_head")
            -- inst.AnimState:OverrideSymbol("fish_mouth", build, "fish_mouth")
            -- inst.AnimState:OverrideSymbol("fish_tail", build, "fish_tail")
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught") end),
            TimeEvent(10*FRAMES, function(inst) inst.sg:RemoveStateTag("fishing") end),
            TimeEvent(23*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishland") end),
            TimeEvent(24*FRAMES, function(inst)

                local equippedTool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equippedTool and equippedTool.components.fwd_in_pdt_com_special_fishingrod then
                    equippedTool.components.fwd_in_pdt_com_special_fishingrod:Hook_End()
                end
                inst.AnimState:ClearOverrideSymbol("fish01")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.AnimState:ClearOverrideSymbol("fish01")
            -- inst.AnimState:ClearOverrideSymbol("fish_body")
            -- inst.AnimState:ClearOverrideSymbol("fish_eye")
            -- inst.AnimState:ClearOverrideSymbol("fish_fin")
            -- inst.AnimState:ClearOverrideSymbol("fish_head")
            -- inst.AnimState:ClearOverrideSymbol("fish_mouth")
            -- inst.AnimState:ClearOverrideSymbol("fish_tail")
        end

    })
    ------------------------------------------------------------------------------------------------
    AddStategraphState("wilson_client",State{
        name = "fwd_in_pdt_catchfish",
        tags = {  "fishing", "catchfish", "busy","fwd_in_pdt_catchfish" },
        server_states = { "fwd_in_pdt_catchfish" },
    
        onenter = function(inst)
            -- if inst.components.playercontroller ~= nil then
            --     inst.components.playercontroller:Enable(false)
            -- end
            inst.AnimState:PlayAnimation("fish_catch")
            inst.components.locomotor:Stop()
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------