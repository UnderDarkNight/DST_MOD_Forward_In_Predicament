-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 地图打开/关闭 控制

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)

    inst:ListenForEvent("fwd_in_pdt_event.ToggleMap",function()
        print("info fwd_in_pdt_event.ToggleMap ")
        if inst.HUD then
            inst.HUD.controls:ToggleMap()
            print("info fwd_in_pdt_event.ToggleMap 666")

        end
    end)
end)
