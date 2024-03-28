--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    洞里自动有视野

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    
    if not TheWorld:HasTag("cave") then
        return
    end

    -------------------------------------------------------------------------------------
    ---- 创建灯光inst
        inst:DoTaskInTime(1,function()
            if not TheNet:IsDedicated() and ThePlayer == inst then

                inst.___light___fx = CreateEntity()
                inst.___light___fx.entity:AddTransform()
                inst.___light___fx.entity:AddLight()
                inst.___light___fx.entity:SetParent(inst.entity)

                inst.___light___fx.Light:SetIntensity(0.9)		-- 强度
                inst.___light___fx.Light:SetRadius(5)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
                inst.___light___fx.Light:SetFalloff(0.1)		-- 下降梯度
                inst.___light___fx.Light:SetColour(255 / 255, 255 / 255, 255 / 255)

                inst.___light___fx:ListenForEvent("onremove",function()
                    inst.___light___fx:Remove()
                end,inst)
                
            end
        end)
    -------------------------------------------------------------------------------------
    ---- 屏蔽查理
        if TheWorld.ismastersim then
            inst:DoTaskInTime(1,function()
                inst.components.grue:AddImmunity("cyclone_in_cave")

                local temp_light_fx = inst:SpawnChild("minerhatlight")
                temp_light_fx.Light:SetIntensity(0.1)
                temp_light_fx.Light:SetFalloff(0.9)
            end)
        end
    -------------------------------------------------------------------------------------
end