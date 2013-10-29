DIALOG_AXIS_SENSITIVITY = 0.9
DIALOG_AXIS_REPEAT_DELAY = 800
system.dialogTemplate = { }
Dialog = system.dialogTemplate
Dialog.name = "<dialog>"
Dialog.start_y = 396
Dialog.lo_color = Green
Dialog.hi_color = Yellow
Dialog.height = 22
Dialog.max_line = 4
Dialog.min_line = 2
Dialog.next_new_line = 1
Dialog.current_choices = { }
Dialog.run = function(arg1, arg2, arg3, arg4) -- line 41
    local local1, local2
    PrintDebug("calling RUN with dialog_name = " .. arg2 .. "\n")
    PrintDebug("filename = " .. arg3 .. "\n")
    local2 = getglobal(arg2)
    if local2 then
        message_text:destroy()
        local2:init(arg4)
    else
        local1 = dofile(arg3)
        if not local1 then
            local2 = getglobal(arg2)
            local2:init(arg4)
            return TRUE
        else
            return FALSE
        end
    end
end
Dialog.create = function(arg1) -- line 70
    local local1 = { }
    local1.parent = arg1
    local1.exit_lines = { }
    local1.aborts = { }
    local1.node = "n1"
    local1.selected_line = 1
    local1.next_line = 1
    local1.ypos = Dialog.start_y
    local1.xpos = 10
    local1[999] = "EOD"
    return local1
end
Dialog.init = function(arg1, arg2) -- line 95
    SetOffscreenTextPos(320, 0)
    system.buttonHandler = noButtonHandler
    arg1.node = "n1"
    if arg1.intro then
        arg1:intro(arg2)
        wait_for_message()
    end
    arg1:display_lines()
end
Dialog.display_lines = function(arg1) -- line 118
    local local1
    local local2 = 0
    local local3
    local local4 = arg1.node
    local local5 = arg1.exit_lines[local4]
    local local6
    arg1:clear()
    PrintDebug("Displaying lines...\n")
    if arg1.node ~= "exit_dialog" then
        arg1.selected_line = 1
        arg1.next_line = 1
        arg1.ypos = arg1.start_y
        if local5 then
            local3 = arg1.max_line
        else
            local3 = arg1.max_line + 1
        end
        repeat
            local2 = local2 + 1
            local1 = arg1[local2]
            if type(local1) == "table" and local1.text then
                if local1[local4] and not local1.off and arg1.next_line < local3 then
                    arg1:set_line(local1)
                end
            end
        until local1 == "EOD" or arg1.next_line >= local3
        if local5 then
            arg1:set_line(local5)
        end
        if arg1.next_line <= arg1.min_line then
            local6 = arg1.aborts[local4]
            if local6 then
                local6()
                arg1:display_lines()
            else
                PrintDebug("Couldn't find any viable lines for " .. dialog_node .. "!\n")
                arg1:finish()
            end
        else
            arg1:update_text_height()
            system.buttonHandler = arg1
            AxisHandlerLastValues = { }
            arg1.axisRepeatFunc = nil
            system.axisHandler = arg1
        end
    else
        arg1:finish()
    end
end
Dialog.update_text_height = function(arg1) -- line 192
    local local1 = 472
    local local2 = arg1.next_line - 1
    local local3
    local local4, local5
    while local2 >= 1 do
        local3 = arg1.current_choices[local2].hText
        ChangeTextObject(local3, { x = arg1.xpos })
        local4, local5 = GetTextObjectDimensions(local3)
        local1 = local1 - local5 - 1
        ChangeTextObject(local3, { y = local1 })
        local2 = local2 - 1
    end
end
Dialog.update_colors = function(arg1) -- line 215
    local local1 = 1
    lines = arg1.current_choices
    while lines[local1] do
        if local1 == arg1.selected_line then
            ChangeTextObject(lines[local1].hText, { fgcolor = arg1.hi_color })
        else
            ChangeTextObject(lines[local1].hText, { fgcolor = arg1.lo_color })
        end
        local1 = local1 + 1
    end
end
Dialog.set_line = function(arg1, arg2) -- line 234
    arg1.current_choices[arg1.next_line] = arg2
    arg2.hText = MakeTextObject(arg2.text, { fgcolor = arg1.lo_color, x = arg1.xpos, y = arg1.ypos, font = verb_font })
    if arg1.next_line == arg1.selected_line then
        ChangeTextObject(arg2.hText, { fgcolor = arg1.hi_color })
    end
    arg1.ypos = arg1.ypos + arg1.height
    arg1.next_line = arg1.next_line + 1
    arg1.current_choices[arg1.next_line] = nil
    if arg2.setup then
        arg2:setup()
    end
