

local function Language_check()
    -- return "ch"
    local LANGUAGE = "en"
    if type(TUNING["Forward_In_Predicament.Language"]) == "function" then
        LANGUAGE = TUNING["Forward_In_Predicament.Language"]()
    elseif type(TUNING["Forward_In_Predicament.Language"]) == "string" then
        LANGUAGE = TUNING["Forward_In_Predicament.Language"]
    end
    return LANGUAGE
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色立绘大图
    GLOBAL.PREFAB_SKINS["fwd_in_pdt_cyclone"] = {
        "fwd_in_pdt_cyclone_none",
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色选择时候都文本
    if Language_check() == "ch" then
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["fwd_in_pdt_cyclone"] = "深渊旋涡"
        STRINGS.CHARACTER_NAMES["fwd_in_pdt_cyclone"] = "深渊旋涡"
        STRINGS.CHARACTER_DESCRIPTIONS["fwd_in_pdt_cyclone"] = "深渊可以给予我力量"
        STRINGS.CHARACTER_QUOTES["fwd_in_pdt_cyclone"] = "\"我来自深渊\""

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("fwd_in_pdt_cyclone")] = require "speech_fwd_in_pdt_cyclone"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("fwd_in_pdt_cyclone")] = "深渊旋涡"
        STRINGS.SKIN_NAMES["fwd_in_pdt_cyclone_none"] = "深渊旋涡"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["fwd_in_pdt_cyclone"] = "在洞里特别容易"
    else
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["fwd_in_pdt_cyclone"] = "Cyclone of the Abyss"
        STRINGS.CHARACTER_NAMES["fwd_in_pdt_cyclone"] = "Cyclone of the Abyss"
        STRINGS.CHARACTER_DESCRIPTIONS["fwd_in_pdt_cyclone"] = "The abyss can give me strength."
        STRINGS.CHARACTER_QUOTES["fwd_in_pdt_cyclone"] = "\"I come from the abyss.\""

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("fwd_in_pdt_cyclone")] = require "speech_fwd_in_pdt_cyclone"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("fwd_in_pdt_cyclone")] = "Cyclone"
        STRINGS.SKIN_NAMES["fwd_in_pdt_cyclone_none"] = "Cyclone"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["fwd_in_pdt_cyclone"] = "easy in cave"

    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------增加人物到mod人物列表的里面 性别为女性（MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
    AddModCharacter("fwd_in_pdt_cyclone", "MALE")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面人物三维显示
    TUNING[string.upper("fwd_in_pdt_cyclone").."_HEALTH"] = 100
    TUNING[string.upper("fwd_in_pdt_cyclone").."_HUNGER"] = 2000
    TUNING[string.upper("fwd_in_pdt_cyclone").."_SANITY"] = 100
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面初始物品显示，物品相关的prefab
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper("fwd_in_pdt_cyclone")] = {"log"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
