--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 高阶通用交互模块，可以服务器下发 index 切换动作 和 文本
-- 

-- 【注意】需要在 inst.entity:SetPristine() 之后，在 TheWorld.ismastersim return 之前，加载并初始化参数。
-- 【笔记】之所以必须在 TheWorld.ismastersim return 之前注册，是因为 动作相关的代码读取 replica 组件的参数会出现未知失败（函数返回正确的值却没能成功执行动作）。绕过的方法过于简单，没深究为什么失败的必要性。

-- 
-- 部分代码需要区分 TheWorld.ismastersim 。
-- 函数 WorkTest 检测的代码只在 client 执行，会瞬间执行多次（约30FPS）。不建议过于复杂的，尽量使用 replica 和 tag 做参数读取。
-- 函数 OnWork 物品接受成功后执行，只在 server上执行，return true 表示执行成功。如果 return nil 或者 false，则会表示失败。
-- 函数 OnWork 返回 非true 的时候，角色会默认说出“我不能这么做。”
-- 【可选】需要配合 fwd_in_pdt_com_action_fail_reason 组件，进行动作失败的时候角色说话。使用说明前往该模块查看。
-- 函数 SetCanWorlk(false) 就能关闭本模块的交互，不需要 inst:RemoveComponent()


-- 动作的显示文本api SetActionDisplayStrByIndex 参数为 index ，对应文本和index 需要前往 GetStringsTable("fwd_in_pdt_com_special_workable") 添加和查看。
-- 封装了添加API AddActionDisplayStr(index,action_name) ，但是容易被后来者覆盖，注意命名避让。

-- 动作交互注册于 【_Key_Modules_Of_FWD_IN_PDT\05_Actions\05_inst_workable_action.lua】。


-- 常用API:
-- 【可选】 fwd_in_pdt_com_special_workable:SetCanWorlk(flag)  -- 设置是否可以使用本组件交互 ，默认可以。

-- 【必须】 fwd_in_pdt_com_special_workable:AddTestFn(index_str,fn)      -- fn(inst,doer,right_click)  
-- 【必须】 fwd_in_pdt_com_special_workable:SetTestIndex(index_str)      --- 可在 server 端执行切换

-- 【必须】 fwd_in_pdt_com_special_workable:AddOnWorkFn(index_str,fn)    -- fn(inst,doer)
-- 【必须】 fwd_in_pdt_com_special_workable:SetOnWorkIndex(index_str)    -- 可在 server 端执行切换

-- 【可选】 fwd_in_pdt_com_special_workable:AddSGAction(str)   -- 添加交互动作。 --- SGWilson 里面的。默认为 "dolongaction"
-- 【可选】【重要】 fwd_in_pdt_com_special_workable:SetSGAction(str)   -- 设置当前动作，可在server端切换

-- 【可选】 fwd_in_pdt_com_special_workable:AddActionDisplayStr(index_str,action_name)  -- 添加显示的动作文本。注意避让index
-- 【可选】【重要】 fwd_in_pdt_com_special_workable:SetActionDisplayStrByIndex(index_str)       -- 设置当前的动作文本，可在server端切换。

-- 【可选】 fwd_in_pdt_com_special_workable:AddPreActionFn(index_str,fn)  -- 添加动作之前的预执行函数 fn(inst,doer) ，server 和 client 的都执行
-- 【可选】【重要】 fwd_in_pdt_com_special_workable:SetPreActionIndex(index_str)       -- 设置当前预执行函数，可在server端切换

--- 程序流程：添加 -> 设置 index
--- 【重要】【示例】 【scripts\prefabs\__fwd_in_pdt_debugging_prefabs\09_example_special_test_tree.lua】

