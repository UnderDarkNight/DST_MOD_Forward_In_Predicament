---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- widgets/text   偶发性的崩溃：  [string "scripts/widgets/text.lua"]:58: bad argument #3 to 'SetColour' (number expected, got no value)
---- widgets/text SetColour
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddClassPostConstruct("widgets/text",function(self)
    local old_fn = self.SetColour
    self.SetColour = function(self,r,g,b,a)
        local colour = type(r) == "number" and { r, g, b, a } or r
        r,g,b,a = unpack(colour)
        old_fn(self,r or 1,g or 1,b or 1 ,a or 1)
    end
end)