--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("cyclone_master_postinit",function(inst)
        
        -----------------------------------------------------------------------------------------------------------
        ---- 隐藏身上
            inst.AnimState:HideSymbol("torso")
        -----------------------------------------------------------------------------------------------------------
        ---- 创建特效跟随玩家
            local BASE_SCALE = Vector3(0.5,0.5,0.5)
            local body_fx = inst:SpawnChild("fwd_in_pdt_fx_red_tornado")
            body_fx:PushEvent("Set",{
                pt = Vector3(-0.2,-0.2,0),
                scale = BASE_SCALE,
            })
            inst.body_fx = body_fx

            inst:ListenForEvent("body_fx",function(inst,fn)
                if type(fn) == "function" then
                    fn(body_fx)
                end
            end)
            body_fx:DoTaskInTime(0.1,function()
                body_fx.AnimState:SetScale(BASE_SCALE.x,BASE_SCALE.y,BASE_SCALE.z)
            end)
            
        -----------------------------------------------------------------------------------------------------------
        ---- 根据状态修改缩放 等其他操作
            local scale_with_state = {
                ["hop_pre"] = Vector3(BASE_SCALE.x,BASE_SCALE.y*2,BASE_SCALE.z),
                ["hop_loop"] = Vector3(BASE_SCALE.x,BASE_SCALE.y*2,BASE_SCALE.z),
                ["hop_pst"] = Vector3(BASE_SCALE.x,BASE_SCALE.y*2,BASE_SCALE.z),
                ["mine_start"] = Vector3(BASE_SCALE.x,BASE_SCALE.y*2,BASE_SCALE.z),
                ["mine"] = Vector3(BASE_SCALE.x,BASE_SCALE.y*2,BASE_SCALE.z),
            }
            local state_fns = {
                ["temp_default"] = function()
                end,
                ["run_start"] = function()
                end,
                ["amulet_rebirth"] = function()
                    body_fx:Show()
                end,
                ["stop_sitting_pst"] = function()
                    inst:PushEvent("cyclone_change_2_fly")
                end,
                ["idle"] = function()
                    inst:PushEvent("cyclone_change_2_fly")
                end,
            }
            inst:ListenForEvent("newstate",function(_,_table)
                local statename = _table and _table.statename
                if not statename then
                    return
                end
                -- print("newstate",statename)
                ------- 缩放
                    local current_scale = scale_with_state[statename] or BASE_SCALE
                    inst.body_fx.AnimState:SetScale(current_scale.x,current_scale.y,current_scale.z)

                ------ 其他配置
                    if state_fns[statename] then
                        state_fns[statename]()
                    else
                        state_fns["temp_default"]()
                    end

            end)
        -----------------------------------------------------------------------------------------------------------
        ---- 冰冻状态
            inst:ListenForEvent("freeze",function(inst)
                inst.AnimState:ShowSymbol("torso")
                body_fx:Hide()
            end)
            inst:ListenForEvent("unfreeze",function(inst)
                inst.AnimState:HideSymbol("torso")
                body_fx:Show()
            end)
        -----------------------------------------------------------------------------------------------------------
        ----- 死亡
            inst:ListenForEvent("death",function(inst)
                body_fx:Hide()
            end)
            inst:ListenForEvent("stopghostbuildinstate",function(inst)
                body_fx:Show()
            end)
        -----------------------------------------------------------------------------------------------------------
    end)
end