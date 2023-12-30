return {
    ---------------------------------------------
    --- prefab白名单
        prefab_whitelist = {   
            -- ["log"] = true,
        },
    ---------------------------------------------
    --- prefab黑名单
        prefab_blacklist = {
            ["multiplayer_portal"] = true,      --- 绚丽之门
        },
    ---------------------------------------------
    --- tags 黑名单
        tags_blacklist = {
            "irreplaceable",    --- 不可替代 （ 如切斯特骨眼 ）,离开当前世界会自动掉落
            "nosteal",          --- 不可被偷取
            "player",

        },
    ---------------------------------------------
    --- components 黑名单  带这个组件的东西都不允许
        components_blacklist = {
            ["inventoryitem"] = true ,      --- 所有可拾取物品
            ["health"] = true,              --- 带血槽的
            ["worldmigrator"] = true,       --- 洞穴出入口
        }
    ---------------------------------------------
}