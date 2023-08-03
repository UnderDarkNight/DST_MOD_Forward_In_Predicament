
local function oncanspell(self,canspell)
    if canspell then
        self.inst:AddTag("los_golden_whip")
    else
        self.inst:RemoveTag("los_golden_whip")
    end
end

local los_com_golden_whip = Class(function(self, inst)
    self.inst = inst
    self.spell = nil
    self.canspell = true
end,
nil,
{
    canspell = oncanspell
})


function los_com_golden_whip:SetSpellFn(fn)
    self.spell = fn
end

function los_com_golden_whip:CastSpell(doer,target)
    if self.spell ~= nil then
        self.spell(self.inst, doer, target)
    end
end

return los_com_golden_whip
