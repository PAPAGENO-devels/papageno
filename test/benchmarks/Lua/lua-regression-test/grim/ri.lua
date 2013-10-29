CheckFirstTime("ri.lua")
ri = Set:create("ri.set", "rubamat interior", { ri_intws = 0 })
dofile("celso_mop.lua")
ri.mop_point = { x = 3.37647, y = 0.436068, z = 0.3554 }
ri.manny_point = { x = 3.0706, y = 0.3254, z = 0.4624 }
mopvol = 20
ri.watch_costume_events = function() -- line 19
    local local1
    while 1 do
        if celso_mop_event then
            if celso_mop_event == 1 then
                local1 = pick_one_of({ "mopStrk1.wav", "mopStrk2.wav", "mopStrk3.wav", "mopStrk4.wav" })
                start_sfx(local1, 64, mopvol)
            end
            celso_mop_event = nil
        end
        break_here()
    end
end
celso.face_manny = function() -- line 34
    if find_script(celso.face_mop) then
        wait_for_script(celso.face_mop)
    end
    celso.facing_manny = TRUE
    celso:head_look_at_point(ri.manny_point)
    celso:stop_looping_chore(celso_mop_mop_loop, "celso_mop.cos")
    celso:run_chore(celso_mop_to_talk, "celso_mop.cos")
    celso:head_look_at_point(ri.manny_point)
end
celso.face_mop = function() -- line 45
    if find_script(celso.face_manny) then
        wait_for_script(celso.face_manny)
    end
    celso.facing_manny = FALSE
    celso:head_look_at_point(ri.mop_point)
    celso:stop_chore(celso_mop_talk_freeze, "celso_mop.cos")
    celso:run_chore(celso_mop_to_mop, "celso_mop.cos")
    celso:play_chore_looping(celso_mop_mop_loop, "celso_mop.cos")
end
celso.hand_photo = function() -- line 56
    manny:clear_hands()
    if not celso.facing_manny then
        celso:face_manny()
    end
    start_script(celso.blend, celso, celso_mop_hand_photo_2, celso_mop_to_talk, 500, "celso_mop.cos")
    start_script(manny.walk_and_face, manny, 2.92736, 0.303278, 0, 0, 6.37918, 0)
    sleep_for(1500)
    manny:play_chore(ma_reach_med, "ma.cos")
    sleep_for(500)
    ri.photo:hold()
    manny:fade_in_chore(ma_hold, "ma.cos")
    celso:wait_for_chore(celso_mop_hand_photo_2, "celso_mop.cos")
    celso:head_look_at_point(ri.mop_point)
    sleep_for(500)
    celso:blend(celso_mop_talk_freeze, celso_mop_hand_photo_2, 500, "celso_mop.cos")
    celso.face_mop()
end
ri.get_job = function(arg1) -- line 76
    START_CUT_SCENE()
    celso:head_look_at(nil)
    ready_for_logbook = FALSE
    manny:walk_and_face(2.91582, 0.380509, 0, 0, 325.012, 0)
    manny:say_line("/rima058/")
    manny:wait_for_message()
    celso.facing_manny = TRUE
    celso:stop_looping_chore(celso_mop_mop_loop, "celso_mop.cos")
    celso:play_chore(celso_mop_take_logbook, "celso_mop.cos")
    sleep_for(3800)
    manny:say_line("/rima059/")
    manny:stop_chore(nil, "ma.cos")
    manny:run_chore(ma_give_logbook, "ma.cos")
    manny:run_chore(ma_logbook_exit, "ma.cos")
    manny:stop_chore(nil, "ma.cos")
    re.logbook:put_in_limbo()
    wait_for_message()
    sleep_for(500)
    celso:say_line("/rice060/")
    wait_for_message()
    celso:say_line("/rice061/")
    wait_for_message()
    manny:say_line("/rima062/")
    manny:twist_head_gesture()
    wait_for_message()
    celso:head_look_at_point(ri.manny_point)
    celso:say_line("/rice063/")
    wait_for_message()
    celso:say_line("/rice064/")
    wait_for_message()
    celso:say_line("/rice065/")
    wait_for_message()
    celso:stop_chore()
    celso:head_look_at(nil)
    manny:head_look_at(nil)
    celso:play_chore(celso_mop_leave_mop, "celso_mop.cos")
    manny:push_costume("ma_grab_mop.cos")
    manny:play_chore(0, "ma_grab_mop.cos")
    celso:say_line("/rice066/")
    wait_for_message()
    celso:say_line("/rice067/")
    manny:wait_for_chore(0, "ma_grab_mop.cos")
    celso:wait_for_chore(celso_mop_leave_mop, "celso_mop.cos")
    wait_for_message()
    sleep_for(1000)
    END_CUT_SCENE()
    start_script(cut_scene.year2int, cut_scene)
end
ri.set_up_actors = function() -- line 133
    celso:put_in_set(ri)
    celso:set_costume("celso_mop.cos")
    celso:set_mumble_chore(celso_mop_mumble, "celso_mop.cos")
    celso:set_talk_chore(1, celso_mop_no_talk)
    celso:set_talk_chore(2, celso_mop_a)
    celso:set_talk_chore(3, celso_mop_c)
    celso:set_talk_chore(4, celso_mop_e)
    celso:set_talk_chore(5, celso_mop_f)
    celso:set_talk_chore(6, celso_mop_l)
    celso:set_talk_chore(7, celso_mop_m)
    celso:set_talk_chore(8, celso_mop_o)
    celso:set_talk_chore(9, celso_mop_t)
    celso:set_talk_chore(10, celso_mop_u)
    celso:setpos(3.075, 0.625, 0)
    celso:setrot(0, 224.118, 0)
    celso:set_head(5, 6, 7, 165, 28, 80)
    celso:play_chore_looping(celso_mop_mop_loop)
    celso:head_look_at_point(ri.mop_point)
    celso:set_look_rate(130)
    celso.facing_manny = FALSE
