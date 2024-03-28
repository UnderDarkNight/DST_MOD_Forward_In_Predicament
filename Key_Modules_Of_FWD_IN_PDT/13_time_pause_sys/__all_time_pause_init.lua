----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    感谢 老王 的代码和相关思路方向。

        https://dont-starve-mod.github.io/lw/zh/homura_index/
        
        https://steamcommunity.com/sharedfiles/filedetails/?id=1837053004




    饥荒原生的全局暂停接口是 TheSim:SetTimeScale(0)，不过这个玩意儿会让一切物体无差别的冻结，不能用。

    晓美焰的暂停参考的是 EntityScript:RemoveFromScene() 函数，并增加了一些定制的内容，如全屏变灰、阻止 scheduler、component、stategraph 的更新。

    EntityScript:RemoveFromScene()
    EntityScript:ReturnToScene()



]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modimport("Key_Modules_Of_FWD_IN_PDT/13_time_pause_sys/01_scheduler_hook.lua")  
--- DoTaskInTime hook 进去

modimport("Key_Modules_Of_FWD_IN_PDT/13_time_pause_sys/02_all_com_update_hook.lua")  
--- 所有com 的 OnUpdate 函数停掉

