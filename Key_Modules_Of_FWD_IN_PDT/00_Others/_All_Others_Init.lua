-- 这个文件是分类入口
-- 本lua 和 modmain.lua 平级
-- 注意文件路径

---- 无法归类的 注册


modimport("Key_Modules_Of_FWD_IN_PDT/00_Others/01_Special_hook_TheSim.lua")    --- 解决WG 平台 的骷髅问题

modimport("Key_Modules_Of_FWD_IN_PDT/00_Others/02_Sound_hook.lua")    --- 屏蔽掉某些声音

modimport("Key_Modules_Of_FWD_IN_PDT/00_Others/03_Death_Announce.lua")    --- 死亡通告相关API  hook
modimport("Key_Modules_Of_FWD_IN_PDT/00_Others/04_Resurrection_Announce.lua")    --- 复活通告相关API hook

-- modimport("Key_Modules_Of_FWD_IN_PDT/00_Others/05_OnEntityReplicated_Event.lua")    --- 修改replica ，让其可以 在加载后瞬间 pushevent

modimport("Key_Modules_Of_FWD_IN_PDT/00_Others/06_pick_sound_customization.lua")    --- 自定义拾取声音，角色独有拾取声音

