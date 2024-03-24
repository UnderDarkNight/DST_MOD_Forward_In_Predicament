----------------------------------------------------------------------------------------------------------------------------------
--[[

     

]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_tag_sys = Class(function(self, inst)
    self.inst = inst

    self.tags = {}
    self.tags_by_time = {}

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
----- event push
    function fwd_in_pdt_com_tag_sys:EventPush()
        self.inst:PushEvent("fwd_in_pdt_com_tag_sys.refresh")
        
    end
------------------------------------------------------------------------------------------------------------------------------
------
    function fwd_in_pdt_com_tag_sys:SwitchTagByCMD(cmd_table)
        -- local rpc_data = {
        --     ["tag_name"] = tag_name,
        --     ["time"] = os.time(),
        --     ["AddTag"] = true,
        -- }
        local current_tag = cmd_table.tag_name
        local new_tag_time = cmd_table.time

        local old_tag_time = self.tags_by_time[current_tag] or 0
        if new_tag_time > old_tag_time then
            self.tags_by_time[current_tag] = new_tag_time
            if cmd_table.AddTag then
                self.tags[current_tag] = true
            else
                self.tags[current_tag] = false
            end
        end
        self:EventPush()
    end
------------------------------------------------------------------------------------------------------------------------------
---- AddTag/RemoveTag
    function fwd_in_pdt_com_tag_sys:AddTag(tag_name)
        self.tags[tag_name] = true
        self:EventPush()
    end
    function fwd_in_pdt_com_tag_sys:RemoveTag(tag_name)
        self.tags[tag_name] = false
        self:EventPush()
    end
------------------------------------------------------------------------------------------------------------------------------
---- HasTag
    function fwd_in_pdt_com_tag_sys:HasTag(tag_name)
        if TheWorld.ismastersim then
            return self.inst.components.fwd_in_pdt_com_tag_sys:HasTag(tag_name)
        end
        return self.tags[tag_name] or false
    end
    function fwd_in_pdt_com_tag_sys:HasOneOfTags(temp,...)
        if TheWorld.ismastersim then
            return self.inst.components.fwd_in_pdt_com_tag_sys:HasOneOfTags(temp,...)
        end

        local _temp_tags = nil
        if type(temp) == "table" then
            _temp_tags = temp
        else
            _temp_tags = {temp,...}
        end

        for _,tag_name in pairs(_temp_tags) do
            if self.tags[tag_name] then
                return true
            end
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_tag_sys







