------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 配方函数
----- server/client 都执行
----- 挂载去 event   itemget  / itemlose
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    API 说明：
    · player_check_fn = nil or  function(doer)   end，    ---- 用来检测指定玩家状态是否允许使用本配方。 return true 为允许。注意 server和client都会执行。注意区别。
    · source 内部9个为对应每个格子的需求参数。 
            - 【注意】 如果该格子里不需要任何东西，空的 table 就行了。
            - 【必须】 prefab          消耗/使用的物品 
            - 【必须】 num             消耗的数量。如果是带耐久度的物品，则【默认】消耗点数1。
            - 【可选】 use             该物品有耐久度，使用多少点 。  item_in_slot.components.finiteuses:Use( ... )
            - 【可选】 remove          给有耐久度的消耗品使用。可直接消耗掉带耐久度的物品。
            - 【可选】 no_loss         true 的时候不消耗本格子的东西，包括耐久度。用于一些特殊的拥有权检查。
    · ret 为奖励执行参数。 ( server side only )
            - 【必须】 prefab          奖励的物品
            - 【必须】 num             奖励的数量
            - 【必须】 atlas           切片xml文件路径。如果是默认的【images\inventoryimages】路径，推荐使用 GetInventoryItemAtlas("walrus_tusk.tex")
            - 【必须】 image           tex贴图文件名。如 "walrus_tusk.tex"
            - 【可选】 finish_fn       奖励发放之后的执行函数，nil 或者 function(inst,doer,times) end , times 为奖励发放次数（给给多个循环使用）
            - 【可选】 item_fn         奖励发放之后，触发对应奖励的执行函数。 nil 或者 function(rewarded_items_insts,doer) end。 其中的 rewarded_items_insts 为发放的物品inst集合成的table
            - 【可选】 overwrite_str   显示的文字特殊化。
        -------------------------------------------------------------------------------------------------------------
                ---- 示例
                    player_check_fn = function(doer)  --- 配方权限检查
                        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                            return true
                        else
                            return false
                        end
                    end，    
                    source = {     
                        {                          } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
                        {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
                        {prefab = "log" , num = 1, } ,  {prefab = "log" , num = 1, },   {prefab = "log" , num = 1, },
                    },
                    ret = {
                        prefab = "walrus_tusk",
                        num = 1,
                        atlas =  GetInventoryItemAtlas("walrus_tusk.tex"),
                        image =  "walrus_tusk.tex",
                        finish_fn = function(inst,doer,times) 
                            --- 给奖励后执行的函数。
                            --- times -- 奖励次数
                        end,
                        item_fn = function(rewarded_items_insts,doer) --- 用来触发某些奖励物品的执行事件
                            for k, item in pairs(rewarded_items_insts) do
                                --- 
                            end
                        end,
                    }
                },
        -------------------------------------------------------------------------------------------------------------
]]--

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


return function(inst)
    


    local recipes = require("prefabs/06_fwd_in_pdt_containers/03_special_production_table_recipes") or {}

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
                            image =  "walrus_tusk.tex",
                            finish_fn = function(inst,doer,times)
                                --- 给奖励后执行的函数。
                                --- times -- 奖励次数
                            end,
                            item_fn = function(rewarded_items_insts,doer) --- 用来触发某些奖励物品的执行事件
                    
                            end,
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
                            image =  "transistor.tex",
                            finish_fn = function(inst,doer,times)
                                --- 给奖励后执行的函数。
                                --- times -- 奖励次数
                            end,
                            item_fn = function(rewarded_items_insts,doer) --- 用来触发某些奖励物品的执行事件
                    
                            end,
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


    local function get_ret_cmd_table_by_slots(slots,doer)
        local function check_item_fit_with_arg_for_widget(item_in_slot,item_arg_table)
            if item_in_slot == nil and ( item_arg_table == nil or item_arg_table.prefab ==  nil) then
                return true
            end
            if item_in_slot and item_in_slot.prefab and item_arg_table and item_arg_table.prefab == item_in_slot.prefab then
                local arg_num = item_arg_table.num or 1
                local current_num = 1
                if item_in_slot.replica.stackable then
                    current_num = item_in_slot.replica.stackable:StackSize()
                end
                if current_num < arg_num then   --- 个数不够
                    return false
                end
                ---- 个数够了
                return true
            end
            return false
        end

        for k, current_recipe in pairs(recipes) do
                --------- 检查 9 个格子里是否都满足条件。
                local flag_num = 0
                if current_recipe.source and current_recipe.ret then
                    if current_recipe.player_check_fn and not current_recipe.player_check_fn(doer) then
                        flag_num = flag_num - 100
                    end
                    for i, item_arg_table in pairs(current_recipe.source) do
                                local the_slot_item = slots[i]
                                if check_item_fit_with_arg_for_widget(the_slot_item,item_arg_table) then
                                    flag_num = flag_num + 1
                                else
                                    flag_num = flag_num - 100
                                end
                    end
                end

                if flag_num >= 9 then
                    return current_recipe
                end

        end

        return nil
    end





    local function item_get_or_lose(inst)
        if TheNet:IsDedicated() then
            return
        end
        -- if not ThePlayer then
        --     return
        -- end
        local slots = inst.replica.container:GetItems()
        local doer = ThePlayer
        local ret_recipe_cmd = get_ret_cmd_table_by_slots(slots,doer)
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
        local openers = inst.components.container:GetOpeners()
        local doer = openers[1]
        local ret_recipe_cmd = get_ret_cmd_table_by_slots(slots,doer)

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
        if recipe.player_check_fn and not recipe.player_check_fn(doer) then
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

                if item_arg_table.no_loss then   --- 本格子无任何消耗。
                    return true
                end

                if item_in_slot.components.finiteuses == nil then   --- 不带耐久度的东西

                    if item_in_slot.components.stackable then
                        item_in_slot.components.stackable:Get(arg_num):Remove()
                    else
                        item_in_slot:Remove()
                    end

                else
                    if not item_arg_table.remove then
                        local use = item_arg_table.use or 1
                        item_in_slot.components.finiteuses:Use(use)
                    else
                        item_in_slot:Remove()
                    end                    
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
                local reward_item_insts = doer.components.fwd_in_pdt_func:GiveItemByPrefab(reward_table.prefab,total_reward_num) or {}
                if reward_table.item_fn then
                    reward_table.item_fn(reward_item_insts,doer)
                end
            end
            if reward_table.finish_fn then
                reward_table.finish_fn(inst,doer,cycle_times)
            end
        end


    end)


end