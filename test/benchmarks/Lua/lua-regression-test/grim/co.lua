CheckFirstTime("co.lua")
co = Set:create("co.set", "Copal's Office", { co_winws = 0, co_dskha = 1, co_comcu = 2, co_dskrv = 3, overhead = 4 })
co.shrinkable = 0.019
copal = Actor:create(nil, nil, nil, "/cotx001/")
copal:set_talk_color(Blue)
copal:set_visibility(FALSE)
co.set_up_actors = function(arg1) -- line 20
end
co.enter = function(arg1) -- line 32
    co:set_up_actors()
    SetShadowColor(15, 15, 15)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 30)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
co.exit = function(arg1) -- line 45
    KillActorShadows(manny.hActor)
    copal:free()
end
co.camerachange = function(arg1, arg2, arg3) -- line 51
    if arg3 ~= co_comcu and co.computer.interface_active then
        co:current_setup(co_comcu)
    end
end
co.computer = Object:create(co, "/cotx002/computer", 0.169416, 2.6942501, 0.40000001, { range = 1 })
co.computer.use_pnt_x = 0.48500001
co.computer.use_pnt_y = 2.7030001
co.computer.use_pnt_z = 0
co.computer.use_rot_x = 0
co.computer.use_rot_y = 89.369904
co.computer.use_rot_z = 0
co.computer.set_to_sign = FALSE
co.computer.auto_response = 3
co.computer.choices = { }
co.computer.choices[0] = "/coco005/"
co.computer.choices[1] = "/coco006/"
co.computer.choices[2] = "/coco007/"
co.computer.choices[3] = "/coco008/"
co.computer.choices[4] = "/coco009/"
co.computer.choices[5] = "/coco010/"
co.computer.choices[6] = "/coco011/"
co.computer.choices[7] = "/coco012/"
co.computer.choices[8] = "/coco013/"
co.computer.choices[9] = "/coco014/"
co.computer.lookAt = function(arg1) -- line 87
    START_CUT_SCENE()
    co.computer.used = TRUE
    manny:say_line("/coma003/")
    manny:wait_for_message()
    END_CUT_SCENE()
end
co.computer.use = function(arg1) -- line 95
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    if not co.computer.used then
        co.computer.used = TRUE
        co.computer:lookAt()
        wait_for_message()
    end
    arg1:start_interface()
    END_CUT_SCENE()
end
co.computer.respond = function(arg1, arg2) -- line 118
    if not arg2 then
        arg2 = co.computer.auto_response
        copal:say_line(co.computer.choices[arg2 - 1])
    elseif arg2 >= 1 and arg2 <= 10 then
        copal:say_line(co.computer.choices[arg2 - 1])
    end
    copal:wait_for_message()
end
co.computer.top_line = 0
co.computer.max_lines = 6
co.computer.text = { x = 200, y = 150, line_height = 40 }
co.computer.selection = 0
co.computer.text_color_bright = MakeColor(200, 100, 0)
co.computer.hilite_color_bright = MakeColor(255, 150, 0)
co.computer.text_color_dim = MakeColor(150, 100, 0)
co.computer.hilite_color_dim = MakeColor(220, 115, 0)
co.computer.background_color = MakeColor(80, 50, 0)
co.computer.text_color = co.computer.text_color_bright
co.computer.hilite_color = co.computer.hilite_color_bright
co.computer.text_objs = { }
co.computer.check_objs = { }
co.computer.select_rect = { }
co.computer.start_interface = function(arg1) -- line 148
    local local1
    local local2
    local local3
    manny:push_costume("ma_note_type.cos")
    manny:play_chore(ma_note_type_to_type, "ma_note_type.cos")
    manny:wait_for_chore()
    manny:put_in_set(nil)
    system.buttonHandler = arg1
    local3 = { fgcolor = co.computer.text_color, font = computer_font }
    local3.x = co.computer.text.x
    local3.y = co.computer.text.y
    local3.width = co.computer.text.x + 280
    local3.height = co.computer.text.y + co.computer.text.line_height
    local1 = 0
    co.computer.select_rect.lines = 18
    while local1 < co.computer.select_rect.lines do
        co.computer.select_rect[local1] = DrawLine(local3.x - 25, local3.y - 5 + local1 * 2, local3.x + 280, local3.y - 5 + local1 * 2, { color = co.computer.background_color, layer = 1 })
        local1 = local1 + 1
    end
    co.computer.select_x = DrawPolygon({ local3.x - 20, local3.y, local3.x - 10, local3.y + 10, local3.x - 20, local3.y + 10, local3.x - 10, local3.y }, { color = local3.fgcolor })
    local1 = co.computer.auto_response - 1
    if local1 >= co.computer.top_line and local1 < co.computer.top_line + co.computer.max_lines then
        local2 = co.computer.text.y + co.computer.text.line_height * (local1 - co.computer.top_line)
    else
        local2 = 500
    end
    ChangePrimitive(co.computer.select_x, { y = local2 })
    local1 = 0
    while local1 < co.computer.max_lines do
        if local1 == co.computer.selection - co.computer.top_line then
            local3.fgcolor = co.computer.hilite_color
        else
            local3.fgcolor = co.computer.text_color
        end
        co.computer.text_objs[local1] = MakeTextObject(co.computer.choices[local1], local3)
        co.computer.check_objs[local1] = DrawRectangle(local3.x - 20, local3.y, local3.x - 10, local3.y + 10, { color = co.computer.text_color })
        local1 = local1 + 1
        local3.y = local3.y + co.computer.text.line_height
        local3.height = local3.height + co.computer.text.line_height
    end
    start_script(co.computer.flicker, co.computer)
    co.computer.scanline = { }
    co.computer.scanline.x = co.computer.text.x - 65
    co.computer.scanline.y = co.computer.text.y
    co.computer.scanline.obj = DrawRectangle(co.computer.scanline.x, co.computer.scanline.y, co.computer.scanline.x + 370, co.computer.scanline.y + 1, { color = MakeColor(20, 20, 20), filled = TRUE, layer = 1 })
    start_script(co.computer.cycle_scanline, co.computer)
    cameraman_disabled = TRUE
    co:current_setup(co_comcu)
    co.computer.interface_active = TRUE
    start_sfx("vectrex.imu")
