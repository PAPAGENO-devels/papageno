CheckFirstTime("tp.lua")
dofile("tp_interface.lua")
tp = Set:create("tp.set", "ticket printer", { tp_tckcu = 0 })
tp.current_button = nil
tp.week = nil
tp.day = nil
tp.race = nil
tp.RACE = 1
tp.DAY = 2
tp.WEEK = 3
tp.PRINT = 4
system.digitTemplate = { name = "<unnamed>", x = nil, y = nil, elements = nil }
Digit = system.digitTemplate
Digit.create = function(arg1, arg2, arg3, arg4) -- line 45
    local local1 = { }
    local local2 = 1
    local1.parent = Digit
    local1.name = arg2
    local1.x = arg3
    local1.y = arg4
    local1.elements = { }
    repeat
        local1.elements[local2] = DrawLine(tp.basenumber[local2].x1 + local1.x, tp.basenumber[local2].y1 + local1.y, tp.basenumber[local2].x2 + local1.x, tp.basenumber[local2].y2 + local1.y, { color = tp.text_color_dim, layer = 1 })
        local2 = local2 + 1
    until local2 == 14
    return local1
end
Digit.draw_number = function(arg1, arg2) -- line 68
    local local1 = 1
    repeat
        ChangePrimitive(arg1.elements[local1], { color = tp.text_color_dim, layer = 1 })
        local1 = local1 + 1
    until local1 == 14
    local1 = 1
    repeat
        ChangePrimitive(arg1.elements[tp.number[arg2][local1]], { color = tp.text_color_bright, layer = 1 })
        local1 = local1 + 1
    until not tp.number[arg2][local1]
end
Digit.draw_char = function(arg1, arg2) -- line 83
    local local1 = 1
    repeat
        ChangePrimitive(arg1.elements[local1], { color = tp.text_color_dim, layer = 1 })
        local1 = local1 + 1
    until local1 == 14
    local1 = 1
    repeat
        if tp.letter[arg2][local1] then
            ChangePrimitive(arg1.elements[tp.letter[arg2][local1]], { color = tp.text_color_bright, layer = 1 })
        end
        local1 = local1 + 1
    until not tp.letter[arg2][local1]
end
Digit.destroy = function(arg1) -- line 101
    local local1 = 1
    repeat
        KillPrimitive(arg1.elements[local1])
        local1 = local1 + 1
    until local1 == 14
end
system.ledTemplate = { name = "<unnamed>", digits = nil, num_digits = 0 }
Led = system.ledTemplate
Led.create = function(arg1, arg2) -- line 120
    local local1 = { }
    local local2 = 1
    local1.parent = Led
    local1.name = arg2
    local1.digits = { }
    local1.num_digits = 0
    return local1
end
Led.add_digit = function(arg1, arg2, arg3) -- line 133
    local local1 = arg1.num_digits + 1
    arg1.digits[local1] = Digit:create("digit " .. local1, arg2, arg3)
    arg1.num_digits = arg1.num_digits + 1
end
Led.display_number = function(arg1, arg2) -- line 141
    local local1 = arg1.num_digits
    local local2, local3
    if arg2 > 9 then
        local2 = floor(arg2 / 10)
        local3 = mod(arg2, 10)
    else
        local2 = 0
        local3 = arg2
    end
    arg1.digits[local1]:draw_number(local3)
    local1 = local1 - 1
    arg1.digits[local1]:draw_number(local2)
    local1 = local1 - 1
    while arg1.digits[local1] do
        arg1.digits[local1]:draw_number(0)
        local1 = local1 - 1
    end
end
Led.display_str = function(arg1, arg2) -- line 164
    local local1 = 1
    local local2
    arg2 = LocalizeString(arg2)
    arg2 = trim_header(arg2)
    arg2 = americanize_string(arg2)
    repeat
        local2 = strsub(arg2, local1, local1)
        if local2 then
            arg1.digits[local1]:draw_char(local2)
            local1 = local1 + 1
        end
    until local1 > arg1.num_digits or not local2
