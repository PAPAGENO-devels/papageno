TEXT_ONLY = 1
VOICE_ONLY = 2
VOICE_AND_TEXT = 3
DEFAULT_LOGO_X = 230
DEFAULT_LOGO_Y = 50
MAX_GAMMA = 1.5
MIN_GAMMA = 0.5
OptionsColor = MakeColor(230, 230, 100)
OptionsHighlightColor = Yellow
OptionsDarkColor = MakeColor(100, 100, 0)
OptionsMidColor = MakeColor(150, 150, 50)
OptionsDimHighlightColor = MakeColor(200, 200, 0)
OptionsDimDarkColor = MakeColor(50, 50, 0)
harddisksets = { }
harddisksets["suit_inv.set"] = "mo.set"
harddisksets["action_inv.set"] = "mo.set"
harddisksets["cafe_inv.set"] = "bi.set"
harddisksets["nautical_inv.set"] = "vd.set"
harddisksets["siberian_inv.set"] = "at.set"
harddisksets["death_inv.set"] = "at.set"
harddisksets["charlie_inv.set"] = "at.set"
harddisksets["pf.set"] = "bi.set"
CheckForCD = function(arg1, arg2, arg3) -- line 49
    local local1
    if harddisksets[arg1] then
        arg1 = harddisksets[arg1]
    end
    if not CheckForFile(arg1) then
        local1 = cd_swap:run(arg1, arg2, arg3)
        return local1, TRUE
    else
        return TRUE, FALSE
    end
end
cd_swap = { }
cd_swap.query = nil
cd_swap.critical_query = nil
cd_swap.is_active = FALSE
cd_swap.cancelled = FALSE
cd_swap.critical_save = FALSE
cd_swap.run = function(arg1, arg2, arg3, arg4) -- line 73
    local local1 = FALSE
    local local2 = FALSE
    if not arg1.is_active then
        arg1.is_active = TRUE
        if strfind(arg2, ".snm", 1, TRUE) then
            arg1.diskprompt = get_cd_prompt_for_snm(arg2)
        else
            arg1.diskprompt = get_cd_prompt_for_setfile(arg2)
        end
        if arg1.diskprompt == nil then
            PrintDebug("Ack!  No idea what CD " .. arg2 .. " is on! Help!\n")
        end
        arg1.caption = "/sytx230/"
        arg1.cancelled = FALSE
        arg1.query = query_mode:create(MODE_QUERY, ORIENTATION_HORIZ)
        arg1.query.caption = arg1.caption
        arg1.query.prompt = arg1.diskprompt
        arg1.query.choices[0] = { text = SAVELOAD_MENU_CONFIRM_OK, x = 260, y = 160 }
        arg1.query.choices[0].action_script = arg1.query_ok
        arg1.query.choices[0].action_table = arg1
        arg1.query.choices[1] = { text = SAVELOAD_MENU_CONFIRM_CANCEL, x = 380, y = 160 }
        arg1.query.choices[1].action_script = arg1.query_cancel
        arg1.query.choices[1].action_table = arg1
        arg1.critical_query = query_mode:create(MODE_QUERY, ORIENTATION_HORIZ)
        arg1.critical_query.caption = "/sytx226/"
        arg1.critical_query.prompt = "/sytx227/"
        arg1.critical_query.choices[0] = { text = "/sytx228/", x = 260, y = 160 }
        arg1.critical_query.choices[0].action_script = arg1.critical_query_save
        arg1.critical_query.choices[0].action_table = arg1
        arg1.critical_query.choices[1] = { text = "/sytx229/", x = 380, y = 160 }
        arg1.critical_query.choices[1].action_script = arg1.critical_query_quit
        arg1.critical_query.choices[1].action_table = arg1
        arg1.prev_button_handler = system.buttonHandler
        arg1.prev_paint_handler = system.userPaintHandler
        arg1.prev_character_handler = system.prevCharacterHandler
        game_pauser:pause(TRUE, arg1, arg1)
        system.characterHandler = arg1
        SetEmergencyFont("treb13bs.laf")
        DetachFromResources()
        CleanBuffer()
        Display()
        CleanBuffer()
        Display()
        arg1:draw()
        repeat
            arg1:do_query()
            if arg1.cancelled and arg3 then
                local2 = FALSE
                arg1:do_critical_query()
                if not arg1.critical_save then
                    exit_the_game()
                else
                    MakeCurrentSet(nil)
                    AttachToResources()
                    GetSystemFonts()
                    local2 = FALSE
                    JustLoaded()
                    critical_saveload_menu:run(SAVELOAD_MENU_SAVE_MODE)
                    repeat
                        break_here()
                    until not critical_saveload_menu.is_active
                    local1 = CheckForFile(arg2)
                    if not local1 and not JustLoaded() then
                        SetEmergencyFont(nil)
                        exit_the_game()
                    end
                end
            elseif not arg1.cancelled then
                AttachToResources()
                local1 = CheckForFile(arg2)
                if local1 then
                    local2 = TRUE
                else
                    ImSetState(0)
                    ImStopAllSounds()
                    DetachFromResources()
                end
            else
                AttachToResources()
                GetSystemFonts()
            end
        until local1 or arg1.cancelled
        SetEmergencyFont(nil)
        if local2 then
            GetSystemFonts()
        end
        if not arg4 then
            PrintDebug("calling game_pauser(FALSE) FROM CHECKFORCD!\n")
            game_pauser:pause(FALSE)
            system.characterHandler = nil
        else
            system.buttonHandler = arg1.prev_button_handler
            system.userPaintHandler = arg1.prev_paint_handler
            system.characterHandler = arg1.prev_character_handler
        end
        arg1.is_active = FALSE
        arg1.query:destroy()
        arg1.critical_query:destroy()
    end
    return local1
end
cd_swap.draw = function(arg1) -- line 215
    if arg1.is_active then
        CleanBuffer()
        Display()
    end
end
cd_swap.do_query = function(arg1, arg2, arg3) -- line 222
    arg1.cancelled = FALSE
    arg1.query.default_choice = 0
    arg1.query.overlay_menu = arg1
    arg1.is_active = FALSE
    CleanBuffer()
    Display()
    CleanBuffer()
    arg1.query:run()
    repeat
        break_here()
    until not arg1.query.is_active
    arg1.is_active = TRUE
    arg1:draw()
    return not arg1.cancelled
end
cd_swap.query_ok = function(arg1) -- line 245
    arg1.cancelled = FALSE
end
cd_swap.query_cancel = function(arg1) -- line 249
    arg1.cancelled = TRUE
end
cd_swap.do_critical_query = function(arg1) -- line 253
    arg1.critical_save = FALSE
    arg1.critical_quit = FALSE
    arg1.critical_query.default_choice = 0
    arg1.critical_query.overlay_menu = arg1
    arg1.is_active = FALSE
    CleanBuffer()
    Display()
    CleanBuffer()
    arg1.critical_query:run()
    repeat
        break_here()
    until not arg1.critical_query.is_active
    arg1.is_active = TRUE
    arg1:draw()
    return arg1.critical_save
end
cd_swap.critical_query_save = function(arg1) -- line 277
    arg1.critical_save = TRUE
end
cd_swap.critical_query_quit = function(arg1) -- line 281
    arg1.critical_save = FALSE
end
system_prefs = { }
system_prefs.gamma = 1
system_prefs.joystick_enabled = FALSE
system_prefs.voice_effects = FALSE
system_prefs.cur_voice_effect = nil
system_prefs.auto_run_enabled = TRUE
system_prefs.double_tap_enabled = TRUE
system_prefs.init = function(arg1) -- line 295
    local local1
    local1 = ReadRegistryValue("MusicVolume")
    if local1 then
        local1 = tonumber(local1)
        ImSetMusicVol(local1)
    else
        ImSetMusicVol(127)
    end
    local1 = ReadRegistryValue("SfxVolume")
    if local1 then
        local1 = tonumber(local1)
        ImSetSfxVol(local1)
    else
        ImSetSfxVol(127)
    end
    local1 = ReadRegistryValue("VoiceVolume")
    if local1 then
        local1 = tonumber(local1)
        ImSetVoiceVol(local1)
    else
        ImSetVoiceVol(127)
    end
    local1 = ReadRegistryValue("Gamma")
    if local1 then
        system_prefs.gamma = tonumber(local1)
    else
        system_prefs.gamma = 1
    end
    SetGamma(system_prefs.gamma)
    local1 = ReadRegistryValue("JoystickEnabled")
    if local1 == "FALSE" then
        system_prefs.joystick_enabled = FALSE
        enable_joystick_controls(FALSE)
    else
        system_prefs.joystick_enabled = TRUE
        enable_joystick_controls(TRUE)
    end
    local1 = ReadRegistryValue("TextMode")
    if local1 then
        SetSpeechMode(tonumber(local1))
    else
        SetSpeechMode(VOICE_ONLY)
    end
    local1 = ReadRegistryValue("TextSpeed")
    if local1 then
        SetTextSpeed(tonumber(local1))
    else
        SetTextSpeed(7)
    end
    local1 = ReadRegistryValue("Transcript")
    if local1 == "FALSE" then
        dialog_log:off()
    else
        dialog_log:on()
    end
    local1 = ReadRegistryValue("MovementMode")
    if local1 == "Camera" then
        MarioControl = TRUE
    else
        MarioControl = FALSE
    end
    local1 = ReadRegistryValue("VoiceEffects")
    if local1 == "FALSE" then
        system_prefs:toggle_voice_effects(FALSE)
    else
        system_prefs:toggle_voice_effects(TRUE)
    end
end
system_prefs.read = function(arg1, arg2) -- line 375
    if arg2 == "MusicVolume" then
        return ImGetMusicVol()
    elseif arg2 == "SfxVolume" then
        if music_state.paused then
            return music_state.original_sound_fx_vol
        else
            return ImGetSfxVol()
        end
    elseif arg2 == "VoiceVolume" then
        return ImGetVoiceVol()
    elseif arg2 == "Gamma" then
        return floor((MAX_GAMMA - MIN_GAMMA - (arg1.gamma - MIN_GAMMA)) * 10)
    elseif arg2 == "JoystickEnabled" then
        if arg1.joystick_enabled then
            return 1
        else
            return 0
        end
    elseif arg2 == "TextMode" then
        return GetSpeechMode()
    elseif arg2 == "TextSpeed" then
        return GetTextSpeed()
    elseif arg2 == "Transcript" then
        if dialog_log.bActive then
            return 1
        else
            return 0
        end
    elseif arg2 == "MovementMode" then
        if MarioControl then
            return 1
        else
            return 0
        end
    elseif arg2 == "VoiceEffects" then
        if arg1.voice_effects then
            return 1
        else
            return 0
        end
    end
end
system_prefs.write = function(arg1, arg2, arg3) -- line 419
    if arg2 == "MusicVolume" or not arg2 then
        if not arg3 then
            arg3 = ImGetMusicVol()
        else
            arg3 = tonumber(arg3)
            ImSetMusicVol(arg3)
        end
        WriteRegistryValue("MusicVolume", arg3)
    end
    if arg2 == "SfxVolume" or not arg2 then
        if not arg3 then
            if music_state.paused then
                arg3 = music_state.original_sound_fx_vol
            else
                arg3 = ImGetSfxVol()
            end
        else
            arg3 = tonumber(arg3)
            if music_state.paused then
                music_state.original_sound_fx_vol = arg3
            else
                ImSetSfxVol(arg3)
            end
        end
        WriteRegistryValue("SfxVolume", arg3)
    end
    if arg2 == "VoiceVolume" or not arg2 then
        if not arg3 then
            arg3 = ImGetVoiceVol()
        else
            arg3 = tonumber(arg3)
            ImSetVoiceVol(arg3)
        end
        WriteRegistryValue("VoiceVolume", arg3)
    end
    if arg2 == "Gamma" or not arg2 then
        if not arg3 then
            arg3 = arg1.gamma
        else
            arg1.gamma = arg3
            SetGamma(arg3)
        end
        WriteRegistryValue("Gamma", arg3)
    end
    if arg2 == "JoystickEnabled" or not arg2 then
        arg1.joystick_enabled = arg3
        if arg3 then
            enable_joystick_controls(TRUE)
            WriteRegistryValue("JoystickEnabled", "TRUE")
        else
            enable_joystick_controls(FALSE)
            WriteRegistryValue("JoystickEnabled", "FALSE")
        end
    end
    if arg2 == "TextMode" or not arg2 then
        if not arg3 then
            arg3 = GetSpeechMode()
        else
            SetSpeechMode(arg3)
        end
        WriteRegistryValue("TextMode", arg3)
    end
    if arg2 == "TextSpeed" or not arg2 then
        if not arg3 then
            arg3 = GetTextSpeed()
        else
            SetTextSpeed(arg3)
        end
        WriteRegistryValue("TextSpeed", arg3)
    end
    if arg2 == "Transcript" or not arg2 then
        if arg3 then
            dialog_log:on()
        else
            dialog_log:off()
        end
        if arg3 then
            WriteRegistryValue("Transcript", "TRUE")
        else
            WriteRegistryValue("Transcript", "FALSE")
        end
    end
    if arg2 == "MovementMode" or not arg2 then
        MarioControl = arg3
        if not game_pauser.is_paused then
            if MarioControl then
                stop_movement_scripts()
                ResetMarioControls()
                single_start_script(WalkManny)
            end
        end
        if arg3 then
            WriteRegistryValue("MovementMode", "Camera")
        else
            WriteRegistryValue("MovementMode", "Character")
        end
    end
    if arg2 == "VoiceEffects" or not arg2 then
        if arg3 then
            arg1:toggle_voice_effects(TRUE)
        else
            arg1:toggle_voice_effects(FALSE)
        end
        if arg3 then
            WriteRegistryValue("VoiceEffects", "TRUE")
        else
            WriteRegistryValue("VoiceEffects", "FALSE")
        end
    end
end
system_prefs.toggle_movement_mode = function(arg1) -- line 532
    if MarioControl then
        MarioControl = FALSE
    else
        MarioControl = TRUE
    end
    if game_pauser.is_paused then
        arg1:write("MovementMode", MarioControl)
    else
        arg1:write("MovementMode", MarioControl)
        if MarioControl then
            message_text:set("/sytx231/")
        else
            message_text:set("/sytx232/")
        end
    end
end
system_prefs.cycle_speech_mode = function(arg1) -- line 550
    local local1 = GetSpeechMode()
    local1 = local1 + 1
    if local1 > 3 then
        local1 = 1
    end
    if game_pauser.is_paused then
        arg1:write("TextMode")
    else
        arg1:write("TextMode", local1)
        if local1 == VOICE_ONLY then
            message_text:set("/sytx233/")
        elseif local1 == VOICE_AND_TEXT then
            message_text:set("/sytx234/")
        elseif local1 == TEXT_ONLY then
            message_text:set("/sytx235/")
        end
    end
end
system_prefs.cycle_gamma = function(arg1) -- line 571
    arg1.gamma = arg1.gamma - 0.1
    if arg1.gamma < MIN_GAMMA then
        arg1.gamma = MAX_GAMMA
    end
    if game_pauser.is_paused then
        arg1:write("Gamma")
    else
        arg1:write("Gamma", arg1.gamma)
        system.currentSet:redraw_frozen_actors()
    end
end
system_prefs.toggle_joystick = function(arg1) -- line 585
    if arg1.joystick_enabled then
        arg1.joystick_enabled = FALSE
    else
        arg1.joystick_enabled = TRUE
    end
    arg1:write("JoystickEnabled", arg1.joystick_enabled)
    if not game_pauser.is_paused then
        if arg1.joystick_enabled then
            message_text:set("/sytx236/")
        else
            message_text:set("/sytx237/")
        end
    end
end
system_prefs.set_voice_effect = function(arg1, arg2) -- line 602
    arg1.cur_voice_effect = arg2
    if arg1.voice_effects then
        ImSetVoiceEffect(arg1.cur_voice_effect)
    else
        ImSetVoiceEffect("OFF")
    end
end
system_prefs.toggle_voice_effects = function(arg1, arg2) -- line 611
    if arg2 then
        if arg1.cur_voice_effect then
            ImSetVoiceEffect(arg1.cur_voice_effect)
        else
            ImSetVoiceEffect("OFF")
        end
    else
        ImSetVoiceEffect("OFF")
    end
    arg1.voice_effects = arg2
end
game_pauser = { }
game_pauser.is_paused = FALSE
game_pauser.prev_button_handler = nil
game_pauser.prev_paint_handler = nil
game_pauser.pause = function(arg1, arg2, arg3, arg4) -- line 631
    if arg2 then
        if not arg1.is_paused then
            arg1.bHardwareEnabled = Is3DHardwareEnabled()
            arg1.prev_button_handler = system.buttonHandler
            arg1.prev_paint_handler = system.paintHandler
            arg1.prev_axis_handler = system.axisHandler
            arg1.is_paused = TRUE
            EngineDisplay(TRUE)
            pause_scripts()
            ImPause()
            PauseMovie(TRUE)
            DimScreen()
            RenderModeUser(TRUE)
        end
        if arg3 then
            system.buttonHandler = arg3
            system.axisHandler = arg1
        end
        if arg4 then
            system.userPaintHandler = arg4
        end
    else
        arg1.is_paused = FALSE
        main_menu:free_logo()
        unpause_scripts()
        ImResume()
        PauseMovie(FALSE)
        RenderModeUser(nil)
        SetGamma(system_prefs.gamma)
        if MarioControl then
            stop_movement_scripts()
            ResetMarioControls()
            single_start_script(WalkManny)
        end
        if arg1.prev_button_handler then
            system.buttonHandler = arg1.prev_button_handler
        else
            system.buttonHandler = SampleButtonHandler
        end
        if arg1.prev_axis_handler then
            system.axisHandler = arg1.prev_axis_handler
        else
            system.axisHandler = SampleAxisHandler
        end
        system.userPaintHandler = arg1.prev_paint_handler
        if Is3DHardwareEnabled() and not arg1.bHardwareEnabled then
            system.currentSet:unfreeze_all_actors()
        end
        if system.currentSet and system.currentSet == sh then
            start_script(sh.set_up_flowers)
        elseif system.currentSet and system.currentSet == zw then
            start_script(sh.set_up_flowers)
        end
    end
end
game_pauser.axisHandler = function(arg1, arg2, arg3) -- line 701
    local local1
    local local2
    if abs(arg3) > AXIS_SENSITIVITY then
        local2 = TRUE
        if arg2 == system.controls.AXIS_JOY1_X then
            if arg3 < 0 then
                local1 = JOYSTICK_X_LEFT
            else
                local1 = JOYSTICK_X_RIGHT
            end
        elseif arg2 == system.controls.AXIS_JOY1_Y then
            if arg3 < 0 then
                local1 = JOYSTICK_Y_UP
            else
                local1 = JOYSTICK_Y_DOWN
            end
        end
        AxisHandlerMappedIds[arg2] = local1
    else
        local2 = FALSE
        local1 = AxisHandlerMappedIds[arg2]
    end
    if local1 ~= nil and system.buttonHandler ~= nil then
        call_button_handler(local1, local2)
    end
end
BlastMultipleLines = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 734
    local local1, local2, local3, local4
    local1 = MakeTextObject(arg1, arg2)
    local2, local3 = GetTextObjectDimensions(local1)
    local4 = arg2.y + local3 + 2
    if arg4.y < local4 then
        arg4.y = local4
    end
    KillTextObject(local1)
    local1 = nil
    if arg5 then
        local1 = MakeTextObject(arg3, arg4)
        local2, local3 = GetTextObjectDimensions(local1)
        local4 = arg4.y + local3 + 2
        if arg6.y < local4 then
            arg6.y = local4
        end
        KillTextObject(local1)
        local1 = nil
    end
    arg2.font = verb_font
    arg4.font = verb_font
    if arg6 then
        arg6.font = verb_font
    end
    BlastText(arg1, arg2)
    BlastText(arg3, arg4)
    if arg5 then
        BlastText(arg5, arg6)
    end
end
menu_object = { }
menu_object.create = function(arg1, arg2, arg3) -- line 773
    local local1 = { }
    local1.parent = arg1
    local1.parent_menu = arg3
    local1.items = { }
    local1.num_items = 0
    local1.cur_item = nil
    local1.help = { }
    local1.help.text = nil
    local1.help.props = { x = 320, y = 430, font = verb_font, center = TRUE, fgcolor = OptionsColor }
    local1.visible_items = nil
    local1.top_item = nil
    local1.scrollbar_x = nil
    if not arg2 then
        arg2 = { x = 320, y = 50, center = TRUE }
    end
    local1.default_props = arg2
    if not local1.default_props.fgcolor then
        local1.default_props.fgcolor = OptionsDarkColor
    end
    if not local1.default_props.font then
        local1.default_props.font = verb_font
    end
    return local1
