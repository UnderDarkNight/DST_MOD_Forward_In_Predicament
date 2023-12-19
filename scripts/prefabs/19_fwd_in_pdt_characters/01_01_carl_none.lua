-- local assets =
-- {
-- 	Asset( "ANIM", "anim/esctemplate.zip" ),
-- 	Asset( "ANIM", "anim/ghost_esctemplate_build.zip" ),
-- }

-- local skins =
-- {
-- 	normal_skin = "esctemplate",
-- 	ghost_skin = "ghost_esctemplate_build",
-- }

-- local base_prefab = "esctemplate"

-- local tags = {"BASE" ,"ESCTEMPLATE", "CHARACTER"}

-- return CreatePrefabSkin("esctemplate_none",
-- {
-- 	base_prefab = base_prefab, 
-- 	skins = skins, 
-- 	assets = assets,
-- 	skin_tags = tags,
	
-- 	build_name_override = "esctemplate",
-- 	rarity = "Character",
-- })

local assets =
{
	Asset( "ANIM", "anim/fwd_in_pdt_carl.zip" ),
	Asset( "ANIM", "anim/fwd_in_pdt_carl_skin_flame.zip" ),
	Asset( "ANIM", "anim/ghost_fwd_in_pdt_carl_build.zip" ),
}
local skin_fns = {

	-----------------------------------------------------
		CreatePrefabSkin("fwd_in_pdt_carl_none",{
			base_prefab = "fwd_in_pdt_carl",			---- 角色prefab
			skins = {
					normal_skin = "fwd_in_pdt_carl",					--- 正常外观
					ghost_skin = "ghost_fwd_in_pdt_carl_build",			--- 幽灵外观
			}, 								
			assets = assets,
			skin_tags = {"BASE" ,"FWD_IN_PDT_CARL", "CHARACTER"},		--- 皮肤对应的tag
			
			build_name_override = "fwd_in_pdt_carl",
			rarity = "Character",
		}),
	-----------------------------------------------------
	-----------------------------------------------------
		CreatePrefabSkin("fwd_in_pdt_carl_skin_flame",{
			base_prefab = "fwd_in_pdt_carl",			---- 角色prefab
			skins = {
					normal_skin = "fwd_in_pdt_carl_skin_flame", 		--- 正常外观
					ghost_skin = "ghost_fwd_in_pdt_carl_build",			--- 幽灵外观
			}, 								
			assets = assets,
			skin_tags = {"BASE" ,"FWD_IN_PDT_CARL", "CHARACTER"},		--- 皮肤对应的tag
			
			build_name_override = "fwd_in_pdt_carl",
			rarity = "Character",
		}),
	-----------------------------------------------------

}

return unpack(skin_fns)