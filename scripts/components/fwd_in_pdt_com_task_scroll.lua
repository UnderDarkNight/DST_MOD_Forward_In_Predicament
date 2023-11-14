---------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    本模块 配合 replica  使用

        · self:Add_Submit_Fn(fn)        fn(inst,doer)

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_task_scroll = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.task_submit_fn = nil




    

end)
-------------------------------------------------------------------------------------------
---- 配置数据
    function fwd_in_pdt_com_task_scroll:Init(cmd_table)
        if type(cmd_table) ~= "table" then
            return
        end
        ------------------------------------------------
            -- local json_string = json.encode(cmd_table)
            -- self.json_str_net_string = json_string
            local com = self.inst.replica.fwd_in_pdt_com_task_scroll or self.inst.replica._.fwd_in_pdt_com_task_scroll
            if com then
                com:Data_Synchronization(cmd_table)
            end
        ------------------------------------------------
        

        self.DataTable = cmd_table
    end
-------------------------------------------------------------------------------------------
---- 打开
    function fwd_in_pdt_com_task_scroll:Open(doer)
        local com = self.inst.replica.fwd_in_pdt_com_task_scroll or self.inst.replica._.fwd_in_pdt_com_task_scroll        
        if com then
            com:Open(doer) 
        end
    end
-------------------------------------------------------------------------------------------
---- 完成任务
    function fwd_in_pdt_com_task_scroll:Add_Submit_Fn(fn)   --- 添加任务函数
        if type(fn) == "function" then
            self.task_submit_fn = fn
        end
    end
    function fwd_in_pdt_com_task_scroll:Submit_Task(doer)   --- 执行任务运行函数
        if type(self.task_submit_fn) == "function" then
            self.task_submit_fn(self.inst,doer)
        end
    end
-------------------------------------------------------------------------------------------



return fwd_in_pdt_com_task_scroll