-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --[[



-- ]]--
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    
    inst:ListenForEvent("cyclone_master_postinit",function(inst)

        local temp_sound = nil
        local state_fns = {
            ["run_start"] = function()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado","tornado_walk",0.2)
            end,
            ["run_stop"] = function()
                inst.SoundEmitter:KillSound("tornado_walk")
            end,
            ["idle"] = function()
                inst.SoundEmitter:KillSound("tornado_walk")
                inst.SoundEmitter:KillSound("tornado_idle")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado","tornado_idle",0.1)
            end,
            ["heavy_walk"] = function()
                inst.SoundEmitter:KillSound("tornado_idle")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado","tornado_walk",0.1)
            end,
            ["careful_walk"] = function()
                inst.SoundEmitter:KillSound("tornado_idle")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado","tornado_walk",0.1)
            end,
        }
        inst:ListenForEvent("newstate",function(_,_table)
            local statename = _table and _table.statename
            if not statename then
                return
            end

            if state_fns[statename] then
                state_fns[statename]()
            end

        end)

    end)

end