------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本文件处理 LongUpdate 的问题，尝试解决 超出玩家加载范围，又重新进入加载范围后的相关处理
---- fn 格式：  func（inst,dt)

----- 利用 OnEntitySleep/OnEntityWake API，实体inst 进出玩家加载范围的时候会执行这个。 
-----【注意】游戏读档加载的时候也会执行。同时还有  POPULATING  参数参与（用法未知）。
-----【注意】 OnEntitySleep 只会在Server 上执行，OnEntityWake 会在Server 和 Client 上都执行，而且在 Client上执行2次。
-----【注意】 OnEntitySleep 会在游戏读档的时候执行一次。

---- 函数在client 会偶发性执行2次，暂时不知道为什么，推测是 net_vars 出现重复问题。
---- dt参数在 client 一直为0,所以屏蔽 该模块在 client 的存在
---- 
---- 由于使用了 os.time() 作为 LongUpdate 的时间参数，会在暂停 等操作的时候，继续计时。时间差会有出入。所以使用饥荒的API： GetTime()
---- 天数 TheWorld.state.cycles 可以作为辅助

---- LongUpdate 在跳天数的时候会在加载范围外执行。OnEntityWake 的时候也会执行（ ________LongUpdate_fns__last_time） 。

---- 【笔记】脑抽了，官方提供了 event entitywake / entitysleep ，这个组件不是在这方面必须的了。
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


return function(fwd_in_pdt_func)
    if not TheWorld.ismastersim then
        return
    end
    --------------------------------------------------------------------------------------
    
    fwd_in_pdt_func.tempData.________LongUpdate_fns = {}
    fwd_in_pdt_func.tempData.________LongUpdate_fns__last_time = GetTime()
    fwd_in_pdt_func.tempData.________OnEntitySleep_Fns = {}
    fwd_in_pdt_func.tempData.________OnEntityWake_Fns = {}


    --------------------------------------------------------------------------------------
    ------ LongUpdate 专用(可以用于植物等生长，记秒)
    function fwd_in_pdt_func:Add_LongUpdate_Func(fn)
        if fn and type(fn) == "function" then
            table.insert(self.tempData.________LongUpdate_fns,fn)
        end
    end
    function fwd_in_pdt_func:Remove_LongUpdate_Func(fn)
        if fn then
            local new_table = {}
            for k, temp_fn in pairs(self.tempData.________LongUpdate_fns) do
                if temp_fn ~= fn then
                    table.insert(new_table,temp_fn)
                end
            end
            self.tempData.________LongUpdate_fns = new_table
        end
        
    end

    function fwd_in_pdt_func:LongUpdate(dt)   --- dt 参数单位：秒
        for k, func in pairs(self.tempData.________LongUpdate_fns) do
            func(self.inst,dt)
        end
    end
    --------------------------------------------------------------------------------------
    ---- 添加/删除 OnEntitySleep 用的fn
    function fwd_in_pdt_func:Add_OnEntitySleep_Fn(fn)
        if fn and type(fn) == "function" then
            table.insert(self.tempData.________OnEntitySleep_Fns, fn)
        end
    end
    function fwd_in_pdt_func:Remove_OnEntitySleep_Fn(fn)
        if fn then
            local new_table = {}
            for k, temp_fn in pairs(self.tempData.________OnEntitySleep_Fns) do
                if temp_fn ~= fn then
                    table.insert(new_table,temp_fn)
                end
            end
            self.tempData.________OnEntitySleep_Fns = new_table
        end
    end
    --------------------------------------------------------------------------------------
    ---- 添加/删除 OnEntityWake 用的fn

    function fwd_in_pdt_func:Add_OnEntityWake_Fn(fn)
        if fn and type(fn) == "function" then
            table.insert(self.tempData.________OnEntityWake_Fns, fn)
        end
    end
    function fwd_in_pdt_func:Remove_OnEntityWake_Fn(fn)
        if fn then
            local new_table = {}
            for k, temp_fn in pairs(self.tempData.________OnEntityWake_Fns) do
                if temp_fn ~= fn then
                    table.insert(new_table, temp_fn)
                end
            end
            self.tempData.________OnEntityWake_Fns = new_table
        end
    end

    --------------------------------------------------------------------------------------

    function fwd_in_pdt_func:OnEntitySleep()
        -- print("OnEntitySleep",math.random(100))
        self.tempData.________LongUpdate_fns__last_time = GetTime()
        if #self.tempData.________OnEntitySleep_Fns > 0 then
            for k, fn in pairs(self.tempData.________OnEntitySleep_Fns) do
                fn(self.inst)
            end
        end

    end

    function fwd_in_pdt_func:OnEntityWake()
        -- print("OnEntityWake",math.random(100))
        local dt = GetTime() - self.tempData.________LongUpdate_fns__last_time
        self:LongUpdate(dt)
        self.tempData.________LongUpdate_fns__last_time = GetTime()

        if #self.tempData.________OnEntityWake_Fns > 0 then
            for k, fn in pairs(self.tempData.________OnEntityWake_Fns) do
                fn(self.inst)
            end
        end

    end

    --------------------------------------------------------------------------------------
end