----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    需要在  TheWorld.ismastersim return 前加载


    fishing_pre -> fishing -> catch -> hook


    目标点检查 ： self:Add_Point_Check_Fn(function(item,doer,pt)    end)
    开始钓鱼 ： self:Add_Start_Fn(function(item,doer,pt)    end)

]]-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_special_fishingrod = Class(function(self, inst)
    self.inst = inst

    self.__point_chek_fn = nil
    self.time = 5
    -- inst:PushEvent("unequipped", { owner = owner })
    inst:ListenForEvent("unequipped",function(_,_table)
        if _table and _table.owner then
            _table.owner:PushEvent("fwd_in_pdt_com_special_fishingrod.unequiped")
            self:CancelFishingTask()
            self:SetCatched(false)            
        end
    end)
end)
---------------------------------------------------------------------------------
---- 目标点检查
    function fwd_in_pdt_com_special_fishingrod:Add_Point_Check_Fn(fn)
        if type(fn) == "function" then
            self.__point_chek_fn = fn
        end
    end

    function fwd_in_pdt_com_special_fishingrod:Point_Test(doer,pt)
        if self.__point_chek_fn ~= nil and pt and pt.x then
            return self.__point_chek_fn(self.inst,doer,pt)
        end
        return false
    end
---------------------------------------------------------------------------------
--- 垂钓时间
    function fwd_in_pdt_com_special_fishingrod:Set_Fishing_Time(num)
        if type(num) == "number" then
            self.time = num
        end
    end
---------------------------------------------------------------------------------
--- 开始垂钓
    function fwd_in_pdt_com_special_fishingrod:Add_Start_Fn(fn)
        if type(fn) == "function" then
            self.___start_fn = fn
        end
    end
    function fwd_in_pdt_com_special_fishingrod:Start_Fishing(doer,pt)
        self.pt = pt
        self.player = doer
        if self.___start_fn then
            self.___start_fn(self.inst,doer,pt)
        end
        self:StartFishingTask(self.time)

    end
    function fwd_in_pdt_com_special_fishingrod:CancelFishingTask()
        if self.fishing_task then
            self.fishing_task:Cancel()
        end
        self.fishing_task = nil
        -- self:SetCatched(false)
    end
    
    function fwd_in_pdt_com_special_fishingrod:StartFishingTask(num)
        self:CancelFishingTask()
        self:SetCatched(false)

        self.fishing_task = self.inst:DoTaskInTime(num,function()
            if self.player and self.player.sg and self.player.sg:HasStateTag("fishing") then
                self.player:PushEvent("fwd_in_pdt_com_special_fishingrod.catched")  --- 往SG 推送 event
                self:SetCatched(true)
            end
        end)
    end        
    
---------------------------------------------------------------------------------
--- 起钓。
    function fwd_in_pdt_com_special_fishingrod:Add_Start_Hook_Fn(fn)
        if type(fn) == "function" then
            self.___start_hook_fn = fn
        end
    end
    function fwd_in_pdt_com_special_fishingrod:Start_Hook()
        if self.___start_hook_fn then
            self.___start_hook_fn(self.inst,self.player,self.pt)
        end
    end
    function fwd_in_pdt_com_special_fishingrod:Add_Hook_End_Fn(fn)
        if type(fn) == "function" then
            self.___hook_end_fn = fn
        end
    end
    function fwd_in_pdt_com_special_fishingrod:Hook_End()
        if self.___hook_end_fn then
            self.___hook_end_fn(self.inst,self.player,self.pt)
        end
        self.player = nil
        self.pt = nil
        self:SetCatched(false)
        self:CancelFishingTask()
    end
---------------------------------------------------------------------------------
--- 状态配置  fishing -> catch
    function fwd_in_pdt_com_special_fishingrod:IsCatched()
        return self.inst:HasTag("fwd_in_pdt_tag.catched")    
    end
    function fwd_in_pdt_com_special_fishingrod:SetCatched(flag)
        if flag then
            self.inst:AddTag("fwd_in_pdt_tag.catched")
        else
            self.inst:RemoveTag("fwd_in_pdt_tag.catched")
        end
    end

---------------------------------------------------------------------------------
--- 起钓bank
    function fwd_in_pdt_com_special_fishingrod:SetFishBuild(bank)
        self.fish_bank = bank
    end
    function fwd_in_pdt_com_special_fishingrod:GetFishBuild()
        local temp = self.fish_bank
        self.fish_bank = nil
        return temp
    end
---------------------------------------------------------------------------------
return fwd_in_pdt_com_special_fishingrod
