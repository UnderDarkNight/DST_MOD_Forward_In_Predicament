----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_workable = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}


end,
nil,
{

})

function fwd_in_pdt_com_workable:SetCanWorlk(flag)
    if not flag then
        self.inst:AddTag("fwd_in_pdt_com_workable_can_not_work")
    else
        self.inst:RemoveTag("fwd_in_pdt_com_workable_can_not_work")
    end
end
function fwd_in_pdt_com_workable:GetCanWorlk()
    return not self.inst:HasTag("fwd_in_pdt_com_workable_can_not_work")
end

function fwd_in_pdt_com_workable:SetActiveFn(fn)
    if type(fn) == "function" then
        self.acive_fn = fn
    end
end

function fwd_in_pdt_com_workable:Active(doer)
    if self.acive_fn then
        return self.acive_fn(self.inst,doer)
    end
    return false
end

function fwd_in_pdt_com_workable:SetOnWorkFn(fn)
    self:SetActiveFn(fn)
end

return fwd_in_pdt_com_workable






