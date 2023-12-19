

local function Language_check()
    return "ch"
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色立绘大图
    GLOBAL.PREFAB_SKINS["fwd_in_pdt_carl"] = {
        "fwd_in_pdt_carl_none",
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色选择时候都文本
    if Language_check() == "ch" then
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["fwd_in_pdt_carl"] = "嗜血的卡尔"
        STRINGS.CHARACTER_NAMES["fwd_in_pdt_carl"] = "卡尔"
        STRINGS.CHARACTER_DESCRIPTIONS["fwd_in_pdt_carl"] = "*给我血！\n*给我血！\n*给我血！"
        STRINGS.CHARACTER_QUOTES["fwd_in_pdt_carl"] = "\"我渴望鲜血和战斗\""

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("fwd_in_pdt_carl")] = require "speech_fwd_in_pdt_carl"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("fwd_in_pdt_carl")] = "卡尔"
        STRINGS.SKIN_NAMES["fwd_in_pdt_carl_none"] = "卡尔"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["fwd_in_pdt_carl"] = "特别容易"
    else
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["fwd_in_pdt_carl"] = "Bloodthirsty Carl"
        STRINGS.CHARACTER_NAMES["fwd_in_pdt_carl"] = "Carl"
        STRINGS.CHARACTER_DESCRIPTIONS["fwd_in_pdt_carl"] = "*Give me blood !\n*Give me blood !\n*Give me blood !"
        STRINGS.CHARACTER_QUOTES["fwd_in_pdt_carl"] = "\"I thirst for battle and blood .\""

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("fwd_in_pdt_carl")] = require "speech_fwd_in_pdt_carl"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("fwd_in_pdt_carl")] = "Carl"
        STRINGS.SKIN_NAMES["fwd_in_pdt_carl_none"] = "Carl"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["fwd_in_pdt_carl"] = "easy"

    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------增加人物到mod人物列表的里面 性别为女性（MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
    AddModCharacter("fwd_in_pdt_carl", "MALE")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面人物三维显示
    TUNING[string.upper("fwd_in_pdt_carl").."_HEALTH"] = 2000
    TUNING[string.upper("fwd_in_pdt_carl").."_HUNGER"] = 500
    TUNING[string.upper("fwd_in_pdt_carl").."_SANITY"] = 100
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面初始物品显示，物品相关的prefab
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper("fwd_in_pdt_carl")] = {"fwd_in_pdt_equipment_vampire_sword"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
