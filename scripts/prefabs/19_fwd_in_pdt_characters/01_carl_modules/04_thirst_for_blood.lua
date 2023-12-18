--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    3.【被动】【渴血】时刻都在掉血（每1s掉5血）。使用【药膏】的回复效果很差、但是可以减少自动掉血的量（每秒-2），持续1天。

    蜜蜂膏药
    蜘蛛腺体
    治疗膏药
    蚊子血袋

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_carl"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    ---------------------------------------------------------------------------------------------------------------------
    --- 【渴血】 debuff
        local time = 1  --- 时间周期
        local HP_delta = 5  --- 原始扣除量

        inst:DoPeriodicTask(time,function()
            if inst:HasTag("playerghost") then
                return
            end

            local target_delta_num = HP_delta
            ----------------------------------------------------------------------
            ---- 有这些 buff 就减少扣血，或者不扣血
                --- 吃 蜜蜂膏药得到的buff
                if inst.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_carl_thirst_for_blood") ~= nil then
                    target_delta_num = 2
                end
                --- 吃暗影心房得到的buff
                if inst.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_carl_thirst_for_blood__shadowheart") ~= nil then
                    target_delta_num = 0
                end

            ----------------------------------------------------------------------
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("渴血：",-target_delta_num)
            end
            if target_delta_num <= 0 then
                return
            end


            local current_health = inst.components.health.currenthealth
            if current_health <= target_delta_num then ---- 特殊死亡通告
                local str = tostring(GetStringsTable()["death_thirst_for_blood"])
                str = string.gsub(str,"{XXXX}", inst:GetDisplayName())  -- 名字拼上去

                inst.components.fwd_in_pdt_func:Add_Death_Announce({
                    source = "death_thirst_for_blood",
                    announce = str or "死得好惨，没有成功吸到血",
                })

                inst.components.health:DoDelta(-target_delta_num, true, "death_thirst_for_blood")
            else
                inst.components.health:DoDelta(-target_delta_num, true)
            end


        end)

    ---------------------------------------------------------------------------------------------------------------------
    ---- 屏蔽一些道具回血
        inst:DoTaskInTime(0,function()
            
            inst.components.fwd_in_pdt_func:PreDoDelta_Add_Health_Fn(function(health_com,amount, overtime, cause,...)
                if amount > 0 and cause then
                    -- print("info health dodelta by reason",amount,cause)
                    local causes_block_by_prefab = {
                        ["bandage"] = true,             --- 蜜蜂膏药
                        ["spidergland"] = true,         --- 蜘蛛腺体
                        ["healingsalve"] = true,        --- 治疗膏药
                        ["mosquitosack"] = true,        --- 蚊子血袋
                    }
                    if causes_block_by_prefab[cause] then
                        amount = 0
                        ---------------------------
                        -- 特殊膏药上 buff
                        if cause == "bandage" then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_carl_thirst_for_blood")
                        end
                        ---------------------------
                    end
                end
                return amount, overtime, cause,...
            end)


        end)
    ---------------------------------------------------------------------------------------------------------------------


end