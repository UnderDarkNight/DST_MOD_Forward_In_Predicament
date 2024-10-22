----------------------------------------------------------------------------------------------------------------------------------------
--[[

    青蛙死的时候有几率变成二蛤

]]--
----------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "frog",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end



        inst:ListenForEvent("minhealth",function(_,_table)  --- 监听杀死的瞬间

            

            if inst:HasTag("fwd_in_pdt_tag.mutant_frog") then  -- 必须没有这个tag 才能进行下去
                return
            end
            ----------------------------------------------------------------------------------
            -- 计数器
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
            -- 概率器(触发死亡监听用的，must_transfrom_flag要true)
                if math.random(1000)/1000 <= 0.2  then   --- 击杀单个是20%分裂 概率在这设计  然后再触发分裂事件

                    must_transfrom_flag = true
                end
            ----------------------------------------------------------------------------------
            -- 执行器
                if must_transfrom_flag then

                    inst:PushEvent("fwd_in_pdt_event.frog_split") --- 满足了must_transfrom_flag再执行分裂事件  放在计数后逻辑才是正确的

                end
            ----------------------------------------------------------------------------------
        end)
end)