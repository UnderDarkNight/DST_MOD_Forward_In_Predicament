-----------------------------------------------
---- 本lua 和 modmain.lua 平级
---- 所有内容相当于挂载到 modmain.lua 上
-----------------------------------------------
-- AddComponentPostInit("teacher", function(self)   ------ hook 蓝图组件，查看出入参数。
--     if not TheWorld.ismastersim then
--         return
--     end
--     self.SetRecipe_old = self.SetRecipe
--     self.SetRecipe = function(self,recipe)
--         print("SetRecipe",type(recipe),recipe)
--         self:SetRecipe_old(recipe)
--     end
--     self.Teach_old = self.Teach
--     self.Teach = function(self,target)
--         print("Teach",target)
--         self:Teach_old(target)
--     end
-- end)
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
GLOBAL.STRINGS.NAMES[string.upper('los_golden_whip')] = '测试物品' -- -- 制造栏里展示的名字
STRINGS.RECIPE_DESC[string.upper('los_golden_whip')] = '测试物品说明' -- --  制造栏里展示的说明
AddRecipeToFilter('los_golden_whip', 'STRUCTURES') --- --- 在类别里注册物品名字(至少一个类别)
AddRecipe2(
    'los_golden_whip', --  --  目标 inst.prefab  实体名字
    {Ingredient('log', 1), Ingredient('goldnugget', 2)}, -- 需要资源
    TECH.LOST, --  NONE / SCIENCE_ONE  / SCIENCE_TWO
    {
        no_deconstruction = true, ----- 【未测试】不能拆解，推测是和拆解魔杖有关。
        nounlock = false, ----- 【重要】见下面说明
        -- numtogive = 1,                               ----- 结果给多少个。
        -- placer = "XXX",                              ----- 建筑类用的，placer 名字。
        -- min_spacing = 1.5，                          ----- 【未测试】建造时候需要空地？？？
        -- testfn = function(pt) return false end ,     ----- 测试函数，参数为坐标。
        -- builder_tag = "player",                      ----- 拥有特殊tag 的玩家 才能看见这个物品制作。
        atlas = GetInventoryItemAtlas('horn.tex'),
        image = 'horn.tex'
    },
    {'STRUCTURES'} -- -- 在哪些制造分栏出现，可以多个 -- "CHARACTER"
)
RemoveRecipeFromFilter('los_golden_whip', 'MODS') -- -- 在【模组物品】标签里移除这个。


-- 关于蓝图：
-- 如果是 TECH.SCIENCE_ONE  或者 是魔法科技， nounlock 会影响。
-- nounlock 配置  true : 靠近科技的时候才会出现，不然隐藏，即便是解锁过也隐藏（不能是TECH.NONE)。false:不靠近科技也能看见，但是不能制作（除非解锁过）
-- 如果不依赖任何科技，解锁就能用。则使用  TECH.LOST  和 nounlock = false
