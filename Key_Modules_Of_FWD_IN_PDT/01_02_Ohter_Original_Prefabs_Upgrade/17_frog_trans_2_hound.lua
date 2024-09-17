----------------------------------------------------------------------------------------------------------------------------------------
--[[

    青蛙死的时候有几率变成 狗

]]--
----------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "frog",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end



        inst:ListenForEvent("minhealth",function(_,_table)  --- 被杀死的瞬间  裂变
            if inst:HasTag("fwd_in_pdt_tag.mutant_frog") then
                return
            end
            ----------------------------------------------------------------------------------
            ---- 玩家杀一定数量的青蛙  必出二蛤
                local must_transfrom_flag = false
                if _table and _table.afflicter and _table.afflicter:HasTag("player") then
                    -- print("+++++++++++",_table.cause,_table.afflicter)
                    local player = _table.afflicter
                    if player.components.fwd_in_pdt_data then
                        if player.components.fwd_in_pdt_data:Add("fwd_in_pdt_animal_frog_hound.flag_num",1) >= 20 then   --- 20 只
                            must_transfrom_flag = true
                            player.components.fwd_in_pdt_data:Set("fwd_in_pdt_animal_frog_hound.flag_num",0)
                        end
                    end
                end
            ----------------------------------------------------------------------------------



            if math.random(1000)/1000 > 0.2 and not must_transfrom_flag then
                return
            end
    
            local x,y,z = inst.Transform:GetWorldPosition()
            inst:Remove()
            SpawnPrefab("fwd_in_pdt_fx_explode"):PushEvent("Set",{
                pt = Vector3(x,y,z),
                scale = 1.5,
                color = Vector3(0,255,0),
                MultColour_Flag = true,
            })

            local monster = SpawnPrefab("fwd_in_pdt_animal_frog_hound")
            monster.Transform:SetPosition(x, y, z)
            local player = monster:GetNearestPlayer(true)
            if player and monster:GetDistanceSqToInst(player) < 30*30 then
                monster.components.combat:SuggestTarget(player)
            end

    
        end)


    end)