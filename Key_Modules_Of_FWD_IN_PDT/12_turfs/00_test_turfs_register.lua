--[[
    【笔记】
    测试地皮的添加
    【贴图相关】
        【注意】地皮贴图的 1024x1024 像素尺寸，是  8x8 地皮格子的尺寸！！！！不是单个地皮！！！！
        【注意】地皮贴图的 1024x1024 像素尺寸，是  8x8 地皮格子的尺寸！！！！不是单个地皮！！！！
        【注意】地皮贴图的 1024x1024 像素尺寸，是  8x8 地皮格子的尺寸！！！！不是单个地皮！！！！
        【制作方法】【PS快速制作四方连续无缝贴图江湖秘技】 https://www.bilibili.com/video/BV1HM4y1w7pY/?share_source=copy_web&vd_source=95ce5ab9b877c6afeb9776e7d5cbffa9

        贴图格式为 DTX1 。不要勾选透明度。

        贴图尺寸官方的相关记录里有 512x512 的存在。DXT5也存在。可以尝试使用 128x128作为单块地皮导入

    tilemanager.lua     添加地皮的核心API
    tiledefs.lua        新版所有地皮的相关参数，包括走在上面的声音 等等
    turfs.lua           生成玩家使用的铺地道具prefab

    【注意】不要随便使用 TileManager 。这东西有安全锁。
    
    自制地皮序号相关：
        print(WORLD_TILES[string.upper("fwd_in_pdt_turf_test")]) 
        获取自制地皮的自动分配的 ID 。用于岛屿地图创建的时候，调取到自己做的地皮序号

    地皮添加API 相关：
        
        local function AddTile(tile_name, tile_range, tile_data, ground_tile_def, minimap_tile_def, turf_def)        

        AddTile(
            "MONKEY_GROUND",                                             --- tile_name       地皮名称【官方都是大写的】
            TileRanges.LAND,                                             --- tile_range 归属【范畴】（ 不是距离！！） ，官方地上的地皮都是使用 TileRanges.LAND 。其他可选 LAND  NOISE OCEAN  IMPASSABLE
            {ground_name = "Pirate Beach"},                              --- tile_data 。【注意】ground_name 必须全局唯一，如果和已有的冲突，则会覆盖已有的（包括官方的）
            {                                                            --- ground_tile_def    应该是游戏场景内地皮相关的参数
                name="cave",                                                    --- 地毯遮罩类型
                                                                                -- blocky                   示例 ： turf_cotl_brick     砖地板
                                                                                -- carpet                   示例 ： turf_carpetfloor    牛毛地毯  。  浮在所有地毯之上，自带外围线边。典型 ： turf_carpetfloor
                                                                                -- cave                     示例 ： turf_monkey_ground  月亮码头海滩地皮
                                                                                -- cobblestone              示例 ： turf_road           卵石路
                                                                                -- deciduous                示例 ： turf_deciduous      落叶林地皮
                                                                                -- desert_dirt              示例 ： turf_desertdirt     沙漠地皮
                                                                                -- dirt                         空地皮，地面挖空后留下的那一层
                                                                                -- dock_falloff                 无法用做地皮，官方暴食、熔炉的辅助地图遮罩
                                                                                -- falloff                      无法用做地皮，官方暴食、熔炉的辅助地图遮罩
                                                                                -- farmsoil                     无法用做地皮，农田完成之后的图片覆盖
                                                                                -- forest                   示例 ： turf_forest         森林地皮
                                                                                -- grass                    示例 ： turf_grass          长草地皮
                                                                                -- grass2                       暴食活动使用的地皮
                                                                                -- grass3                       暴食活动使用的地皮
                                                                                -- lavaarena_falloff            无法使用，熔炉活动的
                                                                                -- lavaarena_floor_ms           无法使用，熔炉活动的
                                                                                -- lavaarena_trim_ms            无法使用，熔炉活动的
                                                                                -- map_edge                     未知，推测和地图边缘有关
                                                                                -- marsh                    示例 ： turf_marsh          沼泽地皮
                                                                                -- meteor                   示例 ： turf_meteor         月球环形山地皮
                                                                                -- rocky                    示例 ： turf_rocky          岩石地皮
                                                                                -- walls                        无法使用，推测是洞穴里的墙壁废稿
                                                                                -- web                          未知用途
                                                                                -- yellowgrass              示例 :  turf_savanna        热带草原地皮

                noise_texture="ground_noise_monkeyisland",                      --- 地毯纹理，1024x1024 像素 DTX1.【注意】没有“.tex”后缀。 【mod根目录\levels\textures】里面。不需要 xml 文件
                runsound="turnoftides/movement/run_pebblebeach",                --- 跑在上面的声音
                walksound="turnoftides/movement/run_pebblebeach",               --- 走在上面的声音
                snowsound="dontstarve/movement/run_ice",                        --- 积雪覆盖后在上面行走的声音
                mudsound="dontstarve/movement/run_mud",                         --- 用途未知
                    -- 以下4个参数用途未能测试出来，建议根据官方地图参考配置。在 tiledefs.lua 里找
                    -- flooring = true,                                                --- 未知参数。地板铺装？
                    -- hard = true,                                                    --- 未知参数
                    -- roadways = true，                                               --- 未知参数
                    -- cannotbedug = true,                                             --- 未知参数，推测是不能挖起来
            },
            {                                                            --- minimap_tile_def  应该是小游戏地图上地皮相关参数
                name="map_edge",                                                --- 用途未知
                noise_texture="mini_pebblebeach",                               --- 用途未知，256x256 像素 DTX1。推测是在小地图上显示使用的。【注意】没有“.tex”后缀 。【mod根目录\levels\textures】里面。不需要 xml 文件
            },
            {                                                            --- turf_def    自动生成prefab 用的参数 turfs.lua 里调取用的
                name = "monkey_ground",                                         --- 地皮prefab名称，最终会生成 turf_XXXXXX 名字的prefab
                anim = "monkey_ground",                                         --- PlayAnimation 使用，通常为 idle
                bank_build = "turf_monkey_ground",                              --- bank build 同名字的时候用这个参数
                bank_override = "",                                             --- bank build 不同名的时候使用
                build_override = "",                                            --- bank build 不同名的时候使用
                pickupsound = "grainy",                                         --- 拾取玩家该地皮的声音，可选参考在 tiledefs.lua
                                                                                --- 【注意】没有 inventoryitem 的参数渠道。要么 外部注册 turf_XXXXXX 的图片名，要不使用其他手段注册图片
            }
        )


    【遮罩贴图自制】
        【mod根目录\levels\tiles】
        略 ： 官方的足够了，没有特别必要的自己创建一套。
        非要自制的，注意参考官方对应目录的文件。同时注意注册 tex 和 xml



]]--
if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
    return