end
co.computer.stop_interface = function(arg1) -- line 218
    local local1
    co.computer.interface_active = FALSE
    stop_script(co.computer.flicker)
    stop_script(co.computer.cycle_scanline)
    PurgePrimitiveQueue()
    local1 = 0
    while local1 < co.computer.max_lines do
        KillTextObject(co.computer.text_objs[local1])
        local1 = local1 + 1
    end
    system.buttonHandler = SampleButtonHandler
    stop_sound("vectrex.imu")
    START_CUT_SCENE()
    manny:put_in_set(co)
    manny:setpos(co.computer.use_pnt_x, co.computer.use_pnt_y, co.computer.use_pnt_z)
    manny:setrot(co.computer.use_rot_x, co.computer.use_rot_y, co.computer.use_rot_z)
    cameraman_disabled = FALSE
    co:current_setup(co_dskha)
    manny:play_chore(ma_note_type_type_to_home, "ma_note_type.cos")
    manny:wait_for_chore()
    manny:pop_costume()
    manny:play_chore(ms_rest, "ms.cos")
    END_CUT_SCENE()
    if co.computer.auto_response == 5 then
        co.computer.set_to_sign = TRUE
    else
        co.computer.set_to_sign = FALSE
    end
end
co.computer.cycle_scanline = function(arg1) -- line 255
    while TRUE do
        co.computer.scanline.y = co.computer.scanline.y + 4
        if co.computer.scanline.y > 400 then
            co.computer.scanline.y = co.computer.text.y
        end
        ChangePrimitive(co.computer.scanline.obj, { y = co.computer.scanline.y })
        break_here()
    end
end
co.computer.flicker = function(arg1) -- line 266
    local local1
    while TRUE do
        if co.computer.text_color == co.computer.text_color_bright then
            co.computer.text_color = co.computer.text_color_dim
            co.computer.hilite_color = co.computer.hilite_color_dim
        else
            co.computer.text_color = co.computer.text_color_bright
            co.computer.hilite_color = co.computer.hilite_color_bright
        end
        start_script(co.computer.draw_choices, co.computer)
        break_here()
    end
end
co.computer.draw_choices = function(arg1) -- line 282
    local local1 = co.computer.text.y + (co.computer.selection - co.computer.top_line) * co.computer.text.line_height
    local local2
    local local3
    local local4
    local3 = 0
    while local3 < co.computer.select_rect.lines do
        ChangePrimitive(co.computer.select_rect[local3], { y = local1 - 5 + local3 * 2 })
        local3 = local3 + 1
    end
    if co.computer.auto_response > co.computer.top_line and co.computer.auto_response - 1 < co.computer.top_line + co.computer.max_lines then
        local2 = co.computer.text.y + (co.computer.auto_response - 1 - co.computer.top_line) * co.computer.text.line_height
    else
        local2 = 500
    end
    local4 = { y = local2 }
    if co.computer.auto_response == co.computer.selection + 1 then
        local4.color = co.computer.hilite_color
    else
        local4.color = co.computer.text_color
    end
    ChangePrimitive(co.computer.select_x, local4)
    local3 = 0
    local4 = { fgcolor = co.computer.text_color }
    while local3 < co.computer.max_lines do
        if local3 == co.computer.selection - co.computer.top_line then
            local4.fgcolor = co.computer.hilite_color
        else
            local4.fgcolor = co.computer.text_color
        end
        ChangeTextObject(co.computer.text_objs[local3], co.computer.choices[co.computer.top_line + local3], local4)
        ChangePrimitive(co.computer.check_objs[local3], { color = local4.fgcolor })
        local3 = local3 + 1
    end
