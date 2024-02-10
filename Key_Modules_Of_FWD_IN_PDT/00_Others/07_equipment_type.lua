---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    自动获取装备类型

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

TUNING["Forward_In_Predicament.equip_slot"] = TUNING["Forward_In_Predicament.equip_slot"] or {}

-------------------------------------------------------------------------------------------------------------------
---- 背包
    TUNING["Forward_In_Predicament.equip_slot"].GetBackpackType = function(self)
        
        if self.backpack_type then
            return self.backpack_type
        end

        local temp_inst = SpawnPrefab("backpack")
        self.backpack_type = temp_inst.components.equippable.equipslot
        temp_inst:Remove()
        return self.backpack_type
    end
-------------------------------------------------------------------------------------------------------------------
---- 项链
    TUNING["Forward_In_Predicament.equip_slot"].GetAmuletType = function(self)
        
        if self.amulet_type then
            return self.amulet_type
        end

        local temp_inst = SpawnPrefab("amulet")
        self.amulet_type = temp_inst.components.equippable.equipslot
        temp_inst:Remove()
        return self.amulet_type
    end
-------------------------------------------------------------------------------------------------------------------
---- armor 盔甲
    TUNING["Forward_In_Predicament.equip_slot"].GetArmorType = function(self)
        
        if self.armor_type then
            return self.armor_type
        end

        local temp_inst = SpawnPrefab("armormarble")
        self.armor_type = temp_inst.components.equippable.equipslot
        temp_inst:Remove()
        return self.armor_type
    end
-------------------------------------------------------------------------------------------------------------------
