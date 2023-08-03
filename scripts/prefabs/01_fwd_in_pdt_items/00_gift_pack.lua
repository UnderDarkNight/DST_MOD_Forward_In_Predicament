
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_gift_pack"
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
end

local assets =
{
    -- Asset("ANIM", "anim/panda_fisherman_supply_pack.zip"),
    -- Asset( "IMAGE", "images/inventoryimages/panda_fisherman_supply_pack.tex" ),  -- 背包贴图
    -- Asset( "ATLAS", "images/inventoryimages/panda_fisherman_supply_pack.xml" ),
}

local function unwrapped_Fn(inst, pos, doer)
    inst.components.container:DropEverything()
    local cmd_table = inst.components.fwd_in_pdt_data:Get("CMD")
    if cmd_table and cmd_table.special_items then
        local x,y,z = inst.Transform:GetWorldPosition()
        for i, code in ipairs(cmd_table.special_items) do
             SpawnSaveRecord(code).Transform:SetPosition(x,y,z)            
        end
    end
    inst:Remove()

    if doer and doer.SoundEmitter then
        doer.SoundEmitter:PlaySound("summerevent/carnival_games/feedchicks/station/endbell")
    end
end

local function fn()

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- inst:AddTag("CLASSIFIED")
    -- inst:AddTag("NOBLOCK")
    -- inst:AddTag("NOCLICK")
    -- inst:AddTag("FX")
    MakeInventoryPhysics(inst)
    MakeHauntableLaunch(inst)
    inst.entity:SetPristine()

    inst.AnimState:SetBank("gift")
    inst.AnimState:SetBuild("gift")
    inst.AnimState:PlayAnimation("idle_large2")
    -- local gift_anim = {
    --     "idle_large1",
    --     "idle_large2",
    --     "idle_medium1",
    --     "idle_medium2",
    --     "idle_small1",
    --     "idle_small2",
    -- }


    inst:AddTag("gift")
    inst:AddTag("fwd_in_pdt_gift_pack")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("named")
    -- inst.components.named:SetName("Gift Pack")
    inst:AddComponent("inspectable") --可检查组件
    -- inst.components.inspectable:SetDescription("Gift Pack")

    
    inst:AddComponent("fwd_in_pdt_data")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem:ChangeImageName("gift_large2")
    -- inst.components.inventoryitem.imagename = "panda_fisherman_supply_pack"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/panda_fisherman_supply_pack.xml"
	inst.components.inventoryitem.cangoincontainer = true

    inst.Set_Skin = function(self,num)
        local Skin_table = {
            [1] = {"idle_small1","gift_small1"},
            [2] = {"idle_small2","gift_small2"},
            [3] = {"idle_medium1","gift_medium1"},
            [4] = {"idle_medium2","gift_medium2"},
            [5] = {"idle_large1","gift_large1"},
            [6] = {"idle_large2","gift_large2"},
        }

        local ret_skin_table = Skin_table[num] or Skin_table[math.random(#Skin_table)]
        self.AnimState:PlayAnimation(ret_skin_table[1])
        self.components.inventoryitem:ChangeImageName(ret_skin_table[2])

    end

    --------------------------------------------------------------------------------------
    inst:AddComponent('container')
    inst.components.container.canbeopened = false
    inst.components.container.numslots = 20
    
    inst:ListenForEvent("itemget",function(inst,_table)
        if _table and _table.item then
            local tempItem = _table.item
            if tempItem.components.perishable then
                tempItem.components.perishable:StopPerishing()
            end
        end
    end)

    inst:ListenForEvent("itemlose",function(inst,_table)
        if _table and _table.prev_item then
            local tempItem = _table.prev_item
            if tempItem.components.perishable then
                tempItem.components.perishable:StartPerishing()
                tempItem.components.perishable:SetPercent(1)
            end
        end
    end)
    --------------------------------------------------------------------------------------
    ---- 拆包相关组件     
    inst:AddComponent("unwrappable")
    -- inst.components.unwrappable:SetOnWrappedFn(OnWrapped)
    inst.components.unwrappable:SetOnUnwrappedFn(unwrapped_Fn)
    -----------------------------------------------------------------------------------
    -- 用 Event("Set",_table) 添加物品到包里。 格式： num 如果 小于1，则是概率，random < num 的时候放置1个
    -- _table = {
    --      items = {
    --                {"log",num,fn},
    --                {"goldnugget",1,fn}
    --      },
    --      special_items = {   ----- 特殊的无法进入容器的物品  --- 使用 code
    --      },    
    --      name = "pack name",
    --      inspect_str = "66666666",
    --      skin_num = 1,   -- 1~6
    --      new_anim = {               ----- 其他皮肤数据
    --         bank = "",
    --         build = "",
    --         anim = "",
    --         imagename = "",
    --         atlasname = "",
    --      },
    -- }
    ---------------------------------------
    local function Add_items(_,_table)
        if _table == nil then
            return
        end

        if _table.items ~= nil then
            for k, theCMD in pairs(_table.items) do
                local itemName = theCMD[1]
                local itemNum = theCMD[2]
                local item_fn = theCMD[3]
                if itemName == nil then
                    return
                end
                if itemNum == nil then
                    itemNum = 1
                end
    
    
                if itemNum < 1 then
                   local tempNum = math.random(100)/100
                   if tempNum < itemNum then
                        itemNum = 1
                   end
                end
    
                if itemNum >=1 then
                    -- for i = 1, itemNum, 1 do
                    --     inst.components.container:GiveItem(SpawnPrefab(itemName))
                    -- end
                    ------ 用for 循环容易导致游戏卡顿
                    if itemNum == 1 then
                                local temp_item = SpawnPrefab(itemName)
                                if temp_item.components.inventoryitem and temp_item.components.inventoryitem.cangoincontainer then
                                    inst.components.container:GiveItem(temp_item)
                                else  ------------ 如果不能放背包里，放到特殊物品表里，拆包的时候根据表 来重新生成物品
                                    print("gift pack info : "..itemName.." has not inventoryitem or can not cangoincontainer")
                                    _table.special_items = _table.special_items or {}
                                    if item_fn then
                                        pcall(item_fn,temp_item)
                                    end
                                    local save_code = temp_item:GetSaveRecord() --- 获取保存字符串
                                    table.insert(_table.special_items,save_code)    --- 储存到表里
                                    temp_item:Remove()  --- 删除实体
                                end
                    else                            
                        local tempItem = SpawnPrefab(itemName)
                        if tempItem.components.stackable == nil then
                                --- 不可叠堆物品
                                tempItem:Remove()
                                for i = 1, itemNum, 1 do
                                    inst.components.container:GiveItem(SpawnPrefab(itemName))
                                end
                        else
                            --- 可叠堆物品
                                local stack_max = tempItem.components.stackable.maxsize

                                local rest_num = itemNum % stack_max                ---- 取不满叠堆的那组里面的个数
                                local group_num = math.floor( (itemNum - rest_num)/stack_max )    ---- 取满叠堆的组数
                                if group_num > 0 then
                                    for i = 1, group_num, 1 do
                                        local group_item = SpawnPrefab(itemName)
                                        group_item.components.stackable.stacksize = stack_max
                                        inst.components.container:GiveItem(group_item)
                                    end
                                end

                                rest_num = math.floor(rest_num)
                                if rest_num > 0 then
                                    tempItem.components.stackable.stacksize = rest_num
                                    inst.components.container:GiveItem(tempItem)
                                else
                                    tempItem:Remove()
                                end
                        end
                    end


                    if item_fn and type(item_fn) == "function" then
                        inst.components.container:ForEachItem(function(item_inst)
                            if item_inst and item_inst.prefab == itemName then
                                pcall(item_fn,item_inst)
                            end
                        end)
                    end
                end
                
            end
        end

        if _table.new_anim then
            inst.AnimState:SetBank(tostring(_table.new_anim.bank))
            inst.AnimState:SetBuild(tostring(_table.new_anim.build))
            inst.AnimState:PlayAnimation(tostring(_table.new_anim.anim),true)
            inst.components.inventoryitem.imagename = _table.new_anim.imagename
            inst.components.inventoryitem.atlasname = _table.new_anim.atlasname
        end

        if _table.name then
            inst.components.named:SetName(_table.name)
        else
            inst.components.named:SetName(GetStringsTable().name or "Gift Pack")
        end

        if _table.inspect_str then
            inst.components.inspectable:SetDescription(_table.inspect_str)
        else
            inst.components.inspectable:SetDescription(GetStringsTable().inspect_str or "Gift Pack")
        end

        if _table.skin_num then
            inst:Set_Skin(_table.skin_num)
        end

        _table.items = nil
        inst.components.fwd_in_pdt_data:Set("CMD",_table)
        inst.Ready = true
    end

    inst:ListenForEvent("Set",Add_items)  

    inst:DoTaskInTime(0,function()
        if inst.Ready == true then
            return
        end
        local _table = inst.components.fwd_in_pdt_data:Get("CMD")
        if _table == nil then
            return
        end
        if _table then
            inst:PushEvent("Set",_table)
        end
    end)
   
    return inst
end

return Prefab("fwd_in_pdt_gift_pack", fn,assets)