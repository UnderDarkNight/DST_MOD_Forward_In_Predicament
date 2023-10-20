--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 登录广告/通报
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_cd_key_sys"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

AddPlayerPostInit(function(inst)

    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------------------------
    -- 介绍册
        if inst.userid and not TheWorld:HasTag("cave") then
            local synopsis_flag = inst.userid..".synopsis_flag"
            if not TheWorld.components.fwd_in_pdt_data:Get(synopsis_flag) then
                TheWorld.components.fwd_in_pdt_data:Set(synopsis_flag,true)
                inst:DoTaskInTime(1,function()
                    inst.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_item_mod_synopsis",1)                    
                end)
            end
        end
    ----------------------------------------------------------------------------------------------------


end)