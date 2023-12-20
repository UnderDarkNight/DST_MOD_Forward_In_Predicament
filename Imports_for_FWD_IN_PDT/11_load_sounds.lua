
if Assets == nil then
    Assets = {}
end

--------------------------------------------
---- fev 的声音集
    local fev_sound_files = {

        "dontstarve_DLC002.fev",        ---- 单纯有这个文件没用。得有对应的 fsb 文件。 fsb里面才是真正的声音。

        
    }
    for k, file_name in pairs(fev_sound_files) do
        if file_name then
            table.insert(Assets,        Asset("SOUNDPACKAGE", "sound/"..file_name)           )
        end
    end
--------------------------------------------

--------------------------------------------
---- fsb 的声音集
    local fsb_sound_files = {

        "dontstarve_shipwreckedSFX.fsb",    

    }
    for k, file_name in pairs(fsb_sound_files) do
        if file_name then
            table.insert(Assets,        Asset("SOUND", "sound/"..file_name)           )
        end
    end
--------------------------------------------

--- 预加载。来自 preloadsounds.lua 文件
PreloadSoundList(fev_sound_files)
PreloadSoundList(fsb_sound_files)


