CheckFirstTime("_sfx.lua")
IM_LOW_PRIORITY = 0
IM_MED_PRIORITY = 64
IM_HIGH_PRIORITY = 127
IM_GROUP_MASTER = 0
IM_GROUP_SFX = 1
IM_GROUP_VOICE = 2
IM_GROUP_MUSIC = 3
IM_GROUP_DIPPED_MUSIC = 4
IM_SOUND_PLAY_COUNT = 256
IM_SOUND_PEND_COUNT = 512
IM_SOUND_GROUP = 1024
IM_SOUND_PRIORITY = 1280
IM_SOUND_VOL = 1536
IM_SOUND_PAN = 1792
preload_sfx = function(arg1) -- line 45
    ImStartSound(arg1, 127, 0)
    ImStopSound(arg1)
end
start_sfx = function(arg1, arg2, arg3) -- line 56
    local local1
    if not arg2 then
        arg2 = IM_HIGH_PRIORITY
    end
    if not arg3 then
        arg3 = 127
    end
    local1 = ImStartSound(arg1, arg2, IM_GROUP_SFX)
    ImSetParam(local1, IM_SOUND_VOL, arg3)
    return local1
end
single_start_sfx = function(arg1, arg2, arg3) -- line 74
    local local1
    if ImGetParam(arg1, IM_SOUND_PLAY_COUNT) == 0 then
        local1 = start_sfx(arg1, arg2, arg3)
    end
    return local1
end
fade_sfx = function(arg1, arg2, arg3) -- line 89
    start_script(new_fade_sfx, arg1, arg2, arg3)
end
new_fade_sfx = function(arg1, arg2, arg3) -- line 93
    local local1 = 0
    local local2 = 0
    local local3 = 0
    local local4 = 0
    if not arg3 then
        arg3 = 0
    end
    if not arg2 then
        arg2 = 1000
    end
    local1 = ImGetParam(arg1, IM_SOUND_VOL)
    local2 = arg2 / 1000
    local3 = abs(local1 - arg3)
    local4 = local3 / local2
    if arg3 < local1 then
        repeat
            break_here()
            local1 = local1 - PerSecond(local4)
            if local1 < arg3 then
                local1 = arg3
            end
            ImSetParam(arg1, IM_SOUND_VOL, local1)
        until local1 == arg3 or sound_playing(arg1) == FALSE
    else
        repeat
            break_here()
            local1 = local1 + PerSecond(local4)
            if local1 > arg3 then
                local1 = arg3
            end
            ImSetParam(arg1, IM_SOUND_VOL, local1)
        until local1 == arg3 or sound_playing(arg1) == FALSE
    end
    if arg3 == 0 then
        stop_sound(arg1)
    end
end
fade_pan_sfx = function(arg1, arg2, arg3) -- line 145
    if not arg3 then
        arg3 = 64
    end
    if not arg2 then
        arg2 = 1000
    end
    ImFadeParam(arg1, IM_SOUND_PAN, arg3, arg2)
end
start_footstep_sfx = function(arg1, arg2) -- line 160
    if not arg2 then
        arg2 = IM_MED_PRIORITY
    end
    ImStartSound(arg1, arg2, IM_GROUP_SFX)
end
start_loop_sfx = function(arg1, arg2) -- line 172
    local local1
    if not arg2 then
        arg2 = IM_HIGH_PRIORITY
    end
    local1 = ImStartSound(arg1, arg2, IM_GROUP_SFX)
    return local1
end
sound_playing = function(arg1) -- line 185
    if ImGetParam(arg1, IM_SOUND_PLAY_COUNT) > 0 then
        return TRUE
    else
        return FALSE
    end
end
wait_for_sound = function(arg1) -- line 197
    while ImGetParam(arg1, IM_SOUND_PLAY_COUNT) > 0 do
        break_here()
    end
end
stop_sound = function(arg1) -- line 207
    ImStopSound(arg1)
end
set_vol = function(arg1, arg2) -- line 215
    ImSetParam(arg1, IM_SOUND_VOL, arg2)
end
set_pan = function(arg1, arg2) -- line 223
    if not arg2 then
        arg2 = 64
    end
    ImSetParam(arg1, IM_SOUND_PAN, arg2)
end
