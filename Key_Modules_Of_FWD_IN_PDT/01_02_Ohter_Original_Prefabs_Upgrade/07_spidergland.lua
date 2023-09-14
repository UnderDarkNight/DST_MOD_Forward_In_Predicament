------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 蜘蛛腺体。 玩家用够3个后解蜘蛛毒

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "spidergland",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.healer then
            inst.components.healer.Heal_old_fwd_in_pdt = inst.components.healer.Heal
            inst.components.healer.Heal = function(self,target,...)
                local ret = self:Heal_old_fwd_in_pdt(target,...)
                if ret and target and target:HasTag("player") and target.components.fwd_in_pdt_wellness then
                    local num = target.components.fwd_in_pdt_wellness:Add("spidergland_used_num",1)
                    if num >= 3 then
                        target.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_spider_poison")
                        target.components.fwd_in_pdt_wellness:Set("spidergland_used_num",0)
                    end
                end
                return ret
            end


        end

    end
)