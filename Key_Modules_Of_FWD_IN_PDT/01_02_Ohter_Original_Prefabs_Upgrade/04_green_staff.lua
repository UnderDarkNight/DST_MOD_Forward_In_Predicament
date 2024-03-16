------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    升级绿杖


]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_com_special_acceptable"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
AddPrefabPostInit(
    "greenstaff",
    function(inst)






        inst:AddComponent("fwd_in_pdt_com_acceptable")
        inst.components.fwd_in_pdt_com_acceptable:SetSGAction("dolongaction")
        inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStr("fwd_in_pdt_element_cores",GetStringsTable()["fwd_in_pdt_element_cores"])
        inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer,right_click)
            -- print("++++++++++++++++",inst,item,doer)
            if item then

                if item:HasTag("fwd_in_pdt_item_ice_core") and inst:HasTag("ice_core_enough") then  --- 冰核足够，不允许继续加了
                    return false
                end

                if item:HasTag("fwd_in_pdt_item_flame_core") and inst:HasTag("flame_core_enough") then  --- 火核足够，不允许继续加了
                    return false
                end


                if item:HasTag("fwd_in_pdt_item_ice_core") or item:HasTag("fwd_in_pdt_item_flame_core") then
                    return true
                end

                if item.prefab == "greengem" then
                    if inst:HasTag("greengem_enough") then
                        return false
                    else
                        return true
                    end
                end

                if item.prefab == "opalpreciousgem" then
                    if inst:HasTag("opalpreciousgem_enough") then
                        return false
                    else
                        return true    
                    end
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

            local ice_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_ice_core",0)
            local flame_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_flame_core",0)
            local greengem_num = inst.components.fwd_in_pdt_func:Add("greengem",0)
            local opalpreciousgem_num = inst.components.fwd_in_pdt_func:Add("opalpreciousgem",0)

            --------------- 冰核心
                if item:HasTag("fwd_in_pdt_item_ice_core") then
                    ice_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_ice_core",1)
                end
            --------------- 火核心
                if item:HasTag("fwd_in_pdt_item_flame_core") then
                    flame_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_flame_core",1)
                end
            --------------- 绿宝石
                if item.prefab == "greengem" then
                    greengem_num = inst.components.fwd_in_pdt_func:Add("greengem",1)
                end
            --------------- 彩虹
                if item.prefab == "opalpreciousgem" then
                    opalpreciousgem_num = inst.components.fwd_in_pdt_func:Add("opalpreciousgem",1)
                end


            if item.components.stackable then
                item.components.stackable:Get():Remove()
            else
                item:Remove()
            end    
            
            if ice_num >= 5 and flame_num >= 5 and greengem_num >= 1 and opalpreciousgem_num >= 1 then
                doer.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_equipment_repair_staff"))
                inst:Remove()
            end
            inst:PushEvent("mouse_over_text_refresh")

            return true

        end)



        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful")
        
        inst:ListenForEvent("mouse_over_text_refresh",function()
            local ice_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_ice_core",0)
            local flame_num = inst.components.fwd_in_pdt_func:Add("fwd_in_pdt_item_flame_core",0)
            local greengem_num = inst.components.fwd_in_pdt_func:Add("greengem",0)
            local opalpreciousgem_num = inst.components.fwd_in_pdt_func:Add("opalpreciousgem",0)

            local r,g,b,a = 0/255,255/255,0/255,200/255

            if ice_num >= 5 then
                inst:AddTag("ice_core_enough")
            end
            if flame_num >= 5 then
                inst:AddTag("flame_core_enough")
            end

            if greengem_num >= 1 then
                inst:AddTag("greengem_enough")
            end

            if opalpreciousgem_num >= 1 then
                inst:AddTag("opalpreciousgem_enough")
            end

            if ice_num + flame_num + greengem_num  + opalpreciousgem_num > 0 then
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)
            end
            
        end)

        inst:DoTaskInTime(0,function()
            inst:PushEvent("mouse_over_text_refresh")
        end)


    end
)