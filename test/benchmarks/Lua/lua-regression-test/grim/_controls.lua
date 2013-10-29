CheckFirstTime("_controls.lua")
WALK = 1
RUN = 2
RETURNKEY = system.controls.KEY_RETURN
SPACEKEY = system.controls.KEY_SPACE
PERIODKEY = system.controls.KEY_PERIOD
COMMAKEY = system.controls.KEY_COMMA
HOMEKEY = system.controls.KEY_HOME
ESCAPEKEY = system.controls.KEY_ESCAPE
EQUALSKEY = system.controls.KEY_EQUALS
MINUSKEY = system.controls.KEY_MINUS
LCONTROLKEY = system.controls.KEY_LCONTROL
RCONTROLKEY = system.controls.KEY_RCONTROL
LSHIFTKEY = system.controls.KEY_LSHIFT
RSHIFTKEY = system.controls.KEY_RSHIFT
LALTKEY = system.controls.KEY_LMENU
RALTKEY = system.controls.KEY_RMENU
BSKEY = system.controls.KEY_BACK
AKEY = system.controls.KEY_A
BKEY = system.controls.KEY_B
CKEY = system.controls.KEY_C
DKEY = system.controls.KEY_D
EKEY = system.controls.KEY_E
FKEY = system.controls.KEY_F
GKEY = system.controls.KEY_G
HKEY = system.controls.KEY_H
IKEY = system.controls.KEY_I
JKEY = system.controls.KEY_J
KKEY = system.controls.KEY_K
LKEY = system.controls.KEY_L
MKEY = system.controls.KEY_M
NKEY = system.controls.KEY_N
OKEY = system.controls.KEY_O
PKEY = system.controls.KEY_P
QKEY = system.controls.KEY_Q
RKEY = system.controls.KEY_R
SKEY = system.controls.KEY_S
TKEY = system.controls.KEY_T
UKEY = system.controls.KEY_U
VKEY = system.controls.KEY_V
WKEY = system.controls.KEY_W
XKEY = system.controls.KEY_X
YKEY = system.controls.KEY_Y
ZKEY = system.controls.KEY_Z
NUMPAD0KEY = system.controls.KEY_NUMPAD0
NUMPAD1KEY = system.controls.KEY_NUMPAD1
NUMPAD2KEY = system.controls.KEY_NUMPAD2
NUMPAD3KEY = system.controls.KEY_NUMPAD3
NUMPAD4KEY = system.controls.KEY_NUMPAD4
NUMPAD5KEY = system.controls.KEY_NUMPAD5
NUMPAD6KEY = system.controls.KEY_NUMPAD6
NUMPAD7KEY = system.controls.KEY_NUMPAD7
NUMPAD8KEY = system.controls.KEY_NUMPAD8
NUMPAD9KEY = system.controls.KEY_NUMPAD9
ADDKEY = system.controls.KEY_ADD
NUMPADENTERKEY = system.controls.KEY_NUMPADENTER
NUMPADDEL = system.controls.KEY_DECIMAL
UPKEY = system.controls.KEY_UP
DOWNKEY = system.controls.KEY_DOWN
RIGHTKEY = system.controls.KEY_RIGHT
LEFTKEY = system.controls.KEY_LEFT
F1KEY = system.controls.KEY_F1
F2KEY = system.controls.KEY_F2
F3KEY = system.controls.KEY_F3
F4KEY = system.controls.KEY_F4
F5KEY = system.controls.KEY_F5
F6KEY = system.controls.KEY_F6
F7KEY = system.controls.KEY_F7
F8KEY = system.controls.KEY_F8
F9KEY = system.controls.KEY_F9
F10KEY = system.controls.KEY_F10
F11KEY = system.controls.KEY_F11
F12KEY = system.controls.KEY_F12
KEY1 = system.controls.KEY_1
KEY2 = system.controls.KEY_2
KEY3 = system.controls.KEY_3
KEY4 = system.controls.KEY_4
KEY5 = system.controls.KEY_5
KEY6 = system.controls.KEY_6
KEY7 = system.controls.KEY_7
KEY8 = system.controls.KEY_8
KEY9 = system.controls.KEY_9
EnableControl(RETURNKEY)
EnableControl(SPACEKEY)
EnableControl(PERIODKEY)
EnableControl(COMMAKEY)
EnableControl(HOMEKEY)
EnableControl(EQUALSKEY)
EnableControl(system.controls.KEY_END)
EnableControl(LCONTROLKEY)
EnableControl(LSHIFTKEY)
EnableControl(RSHIFTKEY)
EnableControl(LALTKEY)
EnableControl(RALTKEY)
EnableControl(BSKEY)
EnableControl(ESCAPEKEY)
EnableControl(AKEY)
EnableControl(BKEY)
EnableControl(CKEY)
EnableControl(DKEY)
EnableControl(EKEY)
EnableControl(FKEY)
EnableControl(GKEY)
EnableControl(HKEY)
EnableControl(IKEY)
EnableControl(JKEY)
EnableControl(KKEY)
EnableControl(LKEY)
EnableControl(MKEY)
EnableControl(NKEY)
EnableControl(OKEY)
EnableControl(PKEY)
EnableControl(QKEY)
EnableControl(RKEY)
EnableControl(SKEY)
EnableControl(TKEY)
EnableControl(UKEY)
EnableControl(VKEY)
EnableControl(WKEY)
EnableControl(XKEY)
EnableControl(YKEY)
EnableControl(ZKEY)
EnableControl(NUMPAD0KEY)
EnableControl(NUMPAD1KEY)
EnableControl(NUMPAD2KEY)
EnableControl(NUMPAD3KEY)
EnableControl(NUMPAD4KEY)
EnableControl(NUMPAD5KEY)
EnableControl(NUMPAD6KEY)
EnableControl(NUMPAD7KEY)
EnableControl(NUMPAD8KEY)
EnableControl(NUMPAD9KEY)
EnableControl(ADDKEY)
EnableControl(NUMPADENTERKEY)
EnableControl(NUMPADDEL)
EnableControl(UPKEY)
EnableControl(DOWNKEY)
EnableControl(RIGHTKEY)
EnableControl(LEFTKEY)
EnableControl(F1KEY)
EnableControl(F2KEY)
EnableControl(F3KEY)
EnableControl(F4KEY)
EnableControl(F5KEY)
EnableControl(F6KEY)
EnableControl(F7KEY)
EnableControl(F8KEY)
EnableControl(F9KEY)
EnableControl(F10KEY)
EnableControl(F11KEY)
EnableControl(F12KEY)
EnableControl(KEY1)
EnableControl(KEY2)
EnableControl(KEY3)
EnableControl(KEY4)
EnableControl(KEY5)
EnableControl(KEY6)
EnableControl(KEY7)
EnableControl(KEY8)
EnableControl(KEY9)
EnableControl(system.controls.KEY_PRIOR)
EnableControl(system.controls.KEY_NEXT)
EnableControl(MINUSKEY)
DriveKeyPressed = { N = nil, S = nil, W = nil, E = nil, NE = nil, NW = nil, SW = nil, SE = nil }
WalkVector = { x = 0, y = 0, z = 0 }
MoveAmount = 2
HalfMove = 1
MANNY_WALK_RATE = 0.4
MANNY_RUN_RATE = 1.5
AXIS_SENSITIVITY = 0.5
JOYSTICK_X_LEFT = 256
JOYSTICK_X_RIGHT = 257
JOYSTICK_Y_UP = 258
JOYSTICK_Y_DOWN = 259
AxisHandlerMappedIds = { }
system.camera_adjust_y = 0
control_map = { }
control_map.MOVE_FORWARD = { }
control_map.MOVE_BACKWARD = { }
control_map.TURN_LEFT = { }
control_map.TURN_RIGHT = { }
control_map.MOVE_NORTH = { }
control_map.MOVE_SOUTH = { }
control_map.MOVE_EAST = { }
control_map.MOVE_WEST = { }
control_map.MOVE_NORTHWEST = { }
control_map.MOVE_NORTHEAST = { }
control_map.MOVE_SOUTHWEST = { }
control_map.MOVE_SOUTHEAST = { }
control_map.LOOK_AT = { }
control_map.USE = { }
control_map.PICK_UP = { }
control_map.INVENTORY = { }
control_map.CHANGE_GAZE = { }
control_map.RUN = { }
control_map.EXPIRE_TEXT = { }
control_map.OVERRIDE = { }
control_map.PAUSE = { }
control_map.DIALOG_UP = { }
control_map.DIALOG_DOWN = { }
control_map.DIALOG_CHOOSE = { }
control_map.PAGE_UP = { }
control_map.PAGE_DOWN = { }
control_map.PAGE_HOME = { }
control_map.PAGE_END = { }
control_map.MENU = { }
control_map.INVENTORY_PREV = { }
control_map.INVENTORY_NEXT = { }
call_button_handler = function(arg1, arg2) -- line 257
    if type(system.buttonHandler) == "table" then
        system.buttonHandler:buttonHandler(arg1, arg2)
    else
        system.buttonHandler(arg1, arg2)
    end
