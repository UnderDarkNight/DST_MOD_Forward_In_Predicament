--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    消耗 70 点血 。放置 区域

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)


    if not TheWorld.ismastersim then
        return
    end

    local SPELL_HUNGER_COST = 70

    inst:ListenForEvent("fwd_in_pdt_spell_key_a_press",function(inst)
        
        local current_health = inst.components.health.currenthealth
        if current_health > SPELL_HUNGER_COST then
            inst.components.health.currenthealth = current_health - SPELL_HUNGER_COST
            local hunger_value = inst.components.hunger.current
            ------- 90%的 饥饿值作为时间。
            inst.components.hunger.current = 0.1*hunger_value

            inst.components.health:DoDelta(0.1)
            inst.components.hunger:DoDelta(0.1,true)

            local ex_time = math.ceil( (hunger_value*0.9)/50 )

            SpawnPrefab("fwd_in_pdt_spell_time_stopper"):PushEvent("Set",{
                target = inst,
                range = 30,
                time = 20 + ex_time,
            })

            inst:PushEvent("fwd_in_pdt.drawing.display",{
                bank = "fwd_in_pdt_drawing_cyclone_spell_a",
                build = "fwd_in_pdt_drawing_cyclone_spell_a",
                anim = "idle",
                location = 9,
                pt = Vector3(0,0),
                scale = 0.7,
            })

        else
            ---- spell fail
            inst.components.fwd_in_pdt_func:Wisper({
                m_colour = {255,0,0} ,                          ---- 内容颜色
                message = GetStringsTable(inst.prefab)["spell_a_fail"] or "ABCDEFG",                            ---- 文字内容
            })
            inst.components.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_spell.fail")
        end

    end)


end