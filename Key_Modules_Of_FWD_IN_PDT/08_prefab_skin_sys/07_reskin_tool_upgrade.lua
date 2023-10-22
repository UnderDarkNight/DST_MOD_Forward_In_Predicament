--------------------------------------------------------------------------------------------------------------------------------------------
---- 清洁扫把 扫皮肤

--------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "reskin_tool",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        -- local spellcaster = inst.components.spellcaster
        -- spellcaster.can_cast_fn__fwd_in_pdt_old = spellcaster.can_cast_fn
        -- spellcaster.can_cast_fn = function(doer,target,pos)
        --     if target and target:HasTag("fwd_in_pdt_com_skins") then
        --         return true
        --     else
        --         return spellcaster.can_cast_fn__fwd_in_pdt_old(doer,target,pos)
        --     end
        -- end

        -- spellcaster.CastSpell__fwd_in_pdt_old = spellcaster.CastSpell
        -- spellcaster.CastSpell = function(self,target, pos, doer)
        --     if target and target.components.fwd_in_pdt_com_skins and doer and doer.components.fwd_in_pdt_com_skins then
        --         doer.components.fwd_in_pdt_com_skins:SetNextSkin(target)
        --     else
        --         return self:CastSpell__fwd_in_pdt_old(target, pos, doer)
        --     end
        -- end
        
        inst:AddComponent("fwd_in_pdt_com_skins_tool")

    end
)