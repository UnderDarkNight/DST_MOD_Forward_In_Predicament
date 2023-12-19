--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    键盘事件监听


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local keys_by_index  = {
        KEY_A = 97,
        KEY_B = 98,
        KEY_C = 99,
        KEY_D = 100,
        KEY_E = 101,
        KEY_F = 102,
        KEY_G = 103,
        KEY_H = 104,
        KEY_I = 105,
        KEY_J = 106,
        KEY_K = 107,
        KEY_L = 108,
        KEY_M = 109,
        KEY_N = 110,
        KEY_O = 111,
        KEY_P = 112,
        KEY_Q = 113,
        KEY_R = 114,
        KEY_S = 115,
        KEY_T = 116,
        KEY_U = 117,
        KEY_V = 118,
        KEY_W = 119,
        KEY_X = 120,
        KEY_Y = 121,
        KEY_Z = 122,
        KEY_F1 = 282,
        KEY_F2 = 283,
        KEY_F3 = 284,
        KEY_F4 = 285,
        KEY_F5 = 286,
        KEY_F6 = 287,
        KEY_F7 = 288,
        KEY_F8 = 289,
        KEY_F9 = 290,
        KEY_F10 = 291,
        KEY_F11 = 292,
        KEY_F12 = 293,
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 检查是否正在输入文字
    local function check_is_text_inputting()    
        -- 代码来自  TheFrontEnd:OnTextInput
        local screen = TheFrontEnd:GetActiveScreen()
        if screen ~= nil then
            if TheFrontEnd.forceProcessText and TheFrontEnd.textProcessorWidget ~= nil then
                return true
            else
                return false
            end
        end
        return false
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 检查 CD 和上传任务
    local function key_event_fn(inst,key)
        if not (key == keys_by_index[TUNING["Forward_In_Predicament.Config"].SPELL_KEY_A] or key == keys_by_index[TUNING["Forward_In_Predicament.Config"].SPELL_KEY_B] )then
           return
        end
        ------------------------------------------------------------------------------------------------
        -- TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, .4)
        ------------------------------------------------------------------------------------------------
            if key == keys_by_index[TUNING["Forward_In_Predicament.Config"].SPELL_KEY_A] then
                -- print("技能A")
                local spell_a_time = ThePlayer.replica.fwd_in_pdt_func:Spell_Get("spell_a_time") or 0
                if spell_a_time ~= 0 then -- 技能没冷却好
                    TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, .4)
                else
                    ThePlayer.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_spell.a.start")
                end
            end
        ------------------------------------------------------------------------------------------------
            if key == keys_by_index[TUNING["Forward_In_Predicament.Config"].SPELL_KEY_B] then
                -- print("技能B")
                local spell_b_time = ThePlayer.replica.fwd_in_pdt_func:Spell_Get("spell_b_time") or 0
                if spell_b_time ~= 0 then -- 技能没冷却好
                    TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, .4)
                else
                    ThePlayer.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_spell.b.start")
                end
            end
        ------------------------------------------------------------------------------------------------


    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if TheFocalPoint and ThePlayer and ThePlayer == inst and ThePlayer.prefab == "fwd_in_pdt_carl" and ThePlayer.HUD and TheInput then
            ------------ 添加键盘监控
                local __key_handler = TheInput:AddKeyHandler(function(key,down)  ------ 30FPS 轮询，不要过于复杂
                    if not check_is_text_inputting() and down == false then
                        -- print("key_up",key)
                        key_event_fn(ThePlayer,key)
                    end
                end)
            ---------- 角色删除的时候顺便移除监听。避免切角色的时候出问题
                inst:ListenForEvent("onremove",function()
                    -- print("info : key handler remove ++++++++++++++++++++++++")
                    __key_handler:Remove()
                end)

            -- print("info fwd_in_pdt_carl key handler added")
            ---------- 施放技能失败，数据来自服务端
                inst:ListenForEvent("fwd_in_pdt_spell.fail",function()
                    TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, .4)
                end)
            
        end
    end)
end