CheckFirstTime("tg.lua")
tg = Set:create("tg.set", "temple gate", { tg_trkla = 0, tg_gtkws = 1, tg_cofws = 2, tg_oh = 3 })
tg.cheat_boxes = { cheat_box1 }
dofile("gatekeeper.lua")
gate_keeper.fling_right_arm = function(arg1) -- line 15
    arg1:play_chore(gatekeeper_gesture, "gatekeeper.cos")
end
gate_keeper.nod_cycle = function(arg1) -- line 19
    arg1:play_chore_looping(gatekeeper_nod_cycle, "gatekeeper.cos")
end
gate_keeper.stop_nod = function(arg1) -- line 23
    arg1:stop_looping_chore(gatekeeper_nod_cycle, "gatekeeper.cos")
end
gate_keeper.brief_nod = function(arg1) -- line 27
    gate_keeper:nod_cycle()
    sleep_for(1000)
    gate_keeper:stop_nod()
end
gate_keeper.arms_out = function(arg1) -- line 33
    arg1:play_chore(gatekeeper_points, "gatekeeper.cos")
end
gate_keeper.raise_hands = function(arg1) -- line 37
    arg1:play_chore(gatekeeper_raise_hands, "gatekeeper.cos")
end
gate_keeper.say_what_in = function(arg1) -- line 41
    arg1:play_chore(gatekeeper_say_what_in, "gatekeeper.cos")
end
gate_keeper.say_what_out = function(arg1) -- line 45
    arg1:play_chore(gatekeeper_say_what_out, "gatekeeper.cos")
end
gate_keeper.shake_cycle = function(arg1) -- line 49
    arg1:play_chore_looping(gatekeeper_shake_cycle, "gatekeeper.cos")
end
gate_keeper.stop_shake = function(arg1) -- line 53
    arg1:stop_looping_chore(gatekeeper_shake_cycle, "gatekeeper.cos")
end
gate_keeper.uncross_arms = function(arg1) -- line 57
    arg1:play_chore(gatekeeper_uncross_arms, "gatekeeper.cos")
end
gate_keeper.cross_arms = function(arg1) -- line 61
    arg1:play_chore(gatekeeper_cross_arms, "gatekeeper.cos")
end
gate_keeper.arms_crossed = function(arg1) -- line 65
    arg1:play_chore(gatekeeper_cross_arms_hold, "gatekeeper.cos")
end
gate_keeper.to_rest = function(arg1) -- line 69
    arg1:play_chore(gatekeeper_back_to_rest, "gatekeeper.cos")
end
tg.give_note = function() -- line 73
    START_CUT_SCENE()
    gate_keeper:say_line("/tggk001/")
    gate_keeper:wait_for_message()
    manny:head_look_at(tg.keeper_obj)
    start_script(manny.walkto_object, manny, tg.keeper_obj)
    gate_keeper:say_line("/tggk002/")
    gate_keeper:fling_right_arm()
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk003/")
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk004/")
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk005/")
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk006/")
    gate_keeper:cross_arms()
    gate_keeper:wait_for_message()
    manny:twist_head_gesture(TRUE)
    manny:say_line("/tgma007/")
    sleep_for(300)
    manny:hand_gesture(TRUE)
    manny:wait_for_message()
    gate_keeper:say_line("/tggk008/")
    gate_keeper:uncross_arms()
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk009/")
    gate_keeper:wait_for_message()
    gate_keeper:play_chore(gatekeeper_give_note, "gatekeeper.cos")
    sleep_for(300)
    start_sfx("tgPullNt.WAV")
    sleep_for(700)
    gate_keeper:say_line("/tggk010/")
    sleep_for(750)
    start_sfx("tgFallNt.WAV")
    if manny.is_holding then
        manny.is_holding:put_away()
    else
        sleep_for(1200)
    end
    manny:play_chore(msb_reach_high, "msb.cos")
    sleep_for(1000)
    start_sfx("tgGrabNt.WAV")
    manny:generic_pickup(tg.note)
    manny:fade_out_chore(msb_reach_high, "msb.cos", 500)
    manny:fade_in_chore(msb_hold, "msb.cos", 500)
    gate_keeper:play_chore(gatekeeper_hide_note, "gatekeeper.cos")
    gate_keeper:wait_for_chore(gatekeeper_give_note, "gatekeeper.cos")
    gate_keeper:wait_for_message()
    END_CUT_SCENE()
end
tg.talk_2 = function() -- line 127
    tg.talked_2 = TRUE
    START_CUT_SCENE()
    wait_for_message()
    manny:say_line("/tgma011/")
    manny:wait_for_message()
    gate_keeper:say_line("/tggk012/")
    gate_keeper:nod_cycle()
    gate_keeper:wait_for_message()
    gate_keeper:stop_nod()
    gate_keeper:say_line("/tggk013/")
    gate_keeper:arms_out()
    END_CUT_SCENE()
