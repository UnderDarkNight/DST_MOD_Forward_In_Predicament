----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_play_flute = Class(function(self, inst)
    self.inst = inst
    self.spell = nil
    self.canspell = true
end)
---------------------------------------------------------------------------------

function fwd_in_pdt_com_play_flute:SetSpellFn(fn)
    -- self.spell(self.inst, doer, target)
    self.spell = fn
end

function fwd_in_pdt_com_play_flute:CastSpell(doer)
    if self.spell ~= nil then
        self.spell(self.inst, doer)
    end
end
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
return fwd_in_pdt_com_play_flute