end
menu_object.destroy = function(arg1) -- line 804
    local local1, local2
    local1, local2 = next(arg1.items, nil)
    while local1 do
        local2.text = nil
        local2.key = nil
        local2.props = nil
        local1, local2 = next(arg1.items, local1)
    end
    arg1.items = nil
    arg1.num_items = nil
    arg1.parent = nil
    arg1.visible_items = nil
    arg1.default_props = nil
    arg1.help = nil
end
menu_object.add_item = function(arg1, arg2, arg3) -- line 823
    local local1, local2, local3, local4
    local1 = arg1.num_items + 1
    if not arg1.items[local1] then
        arg1.items[local1] = { }
    end
    arg1.items[local1].text = arg2
    arg1.items[local1].props = copy_table(arg1.default_props)
    if arg3 and type(arg3) == "table" then
        local3, local4 = next(arg3, nil)
        while local3 do
            arg1.items[local1].props[local3] = local4
            local3, local4 = next(arg3, local3)
        end
    end
    if arg1.items[local1 - 1] then
        arg1.items[local1].props.y = arg1.items[local1 - 1].props.y + 20
    end
    arg1.num_items = local1
    if not arg1.cur_item then
        arg1.cur_item = local1
    end
    return local1
end
menu_object.draw = function(arg1, arg2) -- line 851
    local local1, local2, local3, local4, local5
    arg1.hot_key_pressed = nil
    if not arg1.visible_items then
        local1, local2 = next(arg1.items, nil)
        while local1 do
            local3 = copy_table(local2.props)
            if local1 == arg1.cur_item and not arg2 then
                local3.fgcolor = OptionsHighlightColor
            elseif local1 == arg1.cur_item and arg2 then
                local3.fgcolor = OptionsDimHighlightColor
            else
                local3.fgcolor = OptionsDarkColor
            end
            arg1:display_text(local2.text, local3)
            local1, local2 = next(arg1.items, local1)
        end
    else
        if not arg1.top_item then
            arg1.top_item = 1
        end
        local1 = 0
        while local1 < arg1.visible_items do
            local2 = arg1.items[arg1.top_item + local1]
            if local2 and local2.text then
                local3 = copy_table(local2.props)
                if local1 + arg1.top_item == arg1.cur_item and not arg2 then
                    local3.fgcolor = OptionsHighlightColor
                elseif local1 + arg1.top_item == arg1.cur_item and arg2 then
                    local3.fgcolor = OptionsDimHighlightColor
                else
                    local3.fgcolor = OptionsDarkColor
                end
                local3.y = arg1.default_props.y + local1 * 20
                local2.props.y = local3.y
                arg1:display_text(local2.text, local3)
            end
            local1 = local1 + 1
        end
        if not arg1.scrollbar_x then
            local4 = arg1.items[arg1.top_item].props.x - 20
        else
            local4 = arg1.scrollbar_x
        end
        if arg1.top_item > 1 then
            arg1:draw_arrow(local4, arg1.default_props.y + 8)
        end
        if arg1.top_item + arg1.visible_items - 1 < arg1.num_items then
            arg1:draw_arrow(local4, arg1.default_props.y + (arg1.visible_items - 1) * 20 + 8, TRUE)
        end
    end
    if arg1.help.text then
        arg1.help.props.font = verb_font
        BlastText(arg1.help.text, arg1.help.props)
    end
end
menu_object.draw_arrow = function(arg1, arg2, arg3, arg4) -- line 923
    local local1 = 0
    while local1 < 6 do
        if arg4 then
            BlastRect(arg2 + local1, arg3 + local1 * 2, arg2 + 10 - local1 + 1, arg3 + local1 * 2 + 1, { color = OptionsDimHighlightColor, filled = TRUE })
        else
            BlastRect(arg2 + 5 - local1, arg3 + local1 * 2, arg2 + local1 + 6, arg3 + local1 * 2 + 1, { color = OptionsDimHighlightColor, filled = TRUE })
        end
        local1 = local1 + 1
    end
end
menu_object.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 935
    local local1 = FALSE
    if control_map.DIALOG_UP[arg2] and arg3 then
        single_start_script(arg1.scroll_up, arg1)
        local1 = TRUE
    elseif control_map.DIALOG_DOWN[arg2] and arg3 then
        single_start_script(arg1.scroll_down, arg1)
        local1 = TRUE
    elseif control_map.PAGE_UP[arg2] and arg3 then
        single_start_script(arg1.page_up, arg1)
        local1 = TRUE
    elseif control_map.PAGE_DOWN[arg2] and arg3 then
        single_start_script(arg1.page_down, arg1)
        local1 = TRUE
    elseif control_map.PAGE_HOME[arg2] and arg3 then
        arg1.cur_item = 1
        if arg1.visible_items then
            arg1.top_item = 1
        end
        local1 = TRUE
    elseif control_map.PAGE_END[arg2] and arg3 then
        arg1.cur_item = arg1.num_items
        if arg1.visible_items then
            arg1.top_item = arg1.num_items - arg1.visible_items + 1
            if arg1.top_item < 1 then
                arg1.top_item = 1
            end
        end
        local1 = TRUE
    end
    return local1
end
menu_object.characterHandler = function(arg1, arg2) -- line 970
    local local1, local2
    local local3
    local local4 = FALSE
    arg1.hot_key_pressed = nil
    local1, local2 = next(arg1.items, nil)
    while local1 and not arg1.hot_key_pressed do
        local3 = arg1:get_hotkey(local2.text)
        if local3 then
            if strlower(local3) == strlower(arg2) then
                arg1.cur_item = local1
                arg1.hot_key_pressed = arg1.cur_item
                local4 = TRUE
            end
        end
        local1, local2 = next(arg1.items, local1)
    end
    return local4
end
menu_object.scroll_up = function(arg1) -- line 993
    local local1
    while get_generic_control_state("DIALOG_UP") do
        arg1.cur_item = arg1.cur_item - 1
        while arg1.cur_item >= 1 and arg1.items[arg1.cur_item] and arg1.items[arg1.cur_item].props.disabled do
            arg1.cur_item = arg1.cur_item - 1
        end
        if arg1.cur_item < 1 then
            arg1.cur_item = arg1.num_items
        end
        if arg1.visible_items then
            if arg1.top_item > arg1.cur_item then
                arg1.top_item = arg1.cur_item
            elseif arg1.top_item + arg1.visible_items <= arg1.cur_item then
                arg1.top_item = arg1.cur_item - arg1.visible_items + 1
            end
        end
        if arg1.parent_menu then
            arg1.parent_menu:draw()
        end
        break_here()
        local1 = 0
        while local1 < 500 and get_generic_control_state("DIALOG_UP") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
menu_object.scroll_down = function(arg1) -- line 1027
    local local1
    while get_generic_control_state("DIALOG_DOWN") do
        arg1.cur_item = arg1.cur_item + 1
        while arg1.cur_item <= arg1.num_items and arg1.items[arg1.cur_item] and arg1.items[arg1.cur_item].props.disabled do
            arg1.cur_item = arg1.cur_item + 1
        end
        if arg1.cur_item > arg1.num_items then
            arg1.cur_item = 1
        end
        if arg1.visible_items then
            if arg1.top_item + arg1.visible_items <= arg1.cur_item then
                arg1.top_item = arg1.cur_item - arg1.visible_items + 1
            elseif arg1.top_item > arg1.cur_item then
                arg1.top_item = arg1.cur_item
            end
        end
        if arg1.parent_menu then
            arg1.parent_menu:draw()
        end
        break_here()
        local1 = 0
        while local1 < 500 and get_generic_control_state("DIALOG_DOWN") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
menu_object.page_up = function(arg1) -- line 1061
    local local1
    while get_generic_control_state("PAGE_UP") do
        if arg1.visible_items then
            arg1.cur_item = arg1.cur_item - arg1.visible_items + 1
        else
            arg1.cur_item = 1
        end
        while arg1.cur_item >= 1 and arg1.items[arg1.cur_item] and arg1.items[arg1.cur_item].props.disabled do
            arg1.cur_item = arg1.cur_item - 1
        end
        if arg1.cur_item < 1 then
            arg1.cur_item = 1
        end
        if arg1.visible_items then
            arg1.top_item = arg1.cur_item
        end
        if arg1.parent_menu then
            arg1.parent_menu:draw()
        end
        break_here()
        local1 = 0
        while local1 < 800 and get_generic_control_state("PAGE_UP") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
menu_object.page_down = function(arg1) -- line 1095
    local local1
    while get_generic_control_state("PAGE_DOWN") do
        if arg1.visible_items then
            arg1.cur_item = arg1.cur_item + arg1.visible_items - 1
        else
            arg1.cur_item = arg1.num_items
        end
        while arg1.cur_item <= arg1.num_items and arg1.items[arg1.cur_item] and arg1.items[arg1.cur_item].props.disabled do
            arg1.cur_item = arg1.cur_item + 1
        end
        if arg1.cur_item > arg1.num_items then
            arg1.cur_item = arg1.num_items
        end
        if arg1.visible_items then
            arg1.top_item = arg1.cur_item - arg1.visible_items + 1
            if arg1.top_item < 1 then
                arg1.top_item = 1
            elseif arg1.top_item > arg1.num_items - arg1.visible_items + 1 then
                arg1.top_item = arg1.num_items - arg1.visible_items + 1
            end
        end
        if arg1.parent_menu then
            arg1.parent_menu:draw()
        end
        break_here()
        local1 = 0
        while local1 < 800 and get_generic_control_state("PAGE_DOWN") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
menu_object.set_cur_item = function(arg1, arg2) -- line 1134
    if arg2 >= 1 and arg2 <= arg1.num_items then
        arg1.cur_item = arg2
        if arg2 <= arg1.visible_items then
            arg1.top_item = 1
        else
            arg1.top_item = arg2
            while arg1.top_item > 1 and arg1.top_item + arg1.visible_items >= arg1.num_items do
                arg1.top_item = arg1.top_item - 1
            end
        end
    else
        arg1.cur_item = 1
    end
end
menu_object.is_empty = function(arg1) -- line 1150
    if arg1.num_items == nil or arg1.num_items == 0 then
        return TRUE
    else
        return FALSE
    end
end
menu_object.display_text = function(arg1, arg2, arg3) -- line 1158
    local local1
    local local2, local3
    local local4, local5, local6, local7
    local local8, local9, local10
    local1 = LocalizeString(arg2)
    local1 = trim_header(local1)
    arg3.font = verb_font
    local3 = strfind(local1, "&")
    if not local3 then
        BlastText(local1, arg3)
    else
        local2 = gsub(local1, "&", "")
        BlastText(local2, arg3)
        local4 = copy_table(arg3)
        local8, local9, local10 = GetColorComponents(local4.fgcolor)
        local8 = local8 + 75
        local9 = local9 + 75
        local10 = local10 + 75
        if local8 > 255 then
            local8 = 255
        end
        if local9 > 255 then
            local9 = 255
        end
        if local10 > 255 then
            local10 = 255
        end
        local4.fgcolor = MakeColor(local8, local9, local10)
        if local4.center or local4.rjustify then
            local5 = MakeTextObject(local2, local4)
            local6, local7 = GetTextObjectDimensions(local5)
            KillTextObject(local5)
            local5 = nil
            if local4.center then
                local4.x = local4.x - floor(local6 / 2)
            else
                local4.x = local4.x - local6
            end
            local4.center = FALSE
            local4.rjustify = FALSE
            local4.ljustify = TRUE
        end
        if local3 ~= 1 then
            local5 = MakeTextObject(local2, local4)
            local6 = GetTextCharPosition(local5, local3 - 1)
            KillTextObject(local5)
            local5 = nil
            local4.x = local4.x + local6
        end
        local2 = strsub(local1, local3 + 1, local3 + 1)
        local4.font = verb_font
        BlastText(local2, local4)
    end
end
menu_object.get_hotkey = function(arg1, arg2) -- line 1216
    local local1
    local local2
    local local3
    local1 = LocalizeString(arg2)
    local1 = trim_header(local1)
    local2 = strfind(local1, "&")
    if local2 then
        local3 = strsub(local1, local2 + 1, local2 + 1)
    end
    return local3
end
MAIN_MENU_HELP_TEXT = "/sytx238/"
main_menu = { }
main_menu.initialized = FALSE
main_menu.init = function(arg1) -- line 1238
    arg1:load_logo()
    if not arg1.initialized then
        arg1.menu = menu_object:create({ x = 320, y = 160, center = TRUE }, arg1)
        arg1.menu.help.text = MAIN_MENU_HELP_TEXT
        arg1.menu:add_item("/sytx239/")
        arg1.menu:add_item("/sytx240/")
        arg1.menu:add_item("/sytx241/")
        arg1.menu:add_item("/sytx242/")
        arg1.menu:add_item("/sytx243/")
        arg1.menu:add_item("/sytx244/")
        arg1.menu:add_item("/sytx245/")
        arg1.menu:add_item("/sytx246/")
        arg1.menu:add_item("", { disabled = TRUE })
        arg1.menu:add_item("/sytx247/")
        arg1.menu:add_item("/sytx248/")
        arg1.initialized = TRUE
    end
end
main_menu.load_logo = function(arg1) -- line 1264
    if not arg1.logo then
        arg1.logo = GetImage("grimlogo.bm")
    end
end
main_menu.free_logo = function(arg1) -- line 1270
    if arg1.logo then
        FreeImage(arg1.logo)
        arg1.logo = nil
    end
end
main_menu.destroy = function(arg1) -- line 1277
    if arg1.initialized then
        arg1.initialized = FALSE
        arg1:free_logo()
        arg1.menu:destroy()
    end
end
main_menu.draw = function(arg1) -- line 1287
    if arg1.is_active then
        CleanBuffer()
        BlastImage(arg1.logo, DEFAULT_LOGO_X, DEFAULT_LOGO_Y, TRUE)
        arg1.menu:draw()
        Display()
    end
end
main_menu.run = function(arg1) -- line 1298
    local local1, local2
    if not arg1.is_active then
        arg1:init()
        arg1.is_active = TRUE
        game_pauser:pause(TRUE, arg1, arg1)
        system.characterHandler = arg1
        arg1:draw()
    end
end
main_menu.cancel = function(arg1, arg2) -- line 1313
    PrintDebug("main_menu:cancel(" .. arg2 .. ")\n")
    PrintDebug("self.is_active == " .. arg1.is_active .. "\n")
    if arg1.is_active then
        if not arg2 then
            PrintDebug("Unpausing game -- game.is_paused = " .. game_pauser.is_paused .. "\n")
            game_pauser:pause(FALSE)
        end
        system.characterHandler = nil
        arg1.is_active = FALSE
    end
end
main_menu.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 1328
    local local1 = FALSE
    local1 = arg1.menu:buttonHandler(arg2, arg3, arg4)
    if not local1 then
        if control_map.OVERRIDE[arg2] and arg3 then
            start_script(arg1.return_to_game, arg1)
        elseif control_map.DIALOG_CHOOSE[arg2] and arg3 then
            arg1:choose_item(arg1.menu.cur_item)
        end
    end
    if local1 then
        arg1:draw()
    end
end
main_menu.characterHandler = function(arg1, arg2) -- line 1345
    local local1 = FALSE
    local1 = arg1.menu:characterHandler(arg2)
    if local1 then
        arg1:draw()
        arg1:choose_item(arg1.menu.cur_item)
    end
end
main_menu.choose_item = function(arg1, arg2) -- line 1355
    if arg2 == 11 then
        arg1:cancel(TRUE)
        query_exit_game()
    elseif arg2 == 10 then
        start_script(arg1.return_to_game, arg1)
    elseif arg2 == 8 then
        arg1:cancel(TRUE)
        start_script(credits_menu.run, credits_menu, "ingame.txt")
    elseif arg2 == 7 then
        arg1:cancel(TRUE)
        cutscene_menu:run()
    elseif arg2 == 6 then
        arg1:cancel(TRUE)
        dialog_log:run()
    elseif arg2 == 5 then
        arg1:cancel(TRUE)
        saveload_menu:run(SAVELOAD_MENU_ERASE_MODE)
    elseif arg2 == 4 then
        arg1:cancel(TRUE)
        saveload_menu:run(SAVELOAD_MENU_LOAD_MODE)
    elseif arg2 == 3 then
        arg1:cancel(TRUE)
        saveload_menu:run(SAVELOAD_MENU_SAVE_MODE)
    elseif arg2 == 2 then
        arg1:cancel(TRUE)
        settings_menu:run()
    elseif arg2 == 1 then
        arg1:cancel(TRUE)
        help_menu:run()
    end
end
main_menu.userPaintHandler = function(arg1) -- line 1388
    arg1:draw()
end
main_menu.return_to_game = function(arg1) -- line 1392
    if CheckForCD(system.currentSet.setFile) then
        arg1:cancel()
    else
        arg1:cancel()
        arg1:run()
    end
