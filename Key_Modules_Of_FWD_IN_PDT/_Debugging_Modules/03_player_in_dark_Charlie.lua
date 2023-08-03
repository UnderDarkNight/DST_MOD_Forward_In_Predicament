-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 用来找出和屏蔽查理

-- 查理的攻击 操作都来自于玩家身上的 inst:AddComponent("grue")
-- inst.components.grue:SetSounds("dontstarve/charlie/warn","dontstarve/charlie/attack")
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)
	if not TheWorld.ismastersim then
        return
    end



    -- inst:ListenForEvent("attacked",function(_,_table)
    --     if _table and _table.attacker then
    --         print(_table.attacker)
    --     end
    -- end)

    -- inst.components.health.DoDelta__old_test = inst.components.health.DoDelta
    -- inst.components.health.DoDelta = function(self,amount, overtime, cause,...)
    --     print("DoDelta ",amount,cause)
    --     return self:DoDelta__old_test(amount, overtime, cause,...)
    -- end


    -- if inst.components.grue then
    --     inst.components.grue.OnUpdate_test_old = inst.components.grue.OnUpdate
    --     inst.components.grue.OnUpdate = function(self,...)
    --         if self.inst:HasTag("fwd_in_pdt_tag.avoid_charlie") then                
    --             return
    --         else
    --             return self:OnUpdate_test_old(...)
    --         end
    --     end
    -- end

    -- ThePlayer:AddTag("fwd_in_pdt_tag.avoid_charlie")


    inst:DoTaskInTime(0,function()
        inst.components.fwd_in_pdt_func:Set_Block_Charlie_Attack(true)
    end)

end)


