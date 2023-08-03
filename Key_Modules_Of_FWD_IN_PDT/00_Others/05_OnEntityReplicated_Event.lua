------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 修改 replica 的加载初始化形式，让其可以使用 event 进行初始化

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- require(modname)
require("entityreplica")    -- 加载一下

rawset(EntityScript, "ReplicateEntity__fwd_in_pdt_old", rawget(EntityScript, "ReplicateEntity"))
rawset(EntityScript, "ReplicateEntity", function(self,...)
    local rets = {self:ReplicateEntity__fwd_in_pdt_old(...)}
    self:PushEvent("fwd_in_pdt_event.OnReplicated")
    return unpack(rets)
end)