--------------------------------------------------------------------------------------------------------------------
--- 这个文件存在于mod的根目录是为了方便VSCode 自动补全的时候快速捕捉到
--- 以下API是MOD开发常用的API和一些反复被调用的参数
--------------------------------------------------------------------------------------------------------------------

inst = {
    ["entity"] = {
        ["AddTransform"] = function(...)end,
        ["AddAnimState"] = function(...)end,
        ["AddNetwork"] = function(...)end,
        ["AddSoundEmitter"] = function(...)end,
        ["AddLight"] = function(...)end,
        ["SetPristine"] = function(...)end,
        ["SetParent"] = function(self,target)end
    },
    ["AnimState"] = {
        ["SetBank"] = function(...)end,
        ["SetBuild"] = function(...)end,
        ["PlayAnimation"] = function(...)end,
        ["PushAnimation"] = function(...)end,
        ["SetScale"] =  function(self,x,y,z)end,
        ["Pause"] = function() end,
        ["Resume"] = function() end,
        ["Show"] = function() end,
        ["ShowSymbol"] = function(self,name) end,
        ["Hide"] = function() end,
        ["HideSymbol"] = function(self,name) end,
        ["OverrideSymbol"] = function(self,layer,build,layer2) end,
        ["OverrideItemSkinSymbol"] = function(self,layer,build,layer2,GUID,fname) end,
        ["ClearOverrideSymbol"] = function(self,name)end,
        ["GetBuild"] = function() end,
        ["GetSkinBuild"] = function() end,
        ["SetFinalOffset"] = function(self,num) end,
        ["SetMultColour"] = function(self,x,y,z,a) end,
        ["SetDeltaTimeMultiplier"] = function(self,num) end,
        ["SetTime"] = function(self,num)    end,
        ["SetBloomEffectHandle"] = function(self,ksh)      end,
        ["ClearBloomEffectHandle"] = function(self)      end,
        ["SetSortOrder"] = function(self,num)      end,
        ["SetOrientation"] = function(self,num)      end,   --- ANIM_ORIENTATION.OnGround
        ["SetLayer"] = function(self,num)      end,         --- LAYER_WORLD_BACKGROUND
        ["IsCurrentAnimation"] = function(self,name) return true end

    },
    ["Physics"] = {
        ["Stop"] = function(self) end,
        ["SetActive"] = function(self,flag) end,
        ["Teleport"] = function(self,x,y,z) end,
    },

    ["Transform"] = {
        ["SetScale"] = function(self,x,y,z) end,
        ["SetPosition"] = function(self,x,y,z) end,
        ["GetWorldPosition"] = function() return 0,0,0 end,
        ["SetNoFaced"] = function() end,
        ["SetTwoFaced"] = function() end,
        ["SetFourFaced"] = function() end,
        ["SetSixFaced"] = function() end,
        ["SetEightFaced"] = function() end,
        ["GetRotation"] = function() end,
        ["SetRotation"] = function(...) end,
    },
    ["SoundEmitter"] = {
        ["PlaySound"] = function(self, event_addr, name, volume, ...)end,
        ["KillSound"] = function(self,name)end,
        ["PlaySoundWithParams"] = function(...)end,
        ["GetEntity"] = function(...) return inst end
    },
    ["components"] = {
        ["health"] = {
            maxhealth = 100,
            currenthealth = 100,
            SetPercent = function(self,num)end,
            DoDelta = function(self,num)end,
            OnUpdate = function(self,num)end,
            IsDead = function(self)end,
        },
        ["sanity"] = {
            max = 100,
            current = 100,
            DoDelta = function(self,num)end,
            SetPercent = function(self,num)end,
            OnUpdate = function(self,num)end,            
        },
        ["hunger"] = {
            max = 100,
            current = 100,
            DoDelta = function(self,num)end,
            SetPercent = function(self,num)end,
            OnUpdate = function(self,num)end,

        },
        ["combat"] = {
            ["GetAttacked"] = function(...)end,
            ["onhitotherfn"] = function(attacker, self_inst, damage, stimuli, weapon, damageresolved)end,
            target = inst,
            ["SetTarget"] = function(self,target) end,
            ["SuggestTarget"] = function(self,target) end,
        },
        ["inspectable"] = {
            ["SetDescription"] = function(self,str)end,
        },
        ["inventory"] = {
            ["GiveItem"] = {},
        },
        ["talker"] = {
            ["Say"] = function(...) end,
            font = TALKINGFONT,
            colour = Vector3(165/255, 180/255, 200/255),
            offset = Vector3(0, -650, 0),
        },
        ["debuffable"] = {
            ["HasDebuff"] = function(...)end,
            ["GetDebuff"] = function(self,name) return inst end,
            ["AddDebuff"] = function(self,name, prefab, data)end,
            ["RemoveDebuff"] = function(self,name)end,
        },
        ["inventoryitem"] = {
            owner = inst,
            ["GetGrandOwner"] = function() return inst end,
            ["ChangeImageName"] = function(self,name) end,
        },
        ["tradable"] = {},
        ["lootdropper"] = {
            ["SetLoot"] = function(self,_table) end,
            ["DropLoot"] = function(self) end,
        },
        ["trader"] = {},
        ["stackable"] = {
            stacksize = 1,
            maxsize = 10,
        },
        ["equippable"] = {},
        ["freezable"] = {
            ["Freeze"] = function(self,time) end,
        },
        ["container"] = {
            ["GiveItem"] = function(self,name) end,
            ["DropEverything"] = function()end,
        },
        ["temperature"] = {
            current = 0,
        },
        ["named"] = {
            name = "XXXX",
            possiblenames = {},
            ["PickNewName"] = function()end,
            ["SetName"] = function(...)end,
        },
        ["rechargeable"] = {
            ["SetMaxCharge"] = function(self,max_cool_down_time)end,
            ["IsCharged"] = function()end,
            ["Discharge"] = function(self,time)end,
        },
        ["finiteuses"] = {
            ["Use"] = function(self,num)end,
            total = 100,
            current = 100
        },

        ["workable"] = {},
        ["skinner"] = {
            ["CopySkinsFromPlayer"] = function(self,target) end,
        },
        ["perishable"] = {},
        ["playercontroller"] = {
            ["Enable"] = function(self,true_or_false)
                
            end,
        },        
        ["sanityaura"] = {},        
        ["projectile"] = {
            ["Throw"] = function(self,owner,target,attacker)end,
            ["SetSpeed"] = function(self,num) end,
            ["SetRange"] = function(self,num) end,
            ["SetHitDist"] = function(self,num) end,
            ["SetOnHitFn"] = function(self,fn) end,
            ["SetOnPreHitFn"] = function(self,fn) end,
            ["SetOnThrownFn"] = function(self,fn) end,
            ["SetOnCaughtFn"] = function(self,fn) end,
            ["SetOnMissFn"] = function(self,fn) end,
            owner = inst,
        },        
        ["edible"] = {},        
        ["tool"] = {},        
        ["cursable"] = {},        
        ["cookable"] = {},        
        ["eater"] = {},        
        ["fuel"] = {},        
        ["sleeper"] = {},
        ["spell"] = {},        
        ["locomotor"] = {},
        ["knownlocations"] = {
            ["RememberLocation"] = function(...) end,
        },
        ["timer"] = {
            ["StartTimer"] = function(self,name, time, paused, initialtime_override) end,
            ["StopTimer"] = function(self,name) end,
            ["PauseTimer"] = function(self,name) end,
            ["ResumeTimer"] = function(self,name) end,
            ["IsPaused"] = function(self,name) end,
            ["GetTimeLeft"] = function(self,name) end,
            ["SetTimeLeft"] = function(self,name,time) end,
        },
    },
    ["AddComponent"] = function(...)end,
    ["RemoveComponent"] = function(...)end,
    ["IsValid"] = {},
    ["DoTaskInTime"] = function(self,dt,...)
        return { Cancel = function()end }
    end,
    ["DoPeriodicTask"] = function(self,dt,...)
        return { Cancel = function()end }
    end,
    ["ListenForEvent"] = function(self,event_name)end,
    ["PushEvent"] = function(self,event_name)end,
    ["RemoveEventCallback"] = function(self,event_name,fn)end,

    ["RemoveAllEventCallbacks"] = function(...)end,

    ["WatchWorldState"] = function(self,state_name,fn)end,
    ["StopWatchingWorldState"] = function(self,state_name,fn)end,
    ["StopAllWatchingWorldStates"] = function()end,

    ["AddTag"] = function(self,name)end,
    ["HasTags"] = function(self,tags_table)end,
    ["HasTag"] = function(self,tag)end,
    ["HasOneOfTags"] = function(self,tags_table)end,
    ["AddDebuff"] = function(self,debuff_name,debuff_prefab)end,
    ["HasDebuff"] = function(self,debuff_name)end,
    ["Remove"] = function() end,
    ["GetDistanceSqToInst"] = function(self,inst)  end,
    ["IsNear"] = function(self,inst,dist)  end,
    ["GetNearestPlayer"] = function(self,isalive) return inst end,
    ["IsNearPlayer"] = function(self,range, isalive) return true end,
    ["GetDisplayName"] = function()end,
    ["GetBasicDisplayName"] = function()end,
    ["GetDistanceSqToClosestPlayer"] = function(self,isalive) return inst end,
    
    ["IsAsleep"] = function()end,

    ["GetAngleToPoint"] = function(self,...)    end,
    ["IsOnOcean"] = function(self,allow_boats)   end,
    ["SetBrain"] = {},
    ["RestartBrain"] = {},
    ["StopBrain"] = {},
    ["SetStateGraph"] = {},
    ["ClearStateGraph"] = {},
    ["FacePoint"] = function(self,x,y,z)end,
    ["ForceFacePoint"] = function(self,x,y,z)end,

    ["FaceAwayFromPoint"] = function(self,pt,force_flag)end,
    ["sg"] = {
        ["GoToState"] = function(self,state)end,
        ["AddStateTag"] = function(self,tag_name) end,
        ["RemoveStateTag"] = function(self,tag_name) end,
        ["HasStateTag"] = function(self,tag_name) end,
    },
    ["SpawnChild"] = function(self,name)        return inst    end,
    ["OnBuiltFn"] = function(self,doer)end,
    ["RemoveChild"] = function(self,inst) end,
    ["AddChild"] = function(self,child_inst)end,
    ["GetSaveRecord"] = function(self) return "XXX" end,
    parent = inst,
    children = {inst,inst},
    OnEntityReplicated = {},
}
inst.replica = inst.components
inst.prefab = "6666"