end
tg.setup_gatekeeper = function(arg1) -- line 142
    gate_keeper:free()
    gate_keeper:set_costume("gatekeeper.cos")
    gate_keeper:set_mumble_chore(gatekeeper_mumble)
    gate_keeper:set_talk_chore(1, gatekeeper_stop_talk)
    gate_keeper:set_talk_chore(2, gatekeeper_a)
    gate_keeper:set_talk_chore(3, gatekeeper_c)
    gate_keeper:set_talk_chore(4, gatekeeper_e)
    gate_keeper:set_talk_chore(5, gatekeeper_f)
    gate_keeper:set_talk_chore(6, gatekeeper_l)
    gate_keeper:set_talk_chore(7, gatekeeper_m)
    gate_keeper:set_talk_chore(8, gatekeeper_o)
    gate_keeper:set_talk_chore(9, gatekeeper_t)
    gate_keeper:set_talk_chore(10, gatekeeper_u)
    gate_keeper:setpos(-1.55044, 33.5166, 18.097)
    gate_keeper:setrot(0, 170, 0)
    gate_keeper:put_in_set(tg)
    gate_keeper:play_chore(gatekeeper_cross_arms_hold, "gatekeeper.cos")
end
tg.teleport = function() -- line 162
    while 1 do
        if manny:find_sector_name("tele1") then
            system.lock_display()
            manny:setpos(-1.79763, 31.85, 17.2)
            break_here()
            system.unlock_display()
        elseif manny:find_sector_name("tele2") then
            system.lock_display()
            manny:setpos(-1.86763, 32.3411, 17.13)
            break_here()
            system.unlock_display()
        end
        break_here()
    end
end
tg.enter = function(arg1) -- line 185
    tg:current_setup(tg_gtkws)
    tg:setup_gatekeeper()
    start_script(tg.teleport)
end
tg.exit = function(arg1) -- line 191
    gate_keeper:free()
    stop_script(tg.teleport)
end
tg.note = Object:create(tg, "/tgtx014/note", 0, 0, 0, { range = 0 })
tg.note.wav = "getWrkOr.wav"
tg.note.lookAt = function(arg1) -- line 204
    START_CUT_SCENE()
    set_override(tg.note.look_at_override)
    music_state:set_state(stateHN)
    manny:say_line("/tgma015/")
    manny:wait_for_message()
    manny:say_line("/tgma016/")
    manny:wait_for_message()
    manny:say_line("/tgma017/")
    manny:wait_for_message()
    manny:say_line("/tgma018/")
    if not arg1.seen then
        arg1.seen = TRUE
        manny:wait_for_message()
        manny:say_line("/tgma019/")
        if system.currentSet == tg then
            gate_keeper:brief_nod()
        end
    end
    END_CUT_SCENE()
    music_state:update()
end
tg.note.look_at_override = function(arg1) -- line 227
    music_state:update()
end
tg.note.use = tg.note.lookAt
tg.note.default_response = function(arg1) -- line 233
    manny:say_line("/tgma020/")
end
tg.note.scare_response = function(arg1) -- line 237
    manny:say_line("/tgma021/")
end
tg.keeper_obj = Object:create(tg, "/tgtx022/Gate Keeper", -1.56235, 33.534901, 18.08, { range = 1.22 })
tg.keeper_obj.use_pnt_x = -1.81235
tg.keeper_obj.use_pnt_y = 32.864899
tg.keeper_obj.use_pnt_z = 17.129999
tg.keeper_obj.use_rot_x = 0
tg.keeper_obj.use_rot_y = 343.69
tg.keeper_obj.use_rot_z = 0
tg.keeper_obj.lookAt = function(arg1) -- line 250
    manny:say_line("/tgma023/")
    manny:wait_for_message()
    manny:say_line("/tgma024/")
    gate_keeper:brief_nod()
end
tg.keeper_obj.pickUp = function(arg1) -- line 257
    manny:say_line("/tgma025/")
end
tg.keeper_obj.use = function(arg1) -- line 261
    Dialog:run("gk1", "dlg_keeper.lua")
end
tg.waiting_door = Object:create(tg, "/tgtx026/doorway", -2.56987, 33.964298, 17.549999, { range = 0.60000002 })
tg.waiting_door.use_pnt_x = -2.56987
tg.waiting_door.use_pnt_y = 33.754299
tg.waiting_door.use_pnt_z = 17.129999
tg.waiting_door.use_rot_x = 0
tg.waiting_door.use_rot_y = -350.78
tg.waiting_door.use_rot_z = 0
tg.waiting_door.lookAt = function(arg1) -- line 273
    START_CUT_SCENE()
    manny:say_line("/tgma027/")
    manny:wait_for_message()
    gate_keeper:say_line("/tggk028/")
    gate_keeper:fling_right_arm()
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk029/")
    END_CUT_SCENE()
    if not tg.talked_2 then
        start_script(tg.talk_2)
    end
