return function(inst)
    if not TheWorld.ismastersim then 
        return
    end  
---- 复活的时候500 血量
inst:ListenForEvent("ms_respawnedfromghost",function(inst)
    inst.components.health.current = 500
    end)
end


