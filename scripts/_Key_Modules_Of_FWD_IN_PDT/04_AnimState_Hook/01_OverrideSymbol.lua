if TUNING["Forward_In_Predicament.AnimStateFn"] == nil then
    TUNING["Forward_In_Predicament.AnimStateFn"] = {}
end

TUNING["Forward_In_Predicament.AnimStateFn"]["01_OverrideSymbol"] = function(theAnimState)

    -- OverrideSymbol

    if theAnimState.OverrideSymbol__old_fwd_in_pdt == nil then
        theAnimState.OverrideSymbol__old_fwd_in_pdt = theAnimState.OverrideSymbol
        theAnimState.OverrideSymbol = function(self,layer,build,layer_new)
            -- print("fwd_in_pdt OverrideSymbol",layer,build,layer_new)
            self:OverrideSymbol__old_fwd_in_pdt(layer,build,layer_new)
        end
    end

end