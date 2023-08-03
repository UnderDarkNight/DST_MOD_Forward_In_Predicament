----------------------------------------------------------------------------------------------------------------------------------
-- 通用数据储存库，用来储存各种 【文本】数据
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_data = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
end,
nil,
{

})

function fwd_in_pdt_data:SaveData(DataName_Str,theData)
    if DataName_Str then
        self.DataTable[DataName_Str] = theData
    end
end

function fwd_in_pdt_data:ReadData(DataName_Str)
    if DataName_Str then
        if self.DataTable[DataName_Str] then
            return self.DataTable[DataName_Str]
        else
            return nil
        end
    end
end
function fwd_in_pdt_data:Get(DataName_Str)
    return self:ReadData(DataName_Str)
end
function fwd_in_pdt_data:Set(DataName_Str,theData)
    self:SaveData(DataName_Str, theData)
end

function fwd_in_pdt_data:Add(DataName_Str,num)
    if self:Get(DataName_Str) == nil then
        self:Set(DataName_Str, 0)
    end
    if type(num) ~= "number" or type(self:Get(DataName_Str))~="number" then
        return
    end
    self:Set(DataName_Str, self:Get(DataName_Str) + num)
    return self:Get(DataName_Str)
end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
function fwd_in_pdt_data:OnSave()
    local data =
    {
        DataTable = self.DataTable
    }

    return next(data) ~= nil and data or nil
end

function fwd_in_pdt_data:OnLoad(data)
    if data.DataTable then
        self.DataTable = data.DataTable
    end
end

return fwd_in_pdt_data








------------------------------------------------------------------------------------------------------------------------------
-------- 测试 
--------方案 1 ：函数 RegisterStaticComponentUpdate     RegisterStaticComponentLongUpdate 注册 ， 但是不能停止。进入参数只有dt,没有self。
--------方案 2 ： inst:StartUpdatingComponent(com,do_static_update)  和  inst:StopUpdatingComponent(com)

-------- Update 刷新以 30FPS
-------- LongUpdate : 并不是实时刷新。inst重新进入玩家加载范围内才会执行（未能成功测试）。 配合  DoTaskInTime 执行。
-------- DoPeriodicTask  不受到加载范围的限制。
-- function fwd_in_pdt_data:LongUpdate(dt)
--     print("fwd_in_pdt_data LongUpdate test",dt,math.random(100) )
-- end
-- function fwd_in_pdt_data:OnUpdate(dt)
--     print("fwd_in_pdt_data OnUpdate test",dt,math.random(100) )
-- end

-- ---- 方案2
-- fwd_in_pdt_data.OnUpdate = function(dt)
--     print("fwd_in_pdt_data OnUpdate test",dt,math.random(100) )    
-- end
-- RegisterStaticComponentLongUpdate(fwd_in_pdt_data,fwd_in_pdt_data.OnUpdate)
------------------------------------------------------------------------------------------------------------------------------