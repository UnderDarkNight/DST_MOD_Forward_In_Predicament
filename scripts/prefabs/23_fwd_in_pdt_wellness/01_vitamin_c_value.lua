----------------------------------------------------------------------------------------------------------------------------------
--- VC值相关的
--- 只有执行函数，不做任何数据存储
----------------------------------------------------------------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_welness_vc"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    -- Asset("ANIM", "anim/fwd_in_pdt_jade_coins.zip"),
    -- Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_jade_coin_green.tex" ),
    -- Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_jade_coin_green.xml" ),
    -- Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_jade_coin_black.tex" ),
    -- Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_jade_coin_black.xml" ),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
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
    -- 数据读取/储存。先做一个占位， _OnAttached 后重构。
        inst._Get = function(...) return nil end
        inst._Set = inst._Gett
        inst._Add = function(...) return 0 end

    ------------------------------------------------------------------------------
    -- 添加的瞬间执行的函数组，onload 之前也会读取一次。直接绑定给父节点
        function inst:_OnAttached(fwd_in_pdt_wellness)
            --------------------------------------------------------
            -- 必须要做的，模板化模块 
                self.fwd_in_pdt_wellness = fwd_in_pdt_wellness
                function self:_Get(...)
                    return self.fwd_in_pdt_wellness:Get(...)
                end
                function self:_Set(...)
                    self.fwd_in_pdt_wellness:Set(...)
                end
                function self:_Add(...)
                    return self.fwd_in_pdt_wellness:Add(...)
                end
                self.player = fwd_in_pdt_wellness.inst  --- 玩家链路进来到这
            --------------------------------------------------------
            -- 执行初始化，初始给100
                self:_Set("vitamin_c",self:_Get("vitamin_c") or 100)
            --------------------------------------------------------            
        end
    ------------------------------------------------------------------------------
    -- onload 的时候调用这个。之前会有 inst:_OnAttach(...) 执行，不怕_Get不到数据
        function inst:_OnLoad()
            -------- 没什么数据需要onload 处理的
        end
    ------------------------------------------------------------------------------
    -- 周期性刷新的时候执行,附带return
        function inst:_OnUpdate()
            local num = self:_Add("vitamin_c",0)
            ------- 低于15 点添加定期掉 San 任务
            if num < 15 and self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task == nil then
                self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task = self.player:DoPeriodicTask(2,self.__low_value_task_fn)
            elseif num >= 15 and self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task then
                self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task:Cancel()
                self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task = nil
            end
            return 0.8* num / 100
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:_OnDetached()
            --------
            -- self._Set("vitamin_c",nil)
            if self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task then
                self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task:Cancel()
                self.fwd_in_pdt_wellness.___fwd_in_pdt_welness_vc__low_value_task = nil
            end
        end
    ------------------------------------------------------------------------------
    --  文本信息读取
        function inst:_GetStringsTable()
            return GetStringsTable(self.prefab) or {}
        end
    ------------------------------------------------------------------------------
    --- 根据策划案的需求，进行相关的自身操作
        inst:WatchWorldState("cycles", function()   --- 每天 -1 点
            inst:_Add("vitamin_c",-1)
        end)
        
        inst.__low_value_task_fn = function(player)
            if player.components.sanity then
                player.components.sanity:DoDelta(-1)
            end
        end

    ------------------------------------------------------------------------------



    return inst
end

return Prefab("fwd_in_pdt_welness_vc", fn, assets)