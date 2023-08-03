-------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                        没洞穴        洞穴（远程）       洞穴（本地）
-- TheNet:GetIsClient()                   false         false             true
-- TheNet:GetIsHosting()                  false         true              true
-- TheNet:GetIsMasterSimulation()          true         true              false
-- TheNet:GetIsServer()                    true         true              false
-- TheNet:GetIsServerAdmin()               true         true              true
-- TheNet:GetIsServerOwner()               true         true              true

--  TheNet:GetIsClient() == false and TheNet:GetIsMasterSimulation() == true   ---------- 用来判断单纯的没洞穴的存档。
-------------------------------------------------------------------------------------------------------------------------------------------------------------
TheWorld.Map:GetSize()   ---- 得到地图的地皮数，1块地皮为 4x4距离。 地图中心坐标为（0,0）  最大对角坐标为  正负TheWorld.Map:GetSize()*2
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 一些制造栏声音路径
ThePlayer.SoundEmitter:PlaySound("dontstarve/HUD/creditpage_flip")
ThePlayer.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
ThePlayer.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
ThePlayer.SoundEmitter:PlaySound("dontstarve/HUD/feed")
-------------------------------------------------------------------------------
player:PushEvent("player_despawn")  ------- 玩家自身的 inst.OnDespawn 执行的时候发出的event，可以用来处理玩家离开的相关代码。
TheSim:HasPlayerSkeletons()
-------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 怪物把玩家击飞（猪人活动的击飞倒地效果）
AddPrefabPostInit("leif", function(inst)
    local function OnHitOther(inst, other)
        other:PushEvent("knockback", {
            knocker = inst, -- 攻击者
            radius = 200, -- 击飞范围
            strengthmult = 1 -- 力量倍率
        })
    end
    if inst.components.combat ~= nil then
        inst.components.combat.onhitotherfn = OnHitOther
    end
end)

-----------------------------------------------------------------------------------------------------------------
-- --- 吸引怪物仇恨
local function pleaseattackme(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20,{ "_combat"},{"player","playerghost","INLIMBO","companion","pig"})

    for i, v in ipairs(ents) do
        if v and v:IsValid()
            and not (v.components.health ~= nil and
                    v.components.health:IsDead()) then
            --and v.components.combat:CanAttack(inst) then
			v.components.combat:SuggestTarget(inst)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------
--------------------------------------------
 --  -- 关掉BOSS战斗音效
doer.SoundEmitter:PlaySound("Character_Music_Panda/Character_Music_Panda/Character_Music_Panda_sfx", "Character_Music_Panda")
        -- doer.SoundEmitter:PlaySound("Character_Music_Panda/Character_Music_Panda/Character_Music_Panda_BG", "Character_Music_Panda")
doer.SoundEmitter:SetVolume("Character_Music_Panda",0.3)

