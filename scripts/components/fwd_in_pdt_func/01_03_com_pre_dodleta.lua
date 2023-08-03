------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本模块是 hook 进玩家身上各种数值模块的 dodelta 使用
---- 在官方的代码执行之前进行拦截，并修改数值。同时需要严格的按照官方的数据格式填装和返回参数。
---- 角色三维 的 DoDelta  的 hook
---- 角色其他属性的 DoDelta 的hook （ 潮湿，温度 等 ）
---- 某些情况下可能会加重游戏运行负担。

---- 【重要说明】 函数执行失败记得返回原来的缺省值

---- 【hunger】 PreDoDelta_Add_Hunger_Fn/PreDoDelta_Remove_Hunger_Fn  => fn(hunger_com,delta,overtime,ignore_invincible)
---- 【sanity】 PreDoDelta_Add_Sanity_Fn/PreDoDelta_Remove_Sanity_Fn  => fn(sanity_com,delta,overtime)
---- 【health】 PreDoDelta_Add_Health_Fn/PreDoDelta_Remove_Health_Fn  =>  fn(health_com,amount,overtime,cause, ignore_invincible, afflicter, ignore_absorb)
---- 【health】 PreDoDelta_Add_HealthVal_Fn/PreDoDelta_Remove_HealthVal_Fn =>
---- 【笔记】 health 组件复杂一些，DoDelta 里面还有一条 SetVal ，SetVal 是设置血量并判断执行死亡的操作
---- 【temperature】 PreDoDelta_Add_Temperature_Fn/PreDoDelta_Remove_Temperature_Fn  =>  fn(temperature_com,delta)
---- 【moisture】 PreDoDelta_Add_Moisture_Fn/PreDoDelta_Remove_Moisture_Fn  => fn(moisture_com,num,no_announce)

