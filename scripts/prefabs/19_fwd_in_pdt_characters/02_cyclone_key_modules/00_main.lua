--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)



    local modules = {
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/01_hud_change",                            ---- HUD 外观修改
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/02_body_fx",                               ---- 身体特效
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/03_anim_hook",                             ---- animstate hook
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/04_run_sound",                             ---- 跑路声音
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/05_rideable_blocker",                      ---- 屏蔽骑行
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/06_hunger_and_temperature",                ---- 饥饿 和 温度
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/07_fly",                                   ---- 可以飞行
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/08_red_tornado",                           ---- 红色旋风
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/09_playercontroller_hook_for_map_jump",    ---- HOOK player controller 
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/10_map_jumper",                            ---- 添加跳图组件 

    }
    for k, lua_addr in pairs(modules) do
        local temp_fn = require(lua_addr)
        if type(temp_fn) == "function" then
            temp_fn(inst)
        end
    end


    inst:AddTag("fwd_in_pdt_cyclone")

    -- inst.customidleanim = "moonlightcoda_funny_idle"  -- 闲置站立动画
    -- inst.talksoundoverride = "moonlightcoda_sound/moonlightcoda_sound/talk"
    -- inst.customidleanim = "idle_wendy"  -- 闲置站立动画

    inst.soundsname = "maxwell"           -- 角色声音


    -- inst.AnimState:OverrideSymbol("wendy_idle_flower","moonlightcoda_idle_flower","wendy_idle_flower")
    -- inst.AnimState:OverrideSymbol("wood_splinter","moonlightcoda_hand_glass","wood_splinter")

    if not TheWorld.ismastersim then
        return
    end



end