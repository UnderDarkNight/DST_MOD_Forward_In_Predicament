-- require "prefabutil"
-- require "maputil"
-- require "vecutil"
-- require "datagrid"
-- require("worldsettingsutil")
local moduless_name = {
    ["achievements"] = true,
    ["actions"] = true,
    ["beefalo_clothing"] = true,
    ["behaviourtree"] = true,
    ["brain"] = true,
    ["bufferedaction"] = true,
    ["builtinusercommands"] = true,
    ["camerashake"] = true,
    ["clothing"] = true,
    ["characterutil"] = true,
    ["chathistory"] = true,
    ["componentactions"] = true,
    ["componentutil"] = true,
    ["config"] = true,
    ["consolecommands"] = true,
    ["consolescreensettings"] = true,
    ["constants"] = true,
    ["containers"] = true,
    ["cookbookdata"] = true,
    ["cooking"] = true,
    ["crafting_sorting"] = true,
    ["craftingmenuprofile"] = true,
    -- ["createstringspo"] = true,
    -- ["createstringspo_dlc"] = true,
    ["curse_monkey_util"] = true,
    ["custompresets"] = true,
    ["datagrid"] = true,
    ["debugcommands"] = true,
    ["debughelpers"] = true,
    ["debugkeys"] = true,
    ["debugmenu"] = true,
    ["debugprint"] = true,
    ["debugsounds"] = true,
    ["debugtools"] = true,
    -- ["dlcsupport"] = true,
    -- ["dlcsupport_strings"] = true,
    -- ["dlcsupport_worldgen"] = true,
    ["dumper"] = true,
    ["easing"] = true,
    ["emitters"] = true,
    ["emoji_items"] = true,
    ["emote_items"] = true,
    ["emotes"] = true,
    ["entityreplica"] = true,
    ["entityscript"] = true,
    ["equipslotutil"] = true,
    ["eventachievements"] = true,
    ["events"] = true,
    ["falloffdefs"] = true,
    ["fileutil"] = true,
    ["firelevel"] = true,
    -- ["fix_character_strings"] = true,
    ["fonthelper"] = true,
    ["fonts"] = true,
    ["frontend"] = true,
    ["fx"] = true,
    -- ["gamelogic"] = true,
    -- ["gamemodes"] = true,
    ["generickv"] = true,
    ["giantutils"] = true,
    ["globalvariableoverrides"] = true,
    ["globalvariableoverrides_clean"] = true,
    ["globalvariableoverrides_monkey"] = true,
    ["globalvariableoverrides_pax_server"] = true,
    ["groundcreepdefs"] = true,
    ["guitartab_dsmaintheme"] = true,
    ["input"] = true,
    ["inspect"] = true,
    ["item_blacklist"] = true,
    ["json"] = true,
    ["klump"] = true,
    ["klump_files"] = true,
    ["knownerrors"] = true,
    -- ["lavaarena_achievement_quest_defs"] = true,
    -- ["lavaarena_achievements"] = true,
    -- ["lavaarena_communityprogression"] = true,
    ["lighting"] = true,
    ["loadingtipsdata"] = true,
    -- ["main"] = true,
    ["mainfunctions"] = true,
    ["maputil"] = true,
    ["mathutil"] = true,
    ["messagebottletreasures"] = true,
    ["metaclass"] = true,
    ["misc_items"] = true,
    ["mixer"] = true,
    ["mixes"] = true,
    ["modcompatability"] = true,
    ["modindex"] = true,
    ["mods"] = true,
    ["modutil"] = true,
    ["motdmanager"] = true,
    ["netvars"] = true,
    ["networkclientrpc"] = true,
    ["networking"] = true,
    ["noisetilefunctions"] = true,
    ["notetable_dsmaintheme"] = true,
    ["ocean_util"] = true,
    ["perfutil"] = true,
    ["physics"] = true,
    ["plantregistrydata"] = true,
    ["platformpostload"] = true,
    ["play_commonfn"] = true,
    ["play_generalscripts"] = true,
    ["play_the_doll"] = true,
    ["playerdeaths"] = true,
    ["playerhistory"] = true,
    ["playerprofile"] = true,
    ["popupmanager"] = true,
    -- ["postprocesseffects"] = true,
    ["prefablist"] = true,
    ["prefabs"] = true,
    ["prefabskin"] = true,
    ["prefabskins"] = true,
    ["prefabswaps"] = true,
    ["prefabutil"] = true,
    ["preloadsounds"] = true,
    ["preparedfoods"] = true,
    ["preparedfoods_warly"] = true,
    ["preparednonfoods"] = true,
    ["profiler"] = true,
    ["progressionconstants"] = true,
    ["quagmire_achievements"] = true,
    ["quagmire_recipebook"] = true,
    ["recipe"] = true,
    ["recipes"] = true,
    ["recipes_filter"] = true,
    ["regrowthutil"] = true,
    ["reload"] = true,
    ["savefileupgrades"] = true,
    ["saveindex"] = true,
    ["scheduler"] = true,
    ["scrapbook_prefabs"] = true,
    ["scrapbookpartitions"] = true,
    ["serverpreferences"] = true,
    ["shadeeffects"] = true,
    ["shardindex"] = true,
    ["shardnetworking"] = true,
    ["shardsaveindex"] = true,
    ["signgenerator"] = true,
    ["simutil"] = true,
    ["skilltreedata"] = true,
    ["skin_affinity_info"] = true,
    ["skin_assets"] = true,
    ["skin_gifts"] = true,
    ["skin_set_info"] = true,
    ["skin_strings"] = true,
    ["skins_defs_data"] = true,
    ["skinsfiltersutils"] = true,
    ["skinstradeutils"] = true,
    ["skinsutils"] = true,
    ["spicedfoods"] = true,
    ["splitscreenutils_pc"] = true,
    ["stacktrace"] = true,
    ["standardcomponents"] = true,
    ["stategraph"] = true,
    ["stats"] = true,
    ["strict"] = true,
    ["strings"] = true,
    ["strings_pretranslated"] = true,
    ["stringutil"] = true,
    ["techtree"] = true,
    ["tiledefs"] = true,
    ["tilegroups"] = true,
    ["tilemanager"] = true,
    ["trade_recipes"] = true,
    ["translator"] = true,
    ["traps"] = true,
    ["tuning"] = true,
    ["tuning_override"] = true,
    ["update"] = true,
    ["upsell"] = true,
    ["usercommands"] = true,
    ["util"] = true,
    ["vec3util"] = true,
    ["vector3"] = true,
    ["vecutil"] = true,
    ["voteutil"] = true,
    ["wintersfeastcookedfoods"] = true,
    ["wordfilter"] = true,
    ["worldentities"] = true,
    -- ["worldgen_main"] = true,
    ["worldsettings_overrides"] = true,
    ["worldsettingsutil"] = true,
    ["worldtiledefs"] = true,
    ["writeables"] = true,
    ["wx78_moduledefs"] = true,
    ["wxputils"] = true,
    ["yotb_costumes"] = true,
    ["yotb_sewing"] = true,

    ["prefabs/veggies"] = true,
}
for k, v in pairs(moduless_name) do
    -- local ret = pcall(function()
        
    -- end)
    -- if not ret then
    --     print("require error with",k)
    -- end
    -- print("info 6666",k)
    require(k)
end