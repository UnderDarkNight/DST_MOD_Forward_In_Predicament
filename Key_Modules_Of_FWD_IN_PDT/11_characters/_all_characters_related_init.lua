-- 这个文件是分类入口
-- 本lua 和 modmain.lua 平级
-- 注意文件路径
if not TUNING["Forward_In_Predicament.Config"].ALLOW_CHARACTERS then
    return
end


modimport("Key_Modules_Of_FWD_IN_PDT/11_characters/01_carl.lua")    --- 卡尔 相关的数据注册
modimport("Key_Modules_Of_FWD_IN_PDT/11_characters/02_carl_recipes.lua")    --- 卡尔 专属制作物品
modimport("Key_Modules_Of_FWD_IN_PDT/11_characters/03_carl_spell_display_bar.lua")    --- 卡尔 专属技能栏