end
WalkManny = function() -- line 270
    local local1, local2, local3
    ResetMarioControls()
    while TRUE do
        if MarioControl and cutSceneLevel <= 0 then
            if not system.currentActor.is_climbing then
                if WalkVector.x ~= 0 or WalkVector.y ~= 0 or WalkVector.z ~= 0 then
                    WalkActorVector(system.currentActor.hActor, GetCameraActor(), WalkVector.x * 0.0099999998, WalkVector.y * 0.0099999998, WalkVector.z * 0.0099999998, system.camera_adjust_y)
                elseif system.currentActor.auto_run then
                    system.currentActor:force_auto_run(FALSE)
                end
            end
            break_here()
        else
            break_here()
        end
    end
end
MarioStyleControl = function(arg1, arg2) -- line 294
    if cutSceneLevel > 0 then
        return
    end
    if system.currentActor.is_climbing then
        TombRaiderControl(arg1, arg2)
        return
    end
    if control_map.MOVE_SOUTH[arg1] then
        if arg2 then
            if not DriveKeyPressed.S then
                DriveKeyPressed.S = TRUE
                WalkVector.y = WalkVector.y - MoveAmount
            end
        elseif DriveKeyPressed.S then
            WalkVector.y = WalkVector.y + MoveAmount
            DriveKeyPressed.S = FALSE
        end
    elseif control_map.MOVE_NORTH[arg1] then
        if arg2 then
            if not DriveKeyPressed.N then
                DriveKeyPressed.N = TRUE
                WalkVector.y = WalkVector.y + MoveAmount
            end
        elseif DriveKeyPressed.N then
            WalkVector.y = WalkVector.y - MoveAmount
            DriveKeyPressed.N = FALSE
        end
    end
    if control_map.MOVE_EAST[arg1] then
        if arg2 then
            if not DriveKeyPressed.E then
                DriveKeyPressed.E = TRUE
                WalkVector.x = WalkVector.x + MoveAmount
            end
        elseif DriveKeyPressed.E then
            WalkVector.x = WalkVector.x - MoveAmount
            DriveKeyPressed.E = FALSE
        end
    elseif control_map.MOVE_WEST[arg1] then
        if arg2 then
            if not DriveKeyPressed.W then
                DriveKeyPressed.W = TRUE
                WalkVector.x = WalkVector.x - MoveAmount
            end
        elseif DriveKeyPressed.W then
            WalkVector.x = WalkVector.x + MoveAmount
            DriveKeyPressed.W = FALSE
        end
    end
    if control_map.MOVE_NORTHWEST[arg1] then
        if arg2 then
            if not DriveKeyPressed.NW then
                DriveKeyPressed.NW = TRUE
                WalkVector.y = WalkVector.y + HalfMove
                WalkVector.x = WalkVector.x - HalfMove
            end
        elseif DriveKeyPressed.NW then
            WalkVector.y = WalkVector.y - HalfMove
            WalkVector.x = WalkVector.x + HalfMove
            DriveKeyPressed.NW = nil
        end
    elseif control_map.MOVE_NORTHEAST[arg1] then
        if arg2 then
            if not DriveKeyPressed.NE then
                DriveKeyPressed.NE = TRUE
                WalkVector.y = WalkVector.y + HalfMove
                WalkVector.x = WalkVector.x + HalfMove
            end
        elseif DriveKeyPressed.NE then
            WalkVector.y = WalkVector.y - HalfMove
            WalkVector.x = WalkVector.x - HalfMove
            DriveKeyPressed.NE = nil
        end
    elseif control_map.MOVE_SOUTHWEST[arg1] then
        if arg2 then
            if not DriveKeyPressed.SW then
                DriveKeyPressed.SW = TRUE
                WalkVector.y = WalkVector.y - HalfMove
                WalkVector.x = WalkVector.x - HalfMove
            end
        elseif DriveKeyPressed.SW then
            WalkVector.y = WalkVector.y + HalfMove
            WalkVector.x = WalkVector.x + HalfMove
            DriveKeyPressed.SW = nil
        end
    elseif control_map.MOVE_SOUTHEAST[arg1] then
        if arg2 then
            if not DriveKeyPressed.SE then
                DriveKeyPressed.SE = TRUE
                WalkVector.y = WalkVector.y - HalfMove
                WalkVector.x = WalkVector.x + HalfMove
            end
        elseif DriveKeyPressed.SE then
            WalkVector.y = WalkVector.y + HalfMove
            WalkVector.x = WalkVector.x - HalfMove
            DriveKeyPressed.SE = nil
        end
    end