end
Dialog.clear = function(arg1) -- line 254
    local local1
    local1 = 1
    lines = arg1.current_choices
    while lines[local1] do
        KillTextObject(lines[local1].hText)
        lines[local1] = nil
        local1 = local1 + 1
    end
end
Dialog.finish = function(arg1) -- line 270
    arg1:clear()
    if arg1.outro then
        arg1:outro()
    end
    stop_script(arg1.axis_repeat_handler)
    system.buttonHandler = SampleButtonHandler
    system.axisHandler = SampleAxisHandler
    enable_head_control(TRUE)
    if MarioControl then
        single_start_script(WalkManny)
    end
    SetOffscreenTextPos(nil, nil)
end
Dialog.execute_line = function(arg1, arg2, arg3) -- line 290
    local local1
    local local2 = arg1[arg1.node]
    local local3, local4
    if type(local2) == "function" then
        local2(arg2)
    end
    if type(arg2) == "table" then
        local1 = arg2
    else
        local1 = arg1.current_choices[arg2]
    end
    system.buttonHandler = noButtonHandler
    arg1:clear()
    system.currentActor:say_line(local1.text)
    if local1.gesture then
        PrintDebug("got gesture")
        if type(local1.gesture) == "table" then
            local3, local4 = next(local1.gesture, nil)
            while local3 do
                start_script(local4, system.currentActor, TRUE)
                local3, local4 = next(local1.gesture, local3)
            end
        else
            start_script(local1.gesture, system.currentActor)
        end
    end
    manny:wait_for_message()
    if local1.response then
        local1:response()
        if not arg3 then
            wait_for_message()
        end
    end
    arg1:display_lines()
end
Dialog.force_line = function(arg1, arg2) -- line 341
    arg1:execute_line(arg1[arg2])
end
Dialog.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 354
    if arg2 == AKEY and developerMode then
        arg1:clear()
        start_script(arg1.finish, arg1)
    elseif not CommonButtonHandler(arg2, arg3, arg4) then
        if arg3 then
            if control_map.DIALOG_DOWN[arg2] then
                arg1.selected_line = arg1.selected_line + 1
                if arg1.selected_line >= arg1.next_line then
                    arg1.selected_line = 1
                end
                arg1:update_colors()
            elseif control_map.DIALOG_UP[arg2] then
                arg1.selected_line = arg1.selected_line - 1
                if arg1.selected_line < 1 then
                    arg1.selected_line = arg1.next_line - 1
                end
                arg1:update_colors()
            elseif control_map.DIALOG_CHOOSE[arg2] then
                start_script(arg1.execute_line, arg1, arg1.selected_line)
            end
        end
    end
end
Dialog.axisHandler = function(arg1, arg2, arg3) -- line 387
    local local1
    local local2 = FALSE
    local local3, local4
    local4 = abs(arg3)
    local3 = AxisHandlerLastValues[arg2]
    if local3 == nil then
        local3 = 0
    end
    if local4 > DIALOG_AXIS_SENSITIVITY then
        if abs(local3) < DIALOG_AXIS_SENSITIVITY then
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
        end
    elseif abs(local3) > DIALOG_AXIS_SENSITIVITY then
        local2 = FALSE
        local1 = AxisHandlerMappedIds[arg2]
    end
    AxisHandlerLastValues[arg2] = arg3
    if local1 ~= nil and system.buttonHandler ~= nil then
        call_button_handler(local1, local2)
        if local2 then
            if arg1.axisRepeatFunc == nil then
                arg1.axisRepeatFunc = start_script(arg1.axis_repeat_handler, arg1)
            end
        elseif arg1.axisRepeatFunc ~= nil then
            stop_script(arg1.axisRepeatFunc)
            arg1.axisRepeatFunc = nil
        end
    end
end
Dialog.axis_repeat_handler = function(arg1) -- line 444
    local local1
    while TRUE do
        sleep_for(DIALOG_AXIS_REPEAT_DELAY)
        if get_generic_control_state("DIALOG_UP") then
            local1 = next(control_map.DIALOG_UP, nil)
            call_button_handler(local1, TRUE)
        elseif get_generic_control_state("DIALOG_DOWN") then
            local1 = next(control_map.DIALOG_DOWN, nil)
            call_button_handler(local1, TRUE)
        end
    end
end
