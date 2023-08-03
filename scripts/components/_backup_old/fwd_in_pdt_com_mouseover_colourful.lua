----------------------------------------------------------------------------------------------------------------------------------
-- 【注意】需要在 inst.entity:SetPristine() 之后，在 TheWorld.ismastersim return 之前，加载并初始化参数。
-- 可以在服务端修改颜色，也可以在客户端修改颜色。
-- 需要hook官方函数，具体在 【Key_Modules_Of_FWD_IN_PDT\06_widgets\03_mouseover_text_colourful.lua】 查看。
----------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_mouseover_colourful = Class(function(self, inst)
    self.inst = inst
    self.colour = {}


    self.__colour_json_str = nil

end,
nil,
{

})

function fwd_in_pdt_com_mouseover_colourful:SetColour(r,g,b,a)
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


    self.colour.r = r
    self.colour.g = g
    self.colour.b = b
    self.colour.a = a
end

function fwd_in_pdt_com_mouseover_colourful:GetColour()
    if self.colour.r and self.colour.g and self.colour.b and self.colour.a then
        return self.colour.r,self.colour.g,self.colour.b,self.colour.a
    else
        return nil
    end
end

return fwd_in_pdt_com_mouseover_colourful