end
ResetMarioControls = function() -- line 404
    DriveKeyPressed.N = nil
    DriveKeyPressed.S = nil
    DriveKeyPressed.E = nil
    DriveKeyPressed.W = nil
    DriveKeyPressed.NE = nil
    DriveKeyPressed.NW = nil
    DriveKeyPressed.SW = nil
    DriveKeyPressed.SE = nil
    WalkVector.x = 0
    WalkVector.y = 0
    WalkVector.z = 0
end
TombRaiderControl = function(arg1, arg2) -- line 422
    if not system.currentActor.is_climbing then
        if control_map.MOVE_FORWARD[arg1] then
            if arg2 then
                stop_script(move_actor_backward)
                if find_script(move_actor) == nil then
                    start_script(move_actor, system.currentActor.hActor)
                end
            end
        elseif control_map.MOVE_BACKWARD[arg1] then
            if arg2 then
                stop_script(move_actor)
                if find_script(move_actor_backward) == nil then
                    start_script(move_actor_backward, system.currentActor.hActor)
                end
            else
                system.currentActor:set_walk_backwards(FALSE)
            end
        elseif control_map.TURN_LEFT[arg1] then
            if arg2 then
                stop_script(rotate_actor_right)
                stop_script(strafe_actor_right)
                if altKeyDown then
                    stop_script(rotate_actor_left)
                    if find_script(strafe_actor_left) == nil then
                        start_script(strafe_actor_left, system.currentActor.hActor)
                    end
                else
                    stop_script(strafe_actor_left)
                    if find_script(rotate_actor_left) == nil then
                        start_script(rotate_actor_left, system.currentActor.hActor)
                    end
                end
            else
                stop_script(strafe_actor_left)
                stop_script(rotate_actor_left)
            end
        elseif control_map.TURN_RIGHT[arg1] then
            if arg2 then
                stop_script(rotate_actor_left)
                stop_script(strafe_actor_left)
                if altKeyDown then
                    stop_script(rotate_actor_right)
                    if find_script(strafe_actor_right) == nil then
                        start_script(strafe_actor_right, system.currentActor.hActor)
                    end
                else
                    stop_script(strafe_actor_right)
                    if find_script(rotate_actor_right) == nil then
                        start_script(rotate_actor_right, system.currentActor.hActor)
                    end
                end
            else
                stop_script(strafe_actor_right)
                stop_script(rotate_actor_right)
            end
        end
    elseif control_map.MOVE_FORWARD[arg1] then
        if arg2 then
            stop_script(climb_actor_down)
            single_start_script(climb_actor_up, system.currentActor)
        else
            stop_script(climb_actor_up)
        end
    elseif control_map.MOVE_BACKWARD[arg1] then
        if arg2 then
            stop_script(climb_actor_up)
            single_start_script(climb_actor_down, system.currentActor)
        else
            stop_script(climb_actor_down)
        end
    end
