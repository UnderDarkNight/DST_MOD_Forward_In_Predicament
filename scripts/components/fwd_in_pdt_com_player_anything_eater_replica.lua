--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

     test 函数挂到 replica
     
     
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_player_anything_eater = Class(function(self, inst)
    self.inst = inst

    self._item_test_fns = {}
    self._item_fast_eat_list = {}
end,
nil,
{

})
----------------------------------------------------------------------------------------------------------------------------------
---- player self Test
    function fwd_in_pdt_com_player_anything_eater:SetPlayerSelfTestFn(fn)
        if type(fn) == "function" then
            self._player_self_test_fn = fn
        end
    end
    function fwd_in_pdt_com_player_anything_eater:PlayerSelfTest()
        if self._player_self_test_fn then
            return self._player_self_test_fn(self.inst)
        end
        return true
    end
----------------------------------------------------------------------------------------------------------------------------------
---- item Test
    function fwd_in_pdt_com_player_anything_eater:AddItemTestFn(item_prefab,fn,fast_eat)
        if type(item_prefab) == "string" and type(fn) == "function" then
            self._item_test_fns[item_prefab] = fn
            self._item_fast_eat_list[item_prefab] = fast_eat or false
        end
    end
    function fwd_in_pdt_com_player_anything_eater:TestItem(item)
        local test_ret_flag = false
        local fast_eat_flag = false
        if not self:PlayerSelfTest() then
            return false,false
        end
        if type(item) == "table" then

            -- if not item.replica.inventoryitem:IsGrandOwner(self.inst) then  --- 强制在背包里
            --     return false,false
            -- end
            if not item.replica.inventoryitem:IsHeld() then  --- 强制在背包里
                return false,false
            end

            local item_prefab = tostring(item.prefab)
            if self._item_test_fns[item_prefab] then
                test_ret_flag = self._item_test_fns[item_prefab](item,self.inst)
            end
            if self._item_fast_eat_list[item_prefab] then
                fast_eat_flag = self._item_fast_eat_list[item_prefab]
            end
        end
        return test_ret_flag,fast_eat_flag
    end
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_player_anything_eater