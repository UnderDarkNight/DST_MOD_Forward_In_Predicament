----------------------------------------------------------------------------
--- hook chathistory 模块，实现系统悄悄话
--- function ChatHistoryManager:GenerateChatMessage(type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
--- 改掉其中一个参数
----------------------------------------------------------------------------

-- icondata : "profileflair_treasurechest_monster" ,"default"  在文件 misc_items.lua 里，部分需要玩家解锁
-- ChatHistory:AddToHistory({flag = "fwd_in_pdt" , ChatType = ChatTypes.Message , m_colour = {0,0,255} , s_colour = {255,255,0}},nil,nil,"NPC","656565",{0,255,0})
-- m_colour 文本颜色，  s_colour 名字颜色
----------------------------------------------------------------------------
ChatHistory.GenerateChatMessage_old_fwd_in_pdt = ChatHistory.GenerateChatMessage

ChatHistory.GenerateChatMessage = function(self,Chat_type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
    -- print(icondata)
    local fwd_in_pdt_cmd_table = {}
    if Chat_type and type(Chat_type) == "table" and Chat_type.flag == "fwd_in_pdt" then
        fwd_in_pdt_cmd_table = deepcopy(Chat_type)
        Chat_type = fwd_in_pdt_cmd_table.ChatType or ChatTypes.Message
        localonly = true
        icondata = fwd_in_pdt_cmd_table.icondata or icondata or "default"
    end

    local ret_chat_message = self:GenerateChatMessage_old_fwd_in_pdt(Chat_type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
    
    if fwd_in_pdt_cmd_table.flag == "fwd_in_pdt" then
        if fwd_in_pdt_cmd_table.m_colour then            
            ret_chat_message.m_colour = fwd_in_pdt_cmd_table.m_colour --- 文本颜色
        end
        if fwd_in_pdt_cmd_table.s_colour then
            ret_chat_message.s_colour = fwd_in_pdt_cmd_table.s_colour --- 文本颜色
        end
    end

    return ret_chat_message
end