end
SampleAxisHandler = function(arg1, arg2) -- line 510
    local local1
    local local2
    if cutSceneLevel <= 0 then
        if MarioControl and system.buttonHandler == SampleButtonHandler and not system.currentActor.is_climbing and not in(system.currentSet, inv_sets) then
            if arg1 == system.controls.AXIS_JOY1_X then
                if abs(arg2) > AXIS_SENSITIVITY then
                    WalkVector.x = arg2 * MoveAmount
                    local2 = TRUE
                else
                    WalkVector.x = 0
                    local2 = FALSE
                end
            elseif arg1 == system.controls.AXIS_JOY1_Y then
                if abs(arg2) > AXIS_SENSITIVITY then
                    WalkVector.y = -arg2 * MoveAmount
                    local2 = TRUE
                else
                    WalkVector.y = 0
                    local2 = FALSE
                end
            end
        else
            if abs(arg2) > AXIS_SENSITIVITY then
                local2 = TRUE
                if arg1 == system.controls.AXIS_JOY1_X then
                    if arg2 < 0 then
                        local1 = JOYSTICK_X_LEFT
                    else
                        local1 = JOYSTICK_X_RIGHT
                    end
                elseif arg1 == system.controls.AXIS_JOY1_Y then
                    if arg2 < 0 then
                        local1 = JOYSTICK_Y_UP
                    else
                        local1 = JOYSTICK_Y_DOWN
                    end
                end
                AxisHandlerMappedIds[arg1] = local1
            else
                local2 = FALSE
                local1 = AxisHandlerMappedIds[arg1]
            end
            if local1 ~= nil and system.buttonHandler ~= nil then
                call_button_handler(local1, local2)
            end
        end
    end
end
noButtonHandler = function(arg1, arg2, arg3) -- line 569
    CommonButtonHandler(arg1, arg2, arg3)
end
CommonButtonHandler = function(arg1, arg2, arg3) -- line 578
    local local1 = FALSE
    local local2, local3, local4
    if cutSceneLevel == 0 then
        local2 = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    end
    local3 = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    local4 = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    system.currentActor.stop_idle = TRUE
    if arg1 == HOTKEY_EXIT and local4 and arg2 or (arg1 == HOTKEY_QUIT and local4 and arg2) then
        query_exit_game()
        local1 = TRUE
    elseif control_map.MENU[arg1] and arg2 then
        main_menu:run()
        local1 = TRUE
    elseif arg1 == HOTKEY_JOYSTICK_MODE and local3 and arg2 then
        if local4 then
            input_boot_parameter()
        else
            system_prefs:toggle_joystick()
        end
        local1 = TRUE
    elseif arg1 == HOTKEY_TEXT_MODE and local3 and arg2 then
        system_prefs:cycle_speech_mode()
        local1 = TRUE
    elseif control_map.EXPIRE_TEXT[arg1] and arg2 then
        if IsMessageGoing() then
            shut_up_everybody()
            ExpireText()
            local1 = TRUE
        end
    elseif control_map.OVERRIDE[arg1] and arg2 then
        PrintDebug("Override key hit!")
        call_override()
        local1 = TRUE
    elseif control_map.PAUSE[arg1] and arg2 then
        PrintDebug("Pause key hit!")
        query_pause_game()
        local1 = TRUE
    elseif arg1 == HOTKEY_MOVEMENT_MODE and arg2 and local3 then
        system_prefs:toggle_movement_mode()
        local1 = TRUE
    elseif arg1 == EQUALSKEY and local3 and arg2 then
        local local5 = GetTranslationMode()
        local5 = local5 + 1
        if local5 >= 3 then
            local5 = 0
        end
        SetTranslationMode(local5)
        local1 = TRUE
    elseif arg1 == HOTKEY_BRIGHTNESS and local3 and arg2 then
        system_prefs:cycle_gamma()
        local1 = TRUE
    elseif arg1 == QKEY and GetControlState(BSKEY) and arg2 then
        PrintDebug("EMERGENCY COLLISION OVERRIDE.\n")
        emergency_collision_override()
    elseif developerMode then
        if arg1 == AKEY and local3 and arg2 then
            print_actor_coordinates()
            local1 = TRUE
        elseif arg1 == PKEY and local3 and arg2 then
            print_temporary("Executing patch file!")
            dofile("patch")
            local1 = TRUE
        elseif arg1 == EKEY and local3 and arg2 then
            start_script(execute_user_command)
            local1 = TRUE
        end
    end
    return local1