ThePlayer = inst
AllPlayers = {inst,inst,inst}
owner = inst

TheSim = {
    ["FindFirstEntityWithTag"] = function(self,tag) return inst end,
    ["FindEntities"] = function(self,x, y, z, range, musthavetags, canthavetags, musthaveoneoftags)end,
    ["CountEntities"] = function(self,x, y, z, CONFFETI_PARTY_DIST, COUNT_PARTYGOERS_TAGS)end,
    ["LoadPrefabs"] = function(self,_prefabs_name_table)    end,
}
------------------------------------------------------------------
TheWorld = inst
TheWorld.Map = {
    ["GetTileAtPoint"] = function(self,x,y,z) return 1 end,
    ["IsOceanAtPoint"] = function(self,x,y,z) 
        -- 海洋地皮： 201 ~ 247    10498 ~ 14594        
        -- 函数在 tilegroups.lua 里
    end,
    ["IsAboveGroundAtPoint"] = function(self,x,y,z)end,   
    ["GetTileCenterPoint"] = function(self,x,y,z)
        return 0,0,0
    end,

    -- IsValidTileAtPoint
    -- IsOceanTileAtPoint
    -- IsAboveGroundAtPoint
    -- GetEntitiesOnTileAtPoint
    ["GetTileXYAtPoint"] = function(self,x,y,z)
        return 0,0
    end
}
TheWorld.ismastersim = false
TheWorld.state = {
    ["isday"] = true,
    ["isdusk"] = true,
    ["isnight"] = true,
    ["iscaveday"] = true,

    ["season"] = "summer", -- "winter"
    ["isautumn"] = true,
    ["iswinter"] = true,
    ["isspring"] = true,
    ["issummer"] = true,

    ["israining"] = true,
    ["issnowing"] = true,
    ["issnowcovered"] = true,
    ["snowlevel"] = 1,

    ["timeinphase"] = 1,
    ["temperature"] = 1,

    ["cycles"] = true,
    ["wetness"] = true,
    ["iswet"] = true,
    ["phase"] = true,
    ["nightmarephase"] = true,
    ["remainingdaysinseason"] = 5,

    ["isnewmoon"] = true,
    ["isfullmoon"] = true,
    ["iswaxingmoon"] = true,
    ["moonphase"] = "new", -- "full"
    ["iscavefullmoon"] = true,

    ["isalterawake"] = true,
    ["pop"] = true,
} 
TUNING = {}
-------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                        洞穴端（本地进程）        客户端（带洞穴）                    客户端（不带洞穴）
-- TheNet:GetIsClient()                         false                   true                            false
-- TheNet:GetIsHosting()                        true                    true                            false
-- TheNet:GetIsMasterSimulation()               false                   false                           true
-- TheNet:GetIsServer()                         false                   false                           true
-- TheNet:GetIsServerAdmin()                    false                   true                            true
-- TheNet:GetIsServerOwner()                    false                   true                            true
-- TheNet:IsDedicated()                         true                    false                           false

