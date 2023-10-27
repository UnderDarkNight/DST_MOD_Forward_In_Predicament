require "prefabutil"


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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetRadius(0)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)

    inst.AnimState:SetBank("eyeofterror_portal")
    inst.AnimState:SetBuild("eyeofterror_portal")
    inst.AnimState:PlayAnimation("arrive")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("INLIMBO")
    inst:AddTag("NOBLOCK")

    inst._lightframe = net_smallbyte(inst.GUID, "portalwatch._lightframe", "lightdirty")
    inst._islighton = net_bool(inst.GUID, "portalwatch._islighton", "lightdirty")
    inst._lighttask = nil
    inst._islighton:set(true)
	OnLightDirty(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

    inst:DoTaskInTime(0, play_arrive_sound)

	inst.persists = false
	inst:DoTaskInTime(120*FRAMES, TurnLightOff)
	inst:ListenForEvent("animover", inst.Remove)

    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     color = Vector3(255,255,255),
        --     a = 0.1,
        --     scale = Vector3(0,0,0)
        --     t_scale = nil  ----- transform 缩放
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end

        if _table.color and _table.color.x then
            inst:AddComponent("colouradder")
            inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
        end

        if _table.scale and _table.t_scale ~= true then
            inst.AnimState:SetScale(_table.scale.x,_table.scale.y,_table.scale.z)
        end

        if _table.scale and _table.t_scale == true then
            local temp = inst.Transform:GetScale()
            inst.Transform:SetScale(_table.scale.x * temp,_table.scale.y*temp,_table.scale.z*temp)
        end



    end)



    return inst
end

return Prefab("fwd_in_pdt_fx_sky_door", fn)