--- 【笔记】如果是入背包的物品，要背包里和地上都能用，就得用下面代码。
            -- inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            --     if inst.replica.inventoryitem:IsGrandOwner(doer) then
            --         return true
            --     else
            --         return right_click
            --     end
            -- end)
            
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_special_workable = Class(function(self, inst)
        self.inst = inst  

        self.SimpleDatas = {
            ["TEST"] = 6666,
        }

        self.test_fns = {}
        self.on_work_fns = {}
        self.sg_action = {}
        self.work_action_str_index = {}
        self.inser_table_index = {}
        self.pre_action_fns = {}

        self.__simple_data_json_str = "{}"
        self.__simple_data_json_str_net_string = net_string(self.inst.GUID,"fwd_in_pdt_event.fwd_in_pdt_com_special_workable","fwd_in_pdt_event.fwd_in_pdt_com_special_workable")
        if not TheWorld.ismastersim then
            self.inst:ListenForEvent("fwd_in_pdt_event.fwd_in_pdt_com_special_workable",function()
                self.__simple_data_json_str = self.__simple_data_json_str_net_string:value()
                self:data_synchronization()
                self:SetCanWorlk(self:GetSimpleData("can_work"))
            end)
        end
        self:SetCanWorlk(true)
end,    
nil,
{

})
------------------------------------------------------------------------------------------------------------
--- 数据设置和同步
    function fwd_in_pdt_com_special_workable:data_synchronization_lock__pass_check()    --- 数据交互过于频繁，加个锁限制一下
        --- nil false true
        if self.___locked then
            return false
        else
            self.___locked = true
            self.inst:DoTaskInTime(1,function()
                self.___locked = false
            end)
            return true
        end
    end
    function fwd_in_pdt_com_special_workable:data_synchronization()
        ---- net_vars 同步有点奇怪，会不停的同步数据。可能需要加个tag锁
        if TheWorld.ismastersim then
                    ----- 使用延时任务同步，避免一次性设置数据过多信道阻塞
                    if self.temp_task then
                        self.temp_task:Cancel()
                        self.temp_task = nil
                    end
                    self.temp_task = self.inst:DoTaskInTime(0,function()
                        -- self.inst:AddTag("fwd_in_pdt_com_special_workable.data_synchronization")
                        self.__simple_data_json_str = json.encode(self.SimpleDatas)
                        self.__simple_data_json_str_net_string:set(self.__simple_data_json_str)
                        -- self.inst:DoTaskInTime(0.1,function()
                        --     self.inst:RemoveTag("fwd_in_pdt_com_special_workable.data_synchronization")                        
                        -- end)
                    end)

        else
                    -- if not self.inst:HasTag("fwd_in_pdt_com_special_workable.data_synchronization") then
                    --     return
                    -- end

                    if self:data_synchronization_lock__pass_check() ~= true then
                        return
                    end

                    local crash_flag,ret = pcall(function()
                        local cmd_table = json.decode(self.__simple_data_json_str)
                        for index, data in pairs(cmd_table) do
                            self:SetSimpleData(index, data)
                        end
                    end)
                    if crash_flag == false then
                        print("fwd_in_pdt_com_special_workable:data_synchronization cilent error")
                        print(ret)
                        print(self.__simple_data_json_str)
                    else
                        -- for k, v in pairs(self.SimpleDatas) do
                        --     print(k,v)
                        -- end    
                    end

                                    ------------【重要笔记】 用这种代码方案会导致动作卡！！！！暂时留在这以备后续查看
                                    ------------【重要笔记】 用这种代码方案会导致动作卡！！！！暂时留在这以备后续查看
                                    ------------【重要笔记】 用这种代码方案会导致动作卡！！！！暂时留在这以备后续查看
                                    ------------【重要笔记】 用这种代码方案会导致动作卡！！！！暂时留在这以备后续查看
                                    ------------【重要笔记】 用这种代码方案会导致动作卡！！！！暂时留在这以备后续查看
                                    -- local crash_flag,cmd_table = pcall(json.decode,self.__simple_data_json_str)
                                    -- if crash_flag then
                                    --     for index, data in pairs(cmd_table) do
                                    --         self:SetSimpleData(index, data)
                                    --     end
                                    -- end


                    -- self.inst:RemoveTag("fwd_in_pdt_com_special_workable.data_synchronization")
                
        end
    end
    function fwd_in_pdt_com_special_workable:SetSimpleData(name_str,data)
        if type(name_str) == "string" then
            self.SimpleDatas[name_str] = data
        end
        self:data_synchronization()
    end
    function fwd_in_pdt_com_special_workable:GetSimpleData(name_str)
        return self.SimpleDatas[tostring(name_str)]
    end
------------------------------------------------------------------------------------------------------------
--- 服务器锁定功能,给服务器下发关闭本模块的交互的API
    function fwd_in_pdt_com_special_workable:SetCanWorlk(flag)
        if flag then
            self.inst:AddTag("fwd_in_pdt_event.fwd_in_pdt_com_special_workable.active")        
        else
            self.inst:RemoveTag("fwd_in_pdt_event.fwd_in_pdt_com_special_workable.active")
        end
        self:SetSimpleData("can_work",flag or false)
    end
    function fwd_in_pdt_com_special_workable:GetCanWorlk()
        return self.inst:HasTag("fwd_in_pdt_event.fwd_in_pdt_com_special_workable.active")
    end
------------------------------------------------------------------------------------------------------------
--- test 函数
    function fwd_in_pdt_com_special_workable:WorkTest(doer,right_click)  --- 给动作组件调用
        if self:GetCanWorlk() ~= true then
            return false
        end    
        if self.test_fns[tostring(self:GetSimpleData("test_index"))] then
            return self.test_fns[tostring(self:GetSimpleData("test_index"))](self.inst,doer,right_click) or false
        end
        return false
    end

    function fwd_in_pdt_com_special_workable:AddTestFn(index_str,fn)
        if type(fn) == "function" and type(index_str) =="string" then 
            self.test_fns[index_str] = fn
        end
    end

    function fwd_in_pdt_com_special_workable:SetTestIndex(index_str)
        self:SetSimpleData("test_index",tostring(index_str))
    end
