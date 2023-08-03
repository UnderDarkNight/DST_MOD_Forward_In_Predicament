require "prefabutil"

local assets = {
	Asset("ANIM", "anim/kirby_fx_star_door.zip"),
}

-------------------------------------------------------------------------------
local MAX_LIGHT_FRAME = 10
local MAX_LIGHT_RADIUS = 5

-- dframes is like dt, but for frames, not time
local function OnUpdateLight(inst, dframes)
    local done
    if inst._islighton:value() then
        local frame = inst._lightframe:value() + dframes
        done = frame >= MAX_LIGHT_FRAME
        inst._lightframe:set_local(done and MAX_LIGHT_FRAME or frame)
    else
        local frame = inst._lightframe:value() - dframes
        done = frame <= 0
        inst._lightframe:set_local(done and 0 or frame)
    end

    inst.Light:SetRadius(MAX_LIGHT_RADIUS * inst._lightframe:value() / MAX_LIGHT_FRAME)

    if done then
        inst._lighttask:Cancel()
        inst._lighttask = nil
    end
end

local function OnUpdateLightColour(inst)
	inst._lighttweener = inst._lighttweener + FRAMES * 1.25
	if inst._lighttweener > 2 * PI then
		inst._lighttweener = inst._lighttweener - 2*PI
	end
	local x = inst._lighttweener
	local s = .15
	local b = 0.85
	local sin = math.sin
	inst.Light:SetColour(
		sin(x) * s + b - s, 
		sin(x + 2/3 * PI) * s + b - s, 
		sin(x - 2/3 * PI) * s + b - s) 
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    OnUpdateLight(inst, 0)

	if not TheNet:IsDedicated() then
		if inst._islighton:value() then
			if inst._lightcolourtask == nil then
				inst._lighttweener = 0
				inst._lightcolourtask = inst:DoPeriodicTask(FRAMES, OnUpdateLightColour)
			end
		elseif inst._lightcolourtask ~= nil then
			inst._lightcolourtask:Cancel()
			inst._lightcolourtask = nil
		end
	end
end
-------------------------------------------------------------------------------

local function TurnLightOff(inst)
	inst._islighton:set(false)
	OnLightDirty(inst)
end

local function play_arrive_sound(inst)
    inst.SoundEmitter:PlaySound("terraria1/eyeofterror/arrive_portal")
end

