--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 简易通用物品接受组件，用来实现各类物品接受，包括对应的动作，文本。
-- 本组件过于简易，除了SetCanAccept，其他的固定后就不能server端动态切换。

-- 【注意】需要在 inst.entity:SetPristine() 之后，在 TheWorld.ismastersim return 之前，加载并初始化参数。
-- 【笔记】之所以必须在 TheWorld.ismastersim return 之前注册，是因为 动作相关的代码读取 replica 组件的参数会出现未知失败（函数返回正确的值却没能成功执行动作）。绕过的方法过于简单，没深究为什么失败的必要性。

-- 
-- 部分代码需要区分 TheWorld.ismastersim 。
-- 函数 AcceptTest 检测的代码只在 client 执行，会瞬间执行多次（约30FPS）。不建议过于复杂的，尽量使用 replica 和 tag 做参数读取。
-- 函数 OnAccept 物品接受成功后执行，只在 server上执行，return true 表示执行成功。如果 return nil 或者 false，则会表示失败。
-- 函数 OnAccept 返回 非true 的时候，角色会默认说出“我不能这么做。”
-- 【可选】需要配合 fwd_in_pdt_com_action_fail_reason 组件，进行动作失败的时候角色说话。使用说明前往该模块查看。
-- 需要手动处理接受来的物品，比如数量增减，或者删除，或者其他操作（升级、替换、参数修改等）。
-- 函数 SetCanAccept(false) 就能关闭本模块的交互，不需要 inst:RemoveComponent()

-- 动作的显示文本api SetActionDisplayStrByIndex 参数为 index ，对应文本和index 需要前往 GetStringsTable("fwd_in_pdt_com_acceptable") 添加和查看。
-- 封装了添加API SetActionDisplayStr(index,action_name) ，但是容易被后来者覆盖，注意命名避让。

-- 动作交互注册于 【Key_Modules_Of_FWD_IN_PDT\05_Actions\04_item_acceptable_action.lua】。