------------------------------------------------------------------------------------------------------------
--- 交互执行的时候
    function fwd_in_pdt_com_special_workable:OnWork(doer)         ---- 给 action 组件调用
        if self.on_work_fns[tostring(self:GetSimpleData("on_work_index"))] then
            return self.on_work_fns[tostring(self:GetSimpleData("on_work_index"))](self.inst,doer)
        end
        return false
    end
    function fwd_in_pdt_com_special_workable:AddOnWorkFn(index_str,fn)        --- 添加执行函数
        if type(fn) == "function" and type(index_str) == "string" then
            self.on_work_fns[index_str] = fn
        end
    end
    function fwd_in_pdt_com_special_workable:SetOnWorkIndex(index_str)        --- 给server 端设置切换 执行函数
        self:SetSimpleData("on_work_index",tostring(index_str))
    end
------------------------------------------------------------------------------------------------------------
--- 设置动作SG
    function fwd_in_pdt_com_special_workable:GetSGAction()
        return self.sg_action[tostring(self:GetSimpleData("sg"))] or "dolongaction" 
    end

    function fwd_in_pdt_com_special_workable:AddSGAction(str)
        if type(str) == "string" then
            self.sg_action[str] = str
        end
    end
    function fwd_in_pdt_com_special_workable:SetSGAction(str)
        self:SetSimpleData("sg",tostring(str))
    end
------------------------------------------------------------------------------------------------------------
--- 设置动作显示的名字
    function fwd_in_pdt_com_special_workable:GetActionDisplayStrIndex()       --- 给action组件用的
        return self.work_action_str_index[self:GetSimpleData("action_str_index")] or "DEFAULT"
    end
    function fwd_in_pdt_com_special_workable:AddActionDisplayStrIndex(str)    --- 添加文本的index
        if type(str) == "string" then
            self.work_action_str_index[string.upper(str)] = string.upper(str)
        end
    end

    function fwd_in_pdt_com_special_workable:SetActionDisplayStrByIndex(index_str)        --- 给server 端切换用
        self:SetSimpleData("action_str_index",string.upper(tostring(index_str)))
    end

    function fwd_in_pdt_com_special_workable:AddActionDisplayStr(index,action_name)       ---- 一起添加index 和文本
        if type(index) ~= "string" or type("action_name") ~= "string" then
            return
        end
        index = string.upper(index)
        if STRINGS.ACTIONS[string.upper("fwd_in_pdt_com_special_workable_action")][index] and STRINGS.ACTIONS[string.upper("fwd_in_pdt_com_special_workable_action")][index] ~= action_name then
            print("Error : fwd_in_pdt_com_special_workable:AddActionDisplayStr ,Action text display is overwritten",self.inst,index,action_name)
        end
        STRINGS.ACTIONS[string.upper("fwd_in_pdt_com_special_workable_action")][index] = action_name     ---- 添加到文本库
        self:AddActionDisplayStrIndex(index)
    end
------------------------------------------------------------------------------------------------------------
--- 配置是否可以切换到别的动作
    function fwd_in_pdt_com_special_workable:GetSGActionInserIndex()    
        return self.inser_table_index[tostring(self:GetSimpleData("inser_index"))] or string.upper("fwd_in_pdt_com_special_workable_action")
    end

    function fwd_in_pdt_com_special_workable:AddSGActionInserIndex(str)
        if type(str) == "string" then
            self.inser_table_index[string.upper(str)] = string.upper(str)
        end
    end

    function fwd_in_pdt_com_special_workable:SetSGActionInserIndex(str)
        self:SetSimpleData("inser_index",string.upper(tostring(str)))    
    end
------------------------------------------------------------------------------------------------------------
--- 配置动作之前的预执行函数
    function fwd_in_pdt_com_special_workable:AddPreActionFn(index_str,fn)
        if type(index_str) == "string" and type(fn) == "function" then
            self.pre_action_fns[index_str] = fn
        end
    end
    
    function fwd_in_pdt_com_special_workable:SetPreActionIndex(index_str)
        self:SetSimpleData("pre_action",tostring(index_str))
    end
    function fwd_in_pdt_com_special_workable:DoPreActionFn(doer)
        if self.pre_action_fns[tostring(self:GetSimpleData("pre_action"))] then
            self.pre_action_fns[tostring(self:GetSimpleData("pre_action"))](self.inst,doer)
        end
    end

------------------------------------------------------------------------------------------------------------


return fwd_in_pdt_com_special_workable