local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()


    inst.entity:AddAnimState()
    inst.AnimState:SetBank("kirby_fx_star_door")
    inst.AnimState:SetBuild("kirby_fx_star_door")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(-1)
    -- inst.AnimState:SetSortOrder(-1)
    -- inst.AnimState:SetLayer(LAYER_WORLD)

    inst.Light:SetRadius(0)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst._lightframe = net_smallbyte(inst.GUID, "portalwatch._lightframe", "lightdirty")
    inst._islighton = net_bool(inst.GUID, "portalwatch._islighton", "lightdirty")
    inst._lighttask = nil
    inst._islighton:set(true)
	OnLightDirty(inst)

    inst.__net_str = net_string(inst.GUID, "kirby_fx_command","kriby_fx_star_door") ----- 用json 传送数据同步
    ---------------------------------------------------------------------------------------
    inst:ListenForEvent("CMD Data Set",function(_,_table)
        local function GetRandomM()
            if math.random(1000) <= 500 then
                return -1
            else
                return 1
            end
        end
        local base_sacle = Vector3(2,0.8,2)
        if _table.orientation then  ----- 切换成二维图片
             base_sacle = Vector3(2,2,2)
        end
        local max_sacle = Vector3(1,1,1)
        local vect = Vector3(GetRandomM(),GetRandomM(),GetRandomM())

        if _table == nil then
            return
        end
        if _table.scale and _table.scale.x then
            max_sacle = _table.scale
        end
        local ret_scale = Vector3(base_sacle.x*max_sacle.x*vect.x , base_sacle.y*max_sacle.y*vect.y , base_sacle.z*max_sacle.z*vect.z)
        inst.AnimState:SetScale(ret_scale.x,ret_scale.y,ret_scale.z)

        if _table.type then
            inst.AnimState:OverrideSymbol("type1","kirby_fx_star_door","type2")
            inst.AnimState:OverrideSymbol("line1","kirby_fx_star_door","line2")
        end

        if _table.layer then
            inst.AnimState:SetLayer(_table.layer)
        end
        if _table.orientation then
            inst.AnimState:SetOrientation(_table.orientation)
        end
        if _table.sort then
            inst.AnimState:SetSortOrder(_table.sort)
        end

        if _table.speed_mult then
            inst.AnimState:SetDeltaTimeMultiplier(_table.speed_mult)
        end


        if _table.appear then   -------------------------------------------------------------
            if _table.appear_anim_speed_mult then
                inst.AnimState:SetDeltaTimeMultiplier(_table.appear_anim_speed_mult)
            end
            inst.AnimState:PlayAnimation("appear")
            inst.AnimState:PushAnimation("idle",true)
            inst.appear_task = function()
                inst:RemoveEventCallback("animover",inst.appear_task)
                if _table.idle_anim_speed_mult then
                    inst.AnimState:SetDeltaTimeMultiplier(_table.idle_anim_speed_mult)
                end
            end
            inst:ListenForEvent("animover",inst.appear_task)
        else                    -------------------------------------------------------------
            if _table.idle_anim_speed_mult then
                inst.AnimState:SetDeltaTimeMultiplier(_table.idle_anim_speed_mult)
            end
            inst.AnimState:PlayAnimation("idle",true)
        end                     -------------------------------------------------------------

        if _table.time and type(_table.time) == "number" then
            inst:DoTaskInTime(_table.time,function()
                if _table.disappear_anim_speed_mult then
                    inst.AnimState:SetDeltaTimeMultiplier(_table.disappear_anim_speed_mult)
                end
                inst.AnimState:PlayAnimation("disappear")
                inst:ListenForEvent("animover",inst.Remove)
                -- TurnLightOff(inst)
            end)
        end
    end)
    ---------------------------------------------------------------------------------------
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then   
        -----------------------------------------------------------------------------------
        ---- client
        inst:ListenForEvent("kriby_fx_star_door",function()
            local str = inst.__net_str:value()
            local CMD = json.decode(str)
            inst:PushEvent("CMD Data Set",CMD)
        end)
        inst:ListenForEvent("lightdirty", OnLightDirty)

        -----------------------------------------------------------------------------------
        return inst
    end

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    inst:ListenForEvent("Set",function(_,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),                         ----- 出现坐标
        --     color = Vector3(255,255,255),                ----- 颜色改变       ---
        --     a = 0.1,                                     ----- 透明度改变     --- 
        --     Mult = nil, -- or true                       ----- 着色器         ---
        --     sound == nil, -- or sound addr               ----- 声音播放
        --     scale == Vector3(0,0,0)                      ----- 缩放倍率
        --     time = nil or number                         ----- 持续时间
        --     appear = nil or true                         ----- 是否播放出场动画
        --     type = nil or true                           ----- 切换另一个形状

        --     sort = nil or number                         ----- 贴图位于图层，默认0
        --     orientation = ANIM_ORIENTATION.OnGround      ----- 切换成二维平面用的参数，ANIM_ORIENTATION.OnGround    constants.lua 里找参数
        --     layer = LAYER_WORLD_DEBUG                    ----- 二维平面用的一些参数  LAYER_WORLD_DEBUG              constants.lua 里找参数

        --     appear_anim_speed_mult = nil or number       ----- 展开时播放乘数
        --     idle_anim_speed_mult = nil or number         ----- idle时候的播放乘数
        --     disappear_anim_speed_mult  = nil or number   ----- 消失时候的播放乘数

        --     trans_start_time = 3                         ----- 传送门增亮开始时间
        --     trans_remain_time = 5                        ----- 传送门高亮持续时间
        --     trans_flash_fps = 24                         ----- 闪光耗费帧数
        --     trans_fn = nil or function(inst)             ----- 传送门最亮后执行function

        --     fn = nil or  function(inst)                  ----- 执行连携function
        --     fn_time = nil or  function(inst)             ----- 执行连携延时function
        -- }
        -- 
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        if _table.color and _table.color.x then
            if _table.Mult ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
            end
        end
        if _table.sound and inst.SoundEmitter then
            inst.SoundEmitter:PlaySound(_table.sound)            
        end
        if _table.time and type(_table.time) == "number" then
            inst:DoTaskInTime(_table.time,function()
                TurnLightOff(inst)
            end)
            inst:DoTaskInTime(_table.time+1,inst.Remove)
        end
        ------------------------------------------------------------------------------
        --- 下发之前执行和清掉func
            if _table.fn then   
                _table.fn(inst)
                _table.fn = nil
            end
            if _table.fn_time and _table.time and type(_table.time) == "number" then
                local temp_fn = _table.fn_time
                _table.fn_time = nil
                inst:DoTaskInTime(_table.time,function()
                    temp_fn(inst)
                end)
            end
        ------------------------------------------------------------------------------
        --- 增亮task    
            if _table.trans_start_time and _table.trans_remain_time and type(_table.trans_start_time) == "number" and type(_table.trans_remain_time) == "number" then
                if inst.components.colouradder == nil then
                    inst:AddComponent("colouradder")
                end
                inst:DoTaskInTime(_table.trans_start_time,function()
                        if inst.__trans_lightoff_task then
                            inst.__trans_lightoff_task:Cancel()
                        end
                        --- FRAMES 帧时间，1秒有30帧 0.4s = 12 帧，从0到 255 用 12 帧
                        local fps = _table.trans_flash_fps or 24
                        local delta_num = 255/fps
                        inst.__trans_lightup_task_num = 0
                        inst.__trans_lightup_task = inst:DoPeriodicTask(FRAMES,function()
                            local num = inst.__trans_lightup_task_num * delta_num /255
                            inst.components.colouradder:OnSetColour(num,num,num,1)
                            inst.__trans_lightup_task_num = inst.__trans_lightup_task_num + 1
                            if inst.__trans_lightup_task_num > fps then
                                inst.__trans_lightup_task:Cancel()
                                inst.__trans_lightup_task = nil
                                if _table.trans_fn and type(_table.trans_fn) == "function" then
                                    local trans_fn = _table.trans_fn
                                    inst:DoTaskInTime(0.2,trans_fn)
                                end
                            end
                        end)                        
                end)
                inst:DoTaskInTime(_table.trans_start_time+_table.trans_remain_time,function()
                        if inst.__trans_lightup_task  then
                            inst.__trans_lightup_task:Cancel()
                        end
                        local fps = _table.trans_flash_fps or 24
                        local delta_num = 255/fps
                        inst.__trans_lightoff_task_num = fps
                        inst.__trans_lightoff_task = inst:DoPeriodicTask(FRAMES,function()
                            local num = inst.__trans_lightoff_task_num * delta_num /255
                            inst.components.colouradder:OnSetColour(num,num,num,1)
                            inst.__trans_lightoff_task_num = inst.__trans_lightoff_task_num - 1
                            if inst.__trans_lightoff_task_num < 0 then
                                inst.__trans_lightoff_task:Cancel()
                                inst.components.colouradder:OnSetColour(0,0,0,1)
                            end
                        end)
                end)

                -------------
            end
        ------------------------------------------------------------------------------
        -------- 清除 function,不给 net_string 下发

        local new_cmd_table = {}
        for name, v in pairs(_table) do
            if name ~= nil and type(v) ~= "function" then
                new_cmd_table[name] = v
            end
        end
        
        local str = json.encode(new_cmd_table)
        inst.__net_str:set(str)
        inst:PushEvent("CMD Data Set",_table)       
        inst.Ready = true
    end)



    return inst
end

return Prefab("kirby_fx_star_door",fx,assets)


-- API 示例
--[[

        SpawnPrefab("kirby_fx_star_door"):PushEvent("Set",{
        pt = Vector3(x,y+10,z),
        scale = Vector3(1.5,1.5,1.5),
        appear = true,
        time = 20,
        -- type = true,
        trans_start_time = 5,
        trans_remain_time = 5,
        trans_fn = function(inst)
            local pt = Vector3(inst.Transform:GetWorldPosition())
            local item = SpawnPrefab("log")
            item.Transform:SetPosition(pt.x, pt.y - 0.2, pt.z)
        end,

        appear_anim_speed_mult = 1,
        idle_anim_speed_mult = 0.5,
        disappear_anim_speed_mult = 1,
    })


]]--