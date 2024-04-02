----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectable_spell_caster = Class(function(self, inst)
    self.inst = inst

end,
nil,
{

})
----------------------------------------------------------------------------------------------------------------------------------
----
    function fwd_in_pdt_com_inspectable_spell_caster:SetSpellFn(fn)
        self.spell_fn = fn
    end
    function fwd_in_pdt_com_inspectable_spell_caster:CastSpell(target)
        if self.spell_fn then
            return self.spell_fn(self.inst, target)
        end
        return false
    end
----------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectable_spell_caster