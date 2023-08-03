-- local test_action_change = function(self)    ----- 修改 wilson 和 wilson_client 的动作返回捕捉
--     -- local old_ATTACK = self.actionhandlers[ACTIONS.ATTACK].deststate
--     -- self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst,action)
--     --     if inst:HasTag("demigod_panda") then
--     --         local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
--     --         -- local target = inst.components.combat ~= nil and inst.components.combat.target or nil

--     --         if weapon == nil and inst.replica and inst.replica.combat then  ----------- 客机用这个replica方法执行
--     --             weapon = inst.replica.combat:GetWeapon() or nil
--     --         end
--     --         -- if target == nil and inst.replica and inst.replica.combat then
--     --         --     target = inst.replica.combat:GetTarget()
--     --         -- end

--     --         if weapon and weapon.prefab == "panda_bamboo_cane" then
--     --             local theActionTable = {
--     --                 ["chop_attack"] = true,
--     --                 ["atk_prop_pre"] = true,
--     --                 ["multithrust_pre"] = true,
--     --                 ["helmsplitter_pre"] = true,
--     --             }
                
--     --             if weapon.attack_action and theActionTable[weapon.attack_action] == true then   ------- 手柄情况下连续攻击不太正常，用这个方法切回原始的攻击动作
--     --                 return "attack_bamboo_cane"
--     --             end

--     --         end
--     --     end
        
--     --     return old_ATTACK(inst, action)
--     -- end

--     -- print("fake error ++++++++++:",self)


-- end
-- AddStategraphPostInit("wilson", test_action_change)  ----------- 加给 主机 （成功）



-- for k, v in pairs(ThePlayer.sg.sg.actionhandlers[ACTIONS.GIVE].action) do
--     print(k,v)
-- end


-- require("actions")

-- ACTIONS.GIVE.fn_old = ACTIONS.GIVE.fn
-- ACTIONS.GIVE.fn = function(...)
--     local ret1,ret2,ret3,ret4 = ACTIONS.GIVE.fn_old(...)
--     print("GIVE.fn:",ret1,ret2,ret3,ret4)
--     return ret1,ret2,ret3,ret4
-- end

-- ACTIONS.GIVE.strfn_old = ACTIONS.GIVE.strfn
-- ACTIONS.GIVE.strfn = function(...)
--     local ret1,ret2,ret3,ret4 = ACTIONS.GIVE.strfn_old(...)
--     print("ACTIONS.GIVE.strfn_old : ",ret1,ret2,ret3,ret4)
--     return ret1,ret2,ret3,ret4
-- end

-- ACTIONS.GIVE.stroverridefn_old = ACTIONS.GIVE.stroverridefn
-- ACTIONS.GIVE.stroverridefn = function(...)
--     local ret1,ret2,ret3,ret4 = ACTIONS.GIVE.stroverridefn_old(...)
--     print("ACTIONS.GIVE.stroverridefn",ret1,ret2,ret3,ret4)
--     return ret1,ret2,ret3,ret4
-- end


--------------------------------------------------------------------------------------------
-- #. STRINGS.ACTIONS.ADDCOMPOSTABLE
-- msgctxt "STRINGS.ACTIONS.ADDCOMPOSTABLE"
-- msgid "Give"
-- msgstr "给予"

-- #. STRINGS.ACTIONS.COMPARE_WEIGHABLE
-- msgctxt "STRINGS.ACTIONS.COMPARE_WEIGHABLE"
-- msgid "Give"
-- msgstr "给予"

-- #. STRINGS.ACTIONS.GIVE.GENERIC
-- msgctxt "STRINGS.ACTIONS.GIVE.GENERIC"
-- msgid "Give"
-- msgstr "给予"

-- #. STRINGS.ACTIONS.GIVETOPLAYER
-- msgctxt "STRINGS.ACTIONS.GIVETOPLAYER"
-- msgid "Give"
-- msgstr "给予"

-- #. STRINGS.ACTIONS.GIVE_TACKLESKETCH
-- msgctxt "STRINGS.ACTIONS.GIVE_TACKLESKETCH"
-- msgid "Give"
-- msgstr "给予"
--------------------------------------------------------------------------------------------

ACTIONS.ADDCOMPOSTABLE.fn_old = ACTIONS.ADDCOMPOSTABLE.fn
ACTIONS.ADDCOMPOSTABLE.fn = function(...)
    local ret1,ret2,ret3,ret4  = ACTIONS.ADDCOMPOSTABLE.fn_old(...)
    print("ACTIONS.ADDCOMPOSTABLE.fn",ret1,ret2,ret3,ret4)
    return ret1,ret2,ret3,ret4
end

ACTIONS.COMPARE_WEIGHABLE.fn_old = ACTIONS.COMPARE_WEIGHABLE.fn
ACTIONS.COMPARE_WEIGHABLE.fn = function(...)
    local ret1,ret2,ret3,ret4  = ACTIONS.COMPARE_WEIGHABLE.fn_old(...)
    print("ACTIONS.COMPARE_WEIGHABLE.fn",ret1,ret2,ret3,ret4)
    return ret1,ret2,ret3,ret4
end



ACTIONS.GIVETOPLAYER.fn_old = ACTIONS.GIVETOPLAYER.fn
ACTIONS.GIVETOPLAYER.fn = function(...)
    local ret1,ret2,ret3,ret4 = ACTIONS.GIVETOPLAYER.fn_old(...)
    print("ACTIONS.GIVETOPLAYER.fn_old",ret1,ret2,ret3,ret4)
    return ret1,ret2,ret3,ret4
end

ACTIONS.GIVE_TACKLESKETCH.fn_old = ACTIONS.GIVE_TACKLESKETCH.fn
ACTIONS.GIVE_TACKLESKETCH.fn = function(...)
    local ret1,ret2,ret3,ret4 = ACTIONS.GIVE_TACKLESKETCH.fn_old(...)
    print("ACTIONS.GIVE_TACKLESKETCH.fn",ret1,ret2,ret3,ret4)
    return ret1,ret2,ret3,ret4
end