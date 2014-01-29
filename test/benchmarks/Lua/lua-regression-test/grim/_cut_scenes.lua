CheckFirstTime("_cut_scenes.lua")
dofile("ve_talk_to_membrillo.lua")
dofile("membrillo_talk_to_ve.lua")
dofile("tm_IDPHOTO.lua")
dofile("ma_IDPHOTO.lua")
dofile("nv_IDPHOTO.lua")
dofile("cc_getcard.lua")
dofile("mc_getcard.lua")
RunFullscreenMovie = function(arg1) -- line 18
    local local1
    music_state:pause()
    local1 = StartFullscreenMovie(arg1)
    if local1 then
        while IsFullscreenMoviePlaying() do
            break_here()
        end
    end
    music_state:unpause()
    return local1
end
cut_scene = { }
