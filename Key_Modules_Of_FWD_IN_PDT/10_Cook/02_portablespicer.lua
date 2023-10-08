--------------------------------------------------------------------------------------------------------------------------------------------
--- 便携香料站 放入臭豆腐
--------------------------------------------------------------------------------------------------------------------------------------------

local containers = require("containers")

local portablespicer = containers.params.portablespicer
portablespicer.itemtestfn_fwd_in_pdt_old = portablespicer.itemtestfn
portablespicer.itemtestfn = function(container, item, slot)
    if not container.inst:HasTag("burnt") and item and item.prefab then
        if item:HasTag("fwd_in_pdt_food_stinky_tofu_mixed") then
            return false
        end
        if item.prefab == "fwd_in_pdt_food_stinky_tofu" then
            if slot == 2 or slot == nil then
                return true
            else
                return false
            end
        end
    end
    return  portablespicer.itemtestfn_fwd_in_pdt_old(container,item,slot)
end