end
ri.enter = function(arg1) -- line 162
    start_script(ri.set_up_actors)
    start_script(ri.watch_costume_events)
end
ri.exit = function(arg1) -- line 167
    stop_script(ri.watch_costume_events)
    celso:free()
end
ri.celso_obj = Object:create(ri, "/ritx068/Celso", 3.027, 0.5776, 0.46250001, { range = 0.80000001 })
ri.celso_obj.use_pnt_x = 2.925
ri.celso_obj.use_pnt_y = 0.27500001
ri.celso_obj.use_pnt_z = 0
ri.celso_obj.use_rot_x = 0
ri.celso_obj.use_rot_y = 326.07199
ri.celso_obj.use_rot_z = 0
ri.celso_obj.lookAt = function(arg1) -- line 187
    if ce1 then
        manny:say_line("/rima069/")
    else
        manny:say_line("/rima070/")
    end
end
ri.celso_obj.use = function(arg1) -- line 195
    manny:walkto_object(arg1)
    Dialog:run("ce1", "dlg_celso.lua")
end
ri.celso_obj.use_photo = function(arg1) -- line 200
    manny:say_line("/ccma066/")
end
ri.celso_obj.use_logbook = function(arg1) -- line 204
    ri:get_job()
end
ri.automat = Object:create(ri, "/ritx071/automat doors", 2.4807401, 1.2656, 0.50349998, { range = 0.89999998 })
ri.automat.use_pnt_x = 2.45034
ri.automat.use_pnt_y = 0.88849902
ri.automat.use_pnt_z = 0
ri.automat.use_rot_x = 0
ri.automat.use_rot_y = -5.8937802
ri.automat.use_rot_z = 0
ri.automat.lookAt = function(arg1) -- line 219
    soft_script()
    manny:say_line("/rima072/")
    wait_for_message()
    manny:say_line("/rima073/")
    wait_for_message()
    celso:say_line("/rice074/")
    wait_for_message()
    manny:say_line("/rima075/")
end
ri.automat.use = function(arg1) -- line 230
    soft_script()
    manny:say_line("/rima076/")
    wait_for_message()
    celso:say_line("/rice077/")
end
ri.automat.pickUp = ri.automat.use
ri.condiments = Object:create(ri, "/ritx078/condiments", 3.0552599, 0.099889398, 0.30399999, { range = 0.60000002 })
ri.condiments.use_pnt_x = 2.9186599
ri.condiments.use_pnt_y = 0.27588901
ri.condiments.use_pnt_z = 0
ri.condiments.use_rot_x = 0
ri.condiments.use_rot_y = -143.2
ri.condiments.use_rot_z = 0
ri.condiments.lookAt = function(arg1) -- line 247
    manny:say_line("/rima079/")
end
ri.condiments.pickUp = function(arg1) -- line 251
    soft_script()
    manny:say_line("/rima080/")
    wait_for_message()
    manny:say_line("/rima081/")
end
ri.condiments.use = function(arg1) -- line 258
    manny:say_line("/rima082/")
end
ri.newspaper = Object:create(ri, "/ritx083/newspaper", 3.18662, 0.80306798, 0.24150001, { range = 0.40000001 })
ri.newspaper.use_pnt_x = 3.1182201
ri.newspaper.use_pnt_y = 1.04987
ri.newspaper.use_pnt_z = 0
ri.newspaper.use_rot_x = 0
ri.newspaper.use_rot_y = -173.483
ri.newspaper.use_rot_z = 0
ri.newspaper.lookAt = function(arg1) -- line 271
    soft_script()
    manny:say_line("/rima084/")
    wait_for_message()
    celso:say_line("/rice085/")
end
ri.newspaper.use = ri.newspaper.lookAt
ri.newspaper.pickUp = ri.newspaper.lookAt
ri.photo = Object:create(ri, "/ritx086/photo", 0, 0, 0, { range = 0 })
ri.photo.wav = "getCard.wav"
ri.photo.lookAt = function(arg1) -- line 285
    manny:say_line("/rima087/")
end
ri.photo.use = function(arg1) -- line 289
    manny:say_line("/rima088/")
end
ri.re_door = Object:create(ri, "/ritx089/door", -0.61741298, 0.139908, 0.4172, { range = 0.60000002 })
ri.re_door.use_pnt_x = -0.61741298
ri.re_door.use_pnt_y = 0.41160801
ri.re_door.use_pnt_z = 0
ri.re_door.use_rot_x = 0
ri.re_door.use_rot_y = -192.61301
ri.re_door.use_rot_z = 0
ri.re_door.out_pnt_x = -0.66807699
ri.re_door.out_pnt_y = 0.184798
ri.re_door.out_pnt_z = 0
ri.re_door.out_rot_x = 0
ri.re_door.out_rot_y = -192.61301
ri.re_door.out_rot_z = 0
ri.re_box = ri.re_door
ri.re_door:make_untouchable()
ri.re_door.walkOut = function(arg1) -- line 318
    re:come_out_door(re.ri_door)
end