end
SampleButtonHandler = function(arg1, arg2, arg3) -- line 672
    local local1 = FALSE
    if cutSceneLevel == 0 then
        shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    end
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    bsKeyDown = GetControlState(BSKEY)
    stopKeyDown(arg1, arg2)
    anyModifierDown = shiftKeyDown or controlKeyDown or altKeyDown or bsKeyDown
    if bsKeyDown then
        PrintDebug("bskey down!\n")
    end
    if CommonButtonHandler(arg1, arg2, arg3) then
        return
    elseif cutSceneLevel <= 0 then
        if developerMode then
            if arg1 == RKEY and controlKeyDown and arg2 then
                radar_blip()
                local1 = TRUE
            elseif arg1 == NUMPAD5KEY and arg2 then
                if shiftKeyDown then
                    PrintDebug("Trying to put actor at interest...\n")
                    PutActorAtInterest(system.currentActor.hActor)
                    PutActorInSet(system.currentActor.hActor, system.currentSet.setFile)
                    local1 = TRUE
                end
            elseif arg1 == IKEY and controlKeyDown and arg2 then
                if system.currentActor.following_boxes then
                    system.currentActor:ignore_boxes()
                else
                    system.currentActor:follow_boxes()
                end
                local1 = TRUE
            elseif arg1 == NKEY and controlKeyDown and arg2 then
                if setup_name_showing then
                    kill_setup_name()
                else
                    setup_name_showing = TRUE
                end
                local1 = TRUE
            elseif arg1 == NKEY and shiftKeyDown and arg2 then
                system.currentSet:next_set()
                local1 = TRUE
            elseif arg1 == NKEY and altKeyDown and arg2 then
                NextSetup()
                local1 = TRUE
            elseif arg1 == PKEY and altKeyDown and arg2 then
                PreviousSetup()
                local1 = TRUE
            elseif arg1 == PKEY and shiftKeyDown and arg2 then
                system.currentSet:prev_set()
                local1 = TRUE
            elseif arg1 == PKEY and controlKeyDown and arg2 then
                print_temporary("Executing patch file!")
                dofile("patch")
                local1 = TRUE
            elseif arg1 == GKEY and controlKeyDown and arg2 then
                single_start_script(switch_to_set_from_user)
                local1 = TRUE
            elseif arg1 == OKEY and shiftKeyDown and arg2 then
                if system.object_names_showing then
                    system.object_names_showing = FALSE
                    system.currentSet:kill_object_names()
                    system.currentSet:make_objects_visible()
                else
                    system.object_names_showing = TRUE
                    system.currentSet:update_object_names()
                    system.currentSet:make_objects_visible()
                end
                local1 = TRUE
            elseif arg1 == SKEY and altKeyDown and not controlKeyDown and arg2 then
                if not shiftKeyDown then
                    start_script(start_user_script)
                elseif shrinkBoxesEnabled then
                    GlobalShrinkEnabled = FALSE
                    shrinkBoxesEnabled = FALSE
                    print_temporary("Shrink Boxes Disabled!")
                else
                    GlobalShrinkEnabled = TRUE
                    shrinkBoxesEnabled = TRUE
                    print_temporary("Shrink Boxes Enabled!")
                end
            elseif arg1 == VKEY and controlKeyDown and not altKeyDown and arg2 then
                start_script(input_variable_and_print)
                local1 = TRUE
            elseif arg1 == JKEY and arg2 and not controlKeyDown then
                input_boot_parameter()
                local1 = TRUE
            elseif arg1 == LKEY and controlKeyDown and arg2 then
                if system.ambientLight > 0 then
                    set_ambient_light(0)
                else
                    set_ambient_light(1)
                end
            elseif arg1 == LKEY and altKeyDown and arg2 then
                LightMgrStartup()
            elseif arg1 == F3KEY and arg2 then
                if sector_editor.is_active then
                    start_script(sector_editor.finish, sector_editor)
                else
                    start_script(sector_editor.start, sector_editor)
                end
            elseif arg1 == HOMEKEY then
                if spotfinder_active then
                    system.currentActor:setpos(spotfinder:getpos())
                    if controlKeyDown and arg2 then
                        if spotfinder.attached_actor == system.currentActor then
                            PrintDebug("Current actor is DETACHED FROM spotfinder\n")
                            spotfinder.attached_actor = nil
                        else
                            PrintDebug("Current actor is ATTACHED TO spotfinder\n")
                            spotfinder.attached_actor = system.currentActor
                        end
                    end
                else
                    system.currentActor:put_at_interest()
                end
            elseif controlKeyDown then
                if arg1 == SKEY and arg2 then
                    toggle_spotfinder()
                    local1 = TRUE
                elseif arg1 == UKEY and arg2 then
                    print_use_point()
                    local1 = TRUE
                elseif arg1 == OKEY and not shiftKeyDown and arg2 then
                    print_out_point()
                    local1 = TRUE
                elseif arg1 == UPKEY and arg2 or (arg1 == DOWNKEY and arg2) or (arg1 == RIGHTKEY and arg2) or (arg1 == LEFTKEY and arg2) then
                    start_script(move_spotfinder, arg1, altKeyDown)
                    run_spotfinder = FALSE
                    local1 = TRUE
                elseif spotfinder_active and (arg1 == NUMPAD6KEY and arg2 or (arg1 == NUMPAD4KEY and arg2)) then
                    start_script(slow_rotate_manny, arg1)
                    local1 = TRUE
                end
            elseif spotfinder_active and not arg2 then
                run_spotfinder = FALSE
            elseif spotfinder_active then
                if arg1 == UPKEY and arg2 or (arg1 == DOWNKEY and arg2) or (arg1 == RIGHTKEY and arg2) or (arg1 == LEFTKEY and arg2) then
                    start_script(move_spotfinder, arg1, altKeyDown)
                    local1 = TRUE
                end
            end
        end
        if local1 then
            return
        end
        if cutSceneLevel == 0 then
            if control_map.RUN[arg1] and arg2 then
                single_start_script(monitor_run)
            elseif control_map.RUN[arg1] then
                system.currentActor:force_auto_run(FALSE)
            end
            if MarioControl then
                MarioStyleControl(arg1, arg2)
            else
                TombRaiderControl(arg1, arg2)
            end
        end
        if control_map.LOOK_AT[arg1] and arg2 and not anyModifierDown then
            if controlKeyDown and system.currentActor.is_holding then
                start_script(Sentence, "lookAt", system.currentActor.is_holding)
            elseif hot_object then
                start_script(Sentence, "lookAt", hot_object)
            elseif system.currentActor.is_holding then
                PrintDebug("looking at what's in my hand")
                start_script(look_at_item_in_hand)
            else
                PrintDebug("No hot object!\n")
            end
        elseif arg1 == KEY1 and arg2 or (arg1 == KEY2 and arg2) or (arg1 == KEY3 and arg2) or (arg1 == KEY4 and arg2) or (arg1 == KEY5 and arg2) or (arg1 == KEY6 and arg2) or (arg1 == KEY7 and arg2) or (arg1 == KEY8 and arg2) or (arg1 == KEY9 and arg2) or (arg1 == EQUALSKEY and arg2) or (arg1 == MINUSKEY and arg2) then
            start_script(inventory_hot_key_pressed, arg1)
        elseif control_map.PICK_UP[arg1] and arg2 and hot_object and not anyModifierDown then
            if system.currentActor.is_holding then
                PrintDebug("putting away held item")
                start_script(system.currentActor.is_holding.put_away, system.currentActor.is_holding)
            else
                start_script(Sentence, "pickUp", hot_object)
            end
        elseif control_map.PICK_UP[arg1] and arg2 and not anyModifierDown then
            if system.currentActor.is_holding then
                PrintDebug("putting away held item")
                start_script(system.currentActor.is_holding.put_away, system.currentActor.is_holding)
            end
        elseif control_map.USE[arg1] and arg2 and not anyModifierDown then
            if shiftKeyDown or controlKeyDown and system.currentActor.is_holding then
                start_script(Sentence, "use", system.currentActor.is_holding)
            elseif hot_object then
                if system.currentActor.is_holding then
                    PrintDebug("I've got a\t" .. system.currentActor.is_holding.name .. " in my hand!")
                    start_script(Sentence, "use", hot_object, system.currentActor.is_holding)
                elseif hot_object.walkOut then
                    start_script(Sentence, "walkOut", hot_object)
                else
                    start_script(Sentence, "use", hot_object)
                end
            elseif system.currentActor.is_holding then
                start_script(Sentence, "use", system.currentActor.is_holding)
            end
        elseif control_map.CHANGE_GAZE[arg1] and arg2 then
            Change_Gaze()
        elseif control_map.INVENTORY[arg1] and arg2 then
            if inventory_disabled then
                if system.currentSet.name == "Diner" then
                    start_script(reaper_toggle_scythe)
                else
                    system.default_response("not now")
                end
            elseif system.currentActor.is_holding then
                start_script(open_inventory)
            elseif Inventory.num_items == 1 and mo.scythe.owner ~= manny then
                manny:say_line("/syma091/")
            else
                start_script(open_inventory)
            end
        end
    end
