CheckFirstTime("_music.lua")
dofile("muscript.lua")
FIRST_YEAR1_STATE = 1001
FIRST_YEAR2_STATE = 1100
FIRST_YEAR3_STATE = 1201
FIRST_YEAR4_STATE = 1301
music_state = { }
music_state.current_bundle = nil
music_state.cur_state = STATE_NULL
music_state.set_year = function(arg1, arg2) -- line 31
end
music_state.update = function(arg1, arg2) -- line 60
    local local1
    local local2
    local local3, local4
    if not arg2 then
        arg2 = system.currentSet
    end
    local1 = arg2.setFile
    local3 = arg2:update_music_state()
    if not local3 then
        local2 = strfind(local1, ".set")
        if local2 then
            local1 = strsub(local1, 1, local2 - 1)
        end
        local4 = "state" .. strupper(local1)
        local3 = getglobal(local4)
        if local3 then
            PrintDebug("(music_state:update) Setting music state to '" .. local4 .. "' (" .. local3 .. ")\n")
        else
            PrintDebug("(music_state:update) Music state '" .. local4 .. "' doesn't exist!\n")
        end
    end
    arg1:set_state(local3)
end
music_state.set_sequence = function(arg1, arg2) -- line 100
    if arg2 then
        ImSetSequence(arg2)
    end
end
music_state.set_state = function(arg1, arg2) -- line 112
    if arg2 then
        if arg2 >= FIRST_YEAR1_STATE and arg2 < FIRST_YEAR2_STATE then
            arg1:set_year(1)
        elseif arg2 >= FIRST_YEAR2_STATE and arg2 < FIRST_YEAR3_STATE then
            arg1:set_year(2)
        elseif arg2 >= FIRST_YEAR3_STATE and arg2 < FIRST_YEAR4_STATE then
            arg1:set_year(3)
        elseif arg2 >= FIRST_YEAR4_STATE then
            arg1:set_year(4)
        end
        arg1.cur_state = arg2
        ImSetState(arg2)
    end
end
music_state.pause = function(arg1) -- line 134
    if not arg1.paused then
        arg1.paused = TRUE
        arg1.prev_state = arg1.cur_state
        ImSetState(STATE_NULL)
        arg1.original_sound_fx_vol = ReadRegistryValue("SfxVolume")
        if arg1.original_sound_fx_vol == nil then
            arg1.original_sound_fx_vol = 127
        end
        ImSetSfxVol(0)
    end
end
music_state.unpause = function(arg1) -- line 151
    if arg1.paused then
        arg1.paused = FALSE
        if arg1.original_sound_fx_vol then
            ImSetSfxVol(arg1.original_sound_fx_vol)
        else
            ImSetSfxVol(127)
        end
        if arg1.prev_state ~= nil and arg1.prev_state ~= STATE_NULL then
            ImSetState(arg1.prev_state)
            arg1.prev_state = nil
        end
    end
end
