--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local old_PlayFootstep = rawget(_G,"PlayFootstep")
rawset(_G,"PlayFootstep",function(inst, volume, ispredicted,...)
    if inst and inst:HasTag("fwd_in_pdt_cyclone") and inst.SoundEmitter and not inst:HasTag("playerghost") then
        -- inst.SoundEmitter:PlaySound(
        --     "dontstarve_DLC001/common/tornado",
        --     nil,
        --     (volume or 1)*0.2,
        --     ispredicted
        -- )
        -- print("Playing tornado sound",volume,ispredicted)
        return
    end
    return old_PlayFootstep(inst, volume, ispredicted,...)
end)