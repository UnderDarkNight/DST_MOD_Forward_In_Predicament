------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 指定 图标文件夹的路径，同时hook 函数 给 UI调用
--- tex 的尺寸为 90 x 90 pix
--- 动画由于受到多个因素干扰，设置缩放倍数进行整体调整。
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


if Assets == nil then
    Assets = {}
end

TUNING["Forward_In_Predicament.Chat_Message_Icons"] = TUNING["Forward_In_Predicament.Chat_Message_Icons"] or {}

-- local temp_assets = {
-- 	Asset("IMAGE", "images/chat_message_icons/fwd_in_pdt_chat_message_icon_test.tex"),
-- 	Asset("ATLAS", "images/chat_message_icons/fwd_in_pdt_chat_message_icon_test.xml"),
-- }

-- for k, v in pairs(temp_assets) do
--     table.insert(Assets,v)
-- end

---------- 指定的文件夹和路径，index 为文件名，table 内为 fx 对应的动画参数。
local icon_files_data = {
    
    ["fwd_in_pdt_chat_message_icon_test"] = {
        addr = "images/chat_message_icons/",        ---- 部分地方需要完整的路径，部分不需要，拆开容易进行区别处理。
        atlas = "fwd_in_pdt_chat_message_icon_test.xml",  ---- 切片文件名
        image = "fwd_in_pdt_chat_message_icon_test.tex",  ---- 图片文件名
        scale = nil,                                ---- 图标自定义缩放，避免一棍子打死。默认0.25
        fx = {
            bank = "inventory_fx_shadow",
            build = "inventory_fx_shadow",
            anim = "idle",
            colour = {255/255,0,0},                 ---- 动画的颜色
            scale = 0.3,                            ---- 动画的缩放
            shader = "shaders/anim.ksh",           ---- 动画光效纹理 AnimState:SetBloomEffectHandle 用的
        }
    },



}

for temp_file_name,temp_data  in pairs(icon_files_data) do

    -- if type(temp_file_name) == "string" and type(temp_data) == "table" then

    table.insert(Assets ,  Asset("IMAGE", temp_data.addr .. temp_data.image )    )      --- 完整的路径
    table.insert(Assets ,  Asset("ATLAS", temp_data.addr .. temp_data.atlas)     )      --- 完整的路径

    TUNING["Forward_In_Predicament.Chat_Message_Icons"][temp_file_name] = { 
        atlas = temp_data.addr .. temp_data.atlas ,     ---- 要完整的路径
        image = temp_data.image ,                       ---- 只需要 tex 的名字
        fx = temp_data.fx
    }
    

end



-----------------------------------------------------------------------------------------------------------------------
---- 设置参数拦截。   ChatTypes.Message     才用得上这条函数。
---- 有特殊图标背景，得想办法去掉。
-- if TUNING["Forward_In_Predicament.Config"].UI_FX ~= true then
--     return
-- end

rawset(_G,"GetProfileFlairAtlasAndTex__old_fwd_in_pdt",rawget(_G,"GetProfileFlairAtlasAndTex"))
rawset(_G, "GetProfileFlairAtlasAndTex", function(item_key)
    -- print("info : GetProfileFlairAtlasAndTex",item_key)
    if TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(item_key)] ~= nil then
        local atlas = TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(item_key)].atlas
        local image = TUNING["Forward_In_Predicament.Chat_Message_Icons"][tostring(item_key)].image
        return atlas,image
    else
        return GetProfileFlairAtlasAndTex__old_fwd_in_pdt(item_key)
    end
end)
-----------------------------------------------------------------------------------------------------------------------
