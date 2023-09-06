------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 鼠标放上去的文本显示颜色
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(self)
    function self:Mouseover_SetColour(r,g,b,a)
        if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
            return
        end
        if a ~= nil and type(a) ~= "number" then
            return
        end
        ---- 保证所有数据都是 number,a 可以是nil
        local format_exchange_flag = false         --   判断是否处理过格式转换，方便 a的设置
        if r > 1 or g > 1 or b > 1 then
            r = r/255
            g = g/255
            b = b/255        
            format_exchange_flag = true
        end
        if format_exchange_flag and a then
            a = a/255
        else
            a = a or 1
        end
    
        local colour = {
            r = r,
            g = g,
            b = b,
            a = a,
        }
        self.tempData.__mouser_over_colour = colour
        self:Replica_Set_Simple_Data("mouseover_colour",colour)
    end
    
    function self:Mouseover_GetColour()
        local colour = self.tempData.__mouser_over_colour or {}
        if colour.r and colour.g and colour.b and colour.a then
            return colour.r,colour.g,colour.b,colour.a
        else
            return nil
        end
    end

    function self:Mouseover_SetText(str)
        if type(str) == "string" then
            self.tempData.__mouser_over_text = str
            self:Replica_Set_Simple_Data("mouseover_text",str)
        end
    end

    function self:Mouseover_GetText()
        return self.tempData.__mouser_over_text
    end

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(self)
    function self:Mouseover_SetColour(r,g,b,a)
        if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
            return
        end
        if a ~= nil and type(a) ~= "number" then
            return
        end
        ---- 保证所有数据都是 number,a 可以是nil
        local format_exchange_flag = false         --   判断是否处理过格式转换，方便 a的设置
        if r > 1 or g > 1 or b > 1 then
            r = r/255
            g = g/255
            b = b/255        
            format_exchange_flag = true
        end
        if format_exchange_flag and a then
            a = a/255
        else
            a = a or 1
        end
    
    
        local colour = {
            r = r,
            g = g,
            b = b,
            a = a,
        }
        -- self.tempData.__mouser_over_colour = colour
        self:Replica_Set_Simple_Data("mouseover_colour",colour)
    end
    
    function self:Mouseover_GetColour()
        local colour = self:Replica_Get_Simple_Data("mouseover_colour") or {}
        -- self.tempData.__mouser_over_colour = colour
        if colour.r and colour.g and colour.b and colour.a then
            return colour.r,colour.g,colour.b,colour.a
        else
            return nil
        end
    end

    function self:Mouseover_SetText(str)
        if type(str) == "string" then
            self:Replica_Set_Simple_Data("mouseover_text",str)
        end
    end

    function self:Mouseover_GetText()
        return self:Replica_Get_Simple_Data("mouseover_text")
    end

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(fwd_in_pdt_func)
    fwd_in_pdt_func.inst:AddTag("fwd_in_pdt_tag.fwd_in_pdt_func.Colourful")    --- 添加tag 方便外部扫描到拥有该模块的inst。

    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else                
        replica(fwd_in_pdt_func)                        
    end

end