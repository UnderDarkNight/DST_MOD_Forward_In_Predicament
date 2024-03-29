--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
    local function GetStringsTable(prefab_name)
        return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    
    inst:ListenForEvent("fwd_in_pdt_spell_key_b_press",function(inst)

        if inst.components.hunger.current < 501 then

            ---- spell fail
            inst.components.fwd_in_pdt_func:Wisper({
                m_colour = {255,0,0} ,                          ---- 内容颜色
                message = GetStringsTable(inst.prefab)["spell_b_fail"] or "ABCDEFG",                            ---- 文字内容
            })
            inst.components.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_spell.fail")

            
            return
        end

        inst.components.hunger.current = inst.components.hunger.current - 499
        inst.components.hunger:DoDelta(-1)

        inst.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_item_compressed_cyclone"))

    end)
end