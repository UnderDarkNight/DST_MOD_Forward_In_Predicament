----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 单个物品需求的 集群卷轴
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
        function inst:Get_Missons_Cmd_Tables()
            return require("prefabs/24_fwd_in_pdt_task_scrolls/02_item_ask_scrolls___tasks") or {}
        end
    -----------------------------------------------------------------------------------
    ---- 配置该物品的 任务内容
        if TheWorld.ismastersim then
                inst:ListenForEvent("Set",function(_,task_index)

                    if type(task_index) ~= "string" then
                        return
                    end
                    local cmd_table = inst:Get_Missons_Cmd_Tables()[task_index]

                    inst.components.fwd_in_pdt_data:Set("task_index",task_index)
                    inst.components.fwd_in_pdt_com_task_scroll:Init({
                        atlas = cmd_table.atlas,
                        image = cmd_table.image,
                        x = cmd_table.x or -50,
                        y = cmd_table.y or 0,
                    })
                    if type(cmd_table.submit_fn) == "function" then
                        inst.components.fwd_in_pdt_com_task_scroll:Add_Submit_Fn(cmd_table.submit_fn)
                    end
                    inst.Ready = true
                end)
                inst:DoTaskInTime(0,function()
                    if inst.Ready ~= true then
                        local task_index = inst.components.fwd_in_pdt_data:Get("task_index")
                        if task_index then
                            inst:PushEvent("Set",task_index)
                        end
                    end
                end)
        end
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
        inst.components.fwd_in_pdt_com_workable:SetSGAction("give")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_task_scrolls",STRINGS.ACTIONS.READ)
    -----------------------------------------------------------------------------------
    ---- 任务信息交互组件
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_data")
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
                    local index = inst.components.fwd_in_pdt_data:Get("task_index") or "nil"
                    local cmd_table = inst:Get_Missons_Cmd_Tables()[index] or {}
                    local item_ask_num = cmd_table.item_num or 5
                    local item_ask_prefab = cmd_table.item_prefab or "fertilizer"
                    local gift_box_items = cmd_table.gift_box_items or {
                        {"fwd_in_pdt_item_jade_coin_green",5},
                        {"fwd_in_pdt_plant_paddy_rice_seed",10},
                    }
                ---------------------------------------------------------------------------------
                --- 物品扫描
                        local items = {}
                        local function get_item_stack_num(item_inst)
                            if item_inst.components.stackable then
                                return item_inst.components.stackable.stacksize
                            else
                                return 1
                            end
                        end
                        local container_each_item_search_fn = function(item_inst)
                            if item_inst and item_inst.prefab == item_ask_prefab then
                                table.insert(items,item_inst)
                            end
                        end
                        local each_item_search_fn = function(item_inst)
                            if item_inst == nil then
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
                        local all_item_num = 0
                        for k, item_inst in pairs(items) do
                            all_item_num = all_item_num + get_item_stack_num(item_inst)
                        end

                        if all_item_num < item_ask_num then
                            return
                        end
                
                       ------------ 删除物品  item_ask_num
                       for k, item_inst in pairs(items) do
                            if item_inst.components.stackable then
                                local current_num = item_inst.components.stackable.stacksize
                                if current_num >= item_ask_num then --- 个数足够
                                    item_inst.components.stackable:Get(item_ask_num):Remove()
                                    item_ask_num = 0
                                else
                                    item_inst:Remove()
                                    item_ask_num = item_ask_num - current_num
                                end
                            else
                                item_inst:Remove()
                                item_ask_num = item_ask_num - 1
                            end
                            if item_ask_num <= 0 then
                                break
                            end
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
        MakeSmallPropagator(inst)   -- 可被其他物品引燃
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

return Prefab("fwd_in_pdt_task_scroll__items_ask", fn, assets)