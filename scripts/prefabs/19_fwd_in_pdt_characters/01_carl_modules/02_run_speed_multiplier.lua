--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    移动速度：血量大于80%的时候125%。血量小于20%的时候75% 。其余 100% 

    【注意】每次掉血都会执行，注意性能问题

    体型尺寸顺便处理了。暂时无视 骑行。
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end



    inst:ListenForEvent("fwd_in_pdt_event.character.carl.run_speed",function()
        if inst:HasTag("playerghost") then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "fwd_in_pdt_carl_speed_mod")
            ------------------------------------------------------
            --- 体型过小的问题顺便处理了
                local scale = 1
                inst.AnimState:SetScale(scale,scale,scale)
            ------------------------------------------------------
        else
            local health_percent = inst.components.health:GetPercent()
            local speed = 1
            if health_percent >= 0.8 then
                speed = 1.25
            elseif health_percent < 0.2 then
                speed = 0.75
            end
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "fwd_in_pdt_carl_speed_mod", speed)
            ------------------------------------------------------
            --- 体型过小的问题顺便处理了
                local scale = 1.3
                inst.AnimState:SetScale(scale,scale,scale)
            ------------------------------------------------------
        end
    end)

    inst:DoTaskInTime(0,function()
        inst:PushEvent("fwd_in_pdt_event.character.carl.run_speed")
    end)

    inst:ListenForEvent("healthdelta",function()
        inst:PushEvent("fwd_in_pdt_event.character.carl.run_speed")
    end)


end