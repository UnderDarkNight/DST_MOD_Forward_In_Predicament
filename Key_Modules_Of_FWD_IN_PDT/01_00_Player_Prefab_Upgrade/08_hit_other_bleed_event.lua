-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    当你打出的伤害超过150时（旺达和大力士200），有20%概率触发该事件，若判定成功则每秒钟扣除1血量，持续20秒，
    判定不成功则下次判定增加20%概率触发，成功后有5天冷却


]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_event_hit_other_bleed"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end


    inst:ListenForEvent("onhitother",function(_,_table)
        if not (_table and _table.target and _table.target:IsValid() and _table.damage) then
            return
        end

        ------------- 伤害太小 就跳出
            if (_table.damage < 200 and (inst.prefab == "wolfgang" or inst.prefab == "wanda")) then
                return
            elseif _table.damage < 150 then
                return
            end

        ---------- 距离太远也跳出
            if inst:GetDistanceSqToInst(_table.target) > 9 then
                return
            end


        ---------- 上一次触发的时间 和 当前时间比对
            local day_flag = inst.components.fwd_in_pdt_data:Get("hit_other_blood_event.day_flag") or 0
            if TheWorld.state.cycles - day_flag < 5 then
                return
            end
        
        --------- 概率计算 probability
            local currnt_probability = 0.2 + inst.components.fwd_in_pdt_data:Add("hit_other_blood_event.probability",0)
            if math.random(1000)/1000 > currnt_probability then
                inst.components.fwd_in_pdt_data:Add("hit_other_blood_event.probability",0.2)
                return
            end
        --------- 清空概率累计，上 时间CD
            inst.components.fwd_in_pdt_data:Set("hit_other_blood_event.probability",0)
            inst.components.fwd_in_pdt_data:Set("hit_other_blood_event.day_flag",TheWorld.state.cycles)

        ---------
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                TheNet:Announce("流血事件成功触发")
            end
        -------- 动作
            if inst.sg then
                inst.sg:GoToState("hit")
            end

        ------- 
            if inst.components.health then
                for i = 1, 20, 1 do
                    inst:DoTaskInTime(i,function()
                        if inst:HasTag("playerghost") then
                            return
                        end
                        local current_health = inst.components.health.currenthealth
                        if current_health > 1 then
                            inst.components.health:DoDelta(-1)
                        else
                            local str = tostring(GetStringsTable()["Death_Announce"])
                            str = string.gsub(str,"{XXXX}", inst:GetDisplayName())  -- 名字拼上去            
                            inst.components.fwd_in_pdt_func:Add_Death_Announce({
                                source = "fwd_in_pdt_event_hit_other_bleed",
                                announce = str or "死得好惨，没有成功吸到血",
                            })
                            inst.components.health:DoDelta(-1,nil,"fwd_in_pdt_event_hit_other_bleed")
                        end
                    end)

                end
            end


    end)

end)