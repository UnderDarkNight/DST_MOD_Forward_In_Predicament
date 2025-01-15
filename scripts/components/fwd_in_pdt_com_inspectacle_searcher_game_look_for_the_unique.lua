----------------------------------------------------------------------------------------------------------------------------------
--[[

    找唯一物品 游戏

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetReplica(self)
        return self.inst.replica.fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique or self.inst.replica._.fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique
    end
    local function SetImageIndex(self,index)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetImageIndex(index)
        end
    end
    local function SetMaxTestNum(self,max_test_num)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetMaxTestNum(max_test_num)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    --------------------------------------------------------------
    ---
        self.index = 1
        self.max_test_num = 5
        self:AddOnLoadFn(function()
            self.index = self:Get("index", 1)
            self.max_test_num = self:Get("max_test_num", 5)
        end)
        self:AddOnSaveFn(function()
            self:Set("index", self.index)
            self:Set("max_test_num", self.max_test_num)
        end)
    --------------------------------------------------------------
end,
nil,
{
    index = SetImageIndex,
    max_test_num = SetMaxTestNum,
})
------------------------------------------------------------------------------------------------------------------------------
---
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:SetMaxTestNum(num)
        self.max_test_num = num
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:SetImageIndex(index)
        self.index = index
    end
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:Get(index,default)
        if index then
            return self.DataTable[index] or default
        end
        return nil or default
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:Add(index,num,min,max)
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

------------------------------------------------------------------------------------------------------------------------------
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique







