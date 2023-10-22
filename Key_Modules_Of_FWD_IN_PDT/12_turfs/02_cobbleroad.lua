------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 猪镇石砖地面移植
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end
local temp_assets = {
    -- 被挖起来的地皮物品动画
        Asset("ANIM", "anim/fwd_in_pdt_turf_cobbleroad.zip"), 
    -- 物品栏贴图
        Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_turf_cobbleroad.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_turf_cobbleroad.xml" ),
    -- 地皮贴图
        Asset( "IMAGE", "levels/textures/fwd_in_pdt_turf_cobbleroad.tex" ),
        Asset( "IMAGE", "levels/textures/fwd_in_pdt_turf_cobbleroad_mini.tex" ),
    -- 地皮边缘遮罩
        Asset( "IMAGE", "levels/tiles/fwd_in_pdt_stoneroad.tex" ),
        Asset( "IMAGE", "levels/tiles/fwd_in_pdt_stoneroad.tex" ),

}
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------ 注册一下这个表。使用官方的分类
local TileRanges =
{
    LAND = "LAND",
    NOISE = "NOISE",
    OCEAN = "OCEAN",
    IMPASSABLE = "IMPASSABLE",
}

local turf_name = "fwd_in_pdt_turf_cobbleroad"

AddTile(
    string.upper(turf_name),                                             --- tile_name       地皮名称【官方都是大写的】【注意】建议全局唯一
    TileRanges.LAND,                                             --- tile_range 归属【范畴】（ 不是距离！！） ，官方地上的地皮都是使用 TileRanges.LAND 。其他可选 LAND  NOISE OCEAN  IMPASSABLE
    {ground_name = turf_name},                              --- tile_data 。【注意】ground_name 必须全局唯一，如果和已有的冲突，则会覆盖已有的（包括官方的）
    {                                                            --- ground_tile_def    应该是游戏场景内地皮相关的参数
        name="fwd_in_pdt_stoneroad",                                                  --- 地毯遮罩类型   resolvefilepath("levels/tiles/"..trimmed_name, true)
        noise_texture = turf_name,                      --- 地毯花纹，1024x1024 像素.【注意】没有“.tex”后缀。  resolvefilepath("levels/textures/"..trimmed_name, true)
        runsound="dontstarve/movement/run_dirt",                --- 跑在上面的声音
        walksound="dontstarve/movement/walk_dirt",               --- 走在上面的声音
        snowsound="dontstarve/movement/run_ice",                        --- 积雪覆盖后在上面行走的声音
        mudsound="dontstarve/movement/run_mud",                         --- 用途未知
        
                    -- 以下4个参数用途未能测试出来，建议根据官方地图参考配置。在 tiledefs.lua 里找
        flooring = true,                                                --- 未知参数。地板铺装？
        hard = true,                                                    --- 未知参数
                    -- roadways = true，                                               --- 未知参数
                    -- cannotbedug = true,                                             --- 未知参数，推测是不能挖起来

    },
    {                                                            --- minimap_tile_def  应该是游戏地图上地皮相关参数
        name="map_edge",                                                --- 用途未知
        noise_texture = turf_name.."_mini",                               --- 用途未知，256x256 像素。推测是在小地图上显示使用的。【注意】没有“.tex”后缀
    },
    {                                                            --- turf_def    自动生成prefab 用的参数 turfs.lua 里调取用的
        name = turf_name,                                         --- 地皮prefab名称，最终会生成 turf_XXXXXX 名字的 prefab
        anim = "monkey_ground",                                         --- PlayAnimation 使用，通常为 idle
        bank_build = "turf_monkey_ground",                              --- bank build 同名字的时候用这个参数
        -- bank_override = "",                                             --- bank build 不同名的时候使用
        -- build_override = "",                                            --- bank build 不同名的时候使用
        pickupsound = "rock",                                          --- 拾取玩家该地皮的声音，可选参考在 tiledefs.lua
                                                                        --- 【注意】没有 inventoryitem 的参数渠道。要么 外部注册 turf_XXXXXX 的图片名，要么使用其他手段注册图片。
    }
)

AddPrefabPostInit(
    "turf_"..turf_name,
    function(inst)
        -- inst.AnimState:SetBank("fwd_in_pdt_turf_snakeskin")
        -- inst.AnimState:SetBuild("fwd_in_pdt_turf_snakeskin")
        -- inst.AnimState:PlayAnimation("idle",true)
        inst.AnimState:SetBank(turf_name)
        inst.AnimState:SetBuild(turf_name)
        inst.AnimState:PlayAnimation("idle",true)        
        if not TheWorld.ismastersim then
            return
        end
        local num = math.random(7)
        inst.AnimState:OverrideSymbol("arrow_0",turf_name,"arrow_"..tostring(num))

        -- inst.components.inventoryitem.imagename = "fwd_in_pdt_turf_snakeskin"  -- tex 的名字。不带  .tex 后缀
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_turf_snakeskin.xml"     --- xml 的完整路径，带 .xml 后缀
        inst.components.inventoryitem.imagename = turf_name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/".. turf_name ..".xml"

    end)