end

------ 注册一下这个表。使用官方的分类
local TileRanges =
{
    LAND = "LAND",
    NOISE = "NOISE",
    OCEAN = "OCEAN",
    IMPASSABLE = "IMPASSABLE",
}

AddTile(
    string.upper("fwd_in_pdt_turf_test"),                                             --- tile_name       地皮名称【官方都是大写的】【注意】建议全局唯一
    TileRanges.LAND,                                             --- tile_range 归属【范畴】（ 不是距离！！） ，官方地上的地皮都是使用 TileRanges.LAND 。其他可选 LAND  NOISE OCEAN  IMPASSABLE
    {ground_name = "fwd_in_pdt_turf_test"},                              --- tile_data 。【注意】ground_name 必须全局唯一，如果和已有的冲突，则会覆盖已有的（包括官方的）
    {                                                            --- ground_tile_def    应该是游戏场景内地皮相关的参数
        name="carpet",                                                  --- 地毯遮罩类型   resolvefilepath("levels/tiles/"..trimmed_name, true)
                                                                                -- blocky                   示例 ： turf_cotl_brick     砖地板
                                                                                -- carpet                   示例 ： turf_carpetfloor    牛毛地毯  。  浮在所有地毯之上，自带外围线边。典型 ： turf_carpetfloor
                                                                                -- cave                     示例 ： turf_monkey_ground  月亮码头海滩地皮
                                                                                -- cobblestone              示例 ： turf_road           卵石路
                                                                                -- deciduous                示例 ： turf_deciduous      落叶林地皮
                                                                                -- desert_dirt              示例 ： turf_desertdirt     沙漠地皮
                                                                                -- dirt                         空地皮，地面挖空后留下的那一层
                                                                                -- dock_falloff                 无法用做地皮，官方暴食、熔炉的辅助地图遮罩
                                                                                -- falloff                      无法用做地皮，官方暴食、熔炉的辅助地图遮罩
                                                                                -- farmsoil                     无法用做地皮，农田完成之后的图片覆盖
                                                                                -- forest                   示例 ： turf_forest         森林地皮
                                                                                -- grass                    示例 ： turf_grass          长草地皮
                                                                                -- grass2                       暴食活动使用的地皮
                                                                                -- grass3                       暴食活动使用的地皮
                                                                                -- lavaarena_falloff            无法使用，熔炉活动的
                                                                                -- lavaarena_floor_ms           无法使用，熔炉活动的
                                                                                -- lavaarena_trim_ms            无法使用，熔炉活动的
                                                                                -- map_edge                     未知，推测和地图边缘有关
                                                                                -- marsh                    示例 ： turf_marsh          沼泽地皮
                                                                                -- meteor                   示例 ： turf_meteor         月球环形山地皮
                                                                                -- rocky                    示例 ： turf_rocky          岩石地皮
                                                                                -- walls                        无法使用，推测是洞穴里的墙壁废稿
                                                                                -- web                          未知用途
                                                                                -- yellowgrass              示例 :  turf_savanna        热带草原地皮

        noise_texture="fwd_in_pdt_turf_test",                      --- 地毯花纹，1024x1024 像素.【注意】没有“.tex”后缀。  resolvefilepath("levels/textures/"..trimmed_name, true)
        runsound="turnoftides/movement/run_pebblebeach",                --- 跑在上面的声音
        walksound="turnoftides/movement/run_pebblebeach",               --- 走在上面的声音
        snowsound="dontstarve/movement/run_ice",                        --- 积雪覆盖后在上面行走的声音
        mudsound="dontstarve/movement/run_mud",                         --- 用途未知
        
                    -- 以下4个参数用途未能测试出来，建议根据官方地图参考配置。在 tiledefs.lua 里找
                    -- flooring = true,                                                --- 未知参数。地板铺装？
                    -- hard = true,                                                    --- 未知参数
                    -- roadways = true，                                               --- 未知参数
                    -- cannotbedug = true,                                             --- 未知参数，推测是不能挖起来

    },
    {                                                            --- minimap_tile_def  应该是游戏地图上地皮相关参数
        name="map_edge",                                                --- 用途未知
        noise_texture="mini_pebblebeach",                               --- 用途未知，256x256 像素。推测是在小地图上显示使用的。【注意】没有“.tex”后缀
    },
    {                                                            --- turf_def    自动生成prefab 用的参数 turfs.lua 里调取用的
        name = "fwd_in_pdt_turf_test",                                         --- 地皮prefab名称，最终会生成 turf_XXXXXX 名字的 prefab
        anim = "monkey_ground",                                         --- PlayAnimation 使用，通常为 idle
        bank_build = "turf_monkey_ground",                              --- bank build 同名字的时候用这个参数
        -- bank_override = "",                                             --- bank build 不同名的时候使用
        -- build_override = "",                                            --- bank build 不同名的时候使用
        pickupsound = "grainy",                                         --- 拾取玩家该地皮的声音，可选参考在 tiledefs.lua
                                                                        --- 【注意】没有 inventoryitem 的参数渠道。要么 外部注册 turf_XXXXXX 的图片名，要么使用其他手段注册图片。
    }
)
