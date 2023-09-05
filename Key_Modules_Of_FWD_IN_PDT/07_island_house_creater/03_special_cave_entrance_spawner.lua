--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本文件立志于创建独特的洞穴出入口。必须挂载在TheWorld 上实现。
--- 地图生成后，再将这个出入口放去指定的位置
--- 【笔记】好像没什么用了，暂留着做笔记，洞穴创建必须在世界刚创建完成的时候执行。
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AddPrefabPostInit(
--     "world",
--     function(inst)
--         if not inst.ismastersim then
--             return
--         end

--         local tree = TheSim:FindFirstEntityWithTag("fwd_in_pdt__rooms_quirky_red_tree_special")
--         if tree == nil then
--             tree = SpawnPrefab("fwd_in_pdt__rooms_quirky_red_tree_special")
--             tree.Transform:SetPosition(0,50,0)
--         end


-- end)