end
SETTINGS_MENU_TITLE = "/sytx249/"
SETTINGS_MENU_HELP_TEXT = "/sytx250/"
SETTINGS_OFF_STRING = "/sytx251/"
SETTINGS_LOW_STRING = "/sytx252/"
SETTINGS_MEDIUM_STRING = "/sytx253/"
SETTINGS_HIGH_STRING = "/sytx254/"
SETTINGS_VOICE_ONLY_STRING = "/sytx255/"
SETTINGS_VOICE_AND_TEXT_STRING = "/sytx256/"
SETTINGS_TEXT_ONLY_STRING = "/sytx257/"
SETTINGS_SLOW_STRING = "/sytx258/"
SETTINGS_FAST_STRING = "/sytx259/"
SETTINGS_ON_STRING = "/sytx260/"
SETTINGS_CAMERA_RELATIVE_STRING = "/sytx261/"
SETTINGS_CHAR_RELATIVE_STRING = "/sytx262/"
SETTINGS_NORMAL_STRING = "/sytx263/"
SETTINGS_BRIGHTER_STRING = "/sytx264/"
SETTINGS_BRIGHTEST_STRING = "/sytx265/"
SETTINGS_DARKER_STRING = "/sytx551/"
SETTINGS_DARKEST_STRING = "/sytx552/"
SETTINGS_ENABLED_STRING = "/sytx266/"
SETTINGS_DISABLED_STRING = "/sytx267/"
settings_menu = { }
settings_menu.initialized = FALSE
settings_menu.init = function(arg1) -- line 1436
    local local1, local2, local3, local4, local5
    main_menu:load_logo()
    if not arg1.initialized then
        arg1.gauges = { }
        local1 = 340
        local2 = 150
        local3 = 8
        arg1.menu = menu_object:create({ x = 60, y = 110 }, arg1)
        local4 = arg1.menu:add_item("/sytx268/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, FALSE, 0, 127)
        arg1.gauges[local4].value_text[0] = SETTINGS_OFF_STRING
        arg1.gauges[local4].value_text[2] = SETTINGS_LOW_STRING
        arg1.gauges[local4].value_text[64] = SETTINGS_MEDIUM_STRING
        arg1.gauges[local4].value_text[127] = SETTINGS_HIGH_STRING
        arg1.gauges[local4].increment = 5
        arg1.gauges[local4].value = system_prefs:read("MusicVolume")
        local4 = arg1.menu:add_item("/sytx269/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, FALSE, 0, 127)
        arg1.gauges[local4].value_text[0] = SETTINGS_OFF_STRING
        arg1.gauges[local4].value_text[2] = SETTINGS_LOW_STRING
        arg1.gauges[local4].value_text[64] = SETTINGS_MEDIUM_STRING
        arg1.gauges[local4].value_text[127] = SETTINGS_HIGH_STRING
        arg1.gauges[local4].increment = 5
        arg1.gauges[local4].value = system_prefs:read("SfxVolume")
        local4 = arg1.menu:add_item("/sytx270/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, FALSE, 0, 127)
        arg1.gauges[local4].value_text[0] = SETTINGS_OFF_STRING
        arg1.gauges[local4].value_text[2] = SETTINGS_LOW_STRING
        arg1.gauges[local4].value_text[64] = SETTINGS_MEDIUM_STRING
        arg1.gauges[local4].value_text[127] = SETTINGS_HIGH_STRING
        arg1.gauges[local4].increment = 5
        arg1.gauges[local4].value = system_prefs:read("VoiceVolume")
        arg1.menu:add_item("", { disabled = TRUE })
        local4 = arg1.menu:add_item("/sytx271/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, TRUE, 1, 3)
        arg1.gauges[local4].value_text[1] = SETTINGS_TEXT_ONLY_STRING
        arg1.gauges[local4].value_text[2] = SETTINGS_VOICE_ONLY_STRING
        arg1.gauges[local4].value_text[3] = SETTINGS_VOICE_AND_TEXT_STRING
        arg1.gauges[local4].value = system_prefs:read("TextMode")
        local4 = arg1.menu:add_item("/sytx272/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, FALSE, 1, 10)
        arg1.gauges[local4].value_text[1] = SETTINGS_SLOW_STRING
        arg1.gauges[local4].value_text[5] = SETTINGS_MEDIUM_STRING
        arg1.gauges[local4].value_text[10] = SETTINGS_FAST_STRING
        arg1.gauges[local4].value = system_prefs:read("TextSpeed")
        local4 = arg1.menu:add_item("/sytx273/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, TRUE, 0, 1)
        arg1.gauges[local4].value_text[0] = SETTINGS_OFF_STRING
        arg1.gauges[local4].value_text[1] = SETTINGS_ON_STRING
        arg1.gauges[local4].value = system_prefs:read("Transcript")
        local4 = arg1.menu:add_item("/sytx553/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, TRUE, 0, 1)
        arg1.gauges[local4].value_text[0] = SETTINGS_OFF_STRING
        arg1.gauges[local4].value_text[1] = SETTINGS_ON_STRING
        arg1.gauges[local4].value = system_prefs:read("VoiceEffects")
        arg1.menu:add_item("", { disabled = TRUE })
        local4 = arg1.menu:add_item("/sytx274/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, TRUE, 0, 1)
        arg1.gauges[local4].value_text[0] = SETTINGS_CHAR_RELATIVE_STRING
        arg1.gauges[local4].value_text[1] = SETTINGS_CAMERA_RELATIVE_STRING
        arg1.gauges[local4].value = system_prefs:read("MovementMode")
        local4 = arg1.menu:add_item("/sytx275/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, TRUE, 0, 1)
        arg1.gauges[local4].value_text[0] = SETTINGS_DISABLED_STRING
        arg1.gauges[local4].value_text[1] = SETTINGS_ENABLED_STRING
        arg1.gauges[local4].value = system_prefs:read("JoystickEnabled")
        arg1.menu:add_item("", { disabled = TRUE })
        local4 = arg1.menu:add_item("/sytx276/")
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, FALSE, 0, 10)
        arg1.gauges[local4].value_text[0] = SETTINGS_DARKEST_STRING
        arg1.gauges[local4].value_text[1] = SETTINGS_DARKER_STRING
        arg1.gauges[local4].value_text[4] = SETTINGS_DARKER_STRING
        arg1.gauges[local4].value_text[5] = SETTINGS_NORMAL_STRING
        arg1.gauges[local4].value_text[6] = SETTINGS_BRIGHTER_STRING
        arg1.gauges[local4].value_text[9] = SETTINGS_BRIGHTER_STRING
        arg1.gauges[local4].value_text[10] = SETTINGS_BRIGHTEST_STRING
        arg1.gauges[local4].value = system_prefs:read("Gamma")
        local4 = arg1.menu:add_item("/sytx277/")
        arg1.threed_index = local4
        arg1.gauges[local4] = gauge_object:create(local1, arg1.menu.items[local4].props.y, local2, local3, TRUE, 0, 1)
        arg1.gauges[local4].value_text[0] = SETTINGS_OFF_STRING
        arg1.gauges[local4].value_text[1] = SETTINGS_ON_STRING
        if Is3DHardwareEnabled() then
            arg1.gauges[local4].value = 1
        else
            arg1.gauges[local4].value = 0
        end
        local4 = arg1.menu:add_item("/sytx278/")
        arg1.advanced_threed_index = local4
        arg1.menu:add_item("", { disabled = TRUE })
        local4 = arg1.menu:add_item("/sytx279/")
        arg1.exit_index = local4
        arg1.initialized = TRUE
    end
end
settings_menu.destroy = function(arg1) -- line 1554
    local local1, local2
    if arg1.initialized then
        arg1.initialized = FALSE
        arg1.menu:destroy()
        arg1.menu = nil
        local1, local2 = next(arg1.gauges, nil)
        while local1 do
            local2:destroy()
            local1, local2 = next(arg1.gauges, local1)
        end
        arg1.gauges = nil
    end
end
settings_menu.draw = function(arg1) -- line 1572
    local local1, local2
    if arg1.is_active then
        CleanBuffer()
        BlastImage(main_menu.logo, 0, 0, TRUE)
        BlastMultipleLines(SETTINGS_MENU_TITLE, { x = 190, y = 10, ljustify = TRUE, font = verb_font, fgcolor = White }, SETTINGS_MENU_HELP_TEXT, { x = 190, y = 30, ljustify = TRUE, font = verb_font, fgcolor = OptionsColor })
        arg1.menu:draw()
        arg1:activate_gauges()
        local1, local2 = next(arg1.gauges, nil)
        while local1 do
            if local2 then
                local2:draw()
            end
            local1, local2 = next(arg1.gauges, local1)
        end
        Display()
    end
end
settings_menu.run = function(arg1) -- line 1597
    local local1, local2
    if not arg1.is_active then
        main_menu:free_logo()
        main_menu:load_logo()
        if not arg1.initialized then
            arg1:init()
        end
        arg1.is_active = TRUE
        system.characterHandler = arg1
        game_pauser:pause(TRUE, arg1, arg1)
        arg1:draw()
    end
end
settings_menu.cancel = function(arg1, arg2) -- line 1617
    if arg1.is_active then
        if not arg2 then
            game_pauser:pause(FALSE)
        end
        system.characterHandler = nil
        arg1:destroy()
        arg1.is_active = FALSE
    end
end
settings_menu.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 1630
    local local1 = FALSE
    local1 = arg1.menu:buttonHandler(arg2, arg3, arg4)
    if not local1 then
        if control_map.OVERRIDE[arg2] and arg3 then
            arg1:choose_item(arg1.exit_index)
        elseif control_map.TURN_LEFT[arg2] and arg3 then
            single_start_script(arg1.change_value, arg1, arg2, -1)
            local1 = TRUE
        elseif control_map.TURN_RIGHT[arg2] and arg3 then
            single_start_script(arg1.change_value, arg1, arg2, 1)
            local1 = TRUE
        elseif control_map.DIALOG_CHOOSE[arg2] and arg3 then
            local1 = arg1:choose_item(arg1.menu.cur_item)
        end
    else
        stop_script(arg1.change_value)
    end
    if local1 then
        arg1:draw()
    end
end
settings_menu.characterHandler = function(arg1, arg2) -- line 1655
    local local1 = FALSE
    local1 = arg1.menu:characterHandler(arg2)
    if local1 then
        arg1:draw()
        local1 = arg1:choose_item(arg1.menu.cur_item)
    end
    if local1 then
        arg1:draw()
    end
end
settings_menu.change_value = function(arg1, arg2, arg3) -- line 1669
    local local1, local2
    if arg1.menu.cur_item == arg1.advanced_threed_index then
        arg1:cancel(TRUE)
        display_menu:run()
    elseif arg1.menu.cur_item == arg1.threed_index then
        local2 = arg1.gauges[arg1.menu.cur_item]
        if local2.value == 0 then
            local2:set_value(1)
            SetHardwareState(TRUE)
        else
            local2:set_value(0)
            SetHardwareState(FALSE)
        end
        break_here()
        main_menu:free_logo()
        if Is3DHardwareEnabled() then
            local2:set_value(1)
        else
            local2:set_value(0)
        end
        main_menu:load_logo()
        arg1:draw()
    else
        local2 = arg1.gauges[arg1.menu.cur_item]
        if local2 then
            local2:set_value(local2.value + arg3 * local2.increment)
            arg1:draw()
            if arg2 then
                local1 = 200
                sleep_for(local1)
                while get_control_state(arg2) do
                    local2:set_value(local2.value + arg3 * local2.increment)
                    arg1:draw()
                    sleep_for(local1)
                    if local1 > 5 then
                        local1 = local1 - 5
                    end
                end
            end
            arg1:set_cur_value()
        end
    end
end
settings_menu.set_cur_value = function(arg1) -- line 1715
    local local1, local2
    local1 = arg1.menu.cur_item
    if arg1.gauges[local1] then
        local2 = arg1.gauges[local1].value
        if local1 == 1 then
            system_prefs:write("MusicVolume", local2)
        elseif local1 == 2 then
            system_prefs:write("SfxVolume", local2)
        elseif local1 == 3 then
            system_prefs:write("VoiceVolume", local2)
        elseif local1 == 5 then
            system_prefs:write("TextMode", local2)
        elseif local1 == 6 then
            system_prefs:write("TextSpeed", local2)
        elseif local1 == 7 then
            if local2 == 1 then
                system_prefs:write("Transcript", TRUE)
            else
                system_prefs:write("Transcript", FALSE)
            end
        elseif local1 == 8 then
            if local2 == 1 then
                system_prefs:write("VoiceEffects", TRUE)
            else
                system_prefs:write("VoiceEffects", FALSE)
            end
        elseif local1 == 10 then
            if local2 == 1 then
                system_prefs:write("MovementMode", TRUE)
            else
                system_prefs:write("MovementMode", FALSE)
            end
        elseif local1 == 11 then
            if local2 == 1 then
                system_prefs:write("JoystickEnabled", TRUE)
            else
                system_prefs:write("JoystickEnabled", FALSE)
            end
        elseif local1 == 13 then
            system_prefs:write("Gamma", MAX_GAMMA - local2 * 0.1)
        end
    end
end
settings_menu.choose_item = function(arg1, arg2) -- line 1762
    local local1 = FALSE
    if arg2 == arg1.exit_index then
        arg1:cancel(TRUE)
        main_menu:run()
    elseif arg2 == arg1.advanced_threed_index then
        arg1:cancel(TRUE)
        display_menu:run()
    else
        g = arg1.gauges[arg2]
        if g and g.bTextOnly then
            single_start_script(arg1.change_value, arg1, nil, 1)
        end
        local1 = TRUE
    end
    return local1
end
settings_menu.activate_gauges = function(arg1) -- line 1782
    local local1, local2
    local1, local2 = next(arg1.gauges, nil)
    while local1 do
        local2.bActive = FALSE
        local1, local2 = next(arg1.gauges, local1)
    end
    if arg1.gauges[arg1.menu.cur_item] then
        arg1.gauges[arg1.menu.cur_item].bActive = TRUE
    end
end
settings_menu.userPaintHandler = function(arg1) -- line 1795
    arg1:draw()
end
DISPLAY_MENU_TITLE = "/sytx280/"
DISPLAY_MENU_HELP_TEXT_DEVICE = "/sytx281/"
DISPLAY_MENU_HELP_TEXT_MODE = "/sytx282/"
DISPLAY_MENU_DEVICE_TEXT = "/sytx283/"
DISPLAY_MENU_MODE_TEXT = "/sytx284/"
display_menu = { }
display_menu.initialized = FALSE
display_menu.active_menu = nil
display_menu.exit_index = nil
display_menu.init = function(arg1) -- line 1814
    local local1, local2, local3, local4, local5
    local local6, local7
    main_menu:load_logo()
    if not arg1.initialized then
        arg1.device_menu = menu_object:create({ x = 60, y = 160 }, arg1)
        arg1.device_menu.help.text = DISPLAY_MENU_DEVICE_TEXT
        arg1.device_menu.help.props = { x = 40, y = 125, ljustify = TRUE, font = verb_font, fgcolor = OptionsColor }
        arg1.device_menu.visible_items = 5
        arg1:build_device_menu()
        arg1.active_menu = arg1.device_menu
        arg1.device_menu:add_item("", { disabled = TRUE })
        local6 = arg1.device_menu:add_item("/sytx285/")
        local7 = arg1.device_menu.items[local6]
        local7.props.y = local7.props.y + 20
        arg1.exit_index = local6
        arg1.initialized = TRUE
    end
end
display_menu.destroy = function(arg1) -- line 1843
    local local1, local2
    if arg1.initialized then
        arg1.initialized = FALSE
        arg1.device_menu:destroy()
        arg1.device_menu = nil
        arg1.mode_menu:destroy()
        arg1.mode_menu = nil
        arg1.active_menu = nil
    end
end
display_menu.draw = function(arg1) -- line 1859
    local local1, local2
    if arg1.is_active then
        CleanBuffer()
        BlastImage(main_menu.logo, 0, 0, TRUE)
        if arg1.active_menu == arg1.device_menu then
            BlastMultipleLines(DISPLAY_MENU_TITLE, { x = 190, y = 10, font = verb_font, fgcolor = White }, DISPLAY_MENU_HELP_TEXT_DEVICE, { x = 190, y = 30, font = verb_font, fgcolor = OptionsColor })
        else
            BlastMultipleLines(DISPLAY_MENU_TITLE, { x = 190, y = 10, font = verb_font, fgcolor = White }, DISPLAY_MENU_HELP_TEXT_MODE, { x = 190, y = 30, font = verb_font, fgcolor = OptionsColor })
        end
        if arg1.active_menu == arg1.device_menu then
            arg1:build_mode_menu()
        end
        if arg1.active_menu == arg1.device_menu then
            arg1.device_menu:draw()
            if arg1.device_menu.cur_item ~= arg1.exit_index then
                arg1.mode_menu:draw(TRUE)
            end
        else
            arg1.device_menu:draw(TRUE)
            arg1.mode_menu:draw()
        end
        Display()
    end
end
display_menu.run = function(arg1) -- line 1893
    local local1, local2
    if not arg1.is_active then
        if not arg1.initialized then
            arg1:init()
        end
        arg1:build_mode_menu()
        arg1.is_active = TRUE
        game_pauser:pause(TRUE, arg1, arg1)
        system.characterHandler = arg1
        arg1:draw()
    end
end
display_menu.cancel = function(arg1, arg2) -- line 1911
    if arg1.is_active then
        if not arg2 then
            game_pauser:pause(FALSE)
        end
        arg1:destroy()
        system.characterHandler = nil
        arg1.is_active = FALSE
    end
end
display_menu.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 1924
    local local1 = FALSE
    local1 = arg1.active_menu:buttonHandler(arg2, arg3, arg4)
    if not local1 then
        if control_map.OVERRIDE[arg2] and arg3 then
            arg1:choose_item(arg1.exit_index, TRUE)
        elseif control_map.DIALOG_CHOOSE[arg2] and arg3 then
            local1 = arg1:choose_item(arg1.active_menu.cur_item)
        end
    end
    if local1 then
        arg1:draw()
    end
end
display_menu.characterHandler = function(arg1, arg2) -- line 1941
    local local1 = FALSE
    local1 = arg1.active_menu:characterHandler(arg2)
    if local1 then
        arg1:draw()
        local1 = arg1:choose_item(arg1.active_menu.cur_item)
    end
    if local1 then
        arg1:draw()
    end
end
display_menu.choose_item = function(arg1, arg2, arg3) -- line 1955
    local local1 = FALSE
    local local2, local3
    if arg2 == arg1.exit_index then
        arg1:cancel(TRUE)
        settings_menu:run()
    elseif arg1.active_menu == arg1.device_menu then
        local3 = 1
        while local3 <= arg1.device_menu.num_items do
            if local3 ~= arg1.device_menu.cur_item then
                arg1.device_menu.items[local3].text = ""
            end
            local3 = local3 + 1
        end
        arg1.active_menu = arg1.mode_menu
        local1 = TRUE
    else
        start_script(arg1.update_settings, arg1)
    end
    return local1
end
display_menu.update_settings = function(arg1) -- line 1982
    local local1, local2
    local local3, local4
    main_menu:free_logo()
    local1 = arg1.device_menu.cur_item
    local2 = arg1.mode_menu.cur_item
    local3 = arg1.device_menu.items[local1].device_id
    local4 = arg1.mode_menu.items[local2].mode_id
    SetVideoDevices(local3, local4)
    break_here()
    arg1:cancel(TRUE)
    settings_menu:run()
end
display_menu.build_device_menu = function(arg1) -- line 2000
    local local1, local2, local3
    local local4, local5
    local local6, local7
    local6, local7 = GetVideoDevices()
    local1 = EnumerateVideoDevices()
    local2, local3 = next(local1, nil)
    while local2 do
        local4 = arg1.device_menu:add_item(local3)
        local5 = arg1.device_menu.items[local4]
        local5.device_id = local2
        local5.mode_table = Enumerate3DDevices(local2)
        if local2 == local6 then
            arg1.device_menu.cur_item = local4
        end
        local2, local3 = next(local1, local2)
    end
end
display_menu.build_mode_menu = function(arg1) -- line 2023
    local local1, local2
    local local3, local4, local5
    local local6, local7
    local local8, local9
    local8, local9 = GetVideoDevices()
    local1 = arg1.device_menu.cur_item
    if local1 then
        local2 = arg1.device_menu.items[local1].device_id
        if arg1.mode_menu then
            arg1.mode_menu:destroy()
        end
        arg1.mode_menu = menu_object:create({ x = 60, y = 310 }, arg1)
        arg1.mode_menu.help.text = DISPLAY_MENU_MODE_TEXT
        arg1.mode_menu.help.props = { x = 40, y = 280, ljustify = TRUE, font = verb_font, fgcolor = OptionsColor }
        arg1.mode_menu.visible_items = 5
        if local2 then
            local3 = arg1.device_menu.items[local1].mode_table
            local4, local5 = next(local3, nil)
            while local4 do
                local6 = arg1.mode_menu:add_item(local5)
                local7 = arg1.mode_menu.items[local6]
                local7.mode_id = local4
                if local2 == local8 and local9 == local4 then
                    arg1.mode_menu.cur_item = local6
                end
                local4, local5 = next(local3, local4)
            end
        end
    end
end
display_menu.userPaintHandler = function(arg1) -- line 2060
    arg1:draw()
end
HELP_KEYBOARD_TITLE = "/sytx286/"
HELP_KEYBOARD_HELP_TEXT1 = "/sytx287/"
HELP_GAMEPAD_TITLE = "/sytx288/"
HELP_GAMEPAD_HELP_TEXT1 = "/sytx289/"
HELP_INVENTORY_TITLE = "/sytx290/"
HELP_INVENTORY_HELP_TEXT1 = "/sytx291/"
HELP_MENU_HELP_TEXT2 = "/sytx292/"
help_menu = { }
help_menu.is_active = FALSE
help_menu.key_color = Yellow
help_menu.text_color = White
help_menu.line_height = 20
help_menu.cur_page = 1
help_menu.draw = function(arg1) -- line 2084
    local local1, local2
    if arg1.is_active then
        CleanBuffer()
        BlastImage(main_menu.logo, 0, 0, TRUE)
        if arg1.cur_page == 1 then
            BlastMultipleLines(HELP_KEYBOARD_TITLE, { x = 190, y = 10, font = verb_font, fgcolor = White }, HELP_KEYBOARD_HELP_TEXT1, { x = 190, y = 30, font = verb_font, fgcolor = OptionsColor }, HELP_MENU_HELP_TEXT2, { x = 190, y = 50, font = verb_font, fgcolor = OptionsColor })
        elseif arg1.cur_page == 2 then
            BlastMultipleLines(HELP_GAMEPAD_TITLE, { x = 190, y = 10, font = verb_font, fgcolor = White }, HELP_GAMEPAD_HELP_TEXT1, { x = 190, y = 30, font = verb_font, fgcolor = OptionsColor }, HELP_MENU_HELP_TEXT2, { x = 190, y = 50, font = verb_font, fgcolor = OptionsColor })
        else
            BlastMultipleLines(HELP_INVENTORY_TITLE, { x = 190, y = 10, font = verb_font, fgcolor = White }, HELP_INVENTORY_HELP_TEXT1, { x = 190, y = 30, font = verb_font, fgcolor = OptionsColor }, HELP_MENU_HELP_TEXT2, { x = 190, y = 50, font = verb_font, fgcolor = OptionsColor })
        end
        arg1:display_page()
        Display()
    end
end
help_menu.display_page = function(arg1) -- line 2111
    if arg1.cur_page == 1 then
        arg1:display_keyboard_page()
    elseif arg1.cur_page == 2 then
        arg1:display_gamepad_page()
    else
        arg1:display_inventory_page()
    end
end
help_menu.display_keyboard_page = function(arg1) -- line 2121
    local local1 = { font = verb_font, fgcolor = arg1.key_color, rjustify = TRUE }
    local local2 = { font = verb_font, fgcolor = arg1.text_color, ljustify = TRUE }
    if system.language == "EN" then
        if MarioControl then
            BlastText("/sytx293/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 120 })
            BlastText("/sytx294/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 150 })
            BlastText("/sytx295/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 150 })
            BlastText("/sytx296/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 180 })
            BlastText("/sytx297/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 120 })
            BlastText("/sytx298/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 120 })
            BlastText("/sytx299/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 180 })
            BlastText("/sytx300/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 180 })
            BlastText("/sytx301/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 150 })
        else
            BlastText("/sytx302/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 100 })
            BlastText("/sytx303/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 120 })
            BlastText("/sytx304/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 135 })
            BlastText("/sytx305/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 140, y = 155 })
            BlastText("/sytx306/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 135 })
            BlastText("/sytx307/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 520, y = 155 })
            BlastText("/sytx308/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 165 })
            BlastText("/sytx309/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 185 })
        end
    elseif MarioControl then
        BlastText("/sytx293/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 125 })
        BlastText("/sytx294/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 155 })
        BlastText("/sytx295/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 155 })
        BlastText("/sytx296/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 185 })
        BlastText("/sytx297/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 125 })
        BlastText("/sytx298/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 125 })
        BlastText("/sytx299/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 185 })
        BlastText("/sytx300/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 185 })
        BlastText("/sytx301/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 155 })
    else
        BlastText("/sytx302/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 105 })
        BlastText("/sytx303/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 125 })
        BlastText("/sytx304/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 175, y = 145 })
        BlastText("/sytx305/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 175, y = 165 })
        BlastText("/sytx306/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 455, y = 145 })
        BlastText("/sytx307/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 455, y = 165 })
        BlastText("/sytx308/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 185 })
        BlastText("/sytx309/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 205 })
    end
    if system.language == "EN" then
        local1.x = 200
        local1.y = 220
        local2.x = 215
        local2.y = 220
    else
        local1.x = 200
        local1.y = 245
        local2.x = 215
        local2.y = 245
    end
    arg1:draw_item("/sytx310/", "/sytx554/", local1, local2)
    arg1:draw_item("/sytx311/", "/sytx555/", local1, local2)
    arg1:draw_item("/sytx312/", "/sytx556/", local1, local2)
    arg1:draw_item("/sytx313/", "/sytx557/", local1, local2)
    arg1:draw_item("/sytx314/", "/sytx558/", local1, local2)
    arg1:draw_item("/sytx315/", "/sytx559/", local1, local2)
    arg1:draw_item("/sytx316/", "/sytx560/", local1, local2)
    arg1:draw_item("/sytx317/", "/sytx561/", local1, local2)
    local1.y = local1.y + 15
    local2.y = local2.y + 15
    arg1:draw_item("/sytx318/", "/sytx562/", local1, local2)
    if system.language == "EN" then
        arg1:draw_item("/sytx319/", "/sytx563/", local1, local2)
        arg1:draw_item("/sytx320/", "/sytx564/", local1, local2)
    end
end
help_menu.display_gamepad_page = function(arg1) -- line 2214
    local local1 = { font = verb_font, fgcolor = arg1.key_color, rjustify = TRUE }
    local local2 = { font = verb_font, fgcolor = arg1.text_color, ljustify = TRUE }
    if MarioControl then
        BlastText("/sytx321/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 120 })
        BlastText("/sytx322/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 150 })
        BlastText("/sytx323/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 150 })
        BlastText("/sytx324/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 180 })
        BlastText("/sytx325/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 120 })
        BlastText("/sytx326/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 120 })
        BlastText("/sytx327/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 180 })
        BlastText("/sytx328/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 180 })
        BlastText("/sytx329/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 150 })
    else
        BlastText("/sytx330/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 100 })
        BlastText("/sytx331/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 120 })
        BlastText("/sytx332/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 140, y = 135 })
        BlastText("/sytx333/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 140, y = 160 })
        BlastText("/sytx334/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 520, y = 135 })
        BlastText("/sytx335/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 520, y = 160 })
        BlastText("/sytx336/", { font = verb_font, center = TRUE, fgcolor = arg1.key_color, x = 320, y = 160 })
        BlastText("/sytx337/", { font = verb_font, center = TRUE, fgcolor = arg1.text_color, x = 320, y = 185 })
    end
    local1.x = 160
    local1.y = 220
    local2.x = 175
    local2.y = 220
    arg1:draw_item("/sytx338/", "/sytx565/", local1, local2)
    arg1:draw_item("/sytx339/", "/sytx566/", local1, local2)
    arg1:draw_item("/sytx340/", "/sytx567/", local1, local2)
    arg1:draw_item("/sytx341/", "/sytx568/", local1, local2)
    arg1:draw_item("/sytx342/", "/sytx569/", local1, local2)
    arg1:draw_item("/sytx343/", "/sytx570/", local1, local2)
    arg1:draw_item("/sytx344/", "/sytx571/", local1, local2)
end
help_menu.display_inventory_page = function(arg1) -- line 2260
    local local1 = { font = verb_font, fgcolor = arg1.key_color, rjustify = TRUE }
    local local2 = { font = verb_font, fgcolor = arg1.text_color, ljustify = TRUE }
    local1.x = 200
    local1.y = 120
    local2.x = 215
    local2.y = 120
    arg1:draw_item("/sytx345/", "/sytx572/", local1, local2)
    arg1:draw_item("/sytx346/", "", local1, local2)
    local1.y = local1.y + 10
    local2.y = local2.y + 10
    arg1:draw_item("/sytx347/", "/sytx573/", local1, local2)
    local1.y = local1.y + 10 + arg1.line_height
    local2.y = local2.y + 10 + arg1.line_height
    arg1:draw_item("/sytx348/", "/sytx574/", local1, local2)
    local1.y = local1.y + 10 + arg1.line_height
    local2.y = local2.y + 10 + arg1.line_height
    arg1:draw_item("/sytx349/", "/sytx575/", local1, local2)
    arg1:draw_item("/sytx350/", "", local1, local2)
    local1.y = local1.y + 10
    local2.y = local2.y + 10
    arg1:draw_item("/sytx351/", "/sytx576/", local1, local2)
    arg1:draw_item("/sytx352/", "", local1, local2)
    local1.y = local1.y + 10
    local2.y = local2.y + 10
    arg1:draw_item("/sytx353/", "/sytx577/", local1, local2)
    arg1:draw_item("/sytx354/", "", local1, local2)
end
help_menu.draw_item = function(arg1, arg2, arg3, arg4, arg5) -- line 2303
    arg4.font = verb_font
    arg5.font = verb_font
    BlastText(arg2, arg4)
    BlastText(arg3, arg5)
    arg4.y = arg4.y + arg1.line_height
    arg5.y = arg5.y + arg1.line_height
end
help_menu.run = function(arg1) -- line 2312
    local local1, local2
    if not arg1.is_active then
        arg1.is_active = TRUE
        game_pauser:pause(TRUE, arg1, arg1)
        system.characterHandler = nil
        arg1:draw()
    end
end
help_menu.cancel = function(arg1, arg2) -- line 2325
    if arg1.is_active then
        if not arg2 then
            game_pauser:pause(FALSE)
        end
        arg1.is_active = FALSE
    end
end
help_menu.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 2335
    if control_map.OVERRIDE[arg2] or control_map.USE[arg2] or control_map.PICK_UP[arg2] and arg3 then
        arg1:cancel(TRUE)
        main_menu:run()
    elseif control_map.TURN_LEFT[arg2] and arg3 then
        single_start_script(arg1.prev_page, arg1)
    elseif control_map.TURN_RIGHT[arg2] and arg3 then
        single_start_script(arg1.next_page, arg1)
    end
end
help_menu.prev_page = function(arg1) -- line 2346
    local local1
    while get_generic_control_state("TURN_LEFT") do
        arg1.cur_page = arg1.cur_page - 1
        if arg1.cur_page < 1 then
            arg1.cur_page = 3
        end
        arg1:draw()
        local1 = 0
        while local1 < 1000 and get_generic_control_state("TURN_LEFT") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
help_menu.next_page = function(arg1) -- line 2364
    local local1
    while get_generic_control_state("TURN_RIGHT") do
        arg1.cur_page = arg1.cur_page + 1
        if arg1.cur_page > 3 then
            arg1.cur_page = 1
        end
        arg1:draw()
        local1 = 0
        while local1 < 1000 and get_generic_control_state("TURN_RIGHT") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
help_menu.userPaintHandler = function(arg1) -- line 2382
    arg1:draw()
end
PUZZLE_STATE_NUM_ENTRIES = 60
puzzle_state = { }
puzzle_state.clear = function(arg1) -- line 2392
    local local1
    local1 = 1
    while local1 <= PUZZLE_STATE_NUM_ENTRIES do
        arg1[local1] = FALSE
        local1 = local1 + 1
    end
end
puzzle_state.set_string = function(arg1, arg2) -- line 2401
    local local1
    local1 = 1
    while local1 <= PUZZLE_STATE_NUM_ENTRIES do
        if strsub(arg2, local1, local1) == "1" then
            arg1[local1] = TRUE
        else
            arg1[local1] = FALSE
        end
        local1 = local1 + 1
    end
end
puzzle_state.get_string = function(arg1) -- line 2414
    local local1, local2
    if arg1[1] then
        local2 = "1"
    else
        local2 = "0"
    end
    local1 = 2
    while local1 <= PUZZLE_STATE_NUM_ENTRIES do
        if arg1[local1] then
            local2 = local2 .. "1"
        else
            local2 = local2 .. "0"
        end
        local1 = local1 + 1
    end
    return local2
end
puzzle_state.get_empty_string = function(arg1) -- line 2435
    return strrep("0", PUZZLE_STATE_NUM_ENTRIES)
end
cur_puzzle_state = { }
cur_puzzle_state.parent = puzzle_state
SAVELOAD_MENU_SAVE_MODE = 0
SAVELOAD_MENU_LOAD_MODE = 1
SAVELOAD_MENU_ERASE_MODE = 2
SAVELOAD_MENU_SAVE_TEXT = "/sytx355/"
SAVELOAD_MENU_LOAD_TEXT = "/sytx356/"
SAVELOAD_MENU_ERASE_TEXT = "/sytx357/"
SAVELOAD_MENU_EDIT_TEXT = "/sytx358/"
SAVELOAD_MENU_SAVE_FAIL = "/sytx359/"
SAVELOAD_MENU_LOAD_FAIL = "/sytx360/"
SAVELOAD_MENU_NOGAMES_FAIL = "/sytx361/"
SAVELOAD_MENU_FAIL2 = "/sytx362/"
SAVELOAD_MENU_DISKFULL_FAIL = "/engn008/"
SAVELOAD_MENU_CONFIRM_ERASE1 = "/sytx363/"
SAVELOAD_MENU_CONFIRM_ERASE2 = "/sytx364/"
SAVELOAD_MENU_CONFIRM_ERASE = "/sytx365/"
SAVELOAD_MENU_CONFIRM_OVERWRITE1 = "/sytx366/"
SAVELOAD_MENU_CONFIRM_OVERWRITE2 = "/sytx367/"
SAVELOAD_MENU_CONFIRM_REPLACE = "/sytx368/"
SAVELOAD_MENU_CONFIRM_CANCEL = "/sytx369/"
SAVELOAD_MENU_CONFIRM_OK = "/sytx578/"
SAVELOAD_MENU_EMPTY_STRING = "/sytx370/"
SAVELOAD_MENU_NONAME_STRING = "/sytx371/"
SAVELOAD_MENU_MAX_SLOTS = 1000
SAVELOAD_SCREENSHOT_WIDTH = 250
SAVELOAD_SCREENSHOT_HEIGHT = 188
SAVELOAD_EDITLINE_MAX_WIDTH = 300
SAVELOAD_MENU_MIN_FREE_MEGS = 5
SAVELOAD_MENU_MAX_SCREENSHOTS = 10
saveload_menu = { }
saveload_menu.initialized = FALSE
saveload_menu.mode = nil
saveload_menu.is_valid = TRUE
saveload_menu.edit_line = { }
saveload_menu.edit_line.is_active = FALSE
saveload_menu.edit_line.printable_chars = "/sytx372/"
saveload_menu.init = function(arg1) -- line 2492
    if not arg1.initialized then
        arg1.initialized = TRUE
        arg1.bkgnd = GetImage("saveload_mural.bm")
        arg1.num_screenshots = 0
    end
end
saveload_menu.destroy = function(arg1) -- line 2500
    if arg1.initialized then
        arg1.initialized = FALSE
        arg1:free_screenshots()
        if arg1.menu then
            arg1.menu:destroy()
            arg1.menu = nil
        end
        if arg1.bkgnd then
            FreeImage(arg1.bkgnd)
            arg1.bkgnd = nil
        end
    end
end
saveload_menu.draw = function(arg1, arg2) -- line 2517
    local local1, local2, local3
    if arg1.is_active then
        CleanBuffer()
        if arg1.is_valid then
            arg1:draw_mural()
            local3 = { x = 320, y = 5, font = verb_font, fgcolor = OptionsColor, center = TRUE }
            if arg1.mode == SAVELOAD_MENU_ERASE_MODE then
                BlastText(SAVELOAD_MENU_ERASE_TEXT, local3)
            elseif arg1.mode == SAVELOAD_MENU_SAVE_MODE then
                if arg1.edit_line.is_active then
                    BlastText(SAVELOAD_MENU_EDIT_TEXT, local3)
                else
                    BlastText(SAVELOAD_MENU_SAVE_TEXT, local3)
                end
            else
                BlastText(SAVELOAD_MENU_LOAD_TEXT, local3)
            end
            arg1.menu:draw()
            arg1:draw_edit_line(TRUE)
            if arg1.menu.cur_item ~= arg1.exit_index then
                arg1:load_screenshot(arg1.menu.cur_item)
                local2 = arg1.menu.items[arg1.menu.cur_item].screenshot
                if local2 then
                    BlastImage(local2, 360, 250)
                else
                    PrintDebug("Couldn't load screenshot for item " .. arg1.menu.cur_item .. "!\n")
                end
            end
        end
        if not arg2 then
            Display()
        end
    end
end
saveload_menu.draw_mural = function(arg1) -- line 2565
    local local1 = arg1.menu.cur_item
    local local2
    if not arg1.bkgnd then
        arg1.bkgnd = GetImage("saveload_mural.bm")
    end
    BlastImage(arg1.bkgnd, 0, 0)
    if arg1.menu.items[local1] then
        if arg1.menu.items[local1].saveTable then
            local2 = arg1.menu.items[local1].saveTable[1]
        end
    end
    if not local2 then
        local2 = puzzle_state:get_empty_string()
    end
    muralstate:draw(local2)
end
saveload_menu.draw_edit_line = function(arg1, arg2) -- line 2586
    local local1, local2, local3, local4
    if arg1.edit_line.is_active then
        local4 = arg1.menu.cur_item
        local2 = arg1.menu.default_props.x
        local3 = arg1.menu.items[local4].props.y + 8
        BlastRect(local2, local3, local2 + SAVELOAD_EDITLINE_MAX_WIDTH + 18, local3 + 20, { color = Black, filled = TRUE })
        if arg1.edit_line.cursor then
            local1 = arg1.edit_line.text .. "_"
        else
            local1 = arg1.edit_line.text .. "\182"
        end
        arg1.edit_line.props.font = verb_font
        BlastText(local1, arg1.edit_line.props)
        if not arg2 then
            Display()
        end
    end
end
saveload_menu.flash_cursor = function(arg1) -- line 2609
    if arg1.edit_line then
        while arg1.edit_line.is_active do
            sleep_for(300)
            arg1.edit_line.cursor = FALSE
            arg1:draw_edit_line()
            sleep_for(300)
            arg1.edit_line.cursor = TRUE
            arg1:draw_edit_line()
        end
    end
end
saveload_menu.build_menu = function(arg1) -- line 2622
    local local1, local2, local3, local4, local5, local6
    local local7
    local local8
    local8 = ReadRegistryValue("LastSavedGame")
    if arg1.menu then
        arg1:free_screenshots()
        arg1.menu:destroy()
    end
    arg1.menu = menu_object:create({ x = 30, y = 250 }, arg1)
    arg1.menu.visible_items = 9
    local7 = 1
    local1 = arg1:get_file_list()
    local6, local2 = next(local1, nil)
    while local6 ~= nil do
        local3 = GetSaveGameData(local2)
        if not local3 then
            local3 = { }
            PrintDebug("Couldn't read SaveGameData from " .. local2 .. "!\n")
        end
        if not local3[0] then
            local3[0] = trim_header(LocalizeString(SAVELOAD_MENU_NONAME_STRING))
        end
        if not local3[1] then
            local3[1] = puzzle_state:get_empty_string()
        end
        local5 = arg1.menu:add_item(local3[0])
        arg1.menu.items[local5].saveTable = local3
        arg1.menu.items[local5].fname = local2
        if local2 == local8 then
            local7 = local5
        end
        arg1.menu.items[local5].slotNumber = arg1:get_savegame_slot_number(local2)
        arg1.menu.items[local5].empty = FALSE
        if arg1.num_screenshots < SAVELOAD_MENU_MAX_SCREENSHOTS - 1 then
            arg1.menu.items[local5].screenshot = GetSaveGameImage(local2)
            arg1.num_screenshots = arg1.num_screenshots + 1
        end
        local6, local2 = next(local1, local6)
    end
    if arg1.mode == SAVELOAD_MENU_SAVE_MODE then
        local5 = arg1.menu:add_item(SAVELOAD_MENU_EMPTY_STRING)
        arg1.menu.items[local5].saveTable = { }
        arg1.menu.items[local5].saveTable[0] = SAVELOAD_MENU_EMPTY_STRING
        arg1.menu.items[local5].saveTable[1] = cur_puzzle_state:get_string()
        local4, local2 = arg1:find_empty_slot()
        arg1.menu.items[local5].fname = local2
        arg1.menu.items[local5].slotNumber = local4
        arg1.menu.items[local5].empty = TRUE
        arg1.menu.items[local5].screenshot = ScreenShot(SAVELOAD_SCREENSHOT_WIDTH, SAVELOAD_SCREENSHOT_HEIGHT)
        arg1.num_screenshots = arg1.num_screenshots + 1
        local7 = local5
    end
    arg1.menu:add_item("", { disabled = TRUE })
    arg1.exit_index = arg1.menu:add_item("/sytx373/")
    arg1.menu:set_cur_item(local7)
end
saveload_menu.get_file_list = function(arg1) -- line 2692
    local local1 = { }
    local local2, local3, local4, local5
    fname = FileFindFirst("*.gsv", ".")
    local3 = 0
    while fname ~= nil do
        PrintDebug("Found Savegame: " .. fname .. "\n")
        local1[local3] = fname
        local3 = local3 + 1
        fname = FileFindNext()
    end
    FileFindDispose()
    local4 = 0
    while local4 < local3 do
        local5 = local4
        while local5 < local3 and local1[local5 + 1] ~= nil do
            if local1[local5] > local1[local5 + 1] then
                local2 = local1[local5 + 1]
                local1[local5 + 1] = local1[local5]
                local1[local5] = local2
            end
            local5 = local5 + 1
        end
        local4 = local4 + 1
    end
    return local1, local3
end
saveload_menu.run = function(arg1, arg2) -- line 2725
    local local1, local2
    if not arg1.is_active then
        if not arg2 then
            arg2 = SAVELOAD_MENU_LOAD_MODE
        end
        if not arg1.initialized then
            arg1:init()
        end
        arg1.is_active = TRUE
        arg1.mode = arg2
        arg1.is_valid = FALSE
        arg1:build_menu()
        if arg2 ~= SAVELOAD_MENU_SAVE_MODE and arg1.menu.num_items < 3 then
            arg1:no_saved_games_msg()
        elseif arg2 == SAVELOAD_MENU_SAVE_MODE and GetDiskFreeSpace() <= SAVELOAD_MENU_MIN_FREE_MEGS then
            arg1:disk_full_msg()
        else
            arg1.is_valid = TRUE
            game_pauser:pause(TRUE, arg1, arg1)
            system.characterHandler = arg1
            arg1:draw()
        end
    end
end
saveload_menu.cancel = function(arg1, arg2) -- line 2757
    if arg1.is_active then
        if not arg2 then
            game_pauser:pause(FALSE)
        end
        arg1.is_active = FALSE
        arg1.mode = nil
        system.characterHandler = nil
        arg1:destroy()
    end
end
saveload_menu.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 2772
    local local1 = FALSE
    if not arg1.edit_line.is_active then
        local1 = arg1.menu:buttonHandler(arg2, arg3, arg4)
        if not local1 then
            if control_map.OVERRIDE[arg2] and arg3 then
                arg1:return_to_main()
            elseif control_map.DIALOG_CHOOSE[arg2] and arg3 then
                if arg1.menu.cur_item == arg1.exit_index then
                    arg1:return_to_main()
                elseif arg1.mode == SAVELOAD_MENU_SAVE_MODE then
                    start_script(arg1.begin_save_game, arg1)
                elseif arg1.mode == SAVELOAD_MENU_LOAD_MODE then
                    start_script(arg1.load_game, arg1)
                elseif arg1.mode == SAVELOAD_MENU_ERASE_MODE then
                    start_script(arg1.confirm_erase_game, arg1)
                end
            end
        end
    else
        local1 = arg1:edit_line_button_handler(arg2, arg3, arg4)
    end
    if local1 then
        arg1:draw()
    end
end
saveload_menu.edit_line_button_handler = function(arg1, arg2, arg3, arg4) -- line 2801
    local local1
    local local2 = FALSE
    local1 = arg1.menu.cur_item
    if control_map.OVERRIDE[arg2] and arg3 then
        start_script(arg1.confirm_save_game, arg1, FALSE)
        local2 = TRUE
    elseif control_map.DIALOG_CHOOSE[arg2] and arg3 then
        start_script(arg1.confirm_save_game, arg1, TRUE)
    elseif arg2 == BSKEY and arg3 then
        single_start_script(arg1.backspace, arg1)
    end
    return local2
end
saveload_menu.backspace = function(arg1) -- line 2819
    local local1, local2
    local1 = strlen(arg1.edit_line.text)
    if local1 > 0 then
        arg1.edit_line.text = strsub(arg1.edit_line.text, 1, local1 - 1)
        local1 = local1 - 1
        arg1:draw_edit_line()
        local2 = 0
        while local2 < 500 and GetControlState(BSKEY) do
            break_here()
            local2 = local2 + system.frameTime
        end
        while local1 > 0 and GetControlState(BSKEY) do
            arg1.edit_line.text = strsub(arg1.edit_line.text, 1, local1 - 1)
            local1 = local1 - 1
            arg1:draw_edit_line()
            local2 = 0
            while local2 < 100 and GetControlState(BSKEY) do
                break_here()
                local2 = local2 + system.frameTime
            end
        end
    end
end
saveload_menu.characterHandler = function(arg1, arg2) -- line 2845
    local local1, local2, local3, local4
    local local5, local6
    if arg1.edit_line.is_active then
        local6 = trim_header(LocalizeString(arg1.edit_line.printable_chars))
        if strfind(local6, arg2, 1, TRUE) then
            local1 = arg1.edit_line.text .. arg2
            local2 = MakeTextObject(local1, { x = 0, y = 500, font = verb_font, ljustify = TRUE })
            local3, local4 = GetTextObjectDimensions(local2)
            if local3 <= SAVELOAD_EDITLINE_MAX_WIDTH then
                arg1.edit_line.text = local1
                arg1:draw_edit_line()
            end
            KillTextObject(local2)
            local2 = nil
            return TRUE
        end
    else
        local5 = arg1.menu:characterHandler(arg2)
        if local5 then
            arg1:return_to_main()
        end
    end
    return nil
end
saveload_menu.begin_save_game = function(arg1) -- line 2874
    local local1 = arg1.menu.cur_item
    if arg1.menu.items[local1].empty then
        arg1.edit_line.text = ""
    else
        arg1.edit_line.text = arg1.menu.items[local1].text
    end
    arg1.edit_line.props = copy_table(arg1.menu.items[local1].props)
    arg1.edit_line.props.fgcolor = White
    arg1.edit_line.default_text = arg1.edit_line.text
    arg1.edit_line.is_active = TRUE
    arg1.edit_line.cursor = TRUE
    arg1.menu.items[local1].text = ""
    start_script(arg1.flash_cursor, arg1)
    arg1:draw()
    arg1:draw()
end
saveload_menu.confirm_save_game = function(arg1, arg2) -- line 2894
    local local1 = arg1.menu.cur_item
    arg1.edit_line.is_active = FALSE
    stop_script(arg1.flash_cursor)
    if not arg2 then
        if arg1.edit_line.default_text == "" then
            arg1.menu.items[local1].text = SAVELOAD_MENU_EMPTY_STRING
        else
            arg1.menu.items[local1].text = arg1.edit_line.default_text
        end
        arg1:draw()
    else
        if strlen(arg1.edit_line.text) == 0 then
            arg1.edit_line.text = trim_header(LocalizeString(SAVELOAD_MENU_NONAME_STRING))
        end
        arg1.menu.items[local1].text = arg1.edit_line.text
        if not arg1.menu.items[local1].empty then
            overwrite_query = query_mode:create(MODE_QUERY, ORIENTATION_HORIZ)
            overwrite_query.caption = SAVELOAD_MENU_CONFIRM_OVERWRITE1
            overwrite_query.prompt = SAVELOAD_MENU_CONFIRM_OVERWRITE2
            overwrite_query.choices[0] = { text = SAVELOAD_MENU_CONFIRM_REPLACE, x = 260, y = 160 }
            overwrite_query.choices[0].action_script = arg1.finish_save_game
            overwrite_query.choices[0].action_table = arg1
            overwrite_query.choices[1] = { text = SAVELOAD_MENU_CONFIRM_CANCEL, x = 380, y = 160 }
            overwrite_query.choices[1].action_script = arg1.cancel_save_game
            overwrite_query.choices[1].action_table = arg1
            overwrite_query.default_choice = 1
            overwrite_query.overlay_menu = arg1
            start_script(overwrite_query.run, overwrite_query)
        else
            arg1:finish_save_game()
        end
    end
end
saveload_menu.finish_save_game = function(arg1) -- line 2937
    local local1 = arg1.menu.cur_item
    local local2
    if overwrite_query then
        overwrite_query:destroy()
        overwrite_query = nil
    end
    local2 = format("grimlog%02d.htm", arg1.menu.items[local1].slotNumber)
    dialog_log:copy_to(local2)
    arg1:free_screenshots()
    main_menu:destroy()
    main_menu:free_logo()
    if arg1.bkgnd then
        FreeImage(arg1.bkgnd)
        arg1.bkgnd = nil
    end
    arg1.menu.items[local1].text = arg1.edit_line.text
    arg1.menu.items[local1].saveTable[0] = arg1.edit_line.text
    arg1.menu.items[local1].saveTable[1] = cur_puzzle_state:get_string()
    arg1.menu.items[local1].saveTable[2] = system.currentSet.setFile
    JustLoaded()
    PrintDebug("Saving game as " .. arg1.menu.items[local1].fname .. "\n")
    Save(arg1.menu.items[local1].fname)
    break_here()
    break_here()
    if JustLoaded() then
        system_prefs:init()
        if music_state.paused then
            ImSetSfxVol(0)
        end
    end
    WriteRegistryValue("LastSavedGame", arg1.menu.items[local1].fname)
    arg1:cancel()
end
saveload_menu.cancel_save_game = function(arg1) -- line 2985
    local local1 = arg1.menu.cur_item
    arg1.menu.items[local1].text = arg1.edit_line.default_text
    arg1:draw()
end
saveload_menu.load_game = function(arg1) -- line 2992
    local local1 = arg1.menu.cur_item
    local local2
    if not arg1.menu.items[local1].empty and arg1.menu.items[local1].fname ~= nil then
        local2 = CheckForCD(arg1.menu.items[local1].saveTable[2], nil, arg1)
        if local2 then
            arg1:free_screenshots()
            main_menu:destroy()
            if arg1.bkgnd then
                FreeImage(arg1.bkgnd)
                arg1.bkgnd = nil
            end
            logname = format("grimlog%02d.htm", arg1.menu.items[local1].slotNumber)
            dialog_log:copy_from(logname)
            Load(arg1.menu.items[local1].fname)
            break_here()
            loaderror_query = query_mode:create(MODE_MESSAGE, ORIENTATION_HORIZ)
            loaderror_query.caption = SAVELOAD_MENU_LOAD_FAIL
            loaderror_query.prompt = SAVELOAD_MENU_FAIL2
            loaderror_query.overlay_menu = arg1
            loaderror_query.action_script = arg1.return_to_main
            loaderror_query.action_table = arg1
            start_script(loaderror_query.run, loaderror_query)
        else
            arg1:cancel(FALSE)
            arg1:run(SAVELOAD_MENU_LOAD_MODE)
        end
    end
end
saveload_menu.confirm_erase_game = function(arg1) -- line 3045
    local local1 = arg1.menu.cur_item
    if not arg1.menu.items[local1].empty and arg1.menu.items[local1].fname ~= nil then
        erase_query = query_mode:create(MODE_QUERY, ORIENTATION_HORIZ)
        erase_query.caption = SAVELOAD_MENU_CONFIRM_ERASE1
        erase_query.prompt = SAVELOAD_MENU_CONFIRM_ERASE2
        erase_query.choices[0] = { text = SAVELOAD_MENU_CONFIRM_ERASE, x = 260, y = 160 }
        erase_query.choices[0].action_script = arg1.erase_game
        erase_query.choices[0].action_table = arg1
        erase_query.choices[1] = { text = SAVELOAD_MENU_CONFIRM_CANCEL, x = 380, y = 160 }
        erase_query.choices[1].action_script = nil
        erase_query.default_choice = 1
        erase_query.overlay_menu = arg1
        start_script(erase_query.run, erase_query)
    end
end
saveload_menu.erase_game = function(arg1) -- line 3067
    local local1 = arg1.menu.cur_item
    local local2, local3
    local local4
    if erase_query then
        erase_query:destroy()
        erase_query = nil
    end
    PrintDebug("Deleting " .. arg1.menu.items[local1].fname .. "\n")
    local4 = format("grimlog%02d.htm", arg1.menu.items[local1].slotNumber)
    local2, local3 = remove(local4)
    if not local2 then
        PrintDebug("Could not delete - " .. errStr .. "\n")
    end
    local2, local3 = remove(arg1.menu.items[local1].fname)
    if not local2 then
        PrintDebug("Could not delete - " .. local3 .. "\n")
    end
    arg1:build_menu()
    if arg1.menu.num_items < 3 then
        arg1:return_to_main()
    else
        arg1:draw()
    end
end
saveload_menu.no_saved_games_msg = function(arg1) -- line 3098
    nogames_query = query_mode:create(MODE_MESSAGE, ORIENTATION_HORIZ)
    nogames_query.caption = SAVELOAD_MENU_NOGAMES_FAIL
    nogames_query.prompt = SAVELOAD_MENU_FAIL2
    nogames_query.overlay_menu = arg1
    nogames_query.action_script = arg1.return_to_main
    nogames_query.action_table = arg1
    start_script(nogames_query.run, nogames_query)
end
saveload_menu.disk_full_msg = function(arg1) -- line 3111
    diskfull_query = query_mode:create(MODE_MESSAGE, ORIENTATION_HORIZ)
    diskfull_query.caption = SAVELOAD_MENU_DISKFULL_FAIL
    diskfull_query.prompt = SAVELOAD_MENU_FAIL2
    diskfull_query.overlay_menu = arg1
    diskfull_query.action_script = arg1.return_to_main
    diskfull_query.action_table = arg1
    start_script(diskfull_query.run, diskfull_query)
end
saveload_menu.return_to_main = function(arg1) -- line 3124
    arg1:cancel(TRUE)
    arg1:destroy()
    main_menu:run()
end
saveload_menu.get_savegame_slot_number = function(arg1, arg2) -- line 3130
    local local1 = 0
    local local2, local3
    local2 = strfind(arg2, ".", 5, TRUE)
    if local2 then
        local3 = strsub(arg2, 5, local2 - 1)
        local1 = tonumber(local3)
    end
    return local1
end
saveload_menu.find_empty_slot = function(arg1) -- line 3143
    local local1, local2, local3
    local1 = 0
    local3 = format("grim%02d.gsv", local1)
    local2 = FileFindFirst(local3, ".")
    FileFindDispose()
    while local1 < SAVELOAD_MENU_MAX_SLOTS and local2 ~= nil do
        local3 = format("grim%02d.gsv", local1)
        local2 = FileFindFirst(local3, ".")
        FileFindDispose()
        if local2 then
            local1 = local1 + 1
        end
    end
    if local1 >= SAVELOAD_MENU_MAX_SLOTS then
        return nil
    else
        return local1, local3
    end
end
saveload_menu.load_screenshot = function(arg1, arg2) -- line 3166
    local local1, local2
    if arg1.menu.items[arg2].screenshot == nil and not arg1.menu.items[arg2].empty and arg2 ~= arg1.exit_index then
        local1 = 1
        while local1 <= arg1.menu.num_items and arg1.num_screenshots >= SAVELOAD_MENU_MAX_SCREENSHOTS do
            if arg1.menu.items[local1].screenshot then
                FreeImage(arg1.menu.items[local1].screenshot)
                arg1.menu.items[local1].screenshot = nil
                arg1.num_screenshots = arg1.num_screenshots - 1
            end
            local1 = local1 + 1
        end
        arg1.menu.items[arg2].screenshot = GetSaveGameImage(arg1.menu.items[arg2].fname)
        arg1.num_screenshots = arg1.num_screenshots + 1
    end
end
saveload_menu.free_screenshots = function(arg1) -- line 3186
    local local1
    if arg1.menu then
        local1 = 1
        while local1 <= arg1.menu.num_items do
            if arg1.menu.items[local1].screenshot then
                FreeImage(arg1.menu.items[local1].screenshot)
                arg1.menu.items[local1].screenshot = nil
            end
            local1 = local1 + 1
        end
    end
    arg1.num_screenshots = 0
end
save_game_callback = function() -- line 3201
    local local1
    if critical_saveload_menu.is_active then
        local1 = critical_saveload_menu.menu.cur_item
        SubmitSaveGameData(critical_saveload_menu.menu.items[local1].saveTable)
    elseif saveload_menu.is_active then
        local1 = saveload_menu.menu.cur_item
        SubmitSaveGameData(saveload_menu.menu.items[local1].saveTable)
    end
end
system.saveGameCallback = save_game_callback
saveload_menu.userPaintHandler = function(arg1) -- line 3216
    arg1:draw()
end
critical_saveload_menu = { }
critical_saveload_menu.parent = saveload_menu
critical_saveload_menu.initialized = FALSE
critical_saveload_menu.mode = nil
critical_saveload_menu.num_screenshots = 0
critical_saveload_menu.build_menu = function(arg1) -- line 3228
    saveload_menu.build_menu(arg1)
    arg1.menu.items[arg1.exit_index].text = SAVELOAD_MENU_CONFIRM_CANCEL
end
critical_saveload_menu.return_to_main = function(arg1) -- line 3233
    arg1:cancel(TRUE)
    arg1:destroy()
end
critical_saveload_menu.finish_save_game = function(arg1) -- line 3238
    local local1 = arg1.menu.cur_item
    local local2
    if overwrite_query then
        overwrite_query:destroy()
        overwrite_query = nil
    end
    local2 = format("grimlog%02d.htm", arg1.menu.items[local1].slotNumber)
    dialog_log:copy_to(local2)
    arg1:free_screenshots()
    main_menu:destroy()
    main_menu:free_logo()
    if arg1.bkgnd then
        FreeImage(arg1.bkgnd)
        arg1.bkgnd = nil
    end
    arg1.menu.items[local1].text = arg1.edit_line.text
    arg1.menu.items[local1].saveTable[0] = arg1.edit_line.text
    arg1.menu.items[local1].saveTable[1] = cur_puzzle_state:get_string()
    arg1.menu.items[local1].saveTable[2] = system.currentSet.setFile
    PrintDebug("Saving game as " .. arg1.menu.items[local1].fname .. "\n")
    Save(arg1.menu.items[local1].fname)
    break_here()
    break_here()
    WriteRegistryValue("LastSavedGame", arg1.menu.items[local1].fname)
    arg1:cancel()
    arg1:destroy()
end
CUTSCENE_MENU_TITLE = "/sytx374/"
CUTSCENE_MENU_HELP_TEXT = MAIN_MENU_HELP_TEXT
cutscene_menu = { }
cutscene_menu.initialized = FALSE
cutscene_menu.cutscenes = { }
cutscene_menu.cutscenes[0] = { name = "intro", text = "/sytx375/", enabled = TRUE, disk = 1 }
cutscene_menu.cutscenes[1] = { name = "lol", text = "/sytx376/", disk = 1 }
cutscene_menu.cutscenes[2] = { name = "brunopk", text = "/sytx377/", disk = 1 }
cutscene_menu.cutscenes[3] = { name = "repmec1c", text = "/sytx378/", disk = 1 }
cutscene_menu.cutscenes[4] = { name = "repmec3c", text = "/sytx379/", disk = 1 }
cutscene_menu.cutscenes[5] = { name = "lsahq", text = "/sytx380/", disk = 1 }
cutscene_menu.cutscenes[6] = { name = "stump1c", text = "/sytx381/", disk = 1 }
cutscene_menu.cutscenes[7] = { name = "stump3c", text = "/sytx382/", disk = 1 }
cutscene_menu.cutscenes[8] = { name = "copaldie", text = "/sytx383/", disk = 1 }
cutscene_menu.cutscenes[9] = { name = "getshcks", text = "/sytx384/", disk = 1 }
cutscene_menu.cutscenes[10] = { name = "heloruba", text = "/sytx385/", disk = 1 }
cutscene_menu.cutscenes[11] = { name = "plunge", text = "/sytx386/", disk = 1 }
cutscene_menu.cutscenes[12] = { name = "yr2intro", text = "/sytx387/", disk = 1 }
cutscene_menu.cutscenes[13] = { name = "shanghai", text = "/sytx388/", disk = 2 }
cutscene_menu.cutscenes[14] = { name = "normarae", text = "/sytx389/", disk = 2 }
cutscene_menu.cutscenes[15] = { name = "loladies", text = "/sytx390/", disk = 2 }
cutscene_menu.cutscenes[16] = { name = "byeruba", text = "/sytx391/", disk = 2 }
cutscene_menu.cutscenes[17] = { name = "escape", text = "/sytx392/", disk = 1 }
cutscene_menu.cutscenes[18] = { name = "thepearl", text = "/sytx393/", disk = 1 }
cutscene_menu.cutscenes[19] = { name = "subsaway", text = "/sytx394/", disk = 1 }
cutscene_menu.cutscenes[20] = { name = "reunion", text = "/sytx395/", disk = 1 }
cutscene_menu.cutscenes[21] = { name = "stocking", text = "/sytx396/", disk = 1 }
cutscene_menu.cutscenes[22] = { name = "hostage", text = "/sytx397/", disk = 1 }
cutscene_menu.cutscenes[23] = { name = "lamancha", text = "/sytx398/", disk = 1 }
cutscene_menu.cutscenes[24] = { name = "poseidon", text = "/sytx399/", disk = 1 }
cutscene_menu.cutscenes[25] = { name = "exodus", text = "/sytx400/", disk = 1 }
cutscene_menu.cutscenes[26] = { name = "crushed", text = "/sytx401/", disk = 1 }
cutscene_menu.cutscenes[27] = { name = "heltrain", text = "/sytx402/", disk = 2 }
cutscene_menu.cutscenes[28] = { name = "coffrock", text = "/sytx403/", disk = 2 }
cutscene_menu.cutscenes[29] = { name = "vivamaro", text = "/sytx404/", disk = 2 }
cutscene_menu.cutscenes[30] = { name = "eatbird", text = "/sytx405/", disk = 2 }
cutscene_menu.cutscenes[31] = { name = "oldjob", text = "/sytx406/", disk = 2 }
cutscene_menu.cutscenes[32] = { name = "neonlady", text = "/sytx407/", disk = 2 }
cutscene_menu.cutscenes[33] = { name = "falling", text = "/sytx408/", disk = 2 }
cutscene_menu.cutscenes[34] = { name = "eldepot", text = "/sytx409/", disk = 2 }
cutscene_menu.cutscenes[35] = { name = "greenhse", text = "/sytx410/", disk = 2 }
cutscene_menu.cutscenes[36] = { name = "mnycutfl", text = "/sytx411/", disk = 2 }
cutscene_menu.cutscenes[37] = { name = "hecgetit", text = "/sytx412/", disk = 2 }
cutscene_menu.cutscenes[38] = { name = "hecdie", text = "/sytx413/", disk = 2 }
cutscene_menu.cutscenes[39] = { name = "byebye", text = "/sytx414/", disk = 2 }
get_cd_prompt_for_snm = function(arg1) -- line 3332
    local local1, local2, local3
    local local4
    local1 = strfind(arg1, ".snm")
    if local1 then
        local3 = strsub(arg1, 1, local1 - 1)
        local1, local2 = next(cutscene_menu.cutscenes, nil)
        while local1 and not local4 do
            if local2 and local2.name == local3 then
                if local2.disk == 1 then
                    local4 = PROMPT_FOR_CD_A
                else
                    local4 = PROMPT_FOR_CD_B
                end
            end
            local1, local2 = next(cutscene_menu.cutscenes, local1)
        end
    end
    return local4
end
cutscene_menu.init = function(arg1) -- line 3355
    local local1
    if not arg1.initialized then
        arg1:rebuild_menu()
        arg1.initialized = TRUE
    end
end
cutscene_menu.rebuild_menu = function(arg1) -- line 3365
    local local1
    if arg1.menu then
        arg1.menu:destroy()
    end
    arg1.menu = menu_object:create({ x = 60, y = 125 }, arg1)
    arg1.menu.visible_items = 15
    i = 0
    while arg1.cutscenes[i] do
        if arg1.cutscenes[i].enabled then
            local1 = arg1.menu:add_item(arg1.cutscenes[i].text)
            arg1.menu.items[local1].fname = arg1.cutscenes[i].name .. ".snm"
            arg1.menu.items[local1].disk = arg1.cutscenes[i].disk
        end
        i = i + 1
    end
    arg1.menu:add_item("", { disabled = TRUE })
    arg1.exit_menu_item = arg1.menu:add_item("/sytx415/")
end
cutscene_menu.destroy = function(arg1) -- line 3390
    if arg1.initialized then
        arg1.initialized = FALSE
        arg1.menu:destroy()
        arg1.menu = nil
    end
end
cutscene_menu.draw = function(arg1, arg2) -- line 3399
    local local1, local2
    if arg1.is_active then
        CleanBuffer()
        BlastImage(main_menu.logo, 0, 0, TRUE)
        BlastMultipleLines(CUTSCENE_MENU_TITLE, { x = 190, y = 10, font = verb_font, fgcolor = White }, CUTSCENE_MENU_HELP_TEXT, { x = 190, y = 30, ljustify = TRUE, font = verb_font, fgcolor = OptionsColor })
        arg1.menu:draw()
        if not arg2 then
            Display()
        end
    end
end
cutscene_menu.run = function(arg1) -- line 3417
    local local1, local2
    if not arg1.is_active then
        if not arg1.initialized then
            arg1:init()
        else
            arg1:rebuild_menu()
        end
        arg1.is_active = TRUE
        game_pauser:pause(TRUE, arg1, arg1)
        system.characterHandler = arg1
        arg1:draw()
    end
end
cutscene_menu.cancel = function(arg1, arg2) -- line 3436
    if arg1.is_active then
        if not arg2 then
            game_pauser:pause(FALSE)
        end
        system.characterHandler = nil
        arg1:destroy()
        arg1.is_active = FALSE
    end
end
cutscene_menu.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 3449
    local local1 = FALSE
    local1 = arg1.menu:buttonHandler(arg2, arg3, arg4)
    if not local1 then
        if control_map.OVERRIDE[arg2] and arg3 then
            arg1:cancel(TRUE)
            main_menu:run()
        elseif control_map.DIALOG_CHOOSE[arg2] and arg3 then
            arg1:choose_item(arg1.menu.cur_item)
        elseif developerMode and arg2 == AKEY then
            arg1:enable_all()
        end
    end
    if local1 then
        arg1:draw()
    end
end
cutscene_menu.characterHandler = function(arg1, arg2) -- line 3469
    local local1 = FALSE
    local1 = arg1.menu:characterHandler(arg2)
    if local1 then
        arg1:draw()
        arg1:choose_item(arg1.menu.cur_item)
    end
end
cutscene_menu.choose_item = function(arg1, arg2) -- line 3479
    if arg2 == arg1.exit_menu_item then
        arg1:cancel(TRUE)
        main_menu:run()
    else
        start_script(arg1.view_cutscene, arg1, arg2)
    end
end
cutscene_menu.view_cutscene = function(arg1, arg2) -- line 3488
    local local1, local2
    if arg1.is_active then
        local1 = arg1.menu.items[arg2]
        if local1 and local1.fname then
            local2 = local1.fname
            if CheckForCD(local2, FALSE, arg1) then
                system.buttonHandler = cutscene_menu_view_button_handler
                system.pauseHandler = nil
                system.characterHandler = nil
                PauseMovie(FALSE)
                StopMovie()
                RenderModeUser(nil)
                RunFullscreenMovie(local2)
                wait_for_movie()
                StopMovie()
                RenderModeUser(TRUE)
            end
            system.buttonHandler = arg1
            system.pauseHandler = query_pause_game
            system.characterHandler = arg1
            main_menu:load_logo()
            arg1:draw()
        end
    end
end
cutscene_menu.skip_movie = function(arg1) -- line 3522
    system.buttonHandler = arg1
    system.pauseHandler = query_pause_game
    system.characterHandler = arg1
    StopMovie()
    wait_for_movie()
    RenderModeUser(TRUE)
    arg1:draw()
end
cutscene_menu.enable_cutscene = function(arg1, arg2) -- line 3534
    local local1, local2, local3
    local1, local2 = next(arg1.cutscenes, nil)
    while local1 do
        if type(local2) == "table" then
            local3 = arg2
            if local3 then
                local3 = strlower(local3)
                local3 = gsub(local3, ".snm", "")
            end
            if strlower(local2.name) == local3 then
                local2.enabled = TRUE
                dialog_log:log_cut_scene(local2.text)
            end
        end
        local1, local2 = next(arg1.cutscenes, local1)
    end
end
cutscene_menu.enable_all = function(arg1) -- line 3555
    local local1, local2
    local1, local2 = next(arg1.cutscenes, nil)
    while local1 do
        local2.enabled = TRUE
        local1, local2 = next(arg1.cutscenes, local1)
    end
    arg1:rebuild_menu()
    arg1:draw()
end
cutscene_menu_view_button_handler = function(arg1, arg2, arg3) -- line 3567
    if control_map.OVERRIDE[arg1] and arg2 then
        start_script(cutscene_menu.skip_movie, cutscene_menu)
    end
end
cutscene_menu.userPaintHandler = function(arg1) -- line 3573
    arg1:draw()
end
gauge_object = { }
gauge_object.create = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- line 3582
    local local1 = { }
    local1.parent = arg1
    if arg7 then
        local1.min_value = arg7
    else
        local1.min_value = 0
    end
    if arg8 then
        local1.max_value = arg8
    else
        local1.max_value = 127
    end
    local1.value = local1.min_value
    local1.x = arg2
    local1.y = arg3
    local1.width = arg4
    local1.height = arg5
    local1.bTextOnly = arg6
    local1.increment = 1
    local1.value_text = { }
    local1.fgcolor = OptionsColor
    local1.light_color = Yellow
    local1.dark_color = Black
    local1.dim_fgcolor = OptionsMidColor
    local1.dim_light_color = OptionsDarkColor
    local1.dim_dark_color = Black
    local1.bActive = FALSE
    local1.y_offset = 10
    return local1
end
gauge_object.destroy = function(arg1) -- line 3620
    arg1.value_text = nil
end
gauge_object.draw = function(arg1) -- line 3624
    local local1, local2
    local local3, local4, local5
    if arg1.bActive then
        local3 = arg1.light_color
        local5 = arg1.dark_color
        local4 = arg1.fgcolor
    else
        local3 = arg1.dim_light_color
        local5 = arg1.dim_dark_color
        local4 = arg1.dim_fgcolor
    end
    if not arg1.bTextOnly then
        BlastRect(arg1.x, arg1.y + arg1.y_offset, arg1.x + arg1.width, arg1.y + arg1.y_offset + arg1.height, { color = local4, filled = FALSE })
        if arg1.max_value == arg1.min_value then
            local1 = 1
        else
            local1 = arg1.value / (arg1.max_value - arg1.min_value)
        end
        if local1 < 0.001 then
            BlastRect(arg1.x + 1, arg1.y + 1 + arg1.y_offset, arg1.x + arg1.width - 1, arg1.y + arg1.height - 1 + arg1.y_offset, { color = local5, filled = TRUE })
        elseif local1 >= 1 then
            BlastRect(arg1.x + 1, arg1.y + 1 + arg1.y_offset, arg1.x + arg1.width - 1, arg1.y + arg1.height - 1 + arg1.y_offset, { color = local3, filled = TRUE })
        else
            local1 = local1 * (arg1.width - 2)
            BlastRect(arg1.x + 1, arg1.y + 1 + arg1.y_offset, arg1.x + 1 + local1, arg1.y + arg1.height - 1 + arg1.y_offset, { color = local3, filled = TRUE })
            BlastRect(arg1.x + 2 + local1, arg1.y + 1 + arg1.y_offset, arg1.x + arg1.width - 1, arg1.y + arg1.height - 1 + arg1.y_offset, { color = local5, filled = TRUE })
        end
        BlastText(arg1:find_value_string(), { x = arg1.x + arg1.width + 10, y = arg1.y, font = verb_font, fgcolor = local4 })
    else
        BlastText(arg1:find_value_string(), { x = arg1.x, y = arg1.y, font = verb_font, fgcolor = local4 })
    end
end
gauge_object.find_value_string = function(arg1) -- line 3666
    local local1, local2, local3, local4, local5
    local5 = arg1.value_text[arg1.value]
    if not local5 then
        local1 = arg1.value
        local3 = nil
        while local1 >= arg1.min_value and local3 == nil do
            local3 = arg1.value_text[local1]
            if not local3 then
                local1 = local1 - 1
            end
        end
        local2 = arg1.value
        local4 = nil
        while local2 <= arg1.max_value and local4 == nil do
            local4 = arg1.value_text[local2]
            if not local4 then
                local2 = local2 + 1
            end
        end
        if local3 and local4 then
            if abs(local1 - arg1.value) < abs(local2 - arg1.value) then
                local5 = local3
            else
                local5 = local4
            end
        elseif local3 then
            local5 = local3
        elseif local4 then
            local5 = local4
        else
            local5 = tostring(arg1.value)
        end
    end
    return local5
end
gauge_object.set_value = function(arg1, arg2) -- line 3707
    if not arg1.bTextOnly then
        if arg2 > arg1.max_value then
            arg2 = arg1.max_value
        elseif arg2 < arg1.min_value then
            arg2 = arg1.min_value
        end
    elseif arg2 > arg1.max_value then
        arg2 = arg1.min_value
    elseif arg2 < arg1.min_value then
        arg2 = arg1.max_value
    end
    arg1.value = arg2
end
MODE_QUERY = 0
MODE_MESSAGE = 1
ORIENTATION_HORIZ = 0
ORIENTATION_VERT = 1
query_mode = { }
query_mode.is_active = FALSE
query_mode.caption = nil
query_mode.prompt = nil
query_mode.choices = { }
query_mode.default_choice = 0
query_mode.mode = MODE_QUERY
query_mode.orientation = ORIENTATION_HORIZ
query_mode.overlay_menu = nil
query_mode.create = function(arg1, arg2, arg3) -- line 3770
    local local1 = { }
    local1.parent = arg1
    local1.choices = { }
    local1.caption = nil
    local1.prompt = nil
    local1.default_choice = 0
    local1.bDontPause = FALSE
    if not arg2 then
        local1.mode = MODE_QUERY
    else
        local1.mode = arg2
    end
    if not arg3 then
        local1.orientation = ORIENTATION_HORIZ
    else
        local1.orientation = arg3
    end
    return local1
end
query_mode.destroy = function(arg1) -- line 3795
    local local1, local2
    local1, local2 = next(arg1.choices, nil)
    while local1 do
        local2.text = nil
        local2.action_script = nil
        local2.action_table = nil
        local1, local2 = next(arg1.choices, local1)
    end
    arg1.choices = nil
end
query_mode.run = function(arg1) -- line 3810
    local local1, local2
    if not arg1.is_active then
        arg1.is_active = TRUE
        arg1.prev_button_handler = system.buttonHandler
        if not arg1.bDontPause then
            game_pauser:pause(TRUE, arg1, arg1)
        end
        system.buttonHandler = arg1
        arg1.prev_character_handler = system.characterHandler
        system.characterHandler = arg1
        arg1.num_choices = 0
        arg1.current_choice = nil
        if arg1.mode == MODE_QUERY then
            local1, local2 = next(arg1.choices, nil)
            while local1 do
                arg1.num_choices = arg1.num_choices + 1
                local1, local2 = next(arg1.choices, local1)
            end
            if arg1.num_choices > 0 then
                if arg1.default_choice ~= nil and arg1.default_choice >= 0 and arg1.default_choice < arg1.num_choices then
                    arg1.current_choice = arg1.default_choice
                else
                    arg1.current_choice = next(arg1.choices, nil)
                end
            end
        end
        arg1:draw()
    end
end
query_mode.cancel = function(arg1) -- line 3853
    if arg1.is_active then
        arg1.is_active = FALSE
        if not arg1.overlay_menu then
            if not arg1.bDontPause then
                game_pauser:pause(FALSE)
            end
        else
            system.buttonHandler = arg1.prev_button_handler
            arg1.overlay_menu:draw()
        end
        system.characterHandler = arg1.prev_character_handler
    end
end
query_mode.ok = function(arg1) -- line 3874
    local local1
    if arg1.is_active then
        arg1:draw()
        arg1:cancel()
        if arg1.current_choice then
            if arg1.choices[arg1.current_choice] then
                local1 = arg1.choices[arg1.current_choice].action_script
                if local1 then
                    start_script(local1, arg1.choices[arg1.current_choice].action_table)
                end
            end
        end
    end
end
query_mode.next_choice = function(arg1, arg2) -- line 3895
    local local1, local2
    if arg2 then
        local1 = next(arg1.choices, arg1.current_choice)
        if local1 ~= nil then
            arg1.current_choice = local1
        else
            arg1.current_choice = next(arg1.choices, nil)
        end
    elseif arg1.current_choice == nil then
        arg1.current_choice = next(arg1.choices, nil)
    else
        local2 = arg1.current_choice - 1
        if arg1.choices[local2] ~= nil then
            arg1.current_choice = local2
        else
            arg1.current_choice = arg1.num_choices - 1
        end
    end
end
query_mode.handle_next_choice = function(arg1, arg2) -- line 3921
    local local1, local2
    if arg2 then
        local1 = "INVENTORY_NEXT"
    else
        local1 = "INVENTORY_PREV"
    end
    while get_generic_control_state(local1) do
        arg1:next_choice(arg2)
        arg1:draw()
        local2 = 0
        while local2 < 800 and get_generic_control_state(local1) do
            break_here()
            local2 = local2 + system.frameTime
        end
    end
end
query_mode.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 3943
    local local1
    if arg1.mode == MODE_QUERY then
        if control_map.INVENTORY_PREV[arg2] and arg3 then
            single_start_script(arg1.handle_next_choice, arg1, FALSE)
        elseif control_map.INVENTORY_NEXT[arg2] and arg3 then
            single_start_script(arg1.handle_next_choice, arg1, TRUE)
        elseif control_map.OVERRIDE[arg2] and arg3 then
            arg1:cancel()
        elseif control_map.DIALOG_CHOOSE[arg2] and arg3 then
            arg1:ok()
        end
    elseif arg1.mode == MODE_MESSAGE then
        local1 = GetControlState(LALTKEY) or GetControlState(RALTKEY)
        if arg2 == XKEY and local1 and arg3 or (arg2 == QKEY and local1 and arg3) and not arg1.overlay_menu then
            arg1:cancel()
            query_exit_game()
        elseif arg3 and not in(arg2, { LALTKEY, RALTKEY, LCONTROLKEY, RCONTROLKEY, LSHIFTKEY, RSHIFTKEY }) then
            FlushControls()
            arg1:cancel()
            if arg1.action_script then
                start_script(arg1.action_script, arg1.action_table)
            end
        end
    end
end
query_mode.characterHandler = function(arg1, arg2) -- line 3972
    local local1, local2
    local local3, local4
    if arg1.is_active then
        local4 = FALSE
        local1, local2 = next(arg1.choices, nil)
        while local1 and not local4 do
            local3 = menu_object:get_hotkey(local2.text)
            if local3 then
                if strlower(local3) == strlower(arg2) then
                    arg1.current_choice = local1
                    local4 = TRUE
                end
            end
            local1, local2 = next(arg1.choices, local1)
        end
        if local4 then
            arg1:draw()
            arg1:ok()
        end
    end
end
query_mode.draw = function(arg1) -- line 4001
    local local1 = { }
    local local2, local3
    if arg1.is_active then
        if not arg1.overlay_menu then
            CleanBuffer()
        else
            arg1.overlay_menu:draw(TRUE)
        end
        local1.font = verb_font
        local1.center = TRUE
        local1.fgcolor = White
        local1.x = 320
        if arg1.logo then
            if not arg1.logo_props then
                arg1.logo_props = { x = DEFAULT_LOGO_X, y = DEFAULT_LOGO_Y }
            end
            BlastImage(arg1.logo, arg1.logo_props.x, arg1.logo_props.y, TRUE)
            local1.y = arg1.logo_props.y + 100
        else
            local1.y = 90
        end
        if arg1.caption then
            BlastText(arg1.caption, local1)
            BlastText(arg1.caption, local1)
        end
        if arg1.prompt then
            local1.y = local1.y + 30
            local1.fgcolor = Yellow
            BlastText(arg1.prompt, local1)
        end
        local2, local3 = next(arg1.choices, nil)
        while local2 do
            local1.x = local3.x
            local1.y = local3.y
            if local2 == arg1.current_choice then
                local1.fgcolor = Yellow
            else
                local1.fgcolor = OptionsDarkColor
            end
            menu_object:display_text(local3.text, local1)
            local2, local3 = next(arg1.choices, local2)
        end
        Display()
    end
end
query_mode.userPaintHandler = function(arg1) -- line 4055
    arg1:draw()
end
query_exit_game = function() -- line 4065
    if not PL_MODE then
        if not exit_query then
            exit_query = query_mode:create(MODE_QUERY, ORIENTATION_HORIZ)
        end
        if not exit_query.is_active then
            if pause_query ~= nil and pause_query.is_active then
                pause_query:cancel()
            end
            main_menu:init()
            exit_query.logo = main_menu.logo
            exit_query.caption = nil
            exit_query.prompt = "/sytx221/"
            exit_query.choices[0] = { text = "/sytx222/", action_script = exit_the_game, x = 260, y = 220 }
            exit_query.choices[1] = { text = "/sytx223/", action_script = nil, x = 380, y = 220 }
            exit_query.default_choice = 1
            start_script(exit_query.run, exit_query)
        end
    else
        start_script(exit_the_game)
    end
end
query_pause_game = function() -- line 4099
    if exit_query ~= nil and exit_query.is_active then
        return
    end
    if game_pauser.is_paused then
        return
    end
    FlushControls()
    if pause_query == nil or not pause_query.is_active then
        if not pause_query then
            pause_query = query_mode:create(MODE_MESSAGE, ORIENTATION_HORIZ)
        end
        pause_query.caption = "/sytx224/"
        pause_query.prompt = "/sytx225/"
        start_script(pause_query.run, pause_query)
    else
        start_script(pause_query.cancel, pause_query)
    end
end
system.exitHandler = query_exit_game
system.pauseHandler = query_pause_game
DIALOG_LOG_ID_STRING = "/sytx416/"
DIALOG_LOG_TITLE_STRING = "/sytx417/"
DIALOG_LOG_COPYRIGHT_NOTICE = "/sytx418/"
DIALOG_LOG_LEFT_MARGIN = 20
DIALOG_LOG_CENTER_X = 320
DIALOG_LOG_TOP_MARGIN = 115
DIALOG_LOG_BOTTOM_MARGIN = 20
DIALOG_LOG_OFFSCREEN = 500
DIALOG_LOG_BUFFER_SIZE = 60
DIALOG_LOG_TEXT_OBJS = 20
DIALOG_LOG_DEFAULT_FILENAME = "grimdialog.htm"
dialog_log = { }
dialog_log.bActive = FALSE
dialog_log.filename = nil
dialog_log.is_valid = FALSE
dialog_log.is_empty = FALSE
dialog_log.initialized = FALSE
dialog_log.last_set_logged = nil
dialog_log.init = function(arg1) -- line 4165
    local local1, local2, local3
    if arg1.filename == nil then
        arg1.filename = DIALOG_LOG_DEFAULT_FILENAME
    end
    if writeto(arg1.filename) then
        local1 = LocalizeString(DIALOG_LOG_ID_STRING)
        local2 = LocalizeString(DIALOG_LOG_TITLE_STRING)
        local3 = LocalizeString(DIALOG_LOG_COPYRIGHT_NOTICE)
        write(trim_header(local1))
        write("<TITLE>" .. trim_header(local2) .. "</TITLE>\n")
        write("<P>" .. trim_header(local2) .. "<BR>" .. trim_header(local3) .. "</P><BR>\n")
        writeto()
        arg1.last_set_logged = nil
        arg1.initialized = TRUE
    end
end
dialog_log.on = function(arg1) -- line 4193
    arg1.bActive = TRUE
    if not arg1.initialized then
        arg1:init()
    end
end
dialog_log.off = function(arg1) -- line 4204
    arg1.bActive = FALSE
end
dialog_log.log_say_line = function(arg1, arg2, arg3) -- line 4208
    local local1
    local local2
    if arg1.bActive then
        if arg1.last_set_logged ~= system.currentSet then
            arg1:log_set_change(system.currentSet)
        end
        if not arg1.filename then
            arg1.filename = DIALOG_LOG_DEFAULT_FILENAME
        end
        appendto(arg1.filename)
        local1 = dialog_log:get_color_string(arg2)
        if local1 then
            write("<FONT COLOR=\"" .. local1 .. "\">")
        end
        local2 = LocalizeString(arg2.name)
        write("<CENTER><B>" .. trim_header(local2) .. "</B></CENTER>")
        if local1 then
            write("</FONT>")
        end
        write("\n")
        if local1 then
            write("<FONT COLOR=\"" .. local1 .. "\">")
        end
        local2 = LocalizeString(arg3)
        write("<CENTER>" .. trim_header(local2) .. "</CENTER>")
        if local1 then
            write("</FONT>")
        end
        write("\n")
        write("<BR>\n")
        writeto()
    end
end
dialog_log.log_cut_scene = function(arg1, arg2) -- line 4252
    local local1
    if arg1.bActive then
        if not arg1.filename then
            arg1.filename = DIALOG_LOG_DEFAULT_FILENAME
        end
        local1 = "(" .. trim_header(LocalizeString(arg2)) .. ")"
        if local1 then
            appendto(arg1.filename)
            write("<BR>\n")
            write("<BR>\n")
            write("<CENTER>" .. local1 .. "</CENTER>\n")
            write("<BR>\n")
            write("<BR>\n")
            writeto()
        end
    end
end
dialog_log.log_set_change = function(arg1, arg2) -- line 4277
    local local1
    if arg1.bActive then
        if not arg1.filename then
            arg1.filename = DIALOG_LOG_DEFAULT_FILENAME
        end
        local1 = arg1:get_set_description_string(arg2)
        if local1 then
            appendto(arg1.filename)
            if arg1.last_set_logged ~= nil then
                write("<BR>\n")
            end
            write(local1 .. "\n")
            write("<BR>\n")
            writeto()
            arg1.last_set_logged = arg2
        end
    end
end
dialog_log.get_set_description_string = function(arg1, arg2) -- line 4302
    local local1
    local local2
    local local3, local4
    if arg2.short_name then
        local2 = arg2:short_name()
        if local2 == "do" then
            local2 = "dom"
        end
        if set_description[local2] then
            local3 = set_description[local2]
            local1 = "<P><B>"
            if local3[2] then
                local4 = LocalizeString(set_description.interior)
            else
                local4 = LocalizeString(set_description.exterior)
            end
            local1 = local1 .. trim_header(local4)
            local1 = local1 .. "     "
            local4 = LocalizeString(local3[1])
            local1 = local1 .. trim_header(local4)
            local1 = local1 .. "     "
            if local3[3] == 1 then
                local4 = LocalizeString(set_description.daytime)
            elseif local3[3] == 2 then
                local4 = LocalizeString(set_description.nighttime)
            elseif local3[3] == 3 then
                local4 = LocalizeString(set_description.morning)
            elseif local3[3] == 4 then
                local4 = LocalizeString(set_description.evening)
            end
            local1 = local1 .. trim_header(local4)
            local1 = local1 .. "</B></P>"
        end
    end
    return local1
end
dialog_log.get_color_string = function(arg1, arg2) -- line 4347
    local local1, local2, local3, local4
    if type(arg2) == "table" then
        local1, local2, local3 = GetColorComponents(GetActorTalkColor(arg2.hActor))
    else
        local1, local2, local3 = GetColorComponents(arg2)
    end
    if local1 == 255 and local2 == 255 and local3 == 255 then
        return nil
    else
        local4 = format("#%02X%02X%02X", local1, local2, local3)
        return local4
    end
end
dialog_log.parse_color_string = function(arg1, arg2) -- line 4366
    local local1, local2, local3
    local1 = tonumber(strsub(arg2, 1, 2), 16)
    local2 = tonumber(strsub(arg2, 3, 4), 16)
    local3 = tonumber(strsub(arg2, 5, 6), 16)
    return MakeColor(local1, local2, local3)
end
dialog_log.parse_html_string = function(arg1, arg2) -- line 4377
    local local1 = { }
    local local2, local3, local4, local5
    local local6, local7, local8
    local6 = trim_header(LocalizeString(DIALOG_LOG_ID_STRING))
    local7 = trim_header(LocalizeString(DIALOG_LOG_TITLE_STRING))
    local8 = trim_header(LocalizeString(DIALOG_LOG_COPYRIGHT_NOTICE))
    local1.font = verb_font
    if strfind(arg2, "<CENTER>", 1, TRUE) then
        local1.center = TRUE
        local1.x = DIALOG_LOG_CENTER_X
    else
        local1.ljustify = TRUE
        local1.x = DIALOG_LOG_LEFT_MARGIN
    end
    if strfind(arg2, "<FONT COLOR", 1, TRUE) then
        local3 = strfind(arg2, "\"#", 1, TRUE)
        if local3 then
            local5 = strsub(arg2, local3 + 2, local3 + 8)
            local1.fgcolor = dialog_log:parse_color_string(local5)
        else
            local1.fgcolor = White
        end
    else
        local1.fgcolor = White
    end
    if strfind(strupper(arg2), "<TITLE>", 1, TRUE) or strfind(arg2, local6, 1, TRUE) or strfind(arg2, local7, 1, TRUE) or strfind(arg2, local8, 1, TRUE) then
        local2 = ""
    else
        local2 = arg2
    end
    local2 = gsub(local2, "<CENTER>", "")
    local2 = gsub(local2, "</CENTER>", "")
    local2 = gsub(local2, "<BR>", "")
    local2 = gsub(local2, "<P>", "")
    local2 = gsub(local2, "</P>", "")
    local2 = gsub(local2, "<B>", "")
    local2 = gsub(local2, "</B>", "")
    local2 = gsub(local2, "<I>", "")
    local2 = gsub(local2, "</I>", "")
    local3 = strfind(local2, "<FONT")
    if local3 then
        local4 = strfind(local2, ">", local3 + 5, TRUE)
        local2 = strsub(local2, local4 + 1)
    end
    local2 = gsub(local2, "</FONT>", "")
    return local2, local1
end
dialog_log.run = function(arg1) -- line 4444
    if not arg1.filename then
        arg1.filename = DIALOG_LOG_DEFAULT_FILENAME
    end
    if not arg1.is_active then
        arg1.is_active = TRUE
        main_menu:init()
        game_pauser:pause(TRUE, arg1, arg1)
        dialog_log:start_display()
    end
end
dialog_log.cancel = function(arg1, arg2) -- line 4464
    if arg1.is_active then
        if not arg2 then
            game_pauser:pause(FALSE)
        end
        if arg1.text_obj then
            KillTextObject(arg1.text_obj)
            arg1.text_obj = nil
        end
        arg1.indexTable = nil
        arg1.text_buffer = nil
        arg1.is_active = FALSE
    end
end
dialog_log.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 4482
    if control_map.DIALOG_UP[arg2] and arg3 then
        single_start_script(arg1.scroll_up, arg1)
    elseif control_map.DIALOG_DOWN[arg2] and arg3 then
        single_start_script(arg1.scroll_down, arg1)
    elseif control_map.PAGE_UP[arg2] and arg3 then
        single_start_script(arg1.page_up, arg1)
    elseif control_map.PAGE_DOWN[arg2] and arg3 then
        single_start_script(arg1.page_down, arg1)
    elseif control_map.PAGE_HOME[arg2] and arg3 then
        arg1.top_index = 0
        arg1:draw()
    elseif control_map.PAGE_END[arg2] and arg3 then
        arg1.top_index = arg1.indexTable.count - 3
        if arg1.top_index < 0 then
            arg1.top_index = 0
        end
        arg1:draw()
    elseif control_map.OVERRIDE[arg2] or control_map.USE[arg2] or control_map.PICK_UP[arg2] and arg3 then
        arg1:cancel(TRUE)
        main_menu:run()
    end
end
dialog_log.start_display = function(arg1) -- line 4506
    local local1, local2, local3, local4
    arg1.is_empty = FALSE
    local2, local3 = readfrom(arg1.filename)
    readfrom()
    if not local2 then
        arg1.is_valid = FALSE
        PrintDebug("Couldn't open " .. arg1.filename .. ": error = " .. local3 .. "\n")
    else
        local1 = TextFileGetLine(arg1.filename, 0)
        local4 = trim_header(LocalizeString(DIALOG_LOG_ID_STRING))
        if not local1 or not strfind(local1, local4, 1, TRUE) then
            arg1.is_valid = FALSE
            PrintDebug("Couldn't read dialog log ID string in file " .. arg1.filename .. "\n")
        else
            arg1.is_valid = TRUE
        end
    end
    if arg1.is_valid then
        arg1.indexTable = TextFileGetLineCount(arg1.filename)
    end
    if arg1.is_valid and arg1.indexTable.count < 4 then
        arg1.is_valid = FALSE
        arg1.is_empty = TRUE
        PrintDebug("Dialog log " .. arg1.filename .. " has less than four lines.\n")
    end
    if arg1.is_valid then
        arg1.top_index = arg1.indexTable.count - 10
        if arg1.top_index < 0 then
            arg1.top_index = 0
        end
        arg1:build_text_buffer()
    end
    if not arg1.text_obj then
        arg1.text_obj = MakeTextObject(" ", { x = 0, y = DIALOG_LOG_OFFSCREEN, font = verb_font })
    end
    arg1:draw()
end
dialog_log.draw = function(arg1) -- line 4552
    local local1, local2, local3
    local local4, local5
    CleanBuffer()
    if arg1.is_valid then
        BlastImage(main_menu.logo, 0, 0, TRUE)
        BlastText("/sytx419/", { x = 190, y = 10, font = verb_font, fgcolor = White })
        BlastText("/sytx420/", { x = 190, y = 30, font = verb_font, fgcolor = OptionsColor })
        local3 = arg1.top_index
        local2 = DIALOG_LOG_TOP_MARGIN
        while local2 < 480 - DIALOG_LOG_BOTTOM_MARGIN and local3 < arg1.indexTable.count do
            if local3 < arg1.indexTable.count and arg1.text_buffer[local3] == nil then
                arg1:build_text_buffer()
            end
            if arg1.text_buffer[local3] then
                ChangeTextObject(arg1.text_obj, arg1.text_buffer[local3].text)
            else
                ChangeTextObject(arg1.text_obj, " ")
            end
            local4, local5 = GetTextObjectDimensions(arg1.text_obj)
            if local2 + local5 <= 480 - DIALOG_LOG_BOTTOM_MARGIN then
                arg1.text_buffer[local3].props.y = local2
                arg1.text_buffer[local3].props.font = verb_font
                BlastText(arg1.text_buffer[local3].text, arg1.text_buffer[local3].props)
                arg1.bottom_index = local3
            end
            local2 = local2 + local5
            local3 = local3 + 1
        end
    else
        if not arg1.is_empty then
            BlastText("/sytx421/", { x = 320, y = 90, font = verb_font, fgcolor = Red, center = TRUE })
        else
            BlastText("/sytx422/", { x = 320, y = 90, font = verb_font, fgcolor = White, center = TRUE })
        end
        BlastText("/sytx423/", { x = 320, y = 120, font = verb_font, fgcolor = Yellow, center = TRUE })
    end
    Display()
end
dialog_log.build_text_buffer = function(arg1) -- line 4597
    local local1, local2, local3
    local local4
    if not arg1.text_buffer then
        arg1.text_buffer = { }
    end
    local2 = arg1.top_index - DIALOG_LOG_BUFFER_SIZE / 2
    if local2 < 0 then
        local2 = 0
    end
    local3 = local2 + DIALOG_LOG_BUFFER_SIZE
    if local3 >= arg1.indexTable.count then
        local3 = arg1.indexTable.count - 1
    end
    local1 = 0
    while local1 < local2 do
        arg1.text_buffer[local1] = nil
        local1 = local1 + 1
    end
    local1 = local3 + 1
    while local1 < arg1.indexTable.count do
        arg1.text_buffer[local1] = nil
        local1 = local1 + 1
    end
    local1 = local2
    while local1 <= local3 do
        if not arg1.text_buffer[local1] then
            arg1.text_buffer[local1] = { }
            arg1.text_buffer[local1].text = TextFileGetLine(arg1.filename, arg1.indexTable[local1])
            if arg1.text_buffer[local1].text then
                arg1.text_buffer[local1].text, arg1.text_buffer[local1].props = dialog_log:parse_html_string(arg1.text_buffer[local1].text)
                arg1.text_buffer[local1].text = gsub(arg1.text_buffer[local1].text, "\n", "")
            else
                arg1.text_buffer[local1].text = nil
                arg1.text_buffer[local1].props = { }
            end
            if arg1.text_buffer[local1].text == nil then
                arg1.text_buffer[local1].text = " "
            end
        end
        local1 = local1 + 1
    end
end
dialog_log.scroll_up = function(arg1) -- line 4647
    local local1, local2
    stop_script(arg1.scroll_down)
    stop_script(arg1.page_up)
    stop_script(arg1.page_down)
    if arg1.is_valid then
        local1 = 200
        while get_generic_control_state("DIALOG_UP") do
            if arg1.top_index > 0 then
                arg1.top_index = arg1.top_index - 1
                arg1:draw()
            end
            local2 = 0
            while local2 < local1 and get_generic_control_state("DIALOG_UP") do
                break_here()
                local2 = local2 + system.frameTime
            end
            if local1 > 5 then
                local1 = local1 - 5
            end
        end
    end
end
dialog_log.scroll_down = function(arg1) -- line 4674
    local local1, local2
    stop_script(arg1.scroll_up)
    stop_script(arg1.page_up)
    stop_script(arg1.page_down)
    if arg1.is_valid then
        local1 = 200
        while get_generic_control_state("DIALOG_DOWN") do
            if arg1.top_index < arg1.indexTable.count - 4 then
                arg1.top_index = arg1.top_index + 1
                arg1:draw()
            end
            local2 = 0
            while local2 < local1 and get_generic_control_state("DIALOG_DOWN") do
                break_here()
                local2 = local2 + system.frameTime
            end
            if local1 > 5 then
                local1 = local1 - 5
            end
        end
    end
end
dialog_log.page_up = function(arg1) -- line 4701
    local local1, local2
    stop_script(arg1.page_down)
    stop_script(arg1.scroll_up)
    stop_script(arg1.scroll_down)
    if arg1.is_valid then
        while get_generic_control_state("PAGE_UP") do
            local1 = arg1.top_index - (arg1.bottom_index - arg1.top_index) + 1
            if local1 < 0 then
                local1 = 0
            end
            arg1.top_index = local1
            arg1:draw()
            local2 = 0
            while local2 < 800 and get_generic_control_state("PAGE_UP") do
                break_here()
                local2 = local2 + system.frameTime
            end
        end
    end
end
dialog_log.page_down = function(arg1) -- line 4726
    local local1, local2
    stop_script(arg1.page_up)
    stop_script(arg1.scroll_up)
    stop_script(arg1.scroll_down)
    if arg1.is_valid then
        while get_generic_control_state("PAGE_DOWN") do
            local1 = arg1.bottom_index
            if local1 > arg1.indexTable.count - 3 then
                local1 = arg1.indexTable.count - 3
            end
            arg1.top_index = local1
            arg1:draw()
            local2 = 0
            while local2 < 800 and get_generic_control_state("PAGE_DOWN") do
                break_here()
                local2 = local2 + system.frameTime
            end
        end
    end
end
dialog_log.copy_to = function(arg1, arg2) -- line 4751
    local local1 = FALSE
    local local2
    local local3
    if arg1.filename then
        local1, local2 = readfrom(arg1.filename)
        if local1 then
            local1, local2 = writeto(arg2)
            if local1 then
                local3 = read()
                while local3 do
                    write(local3)
                    write("\n")
                    local3 = read()
                end
                writeto()
            end
            readfrom()
        end
    end
    if not local1 then
        PrintDebug("Error in dialog_log:copy_to() -- " .. local2 .. "\n")
    end
    return local1, local2
end
dialog_log.copy_from = function(arg1, arg2) -- line 4780
    local local1 = FALSE
    local local2
    local local3
    if arg1.filename == nil then
        arg1.filename = DIALOG_LOG_DEFAULT_FILENAME
    end
    if arg2 then
        local1, local2 = readfrom(arg2)
        if local1 then
            local1, local2 = writeto(arg1.filename)
            if local1 then
                local3 = read()
                while local3 do
                    write(local3)
                    write("\n")
                    local3 = read()
                end
                writeto()
            end
            readfrom()
        end
    end
    if not local1 then
        PrintDebug("Error in dialog_log:copy_from() -- " .. local2 .. "\n")
    end
    return local1, local2
end
dialog_log.userPaintHandler = function(arg1) -- line 4813
    arg1:draw()
end
muralstate = { }
muralstate[1] = { 0, 1, 2, 32, 33, 64 }
muralstate[2] = { 34, 65, 66, 96, 97 }
muralstate[3] = { 67, 98, 99, 130, 131 }
muralstate[4] = { 3, 4, 5, 35, 36 }
muralstate[5] = { 128, 129, 160, 161, 162 }
muralstate[6] = { 6, 37, 38, 68, 69 }
muralstate[7] = { 70, 100, 101, 102, 132 }
muralstate[8] = { 7, 8, 39, 40, 71 }
muralstate[9] = { 72, 103, 104, 133, 134 }
muralstate[10] = { 192, 193, 224, 225, 256 }
muralstate[11] = { 257, 258, 288, 289, 290 }
muralstate[12] = { 163, 194, 195, 226, 227 }
muralstate[13] = { 228, 259, 260, 291, 292 }
muralstate[14] = { 164, 165, 196, 197, 198 }
muralstate[15] = { 229, 230, 261, 262, 293 }
muralstate[16] = { 135, 136, 166, 167, 168 }
muralstate[17] = { 199, 200, 231, 232, 263 }
muralstate[18] = { 264, 294, 295, 296, 297 }
muralstate[19] = { 137, 138, 139, 169, 170 }
muralstate[20] = { 171, 172, 203, 204, 205 }
muralstate[21] = { 201, 202, 233, 234, 265 }
muralstate[22] = { 41, 235, 266, 267, 298, 299 }
muralstate[23] = { 9, 10, 11, 42 }
muralstate[24] = { 73, 74, 75, 105, 106 }
muralstate[25] = { 12, 13, 43, 44, 76 }
muralstate[26] = { 77, 107, 108, 109, 140 }
muralstate[27] = { 78, 110, 141, 142, 173 }
muralstate[28] = { 14, 45, 46, 47, 79 }
muralstate[29] = { 15, 16, 48, 49, 80 }
muralstate[30] = { 81, 111, 112, 113, 144 }
muralstate[31] = { 143, 174, 175, 176, 207 }
muralstate[32] = { 206, 236, 237, 238, 268, 300 }
muralstate[33] = { 269, 270, 271, 301, 302 }
muralstate[34] = { 239, 240, 272, 273, 303 }
muralstate[35] = { 17, 18, 19, 50, 82 }
muralstate[36] = { 114, 145, 146, 177, 178 }
muralstate[37] = { 208, 209, 241, 242, 274 }
muralstate[38] = { 275, 304, 305, 306, 307 }
muralstate[39] = { 210, 211, 243, 244, 276, 308 }
muralstate[40] = { 179, 180, 212, 213, 245 }
muralstate[41] = { 277, 278, 309, 310, 311 }
muralstate[42] = { 51, 52, 53, 84, 85 }
muralstate[43] = { 83, 115, 116, 117, 147 }
muralstate[44] = { 86, 118, 148, 149, 150 }
muralstate[45] = { 20, 21, 22, 54, 55 }
muralstate[46] = { 181, 182, 183, 214, 215, 246 }
muralstate[47] = { 23, 24, 25, 26, 56, 57 }
muralstate[48] = { 87, 88, 89, 119, 120, 121 }
muralstate[49] = { 27, 28, 58, 59, 60, 91 }
muralstate[50] = { 151, 152, 153, 154, 184, 185 }
muralstate[51] = { 216, 247, 248, 279, 280 }
muralstate[52] = { 281, 282, 312, 313, 314 }
muralstate[53] = { 217, 218, 249, 250, 251, 283 }
muralstate[54] = { 252, 284, 285, 315, 316, 317 }
muralstate[55] = { 90, 92, 93, 122, 123, 124 }
muralstate[56] = { 29, 30, 31, 61, 62, 63 }
muralstate[57] = { 155, 156, 186, 187, 188, 219 }
muralstate[58] = { 189, 220, 221, 222, 253, 254 }
muralstate[59] = { 94, 95, 125, 126, 127, 157, 158 }
muralstate[60] = { 159, 190, 191, 223, 255, 286, 287, 318, 319 }
muralstate.table = { }
muralstate.draw = function(arg1, arg2) -- line 4883
    local local1, local2, local3, local4, local5, local6
    local local7
    local1 = { }
    local1.parent = puzzle_state
    local1:set_string(arg2)
    local2 = 1
    while local2 <= PUZZLE_STATE_NUM_ENTRIES do
        if muralstate[local2] then
            if not local1[local2] then
                local3, local4 = next(muralstate[local2], nil)
                while local3 do
                    local6 = floor(local4 / 32)
                    local5 = local4 - local6 * 32
                    local7 = 20
                    if local6 == 9 then
                        local7 = 22
                    end
                    DimRegion(local5 * 20, 35 + local6 * 20, 20, local7, 0.2)
                    local3, local4 = next(muralstate[local2], local3)
                end
            end
        end
        local2 = local2 + 1
    end
    local1:clear()
    local1 = nil
end
set_description = { }
set_description.interior = "/sytx541/"
set_description.exterior = "/sytx542/"
set_description.daytime = "/sytx543/"
set_description.nighttime = "/sytx544/"
set_description.morning = "/sytx545/"
set_description.evening = "/sytx546/"
set_description.rf = { "/sytx424/", FALSE, 1 }
set_description.le = { "/sytx425/", FALSE, 1 }
set_description.co = { "/sytx426/", TRUE, 1 }
set_description.dom = { "/sytx427/", TRUE, 1 }
set_description.mo = { "/sytx428/", TRUE, 1 }
set_description.ha = { "/sytx429/", TRUE, 1 }
set_description.hq = { "/sytx430/", TRUE, 1 }
set_description.al = { "/sytx431/", FALSE, 1 }
set_description.tu = { "/sytx432/", TRUE, 1 }
set_description["lo"] = { "/sytx433/", TRUE, 1 }
set_description.pk = { "/sytx434/", TRUE, 1 }
set_description.ga = { "/sytx435/", TRUE, 1 }
set_description.fe = { "/sytx436/", FALSE, 1 }
set_description.st = { "/sytx437/", FALSE, 1 }
set_description.os = { "/sytx438/", FALSE, 1 }
set_description.rp = { "/sytx439/", FALSE, 1 }
set_description.gs = { "/sytx440/", TRUE, 1 }
set_description.lr = { "/sytx441/", TRUE, 1 }
set_description.nl = { "/sytx442/", FALSE, 2 }
set_description.mf = { "/sytx443/", FALSE, 2 }
set_description.me = { "/sytx444/", FALSE, 2 }
set_description.sm = { "/sytx445/", FALSE, 4 }
set_description.sg = { "/sytx446/", FALSE, 4 }
set_description.na = { "/sytx447/", FALSE, 4 }
set_description.sp = { "/sytx448/", FALSE, 4 }
set_description.tr = { "/sytx449/", FALSE, 4 }
set_description.lb = { "/sytx450/", FALSE, 4 }
set_description.bd = { "/sytx451/", FALSE, 4 }
set_description.bv = { "/sytx452/", FALSE, 4 }
set_description.fc = { "/sytx453/", FALSE, 4 }
set_description["re"] = { "/sytx454/", FALSE, 3 }
set_description.ri = { "/sytx455/", TRUE, 3 }
set_description.cb = { "/sytx456/", FALSE, 2 }
set_description.cf = { "/sytx457/", TRUE, 2 }
set_description.cc = { "/sytx458/", TRUE, 2 }
set_description.ci = { "/sytx459/", TRUE, 2 }
set_description.cn = { "/sytx460/", TRUE, 2 }
set_description.ce = { "/sytx461/", FALSE, 2 }
set_description.cl = { "/sytx462/", FALSE, 2 }
set_description.bk = { "/sytx463/", TRUE, 2 }
set_description.bi = { "/sytx464/", TRUE, 2 }
set_description.be = { "/sytx465/", FALSE, 2 }
set_description.lm = { "/sytx466/", FALSE, 2 }
set_description.bb = { "/sytx467/", FALSE, 2 }
set_description.bp = { "/sytx468/", FALSE, 2 }
set_description.pc = { "/sytx469/", FALSE, 2 }
set_description.ev = { "/sytx470/", FALSE, 2 }
set_description.bw = { "/sytx471/", FALSE, 2 }
set_description.hb = { "/sytx472/", FALSE, 2 }
set_description.gt = { "/sytx473/", FALSE, 2 }
set_description.sl = { "/sytx474/", TRUE, 2 }
set_description.mg = { "/sytx475/", TRUE, 2 }
set_description.pi = { "/sytx476/", TRUE, 2 }
set_description.dd = { "/sytx477/", FALSE, 2 }
set_description.tw = { "/sytx478/", TRUE, 2 }
set_description.tb = { "/sytx479/", TRUE, 2 }
set_description.hh = { "/sytx480/", TRUE, 2 }
set_description.xb = { "/sytx481/", FALSE, 2 }
set_description.lx = { "/sytx482/", FALSE, 2 }
set_description.hl = { "/sytx483/", TRUE, 2 }
set_description.mx = { "/sytx484/", TRUE, 2 }
set_description.ts = { "/sytx485/", TRUE, 2 }
set_description.kh = { "/sytx486/", TRUE, 2 }
set_description.ks = { "/sytx487/", TRUE, 2 }
set_description.hk = { "/sytx488/", TRUE, 2 }
set_description.hp = { "/sytx489/", TRUE, 2 }
set_description.he = { "/sytx490/", TRUE, 2 }
set_description.de = { "/sytx491/", TRUE, 2 }
set_description.dh = { "/sytx492/", TRUE, 2 }
set_description.wc = { "/sytx493/", TRUE, 2 }
set_description.tx = { "/sytx494/", FALSE, 2 }
set_description.sd = { "/sytx495/", FALSE, 2 }
set_description.se = { "/sytx496/", FALSE, 2 }
set_description.si = { "/sytx497/", TRUE, 2 }
set_description.lz = { "/sytx498/", FALSE, 1 }
set_description.il = { "/sytx499/", TRUE, 1 }
set_description.ei = { "/sytx500/", TRUE, 1 }
set_description.dp = { "/sytx501/", FALSE, 1 }
set_description.op = { "/sytx502/", FALSE, 1 }
set_description.su = { "/sytx503/", FALSE, 1 }
set_description.ps = { "/sytx504/", FALSE, 1 }
set_description.vi = { "/sytx505/", TRUE, 1 }
set_description.vo = { "/sytx506/", TRUE, 1 }
set_description.fo = { "/sytx507/", TRUE, 1 }
set_description.mn = { "/sytx508/", FALSE, 1 }
set_description.ea = { "/sytx509/", FALSE, 1 }
set_description.fh = { "/sytx510/", TRUE, 1 }
set_description.vd = { "/sytx511/", TRUE, 1 }
set_description.ar = { "/sytx512/", TRUE, 1 }
set_description.dr = { "/sytx513/", TRUE, 1 }
set_description.cy = { "/sytx514/", FALSE, 1 }
set_description.cv = { "/sytx515/", FALSE, 1 }
set_description.ew = { "/sytx516/", FALSE, 1 }
set_description.cu = { "/sytx517/", FALSE, 1 }
set_description.ac = { "/sytx518/", FALSE, 1 }
set_description.bu = { "/sytx519/", FALSE, 1 }
set_description.gh = { "/sytx520/", FALSE, 1 }
set_description.bl = { "/sytx521/", FALSE, 1 }
set_description.lu = { "/sytx522/", FALSE, 1 }
set_description.tg = { "/sytx523/", FALSE, 1 }
set_description.mt = { "/sytx524/", TRUE, 1 }
set_description.bs = { "/sytx525/", FALSE, 1 }
set_description.td = { "/sytx526/", FALSE, 1 }
set_description.my = { "/sytx527/", TRUE, 1 }
set_description.mk = { "/sytx528/", TRUE, 1 }
set_description.jb = { "/sytx529/", TRUE, 2 }
set_description.nq = { "/sytx530/", TRUE, 2 }
set_description.lw = { "/sytx531/", TRUE, 2 }
set_description.sh = { "/sytx532/", TRUE, 2 }
set_description.te = { "/sytx533/", TRUE, 2 }
set_description["th"] = { "/sytx534/", TRUE, 2 }
set_description.zw = { "/sytx535/", TRUE, 2 }
set_description.at = { "/sytx536/", TRUE, 2 }
set_description.fp = { "/sytx537/", FALSE, 2 }
set_description.fi = { "/sytx538/", TRUE, 2 }
set_description.ly = { "/sytx539/", TRUE, 2 }
set_description.hf = { "/sytx540/", TRUE, 2 }
credits_menu = { }
credits_menu.initialized = FALSE
credits_menu.hicolor = Yellow
credits_menu.locolor = White
credits_menu.line_height = 20
credits_menu.build_screen_buffer = function(arg1) -- line 5069
    local local1
    arg1.screens = { }
    arg1.num_screens = 0
    repeat
        local1 = arg1:read_screen()
        if local1 then
            arg1.num_screens = arg1.num_screens + 1
            arg1.screens[arg1.num_screens] = local1
        end
    until local1 == nil
end
credits_menu.fade_in_cur_screen = function(arg1) -- line 5084
    local local1
    if arg1.screens[arg1.cur_screen] then
        break_here()
        local1 = 1
        while local1 <= arg1.fade_steps do
            arg1:fade_colors(arg1.cur_screen, local1)
            break_here()
            local1 = local1 + 1
        end
        arg1:fade_colors(arg1.cur_screen, local1)
    end
end
credits_menu.fade_out_cur_screen = function(arg1) -- line 5101
    local local1
    if arg1.screens[arg1.cur_screen] then
        curScreen = arg1.cur_screen
        local1 = arg1.fade_steps
        while local1 > 0 do
            arg1:fade_colors(arg1.cur_screen, local1)
            break_here()
            local1 = local1 - 1
        end
    end
end
credits_menu.move_to_next_screen = function(arg1) -- line 5116
    if arg1.screens[arg1.cur_screen] then
        sleep_for(arg1.screens[arg1.cur_screen].delay)
        arg1.next_screen = arg1.cur_screen + 1
    end
end
credits_menu.fade_colors = function(arg1, arg2, arg3) -- line 5123
    local local1, local2, local3
    if arg2 then
        local3 = arg1.screens[arg2]
    else
        local3 = nil
    end
    CleanBuffer()
    BlastRect(0, 0, 639, 479, { color = Black, filled = TRUE })
    if local3 then
        local1 = 1
        while local1 <= local3.num_lines do
            local2 = 1
            while local2 <= 3 and local3.lines[local1].options[local2] ~= nil do
                if local3.lines[local1].options[local2].hicolor then
                    local3.lines[local1].options[local2].fgcolor = arg1.hicolorTable[arg3]
                else
                    local3.lines[local1].options[local2].fgcolor = arg1.locolorTable[arg3]
                end
                local3.lines[local1].options[local2].font = verb_font
                BlastText(local3.lines[local1].text[local2], local3.lines[local1].options[local2])
                local2 = local2 + 1
            end
            local1 = local1 + 1
        end
    end
    Display()
end
credits_menu.read_screen = function(arg1) -- line 5155
    local local1
    local local2
    local local3, local4, local5
    local local6, local7
    local6 = { }
    local6.lines = { }
    local6.num_lines = 0
    local7 = 0
    local2 = FALSE
    repeat
        local1 = read("[^\n]*{\n}")
        if local1 then
            if strfind(local1, "<SCREEN") then
                local2 = TRUE
                local6.delay = nil
                local3 = strfind(local1, "DELAY ")
                if local3 then
                    local5 = strfind(local1, ">")
                    if local5 then
                        local4 = strsub(local1, local3 + 6, local5 - 1)
                    else
                        local4 = strsub(local1, local3 + 6)
                    end
                    local6.delay = tonumber(local4)
                end
                if not local6.delay then
                    local6.delay = 6000
                end
            else
                local1, local3 = gsub(local1, "<hicolor>", "")
                if local3 > 0 then
                    color = { arg1.hicolor }
                else
                    local1 = gsub(local1, "<locolor>", "")
                    color = { arg1.locolor }
                end
                col1 = nil
                col2 = nil
                col3 = nil
                local3 = strfind(local1, "\t")
                if local3 then
                    col1 = strsub(local1, 1, local3 - 1)
                    local1 = strsub(local1, local3 + 1)
                    local3 = strfind(local1, "\t")
                    if local3 then
                        col2 = strsub(local1, 1, local3 - 1)
                        col3 = strsub(local1, local3 + 1)
                    else
                        col2 = local1
                    end
                else
                    col1 = local1
                end
                arg1:add_line(local6, col1, col2, col3, color)
                local7 = local7 + arg1.line_height
            end
        end
    until local1 == nil or local2
    local7 = floor((480 - local7) / 2)
    local3 = 1
    while local3 <= local6.num_lines do
        local5 = 1
        while local5 <= 3 and local6.lines[local3].options[local5] ~= nil do
            local6.lines[local3].options[local5].y = local7
            if local6.lines[local3].options[local5].fgcolor == arg1.hicolor then
                local6.lines[local3].options[local5].hicolor = TRUE
            else
                local6.lines[local3].options[local5].hicolor = FALSE
            end
            local5 = local5 + 1
        end
        local7 = local7 + arg1.line_height
        local3 = local3 + 1
    end
    if local6.num_lines > 0 then
        return local6
    else
        local6 = nil
        return nil
    end
end
credits_menu.add_line = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 5254
    local local1, local2, local3
    if type(arg4) == "table" then
        arg6 = arg4
        arg4 = nil
        arg5 = nil
    elseif type(arg5) == "table" then
        arg6 = arg5
        arg5 = nil
    end
    if arg6 and type(arg6) == "table" then
        local1, local3 = next(arg6, nil)
    end
    local1 = arg2.num_lines + 1
    local2 = { }
    local2.text = { }
    local2.options = { }
    if arg3 ~= nil and arg4 ~= nil and arg5 ~= nil then
        local2.text[1] = arg3
        local2.options[1] = { x = 200, y = arg1.top_y, rjustify = TRUE, fgcolor = local3, font = verb_font }
        local2.text[2] = arg4
        local2.options[2] = { x = 320, y = arg1.top_y, center = TRUE, fgcolor = local3, font = verb_font }
        local2.text[3] = arg5
        local2.options[3] = { x = 450, y = arg1.top_y, ljustify = TRUE, fgcolor = local3, font = verb_font }
    elseif arg3 ~= nil and arg4 ~= nil then
        local2.text[1] = arg3
        local2.options[1] = { x = 310, y = arg1.top_y, rjustify = TRUE, fgcolor = local3, font = verb_font }
        local2.text[2] = arg4
        local2.options[2] = { x = 330, y = arg1.top_y, ljustify = TRUE, fgcolor = local3, font = verb_font }
        local2.text[3] = nil
    else
        if arg3 then
            local2.text[1] = arg3
        else
            local2.text[1] = " "
        end
        local2.options[1] = { x = 320, y = arg1.top_y, center = TRUE, fgcolor = local3, font = verb_font }
        local2.text[2] = nil
        local2.text[3] = nil
    end
    arg2.lines[local1] = local2
    arg2.num_lines = arg2.num_lines + 1
end
credits_menu.init = function(arg1) -- line 5306
    arg1.lines = nil
    arg1.screens = nil
    arg1.cur_screen = 0
    arg1.num_screens = 0
    arg1.fade_steps = 5
    arg1.hicolorTable = arg1:build_color_table(arg1.fade_steps, arg1.hicolor)
    arg1.locolorTable = arg1:build_color_table(arg1.fade_steps, arg1.locolor)
end
credits_menu.build_color_table = function(arg1, arg2, arg3) -- line 5318
    local local1, local2, local3, local4, local5, local6, local7
    local local8
    local8 = { }
    local5, local6, local7 = GetColorComponents(arg3)
    local8[arg1.fade_steps + 1] = MakeColor(local5, local6, local7)
    local2 = floor(local5 / arg1.fade_steps)
    local3 = floor(local6 / arg1.fade_steps)
    local4 = floor(local7 / arg1.fade_steps)
    local1 = 1
    local5 = 0
    local6 = 0
    local7 = 0
    while local1 <= arg1.fade_steps do
        local8[local1] = MakeColor(local5, local6, local7)
        local1 = local1 + 1
        local5 = local5 + local2
        local6 = local6 + local3
        local7 = local7 + local4
    end
    return local8
end
credits_menu.destroy = function(arg1) -- line 5347
    arg1.hicolorTable = nil
    arg1.locolorTable = nil
    arg1.lines = nil
    arg1.screens = nil
end
credits_menu.run = function(arg1, arg2, arg3) -- line 5354
    local local1, local2
    arg1:init()
    local1, local2 = readfrom(arg2)
    if local1 == nil then
        PrintDebug("ERROR: " .. local2 .. ": Couldn't open credits file \"" .. arg2 .. "\"!\n")
    else
        arg1:build_screen_buffer()
        readfrom()
        arg1.is_active = TRUE
        arg1.end_game = arg3
        game_pauser:pause(TRUE, arg1, arg1)
        system.characterHandler = nil
        SaveIMuse()
        ImResume()
        if not arg1.end_game then
            ImStopAllSounds()
            ImSetState(stateOPEN_CRED)
        else
            music_state:set_sequence(seqEndCredits)
            music_state:set_state(stateEND_CRED)
        end
        arg1.cur_screen = 1
        while arg1.cur_screen <= arg1.num_screens do
            arg1:fade_in_cur_screen()
            start_script(arg1.move_to_next_screen, arg1)
            wait_for_script(arg1.move_to_next_screen)
            arg1:fade_out_cur_screen()
            arg1.cur_screen = arg1.next_screen
        end
    end
    PrintDebug("done with credits...\n")
    if not arg1.end_game then
        ImSetState(STATE_NULL)
        sleep_for(1000)
        arg1:cancel(TRUE)
        main_menu:run()
    else
        start_script(arg1.end_credits_hook, arg1)
        wait_for_script(arg1.end_credits_hook)
    end
end
credits_menu.cancel = function(arg1, arg2) -- line 5405
    if arg1.is_active then
        if not arg2 then
            game_pauser:pause(FALSE)
        end
        system.characterHandler = nil
        arg1:destroy()
        arg1.is_active = FALSE
    end
    RestoreIMuse()
    ImPause()
end
credits_menu.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 5420
    local local1
    local1 = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    if control_map.OVERRIDE[arg2] or control_map.DIALOG_CHOOSE[arg2] or (arg2 == QKEY and local1) or (arg2 == XKEY and local1) and arg3 then
        stop_script(arg1.move_to_next_screen)
        stop_script(arg1.run)
        stop_script(arg1.end_credits_hook)
        if not arg1.end_game then
            arg1:cancel(TRUE)
            main_menu:run()
        else
            arg1:cancel()
        end
    elseif control_map.TURN_LEFT[arg2] or control_map.MOVE_BACKWARD[arg2] and arg3 then
        arg1.next_screen = arg1.cur_screen - 1
        if arg1.next_screen < 1 then
            arg1.next_screen = arg1.num_screens
        end
        stop_script(arg1.move_to_next_screen)
    elseif control_map.TURN_RIGHT[arg2] or control_map.MOVE_FORWARD[arg2] and arg3 then
        arg1.next_screen = arg1.cur_screen + 1
        if arg1.next_screen > arg1.num_screens then
            arg1.next_screen = 1
        end
        stop_script(arg1.move_to_next_screen)
    end
end
credits_menu.userPaintHandler = function(arg1) -- line 5453
    arg1:fade_colors(arg1.fade_step)
end
credits_menu.end_credits_hook = function(arg1) -- line 5458
    local local1
    if ImSetSequence(-1) ~= SEQ_NULL then
        local1 = TRUE
    else
        local1 = FALSE
    end
    unpause_scripts()
    RenderModeUser(TRUE)
    system.buttonHandler = arg1
    CleanBuffer()
    BlastRect(0, 0, 639, 479, { color = Black, filled = TRUE })
    Display()
    CleanBuffer()
    BlastRect(0, 0, 639, 479, { color = Black, filled = TRUE })
    Display()
    ImSetState(STATE_NULL)
    sleep_for(1000)
    main_menu:load_logo()
    start_script(arg1.fade_in_logo, arg1)
    while ImSetSequence(-1) ~= SEQ_NULL or find_script(arg1.fade_in_logo) do
        break_here()
    end
    if not local1 then
        ImSetSequence(seqPigeonFly)
        sleep_for(2000)
    end
    start_script(arg1.fade_out_logo, arg1)
    while ImSetSequence(-1) ~= SEQ_NULL or find_script(arg1.fade_out_logo) do
        break_here()
    end
end
credits_menu.fade_in_logo = function(arg1) -- line 5502
    local local1
    local1 = 0
    while local1 < 1 do
        CleanBuffer()
        BlastRect(0, 0, 639, 479, { color = Black, filled = TRUE })
        BlastImage(main_menu.logo, DEFAULT_LOGO_X, DEFAULT_LOGO_Y + 40, TRUE)
        DimRegion(DEFAULT_LOGO_X, DEFAULT_LOGO_Y + 40, 182, 117, local1)
        Display()
        break_here()
        local1 = local1 + 0.050000001
    end
    CleanBuffer()
    BlastRect(0, 0, 639, 479, { color = Black, filled = TRUE })
    BlastImage(main_menu.logo, DEFAULT_LOGO_X, DEFAULT_LOGO_Y + 40, TRUE)
    Display()
end
credits_menu.fade_out_logo = function(arg1) -- line 5522
    local local1
    local1 = 1
    while local1 > 0 do
        CleanBuffer()
        BlastRect(0, 0, 639, 479, { color = Black, filled = TRUE })
        BlastImage(main_menu.logo, DEFAULT_LOGO_X, DEFAULT_LOGO_Y + 40, TRUE)
        DimRegion(DEFAULT_LOGO_X, DEFAULT_LOGO_Y + 40, 182, 117, local1)
        Display()
        break_here()
        local1 = local1 - 0.050000001
    end
    CleanBuffer()
    BlastRect(0, 0, 639, 479, { color = Black, filled = TRUE })
    Display()
    break_here()
end