end
americanize_string = function(arg1) -- line 181
    local local1 = { }
    local local2
    local local3, local4, local5, local6
    local1.A = "\192\193\194\195\196\197\198\224\225\226\227\228\229\230"
    local1.C = "\199\231"
    local1.E = "\200\201\202\203\232\233\234\235"
    local1.I = "\204\205\206\207\236\237\238\239"
    local1.N = "\209\241"
    local1.O = "\210\211\212\213\214\242\243\244\245\246\248\216"
    local1.U = "\217\218\219\220\249\250\251\252"
    local1.Y = "\221\159\253\255"
    local1.OE = "\140\156"
    local1.AE = "\198\230"
    local1.S = "\154\138"
    local1.SS = "\223"
    local2 = arg1
    local3, local4 = next(local1, nil)
    while local3 do
        local6 = strlen(local4)
        local5 = 1
        while local5 <= local6 do
            local2 = gsub(local2, strsub(local4, local5, local5), local3)
            local5 = local5 + 1
        end
        local3, local4 = next(local1, local3)
    end
    local2 = strlower(local2)
    return local2
end
Led.destroy = function(arg1) -- line 216
    local local1 = 1
    repeat
        arg1.digits[local1]:destroy()
        local1 = local1 + 1
    until local1 > arg1.num_digits
