------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 帝王蟹掉落 填海叉蓝图
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit(
    "crabking",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("death",function()
            if inst.components.lootdropper then
                inst.components.lootdropper:SpawnLootPrefab("fwd_in_pdt_equipment_ocean_fork_blueprint")
                -- local loot = inst.components.lootdropper.loot or {}
                --     table.insert(loot,"fwd_in_pdt_equipment_ocean_fork_blueprint")
                -- inst.components.lootdropper.loot = loot
            end
        end)

    end
)