end
co.computer.scroll_down = function(arg1) -- line 323
    local local1
    if co.computer.selection < co.computer.top_line + co.computer.max_lines - 1 then
        start_sfx("cpuBeep2.wav")
        co.computer.selection = co.computer.selection + 1
    else
        local1 = co.computer.selection + 1
        if co.computer.choices[local1] ~= nil then
            start_sfx("cpuBeep2.wav")
            co.computer.top_line = co.computer.top_line + 1
            co.computer.selection = local1
        else
            start_sfx("cpuArrow.WAV")
        end
    end
    start_script(co.computer.draw_choices, co.computer)
end
co.computer.scroll_up = function(arg1) -- line 342
    local local1
    if co.computer.selection > co.computer.top_line then
        start_sfx("cpuBeep2.wav")
        co.computer.selection = co.computer.selection - 1
    else
        local1 = co.computer.selection - 1
        if co.computer.choices[local1] ~= nil then
            start_sfx("cpuBeep2.wav")
            co.computer.top_line = co.computer.top_line - 1
            co.computer.selection = local1
        else
            start_sfx("cpuArrow.WAV")
        end
    end
    start_script(co.computer.draw_choices, co.computer)
end
co.computer.make_selection = function(arg1) -- line 361
    START_CUT_SCENE()
    if not co.computer.changed_response then
        co.computer.changed_response = TRUE
        wait_for_message()
        manny:say_line("/coma004/")
        manny:wait_for_message()
    end
    start_sfx("cpuBeep1.wav")
    if co.computer.auto_response ~= co.computer.selection + 1 then
        co.computer.auto_response = co.computer.selection + 1
        start_script(co.computer.draw_choices, co.computer)
        co.computer:respond(co.computer.auto_response)
    end
    if co.computer.auto_response == 5 then
        co.computer.set_to_sign = TRUE
    else
        co.computer.set_to_sign = FALSE
    end
    start_script(arg1.stop_interface, arg1)
    END_CUT_SCENE()
end
co.computer.select_response = function(arg1) -- line 387
    START_CUT_SCENE()
    if not co.computer.changed_response then
        co.computer.changed_response = TRUE
        wait_for_message()
        manny:say_line("/coma004/")
        manny:wait_for_message()
    end
    co.computer.auto_response = co.computer.selection + 1
    if co.computer.auto_response == 5 then
        co.computer.set_to_sign = TRUE
    else
        co.computer.set_to_sign = FALSE
    end
    start_sfx("cpuBeep2.WAV")
    start_script(co.computer.draw_choices, co.computer)
    copal:say_line(co.computer.choices[co.computer.selection])
    END_CUT_SCENE()
end
co.computer.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 409
    if control_map.OVERRIDE[arg2] and arg3 then
        start_script(arg1.stop_interface, arg1)
    elseif control_map.MOVE_BACKWARD[arg2] or control_map.MOVE_SOUTH[arg2] and arg3 then
        if not find_script(co.computer.wait_for_joystick_release) then
            co.computer:scroll_down()
            start_script(co.computer.wait_for_joystick_release, co.computer, "MOVE_BACKWARD")
        end
    elseif control_map.MOVE_FORWARD[arg2] or control_map.MOVE_NORTH[arg2] and arg3 then
        if not find_script(co.computer.wait_for_joystick_release) then
            co.computer:scroll_up()
            start_script(co.computer.wait_for_joystick_release, co.computer, "MOVE_FORWARD")
        end
    elseif control_map.LOOK_AT[arg2] and arg3 then
        copal:say_line(co.computer.choices[co.computer.selection])
    elseif control_map.TURN_LEFT[arg2] or control_map.TURN_RIGHT[arg2] or control_map.MOVE_WEST[arg2] or control_map.MOVE_EAST[arg2] or control_map.PICK_UP[arg2] or arg2 == SPACEKEY and arg3 then
        start_script(co.computer.select_response, co.computer)
    elseif control_map.USE[arg2] and arg3 then
        start_script(co.computer.make_selection, co.computer)
    else
        CommonButtonHandler(arg2, arg3, arg4)
    end
