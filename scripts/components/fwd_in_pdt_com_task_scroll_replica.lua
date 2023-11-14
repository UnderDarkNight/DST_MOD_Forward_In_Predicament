---------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本模块给商店使用，配合replica启用
--- 通过replica 下发商品列表
--[[


]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_task_scroll = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}


    --------------------------------------------------------------------------------------------------------------------
        self.___net_entity = net_entity(inst.GUID, "fwd_in_pdt_com_task_scroll_com", "fwd_in_pdt_com_task_scroll_com")
        self.inst:ListenForEvent("fwd_in_pdt_com_task_scroll_com",function()
            local temp_inst = self.___net_entity:value()
            if temp_inst and temp_inst:HasTag("player") then
                self:OpenWidget(temp_inst)
            end
        end)
    --------------------------------------------------------------------------------------------------------------------
        self.___net_json_string = net_string(inst.GUID,"fwd_in_pdt_com_task_scroll_json_str","fwd_in_pdt_com_task_scroll_json_str")
        self.inst:ListenForEvent("fwd_in_pdt_com_task_scroll_json_str",function()
            local json_str = self.___net_json_string:value()
            local crash_flag , data_table = pcall(json.decode,json_str)
            if crash_flag then
                self.DataTable = data_table
            end
        end)
    --------------------------------------------------------------------------------------------------------------------

end)
----------------------------------------------------------------------------------------
----- 数据传送到replica
    function fwd_in_pdt_com_task_scroll:Data_Synchronization(data_table)
        self.___net_json_string:set(json.encode(data_table))
    end
    function fwd_in_pdt_com_task_scroll:Open(doer)      --- 走 net_vars 下发数据
        self.___net_entity:set(doer)
        self.inst:DoTaskInTime(0.5,function()
            self.___net_entity:set(self.inst)
        end)
    end
----------------------------------------------------------------------------------------
    function fwd_in_pdt_com_task_scroll:OpenWidget(doer)
        if ThePlayer and ThePlayer == doer then
            ThePlayer.HUD:fwd_in_pdt_task_scroll_widget_open(self.inst,self.DataTable)
        end
    end
----------------------------------------------------------------------------------------
---- 按钮
    function fwd_in_pdt_com_task_scroll:FinishButtonClick(doer)
        if self.inst.components.fwd_in_pdt_com_task_scroll then
            self.inst.components.fwd_in_pdt_com_task_scroll:Submit_Task(doer)
        else
            SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["fwd_in_pdt_com_task_scroll.client2server"],self.inst)
        end
    end
----------------------------------------------------------------------------------------

return fwd_in_pdt_com_task_scroll