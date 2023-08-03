--- --- hook  掉 inst.AnimState  不依赖mod加载优先级，方便和其他MOD兼容

TUNING["Forward_In_Predicament.AnimStateFn"]= {}

----------------------------------------------------------------------------------------------------------------------------------------
------ 正在开发的模块
if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    -- modimport("Key_Modules_Of_FWD_IN_PDT/04_AnimState_Hook/00_PlayAnim_PushAnim.lua")    --- 更新 PlayAnimation 和 PushAnimation 
    modimport("Key_Modules_Of_FWD_IN_PDT/04_AnimState_Hook/01_OverrideSymbol.lua")    --- build fn    
end
---------------------------------------------------------------------------------------------------------------
------ 可以上线使用的模块
modimport("Key_Modules_Of_FWD_IN_PDT/04_AnimState_Hook/00_PlayAnim_PushAnim.lua")    --- 更新 PlayAnimation 和 PushAnimation 


---------------------------------------------------------------------------------------------------------------
local function theAnimState_fn_Upgrade(theAnimState)
    for fn_name, fn in pairs(TUNING["Forward_In_Predicament.AnimStateFn"]) do
        if fn and type(fn) == "function" then
            fn(theAnimState)
        end
    end
end


local function Hook_Player_AnimState(inst)

    if type(inst.AnimState) == "userdata" then            ----- 只能转变一次，重复的操作 会导致  __index 函数错误
        --------------------------------------------------------------------------------------------------------------------------------
            inst.__AnimState_userdata_fwd_in_pdt = inst.AnimState      ----- 转移复制原有 userdata
            inst.AnimState = {inst = inst , name = "AnimState"}   ----- name 是必须的，用于 从 _G  里 得到目标, 玩家 inst 也是从这里进入
            ------ 逻辑上复现棱镜模组的代码：

            setmetatable( inst.AnimState , {
                __index = function(_table,fn_name)
                            if _table and _table.inst and _table.name then

                                    if _G[_table.name][fn_name] then    ---- 从_G全局里得到原函数？？这句并不好理解。   ---- lua 会往_G 里自动挂载所有要运行的 userdata ？？
                                        local _table_name = _table.name
                                        local fn = function(temp_table,...)
                                            return _G[_table_name][fn_name](temp_table.inst.__AnimState_userdata_fwd_in_pdt,...)
                                        end
                                        rawset(_table,fn_name,fn)
                                        return fn
                                    end

                            end
                end,
            })
        --------------------------------------------------------------------------------------------------------------------------------
    else
        print("warning : ThePlayer.AnimState is already a table ")    
    end

    ------- 成功把  inst.AnimState 从  userdata 变成 table
    --------------------- 挂载函数
    if inst.AnimState.inst ~= inst then
        inst.AnimState.inst = inst
    end
    ---------------------
    theAnimState_fn_Upgrade(inst.AnimState)
    print("FWD_IN_PDT hook player AnimState finish")
end

AddPlayerPostInit(function(inst)
    ------------ 为了处理棱镜的兼容问题，只能 DoTaskInTime 0 的时候执行了,棱镜的HOOK API 并没有考虑 其他MOD也同样原理 hook。
    ------------ 目标是把 AnimState 从  userdata 转为  table ，哪个MOD优先转换不重要。
    ------------ 幻化相关的代码放到 DoTaskInTime 0.1 执行
    if not TheWorld.ismastersim then    ------ hook 服务端足够了
        return
    end

    -- inst:DoTaskInTime(0,Hook_Player_AnimState)
    -- inst:ListenForEvent("fwd_in_pdt_event.hook_player_AnimState",Hook_Player_AnimState)
    inst:ListenForEvent("fwd_in_pdt_event.entity_spawned",Hook_Player_AnimState)
    
end)

-- ----------------- 尝试在 DoTaskInTime 0 之前执行HOOK 
-- AddPrefabPostInit(
--     "world",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end
            
--         inst:ListenForEvent("entity_spawned",function(_,spawned_inst)
--             if spawned_inst and spawned_inst:HasTag("player") and spawned_inst.userid then
--                 spawned_inst:PushEvent("fwd_in_pdt_event.hook_player_AnimState")
--             end
--         end)

--     end
-- )





























---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------ 下面这些用来备份留档说明。  --- 看不懂棱镜逻辑的时候过来看这里
--[[
local function Hook_Player_AnimState(inst)

    if type(inst.AnimState) == "userdata" then            ----- 只能转变一次，重复的操作 会导致  __index 函数错误
        inst.__AnimState_userdata_fwd_in_pdt = inst.AnimState      ----- 转移复制原有 userdata
        inst.__AnimState_new_fns_fwd_in_pdt = {}                ----- 新的函数在这里面， __index 里挂进去

        inst.AnimState = {inst = inst,name = "AnimState"}   ----- name 是必须的，用于 从 _G  里 得到目标, 玩家 inst 也是从这里进入
        ----------------------------------- 这里复现了 棱镜 hook userdata 的代码，有些 东西可能用不上。
        setmetatable(inst.AnimState,{
            __index = function(_table,fn_name)
                        if _table and _table.inst and _table.name then
                            ------ 逻辑上复现棱镜模组的代码：

                                -- 下面这段【大概】是棱镜里 给多个 userdata hook 时候用的，方便统一的路径寻找。
                                if _table.inst.__AnimState_new_fns_fwd_in_pdt[fn_name] then                       ----- 如果有hook过的函数，直接调用
                                    rawset(_table,fn_name,_table.inst.__AnimState_new_fns_fwd_in_pdt[fn_name])
                                    return _table.inst.__AnimState_new_fns_fwd_in_pdt[fn_name]
                                end

                                if _G[_table.name][fn_name] then    ---- 从_G全局里得到原函数？？这句并不好理解。   ---- lua 会往_G 里自动挂载所有要运行的 userdata ？？
                                    local _table_name = _table.name
                                    local fn = function(temp_table,...)
                                        return _G[_table_name][fn_name](temp_table.inst.__AnimState_userdata_fwd_in_pdt,...)
                                    end
                                    _table.inst.__AnimState_new_fns_fwd_in_pdt[fn_name] = fn      -- 缓存生成的镜像函数
                                    rawset(_table,fn_name,fn)
                                    return fn
                                end

                        end
            end,
        })
        ---------------- 成功把  inst.AnimState 从  userdata 变成 table
    end

    --------------------- 挂载函数
    if inst.AnimState.inst ~= inst then
        inst.AnimState.inst = inst
    end
    ---------------------
    theAnimState_fn_Upgrade(inst.AnimState)

end
]]----