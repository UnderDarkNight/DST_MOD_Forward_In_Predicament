----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    医生的治疗
    玩家拾取瞬间触发

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_glass_horn"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets = {
    -- Asset("ANIM", "anim/fwd_in_pdt_item_bloody_flask.zip"), 

    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_treatment_from_head_doctor.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_treatment_from_head_doctor.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_treatment_from_internship_doctor.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_treatment_from_internship_doctor.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_treatment_from_specialist_doctor.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_treatment_from_specialist_doctor.xml" ),
}


local function common_fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    -- MakeInventoryFloatable(inst, "med", nil, 0.75)

    -- inst.AnimState:SetBank("fwd_in_pdt_item_bloody_flask") -- 地上动画
    -- inst.AnimState:SetBuild("fwd_in_pdt_item_bloody_flask") -- 材质包，就是anim里的zip包
    -- inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画


    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_item_treatment_from_internship_doctor"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_treatment_from_internship_doctor.xml"

    -- -------------------------------------------------------------------   
    --     inst:ListenForEvent("onpickup",function(_,_table)
    --         if _table and _table.owner then
    --             print("onpickup ++++",_table.owner)
    --         end
    --     end)
    -- -------------------------------------------------------------------

    inst:DoTaskInTime(0,inst.Remove)
    return inst
end


local function internship_doctor()
    local inst = common_fn()
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------
        inst.components.inventoryitem.imagename = "fwd_in_pdt_item_treatment_from_internship_doctor"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_treatment_from_internship_doctor.xml"
    -------------------------------------------------------------------   
        inst:ListenForEvent("onpickup",function(_,_table)
            -- if _table and _table.owner then
            --     print("onpickup ++++",_table.owner)
            -- end
            if not (_table and _table.owner) then
                return
            end
            local player = _table.owner
            -----------------------------------------------------------
            ---- 医生的治疗方案 。 30%概率解除毒并清空中毒值，60%概率没有效果，10%体质值+80
                local temp_num = math.random(1000)/1000
                if temp_num <= 0.1 then

                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["succeed"] or "succeed",                            ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:DoDelta_Wellness(80)

                elseif temp_num <= 0.4 then

                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["succeed"] or "succeed",                            ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:SetCurrent_Poison(0)
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_snake_poison")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_frog_poison")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_spider_poison")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_bee_poison")


                else
                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["fail"] or "fail",                                  ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:DoDelta_Wellness(5)
                end
                        
            -----------------------------------------------------------

            player.components.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_client_event.shop_close_cmd_by_server")

            -- inst:Remove()
        end)
    -------------------------------------------------------------------
    return inst
end
local function head_doctor()
    local inst = common_fn()
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------
        inst.components.inventoryitem.imagename = "fwd_in_pdt_item_treatment_from_head_doctor"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_treatment_from_head_doctor.xml"
    -------------------------------------------------------------------   
        inst:ListenForEvent("onpickup",function(_,_table)
            -- if _table and _table.owner then
            --     print("onpickup ++++",_table.owner)
            -- end
            if not (_table and _table.owner) then
                return
            end
            local player = _table.owner
            -----------------------------------------------------------
            ---- 医生的治疗方案 。 
                --[[
                        30%解除发烧和咳嗽，并送一个紫菀药丸，
                        40%无效果,
                        30%体质值+200,并送2个紫菀药丸，
                ]]--
                local temp_num = math.random(1000)/1000
                if temp_num <= 0.3 then

                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["succeed"] or "succeed",                            ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:DoDelta_Wellness(200)
                            player.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_food_aster_tataricus_l_f_pills",2)


                elseif temp_num <= 0.6 then

                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["succeed"] or "succeed",                            ---- 文字内容
                            })
                            -- player.components.fwd_in_pdt_wellness:SetCurrent_Poison(0)

                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_cough")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_fever")
                            player.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_food_aster_tataricus_l_f_pills",1)

                else
                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["fail"] or "fail",                                  ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:DoDelta_Wellness(10)
                end
                        
            -----------------------------------------------------------

            player.components.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_client_event.shop_close_cmd_by_server")


            -- inst:Remove()
        end)
    -------------------------------------------------------------------
    return inst
end
local function specialist_doctor()
    local inst = common_fn()
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------
        inst.components.inventoryitem.imagename = "fwd_in_pdt_item_treatment_from_specialist_doctor"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_treatment_from_specialist_doctor.xml"
    -------------------------------------------------------------------   
        inst:ListenForEvent("onpickup",function(_,_table)
            -- if _table and _table.owner then
            --     print("onpickup ++++",_table.owner)
            -- end
            if not (_table and _table.owner) then
                return
            end
            local player = _table.owner
            -----------------------------------------------------------
            ---- 医生的治疗方案 。 
                --[[
                        20% 刷满体制值
                        60% 清空所有病症
                        20% 失败。
                ]]--
                local temp_num = math.random(1000)/1000
                if temp_num <= 0.2 then

                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["succeed"] or "succeed",                            ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:DoDelta_Wellness(300)


                elseif temp_num <= 0.6 then

                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["succeed"] or "succeed",                            ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:DoDelta_Wellness(200)

                            player.components.fwd_in_pdt_wellness:SetCurrent_Poison(0)
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_snake_poison")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_frog_poison")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_spider_poison")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_bee_poison")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_cough")
                            player.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_fever")

                else
                            player.components.fwd_in_pdt_func:Wisper({
                                m_colour = {0,250,250} ,                                                                   ---- 内容颜色
                                message = GetStringsTable(inst.prefab)["fail"] or "fail",                                  ---- 文字内容
                            })
                            player.components.fwd_in_pdt_wellness:DoDelta_Wellness(30)

                end
                        
            -----------------------------------------------------------

            player.components.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_client_event.shop_close_cmd_by_server")

            -- inst:Remove()
        end)
    -------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_item_treatment_from_internship_doctor", internship_doctor, assets),
            Prefab("fwd_in_pdt_item_treatment_from_head_doctor", head_doctor, assets),
                Prefab("fwd_in_pdt_item_treatment_from_specialist_doctor", specialist_doctor, assets)