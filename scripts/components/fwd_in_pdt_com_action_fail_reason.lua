----------------------------------------------------------------------------------------------------------------------------------
-- 简易动作失败的时候的文本组件,需要配合 fwd_in_pdt_com_acceptable 组件
-- 该组件只会在server上被调用执行。所以只需要在 TheWorld.ismastersim 里注册。但是同时在 server和client上注册并不影响功能。
-- 玩家身上也注册了该组件，用于更高优先级的文本显示。

--- fwd_in_pdt_com_action_fail_reason:Add_Reason(reason_name,talk_str)  添加失败原因标记位，和对应的文本内容。 用于非玩家。
--- fwd_in_pdt_com_action_fail_reason:Inser_Fail_Talk_Str(str)   添加玩家用的专属失败话语。优先级高于非玩家对象。

-- 需要hook官方函数，具体在 【_Key_Modules_Of_FWD_IN_PDT\05_Actions\00_action_fail_string_api.lua】 查看。
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_action_fail_reason = Class(function(self, inst)
    self.inst = inst
    self.DataTable = {}
    self._temp_custom_str = nil --- 给玩家触发用的
end,
nil,
{

})

function fwd_in_pdt_com_action_fail_reason:Add_Reason(reason_name,talk_str)       ---- 添加失败原因标记位，和对应的文本内容。
    if type(reason_name) == "string" and type(talk_str) == "string" then
        self.DataTable[reason_name] = talk_str
    end
end


function fwd_in_pdt_com_action_fail_reason:Get_Reason_Talk_Str(reason_name)       ---- 给外部调用。
    if reason_name == nil then
        return nil
    end
    return self.DataTable[reason_name]
end

--------------------------------------------------------------------------------
--- 玩家用的，读取优先级会高于物品的。
function fwd_in_pdt_com_action_fail_reason:Inser_Fail_Talk_Str(str)               ---- 
    if type(str) == "string" then
        self._temp_custom_str = str
        self.inst:DoTaskInTime(0.5,function()   --- 超时清除，避免话语出现在错误的交互对象上。
            self._temp_custom_str = nil
        end)
    end
end

function fwd_in_pdt_com_action_fail_reason:Get_Custom_Fail_Str()
    local ret = self._temp_custom_str
    self._temp_custom_str = nil
    return ret
end
--------------------------------------------------------------------------------
return fwd_in_pdt_com_action_fail_reason
