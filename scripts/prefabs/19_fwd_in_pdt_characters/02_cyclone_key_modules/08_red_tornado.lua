--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    工作的时候出旋风

    被打的时候也出旋风



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    ------------------------------------------------------------------------------------------------------------------------------
        inst:ListenForEvent("create_red_tornado_for_target",function(inst,target)
            if target and target.prefab then
                local tornado = SpawnPrefab("tornado")
                tornado.AnimState:SetBuild("fwd_in_pdt_fx_tornado")
                tornado.AnimState:SetScale(0.5,0.5,0.5)                
                tornado.WINDSTAFF_CASTER = inst
                tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
                tornado.Transform:SetPosition(inst.Transform:GetWorldPosition())
                tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

                tornado.SoundEmitter:KillSound("spinLoop")
                tornado.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop",0.5)

            end
        end)
    ------------------------------------------------------------------------------------------------------------------------------
        local temp_target = nil
        local temp_target_cd_task = nil
    ------------------------------------------------------------------------------------------------------------------------------
    ---- 工作的时候出旋风
        inst:ListenForEvent("working",function(inst,_table)
            if _table and _table.target then
                local target = _table.target

                if temp_target ~= target and inst.components.hunger.current > 100 then
                    ---------------------------------------------
                    ---- 一个目标只搞一次
                        temp_target = target
                        temp_target_cd_task = inst:DoTaskInTime(5,function()
                            temp_target = nil
                            temp_target_cd_task = nil
                        end)
                    ---------------------------------------------
                        inst.components.hunger:DoDelta(-100)
                        inst:PushEvent("create_red_tornado_for_target",target)
                    ---------------------------------------------
                else
                    ---------------------------------------------
                        temp_target = nil
                        if temp_target_cd_task then
                            temp_target_cd_task:Cancel()
                            temp_target_cd_task = nil
                        end
                    ---------------------------------------------
                end
            end
        end)
    ------------------------------------------------------------------------------------------------------------------------------
    ---- 被打的时候出旋风
        inst:ListenForEvent("attacked",function(inst,_table)
            if _table and _table.attacker then
                if inst.components.hunger.current > 100 then
                    inst.components.hunger:DoDelta(-100,true)
                    inst:PushEvent("create_red_tornado_for_target",_table.attacker)
                end
            end            
        end)
    ------------------------------------------------------------------------------------------------------------------------------
end