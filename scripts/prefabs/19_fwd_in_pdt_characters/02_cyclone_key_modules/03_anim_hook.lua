--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end




    ---- 屏蔽穿脱盔甲、项链
        local function need_2_clear_body_layer(tar_layer,build,the_layer)
            if  tar_layer == "swap_body" or tar_layer == "swap_body_tall" or (tar_layer==nil and  build == nil and the_layer == nil) then
                    -------------------------------------------------------

                    -------------------------------------------------------
                    ----- 背重物
                        if inst.replica.inventory:IsHeavyLifting() then
                            -- print("heavylifting",build)
                            return false
                        end
                    ------------------------------------------------------- 
                    -------------------------------------------------------
                    --- 蜗牛壳
                        if inst.replica.inventory:EquipHasTag("shell") then
                            return false
                        end
                    -------------------------------------------------------
                    --- 鼓
                        if inst.replica.inventory:EquipHasTag("band") then
                            return false
                        end
                    -------------------------------------------------------
                    -------------------------------------------------------
                    return true

            end
            return false
        end

                    

        inst:ListenForEvent("unequip",function()
            if need_2_clear_body_layer() then
                inst.AnimState:ClearOverrideSymbol("swap_body")
                inst.AnimState:ClearOverrideSymbol("swap_body_tall")
            end
        end)
        inst:ListenForEvent("equip",function()
            if need_2_clear_body_layer() then
                inst.AnimState:ClearOverrideSymbol("swap_body")
                inst.AnimState:ClearOverrideSymbol("swap_body_tall")
            end
        end)













end