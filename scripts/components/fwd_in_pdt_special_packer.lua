----------------------------------------------------------------------------------------------------------------------------------
--[[
    给动作交互、Test 函数调取用的
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_special_packer = Class(function(self, inst)
    self.inst = inst
    inst:AddTag("fwd_in_pdt_special_packer")
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------

    function fwd_in_pdt_special_packer:SetTestFn(fn)
        if type(fn) == "function" then
            self.test_fn = fn
        end
    end
    function fwd_in_pdt_special_packer:Test(target)
        if self.test_fn then
            return self.test_fn(target)
        end
        return false
    end

------------------------------------------------------------------------------------------------------------------------------
    function fwd_in_pdt_special_packer:SetPackFn(fn)
        if type(fn) == "function" then
            self.pack_fn = fn
        end
    end
    function fwd_in_pdt_special_packer:Pack(target)
        if self.pack_fn then
            return self.pack_fn(target)
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_special_packer








------------------------------------------------------------------------------------------------------------------------------
-------- 测试 
--------方案 1 ：函数 RegisterStaticComponentUpdate     RegisterStaticComponentLongUpdate 注册 ， 但是不能停止。进入参数只有dt,没有self。
--------方案 2 ： inst:StartUpdatingComponent(com,do_static_update)  和  inst:StopUpdatingComponent(com)

-------- Update 刷新以 30FPS
-------- LongUpdate : 并不是实时刷新。inst重新进入玩家加载范围内才会执行（未能成功测试）。 配合  DoTaskInTime 执行。
-------- DoPeriodicTask  不受到加载范围的限制。
-- function fwd_in_pdt_special_packer:LongUpdate(dt)
--     print("fwd_in_pdt_special_packer LongUpdate test",dt,math.random(100) )
-- end
-- function fwd_in_pdt_special_packer:OnUpdate(dt)
--     print("fwd_in_pdt_special_packer OnUpdate test",dt,math.random(100) )
-- end

-- ---- 方案2
-- fwd_in_pdt_special_packer.OnUpdate = function(dt)
--     print("fwd_in_pdt_special_packer OnUpdate test",dt,math.random(100) )    
-- end
-- RegisterStaticComponentLongUpdate(fwd_in_pdt_special_packer,fwd_in_pdt_special_packer.OnUpdate)
------------------------------------------------------------------------------------------------------------------------------