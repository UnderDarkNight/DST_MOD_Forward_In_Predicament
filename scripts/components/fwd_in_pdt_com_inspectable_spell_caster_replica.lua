----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
STRINGS.ACTIONS.FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER = STRINGS.ACTIONS.FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER or {
    DEFAULT = STRINGS.ACTIONS.CASTSPELL.GENERIC
}
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectable_spell_caster = Class(function(self, inst)
    self.inst = inst

end,
nil,
{

})
----------------------------------------------------------------------------------------------------------------------------------
--- Test 函数
    function fwd_in_pdt_com_inspectable_spell_caster:Test(target,right_click,temp_action)
        if target == self.inst then
            return false
        end
        if self.__test_fn then
            return self.__test_fn(self.inst,target,right_click,temp_action)
        end
        return false
    end
    function fwd_in_pdt_com_inspectable_spell_caster:SetTestFn(fn)
        self.__test_fn = fn
    end
----------------------------------------------------------------------------------------------------------------------------------
--- DoPreAction 函数
    function fwd_in_pdt_com_inspectable_spell_caster:SetPreActionFn(fn)
        self.__pre_action_fn = fn
    end
    function fwd_in_pdt_com_inspectable_spell_caster:DoPreAction(target)
        if self.__pre_action_fn then
            return self.__pre_action_fn(self.inst,target)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
----
    function fwd_in_pdt_com_inspectable_spell_caster:SetSGAction(sg)
        self.sg = sg
    end
    function fwd_in_pdt_com_inspectable_spell_caster:GetSGAction()
        return self.sg or "give"
    end
----------------------------------------------------------------------------------------------------------------------------------
------ 设置显示文本
    function fwd_in_pdt_com_inspectable_spell_caster:SetText(index,str)
        index = string.upper(index)
        STRINGS.ACTIONS.FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER[index] = str
        self.str_index = index
    end
    function fwd_in_pdt_com_inspectable_spell_caster:GetTextIndex()
        return self.str_index or "DEFAULT"
    end
----------------------------------------------------------------------------------------------------------------------------------

return fwd_in_pdt_com_inspectable_spell_caster