----------------------------------------------------------------------------------------------------------------------------------
--[[

    装饰品系统

    装饰品系统：{
        {decoration_id,x,y},    
    }

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetReplica(self)
        return self.inst.replica.fwd_in_pdt_building_decoration_system or self.inst.replica._.fwd_in_pdt_building_decoration_system
    end
    local function SetDecorations(self,data)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetDecorations(data)
        end        
    end
    local function SetOwner(self,owner)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetOwner(owner)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_building_decoration_system = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    ------------------------------------------------------
    ---
        self.decorations = {}
        self:AddOnSaveFn(function()
            self:Set("decorations",self.decorations)
        end)
        self:AddOnLoadFn(function()
            self.decorations = self:Get("decorations",{})
        end)
    ------------------------------------------------------
    ---
        self.owner = nil
    ------------------------------------------------------

end,
nil,
{
    decorations = SetDecorations,
    owner = SetOwner
})
------------------------------------------------------------------------------------------------------------------------------
--- 
    function fwd_in_pdt_building_decoration_system:SetDecorations(data)
        self.decorations = data
    end
    function fwd_in_pdt_building_decoration_system:GetDecorations()
        return self.decorations
    end
    function fwd_in_pdt_building_decoration_system:SetOwner(owner)
        self.owner = owner
    end
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function fwd_in_pdt_building_decoration_system:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function fwd_in_pdt_building_decoration_system:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function fwd_in_pdt_building_decoration_system:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function fwd_in_pdt_building_decoration_system:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function fwd_in_pdt_building_decoration_system:Get(index,default)
        if index then
            return self.DataTable[index] or default
        end
        return nil or default
    end
    function fwd_in_pdt_building_decoration_system:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function fwd_in_pdt_building_decoration_system:Add(index,num,min,max)
        if index then
            if min and max then
                local ret = (self.DataTable[index] or 0) + ( num or 0 )
                ret = math.clamp(ret,min,max)
                self.DataTable[index] = ret
                return ret
            else
                self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
                return self.DataTable[index]
            end
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
--- save/load
    function fwd_in_pdt_building_decoration_system:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function fwd_in_pdt_building_decoration_system:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_building_decoration_system







