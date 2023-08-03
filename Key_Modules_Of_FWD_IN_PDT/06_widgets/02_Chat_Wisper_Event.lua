------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- hook chathistory 模块，实现系统悄悄话。  chathistory.lua
--- function ChatHistoryManager:GenerateChatMessage(type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
--- 改掉其中一个参数
--- 客户端用 ChatHistory:AddToHistory 执行显示语句，该函数内部会调用 ChatHistory.GenerateChatMessage
----------------------------------------------------------------------------
-- icondata : "profileflair_treasurechest_monster" ,"default"  在文件 misc_items.lua 里，部分需要玩家解锁。
-- icon 的尺寸为90x90像素，具体参数前往 profileflair.tex 和 profileflair.xml 查看。如果是自己制作，推荐使用 autocompiler.exe 自动编译 png 成 tex + xml (png放文件夹里会自动进行)
-- ChatHistory:AddToHistory({flag = "fwd_in_pdt" , ChatType = ChatTypes.Message , m_colour = {0,0,255} , s_colour = {255,255,0}},nil,nil,"NPC","656565",{0,255,0})
-- m_colour 文本颜色，  s_colour 名字颜色
-- colour 参数 和官方的有出入，  需要除以255才能成任意色。
-- ChatType 在 chatline.lua 里有执行逻辑
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


ChatHistory.GenerateChatMessage_old_fwd_in_pdt = ChatHistory.GenerateChatMessage
ChatHistory.GenerateChatMessage = function(self,Chat_type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
    local fwd_in_pdt_cmd_table = {}
    if Chat_type and type(Chat_type) == "table" and Chat_type.flag == "fwd_in_pdt" then
        fwd_in_pdt_cmd_table = deepcopy(Chat_type)
        Chat_type = fwd_in_pdt_cmd_table.ChatType or ChatTypes.Message                        ---- 文本类型
        localonly = true                                                                ---- 只在本地
        icondata = fwd_in_pdt_cmd_table.icondata or icondata -- or "default"                     ---- 图标
        sender_name = fwd_in_pdt_cmd_table.sender_name or sender_name                         ---- 发送者名字
        message = fwd_in_pdt_cmd_table.message or message                                     ---- 文字内容
        colour = fwd_in_pdt_cmd_table.s_colour or fwd_in_pdt_cmd_table.m_colour or {255/255,255/255,255/255}    ---- 颜色初始化。
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


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 在 client 端 给玩家添加 event
AddPlayerPostInit(function(inst)
    
    if TheNet:IsDedicated() then    -- 是服务器加载到这就返回。 事件添加到 客户端足够了，用 RPC EVENT 下发
        return
    end

    inst:ListenForEvent("fwd_in_pdt_event.whisper",function(_,_table)
        if _table and _table.message then
            _table.flag = "fwd_in_pdt"
            ChatHistory:AddToHistory(_table)
        end
    end)

end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 修改操作成无背景图标
---- 参考 TEMPLATES.ChatFlairBadge 修改参数和挂载节点。
----  TUNING["Forward_In_Predicament.Chat_Message_Icons"][temp_file_name]

if TUNING["Forward_In_Predicament.Config"].UI_FX ~= true then     ---- 设置上关闭动画特效
    return
end

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
TUNING["Forward_In_Predicament.Chat_Message_Icons"] = TUNING["Forward_In_Predicament.Chat_Message_Icons"] or {} --- 在这初始化一下，避免某些潜在的崩溃。
AddClassPostConstruct("widgets/redux/chatline",function(self)  

    self.SetChatData__fwd_in_pdt_old = self.SetChatData
    self.SetChatData = function(self,_type, alpha, message, m_colour, sender, s_colour, icondata)
        self:SetChatData__fwd_in_pdt_old(_type, alpha, message, m_colour, sender, s_colour, icondata)
        
        if self.flair == nil then
            return
        end

        ---------- 清除旧栏目内的内容。
        if icondata ~= nil and TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(icondata)] == nil and self.___fwd_in_pdt_image then
            self.___fwd_in_pdt_image:Kill()
            self.___fwd_in_pdt_image = nil
            if self.flair.flair_img then
                self.flair.flair_img:Show()
            end
            if self.flair.bg then
                self.flair.bg:Show()
            end
            return
        end

        ------ 隐藏原有的 图标和背景，添加新的图标和FX图层。
        if TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(icondata)] and self.___fwd_in_pdt_image == nil then
                        local atlas = TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(icondata)].atlas
                        local image = TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(icondata)].image
                        local image_scale = TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(icondata)].scale
                        local fx = TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(icondata)].fx
                    
                        if self.flair.flair_img then
                            self.flair.flair_img:Hide()
                        end
                        if self.flair.bg then
                            self.flair.bg:Hide()
                        end
                        -- if self.___fwd_in_pdt_image then
                        --     self.___fwd_in_pdt_image:Kill()
                        -- end

                        self.___fwd_in_pdt_image = self.root:AddChild(Image())
                        self.___fwd_in_pdt_image:SetPosition(-315, 0)
                        self.___fwd_in_pdt_image:SetScale(image_scale or 0.25)
                        self.___fwd_in_pdt_image:SetTexture(atlas,image)
                        self.___fwd_in_pdt_image:SetClickable(false)

                        self.flair.___fwd_in_pdt_image = self.___fwd_in_pdt_image   --- 方便 SetAlpha 操作渐变

                        if type(fx) == "table" and fx.bank and fx.build and fx.anim then
                                self.__fwd_in_pdt_fx = self.___fwd_in_pdt_image:AddChild(UIAnim())
                                self.__fwd_in_pdt_fx:GetAnimState():SetBank(fx.bank)
                                self.__fwd_in_pdt_fx:GetAnimState():SetBuild(fx.build)
                                self.__fwd_in_pdt_fx:GetAnimState():PlayAnimation(fx.anim,true)
                                local color = fx.color or fx.colour
                                if color then
                                    local r = color[1]
                                    local g = color[2]
                                    local b = color[3]
                                    local a = color[4] or 1
                                    self.__fwd_in_pdt_fx:GetAnimState():SetMultColour(r,g,b,a)
                                end
                                if type(fx.scale) == "number" then
                                    self.__fwd_in_pdt_fx:SetScale(fx.scale)
                                end
                                if type(fx.shader) == "string" then
                                    self.__fwd_in_pdt_fx:GetAnimState():SetBloomEffectHandle(fx.shader)
                                end
                        end

                        ------------- 让图标和动画特效也跟着 渐隐,逻辑照抄。
                        if self.flair.SetAlpha___fwd_in_pdt_old == nil then
                            self.flair.SetAlpha___fwd_in_pdt_old = self.flair.SetAlpha
                            self.flair.SetAlpha = function(self,a)
                                self:SetAlpha___fwd_in_pdt_old(a)
                                if self.___fwd_in_pdt_image and a > 0.01 then
                                    self.___fwd_in_pdt_image:Show()
                                    self.___fwd_in_pdt_image:SetTint(1,1,1,a)      
                                else
                                    self.___fwd_in_pdt_image:Hide()                              
                                end
                            end

                        end

        end
    end


end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

