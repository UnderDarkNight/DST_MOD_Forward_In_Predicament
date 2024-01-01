-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    
        骨折触发

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function GetStringsTable(name)
        local prefab_name = name or "fwd_in_pdt_welness_fracture"
        local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
        return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
    end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end


    -- worker:PushEvent("finishedwork", { target = self.inst, action = self.action })
    inst:ListenForEvent("finishedwork",function(_,_table)
        if _table and (_table.action == ACTIONS.DIG or _table.action == ACTIONS.CHOP or _table.action == ACTIONS.MINE) then
            if TheWorld.state.isnight or TheWorld:HasTag("cave") or TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then --- 洞穴和夜晚都会触发判定
                if inst.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_fracture") == nil then
                    if math.random(100000)/100000 <= ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 0.5 or 0.01) then

                                inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_fracture")
                                inst.components.fwd_in_pdt_func:Wisper({
                                    m_colour = {200,200,200} ,    -- 内容颜色
                                    message = GetStringsTable("fwd_in_pdt_welness_fracture")["debuff_attach_whisper"] or "", ---- 文字内容
                                })
                                -- print("fake error +++++++ ")
                    end
                end
            end
        end
    end)

end)