end
tg.waiting_door.use = function(arg1) -- line 287
    START_CUT_SCENE()
    manny:say_line("/tgma030/")
    manny:wait_for_message()
    gate_keeper:say_line("/tggk031/")
    gate_keeper:cross_arms()
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk032/")
    gate_keeper:cross_arms()
    gate_keeper:wait_for_message()
    gate_keeper:uncross_arms()
    END_CUT_SCENE()
    if not tg.talked_2 then
        start_script(tg.talk_2)
    end
end
tg.waiting_door.walkOut = tg.waiting_door.use
tg.sign = Object:create(tg, "/tgtx033/sign", -1.31014, 30.41, 17.82, { range = 0.89999998 })
tg.sign.use_pnt_x = -1.5417
tg.sign.use_pnt_y = 30.8209
tg.sign.use_pnt_z = 17.23
tg.sign.use_rot_x = 0
tg.sign.use_rot_y = 201.44
tg.sign.use_rot_z = 0
tg.sign.lookAt = function(arg1) -- line 314
    START_CUT_SCENE()
    manny:say_line("/tgma034/")
    manny:wait_for_message()
    gate_keeper:say_line("/tggk035/")
    gate_keeper:wait_for_message()
    gate_keeper:say_line("/tggk036/")
    gate_keeper:arms_out()
    END_CUT_SCENE()
end
tg.sign.use = function(arg1) -- line 325
    manny:say_line("/tgma037/")
end
tg.track = Object:create(tg, "/tgtx038/track", -0.61754298, 32.937099, 16.99, { range = 0.60000002 })
tg.track.use_pnt_x = -1.03754
tg.track.use_pnt_y = 32.937099
tg.track.use_pnt_z = 17.129999
tg.track.use_rot_x = 0
tg.track.use_rot_y = 249.435
tg.track.use_rot_z = 0
tg.track.lookAt = function(arg1) -- line 337
    manny:say_line("/tgma039/")
end
tg.track.use = function(arg1) -- line 341
    manny:say_line("/tgma040/")
    manny:wait_for_message()
    manny:say_line("/tgma041/")
end
tg.mt_door = Object:create(tg, "/tgtx042/doorway", -1.54431, 33.795898, 17.58, { range = 0.89999998 })
tg.mt_door.use_pnt_x = -1.55431
tg.mt_door.use_pnt_y = 33.405899
tg.mt_door.use_pnt_z = 17.129999
tg.mt_door.use_rot_x = 0
tg.mt_door.use_rot_y = -3.29249
tg.mt_door.use_rot_z = 0
tg.mt_door.out_pnt_x = -1.51428
tg.mt_door.out_pnt_y = 33.7286
tg.mt_door.out_pnt_z = 17.129999
tg.mt_door.out_rot_x = 0
tg.mt_door.out_rot_y = -7.0957699
tg.mt_door.out_rot_z = 0
tg.mt_door.walkOut = function(arg1) -- line 362
    mt:come_out_door(mt.tg_door)
end
tg.mt_door.lookAt = function(arg1) -- line 366
    manny:say_line("/tgma043/")
end
tg.bs_door = Object:create(tg, "/tgtx044/stairs", -4.3911901, 33.560501, 17.790001, { range = 0.60000002 })
tg.bs_door.use_pnt_x = -2.95119
tg.bs_door.use_pnt_y = 33.2505
tg.bs_door.use_pnt_z = 17.129999
tg.bs_door.use_rot_x = 0
tg.bs_door.use_rot_y = 80.750504
tg.bs_door.use_rot_z = 0
tg.bs_door.out_pnt_x = -3.19085
tg.bs_door.out_pnt_y = 33.289501
tg.bs_door.out_pnt_z = 17.129999
tg.bs_door.out_rot_x = 0
tg.bs_door.out_rot_y = 80.750504
tg.bs_door.out_rot_z = 0
tg.bs_box = tg.bs_door
tg.bs_door.walkOut = function(arg1) -- line 392
    if tg.note.owner ~= manny then
        tg:give_note()
    else
        bs:come_out_door(bs.tg_door)
    end
end
tg.bs_door.lookAt = function(arg1) -- line 400
    manny:say_line("/tgma045/")
end
tg.bs_door.comeOut = function(arg1) -- line 404
    if not seen_hell_train then
        start_script(cut_scene.helltrain)
    else
        Object.come_out_door(arg1)
    end
end