---- 【笔记】 体温组件没那么严格，而且官方提供了 Event("temperaturedelta"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function main_com(fwd_in_pdt_func)    
    local inst = fwd_in_pdt_func.inst
    inst:AddTag("fwd_in_pdt_com.pre_dodelta")
    -- if inst.components.playercontroller == nil then
    --     return
    -- end
    fwd_in_pdt_func.TempData.PreDoDelta = {}
    ----------------------------------------------------------------------------------------
    local function remove_fn_from_table(old_table,fn)
        local new_table = {}
        for k, v in pairs(old_table) do
            if v ~= fn then
                table.insert(new_table,v)
            end
        end
        return new_table
    end
    ----------------------------------------------------------------------------------------
    --- hunger
        fwd_in_pdt_func.TempData.PreDoDelta.__hunger_fns = {}
        function fwd_in_pdt_func:PreDoDelta_Add_Hunger_Fn(fn)
            if type(fn) == fn then
                table.insert(self.TempData.PreDoDelta.__hunger_fns,fn)
            end
        end
        function fwd_in_pdt_func:PreDoDelta_Remove_Hunger_Fn(fn)
            if type(fn) == "function" then
                self.TempData.PreDoDelta.__hunger_fns = remove_fn_from_table(self.TempData.PreDoDelta.__hunger_fns,fn)
            end
        end
        if inst.components.hunger then
                inst.components.hunger.DoDelta__old__fwd_in_pdt_for_pre = inst.components.hunger.DoDelta
                inst.components.hunger.DoDelta = function(self,delta,overtime,ignore_invincible)
                    for k, fn in pairs(self.inst.components.fwd_in_pdt_func.TempData.PreDoDelta.__hunger_fns) do
                            -- local _delta,_overtime,_ignore_invincible = fn(self,delta,overtime,ignore_invincible)
                            -- delta               = _delta ~= nil and _delta or delta
                            -- overtime            = _overtime ~= nil and _overtime or overtime
                            -- ignore_invincible   = _ignore_invincible ~= nil and _ignore_invincible or ignore_invincible
                            delta,overtime,ignore_invincible = fn(self,delta,overtime,ignore_invincible)
                    end
                    return self:DoDelta__old__fwd_in_pdt_for_pre(delta, overtime, ignore_invincible)
                end
        end
    ----------------------------------------------------------------------------------------
    ---- sanity
        fwd_in_pdt_func.TempData.PreDoDelta.__sanity_fns = {}
        function fwd_in_pdt_func:PreDoDelta_Add_Sanity_Fn(fn)
            if type(fn) == "function" then
                table.insert( self.TempData.PreDoDelta.__sanity_fns,fn)
            end
        end
        function fwd_in_pdt_func:PreDoDelta_Remove_Sanity_Fn(fn)
            if type(fn) == "function" then
                self.TempData.PreDoDelta.__sanity_fns = remove_fn_from_table(self.TempData.PreDoDelta.__sanity_fns,fn)
            end
        end

        if inst.components.sanity then
            inst.components.sanity.DoDelta__old__fwd_in_pdt_for_pre = inst.components.sanity.DoDelta
            inst.components.sanity.DoDelta = function(self,delta, overtime)
                for k, fn in pairs(self.inst.components.fwd_in_pdt_func.TempData.PreDoDelta.__sanity_fns) do
                        -- local _delta,_overtime = fn(self,delta, overtime)
                        -- delta = _delta ~= nil and _delta or delta
                        -- overtime = _overtime ~= nil and _delta or overtime
                        delta , overtime = fn(self,delta,overtime)
                end
                return self:DoDelta__old__fwd_in_pdt_for_pre(delta,overtime)
            end
        end

    ----------------------------------------------------------------------------------------
    -- health 组件有 DoDelta  和 SetVal 可用,  SetVal 用来设置血量 并判断死亡
    -- 同时hook 两个操作更加自由
        fwd_in_pdt_func.TempData.PreDoDelta.__health_val_fns = {}
        fwd_in_pdt_func.TempData.PreDoDelta.__health_fns = {}
        function fwd_in_pdt_func:PreDoDelta_Add_HealthVal_Fn(fn)
            if type(fn) == "function" then
                table.insert(self.TempData.PreDoDelta.__health_val_fns,fn)
            end
        end
        function fwd_in_pdt_func:PreDoDelta_Remove_HealthVal_Fn(fn)
            if type(fn) == "function" then
                self.TempData.PreDoDelta.__health_val_fns  =  remove_fn_from_table(self.TempData.PreDoDelta.__health_val_fns,fn)
            end
        end
        function fwd_in_pdt_func:PreDoDelta_Add_Health_Fn(fn)
            if type(fn) == "function" then
                table.insert(self.TempData.PreDoDelta.__health_fns,fn)
            end
        end
        function fwd_in_pdt_func:PreDoDelta_Remove_Health_Fn(fn)
            if type(fn) == "function" then
                self.TempData.PreDoDelta.__health_fns  =  remove_fn_from_table(self.TempData.PreDoDelta.__health_fns,fn)
            end
        end
        if inst.components.health then

            inst.components.health.DoDelta__old__fwd_in_pdt_for_pre = inst.components.health.DoDelta
            inst.components.health.DoDelta = function(self,amount,overtime,cause, ignore_invincible, afflicter, ignore_absorb)
                for k, fn in pairs(self.inst.components.fwd_in_pdt_func.TempData.PreDoDelta.__health_fns) do
                    
                        -- local _amount,_overtime,_cause,_ignore_invincible,_afflicter,_ignore_absorb = fn(self,amount,overtime,cause, ignore_invincible, afflicter, ignore_absorb)
                        -- amount          = _amount ~= nil and _amount or amount
                        -- overtime        = _overtime ~= nil and _overtime or overtime
                        -- cause           = _cause ~= nil and _cause or cause
                        -- ignore_invincible = _ignore_invincible ~= nil and _ignore_invincible or ignore_invincible
                        -- afflicter       = _afflicter ~= nil and _afflicter or afflicter
                        -- ignore_absorb   = _ignore_absorb ~= nil and _ignore_absorb or ignore_absorb

                        amount,overtime,cause, ignore_invincible, afflicter, ignore_absorb = fn(self,amount,overtime,cause, ignore_invincible, afflicter, ignore_absorb)
                   
                end
                return self:DoDelta__old__fwd_in_pdt_for_pre(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
            end


            inst.components.health.SetVal__old__fwd_in_pdt_for_pre = inst.components.health.SetVal
            inst.components.health.SetVal = function(self,val,cause, afflicter)
                --- val 为新的血量值
                for k, fn in pairs(self.inst.components.fwd_in_pdt_func.TempData.PreDoDelta.__health_val_fns) do
                    
                        -- local _val,_cause,_afflicter = fn(self,val,cause, afflicter)
                        -- val          = _val ~= nil and _val or val
                        -- cause        = _cause ~= nil and _cause or val
                        -- afflicter    = _afflicter ~= nil and _afflicter or afflicter
                        val,cause, afflicter = fn(self,val,cause, afflicter)
                end
                return self:SetVal__old__fwd_in_pdt_for_pre(val,cause, afflicter)
            end

        end
    ----------------------------------------------------------------------------------------
    --- temperature 体温
        fwd_in_pdt_func.TempData.PreDoDelta.__temperature_fns = {}
        function fwd_in_pdt_func:PreDoDelta_Add_Temperature_Fn(fn)
            if type(fn) == "function" then
                table.insert(self.TempData.PreDoDelta.__temperature_fns,fn)
            end
        end
        function fwd_in_pdt_func:PreDoDelta_Remove_Temperature_Fn(fn)
            if type(fn) == "function" then
                self.TempData.PreDoDelta.__temperature_fns = remove_fn_from_table(self.TempData.PreDoDelta.__temperature_fns,fn)
            end
        end
        if inst.components.temperature then
            inst.components.temperature.DoDelta__old__fwd_in_pdt_for_pre = inst.components.temperature.DoDelta
            inst.components.temperature.DoDelta = function(self,delta)
                for k, fn in pairs(self.inst.components.fwd_in_pdt_func.TempData.PreDoDelta.__temperature_fns) do
                    delta = fn(self,delta)
                end
                return self:DoDelta__old__fwd_in_pdt_for_pre(delta)
            end
        end
    ----------------------------------------------------------------------------------------
    ---- 潮湿度 moisture
        fwd_in_pdt_func.TempData.PreDoDelta.__moisture_fns = {}
        function fwd_in_pdt_func:PreDoDelta_Add_Moisture_Fn(fn)
            if type(fn) == "function" then
                table.insert(self.TempData.PreDoDelta.__moisture_fns,fn)
            end
        end
        function fwd_in_pdt_func:PreDoDelta_Remove_Moisture_Fn(fn)
            if type(fn) == "function" then
                self.TempData.PreDoDelta.__moisture_fns = remove_fn_from_table(self.TempData.PreDoDelta.__moisture_fns,fn)
            end
        end
        if inst.components.moisture then
            inst.components.moisture.DoDelta__old__fwd_in_pdt_for_pre = inst.components.moisture.DoDelta
            inst.components.moisture.DoDelta = function(self,num,no_announce)
                for k, fn in pairs(self.inst.components.fwd_in_pdt_func.TempData.PreDoDelta.__moisture_fns) do
                    num,no_announce = fn(self,num,no_announce)
                end
                return self:DoDelta__old__fwd_in_pdt_for_pre(num, no_announce)
            end
        end
    ----------------------------------------------------------------------------------------
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function replica(fwd_in_pdt_func)
    
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    if not fwd_in_pdt_func.inst:HasTag("player") then
        return
    end
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else               
        replica(fwd_in_pdt_func)
    end

end