--  TheNet:GetIsClient() == false and TheNet:GetIsMasterSimulation() == true   ---------- 用来判断单纯的没洞穴的存档。
-------------------------------------------------------------------------------------------------------------------------------------------------------------
LookupPlayerInstByUserID = function(userid) return inst end
TheNet = {
    ["Announce"] = function(self,str)end,
    ["SystemMessage"] = function(self,str)end,
    ["GetUserID"] = function() end,
    ["GetIsClient"] = function(...) end,
    ["GetIsHosting"] = function(...) end,
    ["GetIsServer"] = function(...) end,
    ["GetIsServerAdmin"] = function(...) end,
    ["GetIsServerOwner"] = function(...) end,
    ["GetIsMasterSimulation"] = function(...) end,
    ["IsDedicated"] = function(...) end,    --  TheNet:IsDedicated()  true :服务端（或洞穴服务器）  false ：客户端
    ["GetClientTableForUser"] = function(self,userid) return { admin = true } end    ---- 检查玩家是否是服务器管理员
}
-------------------------------------------------------------------
GLOBAL = {
    ["UserToPlayer"] = function(userid)    end,
}

SpawnPrefab = function(name)
    return inst
end
SpawnSaveRecord = function(name)
    return inst
end
CreateEntity = function(...)
    return inst