end
tp.init_number_tables = function() -- line 238
    tp.basenumber = { }
    tp.basenumber[1] = { }
    tp.basenumber[2] = { }
    tp.basenumber[3] = { }
    tp.basenumber[4] = { }
    tp.basenumber[5] = { }
    tp.basenumber[6] = { }
    tp.basenumber[7] = { }
    tp.basenumber[8] = { }
    tp.basenumber[9] = { }
    tp.basenumber[10] = { }
    tp.basenumber[11] = { }
    tp.basenumber[12] = { }
    tp.basenumber[13] = { }
    tp.basenumber[1].x1 = 1
    tp.basenumber[1].y1 = 0
    tp.basenumber[1].x2 = 12
    tp.basenumber[1].y2 = 0
    tp.basenumber[2].x1 = 0
    tp.basenumber[2].y1 = 1
    tp.basenumber[2].x2 = 0
    tp.basenumber[2].y2 = 13
    tp.basenumber[3].x1 = 13
    tp.basenumber[3].y1 = 1
    tp.basenumber[3].x2 = 13
    tp.basenumber[3].y2 = 13
    tp.basenumber[4].x1 = 1
    tp.basenumber[4].y1 = 14
    tp.basenumber[4].x2 = 12
    tp.basenumber[4].y2 = 14
    tp.basenumber[5].x1 = 0
    tp.basenumber[5].y1 = 15
    tp.basenumber[5].x2 = 0
    tp.basenumber[5].y2 = 27
    tp.basenumber[6].x1 = 13
    tp.basenumber[6].y1 = 15
    tp.basenumber[6].x2 = 13
    tp.basenumber[6].y2 = 27
    tp.basenumber[7].x1 = 1
    tp.basenumber[7].y1 = 28
    tp.basenumber[7].x2 = 12
    tp.basenumber[7].y2 = 28
    tp.basenumber[8].x1 = 6
    tp.basenumber[8].y1 = 1
    tp.basenumber[8].x2 = 6
    tp.basenumber[8].y2 = 12
    tp.basenumber[9].x1 = 6
    tp.basenumber[9].y1 = 15
    tp.basenumber[9].x2 = 6
    tp.basenumber[9].y2 = 27
    tp.basenumber[10].x1 = 1
    tp.basenumber[10].y1 = 26
    tp.basenumber[10].x2 = 5
    tp.basenumber[10].y2 = 15
    tp.basenumber[11].x1 = 7
    tp.basenumber[11].y1 = 12
    tp.basenumber[11].x2 = 12
    tp.basenumber[11].y2 = 1
    tp.basenumber[12].x1 = 1
    tp.basenumber[12].y1 = 1
    tp.basenumber[12].x2 = 5
    tp.basenumber[12].y2 = 12
    tp.basenumber[13].x1 = 7
    tp.basenumber[13].y1 = 15
    tp.basenumber[13].x2 = 11
    tp.basenumber[13].y2 = 26
    tp.number = { }
    tp.number[0] = { }
    tp.number[0][1] = 1
    tp.number[0][2] = 2
    tp.number[0][3] = 3
    tp.number[0][4] = 5
    tp.number[0][5] = 6
    tp.number[0][6] = 7
    tp.number[1] = { }
    tp.number[1][1] = 8
    tp.number[1][2] = 9
    tp.number[2] = { }
    tp.number[2][1] = 1
    tp.number[2][2] = 3
    tp.number[2][3] = 4
    tp.number[2][4] = 5
    tp.number[2][5] = 7
    tp.number[3] = { }
    tp.number[3][1] = 1
    tp.number[3][2] = 3
    tp.number[3][3] = 4
    tp.number[3][4] = 6
    tp.number[3][5] = 7
    tp.number[4] = { }
    tp.number[4][1] = 2
    tp.number[4][2] = 3
    tp.number[4][3] = 4
    tp.number[4][4] = 6
    tp.number[5] = { }
    tp.number[5][1] = 1
    tp.number[5][2] = 2
    tp.number[5][3] = 4
    tp.number[5][4] = 6
    tp.number[5][5] = 7
    tp.number[6] = { }
    tp.number[6][1] = 2
    tp.number[6][2] = 4
    tp.number[6][3] = 5
    tp.number[6][4] = 6
    tp.number[6][5] = 7
    tp.number[7] = { }
    tp.number[7][1] = 1
    tp.number[7][2] = 3
    tp.number[7][3] = 6
    tp.number[8] = { }
    tp.number[8][1] = 1
    tp.number[8][2] = 2
    tp.number[8][3] = 3
    tp.number[8][4] = 4
    tp.number[8][5] = 5
    tp.number[8][6] = 6
    tp.number[8][7] = 7
    tp.number[9] = { }
    tp.number[9][1] = 1
    tp.number[9][2] = 2
    tp.number[9][3] = 3
    tp.number[9][4] = 4
    tp.number[9][5] = 6
    tp.letter = { }
    tp.letter["a"] = { }
    tp.letter.a[1] = 1
    tp.letter.a[2] = 2
    tp.letter.a[3] = 3
    tp.letter.a[4] = 4
    tp.letter.a[5] = 5
    tp.letter.a[6] = 6
    tp.letter.b = { }
    tp.letter.b[1] = 1
    tp.letter.b[2] = 2
    tp.letter.b[3] = 3
    tp.letter.b[4] = 4
    tp.letter.b[5] = 5
    tp.letter.b[6] = 6
    tp.letter.b[7] = 7
    tp.letter.c = { }
    tp.letter.c[1] = 1
    tp.letter.c[2] = 2
    tp.letter.c[3] = 5
    tp.letter.c[4] = 7
    tp.letter["d"] = { }
    tp.letter.d[1] = 2
    tp.letter.d[2] = 5
    tp.letter.d[3] = 10
    tp.letter.d[4] = 12
    tp.letter["e"] = { }
    tp.letter.e[1] = 1
    tp.letter.e[2] = 2
    tp.letter.e[3] = 4
    tp.letter.e[4] = 5
    tp.letter.e[5] = 7
    tp.letter["f"] = { }
    tp.letter.f[1] = 1
    tp.letter.f[2] = 2
    tp.letter.f[3] = 4
    tp.letter.f[4] = 5
    tp.letter.g = { }
    tp.letter.g[1] = 1
    tp.letter.g[2] = 2
    tp.letter.g[3] = 5
    tp.letter.g[4] = 7
    tp.letter.g[5] = 13
    tp.letter.h = { }
    tp.letter.h[1] = 2
    tp.letter.h[2] = 3
    tp.letter.h[3] = 4
    tp.letter.h[4] = 5
    tp.letter.h[5] = 6
    tp.letter["i"] = { }
    tp.letter.i[1] = 8
    tp.letter.i[2] = 9
    tp.letter.j = { }
    tp.letter.j[1] = 1
    tp.letter.j[2] = 8
    tp.letter.j[3] = 10
    tp.letter.j[4] = 5
    tp.letter.k = { }
    tp.letter.k[1] = 8
    tp.letter.k[2] = 9
    tp.letter.k[3] = 11
    tp.letter.k[4] = 13
    tp.letter["l"] = { }
    tp.letter.l[1] = 2
    tp.letter.l[2] = 5
    tp.letter.l[3] = 7
    tp.letter.m = { }
    tp.letter.m[1] = 2
    tp.letter.m[2] = 3
    tp.letter.m[3] = 5
    tp.letter.m[4] = 6
    tp.letter.m[5] = 12
    tp.letter.m[6] = 11
    tp.letter["n"] = { }
    tp.letter.n[1] = 2
    tp.letter.n[2] = 3
    tp.letter.n[3] = 5
    tp.letter.n[4] = 6
    tp.letter.n[5] = 12
    tp.letter.n[6] = 13
    tp.letter["o"] = { }
    tp.letter.o[1] = 1
    tp.letter.o[2] = 2
    tp.letter.o[3] = 3
    tp.letter.o[4] = 5
    tp.letter.o[5] = 6
    tp.letter.o[6] = 7
    tp.letter.p = { }
    tp.letter.p[1] = 1
    tp.letter.p[2] = 2
    tp.letter.p[3] = 3
    tp.letter.p[4] = 4
    tp.letter.p[5] = 5
    tp.letter.q = { }
    tp.letter.q[1] = 1
    tp.letter.q[2] = 2
    tp.letter.q[3] = 3
    tp.letter.q[4] = 5
    tp.letter.q[5] = 6
    tp.letter.q[6] = 7
    tp.letter.q[7] = 13
    tp.letter["r"] = { }
    tp.letter.r[1] = 1
    tp.letter.r[2] = 2
    tp.letter.r[3] = 3
    tp.letter.r[4] = 4
    tp.letter.r[5] = 5
    tp.letter.r[6] = 13
    tp.letter.s = { }
    tp.letter.s[1] = 1
    tp.letter.s[2] = 12
    tp.letter.s[3] = 13
    tp.letter.s[4] = 7
    tp.letter["t"] = { }
    tp.letter.t[1] = 1
    tp.letter.t[2] = 8
    tp.letter.t[3] = 9
    tp.letter["u"] = { }
    tp.letter.u[1] = 2
    tp.letter.u[2] = 3
    tp.letter.u[3] = 5
    tp.letter.u[4] = 6
    tp.letter.u[5] = 7
    tp.letter.v = { }
    tp.letter.v[1] = 2
    tp.letter.v[2] = 5
    tp.letter.v[3] = 10
    tp.letter.v[4] = 11
    tp.letter["w"] = { }
    tp.letter.w[1] = 2
    tp.letter.w[2] = 3
    tp.letter.w[3] = 5
    tp.letter.w[4] = 6
    tp.letter.w[5] = 10
    tp.letter.w[6] = 13
    tp.letter.x = { }
    tp.letter.x[1] = 10
    tp.letter.x[2] = 11
    tp.letter.x[3] = 12
    tp.letter.x[4] = 13
    tp.letter.y = { }
    tp.letter.y[1] = 9
    tp.letter.y[2] = 11
    tp.letter.y[3] = 12
    tp.letter.z = { }
    tp.letter.z[1] = 1
    tp.letter.z[2] = 7
    tp.letter.z[3] = 10
    tp.letter.z[4] = 11
    tp.window_offset = { }
    tp.window_offset[1] = { }
    tp.window_offset[1].x = 198
    tp.window_offset[1].y = 211
    tp.window_offset[2] = { }
    tp.window_offset[2].x = 214
    tp.window_offset[2].y = 211
    tp.window_offset[3] = { }
    tp.window_offset[3].x = 320
    tp.window_offset[3].y = 256
    tp.window_offset[4] = { }
    tp.window_offset[4].x = 336
    tp.window_offset[4].y = 256
    tp.window_offset[5] = { }
    tp.window_offset[5].x = 352
    tp.window_offset[5].y = 256
    tp.window_offset[6] = { }
    tp.window_offset[6].x = 453
    tp.window_offset[6].y = 211
    tp.window_offset[7] = { }
    tp.window_offset[7].x = 469
    tp.window_offset[7].y = 211
    tp.daystr = { }
    tp.daystr[1] = "/tptx189/"
    tp.daystr[2] = "/tptx190/"
    tp.daystr[3] = "/tptx191/"
    tp.daystr[4] = "/tptx192/"
    tp.daystr[5] = "/tptx193/"
    tp.daystr[6] = "/tptx194/"
    tp.daystr[7] = "/tptx195/"
