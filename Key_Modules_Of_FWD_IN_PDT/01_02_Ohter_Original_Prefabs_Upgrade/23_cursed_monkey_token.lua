-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    猴子诅咒不会被人捡起来
]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





AddPrefabPostInit(
    "cursed_monkey_token",
    function(inst)

        
        if not TheWorld.ismastersim then
            return
        end


        local old_checkplayersinventoryforspace_fn = inst.components.curseditem.checkplayersinventoryforspace
        inst.components.curseditem.checkplayersinventoryforspace = function(self, player,...)
            if player and player:HasTag("fwd_in_pdt_cyclone") then
                return false
            end
            return old_checkplayersinventoryforspace_fn(self, player,...)
        end


    end
)

