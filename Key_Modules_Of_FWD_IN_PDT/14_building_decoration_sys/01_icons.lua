----------------------------------------------------------------------------------------------------------------------------------
--[[

    素材库 和 参数表

    参数表说明

    默认情况下，使用像素100X100的图片。场景内的素材也是100X100的尺寸。
    但是，如果 超出 100x100像素，前面的参数就是 slot盒子里的动画。
        后续的 decoration = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "a"}
        则是 建筑物上的挂载

    TUNING.FWD_IN_PDT_DECORATIONS = {    
        ["yellow_alphabet_a"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "a" , decoration = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "a"}},
        ["yellow_alphabet_b"] = {bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "b"},
        ....
    }

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
	    Asset("ANIM", "anim/fwd_in_pdt_fx_canvas.zip"),
    ---------------------------------------------------------------------------------------------
    --- 装饰
	    Asset("ANIM", "anim/fwd_in_pdt_decoration_excample_spring_scrolls.zip"), --- 示例用的对联
    ---------------------------------------------------------------------------------------------
}
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
----------------------------------------------------------------------------------------------------------------------------------

TUNING.FWD_IN_PDT_DECORATIONS = {
    {id = "yellow_alphabet_a", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "a"},
    {id = "yellow_alphabet_b", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "b"},
    {id = "yellow_alphabet_c", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "c"},
    {id = "yellow_alphabet_d", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "d"},
    {id = "yellow_alphabet_e", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "e"},
    {id = "yellow_alphabet_f", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "f"},
    {id = "yellow_alphabet_g", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "g"},
    {id = "yellow_alphabet_h", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "h"},
    {id = "yellow_alphabet_i", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "i"},
    {id = "yellow_alphabet_j", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "j"},
    {id = "yellow_alphabet_k", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "k"},
    {id = "yellow_alphabet_l", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "l"},
    {id = "yellow_alphabet_m", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "m"},
    {id = "yellow_alphabet_n", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "n"},
    {id = "yellow_alphabet_o", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "o"},
    {id = "yellow_alphabet_p", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "p"},
    {id = "yellow_alphabet_q", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "q"},
    {id = "yellow_alphabet_r", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "r"},
    {id = "yellow_alphabet_s", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "s"},
    {id = "yellow_alphabet_t", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "t"},
    {id = "yellow_alphabet_u", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "u"},
    {id = "yellow_alphabet_v", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "v"},
    {id = "yellow_alphabet_w", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "w"},
    {id = "yellow_alphabet_x", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "x"},
    {id = "yellow_alphabet_y", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "y"},
    {id = "yellow_alphabet_z", bank = "fwd_in_pdt_fx_canvas" ,build = "fwd_in_pdt_fx_canvas" ,anim = "z"},
    {id = "excample_spring_scrolls_titile",bank = "fwd_in_pdt_decoration_excample_spring_scrolls" ,build = "fwd_in_pdt_decoration_excample_spring_scrolls" ,anim = "icon_title" , decoration = {bank = "fwd_in_pdt_decoration_excample_spring_scrolls" ,build = "fwd_in_pdt_decoration_excample_spring_scrolls" ,anim = "title"}},
    {id = "excample_spring_scrolls_scroll",bank = "fwd_in_pdt_decoration_excample_spring_scrolls" ,build = "fwd_in_pdt_decoration_excample_spring_scrolls" ,anim = "icon_scroll" , decoration = {bank = "fwd_in_pdt_decoration_excample_spring_scrolls" ,build = "fwd_in_pdt_decoration_excample_spring_scrolls" ,anim = "scroll"}},
}
TUNING.FWD_IN_PDT_DECORATIONS_IDS = {}
for k,temp_data in pairs(TUNING.FWD_IN_PDT_DECORATIONS) do
    TUNING.FWD_IN_PDT_DECORATIONS_IDS[temp_data.id or tostring(temp_data.bank)..tostring(temp_data.build)..tostring(temp_data.anim)] = temp_data
end
