
local function CastSpell(player)
    local function CastSpell_p(player)

    end
    local flg,ret = pcall(CastSpell_p,player)    
end

local function builder_onbuilt(inst, builder)
    -- print(inst,builder,"fake error")
	if builder then
        CastSpell(builder)
    end
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.persists = false
    inst:DoTaskInTime(0, inst.Remove)
    if not TheWorld.ismastersim then
        return inst
    end
    -- inst.OnBuiltFn = builder_onbuilt
   inst:ListenForEvent("onbuilt",function(inst,_table)
        -- print("event : onbuilt")
        if _table and _table.builder then
            builder_onbuilt(inst,_table.builder)
        end
    end)
    return inst
end

return Prefab("spell_reject_the_npc", fn)


