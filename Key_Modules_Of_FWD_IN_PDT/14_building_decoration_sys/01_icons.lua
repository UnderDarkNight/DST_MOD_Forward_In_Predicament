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
        Asset("ANIM", "anim/fwd_in_pdt_decoration_old.zip"),
    ---------------------------------------------------------------------------------------------
    --- 装饰
	    Asset("ANIM", "anim/fwd_in_pdt_decoration_spring_scrolls.zip"), --- 对联
	    Asset("ANIM", "anim/fwd_in_pdt_decoration_cats_1.zip"), --- 猫
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
    --- 示例春联
    {id = "spring_scrolls_title",bank = "fwd_in_pdt_decoration_spring_scrolls" ,build = "fwd_in_pdt_decoration_spring_scrolls" ,anim = "icon_title" , decoration = {bank = "fwd_in_pdt_decoration_spring_scrolls" ,build = "fwd_in_pdt_decoration_spring_scrolls" ,anim = "title"}},
    {id = "spring_scrolls_scroll_left",bank = "fwd_in_pdt_decoration_spring_scrolls" ,build = "fwd_in_pdt_decoration_spring_scrolls" ,anim = "icon_left_scroll" , decoration = {bank = "fwd_in_pdt_decoration_spring_scrolls" ,build = "fwd_in_pdt_decoration_spring_scrolls" ,anim = "left_scroll"}},
    {id = "spring_scrolls_scroll_right",bank = "fwd_in_pdt_decoration_spring_scrolls" ,build = "fwd_in_pdt_decoration_spring_scrolls" ,anim = "icon_right_scroll" , decoration = {bank = "fwd_in_pdt_decoration_spring_scrolls" ,build = "fwd_in_pdt_decoration_spring_scrolls" ,anim = "right_scroll"}},
    --- fwd_in_pdt_decoration_cats_1 猫包
    {id = "jellyfish_1",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_jellyfish_1" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "jellyfish_1"}},
    {id = "jellyfish_2",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_jellyfish_2" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "jellyfish_2"}},
    {id = "pink_cat_wind_chime",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_wind_chime" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "wind_chime"}},
    {id = "innocent_black_cat",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_black_cat" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "black_cat"}},
    {id = "blue_cat_holding",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_cat_blue" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "cat_blue"}},
    {id = "orange_cat_holding",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_cat_orange" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "cat_orange"}},
    {id = "black_cat_holding",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_cat_black" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "cat_black"}},
    {id = "white_cat_holding",bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "icon_cat_white" , decoration = {bank = "fwd_in_pdt_decoration_cats_1" ,build = "fwd_in_pdt_decoration_cats_1" ,anim = "cat_white"}},
    --- fwd_in_pdt_decoration_old
    {id = "decoration_1", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_1"},
    {id = "decoration_2", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_2"},
    {id = "decoration_3", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_3"},
    {id = "decoration_4", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_4"},
    {id = "decoration_5", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_5"},
    {id = "decoration_6", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_6"},
    {id = "decoration_7", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_7"},
    {id = "decoration_8", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_8"},
    {id = "decoration_9", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_9"},
    {id = "decoration_10", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_10"},
    {id = "decoration_11", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_11"},
    {id = "decoration_12", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_12"},
    {id = "decoration_13", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_13"},
    {id = "decoration_14", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_14"},
    {id = "decoration_15", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_15"},
    {id = "decoration_16", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_16"},
    {id = "decoration_17", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_17"},
    {id = "decoration_18", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_18"},
    {id = "decoration_19", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_19"},
    {id = "decoration_20", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_20"},
    {id = "decoration_21", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_21"},
    {id = "decoration_22", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_22"},
    {id = "decoration_23", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_23"},
    {id = "decoration_24", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_24"},
    {id = "decoration_25", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_25"},
    {id = "decoration_26", bank = "fwd_in_pdt_decoration_old" ,build = "fwd_in_pdt_decoration_old" ,anim = "decoration_26"},
}
TUNING.FWD_IN_PDT_DECORATIONS_IDS = {}
for k,temp_data in pairs(TUNING.FWD_IN_PDT_DECORATIONS) do
    TUNING.FWD_IN_PDT_DECORATIONS_IDS[temp_data.id or tostring(temp_data.bank)..tostring(temp_data.build)..tostring(temp_data.anim)] = temp_data
end