end
suitInventoryButtonHandler = function(arg1, arg2, arg3) -- line 983
    shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if arg1 == EKEY and controlKeyDown and arg2 then
        start_script(execute_user_command)
        bHandled = TRUE
    elseif control_map.OVERRIDE[arg1] and arg2 then
        system.currentActor.is_holding = nil
        if manny.dying then
            start_script(dead_close_inventory, TRUE)
        else
            start_script(close_inventory, TRUE)
        end
    elseif control_map.INVENTORY[arg1] and arg2 or (control_map.USE[arg1] and arg2) or (control_map.PICK_UP[arg1] and arg2) and cutSceneLevel <= 0 then
        if manny.dying then
            start_script(dead_close_inventory)
        else
            start_script(close_inventory)
        end
    elseif control_map.INVENTORY_NEXT[arg1] and arg2 and cutSceneLevel <= 0 then
        start_script(Inventory.get_next_inventory_item)
    elseif control_map.INVENTORY_PREV[arg1] and arg2 and cutSceneLevel <= 0 then
        start_script(Inventory.get_previous_inventory_item)
    elseif control_map.LOOK_AT[arg1] and arg2 and cutSceneLevel <= 0 then
        start_script(Sentence, "lookAt", system.currentActor.is_holding)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
SaveTheGame = function(arg1) -- line 1027
    Save("grim" .. arg1 .. ".gsv")
    print_temporary("Game saved in slot " .. arg1 .. ".")
end
LoadTheGame = function(arg1) -- line 1035
    print_temporary("Loading game in slot " .. arg1 .. "...")
    Load("grim" .. arg1 .. ".gsv")
    break_here()
    print_temporary("No valid savegame found in slot " .. arg1 .. ".")
end
EnableAllControls = function() -- line 1052
    local local1, local2
    local1, local2 = next(system.controls, nil)
    while local1 do
        PrintDebug("Enabling " .. local1 .. "...\n")
        EnableControl(local2)
        local1, local2 = next(system.controls, local1)
    end
end
PrintControlDefs = function() -- line 1067
    local local1, local2
    local1, local2 = next(system.controls, nil)
    while local1 do
        PrintDebug("Control Definition: " .. local1 .. "\t\t\t : " .. local2 .. "\n")
        local1, local2 = next(system.controls, local1)
    end
end
PrintControlDefsToFile = function(arg1) -- line 1083
    local local1, local2
    writeto(arg1)
    local1, local2 = next(system.controls, nil)
    while local1 do
        write("Control Definition: " .. local1 .. "\t: " .. local2 .. "\n")
        local1, local2 = next(system.controls, local1)
    end
    writeto()
end
enable_generic_control = function(arg1, arg2, arg3) -- line 1107
    control_map[arg1][arg2] = arg3
    if arg3 then
        if arg2 == JOYSTICK_Y_UP or arg2 == JOYSTICK_Y_DOWN then
            EnableControl(system.controls.AXIS_JOY1_Y)
        elseif arg2 == JOYSTICK_X_LEFT or arg2 == JOYSTICK_X_RIGHT then
            EnableControl(system.controls.AXIS_JOY1_X)
        else
            EnableControl(arg2)
        end
    elseif arg2 == JOYSTICK_Y_UP or arg2 == JOYSTICK_Y_DOWN then
        DisableControl(system.controls.AXIS_JOY1_Y)
    elseif arg2 == JOYSTICK_X_LEFT or arg2 == JOYSTICK_X_RIGHT then
        DisableControl(system.controls.AXIS_JOY1_X)
    end
