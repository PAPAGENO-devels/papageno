CheckFirstTime("bw.lua")
dofile("bw_elevator.lua")
bw = Set:create("bw.set", "blue casket wide", { bw_bldws = 0, bw_ovrhd = 1 })
bw.enter = function(arg1) -- line 20
    if not in_year_four then
        bw:add_object_state(bw_bldws, "bw_elev_bottom.bm", "bw_elev_bottom.zbm", OBJSTATE_STATE)
        bw:add_object_state(bw_bldws, "bw_elev_top.bm", nil, OBJSTATE_UNDERLAY)
    else
        bw:add_object_state(bw_bldws, "bw_elev_dark.bm", nil, OBJSTATE_UNDERLAY)
    end
    bw.ev_door:set_object_state("bw_elevator.cos")
    if in_year_four then
        bw.ev_door:complete_chore(bw_elevator_dark)
    elseif bw.ev_door.here then
        if bw.ev_door.opened then
            bw.ev_door:complete_chore(bw_elevator_set_open)
        else
            bw.ev_door:complete_chore(bw_elevator_set_closed)
        end
    end
end
bw.ev_door = Object:create(bw, "/bwtx001/door", -2.5936401, -1.98356, 0.81400001, { range = 0.89999998 })
bw.ev_door.use_pnt_x = -2.4782801
bw.ev_door.use_pnt_y = -2.4909699
bw.ev_door.use_pnt_z = 0.23
bw.ev_door.use_rot_x = 0
bw.ev_door.use_rot_y = 354.67801
bw.ev_door.use_rot_z = 0
bw.ev_door.out_pnt_x = -2.46
bw.ev_door.out_pnt_y = -1.66
bw.ev_door.out_pnt_z = 0.23
bw.ev_door.out_rot_x = 0
bw.ev_door.out_rot_y = 354.67801
bw.ev_door.out_rot_z = 0
bw.ev_box = bw.ev_door
bw.ev_door.passage = { "bw_ev_psg" }
bw.ev_door.here = TRUE
bw.ev_door.lookAt = function(arg1) -- line 73
    if in_year_four then
        START_CUT_SCENE()
        manny:say_line("/bwma005/")
        if not arg1.seen then
            arg1.seen = TRUE
            manny:wait_for_message()
            manny:say_line("/bwma006/")
            manny:wait_for_message()
            manny:say_line("/bwma007/")
        end
        END_CUT_SCENE()
    else
        manny:say_line("/bwma008/")
    end
end
bw.ev_door.walkOut = function(arg1) -- line 90
    if not in_year_four then
        START_CUT_SCENE()
        stop_script(bw.ev_trigger.trigger)
        set_override(bw.ev_door.skip_walkout)
        manny:clear_hands()
        if not arg1:is_open() then
            arg1:open()
        end
        manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
        manny:wait_for_actor()
        start_script(arg1.close, arg1)
        manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z, TRUE)
        wait_for_script(arg1.close)
        start_sfx("bwElRise.wav")
        arg1:play_chore(bw_elevator_rise)
        arg1:wait_for_chore()
        RunFullscreenMovie("eleup.snm")
        END_CUT_SCENE()
        ev:come_out_door(ev.be_door)
    end
end
bw.ev_door.skip_walkout = function(arg1) -- line 121
    kill_override()
    ev:come_out_door(ev.be_door)
end
bw.ev_door.comeOut = function(arg1) -- line 126
    START_CUT_SCENE()
    arg1.here = FALSE
    bw:switch_to_set()
    set_override(bw.ev_door.skip_comeOut, bw.ev_door)
    manny:set_visibility(FALSE)
    RunFullscreenMovie("eledown.snm")
    start_sfx("bwElLowr.wav")
    arg1:play_chore(bw_elevator_lower)
    arg1:wait_for_chore()
    arg1.here = TRUE
    manny:put_in_set(bw)
    manny:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    manny:set_visibility(TRUE)
    arg1:open()
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
    manny:wait_for_actor()
    arg1:close()
    END_CUT_SCENE()
end
bw.ev_door.skip_comeOut = function(arg1) -- line 150
    kill_override()
    bw.ev_door.here = TRUE
    manny:put_in_set(bw)
    manny:set_visibility(TRUE)
    manny:setpos(bw.ev_door.use_pnt_x, bw.ev_door.use_pnt_y, bw.ev_door.use_pnt_z)
    manny:setrot(bw.ev_door.use_rot_x, bw.ev_door.use_rot_y, bw.ev_door.use_rot_z)
    bw.ev_door:stop_chore()
    bw.ev_door:play_chore(bw_elevator_set_closed)
    Object.close(bw.ev_door)
