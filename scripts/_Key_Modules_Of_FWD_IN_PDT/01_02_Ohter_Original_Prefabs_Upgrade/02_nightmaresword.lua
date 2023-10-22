------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    · 暗影剑


]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_com_special_acceptable"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
AddPrefabPostInit(
    "nightsword",
    function(inst)






        inst:AddComponent("fwd_in_pdt_com_acceptable")
        inst.components.fwd_in_pdt_com_acceptable:SetSGAction("dolongaction")
        inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStr("fwd_in_pdt_element_cores",GetStringsTable()["fwd_in_pdt_element_cores"])
        inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer,right_click)
            -- print("++++++++++++++++",inst,item,doer)
            if item then

                if item:HasTag("fwd_in_pdt_item_ice_core") and inst:HasTag("trans_2_flame") then      --- 切火的不允许切冰
                    return false
                end
                if item:HasTag("fwd_in_pdt_item_flame_core") and inst:HasTag("trans_2_ice") then      --- 切冰的不允许切火
                    return false
                end
                

                if item:HasTag("fwd_in_pdt_item_ice_core") or item:HasTag("fwd_in_pdt_item_flame_core") then
                    return true
                end

            end            
            return false
        end)

        inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
            if not TheWorld.ismastersim then
                return
            end
            if item == nil or doer == nil then
                return
            end

            if item:HasTag("fwd_in_pdt_item_ice_core") then
                local ret = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_ice_core",1)
                item.components.stackable:Get():Remove()
                if ret >= 10 then
                    doer.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_equipment_frozen_nightmaresword"))
                    inst:Remove()
                end
                inst:PushEvent("mouse_over_text_refresh")

                return true
            end

            if item:HasTag("fwd_in_pdt_item_flame_core") then
                local ret = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_flame_core",1)
                item.components.stackable:Get():Remove()
                if ret >= 10 then
                    doer.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_equipment_blazing_nightmaresword"))
                    inst:Remove()
                end
                inst:PushEvent("mouse_over_text_refresh")

                return true
            end


            return false
        end)



        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful")
        
        inst:ListenForEvent("mouse_over_text_refresh",function()
            local ice_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_ice_core",0)
            local flame_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_flame_core",0)

            if ice_num > 0 then
                inst:AddTag("trans_2_ice")
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(35/255,255/255,255/255,1)
            end
            if flame_num > 0 then
                inst:AddTag("trans_2_flame")
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(255/255,100/255,0/255,1)
            end
            
        end)

        inst:DoTaskInTime(0,function()
            inst:PushEvent("mouse_over_text_refresh")
        end)


    end
)