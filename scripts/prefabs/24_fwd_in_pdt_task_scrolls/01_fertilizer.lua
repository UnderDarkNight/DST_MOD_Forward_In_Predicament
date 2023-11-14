----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 示例 任务卷轴
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_task_scroll__test"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_task_scroll.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_task_scroll.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_task_scroll.xml" ),

}

-----------------------------------------------------////-----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("fwd_in_pdt_task_scroll")
    inst.AnimState:SetBuild("fwd_in_pdt_task_scroll")
    inst.AnimState:PlayAnimation("idle",true)



	inst:AddTag("fwd_in_pdt_task_scroll")

    -- inst:AddTag("waterproofer")
    MakeInventoryFloatable(inst, nil, 0.1)
    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()
    
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
            inst.components.fwd_in_pdt_com_task_scroll:Open(doer)
            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("dolongaction")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_task_scrolls",STRINGS.ACTIONS.READ)
    -----------------------------------------------------------------------------------
    ---- 任务信息交互组件
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_task_scroll")
            inst.components.fwd_in_pdt_com_task_scroll:Init({
                atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",
                image = "fwd_in_pdt_task_scroll__fertilizer.tex",
                x = -50,
                y = 0
            })
            inst.components.fwd_in_pdt_com_task_scroll:Add_Submit_Fn(function(inst,doer)
                -- print("error fwd_in_pdt_com_task_scroll submit task",inst,doer)
                ---------------------------------------------------------------------------------
                    local item_ask_num = 5
                    local item_ask_prefab = "fertilizer"
                    local gift_box_items = {
                        {"fwd_in_pdt_item_jade_coin_green",5},
                        {"fwd_in_pdt_plant_paddy_rice_seed",10},
                    }
                ---------------------------------------------------------------------------------
                --- 物品扫描
                        local items = {}

                        local container_each_item_search_fn = function(item_inst)
                            if item_inst == nil then
                                return
                            end
                            if #items >= item_ask_num then ---- 个数够了，跳出扫描函数
                                return
                            end
                            if item_inst.prefab == item_ask_prefab then
                                table.insert(items,item_inst)
                            end
                        end
                        local each_item_search_fn = function(item_inst)
                            if item_inst == nil then
                                return
                            end

                            if #items >= item_ask_num then ---- 个数够了，跳出扫描函数
                                return
                            end

                            if item_inst.components.container then
                                item_inst.components.container:ForEachItem(container_each_item_search_fn)
                                return
                            end
                            if item_inst.prefab == item_ask_prefab then
                                table.insert(items,item_inst)
                            end
                        end
                        doer.components.inventory:ForEachItem(each_item_search_fn)
                ---------------------------------------------------------------------------------

                if not (#items >= item_ask_num) then
                    -- print("info fwd_in_pdt_com_task_scroll fail")
                    return
                end

                for k, v in pairs(items) do ---- 移除任务
                    v:Remove()
                end

                -- print("info fwd_in_pdt_com_task_scroll succeed")
                ----------------------------------------------------------------------------------------------------
                        local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(doer,math.random(3))
                        SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                            pt = Vector3(pt.x,pt.y+1,pt.z),
                            scale = Vector3(2.5,1,2.5)
                        })
                        doer:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable("fwd_in_pdt_gift_pack")["name.task_scroll"],
                                inspect_str =  GetStringsTable()["name.task_scroll"],
                                items = gift_box_items,
                                    new_anim = {               ----- 其他皮肤数据
                                        bank = "fwd_in_pdt_gift_pack",
                                        build = "fwd_in_pdt_gift_pack",
                                        anim = "fwd_in_pdt_gift_pack_"..skin_num,
                                        scale = 2,
                                        imagename = "fwd_in_pdt_gift_pack_"..skin_num,
                                        atlasname = "images/inventoryimages/fwd_in_pdt_gift_pack.xml",
                                    },
                            })
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                        end)



                ----------------------------------------------------------------------------------------------------


                inst:Remove()
            end)
        end
    -----------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("named")
    inst:AddComponent("inspectable")
    inst.components.named:SetName(GetStringsTable()["name"])
    inst.components.inspectable:SetDescription(GetStringsTable()["inspect_str"])


    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("scandata")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_task_scroll"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_task_scroll.xml"



    MakeHauntableLaunch(inst)
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
    ---- 燃烧 和 可燃
        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)    --- 可点燃
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------

    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
                -- inst.AnimState:PlayAnimation("idle_water")
            else                                
                inst.AnimState:Show("SHADOW")
                -- inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_task_scroll__fertilizer", fn, assets)