doer.BGM_check_task = doer:DoPeriodicTask(1,function()
    TheWorld:PushEvent("enabledynamicmusic", false)

end)
doer:DoTaskInTime(240,function()
    if doer.BGM_check_task then
        doer.BGM_check_task:Cancel()
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 获取角色屏幕坐标相关（可以得到角色右边的坐标，无论旋转的屏幕是什么角度）
-- 系统的 followcamera.lua 里还有其它形式的封装
--  inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 貌似可以用这个实现跨世界传送数据（服务器）
-------- 跨洞穴RPC广播
AddShardModRPCHandler("Panda_Fisherman", "Through_The_Cave", function(shardId, ...)
	-- local arg = {...}
	-- GLOBAL.TheShard:GetShardId()
	-- TheWorld.GUID
	print("fake error : Shard RPC",shardId)
end)
-- SendModRPCToShard(SHARD_MOD_RPC["Panda_Fisherman"]["Through_The_Cave"], shardId ,...)	--- shardId 直接为nil就可以跨洞穴执行
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 特效
SpawnPrefab("spawn_fx_medium_static")  -- 玩家退出的时候刷的旋转门


--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SGwilson.lua 里，, name = "attack", 有各种武器的攻击动作 tag，name = "dojostleaction" 也有一些
-- inst:AddTag("jab") --使用捅击的动作进行攻击
-- equip:HasTag("whip")  -- 鞭子
-- equip:HasTag("pocketwatch") -- 链表
-- equip:HasTag("punch") -- 拳头？
-- equip:HasTag("nopunch") -- 不是拳头？
-- equip:HasTag("light")  ？？
-- inst:HasTag("beaver") -- 海狸
-- equip:HasTag("toolpunch") -- 拿工具用拳头？
-- equip:HasTag("book")     -- 拿书抽目标


--------------------------------------------------------------------------------------------------------------------------------------------------------------
ThePlayer.AnimState:SetBuild("woodie")

ThePlayer.sg:GoToState("applyupgrademodule")     -- 修理东西失败的动作，有音效，电起来
ThePlayer.sg:GoToState("hideandseek_counting")  -- 揉眼睛的动作
ThePlayer.sg:GoToState("research")              -- 跳起来双腿拍击的动作，有音效
ThePlayer.sg:GoToState("tackle_pre")            --  WOODIE 变身鹿时候的冲击 全部动作
ThePlayer.sg:GoToState("fertilize")             --  拿东西涂脸？有表情
ThePlayer.sg:GoToState("form_log")              --  连续动作，有音效，撕裂什么东西
ThePlayer.sg:GoToState("pour")                  -- 浇水淋地动作
ThePlayer.sg:GoToState("till_start")            -- 耙子犁地动作，有音效
ThePlayer.sg:GoToState("bundle")                --  打包包裹动作
ThePlayer.sg:GoToState("pinned_hit")            -- 被打中，有音效
ThePlayer.sg:GoToState("pinned_pre")            -- 被打中的样子，有奇怪音效
ThePlayer.sg:GoToState("throw_line")            -- 丢出武器的动作，武器贴图消失，最后身后拿出武器
ThePlayer.sg:GoToState("catch_equip")           -- 接回武器的动作
ThePlayer.sg:GoToState("blowdart_special")      -- 吹箭动作
ThePlayer.sg:GoToState("helmsplitter_pre")      -- 跳起来向下挥砍，有音效和武器光亮。【无法触发武器的 onattack 函数】--------------------------------------------------
ThePlayer.sg:GoToState("multithrust_pre")       -- 武器攻击动作，多重向前戳，有音效----------------------------------------------------
ThePlayer.sg:GoToState("combat_superjump_pst")
ThePlayer.sg:GoToState("combat_superjump")
ThePlayer.sg:GoToState("combat_superjump_start")    -- 准备起跳的动作
ThePlayer.sg:GoToState("combat_leap")
ThePlayer.sg:GoToState("combat_leap_start")     -- 准备拔刀向前挥砍的动作
ThePlayer.sg:GoToState("combat_lunge_start")    -- 旋转手中武器的动作，有音效
ThePlayer.sg:GoToState("quicktele")             -- 快速传送的动作
ThePlayer.sg:GoToState("portal_rez")            --  镜头拉近，全身发黑的动作
ThePlayer.sg:GoToState("spooked")               -- 惊恐表情动作
ThePlayer.sg:GoToState("mindcontrolled")        -- 脸上被黑影灼烧的动作
ThePlayer.sg:GoToState("knockbacklanded")       -- 跳起来向下踩的动作，有音效，上船着陆的原地动作-----------------------------------------------------------------
ThePlayer.sg:GoToState("knockback_pst")         -- 起身动作
ThePlayer.sg:GoToState("knockback")             -- 天上掉下来的 动作（包括起身）
ThePlayer.sg:GoToState("washed_ashore")         -- 被救上岸的动作，包括 落水惩罚处理事件
ThePlayer.sg:GoToState("sink")                  -- 站浮木上的落水动作 -- 有落水后的处理（惩罚）事件连着
ThePlayer.sg:GoToState("sink_fast")             --  快速落水
ThePlayer.sg:GoToState("mount_plank")           -- 左顾右盼的动作
ThePlayer.sg:GoToState("hit")                   -- 被打的动作
ThePlayer.sg:GoToState("knockout")              --  睡觉动作---无法释放，界面隐藏
ThePlayer.sg:GoToState("bedroll")               -- 铺上睡袋睡觉
ThePlayer.sg:GoToState("attack")                -- 普通的单手挥砍动作---------------------------------------------------------
ThePlayer.sg:GoToState("attack_prop")
ThePlayer.sg:GoToState("attack_prop_pre")       -- 双手抓武器挥打动作，武器贴图部分情况下消失.【无法触发武器的 onattack 函数】-------------------------- 
ThePlayer.sg:GoToState("catch_pre")             -- 回旋镖接住的前置动画
ThePlayer.sg:GoToState("throw")                 -- 手上东西丢出去的动画，武器贴图消失
ThePlayer.sg:GoToState("blowdart")              -- 吹箭动作，有音效，手上当前武器
ThePlayer.sg:GoToState("book_peruse")           -- 坐下来翻书 -- 需要贴图跟上，不然脸部贴图丢失
ThePlayer.sg:GoToState("book")                  -- 读书的动作
ThePlayer.sg:GoToState("summon_abigail")        --阿比盖尔的亲吻动作
ThePlayer.sg:GoToState("play_gnarwail_horn")    -- 吹号角的前置动作，没有声音
ThePlayer.sg:GoToState("play_horn") -- 吹号角
ThePlayer.sg:GoToState("enter_onemanband")  --  打击乐器跳舞动作，有音效
ThePlayer.sg:GoToState("play_onemanband")   -- 打击乐器的一部分动作
ThePlayer.sg:GoToState("dochannelaction")   -- 堵住耳朵甩手
ThePlayer.sg:GoToState("powerup_wurt") -- 变强壮动作，播放后有导致贴图丢失的可能
ThePlayer.sg:GoToState("funnyidle")     -- 站久时候的动作
ThePlayer.sg:GoToState("mine_start")    -- 向下锤的动作
ThePlayer.sg:GoToState("hammer_start")  -- 锤子音效动作
ThePlayer.sg:GoToState("gnaw")          -- 单手挥砍，有音效-----------------------------------------------------
ThePlayer.sg:GoToState("hide")          -- 灌木丛帽子的隐藏动作
ThePlayer.sg:GoToState("parry_pre")     -- 格挡前置动作
ThePlayer.sg:GoToState("parry_knockback")   -- 格挡抵挡动作，有音效
ThePlayer.sg:GoToState("dig_start")     -- 挖地动作，有音效
ThePlayer.sg:GoToState("terraform")     -- 也是挖地动作，有音效
ThePlayer.sg:GoToState("refuseeat")     -- 拒绝吃的时候嫌弃的动作
ThePlayer.sg:GoToState("mime")          -- 看起来像是wes 的舞蹈动作【哑剧】
ThePlayer.sg:GoToState("unsaddle")      -- 跳起来向下挥砍的动作---------------------------------------------------------------
ThePlayer.sg:GoToState("dostandingaction")  -- 向前抓握的动作
ThePlayer.sg:GoToState("doequippedaction")  -- 某个奇怪的动作
ThePlayer.sg:GoToState("dosilentshortaction")   -- 蹲下播种的动作
ThePlayer.sg:GoToState("dohungrybuild")     -- 制造物品的动作
ThePlayer.sg:GoToState("revivecorpse")      -- 很长的制造物品的动作
ThePlayer.sg:GoToState("dojostleaction")    -- 站立挥砍的动作


ThePlayer.sg:GoToState("yawn")  --  打哈欠

ThePlayer.sg:GoToState("electrocute")  -- 触电

ThePlayer.AnimState:PlayAnimation("emote_pre_toast")
ThePlayer.AnimState:PlayAnimation("emote_loop_toast")


-- [00:22:40]: inst PlayAnimation	ready_stance_pre	129006 - shadowprotector	
-- [00:22:40]: inst PlayAnimation	ready_stance_loop	129006 - shadowprotector	
-- [00:22:42]: inst PlayAnimation	lunge_pre	129006 - shadowprotector	
-- [00:22:43]: inst PlayAnimation	lunge_pst	129006 - shadowprotector	
-- [00:22:43]: inst PlayAnimation	appear	129006 - shadowprotector	