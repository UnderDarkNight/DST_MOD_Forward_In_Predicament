-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    青蛙分裂事件  给minhealth 和 trapped 事件触发的时候调用

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit(

    "frog",
    
    function(inst)
    if not TheWorld.ismastersim then
        return
    end


    -- worker:PushEvent("finishedwork", { target = self.inst, action = self.action })
    inst:ListenForEvent("fwd_in_pdt_event.frog_split",function(_,_table)
        
        if inst:HasTag("fwd_in_pdt_tag.mutant_frog") then
            return
        end

        local x,y,z = inst.Transform:GetWorldPosition()
        inst:Remove()
        SpawnPrefab("fwd_in_pdt_fx_explode"):PushEvent("Set",{
            pt = Vector3(x,y,z),
            scale = 1.5,
            color = Vector3(0,255,0),
            MultColour_Flag = true,
        })

        local monster = SpawnPrefab("fwd_in_pdt_animal_frog_hound")
        monster.Transform:SetPosition(x, y, z)
        local player = monster:GetNearestPlayer(true)
        if player and monster:GetDistanceSqToInst(player) < 30*30 then
            monster.components.combat:SuggestTarget(player)
        end


    end)


end)