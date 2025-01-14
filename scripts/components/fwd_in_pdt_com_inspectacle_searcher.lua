----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetReplica(self)
        return self.inst.replica.fwd_in_pdt_com_inspectacle_searcher or self.inst.replica._.fwd_in_pdt_com_inspectacle_searcher
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectacle_searcher = Class(function(self, inst)
    self.inst = inst
    inst:AddTag("fwd_in_pdt_com_inspectacle_searcher")
    ----------------------------------------------------------------
    --- 数据表
        self.DataTable = {}
        self.TempTable = {}
        self._onload_fns = {}
        self._onsave_fns = {}
    ----------------------------------------------------------------
    --- 
        self.owner = nil
    ----------------------------------------------------------------
    ---
    ----------------------------------------------------------------
end,
nil,
{
})
------------------------------------------------------------------------------------------------------------------------------
--- RPC
    function fwd_in_pdt_com_inspectacle_searcher:GetRPC()
        if self.owner and self.owner.components.fwd_in_pdt_com_rpc_event then
            return self.owner.components.fwd_in_pdt_com_rpc_event
        end
        return nil
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function fwd_in_pdt_com_inspectacle_searcher:Active(doer)
        self.__active_task = self.inst:DoPeriodicTask(0.5,function()
            if doer and doer.components.playercontroller and doer.components.playercontroller:IsEnabled() then
                self.owner = doer
                local rpc = self:GetRPC()
                if rpc then
                    rpc:PushEvent("inspectacle_searcher_active",{userid = doer.userid}, self.inst)
                    self.__active_task:Cancel()
                    self.__active_task = nil
                end
            end
        end)
        -- self.inst:DoTaskInTime(0,function()
        --     self.owner = doer
        --     local rpc = self:GetRPC()
        --     if rpc then
        --         rpc:PushEvent("inspectacle_searcher_active",{userid = doer.userid}, self.inst)
        --     end
        -- end)
    end
    function fwd_in_pdt_com_inspectacle_searcher:Deactive()
        if self.__active_task then
            self.__active_task:Cancel()
            self.__active_task = nil
        end
        local rpc = self:GetRPC()
        if rpc then
            rpc:PushEvent("inspectacle_searcher_deactive",{userid = self.owner.userid}, self.inst)
        end
        self.owner = nil
    end
    function fwd_in_pdt_com_inspectacle_searcher:GetOwner()
        return self.owner
    end
------------------------------------------------------------------------------------------------------------------------------
---
------------------------------------------------------------------------------------------------------------------------------


----- onload/onsave 函数
    function fwd_in_pdt_com_inspectacle_searcher:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function fwd_in_pdt_com_inspectacle_searcher:Get(index,default)
        if index then
            return self.DataTable[index] or default
        end
        return nil
    end
    function fwd_in_pdt_com_inspectacle_searcher:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function fwd_in_pdt_com_inspectacle_searcher:Add(index,num,min,max)
        if index then
            if not min and not max then
                self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
                return self.DataTable[index]
            elseif type(min) == "number" and type(max) == "number" then
                local ret = math.clamp( (self.DataTable[index] or 0) + ( num or 0 ) , min , max )
                self.DataTable[index] = ret
                return ret
            end
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function fwd_in_pdt_com_inspectacle_searcher:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function fwd_in_pdt_com_inspectacle_searcher:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectacle_searcher