end
tp.enter = function(arg1) -- line 613
    NewObjectState(tp_tckcu, OBJSTATE_OVERLAY, "print_ticket.bm")
    tp.stub:set_object_state("tp_stub.cos")
    tp.init_number_tables()
    if not mannys_hands then
        mannys_hands = Actor:create(nil, nil, nil, "/sytx188/")
    end
    mannys_hands:set_costume("tp_interface.cos")
    mannys_hands:put_in_set(tp)
    mannys_hands:moveto(-0.029, 0.002, 0)
    mannys_hands:setrot(0, 180, 0)
    tp.current_button = tp.RACE
    tp.text_color_bright = MakeColor(255, 150, 0)
    tp.text_color_dim = MakeColor(80, 80, 0)
    week_field = Led:create("week")
    week_field:add_digit(tp.window_offset[1].x, tp.window_offset[1].y)
    week_field:add_digit(tp.window_offset[2].x, tp.window_offset[2].y)
    week_field:display_number(1)
    tp.week = 1
    cn.ticket.week = 1
    day_field = Led:create("day")
    day_field:add_digit(tp.window_offset[3].x, tp.window_offset[3].y)
    day_field:add_digit(tp.window_offset[4].x, tp.window_offset[4].y)
    day_field:add_digit(tp.window_offset[5].x, tp.window_offset[5].y)
    day_field:display_str(tp.daystr[1])
    tp.day = 1
    cn.ticket.day = 1
    race_field = Led:create("race")
    race_field:add_digit(tp.window_offset[6].x, tp.window_offset[6].y)
    race_field:add_digit(tp.window_offset[7].x, tp.window_offset[7].y)
    race_field:display_number(1)
    tp.race = 1
    cn.ticket.race = 1
