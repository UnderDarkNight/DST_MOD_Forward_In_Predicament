-- 击杀亮茄10%概率掉落亮茄涂层


AddPrefabPostInit(
    "lunarthrall_plant",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("death",function()
            if inst.components.lootdropper then
                if math.random(100) <= 10 then
                    inst.components.lootdropper:SpawnLootPrefab("fwd_in_pdt_item_avoidable_lunarthrall_plant")
                end
            end
        end)

    end
)