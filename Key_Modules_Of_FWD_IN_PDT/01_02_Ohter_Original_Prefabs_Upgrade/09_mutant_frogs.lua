------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 升级 青蛙，可变异组件

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "frog",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end



        inst:AddComponent("fwd_in_pdt_data")
        inst:ListenForEvent("fwd_in_pdt_event.start_mutant",function()
            inst.components.fwd_in_pdt_data:Set("mutant_frog",true)
            inst.AnimState:SetMultColour(255/255,0/255,0/255,255/255)
            inst:AddTag("fwd_in_pdt_tag.mutant_frog")
        end)
        inst:DoTaskInTime(0,function()
            if inst.components.fwd_in_pdt_data:Get("mutant_frog") then
                inst:PushEvent("fwd_in_pdt_event.start_mutant")
            end
        end)

        inst:ListenForEvent("newstate",function(_,_table)
            if _table and _table.statename and _table.statename == "fall" then
                if math.random(1000) < 200 then
                    inst:PushEvent("fwd_in_pdt_event.start_mutant")
                end
            end
        end)

    end
)