end
Vector3 = function(...) return{x=0,y=0,z=0} end

AddPrefabPostInit = function(item_name,fn) fn(inst) end
AddPlayerPostInit = function(fn) fn(inst) end
AddComponentPostInit = function(component_name, fn) 
    fn(inst.components[component_name]) 
end
FRAMES = 1/30
dofile = function(...) end
resolvefilepath = function(...) end
---------------------------------------------------------------------
-- netVars
net_bool = function(inst_GUID, namespace,event_name) return{
    ["set"] = function(self,flag)  end,
    ["value"] = function()  end,
} end
net_string = function(inst_GUID, namespace,event_name) return{
    ["set"] = function(self,str)  end,

    ["value"] = function()  end,
} end

net_float = function(inst_GUID,namespace,event_name) return{
    ["set"] = function(self,num)  end,
    ["value"] = function()  end,
} end
net_entity = net_bool

net_tinybyte = net_float
net_smallbyte = net_float

net_event = function(inst_GUID, namespace_or_event_name,event_name_or_nil) return{
    ["push"] = function()  end,
} end

json = {
    encode = function(_table)end,
    decode = function(str) return{} end,
}

PrefabExists = function(str) return true end

-----------------------------------------
--- RPC : Server 2 Client
AddClientModRPCHandler = function(RPC_namespace,event_name,fn) end
--AddClientModRPCHandler(namespace, event_name, function(data_json) end)
SendModRPCToClient = function(CLIENT_MOD_RPC______namespace_event_name,player_userid,data_json_or_str,...)    
end
-- SendModRPCToClient(CLIENT_MOD_RPC["Demigod_Panda"]["the_SoundEmitter_cmd"],player.userid,json.encode(_table)) -- -- -- 在服务器端使用，下发数据给userid 的 客户端
-----------------------------------------
--- RPC : Client 2 Server
-- SendModRPCToServer(MOD_RPC["Demigod_Panda"]["Achievement"], json.encode(RPC_CMD_table))
SendModRPCToServer = function(MOD_RPC_____namspace_event_name, data_json_or_str,...)end

