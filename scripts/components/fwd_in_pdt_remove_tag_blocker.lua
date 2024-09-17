----------------------------------------------------------------------------------------------------------------------------------
--[[

     tag 屏蔽器   防止别的mod移除原本是负重的tag用的

]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_remove_tag_blocker = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    -------------------------------------------------------------------
    --- 核心列表
        self.temp_list = {}     --- 临时的列表
        self.saved_list = {}     --- 跟随存档保存的、穿越洞穴不丟失的

        self:AddOnSaveFn(function()
            self:Set("saved_list",self.saved_list)
        end)
        self:AddOnLoadFn(function()
            local temp_list = self:Get("saved_list") or {}
            for tag, flag in pairs(temp_list) do        -- 处理加载期间的屏蔽状态数据冲突 不能一次性全部覆盖
                if flag then
                    self.saved_list[tag] = true
                end
            end
        end)

    -------------------------------------------------------------------
    --- hook 进官方函数
        local old_RemoveTag = inst.RemoveTag
        inst.RemoveTag = function(_, tag,...)
            if self:Check_Tag_Is_Blocking(tag) then
                return
            end
            return old_RemoveTag(_, tag,...)
        end
    -------------------------------------------------------------------

end,
nil,
{

})
----------------------------------------------------------------------------------------------------------------------------------
---- 
    function fwd_in_pdt_remove_tag_blocker:Add(tag)  -- 临时的
        self.temp_list[tag] = true
    end
    function fwd_in_pdt_remove_tag_blocker:Add_With_Save(tag)  -- 永久保存的
        self.saved_list[tag] = true
    end
    function fwd_in_pdt_remove_tag_blocker:Remove(tag)  -- 移除(临时和永久的放一起、自动判断)
        if self.temp_list[tag] then
            self.temp_list[tag] = nil
        end
        if self.saved_list[tag] then
            self.saved_list[tag] = nil
        end
    end

    function fwd_in_pdt_remove_tag_blocker:Check_Tag_Is_Blocking(tag)  -- 检查是否被阻止
        if self.temp_list[tag] or self.saved_list[tag] then
            return true
        end
        return false
    end
----------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function fwd_in_pdt_remove_tag_blocker:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function fwd_in_pdt_remove_tag_blocker:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function fwd_in_pdt_remove_tag_blocker:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function fwd_in_pdt_remove_tag_blocker:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function fwd_in_pdt_remove_tag_blocker:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function fwd_in_pdt_remove_tag_blocker:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function fwd_in_pdt_remove_tag_blocker:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function fwd_in_pdt_remove_tag_blocker:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function fwd_in_pdt_remove_tag_blocker:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_remove_tag_blocker







