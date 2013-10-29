CheckFirstTime("dh.lua")
dofile("mc_suitcase.lua")
dh = Set:create("dh.set", "dillopede hall", { dh_room = 0, dh_safws = 1 })
dh.suitcase_actor = Actor:create(nil, nil, nil, "suitcase")
dh.suitcase_actor.default = function(arg1) -- line 16
    arg1:free()
    arg1:set_costume("mc_suitcase.cos")
    arg1:set_colormap("cafe.cmp")
    arg1:put_in_set(dh)
    arg1:setpos(-0.356249, 3.72979, 0)
    arg1:setrot(0, 55.8682, 0)
    arg1:play_chore(mc_suitcase_suitcase_only)
end
dh.enter = function(arg1) -- line 32
    if dh.suitcase.touchable then
        dh.suitcase_actor:default()
        box_on("checkcase_box")
    else
        box_off("checkcase_box")
    end
end
dh.exit = function(arg1) -- line 41
end
dh.suitcase = Object:create(dh, "/dhtx001/suitcase", -0.69071603, 3.8353701, 0.30000001, { range = 0.60000002 })
dh.suitcase.use_pnt_x = -0.356249
dh.suitcase.use_pnt_y = 3.72979
dh.suitcase.use_pnt_z = 0
dh.suitcase.use_rot_x = 0
dh.suitcase.use_rot_y = 55.868198
dh.suitcase.use_rot_z = 0
dh.suitcase.lookAt = function(arg1) -- line 57
    if not arg1.seen_tix then
        manny:say_line("/dhma002/")
    else
        manny:say_line("/dhma003/")
    end
    box_on("checkcase_box")
end
dh.suitcase.put_away = function(arg1) -- line 66
    system.default_response("no pocket")
    return TRUE
end
dh.suitcase.use = function(arg1) -- line 71
    if arg1.owner == manny then
        arg1:lookAt()
    else
        cur_puzzle_state[22] = TRUE
        START_CUT_SCENE("nohead")
        if manny.is_holding then
            put_away_held_item()
        end
        manny:walkto_object(arg1)
        dh:current_setup(0)
        manny:push_costume("mc_suitcase.cos")
        manny:play_chore(mc_suitcase_open, "mc_suitcase.cos")
        dh.suitcase_actor:set_visibility(FALSE)
        sleep_for(1000)
        music_state:set_sequence(seqFakeTix)
        manny:wait_for_chore(mc_suitcase_open, "mc_suitcase.cos")
        manny:say_line("/dhma005/")
        manny:wait_for_message()
        manny:say_line("/dhma006/")
        manny:wait_for_message()
        manny:say_line("/dhma007/")
        manny:wait_for_message()
        manny:say_line("/dhma008/")
        manny:wait_for_message()
        manny:head_look_at(nil)
        manny:play_chore(mc_suitcase_close, "mc_suitcase.cos")
        arg1.seen_tix = TRUE
        arg1:lookAt()
        manny:wait_for_message()
        manny:wait_for_chore(mc_suitcase_close, "mc_suitcase.cos")
        manny:setrot(0, 48.1586, 0)
        manny:play_chore(mc_suitcase_grab_case, "mc_suitcase.cos")
        manny:wait_for_chore(mc_suitcase_grab_case, "mc_suitcase.cos")
        manny:pop_costume()
        END_CUT_SCENE()
        arg1:get()
        start_script(cut_scene.getcard, cut_scene)
    end
end
dh.suitcase.pickUp = dh.suitcase.use
dh.de_door = Object:create(dh, "/dhtx009/door", 0.019099999, -3.2279999, 0, { range = 0.60000002 })
dh.de_door.use_pnt_x = 0.0103251
dh.de_door.use_pnt_y = -2.5153201
dh.de_door.use_pnt_z = 0
dh.de_door.use_rot_x = 0
dh.de_door.use_rot_y = 175.57401
dh.de_door.use_rot_z = 0
dh.de_door.out_pnt_x = -0.0262205
dh.de_door.out_pnt_y = -2.9875
dh.de_door.out_pnt_z = 0
dh.de_door.out_rot_x = 0
dh.de_door.out_rot_y = 175.57401
dh.de_door.out_rot_z = 0
dh.de_door.touchable = FALSE
dh.de_box = dh.de_door
dh.de_door.walkOut = function(arg1) -- line 137
    de:come_out_door(de.grating)
end
dh.checkcase_box = { name = "check suitcase" }
dh.checkcase_box.walkOut = function(arg1) -- line 145
    if not arg1.triggered then
        arg1.triggered = TRUE
    elseif dh.suitcase.owner ~= manny then
        if not dh.suitcase.seen_tix then
            START_CUT_SCENE()
            manny:say_line("/dhma010/")
            manny:wait_for_message()
            END_CUT_SCENE()
        end
        start_script(dh.suitcase.use, dh.suitcase)
    end
end