end
co.computer.wait_for_joystick_release = function(arg1, arg2) -- line 435
    local local1
    local1 = 0
    while get_generic_control_state(arg2) do
        break_here()
        local1 = local1 + system.frameTime
        if local1 >= 600 then
            local1 = 0
            if arg2 == "MOVE_BACKWARD" then
                co.computer:scroll_down()
            elseif arg2 == "MOVE_FORWARD" then
                co.computer:scroll_up()
            end
        end
    end
end
co.papers = Object:create(co, "/cotx017/papers", 1.0006, 2.3396599, 0.23999999, { range = 0.60000002 })
co.papers.use_pnt_x = 1.0405999
co.papers.use_pnt_y = 2.6796601
co.papers.use_pnt_z = 0
co.papers.use_rot_x = 0
co.papers.use_rot_y = -543.66901
co.papers.use_rot_z = 0
co.papers.lookAt = function(arg1) -- line 462
    if not arg1.count then
        manny:say_line("/coma018/")
    else
        manny:say_line("/coma019/")
    end
end
co.papers.pickUp = function(arg1) -- line 470
    if not arg1.count then
        arg1.count = 1
        manny:say_line("/coma020/")
    elseif arg1.count == 1 then
        arg1.count = 2
        manny:say_line("/coma021/")
    else
        manny:say_line("/coma022/")
    end
end
co.papers.use = co.papers.pickUp
co.papers2 = Object:create(co, "/cotx023/papers", 0.342592, 2.95924, 0.16, { range = 0.60000002 })
co.papers2.use_pnt_x = 0.61259198
co.papers2.use_pnt_y = 2.88924
co.papers2.use_pnt_z = 0
co.papers2.use_rot_x = 0
co.papers2.use_rot_y = -659.94598
co.papers2.use_rot_z = 0
co.papers2.parent = co.papers
co.papers3 = Object:create(co, "/cotx024/papers", 0.80143601, 1.29921, 0.28, { range = 0.60000002 })
co.papers3.use_pnt_x = 1.15144
co.papers3.use_pnt_y = 1.51921
co.papers3.use_pnt_z = 0
co.papers3.use_rot_x = 0
co.papers3.use_rot_y = -592.19501
co.papers3.use_rot_z = 0
co.papers3.parent = co.papers
co.files = Object:create(co, "/cotx025/files", 1.43548, 1.26357, 0.37, { range = 0.60000002 })
co.files.use_pnt_x = 1.2846
co.files.use_pnt_y = 1.4451801
co.files.use_pnt_z = 0
co.files.use_rot_x = 0
co.files.use_rot_y = -517.82001
co.files.use_rot_z = 0
co.files.parent = co.papers
co.files.lookAt = function(arg1) -- line 514
    manny:say_line("/coma026/")
end
co.files2 = Object:create(co, "/cotx027/files", 0.16481, 2.3450899, 0.38999999, { range = 0.60000002 })
co.files2.use_pnt_x = 0.32481
co.files2.use_pnt_y = 2.1250999
co.files2.use_pnt_z = 0
co.files2.use_rot_x = 0
co.files2.use_rot_y = -695.60602
co.files2.use_rot_z = 0
co.files2.parent = co.files
co.memo1 = Object:create(co, "/cotx028/memo", 0.570032, 2.25, 0.28999999, { range = 0.60000002 })
co.memo1.use_pnt_x = 0.54003203
co.memo1.use_pnt_y = 2.05
co.memo1.use_pnt_z = 0
co.memo1.use_rot_x = 0
co.memo1.use_rot_y = -361.99701
co.memo1.use_rot_z = 0
co.memo1.lookAt = function(arg1) -- line 536
    START_CUT_SCENE()
    manny:say_line("/coma029/")
    wait_for_message()
    manny:say_line("/coma030/")
    wait_for_message()
    manny:say_line("/coma031/")
    END_CUT_SCENE()
end
co.memo1.pickUp = function(arg1) -- line 546
    system.default_response("need")
end
co.memo1.use = co.memo1.lookAt
co.memo2 = Object:create(co, "/cotx032/memo", 0.99741602, 2.24, 0.36000001, { range = 0.60000002 })
co.memo2.use_pnt_x = 0.99741602
co.memo2.use_pnt_y = 2.05
co.memo2.use_pnt_z = 0
co.memo2.use_rot_x = 0
co.memo2.use_rot_y = -351.08899
co.memo2.use_rot_z = 0
co.memo2.lookAt = function(arg1) -- line 561
    START_CUT_SCENE()
    manny:say_line("/coma033/")
    wait_for_message()
    manny:say_line("/coma034/")
    wait_for_message()
    manny:say_line("/coma035/")
    END_CUT_SCENE()
