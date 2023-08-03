------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Hook 复活通告API
--- _G.GetNewRezAnnouncementString(...)   --- 就是这个函数处理复活通告的  eventannouncer.lua 里
--- client server 都会运行这个，注意相关的处理
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local EventAnnouncer = require "widgets/eventannouncer"     --- 加载一下函数
local temp_inst = CreateEntity()
temp_inst:DoTaskInTime(0.5,function()   




    rawset(_G, "GetNewRezAnnouncementString_fwd_in_pdt_old", rawget(_G, "GetNewRezAnnouncementString"))
    rawset(_G,"GetNewRezAnnouncementString",function(theRezzed, source)
        local old_ret = {GetNewRezAnnouncementString_fwd_in_pdt_old(theRezzed,source)}
        --  source 通常为文本或者nil，为复活玩家的那个东西的 prefab
        if theRezzed and theRezzed.components.fwd_in_pdt_data:Get("resurrection_announce") then
            local cmd_table_or_string = theRezzed.components.fwd_in_pdt_data:Get("resurrection_announce")
            theRezzed.components.fwd_in_pdt_data:Set("resurrection_announce",nil)
            if type(cmd_table_or_string) == "string" then
                return cmd_table_or_string
            elseif type(cmd_table_or_string) == "table" and cmd_table_or_string.source == source then
                return cmd_table_or_string.announce or ""
            end
        end
        return unpack(old_ret)
    end)


    temp_inst:Remove()
end)