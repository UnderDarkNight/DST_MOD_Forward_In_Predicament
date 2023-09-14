----------------------------------------------------------------------------------------------------------------------------------
--- 本文件致力于 添加个 屏蔽检测。所有毒的前置屏蔽都可以在这进行相关计数。


--- 只有执行函数，不做任何数据存储。


--- 按天数计数的屏蔽，相关计数器放置于 OnUpdate 进行加减。
--- 使用 com:Set(index,num)    com:Get(index)   com:Add(index,num)   来读写参数

--- 【注意】 index字段的命名唯一性！！！！所有 体质值 的数据在同一个 table 里，字段命名不规范会覆盖！！
--- 【注意】 index字段的命名唯一性！！！！所有 体质值 的数据在同一个 table 里，字段命名不规范会覆盖！！
--- 【注意】 index字段的命名唯一性！！！！所有 体质值 的数据在同一个 table 里，字段命名不规范会覆盖！！
--- 【注意】 index字段的命名唯一性！！！！所有 体质值 的数据在同一个 table 里，字段命名不规范会覆盖！！
--- 【注意】 index字段的命名唯一性！！！！所有 体质值 的数据在同一个 table 里，字段命名不规范会覆盖！！


--- 作为常驻项目。

--[[

    关键外部API 说明：
    ·  inst:OnUpdate()                 每个扫描周期内都会执行的函数。默认执行周期为 5秒

]]--



----------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------
    -- 预添加本Debuff 的时候检查函数，如果通过，则添加，不通过，则不添加
        function inst:PreAttach(com)
            return true
        end
    ------------------------------------------------------------------------------
    -- 添加的瞬间执行的函数组。直接绑定给父节点 
        function inst:OnAttached(com)
            --------------------------------------------------------
              

            --------------------------------------------------------     
                        
        end
    ------------------------------------------------------------------------------
    -- 重复添加的时候执行的函数
        function inst:RepeatedlyAttached()
            
        end
    ------------------------------------------------------------------------------
    -- 周期性刷新的时候执行
        function inst:OnUpdate()
           --[[
                按照1天执行100次计算
           ]]--


            ----------------------------------------
            --- 蛇毒计数器。蛇毒里的 inst:PreAttach() 调用检查
                local snake_poison_blocker_times = self.com:Add("snake_poison_blocker_update_times",-1)
                if snake_poison_blocker_times < -10 then
                    self.com:Set("snake_poison_blocker_update_times",-1)
                end

        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()

        end
    ------------------------------------------------------------------------------
    -- 强制刷新，给道具使用的时候执行的
        function inst:ForceRefresh()

        end
    ------------------------------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_welness_poison_blocker", fn)