


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_element_cores.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_ice_core.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_ice_core.xml" ),
}
local function wrap_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("bundle")
    inst.AnimState:SetBuild("bundle")
    inst.AnimState:PlayAnimation("idle")



	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("giftwrap")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_item_ice_core"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_ice_core.xml"
    inst:AddComponent("fwd_in_pdt_special_packer")
    inst.components.fwd_in_pdt_special_packer:SetTestFn(function(target)
        -- 检查顺序：prefab白名单、prefab黑名单、tags黑名单、组件黑名单、头脑、生物

        local check_list_table = require("prefabs/01_fwd_in_pdt_items/23_special_packer_list")
        if check_list_table.prefab_whitelist[target.prefab] then
            return true
        end
        if check_list_table.prefab_blacklist[target.prefab] then
            return false
        end
        if target:HasOneOfTags(check_list_table.tags_blacklist or {}) then
            return false
        end

        for com_name, v in pairs(target.components) do
            if check_list_table.components_blacklist[com_name] then
                return false
            end
        end

        if target.brainfn then
            return false
        end

        return true
    end)
    inst.components.fwd_in_pdt_special_packer:SetPackFn(function(target)
        local debugstring = target.entity:GetDebugString()
        -----------------------------------------------------------------------------------------------------
        --- 这段逻辑直接复制【小穹MOD】
            local bank, build, anim = debugstring:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")
            if (not bank) or (bank:find("FROMNUM")) then
                bank = target.prefab -- 抢救一下吧
            end
            if (not build) or (build:find("FROMNUM")) then
                build = target.prefab -- 抢救一下吧
            end

            if target.skinname and not Prefabs[target.prefab .. "_placer"] then
                local temp_inst = SpawnPrefab(target.prefab)
                debugstring = temp_inst.entity:GetDebugString()
                bank, build, anim = debugstring:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")
                temp_inst:Remove()
            end
        -----------------------------------------------------------------------------------------------------
            if target and target.components.container and target.components.container:IsOpen() then
                target.components.container:Close()
            end
        -----------------------------------------------------------------------------------------------------
            -- print(bank,build,anim)
            local x,y,z = target.Transform:GetWorldPosition()
            local save_record = target:GetSaveRecord()
            local name = target:GetDisplayName()
            local box = SpawnPrefab("fwd_in_pdt_item_special_wraped_box")
            box:PushEvent("Set",{
                save_record = save_record,
                bank = bank,
                build = build,
                anim = anim,
                name = name,
            })
            box.Transform:SetPosition(x, y, z)
            target:Remove()
            -- inst:Remove()
            inst.components.stackable:Get():Remove()
        -----------------------------------------------------------------------------------------------------
        return true
    end)

    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)   -- 可被其他物品引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    return inst
end

local function box_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("gift")
    inst.AnimState:SetBuild("gift")
    inst.AnimState:PlayAnimation("idle_large2")



	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()
    ----------------------------------------------------------------------
    --- 给放置时候用的数据调取。
        inst.__net_string_json = net_string(inst.GUID,"fwd_in_pdt_item_special_wraped_box","fwd_in_pdt_item_special_wraped_box")
        inst:ListenForEvent("fwd_in_pdt_item_special_wraped_box",function() --- 得到下发的数据
            inst.deploy_placer_data = {}
            pcall(function()
                local str = inst.__net_string_json:value()
                local temp_table = json.decode(str)
                if temp_table.bank and temp_table.build and temp_table.anim then
                    inst.deploy_placer_data = temp_table
                end
            end)
        end)
    ----------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("named")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("gift_large2")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_item_ice_core"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_ice_core.xml"

    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)   -- 可被其他物品引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    ------------------------------------------------------------------------------------------
    ---- 参数设置
        inst:AddComponent("fwd_in_pdt_data")
        inst:ListenForEvent("Set",function(_,_table)
            -- _table = {
            --     bank = "",  --- 
            --     build = "", ---
            --     anim = "",  ---
            --     name = "",  --- 显示名字
            --     save_record = "",  --- 储存代码
            -- }
            if _table.save_record == nil then
                inst:Remove()
                return
            end

            ------------------------------------------------------
                local deploy_placer_data = {
                    bank = _table.bank,
                    build = _table.build,
                    anim = _table.anim,
                }
                -- inst.__net_string_json:set(json.encode(deploy_placer_data)) --- 下发placer 用的数据
                inst.components.fwd_in_pdt_data:Set("deploy_placer_data",deploy_placer_data)
            ------------------------------------------------------


            inst.components.fwd_in_pdt_data:Set("save_record",_table.save_record)

            if _table.name then
                inst.components.named:SetName("Pack : ".._table.name)
            end
        end)
    ------------------------------------------------------------------------------------------
    ---- 重载的时候下发数据
        inst:DoTaskInTime(0,function()
            local deploy_placer_data = inst.components.fwd_in_pdt_data:Get("deploy_placer_data") 
            if deploy_placer_data then
                inst.__net_string_json:set(json.encode(deploy_placer_data)) --- 下发placer 用的数据
            end
        end)
    ------------------------------------------------------------------------------------------
    --- 种植组件
        inst:AddComponent("deployable")                
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            local save_record = inst.components.fwd_in_pdt_data:Get("save_record")
            
            if save_record then
                SpawnSaveRecord(save_record).Transform:SetPosition(pt.x, pt.y, pt.z)
            end

            inst:Remove()            
        end
        -- inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    ------------------------------------------------------------------------------------------
    return inst
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- placer 相关的 hook
    local function placer_postinit_fn(inst)

            local old_SetBuilder_fn = inst.components.placer.SetBuilder
            inst.components.placer.SetBuilder = function(self,builder, recipe, invobject) --- 玩家准备放置预览的时候，会执行这个
                if invobject and invobject.deploy_placer_data then
                    local temp_table = invobject.deploy_placer_data
                    if temp_table.bank and temp_table.build and temp_table.anim then
                        inst.AnimState:SetBank(temp_table.bank)
                        inst.AnimState:SetBuild(temp_table.build)
                        inst.AnimState:PlayAnimation(temp_table.anim,true)
                    end
                end
                return old_SetBuilder_fn(self,builder, recipe, invobject)
            end
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_item_special_wrap", wrap_fn, assets),
        Prefab("fwd_in_pdt_item_special_wraped_box", box_fn, assets),
        MakePlacer("fwd_in_pdt_item_special_wraped_box_placer", "fwd_in_pdt_container_tv_box", "fwd_in_pdt_container_tv_box", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)
