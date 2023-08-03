------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Hook 死亡通告API
--- _G.GetNewDeathAnnouncementString(...)   --- 就是这个函数处理死亡通告的  eventannouncer.lua 里
--- client server 都会运行这个，注意相关的处理
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local EventAnnouncer = require "widgets/eventannouncer"     --- 加载一下函数

local temp_inst = CreateEntity()
temp_inst:DoTaskInTime(0.5,function()   


    ------------------------------------------------------------------------------------------------------------------------------------------------
    ------------ 延迟一下执行，游戏加载的时候没能成功hook

    local origin_fn = rawget(_G,"GetNewDeathAnnouncementString")
    rawset(_G,"GetNewDeathAnnouncementString__fwd_in_pdt_old", origin_fn)
    rawset(_G,"GetNewDeathAnnouncementString", function(theDead_inst,source,...)
            --  source is string or nil, normally killer_inst.prefab
            --  source 通常为文本或者nil，为弄死玩家的 prefab
            --  print("GetNewDeathAnnouncementString",theDead_inst,source)
            if theDead_inst and theDead_inst.components.fwd_in_pdt_data and theDead_inst.components.fwd_in_pdt_data:Get("death_announce") then
                local death_announce_data = theDead_inst.components.fwd_in_pdt_data:Get("death_announce")
                theDead_inst.components.fwd_in_pdt_data:Set("death_announce",nil)
                if type(death_announce_data) == "string" then
                    return death_announce_data
                elseif type(death_announce_data) == "table" then
                    if death_announce_data.source == source then
                        return death_announce_data.announce or ""
                    end
                end
            end
            return GetNewDeathAnnouncementString__fwd_in_pdt_old(theDead_inst,source,...)
    end)
    ------------------------------------------------------------------------------------------------------------------------------------------------

    temp_inst:Remove()
    -- print("info:GetNewDeathAnnouncementString__fwd_in_pdt_old")
end)


