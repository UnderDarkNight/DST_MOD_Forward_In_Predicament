

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_jade_coin_green"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_jade_coins.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_jade_coin_green.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_jade_coin_green.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_jade_coin_black.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_jade_coin_black.xml" ),
}

local function fn_green()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fwd_in_pdt_jade_coins")
    inst.AnimState:SetBuild("fwd_in_pdt_jade_coins")
    inst.AnimState:PlayAnimation("idle_green",true)
    inst.AnimState:SetTime(math.random(8000)/1000)

    -- inst.AnimState:SetScale(1.5, 1.5, 1.5)
    inst.DynamicShadow:SetSize(1.5,0.7)
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")


	inst:AddTag("fwd_in_pdt_item_jade_coin_green")

	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()
    --------------------------------------------------------------------------------------------
    --- 100 绿币 合并成 1 黑币
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if doer and inst.replica.inventoryitem:IsGrandOwner(doer) then
                    local flag,num = doer.replica.inventory:Has(inst.prefab,100,true)
                    return flag
                end
                return false
            end)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("fwd_in_pdt_item_jade_coin_exchange",GetStringsTable()["action_str"])
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)

                local need_num = 100
                local green_coin_insts = {}
                local all_num = 0

                doer.components.inventory:ForEachItem(function(item_inst)
                    if item_inst and item_inst.prefab == "fwd_in_pdt_item_jade_coin_green" and item_inst.components.inventoryitem:GetGrandOwner() == doer then
                        green_coin_insts[item_inst] = item_inst.components.stackable.stacksize
                        all_num = all_num + item_inst.components.stackable.stacksize
                    end
                end)
                if all_num < need_num then
                    return
                end

                for temp_item,temp_num  in pairs(green_coin_insts) do
                    if temp_num <= need_num then
                        temp_item:Remove()
                        need_num = need_num - temp_num
                    else
                        temp_item.components.stackable:Get(need_num):Remove()
                        need_num = 0
                    end
                    if need_num <= 0 then
                        break
                    end
                end

                -- doer.components.inventory:ForEachItem(function(item_inst)
                --     if item_inst and item_inst.prefab == "fwd_in_pdt_item_jade_coin_green" then
                --         if need_num <= 0 then
                --             return
                --         end
                --         if item_inst.components.stackable.stacksize >= need_num then
                --             item_inst.components.stackable:Get(need_num):Remove()
                --             need_num = 0
                --         else
                --             -- local max_num = item_inst.components.stackable.maxsize
                --             local current_num = item_inst.components.stackable.stacksize
                --             if current_num <= need_num then
                --                 item_inst:Remove()
                --                 need_num = need_num - current_num
                --             else
                --                 local rest_num = current_num - need_num
                --                 item_inst.components.stackable.stacksize = rest_num
                --                 need_num = 0
                --             end

                --         end

                --     end
                -- end)


                doer.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_item_jade_coin_black"))
                return true
            end)
        end
    --------------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_jade_coin_green"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_jade_coin_green.xml"

    inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_jade_coins",
        build = "fwd_in_pdt_jade_coins",
        anim = "icon_green",
        hide_image = true,
        text = {
            color = {100/255,255/255,100/255},
            pt = Vector3(4,1,0),
            size = 36,
        }
    })

    inst:AddComponent("stackable")  -- 可叠堆
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM  -- 60

    MakeHauntableLaunch(inst)


    return inst
end

local function fn_black()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fwd_in_pdt_jade_coins")
    inst.AnimState:SetBuild("fwd_in_pdt_jade_coins")
    inst.AnimState:PlayAnimation("idle_black",true)
    inst.AnimState:SetTime(math.random(8000)/1000)
    -- inst.AnimState:SetScale(1.5, 1.5, 1.5)
    inst.DynamicShadow:SetSize(1.5,0.7)
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")


	inst:AddTag("fwd_in_pdt_item_jade_coin_black")

	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()
    ---------------------------------------------------------------------------------
    -- 黑币转换为绿币
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能转换。地上不给转。                
            end)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("fwd_in_pdt_item_jade_coin_exchange",GetStringsTable()["action_str"])
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                inst.components.stackable:Get():Remove()
                local new_green_coins = SpawnPrefab("fwd_in_pdt_item_jade_coin_green")
                if new_green_coins.components.stackable.maxsize >= 100 then
                    new_green_coins.components.stackable.stacksize = 100
                    doer.components.inventory:GiveItem(new_green_coins)
                else
                    local max_stack = new_green_coins.components.stackable.maxsize
                    local rest_num = 100 - max_stack
                    new_green_coins.components.stackable.stacksize = max_stack
                    doer.components.inventory:GiveItem(new_green_coins)
                    if rest_num > 0 then
                        local temp_green_coins = SpawnPrefab("fwd_in_pdt_item_jade_coin_green")
                        temp_green_coins.components.stackable.stacksize = rest_num
                        doer.components.inventory:GiveItem(temp_green_coins)
                    end
                end
    
                return true
            end)
        end
    ---------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_jade_coin_black"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_jade_coin_black.xml"

    inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_jade_coins",
        build = "fwd_in_pdt_jade_coins",
        anim = "icon_black",
        hide_image = true,
        text = {
            -- color = {100/255,255/255,255/255},
            pt = Vector3(-14,16,0),
            size = 35,
        }
    })

    inst:AddComponent("stackable")  -- 可叠堆
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM  -- 60

    MakeHauntableLaunch(inst)



    return inst
end

return Prefab("fwd_in_pdt_item_jade_coin_green", fn_green, assets),Prefab("fwd_in_pdt_item_jade_coin_black", fn_black, assets)
