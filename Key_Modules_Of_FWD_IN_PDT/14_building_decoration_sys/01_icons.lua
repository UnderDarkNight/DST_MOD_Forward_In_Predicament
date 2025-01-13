----------------------------------------------------------------------------------------------------------------------------------
--[[

    素材库 和 参数表

]]--
----------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end

local temp_assets = {
    ---------------------------------------------------------------------------------------------
    --- UI
        Asset("ATLAS", "images/widget/fwd_in_pdt_decoration_ui.xml"),
    ---------------------------------------------------------------------------------------------
    --- 字母
        -- Asset("IMAGE", "images/fwd_in_pdt_decorations/fwd_in_pdt_decoration_alphabet.tex"),
        -- Asset("ATLAS", "images/fwd_in_pdt_decorations/fwd_in_pdt_decoration_alphabet.xml"),
	    Asset("ANIM", "anim/fwd_in_pdt_fx_canvas.zip"),

    ---------------------------------------------------------------------------------------------
}
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
----------------------------------------------------------------------------------------------------------------------------------

TUNING.FWD_IN_PDT_DECORATIONS = {    
    ["yellow_alphabet_a"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "a"},
    ["yellow_alphabet_b"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "b"},
    ["yellow_alphabet_c"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "c"},
    ["yellow_alphabet_d"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "d"},
    ["yellow_alphabet_e"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "e"},
    ["yellow_alphabet_f"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "f"},
    ["yellow_alphabet_g"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "g"},
    ["yellow_alphabet_h"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "h"},
    ["yellow_alphabet_i"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "i"},
    ["yellow_alphabet_j"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "j"},
    ["yellow_alphabet_k"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "k"},
    ["yellow_alphabet_l"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "l"},
    ["yellow_alphabet_m"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "m"},
    ["yellow_alphabet_n"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "n"},
    ["yellow_alphabet_o"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "o"},
    ["yellow_alphabet_p"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "p"},
    ["yellow_alphabet_q"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "q"},
    ["yellow_alphabet_r"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "r"},
    ["yellow_alphabet_s"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "s"},
    ["yellow_alphabet_t"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "t"},
    ["yellow_alphabet_u"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "u"},
    ["yellow_alphabet_v"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "v"},
    ["yellow_alphabet_w"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "w"},
    ["yellow_alphabet_x"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "x"},
    ["yellow_alphabet_y"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "y"},
    ["yellow_alphabet_z"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "z"},

}