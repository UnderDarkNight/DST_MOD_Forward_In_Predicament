----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_medical_certificate"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_item_medical_certificate.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_medical_certificate.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_medical_certificate.xml" ),

}

-----------------------------------------------------////-----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("fwd_in_pdt_item_medical_certificate")
    inst.AnimState:SetBuild("fwd_in_pdt_item_medical_certificate")
    inst.AnimState:PlayAnimation("idle")



	inst:AddTag("fwd_in_pdt_item_medical_certificate")
    -- inst:AddTag("waterproofer")
    MakeInventoryFloatable(inst, nil, 0.1)

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()
    -----------------------------------------------------------------------------------
    ---- net_entity 下发 player
        inst.___net_entity = net_entity(inst.GUID, "fwd_in_pdt_item_medical_certificate.net_entity", "fwd_in_pdt_item_medical_certificate.net_entity")
        inst:ListenForEvent("fwd_in_pdt_item_medical_certificate.net_entity",function()
            local entity = inst.___net_entity:value()
            if entity:HasTag("player") and ThePlayer and ThePlayer == entity and  ThePlayer.HUD and ThePlayer.HUD.fwd_in_pdt_medical_certificate_show then
                
                -- print("fwd_in_pdt_item_medical_certificate  READ")

                local certificate_data = inst.replica.fwd_in_pdt_func:Replica_Get_Simple_Data("certificate_data") or {}
                ThePlayer.HUD:fwd_in_pdt_medical_certificate_show(certificate_data)

                -- if certificate_data then
                --     print("++++++++++ 诊断书 ++++++++++")
                --     print("天数",certificate_data.days)
                --     print("玩家",certificate_data.player_name)
                --     for i, debuff_table in pairs(certificate_data.debuffs or {}) do
                --         if debuff_table and debuff_table.name and debuff_table.treatment then
                --             print("项目",debuff_table.name)
                --             print("解决方法：")
                --             if type(debuff_table.treatment) == "table" then
                --                 for k, treatment in pairs(debuff_table.treatment) do
                --                     print("    ",treatment)                                            
                --                 end      
                --             else
                --                 print("    ",debuff_table.treatment)        
                --             end
                --             print("----------------")
                --         end
                --     end
                --     print("+++++++++++++++++++++++++++")

                -- end

            end
        end)
    -----------------------------------------------------------------------------------
    ---- 法术施放
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            return inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能使用            
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end

            inst.___net_entity:set(doer)
            inst:DoTaskInTime(1,function()
                inst.___net_entity:set(inst)
            end)

            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("give")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_item_medical_certificate",STRINGS.ACTIONS.READ)
    -----------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("named")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("scandata")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_medical_certificate"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_medical_certificate.xml"


    MakeHauntableLaunch(inst)
    ------------------------------------------------------------------------------------------------------
    --- 擦除
        inst:AddComponent("erasablepaper")
    ------------------------------------------------------------------------------------------------------
    ---- 燃烧 和 可燃
        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)    --- 可点燃
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    ------------------------------------------------------------------------------------------------------
        inst:AddComponent("fwd_in_pdt_func")    --- 用来转存数据的
        inst:ListenForEvent("certificate_data",function(_,cmd_table)
            -- cmd_table = {
            --     days = 0,
            --     player_name = "",
            --     debuffs = {
            --         { 
            --             name = "",
            --             treatment = "", -- or table
            --         },
            --         { 
            --             name = "",
            --             treatment = "", -- or table
            --         },
            --     }
            -- }
            inst.components.fwd_in_pdt_func:Set("certificate_data",cmd_table)
            local str = GetStringsTable()["item_name_format"]
            local ret_item_name = string.gsub(str, "XXXX", tostring(cmd_table.player_name))
            inst.components.named:SetName(ret_item_name)
            inst.components.fwd_in_pdt_func:Replica_Set_Simple_Data("certificate_data",cmd_table)
        end)
        inst:DoTaskInTime(0,function()
            local data = inst.components.fwd_in_pdt_func:Get("certificate_data")
            if data then
                inst:PushEvent("certificate_data",data)
            end
        end)

        inst.OnBuiltFn = function(self,builder)
            local cmd_table = {
                days = TheWorld.state.cycles + 1,
                player_name = builder:GetDisplayName()
            }
            if not builder.components.fwd_in_pdt_wellness then
                return
            end

            local debuff_list = builder.components.fwd_in_pdt_wellness:Get_All_Debuffs_Name()
            local debuffs = {}
            for k , debuff_prefab in pairs(debuff_list) do
                local string_table = GetStringsTable(debuff_prefab)
                if string_table and string_table.name and string_table.treatment then
                    -- print("++++ inser ",string_table.name)
                    table.insert(debuffs,{name = string_table.name , treatment = string_table.treatment})
                end
            end
            cmd_table.debuffs = debuffs
            inst:PushEvent("certificate_data",cmd_table)
        end
    ------------------------------------------------------------------------------------------------------

    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("idle_water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------

    return inst
end





return Prefab("fwd_in_pdt_item_medical_certificate", fn, assets)