-- 常用API:
-- 【可选】 fwd_in_pdt_com_acceptable:SetCanAccept(flag)  -- 设置是否可以使用本组件交互 ，默认可以。
-- 【必须】 fwd_in_pdt_com_acceptable:SetTestFn(fn)       -- fn(inst,item,doer,right_click)  
-- 【必须】 fwd_in_pdt_com_acceptable:SetOnAcceptFn(fn)   -- fn(inst,item,doer)
-- 【可选】 fwd_in_pdt_com_acceptable:SetSGAction(str)    -- 设置交互动作。 --- SGWilson 里面的。默认为 "give"
-- 【可选】 fwd_in_pdt_com_acceptable:SetActionDisplayStr(index_str,action_name)  -- 设置显示的动作文本。
-- 【可选】 fwd_in_pdt_com_acceptable:SetPreActionFn(fn)  -- fn(inst,item,doer) 动作执行前的预执行函数。server端 和 client端 都会执行
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_acceptable = Class(function(self, inst)
    self.inst = inst
    -- self.DataTable = {}
    self.__accept_test_fn = nil ---- 测试是否能接收目标物品 fn(inst,item,doer)
    self.__on_accept_fn = nil   ---- 物品接受的时候执行 fn(inst,item,doer)
    self._accept_sg_action = "give"        ---- 默认动作。 --- SGWilson 里面的
    self._accept_action_str_index = "DEFAULT"   -- 默认动作文本index
    self._inser_table_index = "FWD_IN_PDT_COM_ACCEPTABLE_ACTION"  --- 具体前往 Key_Modules_Of_FWD_IN_PDT\05_Actions\04_item_acceptable_action.lua 参考
    self.__pre_action_fn = nil


    self.__can_accept_net_bool = net_bool(self.inst.GUID,"fwd_in_pdt_event.fwd_in_pdt_com_acceptable","fwd_in_pdt_event.fwd_in_pdt_com_acceptable")
    if not TheWorld.ismastersim then
        self.inst:ListenForEvent("fwd_in_pdt_event.fwd_in_pdt_com_acceptable",function()
            local flag = self.__can_accept_net_bool:value() or false
            self:SetCanAccept(flag)
        end)
    end
    self:SetCanAccept(true)

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------
--- 服务器锁定功能,给服务器下发关闭本模块的交互的API
--- 只能用tag ，不然会卡动作
function fwd_in_pdt_com_acceptable:SetCanAccept(flag)
    if flag then
        self.inst:AddTag("fwd_in_pdt_event.fwd_in_pdt_com_acceptable.can_accept")        
    else
        self.inst:RemoveTag("fwd_in_pdt_event.fwd_in_pdt_com_acceptable.can_accept")
    end
    if TheWorld.ismastersim then
        self.__can_accept_net_bool:set(flag or false)
    end
end
function fwd_in_pdt_com_acceptable:GetCanAccept()
    -- print("GetCanAccept",self.inst:HasTag("fwd_in_pdt_event.fwd_in_pdt_com_acceptable.can_accept"))
    return self.inst:HasTag("fwd_in_pdt_event.fwd_in_pdt_com_acceptable.can_accept")
end
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
--- test 函数
function fwd_in_pdt_com_acceptable:AcceptTest(item,doer,right_click)  --- 给动作组件调用
    if self:GetCanAccept() ~= true then
        return false
    end
    if self.__accept_test_fn then
        return self.__accept_test_fn(self.inst,item,doer,right_click) or false
    end
    return false
end

function fwd_in_pdt_com_acceptable:SetTestFn(fn)
    if type(fn) == "function" then 
        self.__accept_test_fn = fn
    end
end
------------------------------------------------------------------------------------------------------------
--- 物品接受的时候
function fwd_in_pdt_com_acceptable:OnAccept(item,doer)
    if self.__on_accept_fn then
        return self.__on_accept_fn(self.inst,item,doer)
    end
    return false
end
function fwd_in_pdt_com_acceptable:SetOnAcceptFn(fn)
    if type(fn) == "function" then
        self.__on_accept_fn = fn
    end
end
------------------------------------------------------------------------------------------------------------
--- 设置动作SG
function fwd_in_pdt_com_acceptable:GetSGAction()
    return self._accept_sg_action
end

function fwd_in_pdt_com_acceptable:SetSGAction(str)
    if type(str) == "string" then
        self._accept_sg_action = str
    end
end
------------------------------------------------------------------------------------------------------------
--- 设置动作显示的名字
function fwd_in_pdt_com_acceptable:GetSGActionNameIndex() --- 给 action 用的
    return self._accept_action_str_index
end
function fwd_in_pdt_com_acceptable:SetActionDisplayStrByIndex(str)  --- 设置文本的index
    if type(str) == "string" then
        self._accept_action_str_index = string.upper(str)
    end
end

function fwd_in_pdt_com_acceptable:SetActionDisplayStr(index,action_name)     --- 一起设置文本index 和 文本内容
    if type(index) ~= "string" or type("action_name") ~= "string" then
        return
    end
    index = string.upper(index)
    if STRINGS.ACTIONS.FWD_IN_PDT_COM_ACCEPTABLE_ACTION[index] and STRINGS.ACTIONS.FWD_IN_PDT_COM_ACCEPTABLE_ACTION[index] ~= action_name then
        print("Error : fwd_in_pdt_com_acceptable:SetActionDisplayStr ,Action text display is overwritten",self.inst,index,action_name)
    end
    STRINGS.ACTIONS.FWD_IN_PDT_COM_ACCEPTABLE_ACTION[index] = action_name     ---- 添加到文本库
    self:SetActionDisplayStrByIndex(index)                                    ---- 添加给自己
end
------------------------------------------------------------------------------------------------------------
--- 配置是否可以切换到别的动作
function fwd_in_pdt_com_acceptable:GetSGActionInserIndex()
    return self._inser_table_index
end

function fwd_in_pdt_com_acceptable:SetSGActionInserIndex(str)
    if type(str) == "string" then
        self._inser_table_index = string.upper(str)
    end
end
------------------------------------------------------------------------------------------------------------
--- 配置动作执行前的预执行函数
function fwd_in_pdt_com_acceptable:SetPreActionFn(fn)
    if type(fn) == "function" then
        self.__pre_action_fn = fn
    end
end
function fwd_in_pdt_com_acceptable:DoPreActionFn(item,doer)
    if self.__pre_action_fn then
        self.__pre_action_fn(self.inst,item,doer)
    end
end
------------------------------------------------------------------------------------------------------------

return fwd_in_pdt_com_acceptable