end
tp.exit = function(arg1) -- line 656
    mannys_hands:free()
    week_field:destroy()
    race_field:destroy()
    day_field:destroy()
end
tp.switch_to_set = function(arg1) -- line 664
    if IsMoviePlaying() then
        StopMovie()
    else
        system.loopingMovie = nil
    end
    system.lastSet = system.currentSet
    LockSet(system.currentSet.setFile)
    inventory_save_set = system.currentSet
    arg1:CommonEnter()
    MakeCurrentSet(arg1.setFile)
    arg1:enter()
    system.currentSet = tp
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
end
tp.return_to_set = function(arg1, arg2) -- line 685
    START_CUT_SCENE()
    if arg2 then
        tp.stub:play_chore(0)
        tp.stub:wait_for_chore()
    end
    END_CUT_SCENE()
    tp:exit()
    system.currentSet = inventory_save_set
    UnLockSet(inventory_save_set.setFile)
    MakeCurrentSet(inventory_save_set.setFile)
    system.buttonHandler = inventory_save_handler
    if system.loopingMovie and type(system.loopingMovie) == "table" then
        play_movie_looping(system.loopingMovie.name, system.loopingMovie.x, system.loopingMovie.y)
    end
    if arg2 then
        START_CUT_SCENE()
        put_away_held_item()
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = cn.ticket
        start_script(close_inventory)
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
            shrink_box_toggle()
        end
        END_CUT_SCENE()
    end
end
tpButtonHandler = function(arg1, arg2, arg3) -- line 724
    shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if control_map.OVERRIDE[arg1] and arg2 then
        single_start_script(tp.close_printer)
    elseif control_map.TURN_RIGHT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.move_right)
    elseif control_map.TURN_LEFT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.move_left)
    elseif control_map.LOOK_AT[arg1] and arg2 and cutSceneLevel <= 0 or (control_map.USE[arg1] and arg2 and cutSceneLevel <= 0) then
        single_start_script(cn.printer.lookAt, cn.printer)
    elseif control_map.MOVE_BACKWARD[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.push_down)
    elseif control_map.MOVE_FORWARD[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.push_up)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
