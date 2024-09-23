return function(inst)

    if not TheWorld.ismastersim then 
        return
    end  
---- 复活的时候 1000 血量
    inst:ListenForEvent("ms_respawnedfromghost",function(inst)
        inst:DoTaskInTime(1,function ()
            if inst:HasTag("fwd_in_pdt_carl") then
                inst.components.health:SetPercent(0.5)  -- 这里不要用current 这个  不知道为什么不生效  感觉这个设置只能是 活着状态下
            end
        end)
    end)
end



