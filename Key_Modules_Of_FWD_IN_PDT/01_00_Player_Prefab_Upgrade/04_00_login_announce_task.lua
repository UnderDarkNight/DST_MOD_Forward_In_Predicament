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



    -- inst.components.fwd_in_pdt_func:DailyTask_Add_Fn(function()
    --     if inst.components.fwd_in_pdt_func:IsVIP() then
    --             -- local display_name = inst:GetDisplayName()
    --             -- local base_str = GetStringsTable()["succeed_announce"]
    --             -- local ret_str = string.gsub(base_str, "XXXXXX", tostring(display_name))

    --             -- inst.components.fwd_in_pdt_func:Wisper({
    --             -- --     m_colour = {0,0,255} ,                          ---- 内容颜色
    --             -- --     s_colour = {255,255,0},                         ---- 发送者颜色
    --             -- --     icondata = "profileflair_food_crabroll",        ---- 图标
    --             --     message = ret_str,                                 ---- 文字内容
    --             --     -- sender_name = "HHHH555",                        ---- 发送者名字
    --             -- })

    --         inst.components.fwd_in_pdt_func:VIP_Announce()

    --     else
    --         inst.components.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.display_ad")
    --     end


    -- end)      


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