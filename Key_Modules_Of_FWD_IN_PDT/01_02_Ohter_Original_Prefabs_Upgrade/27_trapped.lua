-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    监听青蛙捕捉，即使捕捉也得正常计数和分裂

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit(
    "frog",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
-- 回调函数

--- 监听捕捉的瞬间
        inst:ListenForEvent("trapped",function()
            -- 不需要判断青蛙了 那个地方有判断
                inst:PushEvent("fwd_in_pdt_event.frog_split")
            
        end)
    end)

    --         if inst:HasTag("fwd_in_pdt_tag.mutant_frog") then  -- 必须没有这个tag 才能进行下去
    --             return
    --         end
    --         ----------------------------------------------------------------------------------
    --         ---- 玩家杀一定数量的青蛙  必出二蛤
    --             local must_transfrom_flag = false
    --             if _table and _table.afflicter and _table.afflicter:HasTag("player") then
    --                 -- print("+++++++++++",_table.cause,_table.afflicter)
    --                 local player = _table.afflicter
    --                 if player.components.fwd_in_pdt_data then
    --                     if player.components.fwd_in_pdt_data:Add("fwd_in_pdt_animal_frog_hound.flag_num",1) >= 20 then   --- 20 只

    --                         must_transfrom_flag = true

    --                         player.components.fwd_in_pdt_data:Set("fwd_in_pdt_animal_frog_hound.flag_num",0)
    --                     end
    --                     if math.random(1000)/1000 > 0.999 and not must_transfrom_flag then   --- 击杀单个是20%分裂 概率在这设计  然后再触发分裂事件
    --                         return
    --                     end

    --                     inst:PushEvent("fwd_in_pdt_event.frog_split") --- 再执行分裂事件  放在计数后逻辑才是正确的

    --                 end
    --             end
    --     end)
    -- end)