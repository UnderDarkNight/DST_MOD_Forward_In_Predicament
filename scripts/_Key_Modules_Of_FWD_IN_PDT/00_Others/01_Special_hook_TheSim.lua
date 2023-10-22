------------------------------------------------------------
---- 解决某些特殊版本饥荒无法生成骷髅问题
------------------------------------------------------------
if TheSim and TheSim.HasPlayerSkeletons and TheSim:HasPlayerSkeletons() == false then
    if type(TheSim) == "userdata" then
        local tempSim = getmetatable(TheSim).__index
        tempSim.HasPlayerSkeletons = function()
            return true
        end
    elseif type(TheSim) == "table" then
        TheSim.HasPlayerSkeletons = function()
            return true
        end
    end   
end