end
enable_default_keyboard_controls = function(arg1) -- line 1140
    enable_generic_control("MOVE_FORWARD", system.controls.KEY_NUMPAD8, arg1)
    enable_generic_control("MOVE_BACKWARD", system.controls.KEY_NUMPAD2, arg1)
    enable_generic_control("TURN_LEFT", system.controls.KEY_NUMPAD4, arg1)
    enable_generic_control("TURN_RIGHT", system.controls.KEY_NUMPAD6, arg1)
    enable_generic_control("MOVE_NORTH", system.controls.KEY_NUMPAD8, arg1)
    enable_generic_control("MOVE_SOUTH", system.controls.KEY_NUMPAD2, arg1)
    enable_generic_control("MOVE_WEST", system.controls.KEY_NUMPAD4, arg1)
    enable_generic_control("MOVE_EAST", system.controls.KEY_NUMPAD6, arg1)
    enable_generic_control("MOVE_NORTHWEST", system.controls.KEY_NUMPAD7, arg1)
    enable_generic_control("MOVE_NORTHEAST", system.controls.KEY_NUMPAD9, arg1)
    enable_generic_control("MOVE_SOUTHWEST", system.controls.KEY_NUMPAD1, arg1)
    enable_generic_control("MOVE_SOUTHEAST", system.controls.KEY_NUMPAD3, arg1)
    enable_generic_control("LOOK_AT", system.controls.KEY_NUMPAD5, arg1)
    enable_generic_control("USE", system.controls.KEY_NUMPADENTER, arg1)
    enable_generic_control("PICK_UP", system.controls.KEY_ADD, arg1)
    enable_generic_control("INVENTORY", system.controls.KEY_NUMPAD0, arg1)
    enable_generic_control("CHANGE_GAZE", system.controls.KEY_DECIMAL, arg1)
    enable_generic_control("EXPIRE_TEXT", system.controls.KEY_PERIOD, arg1)
    enable_generic_control("EXPIRE_TEXT", system.controls.KEY_DECIMAL, arg1)
    enable_generic_control("OVERRIDE", system.controls.KEY_ESCAPE, arg1)
    enable_generic_control("RUN", system.controls.KEY_LSHIFT, arg1)
    enable_generic_control("RUN", system.controls.KEY_RSHIFT, arg1)
    enable_generic_control("DIALOG_UP", system.controls.KEY_NUMPAD8, arg1)
    enable_generic_control("DIALOG_DOWN", system.controls.KEY_NUMPAD2, arg1)
    enable_generic_control("DIALOG_CHOOSE", system.controls.KEY_NUMPADENTER, arg1)
    enable_generic_control("PAGE_UP", system.controls.KEY_NUMPAD9, arg1)
    enable_generic_control("PAGE_DOWN", system.controls.KEY_NUMPAD3, arg1)
    enable_generic_control("PAGE_HOME", system.controls.KEY_NUMPAD7, arg1)
    enable_generic_control("PAGE_END", system.controls.KEY_NUMPAD1, arg1)
    enable_generic_control("INVENTORY_NEXT", system.controls.KEY_NUMPAD6, arg1)
    enable_generic_control("INVENTORY_PREV", system.controls.KEY_NUMPAD4, arg1)
    enable_generic_control("MENU", system.controls.KEY_F1, arg1)
end
enable_joystick_controls = function(arg1) -- line 1185
    joystick_enabled = arg1
    enable_generic_control("MOVE_FORWARD", JOYSTICK_Y_UP, arg1)
    enable_generic_control("MOVE_BACKWARD", JOYSTICK_Y_DOWN, arg1)
    enable_generic_control("TURN_LEFT", JOYSTICK_X_LEFT, arg1)
    enable_generic_control("TURN_RIGHT", JOYSTICK_X_RIGHT, arg1)
    enable_generic_control("MOVE_NORTH", JOYSTICK_Y_UP, arg1)
    enable_generic_control("MOVE_SOUTH", JOYSTICK_Y_DOWN, arg1)
    enable_generic_control("MOVE_WEST", JOYSTICK_X_LEFT, arg1)
    enable_generic_control("MOVE_EAST", JOYSTICK_X_RIGHT, arg1)
    enable_generic_control("LOOK_AT", system.controls.KEY_JOY1_B1, arg1)
    enable_generic_control("USE", system.controls.KEY_JOY1_B2, arg1)
    enable_generic_control("PICK_UP", system.controls.KEY_JOY1_B3, arg1)
    enable_generic_control("INVENTORY", system.controls.KEY_JOY1_B4, arg1)
    enable_generic_control("CHANGE_GAZE", system.controls.KEY_JOY1_B7, arg1)
    enable_generic_control("EXPIRE_TEXT", system.controls.KEY_JOY1_B7, arg1)
    enable_generic_control("OVERRIDE", system.controls.KEY_JOY1_B6, arg1)
    enable_generic_control("RUN", system.controls.KEY_JOY1_B5, arg1)
    enable_generic_control("RUN", system.controls.KEY_JOY1_B8, arg1)
    enable_generic_control("DIALOG_UP", JOYSTICK_Y_UP, arg1)
    enable_generic_control("DIALOG_DOWN", JOYSTICK_Y_DOWN, arg1)
    enable_generic_control("DIALOG_CHOOSE", system.controls.KEY_JOY1_B1, arg1)
    enable_generic_control("DIALOG_CHOOSE", system.controls.KEY_JOY1_B2, arg1)
    enable_generic_control("INVENTORY_NEXT", JOYSTICK_X_RIGHT, arg1)
    enable_generic_control("INVENTORY_PREV", JOYSTICK_X_LEFT, arg1)
    enable_generic_control("DIALOG_UP", system.controls.KEY_JOY1_HUP, arg1)
    enable_generic_control("DIALOG_DOWN", system.controls.KEY_JOY1_HDOWN, arg1)
    enable_generic_control("INVENTORY_NEXT", system.controls.KEY_JOY1_HRIGHT, arg1)
    enable_generic_control("INVENTORY_PREV", system.controls.KEY_JOY1_HLEFT, arg1)
    enable_generic_control("MENU", system.controls.KEY_JOY1_B9, arg1)
