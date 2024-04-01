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
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/11_cave_and_light",                        ---- 在洞里会自动有视野 
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/12_beard_spell_item_setup",                ---- 技能物品安装 
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/13_key_listener",                          ---- 键盘监听事件
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/14_spell_a",                               ---- 技能A
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/15_spell_b",                               ---- 技能B
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/16_anything_eater",                        ---- 特殊的吃东西交互组件
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/17_damage_mult",                           ---- 伤害倍增器
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/18_spell_introduction_page",               ---- 法术介绍页
        "prefabs/19_fwd_in_pdt_characters/02_cyclone_key_modules/19_work_without_tools",                    ---- 不使用工具直接工作

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



    inst:ListenForEvent("cyclone_master_postinit",function(inst)
        
        inst.soundsname = "maxwell"           -- 角色声音


        inst.skeleton_prefab = "fwd_in_pdt_cyclone_skeleton"    --- 客制化骷髅


    end)

    if not TheWorld.ismastersim then
        return
    end



end