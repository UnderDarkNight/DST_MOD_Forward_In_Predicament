--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    1.只能吃荤，吃生肉没有惩罚（包括怪物肉，小肉，大肉，鱼肉，叶肉）（这里注意和富贵险中求做兼容，不会感染蛔虫）

    2.吃所有料理的血量收益都为0.1倍率，只能通过打架增加血量

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

    inst:DoTaskInTime(0,function()     
        
        
        ---------------------------------------------------------------------------------------------------------------------
        --- 只能吃肉
            inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES })
        ---------------------------------------------------------------------------------------------------------------------
        --- 所有料理血量收益倍率 0.1
            -- health_delta, hunger_delta, sanity_delta = self.custom_stats_mod_fn(self.inst, health_delta, hunger_delta, sanity_delta, food, feeder)

            inst.components.eater.custom_stats_mod_fn = function(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
                health_delta = 0.1 * health_delta
                return health_delta, hunger_delta, sanity_delta
            end
        ---------------------------------------------------------------------------------------------------------------------


        
    end)


end