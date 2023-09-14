------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 两个蟾蜍BOSS 在吃了 绿蘑菇汤 和 红蘑菇汤后，不会再放出 蘑菇树
--- toadstool   toadstool_dark
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_food_red_mushroom_soup"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
local function ChangeTheBOSS(inst)
    
    -------------------------------------------------------------------------------------------------------
    ----- 添加喂食机制        
        inst:AddComponent("fwd_in_pdt_com_acceptable")
        inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer,right_click)
            if item and item.prefab then
                local accept_list = {
                    ["fwd_in_pdt_food_red_mushroom_soup"] = true,
                    ["fwd_in_pdt_food_green_mushroom_soup"] = true,
                }
                if accept_list[item.prefab] then
                    return true
                end
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
            if not TheWorld.ismastersim then
                return
            end
            if item then
                if item.prefab == "fwd_in_pdt_food_green_mushroom_soup" then
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst:AddTag("fwd_in_pdt_food_green_mushroom_soup_mark")
                    return true
                elseif item.prefab == "fwd_in_pdt_food_red_mushroom_soup" then
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst:AddTag("fwd_in_pdt_food_red_mushroom_soup_mark")
                    return true
                end
            end
            return false
        end)

        inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStr("fwd_in_pdt_food_red_mushroom_soup",GetStringsTable()["special_action_str"])
    -------------------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return
    end





end


AddPrefabPostInit(
    "toadstool",
    function(inst)
        ChangeTheBOSS(inst)
    end
)
AddPrefabPostInit(
    "toadstool_dark",
    function(inst)
        ChangeTheBOSS(inst)
    end
)



------------------
-- 两种蘑菇树
local function ChangeMushroomTree(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("linktoadstool",function(inst,boss)
        if boss and boss.HasTag then
            if boss:HasTag("fwd_in_pdt_food_red_mushroom_soup_mark") and boss:HasTag("fwd_in_pdt_food_green_mushroom_soup_mark") then
                inst:DoTaskInTime(0,inst.Remove)
            end
        end
    end)

end
AddPrefabPostInit(
    "mushroomsprout",
    function(inst)
        ChangeMushroomTree(inst)
    end
)
AddPrefabPostInit(
    "mushroomsprout_dark",
    function(inst)
        ChangeMushroomTree(inst)
    end
)