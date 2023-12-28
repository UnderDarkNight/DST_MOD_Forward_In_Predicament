--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    能否吸血的判定直接调用沃拓克斯的机制

    每攻击一次增加10点血量。

    只能对带着 脑子 的目标造成吸血

    被任何攻击有2s硬直，避免打群架的时候被控到死。每次触发会消耗 0.5 饥饿值。如果饥饿值为0 则无法触发硬直

    打死一个怪得1血瓶,BOSS 得10 个。 被卡尔打过的怪才会掉。 

    
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    ---------------------------------------------------------------------------------------------------------------------------------------
        local function HasSoul(target)
            local wortox_soul_common = require("prefabs/wortox_soul_common")
            return wortox_soul_common.HasSoul(target)
        end
    ---------------------------------------------------------------------------------------------------------------------------------------
    ---- 普通攻击
        inst:ListenForEvent("onhitother",function(_,_table)
            if _table and _table.target and HasSoul(_table.target) and (_table.damage or 0) > 0 then
                inst.components.health:DoDelta(10,true)
                _table.target:AddTag("fwd_in_pdt_tag.attacked_by_carl")
            end
        end)
    ---------------------------------------------------------------------------------------------------------------------------------------
    ---- 用蝙蝠剑的时候 额外吸血
        inst:ListenForEvent("fwd_in_pdt_event.vampire_sword_hit_target",function(_,target)
            if target and HasSoul(target) then
                inst.components.health:DoDelta(20,true)
            end
        end)
    ---------------------------------------------------------------------------------------------------------------------------------------
    ----- 硬直
        inst:DoTaskInTime(0,function()
            inst.components.fwd_in_pdt_func:PreGetAttacked_Add_Fn(function(combat_com,attacker, damage, ...)
                if damage > 0 then
                    if combat_com.____fwd_in_pdt_carl_attacked_rigid_task ~= nil then
                        local hunger_delta_num = 0.5
                        if inst.components.hunger.current > hunger_delta_num then
                                inst.components.hunger:DoDelta(-hunger_delta_num,true)
                                damage = 0
                                local fx = combat_com.inst:SpawnChild("fwd_in_pdt_fx_shadow_shell")
                                fx:PushEvent("Set",{
                                    pt = Vector3(0,0,0),
                                    speed = 2,
                                    color = Vector3(255,0,0)
                                })
                        end

                    else
                        combat_com.____fwd_in_pdt_carl_attacked_rigid_task = combat_com.inst:DoTaskInTime(2,function()
                            combat_com.____fwd_in_pdt_carl_attacked_rigid_task = nil
                        end)
                    end
                end
                return attacker,damage,...
            end)
        end)
    ---------------------------------------------------------------------------------------------------------------------------------------
    ---- 血瓶


        local _onentitydeathfn = function(src, data) 
            local target = data.inst
            -- print("entity_death",target)
            if target and not target:HasTag("fwd_in_pdt_bloody_flask_flag") then
                target:AddTag("fwd_in_pdt_bloody_flask_flag")

                if not HasSoul(target) then --- 使用 沃拓克斯 的灵魂判定
                    return
                end

                local x,y,z = target.Transform:GetWorldPosition()
                local temp_players = TheSim:FindEntities(x, y, z, 50, {"fwd_in_pdt_carl"}, {"playerghost"}, nil)                
                if not(#temp_players > 0 or target:HasTag("fwd_in_pdt_tag.attacked_by_carl") )then  --- 附近没卡尔或者没被卡尔打死过
                    return
                end

                local num = 1
                if target:HasTag("epic") then
                    num = 10
                end

                TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                    target = Vector3(x,y,z),
                    name = "fwd_in_pdt_item_bloody_flask",
                    num = num,    
                    range = math.random(15,40)/10, 
                    height = 4,
                    -- random_height = true,
                })

            end
        end
        inst:ListenForEvent("entity_death", _onentitydeathfn, TheWorld)



end