tp.move_left = function() -- line 747
    local local1
    while get_generic_control_state("TURN_LEFT") do
        if tp.current_button == tp.RACE then
            tp.current_button = tp.DAY
            mannys_hands:moveto(-0.015, 0.0020000001, 0)
        elseif tp.current_button == tp.DAY then
            tp.current_button = tp.WEEK
            mannys_hands:moveto(-0.001, 0.0020000001, 0)
        elseif tp.current_button == tp.WEEK then
            tp.current_button = tp.PRINT
            mannys_hands:moveto(-0.015, -0.02, 0)
        elseif tp.current_button == tp.PRINT then
            tp.current_button = tp.RACE
            mannys_hands:moveto(-0.028999999, 0.0020000001, 0)
        end
        mannys_hands:wait_for_actor()
        local1 = 0
        while local1 < 500 and get_generic_control_state("TURN_LEFT") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
tp.move_right = function() -- line 777
    local local1
    while get_generic_control_state("TURN_RIGHT") do
        if tp.current_button == tp.WEEK then
            tp.current_button = tp.DAY
            mannys_hands:moveto(-0.015, 0.0020000001, 0)
        elseif tp.current_button == tp.DAY then
            tp.current_button = tp.RACE
            mannys_hands:moveto(-0.028999999, 0.0020000001, 0)
        elseif tp.current_button == tp.RACE then
            tp.current_button = tp.PRINT
            mannys_hands:moveto(-0.015, -0.02, 0)
        elseif tp.current_button == tp.PRINT then
            tp.current_button = tp.WEEK
            mannys_hands:moveto(-0.001, 0.0020000001, 0)
        end
        mannys_hands:wait_for_actor()
        local1 = 0
        while local1 < 500 and get_generic_control_state("TURN_RIGHT") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
tp.close_printer = function() -- line 807
    tp.return_to_set()
end
tp.push_up = function() -- line 811
    START_CUT_SCENE()
    mannys_hands:play_chore(tp_interface_press_up)
    sleep_for(100)
    if tp.current_button == tp.RACE then
        tp.race = tp.race + 1
        if tp.race > 15 then
            tp.race = 1
        end
        cn.ticket.race = tp.race
        start_sfx("prntBtn1.wav", 100, 80)
        race_field:display_number(tp.race)
    elseif tp.current_button == tp.DAY then
        tp.day = tp.day + 1
        if tp.day > 7 then
            tp.day = 1
        end
        cn.ticket.day = tp.day
        start_sfx("prntBtn2.wav", 100, 80)
        day_field:display_str(tp.daystr[tp.day])
    elseif tp.current_button == tp.WEEK then
        tp.week = tp.week + 1
        if tp.week > 32 then
            tp.week = 1
        end
        cn.ticket.week = tp.week
        start_sfx("prntBtn3.wav", 100, 80)
        week_field:display_number(tp.week)
    elseif tp.current_button == tp.PRINT then
        start_sfx("prntPrnt.wav")
        cn.ticket:get()
        tp:return_to_set(TRUE)
    end
    mannys_hands:wait_for_chore()
    END_CUT_SCENE()
end
tp.push_down = function() -- line 853
    START_CUT_SCENE()
    if tp.current_button == tp.PRINT then
        mannys_hands:play_chore(tp_interface_press_up)
    else
        mannys_hands:play_chore(tp_interface_press_down)
    end
    sleep_for(100)
    if tp.current_button == tp.RACE then
        tp.race = tp.race - 1
        if tp.race < 1 then
            tp.race = 15
        end
        cn.ticket.race = tp.race
        start_sfx("prntBtn1.wav", 100, 80)
        race_field:display_number(tp.race)
    elseif tp.current_button == tp.DAY then
        tp.day = tp.day - 1
        if tp.day < 1 then
            tp.day = 7
        end
        cn.ticket.day = tp.day
        start_sfx("prntBtn2.wav", 100, 80)
        day_field:display_str(tp.daystr[tp.day])
    elseif tp.current_button == tp.WEEK then
        tp.week = tp.week - 1
        if tp.week < 1 then
            tp.week = 32
        end
        cn.ticket.week = tp.week
        start_sfx("prntBtn3.wav", 100, 80)
        week_field:display_number(tp.week)
    elseif tp.current_button == tp.PRINT then
        start_sfx("prntPrnt.wav")
        cn.ticket:get()
        tp:return_to_set(TRUE)
    end
    mannys_hands:wait_for_chore()
    END_CUT_SCENE()
end
tp.stub = Object:create(tp, "", 0, 0, 0, { range = 0 })
