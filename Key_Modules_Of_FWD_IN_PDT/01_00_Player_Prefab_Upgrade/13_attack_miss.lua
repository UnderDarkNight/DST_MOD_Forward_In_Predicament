-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    
        失明触发

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_welness_attack_miss"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end


    -- worker:PushEvent("finishedwork", { target = self.inst, action = self.action })
    inst:ListenForEvent("fwd_in_pdt_event.enter_desert",function(_,_table)
    
                                inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_attack_miss")
                                inst.components.fwd_in_pdt_func:Wisper({
                                    m_colour = {200,200,200} ,    -- 内容颜色
                                    message = GetStringsTable("fwd_in_pdt_welness_attack_miss")["debuff_attach_whisper"] or "", ---- 文字内容
                                })
                                -- print("fake error +++++++ ")
                    
    end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        ----------------------------------------------------------------------
        ---- 标记tag 组件
            if inst.components.fwd_in_pdt_com_tag_sys == nil then
                inst:AddComponent("fwd_in_pdt_com_tag_sys")
            end
        ----------------------------------------------------------------------
        ---- 挂玩家身上的tag
            local sandstorm_event_push_fn = function(inst, _table)
                _table = _table or {}
                local tile_tags = _table.tags or {}
                for k, temp_tag in pairs(tile_tags) do
                    if temp_tag == "sandstorm" then
                        inst:PushEvent("fwd_in_pdt_event.enter_desert") ----- 广播玩家进入沙漠事件。
                        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                            print("FWD_IN_PDT 玩家进入沙漠")
                        end
                        return
                    end
                end

            end
            local function add_enter_desert_event_listener_2_player(inst)
                if not inst.components.fwd_in_pdt_com_tag_sys:HasTag("has_enter_desert_event") then
                    inst.components.fwd_in_pdt_com_tag_sys:AddTag("has_enter_desert_event")
                    inst:ListenForEvent("changearea", sandstorm_event_push_fn)
                end
            end
            local function remove_enter_desert_event_listener_from_player(inst)
                if inst.components.fwd_in_pdt_com_tag_sys:HasTag("has_enter_desert_event") then
                    inst.components.fwd_in_pdt_com_tag_sys:RemoveTag("has_enter_desert_event")
                    inst:RemoveEventCallback("changearea", sandstorm_event_push_fn)
                end
            end
        ----------------------------------------------------------------------
        ---- 初始化检查
            inst:DoTaskInTime(1, function(inst)
                if inst.components.areaaware == nil then
                    return
                end
                if not TheWorld.state.issummer then
                    return
                end
                local CurrentAreaData = inst.components.areaaware:GetCurrentArea() or {}
                CurrentAreaData.tags = CurrentAreaData.tags or {}
                for k,temp_tag in pairs(CurrentAreaData.tags) do
                    if temp_tag == "sandstorm" then
                        add_enter_desert_event_listener_2_player(inst)
                        return
                    end
                end
            end)
        ----------------------------------------------------------------------
        ---- 进入夏天 就挂载 沙漠进入 监听
            inst:WatchWorldState("season",function()
                inst:DoTaskInTime(5,function()
                    if TheWorld.state.issummer then
                        add_enter_desert_event_listener_2_player(inst)
                    else
                        remove_enter_desert_event_listener_from_player(inst)
                    end
                end)
            end)
        ----------------------------------------------------------------------



    end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------