end
co.memo2.pickUp = function(arg1) -- line 571
    system.default_response("need")
end
co.memo2.use = co.memo2.lookAt
co.tube = Object:create(co, "/cotx036/tube", 1.51164, 2.26577, 0.34999999, { range = 0.60000002 })
co.tube.use_pnt_x = 1.34164
co.tube.use_pnt_y = 2.26577
co.tube.use_pnt_z = 0
co.tube.use_rot_x = 0
co.tube.use_rot_y = -90.910896
co.tube.use_rot_z = 0
co.tube.lookAt = function(arg1) -- line 587
    soft_script()
    manny:say_line("/coma037/")
    wait_for_message()
    manny:say_line("/coma038/")
end
co.tube.pickUp = function(arg1) -- line 594
    system.default_response("attached")
end
co.tube.use = function(arg1) -- line 598
    dom.tube_object:use()
end
co.message_board = Object:create(co, "/cotx039/board", 1.59978, 2.35584, 0.57999998, { range = 0.60000002 })
co.message_board.use_pnt_x = 1.34978
co.message_board.use_pnt_y = 2.2458401
co.message_board.use_pnt_z = 0
co.message_board.use_rot_x = 0
co.message_board.use_rot_y = -806.77802
co.message_board.use_rot_z = 0
co.message_board.lookAt = function(arg1) -- line 612
    START_CUT_SCENE()
    manny:say_line("/coma040/")
    wait_for_message()
    manny:say_line("/coma041/")
    END_CUT_SCENE()
end
co.message_board.pickUp = function(arg1) -- line 620
    system.default_response("need")
end
co.message_board.use = co.message_board.lookAt
co.le_door = Object:create(co, "/cotx015/window", 1.0090801, 3.33602, 0.53640002, { range = 0.89999998 })
co.le_door_box = co.le_door
co.le_door.use_pnt_x = 1.05428
co.le_door.use_pnt_y = 2.99512
co.le_door.use_pnt_z = 0
co.le_door.use_rot_x = 0
co.le_door.use_rot_y = 357.89499
co.le_door.use_rot_z = 0
co.le_door.out_pnt_x = 1.05428
co.le_door.out_pnt_y = 2.99512
co.le_door.out_pnt_z = 0
co.le_door.out_rot_x = 0
co.le_door.out_rot_y = 357.89499
co.le_door.out_rot_z = 0
co.le_door.use = function(arg1) -- line 649
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:clear_hands()
    co:current_setup(co_winws)
    manny:push_costume("ma_enter_office.cos")
    manny:play_chore(ma_enter_office_step_in_do, "ma_enter_office.cos")
    sleep_for(600)
    start_sfx("maGrbWnd.WAV")
    manny:wait_for_chore()
    manny:stop_chore(ma_enter_office_step_in_do, "ma_enter_office.cos")
    manny:pop_costume()
    END_CUT_SCENE()
    le:come_out_door(le.co_door)
    start_sfx("mannyJmp.WAV")
end
co.le_door.lookAt = function(arg1) -- line 666
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:say_line("/coma042/")
    END_CUT_SCENE()
end
co.le_door.walkOut = co.le_door.use
co.ha_door = Object:create(co, "/cotx016/door", -0.2274, 1.7632, 0.51999998, { range = 0.62428802 })
co.co_ha_box = co.ha_door
co.ha_door.use_pnt_x = 0.118
co.ha_door.use_pnt_y = 1.7690001
co.ha_door.use_pnt_z = 0
co.ha_door.use_rot_x = 0
co.ha_door.use_rot_y = -277.22198
co.ha_door.use_rot_z = 0
co.ha_door.out_pnt_x = -0.26800001
co.ha_door.out_pnt_y = 1.745
co.ha_door.out_pnt_z = 0
co.ha_door.out_rot_x = 0
co.ha_door.out_rot_y = 92.9963
co.ha_door.out_rot_z = 0
co.ha_door.touchable = FALSE
co.ha_door.walkOut = function(arg1) -- line 697
    START_CUT_SCENE()
    manny:say_line("/coma043/")
    ResetMarioControls()
    stop_movement_scripts()
    manny:walkto(0.0414779, 1.73017, 0.01, 0, 276.154, 0)
    END_CUT_SCENE()
end
