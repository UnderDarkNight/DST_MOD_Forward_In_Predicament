--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    圈圈特效

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function fn()
        local inst = CreateEntity()

        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst:AddTag("CLASSIFIED")
        inst:AddTag("NOCLICK")
        inst:AddTag("placer")

        inst.AnimState:SetBank("firefighter_placement")
        inst.AnimState:SetBuild("firefighter_placement")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetAddColour(0, .2, .5, 0)
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:SetSortOrder(3)

        -- local CIRCLE_RADIUS_SCALE = 1888 / 150 / 2 -- Source art size / anim_scale / 2 (halved to get radius).

        -- local scale = 35 / CIRCLE_RADIUS_SCALE -- Convert to rescaling for our desired range.

        -- inst.AnimState:SetScale(scale, scale)

        -- NOTE(DiogoW): We are fighting against the parent's scale, which is considerably non-optimal...
        -- local SENTRYWARD_SCALE = 1.3
        -- local DEPLOYHELPER_SCALE = 1/SENTRYWARD_SCALE
        -- inst.Transform:SetScale(DEPLOYHELPER_SCALE, DEPLOYHELPER_SCALE, DEPLOYHELPER_SCALE)

        --- 动画尺寸 半径 950pix

        function inst:SetRadius(radius)
                ---- 1距离150像素，圈圈半径950像素
                local pix_radious = 950
                local discanse_1_for_1_pix = 150
        
                local range =  radius or 1
                local scale = range * discanse_1_for_1_pix/pix_radious
                self.AnimState:SetScale(scale,scale,scale)
        end

        if not TheWorld.ismastersim then
            return inst
        end

        inst:ListenForEvent("Set",function(inst,_table)
            -- _table = {
            --     pt = Vector3(0,0,0),
            --     target = target,
            --     range = 1,
            --     color = Vector3(0,0,0),
            --     MultColour_Flag = false,
            -- }
            if type(_table) ~= "table" then
                return
            end

            if _table.pt then
                inst.Transform:SetPosition(_table.pt.x, _table.pt.y, _table.pt.z)
            end
            if _table.target then
                inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
            end

            if _table.color and _table.color.x then
                if _table.MultColour_Flag ~= true then
                    inst:AddComponent("colouradder")
                    inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
                else
                    inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
                end
            end
            ----------------------------------------------------------------------------------
                inst:SetRadius(_table.range or _table.radius or 1)
            ----------------------------------------------------------------------------------


            inst.Ready = true
        end)

        inst:DoTaskInTime(0,function(inst)
            if not inst.Ready then
                inst:Remove()
            end
        end)

        return inst    
    end

return Prefab("fwd_in_pdt_fx_dotted_circle", fn)