end
enable_cursor_keyboard_controls = function(arg1) -- line 1231
    enable_generic_control("MOVE_FORWARD", system.controls.KEY_UP, arg1)
    enable_generic_control("MOVE_BACKWARD", system.controls.KEY_DOWN, arg1)
    enable_generic_control("TURN_LEFT", system.controls.KEY_LEFT, arg1)
    enable_generic_control("TURN_RIGHT", system.controls.KEY_RIGHT, arg1)
    enable_generic_control("MOVE_NORTH", system.controls.KEY_UP, arg1)
    enable_generic_control("MOVE_SOUTH", system.controls.KEY_DOWN, arg1)
    enable_generic_control("MOVE_WEST", system.controls.KEY_LEFT, arg1)
    enable_generic_control("MOVE_EAST", system.controls.KEY_RIGHT, arg1)
    if HOTKEY_EXAMINE then
        enable_generic_control("LOOK_AT", HOTKEY_EXAMINE, arg1)
    end
    if HOTKEY_USE then
        enable_generic_control("USE", HOTKEY_USE, arg1)
    end
    if HOTKEY_PICKUP then
        enable_generic_control("PICK_UP", HOTKEY_PICKUP, arg1)
    end
    if HOTKEY_INVENTORY then
        enable_generic_control("INVENTORY", HOTKEY_INVENTORY, arg1)
    end
    enable_generic_control("USE", system.controls.KEY_RETURN, arg1)
    enable_generic_control("INVENTORY", system.controls.KEY_INSERT, arg1)
    enable_generic_control("CHANGE_GAZE", system.controls.KEY_DELETE, arg1)
    enable_generic_control("DIALOG_UP", system.controls.KEY_UP, arg1)
    enable_generic_control("DIALOG_DOWN", system.controls.KEY_DOWN, arg1)
    enable_generic_control("DIALOG_CHOOSE", system.controls.KEY_RETURN, arg1)
    enable_generic_control("PAGE_UP", system.controls.KEY_PRIOR, arg1)
    enable_generic_control("PAGE_DOWN", system.controls.KEY_NEXT, arg1)
    enable_generic_control("PAGE_HOME", system.controls.KEY_HOME, arg1)
    enable_generic_control("PAGE_END", system.controls.KEY_END, arg1)
    enable_generic_control("INVENTORY_NEXT", system.controls.KEY_RIGHT, arg1)
    enable_generic_control("INVENTORY_PREV", system.controls.KEY_LEFT, arg1)
    if ALTHOTKEY_EXAMINE then
        enable_generic_control("LOOK_AT", ALTHOTKEY_EXAMINE, arg1)
    end
    if ALTHOTKEY_USE then
        enable_generic_control("USE", ALTHOTKEY_USE, arg1)
    end
    if ALTHOTKEY_PICKUP then
        enable_generic_control("PICK_UP", ALTHOTKEY_PICKUP, arg1)
    end
    if ALTHOTKEY_INVENTORY then
        enable_generic_control("INVENTORY", ALTHOTKEY_INVENTORY, arg1)
    end
end
get_generic_control_state = function(arg1) -- line 1298
    local local1, local2
    local local3 = FALSE
    local local4
    local1, local2 = next(control_map[arg1], nil)
    while local1 ~= nil and local3 == FALSE do
        local3 = get_control_state(local1)
        local1, local2 = next(control_map[arg1], local1)
    end
    return local3
end
get_control_state = function(arg1) -- line 1322
    local local1
    if arg1 == JOYSTICK_Y_UP then
        local1 = GetControlState(system.controls.AXIS_JOY1_Y)
        if local1 < -AXIS_SENSITIVITY then
            return TRUE
        else
            return FALSE
        end
    elseif arg1 == JOYSTICK_Y_DOWN then
        local1 = GetControlState(system.controls.AXIS_JOY1_Y)
        if local1 > AXIS_SENSITIVITY then
            return TRUE
        else
            return FALSE
        end
    elseif arg1 == JOYSTICK_X_LEFT then
        local1 = GetControlState(system.controls.AXIS_JOY1_X)
        if local1 < -AXIS_SENSITIVITY then
            return TRUE
        else
            return FALSE
        end
    elseif arg1 == JOYSTICK_X_RIGHT then
        local1 = GetControlState(system.controls.AXIS_JOY1_X)
        if local1 > AXIS_SENSITIVITY then
            return TRUE
        else
            return FALSE
        end
    else
        return GetControlState(arg1)
    end
end
system.buttonHandler = SampleButtonHandler
system.axisHandler = SampleAxisHandler