AddModRPCHandler = function(name_space, event_name,fn,player_inst,data_json_or_str,...) fn(player_inst,data_json_or_str,...) end
-- AddModRPCHandler("Demigod_Panda", "The_Fate", function(player,data_json,...)
--     player:PushEvent("panda_TheFate_Clicked")     
-- end)

-----------------------------------------
-- 跨洞穴RPC
-- 貌似可以用这个实现跨世界传送数据（服务器）
-------- 跨洞穴RPC广播
AddShardModRPCHandler("Demigod_Panda", "Through_The_Cave", function(shardId, ...)
	-- local arg = {...}
	-- GLOBAL.TheShard:GetShardId()
	-- TheWorld.GUID
	print("fake error : Shard RPC",shardId)
end)
-- SendModRPCToShard(SHARD_MOD_RPC["Demigod_Panda"]["Through_The_Cave"], shardId ,...)	--- shardId 直接为nil就可以跨洞穴执行
------------------------------------------------------------------------------------------------------------------------------------------------
--- 有价值的辅助函数，大多数来自官方 util.lua
IsTableEmpty = function(t)    return true end
RingBuffer = {}     --- -- Class RingBuffer (circular array)  循环数组
PrintTable = function(t)end

GetClosestInstWithTag = function(tag,inst,radius) return inst end
------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------
StartDedicatedServer = function() --- 创建生成默认世界    
end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local emoji_table = {
        ["beefalo"] = "󰀁",          --- 牛
        ["meat"] = "󰀦",             --- 肉
        ["wormhole"] = "󰀯",         --- 虫洞
        ["eyeball"] = "󰀅",          --- 眼球
        ["heart"] = "󰀍",            --- 心
        ["carrot"] = "󰀡",           --- 胡萝卜
        ["skull"] = "󰀕",            --- 白骷髅
        ["battle"] = "󰀘",           --- 双剑交叉
        ["grave"] = "󰀊",            --- 墓碑
        ["ghost"] = "󰀉",            --- 幽灵
        ["shadow"] = "󰀩",           --- 魔法引擎
        ["portal"] = "󰀰",           --- 绚丽之门
        ["trap"] = "󰀬",             --- 陷阱
        ["abigail"] = "󰀜",          --- Abigail
        ["hammer"] = "󰀌",           --- 锤子
        ["web"] = "󰀗",              --- 蜘蛛网
        ["farm"] = "󰀇",             --- 农场
        ["redgem"] = "󰀒",           --- 红宝石
        ["gold"] = "󰀚",             --- 金子
        ["wave"] = "󰀮",             --- 手（展开）
        ["lightbulb"] = "󰀏",        --- 灯泡
        ["firepit"] = "󰀤",          --- 火堆
        ["trophy"] = "󰀭",           --- 奖杯
        ["faketeeth"] = "󰀆",        --- 假牙
        ["backpack"] = "󰀞",         --- 背包
        ["berry"] = "󰀠",            --- 浆果
        ["horn"] = "󰀥",             --- 牛角
        ["tophat"] = "󰀖",           --- 礼帽
        ["sciencemachine"] = "󰀔",   --- 炼金引擎
        ["chest"] = "󰀂",            --- 箱子
        ["torch"] = "󰀛",            --- 火把
        ["shovel"] = "󰀪",           --- 铲子
        ["alchemy"] = "󰀝",          --- 炼金引擎
        ["sanity"] = "󰀓",           --- 脑子
        ["salt"] = "󰀨",             --- 盐
        ["resurrection"] = "󰀱",     --- 炼金石
        ["hunger"] = "󰀎",           --- 饥饿
        ["poop"] = "󰀑",             --- 便便
        ["pig"] = "󰀐",              --- 猪头
        ["refine"] = "󰀧",           --- 白宝石
        ["hambat"] = "󰀋",           --- 火腿棒
        ["flex"] = "󰀙",             --- 强壮手臂
        ["crockpot"] = "󰀄",         --- 烹饪锅
        ["chester"] = "󰀃",          --- 切斯特
        ["beehive"] = "󰀟",          --- 蜂箱
        ["eyeplant"] = "󰀣",         --- 眼球草
        ["egg"] = "󰀢",              --- 鸡蛋
        ["thumbsup"] = "󰀫",         --- 点赞
        ["arcane"] = "󰀀",           --- 红骷髅
        ["fire"] = "󰀈"              --- 火
    }

------------------------------------------------------------------------------------------------------------------------------------------------