end
bw.ev_door.use = function(arg1) -- line 162
    if in_year_four then
        arg1:locked_out()
    else
        START_CUT_SCENE()
        if not arg1:is_open() then
            arg1:open()
        end
        arg1:walkOut()
        END_CUT_SCENE()
    end
end
bw.ev_door.open = function(arg1) -- line 175
    if in_year_four then
        return FALSE
    else
        if not arg1.opened then
            start_sfx("bwElOpen.wav")
            arg1:play_chore(bw_elevator_open)
            arg1:wait_for_chore()
            Object.open(arg1)
        end
        return TRUE
    end
end
bw.ev_door.close = function(arg1) -- line 189
    if arg1.opened then
        start_sfx("bwElClos.wav")
        arg1:play_chore(bw_elevator_close)
        arg1:wait_for_chore()
        Object.close(arg1)
    end
end
bw.ev_trigger = { name = "ev door trigger" }
bw.ev_trigger.walkOut = function(arg1) -- line 203
    if not in_year_four then
        single_start_script(arg1.trigger, arg1)
    end
end
bw.ev_trigger.trigger = function(arg1) -- line 209
    if not bw.ev_door:is_open() then
        bw.ev_door:open()
    end
    while manny:find_sector_name("ev_trigger") do
        break_here()
    end
    if not manny:find_sector_name("bw_ev_psg") then
        bw.ev_door:close()
    end
end
bw.be_door = Object:create(bw, "/bwtx002/door", 0.13732, 0.100709, 0.5, { range = 0.60000002 })
bw.be_door.use_pnt_x = -0.0859721
bw.be_door.use_pnt_y = -1.25122
bw.be_door.use_pnt_z = 0.23
bw.be_door.use_rot_x = 0
bw.be_door.use_rot_y = -725.01599
bw.be_door.use_rot_z = 0
bw.be_door.out_pnt_x = -0.052507199
bw.be_door.out_pnt_y = -0.868276
bw.be_door.out_pnt_z = 0.23
bw.be_door.out_rot_x = 0
bw.be_door.out_rot_y = -725.01599
bw.be_door.out_rot_z = 0
bw.be_door:make_untouchable()
bw.be_box = bw.be_door
bw.be_door.walkOut = function(arg1) -- line 242
    be:come_out_door(be.bw_door)
end
bw.dd_door = Object:create(bw, "/bwtx003/bridge", -3.7627599, -2.7811601, 0.73000002, { range = 0.60000002 })
bw.dd_door.use_pnt_x = -3.17243
bw.dd_door.use_pnt_y = -2.81321
bw.dd_door.use_pnt_z = 0.23
bw.dd_door.use_rot_x = 0
bw.dd_door.use_rot_y = -637.245
bw.dd_door.use_rot_z = 0
bw.dd_door.out_pnt_x = -3.46731
bw.dd_door.out_pnt_y = -2.80336
bw.dd_door.out_pnt_z = 0.23
bw.dd_door.out_rot_x = 0
bw.dd_door.out_rot_y = -619.20203
bw.dd_door.out_rot_z = 0
bw.dd_box = bw.dd_door
bw.dd_box:make_untouchable()
bw.dd_door.walkOut = function(arg1) -- line 267
    dd:come_out_door(dd.bw_door)
end
bw.hb_door = Object:create(bw, "/bwtx004/bridge", 2.7160699, -5.2459698, 1.13, { range = 0.60000002 })
bw.hb_door.use_pnt_x = 2.7160699
bw.hb_door.use_pnt_y = -4.1759701
bw.hb_door.use_pnt_z = 0.69999999
bw.hb_door.use_rot_x = 0
bw.hb_door.use_rot_y = -528.96198
bw.hb_door.use_rot_z = 0
bw.hb_door.out_pnt_x = 2.78141
bw.hb_door.out_pnt_y = -4.2933302
bw.hb_door.out_pnt_z = 0.69999999
bw.hb_door.out_rot_x = 0
bw.hb_door.out_rot_y = 184.008
bw.hb_door.out_rot_z = 0
bw.hb_door.lookAt = function(arg1) -- line 288
end
bw.hb_door.walkOut = function(arg1) -- line 291
    hb:come_out_door(hb.bw_door)
end
