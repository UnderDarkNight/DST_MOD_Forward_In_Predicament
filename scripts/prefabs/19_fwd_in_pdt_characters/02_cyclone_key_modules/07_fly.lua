--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local function make_fly(inst)
        if inst.components.drownable and inst.components.drownable.enabled ~= false then
            inst.components.drownable.enabled = false
        end
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)
    end

    inst:ListenForEvent("change_2_flay",make_fly)
    inst:ListenForEvent("equip",function(inst)
        inst:DoTaskInTime(0,make_fly)
    end)
    inst:ListenForEvent("unequip",function(inst)
        inst:DoTaskInTime(0,make_fly)        
    end)
    inst:ListenForEvent("cyclone_master_postinit",make_fly)


end