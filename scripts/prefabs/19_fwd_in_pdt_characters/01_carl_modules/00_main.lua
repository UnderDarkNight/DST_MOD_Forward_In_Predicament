--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    local modules = {
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/01_damage_multiplier",        ---- 伤害倍率
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/02_run_speed_multiplier",     ---- 速度倍率
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/03_combat_and_blood",         ---- 吸血和硬直
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/04_thirst_for_blood",         ---- 渴血
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/05_eater",                    ---- 吃东西
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/06_spell_cd_display_sys",     ---- 技能CD显示系统
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/07_key_listener",             ---- 键盘按键监听
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/08_spell_a",                  ---- 技能A
        "prefabs/19_fwd_in_pdt_characters/01_carl_modules/09_spell_b",                  ---- 技能B
        -- "prefabs/19_fwd_in_pdt_characters/01_carl_modules/10_health",                   ---- 自定义复活后生命值
    }
    for k, lua_addr in pairs(modules) do
        local temp_fn = require(lua_addr)
        if type(temp_fn) == "function" then
            temp_fn(inst)
        end
    end

    inst:AddTag("fwd_in_pdt_carl") --- 给自己上标记 tag 。通常用于武器、制作栏专属

    inst:AddTag("playermonster")   --- 会被中立怪物攻击
    inst:AddTag("monster")

end