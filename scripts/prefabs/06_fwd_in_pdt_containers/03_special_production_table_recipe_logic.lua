------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 配方函数
----- server/client 都执行
----- 挂载去 event   itemget  / itemlose
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    


    local recipes = {
        ------- 正式配方
        -- -------------------------------------------------------------------------------------------------------------
        -- ---- 测试配方
        --     {
        --         source = {     
        --             {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
        --             {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
        --             {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
        --         },
        --         ret = {
        --             prefab = "walrus_tusk",
        --             num = 1,
        --             atlas =  GetInventoryItemAtlas("walrus_tusk.tex"),
        --             image =  "walrus_tusk.tex"
        --         }
        --     },
        -- -------------------------------------------------------------------------------------------------------------
        -- ---- 测试配方
        --     {
        --         source = {     
        --             {                                 } ,  {prefab = "goldnugget" , num = 1, },   {                          },
        --             {prefab = "goldnugget" , num = 1, } ,  {                                 },   {                          },
        --             {                                 } ,  {prefab = "goldnugget" , num = 1, },   {                          },
        --         },
        --         ret = {
        --             prefab = "transistor",
        --             num = 1,
        --             atlas =  GetInventoryItemAtlas("transistor.tex"),
        --             image =  "transistor.tex"
        --         }
        --     },
        -- -------------------------------------------------------------------------------------------------------------

    }

    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
        local debugging_recipe = {
                -------------------------------------------------------------------------------------------------------------
                    ---- 测试配方
                    {
                        source = {     
                            {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
                            {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
                            {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
                        },
                        ret = {
                            prefab = "walrus_tusk",
                            num = 1,
                            atlas =  GetInventoryItemAtlas("walrus_tusk.tex"),
                            image =  "walrus_tusk.tex"
                        }
                    },
                -------------------------------------------------------------------------------------------------------------
                ---- 测试配方
                    {
                        source = {     
                            {                                 } ,  {prefab = "goldnugget" , num = 1, },   {                          },
                            {prefab = "goldnugget" , num = 1, } ,  {prefab = "multitool_axe_pickaxe" , use = 10},   {                          },
                            {                                 } ,  {prefab = "goldnugget" , num = 1, },   {                          },
                        },
                        ret = {
                            prefab = "transistor",
                            num = 1,
                            atlas =  GetInventoryItemAtlas("transistor.tex"),
                            image =  "transistor.tex"
                        }
                    },
                -------------------------------------------------------------------------------------------------------------
        }
        for k, v in pairs(debugging_recipe) do
            table.insert(recipes,v)
        end
    end



    local function GetStackNum(item)
        if item.replica.stackable then
            return item.replica.stackable:StackSize()
        else
            return 1
        end
    end


    local function get_ret_cmd_table_by_slots(slots)
        local ret_recipe_cmd = nil  --- 最终配方
        -- for k, v in pairs(slots) do
        --     print(k,v)
        -- end

        for k, current_recipe in pairs(recipes) do

                --------- 检查 9 个格子里是否都满足条件。
                local check_succeed_flag_table = {}
                if current_recipe.source and current_recipe.ret then
                    for i, item_arg_table in pairs(current_recipe.source) do
                                local the_slot_item = slots[i]
                                if (item_arg_table == nil or item_arg_table.prefab == nil ) and the_slot_item == nil then
                                    table.insert(check_succeed_flag_table,1)    --- 空位置，符合
                                elseif the_slot_item and the_slot_item.prefab and type(item_arg_table) == "table" and the_slot_item.prefab == item_arg_table.prefab  then
                                    local item_num = GetStackNum(the_slot_item)
                                    local ask_num = item_arg_table.num or 1
                                    if ask_num <= item_num then --- 个数够
                                        table.insert(check_succeed_flag_table,1)    --- 位置和个数符合
                                    else
                                        table.insert(check_succeed_flag_table,-100)    --- 位置符合，个数不符合
                                    end
                                else
                                    table.insert(check_succeed_flag_table,-100)    --- 都不符合                                    
                                end
                                    
                            -- print(i,check_succeed_flag_table[i])
                    end
                end
                -------- 如果成功获得9个true
                local temp_num = 0
                for kk, flag_num in pairs(check_succeed_flag_table) do
                    temp_num = temp_num + flag_num
                end
                if temp_num >= 9 then                    
                    return current_recipe
                end

        end

        return nil
    end





    local function item_get_or_lose(inst)
        local slots = inst.replica.container:GetItems()
        local ret_recipe_cmd = get_ret_cmd_table_by_slots(slots)
        if ret_recipe_cmd then
            local giveback_item_data = ret_recipe_cmd.ret
            inst:PushEvent("target_widget_image",giveback_item_data)
        else
            inst:PushEvent("target_widget_image")            
        end
    end
    inst:ListenForEvent("itemget",item_get_or_lose)     ---- 这个事件在 client 也会执行
    inst:ListenForEvent("itemlose",item_get_or_lose)    ---- 这个事件在 client 也会执行
    inst:ListenForEvent("fwd_in_pdt_event.container_widget_open",function()
        inst:DoTaskInTime(0.2,item_get_or_lose)
    end)    

    ----------------------------------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return
    end


    local function item_get_or_lose_for_server(inst)
        local slots = inst.replica.container:GetItems()
        local ret_recipe_cmd = get_ret_cmd_table_by_slots(slots)

        if ret_recipe_cmd and ret_recipe_cmd.ret and ret_recipe_cmd.ret.prefab then
            inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
            inst.___ret_recipe_cmd = ret_recipe_cmd
        else
            inst.___ret_recipe_cmd = nil
            inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
        end
    end
    inst:ListenForEvent("itemget",item_get_or_lose_for_server)     
    inst:ListenForEvent("itemlose",item_get_or_lose_for_server)    
    inst:ListenForEvent("onopen",item_get_or_lose_for_server)

    inst:ListenForEvent("recipe_work",function(inst,doer)
        local recipe = inst.___ret_recipe_cmd
        if type(recipe) ~= "table" or doer == nil then

            return
        end

        

        local slots = inst.components.container.slots
        local source_table = recipe.source
        local reward_table = recipe.ret
        
        local cycle_times = 0   --- 循环次数

        local function check_item_fit_with_arg(item_in_slot,item_arg_table,use_flag)
            if item_in_slot == nil and ( item_arg_table == nil or item_arg_table.prefab ==  nil) then
                return true
            end
            if item_in_slot and item_in_slot.prefab and item_arg_table and item_arg_table.prefab == item_in_slot.prefab then
                local arg_num = item_arg_table.num or 1
                local current_num = 1
                if item_in_slot.components.stackable then
                    current_num = item_in_slot.components.stackable.stacksize 
                end
                if current_num < arg_num then   --- 个数不够
                    return false
                end
                ---- 个数够了
                if not use_flag then    --- 个数够了，又不需要消耗掉
                    return true
                end

                if item_in_slot.components.finiteuses == nil then   --- 不带耐久度的东西

                    if item_in_slot.components.stackable then
                        item_in_slot.components.stackable:Get(arg_num):Remove()
                    else
                        item_in_slot:Remove()
                    end

                else
                    local use = item_arg_table.use or 1
                    item_in_slot.components.finiteuses:Use(use)
                end

                return true
            end
            return false
        end
        local function items_enough_in_single_cycle()   --- 检查单次循环够不够
            local succeed_flag_num = 0
            for i = 1, 9, 1 do
                local item_in_slot = slots[i] 
                local item_arg_table = source_table[i] or {}
                if check_item_fit_with_arg(item_in_slot,item_arg_table) then
                    succeed_flag_num = succeed_flag_num + 1
                else
                    succeed_flag_num = succeed_flag_num - 100
                end                     
            end

            if succeed_flag_num >= 9 then
                return true
            else
                return false
            end
        end



        local function remove_items_in_single_cycle()   --- 单次循环
            if items_enough_in_single_cycle() then
                for i = 1, 9, 1 do
                    local item_in_slot = slots[i] 
                    local item_arg_table = source_table[i] or {}
                    check_item_fit_with_arg(item_in_slot,item_arg_table,true)
                end
                return true
            end
            return false
        end


        for iiii = 1, 100, 1 do ---- 最多循环 100 次
            if not remove_items_in_single_cycle() then
                break
            else
                cycle_times = cycle_times + 1
                -- print("info  ",cycle_times)
            end
        end

        -- cycle_times     --- 循环的次数
        if reward_table and reward_table.prefab then
            local reward_num = reward_table.num or 1
            local total_reward_num = reward_num * cycle_times
            if total_reward_num > 0 then
                doer.components.fwd_in_pdt_func:GiveItemByPrefab(reward_table.prefab,total_reward_num)
            end
        end


    end)


end