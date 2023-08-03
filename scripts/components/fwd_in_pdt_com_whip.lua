----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 鞭子动作组件
-- 需要在  TheWorld.ismastersim return 前加载，为的是 fwd_in_pdt_com_whip：CanCastSpell（） 给client 动作 和 动作文本
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_whip = Class(function(self, inst)
    self.inst = inst
    self.spell = nil
    self.canspell = true
end)
---------------------------------------------------------------------------------

function fwd_in_pdt_com_whip:SetSpellFn(fn)
    -- self.spell(self.inst, doer, target)
    self.spell = fn
end

function fwd_in_pdt_com_whip:CastSpell(doer,target)
    if self.spell ~= nil then
        self.spell(self.inst, doer, target)
    end
end
---------------------------------------------------------------------------------
function fwd_in_pdt_com_whip:SetCanCastSpellFn(fn)
    -- local ret , action = self.__can_cast_spell_fn(self.inst,doer,target)
    self.__can_cast_spell_fn = fn
end
function fwd_in_pdt_com_whip:CanCastSpell(doer,target)
    if self.__can_cast_spell_fn then
        local ret , action = self.__can_cast_spell_fn(self.inst,doer,target)
        return  ret or false , action
    end
    return false,nil
end
---------------------------------------------------------------------------------
return fwd_in_pdt_com_whip
