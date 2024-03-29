----------------------------------------------------------------------------------------------------------------------------------
--[[

     test 函数挂到 replica
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_player_anything_eater = Class(function(self, inst)
    self.inst = inst

    self._on_eat_fns = {}
end,
nil,
{

})


----------------------------------------------------------------------------------------------------------------------------------
---- 
    function fwd_in_pdt_com_player_anything_eater:AddItemOnEatFn(item_prefab,fn)
        if type(item_prefab) == "string" and type(fn) == "function" then
            self._on_eat_fns[item_prefab] = fn
        end
    end
    function fwd_in_pdt_com_player_anything_eater:OnEat(item)
        if type(item) == "table" then
            local item_prefab = tostring(item.prefab)
            if self._on_eat_fns[item_prefab] then
                return self._on_eat_fns[item_prefab](item,self.inst)
            end
        end
        return false
    end
----------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_player_anything_eater
