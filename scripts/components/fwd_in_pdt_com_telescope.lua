----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_telescope = Class(function(self, inst)
    self.inst = inst
    self.spell = nil
    self.canspell = true
end)
---------------------------------------------------------------------------------

function fwd_in_pdt_com_telescope:SetSpellFn(fn)
    -- self.spell(self.inst, doer, target)
    self.spell = fn
end

function fwd_in_pdt_com_telescope:CastSpell(doer,pt)
    if self.spell ~= nil then
        self.spell(self.inst, doer, pt)
    end
end
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
return fwd_in_pdt_com_telescope