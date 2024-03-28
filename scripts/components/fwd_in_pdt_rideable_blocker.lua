----------------------------------------------------------------------------------------------------------------------------------
--[[

     屏蔽可骑行的任何组件

]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_rideable_blocker = Class(function(self, inst)
    self.inst = inst

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
------
    function fwd_in_pdt_rideable_blocker:SetOnRefuseFn(fn)
        self.__on_refuse_fn = fn
    end
    function fwd_in_pdt_rideable_blocker:ActiveRefuse(target)
        if self.__on_refuse_fn then
            self.__on_refuse_fn(self.inst,target)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_rideable_blocker







