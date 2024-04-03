--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetSingleItem(item)
        if item.components.stackable then
            return item.components.stackable:Get()
        end
        return item
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 列表
    local prefabs_fn = {
        -----------------------------------------------------------------------------------------------
        --- 草
            ["cutgrass"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(100)
                    return true
                end,
                ["fast_eat"] = true
            },
        -----------------------------------------------------------------------------------------------
        --- 树枝
            ["twigs"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(100)
                    return true
                end,
                ["fast_eat"] = true
            },
        -----------------------------------------------------------------------------------------------
        --- 木头
            ["log"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(100)
                    return true
                end,
                ["fast_eat"] = true
            },
        -----------------------------------------------------------------------------------------------
        --- 活木
            ["driftwood_log"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(300)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
        --- 木炭
            ["charcoal"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(200)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
        --- 灰烬
            ["ash"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(50)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
        --- 噩梦燃料
            ["nightmarefuel"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(200)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
        --- 纯粹恐惧
            ["horrorfuel"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(1000)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
        --- 龙鳞
            ["dragon_scales"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(2000)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
        --- 暗影心房
            ["shadowheart"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(2000)
                    doer.components.sanity:DoDelta(2000)
                    doer.components.health:DoDelta(2000)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
        --- 高压气旋
            ["fwd_in_pdt_item_compressed_cyclone"] = {
                ["test_fn"] = function(item,doer)
                    return true
                end,
                ["oneat_fn"] = function(item,doer)
                    GetSingleItem(item):Remove()
                    doer.components.hunger:DoDelta(500)
                    return true
                end,
                ["fast_eat"] = false
            },
        -----------------------------------------------------------------------------------------------
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)



    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_player_anything_eater",function(inst,replica_com)
        for temp_prefab, cmd_table in pairs(prefabs_fn) do
            replica_com:AddItemTestFn(temp_prefab,cmd_table["test_fn"],cmd_table["fast_eat"] or false)
        end
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_com_player_anything_eater")
        for temp_prefab, cmd_table in pairs(prefabs_fn) do
           inst.components.fwd_in_pdt_com_player_anything_eater:AddItemOnEatFn(temp_prefab,cmd_table["oneat_fn"])
        end
    end



end