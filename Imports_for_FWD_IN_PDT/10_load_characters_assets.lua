------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色相关的 素材文件
------------------------------------------------------------------------------------------------------------------------------------------------------

if not TUNING["Forward_In_Predicament.Config"].ALLOW_CHARACTERS then
    return
end


if Assets == nil then
    Assets = {}
end

local temp_assets = {


	---------------------------------------------------------------------------
        Asset( "IMAGE", "images/saveslot_portraits/fwd_in_pdt_carl.tex" ), --存档图片
        Asset( "ATLAS", "images/saveslot_portraits/fwd_in_pdt_carl.xml" ),

        Asset( "IMAGE", "bigportraits/fwd_in_pdt_carl.tex" ), --人物大图（方形的那个）
        Asset( "ATLAS", "bigportraits/fwd_in_pdt_carl.xml" ),

        Asset( "IMAGE", "bigportraits/fwd_in_pdt_carl_none.tex" ),  --人物大图（椭圆的那个）
        Asset( "ATLAS", "bigportraits/fwd_in_pdt_carl_none.xml" ),
        
        Asset( "IMAGE", "images/map_icons/fwd_in_pdt_carl.tex" ), --小地图
        Asset( "ATLAS", "images/map_icons/fwd_in_pdt_carl.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_fwd_in_pdt_carl.tex" ), --tab键人物列表显示的头像  --- 直接用小地图那张就行了
        Asset( "ATLAS", "images/avatars/avatar_fwd_in_pdt_carl.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_ghost_fwd_in_pdt_carl.tex" ),--tab键人物列表显示的头像（死亡）
        Asset( "ATLAS", "images/avatars/avatar_ghost_fwd_in_pdt_carl.xml" ),
        
        Asset( "IMAGE", "images/avatars/self_inspect_fwd_in_pdt_carl.tex" ), --人物检查按钮的图片
        Asset( "ATLAS", "images/avatars/self_inspect_fwd_in_pdt_carl.xml" ),
        
        Asset( "IMAGE", "images/names_fwd_in_pdt_carl.tex" ),  --人物名字
        Asset( "ATLAS", "images/names_fwd_in_pdt_carl.xml" ),
        
        Asset("ANIM", "anim/fwd_in_pdt_carl.zip"),              --- 人物动画文件
        Asset("ANIM", "anim/ghost_fwd_in_pdt_carl_build.zip"),  --- 灵魂状态动画文件


        Asset("ANIM", "anim/fwd_in_pdt_carl_spell_bar.zip"),  --- 角色技能指示条
        Asset("ANIM", "anim/fwd_in_pdt_drawing_carl_spell_a.zip"),  --- 技能立绘
	---------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

