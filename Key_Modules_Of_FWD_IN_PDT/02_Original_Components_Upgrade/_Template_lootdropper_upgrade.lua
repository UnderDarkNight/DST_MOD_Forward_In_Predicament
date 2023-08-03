----- 可被玩家搬动的物品拥有的重量组件
AddComponentPostInit("lootdropper", function(self)
    if not TheWorld.ismastersim then
        return
    end

    -- self.GenerateLoot___npc_old = self.GenerateLoot
    -- self.GenerateLoot = function(self,...)
    --     if self.inst and self.inst.components.inventoryitem and self.inst.components.health then
    --         TheWorld:PushEvent("entity_death_npc_in_container",{ inst = self.inst })
    --     end
    --     local ret = {self:GenerateLoot___npc_old(...) }
    --     return unpack(ret)
    -- end

end)