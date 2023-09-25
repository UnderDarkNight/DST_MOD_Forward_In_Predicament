author = "可爱的小亨、GAGA、幕夜之下"
-- from stringutil.lua


----------------------------------------------------------------------------
--- 版本号管理（暂定）：最后一位为内部开发版本号，或者修复小bug的时候进行增量。
---                   倒数第二位为对外发布的内容量版本号，有新内容的时候进行增量。
---                   第二位为大版本号，进行主题更新、大DLC发布的时候进行增量。
---                   第一位暂时预留。 
----------------------------------------------------------------------------
local the_version = "0.00.00.0003"



local function Check_Mod_is_Internal_Version()
  if folder_name and (folder_name == "Forward In Predicament" or folder_name == "workshop-3031245026") then
      return true
  end
  return false
end

local function GetName()
  ----------------------------------------------------------------------------
  ---- 参数表： loc.lua 里面的localizations 表，code 为 这里用的index
  local temp_table = {
      "Forward In Predicament",                               ----- 默认情况下(英文)
      ["zh"] = "负重前行",                                 ----- 中文
  }

  local temp_table_internal = {
    "Forward In Predicament (BETA)",                               ----- 默认情况下(英文)
    ["zh"] = "负重前行(BETA)",                                 ----- 中文
  }

  if Check_Mod_is_Internal_Version() then
    return ChooseTranslationTable(temp_table_internal)
  end
  return ChooseTranslationTable(temp_table)
end

local function GetDesc()
    local temp_table = {
      [[
        Large amount of content
      ]],
      ["zh"] = [[
        本MOD添加大量内容。
        这里描述不完。
      ]]
    }
    local ret = the_version .. "  \n  "..ChooseTranslationTable(temp_table)
    return ret
end

name = GetName()
description = GetDesc()

version = the_version ------ MOD版本，上传的时候必须和已经在工坊的版本不一样

api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
dont_starve_compatible = true
dst_compatible = true
all_clients_require_mod = true

priority = -10000000000  -- MOD加载优先级 影响某些功能的兼容性，比如官方Com 的 Hook


local function IsChinese() 
    return locale == "zh" or locate == "zht" or locate == "zhr" or false
end
configuration_options =
{
    {
        name = "LANGUAGE",
        label = "Language/语言",
        hover = "Set Language/设置语言",
        options =
        {
          {description = "Auto/自动", data = "auto"},
          {description = "English", data = "en"},
          {description = "中文", data = "ch"},
        },
        default = "auto",
    },
    -- {
    --     name = "DEBUGGING_MOD",
    --     label = IsChinese() and "内测版本模式" or "debugging version",
    --     hover = IsChinese() and "启动测试模式，控制台更多数据" or " for log display",
    --     options =
    --     {
    --       {description = IsChinese() and "关" or "OFF", data = false},
    --       {description = IsChinese() and "开" or "ON", data = true},
    --     },
    --     default = false,
    -- },

    {
      name = "",
      label = "隔断测试2",
      hover = "",
      options = {{description = "", data = 0}},
      default = 0,
    },

    {
      name = "UI_FX",
      label = IsChinese() and "UI动画特效" or "UI FX Anim",
      hover = IsChinese() and "物品栏、背包栏上的动画特效" or "Animated effects for UI",
      options =
      {
        {description = IsChinese() and "开" or "ON", data = true},
        {description = IsChinese() and "关" or "OFF", data = false},
      },
      default = true,
    },

    {
      name = "",
      label = "     ",
      hover = "",
      options = {{description = "", data = 0}},
      default = 0,
    },
    {
      name = "Element_Core_Probability",
      label = IsChinese() and "元素核心概率" or "Element Core Probability",
      hover = IsChinese() and "炽热光核、极冰冷核 的出现概率" or "Flame/Ice Core Stone Probability",
      options =
      {
        {description = "10%", data = 0.1},
        {description = "15%", data = 0.15},
        {description = "20%", data = 0.2},
        {description = "25%", data = 0.25},
        {description = "30%", data = 0.3},
      },
      default = 0.1,
    },

  
}
