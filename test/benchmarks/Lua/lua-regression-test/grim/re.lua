CheckFirstTime("re.lua")
re = Set:create("re.set", "rubamat exterior", { re_estla = 0, re_estla2 = 0, re_front = 1, re_lotws = 2, re_ovrhd = 3, re_velcu = 4, re_mnycu = 5 })
dofile("ma_ve_carry.lua")
dofile("ma_shakecycle_stand.lua")
dofile("glottis_idles.lua")
dofile("velasco_idles.lua")
re.glottis_mark = { x = 0.786365, y = -4.8601, z = -3.4 }
re.glottis_look_point = { x = 0.801131, y = -4.43508, z = -2.655 }
re.vel_shake_spot1 = { x = 7.24323, y = -3.0996, z = -1.56629 }
re.vel_shake_spot2 = { x = 7.27331, y = -2.98701, z = -1.55692 }
re.vel_look_bw_spot = { x = 7.15428, y = -3.10409, z = -1.54379 }
re.vel_look_sky_point = { x = 7.24101, y = -3.07819, z = -1.5001 }
re.bw_look1 = { x = 0.826013, y = -4.32169, z = -3.2145 }
re.bw_look2 = { x = 0.767513, y = -4.50069, z = -2.662 }
re.bw_look3 = { x = 0.0944134, y = -4.53109, z = -3.1975 }
re.bw_look4 = { x = 0.0944134, y = -4.76249, z = -2.7852 }
velasco.idle_table = Idle:create("velasco_idles")
velasco.idle_table:add_state("up_on_toes", { rocking = 0.4, on_toes = 0.1, down_from_toes = 0.1, looks_right = 0.2, tilt_left = 0.2 })
velasco.idle_table:add_state("tilt_up", { standing = 1 })
velasco.idle_table:add_state("tilt_left", { tilt_hold = 0.7, tilt_up = 0.3 })
velasco.idle_table:add_state("tilt_hold", { tilt_hold = 0.6, tilt_up = 0.4 })
velasco.idle_table:add_state("standing", { up_on_toes = 0.25, standing = 0.75, bending_down = 0 })
velasco.idle_table:add_state("rocking", { on_toes = 0.5, down_from_toes = 0.5 })
velasco.idle_table:add_state("on_toes", { rocking = 0.8, down_from_toes = 0.2, on_toes = 0 })
velasco.idle_table:add_state("looks_right", { looks_hold = 1, looks_forward = 0 })
velasco.idle_table:add_state("looks_hold", { looks_hold = 0.6, looks_forward = 0.4 })
velasco.idle_table:add_state("looks_forward", { on_toes = 0.2, looks_right = 0.2, tilt_left = 0.2, rocking = 0.2, down_from_toes = 0.2 })
velasco.idle_table:add_state("hold_down", { bending_up = 0.2, hold_down = 0.8 })
velasco.idle_table:add_state("down_from_toes", { up_on_toes = 0, bending_down = 0, standing = 1 })
velasco.idle_table:add_state("bending_up", { on_toes = 1 })
velasco.idle_table:add_state("bending_down", { hold_down = 1, bending_up = 0 })
re.stop_fake_conversation = function() -- line 46
    stop_script(re.fake_conversation)
    if not find_script(re.car_talk_intro) then
        velasco:shut_up()
        glottis:shut_up()
    end
end
re.car_talk_intro = function(arg1) -- line 54
    re.stop_fake_conversation()
    break_here()
    glottis:say_line("/regl040/")
    glottis:wait_for_message()
    velasco:say_line("/reve041/")
    velasco:wait_for_message()
    start_script(re.fake_conversation)
end
re.more_car_talk = function(arg1) -- line 64
    glottis:say_line("/regl042/")
    wait_for_message()
    glottis:say_line("/regl043/")
    wait_for_message()
    velasco:say_line("/reve044/")
    wait_for_message()
    glottis:say_line("/regl045/")
    wait_for_message()
    velasco:say_line("/reve046/")
    wait_for_message()
end
re.heloruba_outro = function() -- line 77
    START_CUT_SCENE()
    manny:default()
    manny:put_in_set(re)
    SetActorConstrain(system.currentActor.hActor, FALSE)
    plunge_trap_set = TRUE
    set_override(re.heloruba_outro_override)
    manny:setpos(5.47389, -2.9179, -2.47364)
    manny:setrot(0, 274.291, 0)
    SetActorConstrain(system.currentActor.hActor, FALSE)
    re:current_setup(re_estla)
    start_script(re.fix_this_damn_bug)
    play_movie("re_bw.snm", 0, 274)
    SetActorConstrain(system.currentActor.hActor, FALSE)
    manny:walkto(6.78632, -2.86125, -1.99)
    break_here()
    SetActorConstrain(system.currentActor.hActor, FALSE)
    manny:walk_and_face(6.78632, -2.86125, -1.99, 0, 255.741, 0)
    break_here()
    SetActorConstrain(system.currentActor.hActor, FALSE)
    sleep_for(300)
    manny:head_look_at_point(6.71672, -3.03675, -1.5827, 170)
    wait_for_movie()
    re.bone_wagon:play_chore(0)
    manny:head_look_at(nil, 130)
    stop_script(re.fix_this_damn_bug)
    re.bw_needs_updating = TRUE
    END_CUT_SCENE()
end
re.heloruba_outro_override = function() -- line 112
    kill_override()
    manny:setpos(6.78632, -2.86125, -1.99)
    manny:setrot(0, 255.741, 0)
    manny:head_look_at(nil)
    if IsMoviePlaying() then
        StopMovie()
    end
    re.bone_wagon:play_chore(0)
    re.bw_needs_updating = TRUE
    stop_script(re.fix_this_damn_bug)
end
re.fix_this_damn_bug = function() -- line 125
    while 1 do
        break_here()
        glottis:set_visibility(FALSE)
    end
end
re.velasco_shake_head = function() -- line 132
    velasco:set_look_rate(25)
    while 1 do
        velasco:head_look_at_point(re.vel_shake_spot1)
        sleep_for(250)
        velasco:head_look_at_point(re.vel_shake_spot2)
        sleep_for(250)
    end
end
velasco.manny_cu_pos = function(arg1) -- line 142
    velasco:setpos(7.46706, -2.46743, -1.99)
    velasco:setrot(0, 180.912, 0)
end
velasco.cu_pos = function(arg1) -- line 147
    velasco:setpos(7.19231, -2.94419, -1.99)
    velasco:setrot(0, 216.983, 0)
end
re.velasco_intro = function() -- line 152
    local local1, local2
    START_CUT_SCENE()
    stop_script(re.setup_velasco_idles)
    stop_script(velasco.walk_and_face)
    stop_script(velasco.walkto)
    stop_script(velasco.new_run_idle)
    stop_script(re.vel_look_around)
    re:current_setup(re_velcu)
    re:current_setup(re_mnycu)
    re:current_setup(re_estla)
    manny:free()
    velasco:default()
    velasco:follow_boxes()
    velasco:put_in_set(re)
    velasco:set_walk_rate(0.23)
    velasco:head_look_at(nil)
    velasco:push_costume("ma_ve_carry.cos")
    velasco:set_walk_chore(nil)
    velasco:set_rest_chore(nil)
    velasco.footsteps = footsteps.velasco
    set_override(re.velasco_intro_override)
    music_state:set_sequence(seqMeetVelasco)
    velasco:setpos(7.3227401, -1.10838, -1.99)
    velasco:setrot(0, 175.411, 0)
    velasco:play_chore_looping(ma_ve_carry_ma_carry, "ma_ve_carry.cos")
    velasco:walkto(7.3450799, -2.51139, -1.994)
    velasco:wait_for_actor()
    velasco:stop_chore(ma_ve_carry_ma_carry, "ma_ve_carry.cos")
    velasco:play_chore(ma_ve_carry_drop_ma, "ma_ve_carry.cos")
    sleep_for(1500)
    re:current_setup(re_mnycu)
    velasco:manny_cu_pos()
    velasco:say_line("/plgvl03a/")
    wait_for_message()
    re:current_setup(re_velcu)
    velasco:cu_pos()
    velasco:say_line("/plgvl03b/")
    start_script(re.velasco_shake_head)
    wait_for_message()
    stop_script(re.velasco_shake_head)
    velasco:set_look_rate(180)
    velasco:head_look_at_point(re.vel_look_bw_spot)
    sleep_for(1000)
    velasco:say_line("/plgvl04a/")
    wait_for_message()
    velasco:say_line("/plgvl04b/")
    velasco:head_look_at_point(7.2711101, -3.0781901, -1.5986)
    sleep_for(3000)
    velasco:head_look_at(nil)
    velasco:default()
    velasco:put_in_set(re)
    start_script(velasco.walk_and_face, velasco, 0.63307297, -3.9885099, -3.4000001, 0, 140.009, 0)
    sleep_for(1000)
    stop_script(velasco.walk_and_face)
    velasco:setpos(6.26722, -2.8559599, -2.05934)
    velasco:setrot(0, 94.547997, 0)
    start_script(velasco.walk_down_to_car)
    re:current_setup(re_estla)
    manny:default()
    manny:setpos(7.2093101, -2.7980101, -1.99)
    manny:setrot(0, 188.711, 0)
    manny:push_costume("ma_shakecycle_stand.cos")
    manny:run_chore(ma_shakecycle_stand_bendup_shake, "ma_shakecycle_stand.cos")
    manny:play_chore_looping(ma_shakecycle_stand_shiver_cycle, "ma_shakecycle_stand.cos")
    sleep_for(2000)
    END_CUT_SCENE()
    system.buttonHandler = shiver_button_handler
    start_script(re.setup_velasco_idles)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.34999999)
    re.velasco_obj:make_touchable()
end
re.velasco_intro_override = function() -- line 243
    kill_override()
    stop_script(re.velasco_shake_head)
    manny:default()
    manny:push_costume("ma_shakecycle_stand.cos")
    manny:play_chore_looping(ma_shakecycle_stand_shiver_cycle, "ma_shakecycle_stand.cos")
    manny:setpos(7.20931, -2.79801, -1.99)
    manny:setrot(0, 188.711, 0)
    stop_script(velasco.walk_down_to_car)
    re:current_setup(re_estla)
    velasco:stop_chore()
    velasco:head_look_at(nil)
    velasco:setpos(0.633073, -3.98851, -3.4)
    velasco:setrot(0, 140.009, 0)
    velasco:set_look_rate(180)
    system.buttonHandler = shiver_button_handler
    velasco:setpos(0.633073, -3.98851, -3.4)
    velasco:setrot(0, 140.009, 0)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.35)
    re.velasco_obj:make_touchable()
    single_start_script(re.setup_velasco_idles)
end
shiver_button_handler = function(arg1, arg2, arg3) -- line 267
    if arg2 and cutSceneLevel <= 0 then
        if not find_script(re.manny_get_up, arg1, arg2, arg3) then
            start_script(re.manny_get_up, arg1, arg2, arg3)
        end
    end
end
velasco.walk_down_to_car = function() -- line 275
    velasco:walk_and_face(3.4835, -2.82654, -3.4, 0, 90.3123, 0)
    velasco:wait_for_actor()
    velasco:walk_and_face(0.633073, -3.98851, -3.4, 0, 140.009, 0)
end
re.manny_get_up = function(arg1, arg2, arg3) -- line 282
    local local1 = manny:getrot()
    START_CUT_SCENE()
    manny:stop_looping_chore(ma_shakecycle_stand_shiver_cycle, "ma_shakecycle_stand.cos")
    manny:play_chore(ma_shakecycle_stand_shiver_getup, "ma_shakecycle_stand.cos")
    manny:wait_for_chore(ma_shakecycle_stand_shiver_getup, "ma_shakecycle_stand.cos")
    manny:default()
    manny:setrot(local1.x, local1.y + 180, local1.z)
    system.buttonHandler = SampleButtonHandler
    END_CUT_SCENE()
end
re.vel_look_around = function() -- line 295
    while 1 do
        sleep_for(3000 + 4000 * random())
        velasco:head_look_at_point(pick_one_of({ re.bw_look1, re.bw_look2, re.bw_look3, re.bw_look4 }))
    end
end
re.setup_velasco_idles = function(arg1) -- line 302
    while find_script(velasco.walk_down_to_car) and re:current_setup() == re_estla do
        break_here()
    end
    start_script(re.setup_velasco_idles2)
end
re.setup_velasco_idles2 = function() -- line 309
    stop_script(velasco.walk_down_to_car)
    stop_script(velasco.walk_and_face)
    velasco:setpos(0.633073, -3.98851, -3.4)
    velasco:setrot(0, 140.009, 0)
    velasco:default()
    velasco:put_in_set(re)
    velasco:push_costume("velasco_idles.cos")
    velasco:set_collision_mode(COLLISION_BOX, 1)
    start_script(velasco.new_run_idle, velasco, "standing", velasco.idle_table, "velasco_idles.cos")
    start_script(re.vel_look_around)
    start_script(re.fake_conversation)
end
re.see_cactus = function(arg1) -- line 323
    START_CUT_SCENE()
    fc:switch_to_set()
    manny:put_in_set(fc)
    manny:setpos(19.9082, 0.332317, 1.30575)
    manny:setrot(0, 128.548, 0)
    break_here()
    manny:walkto(19.5434, 0.0680735, 1.30575, 0, 105.545, 0)
    manny:wait_for_actor()
    sleep_for(1000)
    if not fc.seen_road then
        fc.seen_road = TRUE
        manny:say_line("/rema072/")
        wait_for_message()
        manny:say_line("/rema073/")
        wait_for_message()
        manny:say_line("/rema074/")
        wait_for_message()
        manny:say_line("/rema075/")
        wait_for_message()
    end
    manny:say_line("/rema076/")
    wait_for_message()
    manny:walkto(19.9082, 0.332317, 1.30575)
    sleep_for(500)
    END_CUT_SCENE()
    re:come_out_door(arg1)
end
re.fake_conversation = function() -- line 352
    local local1
    while not re.in_dialog do
        if not find_script(re.car_talk_intro) then
            sleep_for(random() * 4000)
            velasco:play_chore_looping(velasco_mumble, "velasco.cos")
            sleep_for(random() * 3000 + 1000)
            velasco:shut_up()
            sleep_for(2000 * random())
            glottis:play_chore_looping(glottis_mumble, "glottis.cos")
            sleep_for(random() * 5000 + 2000)
            glottis:shut_up()
        else
            break_here()
        end
    end
end
re.set_up_actors = function() -- line 373
    glottis:default()
    glottis:push_costume("glottis_idles.cos")
    glottis:ignore_boxes()
    glottis:put_in_set(re)
    glottis:head_look_at(nil, 360)
    glottis:setpos(0.921865, -4.8776, -3.4)
    glottis:setrot(0, 315.689, 0)
    glottis:play_chore(glottis_idles_hold, "glottis_idles.cos")
    if re.plunged then
        re.velasco_obj:make_touchable()
        re:setup_velasco_idles()
        manny:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(manny.hActor, 0.35)
    else
        re.velasco_obj:make_untouchable()
    end
end
re.enter = function(arg1) -- line 398
    start_script(re.set_up_actors)
    re.bone_wagon.hObjectState = re:add_object_state(re_estla, "re_bw_anim.bm", nil, OBJSTATE_STATE, FALSE)
    re.bone_wagon:set_object_state("re_bw_anim.cos")
    if not re.plunged then
        plunge_trap_set = TRUE
        preload_sfx("re_slip.wav")
    end
    SetShadowColor(10, 10, 10)
end
re.camerachange = function(arg1, arg2, arg3) -- line 426
    if re.bw_needs_updating then
        re.bw_needs_updating = FALSE
        glottis:set_visibility(TRUE)
        re.bone_wagon:play_chore(1)
    end
    if re.plunged and arg3 == re_lotws then
        if find_script(re.setup_velasco_idles) then
            stop_script(re.setup_velasco_idles)
            start_script(re.setup_velasco_idles2)
        end
        if not re.heard_car_talk_intro then
            re.heard_car_talk_intro = TRUE
            start_script(re.car_talk_intro)
        end
    end
end
re.exit = function(arg1) -- line 444
    stop_script(velasco.new_run_idle)
    stop_script(re.vel_look_around)
    stop_script(re.fake_conversation)
    manny:set_collision_mode(COLLISION_OFF)
    glottis:free()
    velasco:free()
    re.bone_wagon:free_object_state()
    KillActorShadows(manny.hActor)
end
re.bone_wagon = Object:create(re, "/retx058/Bone Wagon", 0.49903101, -4.5590901, -2.993, { range = 0.80000001 })
re.bone_wagon.use_pnt_x = 0.49903101
re.bone_wagon.use_pnt_y = -4.2260799
re.bone_wagon.use_pnt_z = -3.4000001
re.bone_wagon.use_rot_x = 0
re.bone_wagon.use_rot_y = 219.369
re.bone_wagon.use_rot_z = 0
re.bone_wagon.lookAt = function(arg1) -- line 469
    manny:say_line("/rema059/")
end
re.bone_wagon.pickUp = function(arg1) -- line 473
    sg.bone_wagon:pickUp()
end
re.bone_wagon.use = function(arg1) -- line 477
    soft_script()
    if not find_script(re.more_car_talk) then
        if not find_script(re.velasco_obj.use) then
            wait_for_script(re.car_talk_intro)
            if re.plunged then
                re.stop_fake_conversation()
            end
            START_CUT_SCENE()
            manny:say_line("/rema060/")
            manny:twist_head_gesture()
            wait_for_message()
            glottis:head_look_at_manny()
            if re.plunged then
                glottis:say_line("/regl061/")
                wait_for_message()
                glottis:head_follow_mesh(velasco, 6, TRUE)
            else
                glottis:say_line("/regl062/")
                wait_for_message()
                glottis:head_look_at(nil)
            end
            END_CUT_SCENE()
            if re.plunged then
                start_script(re.fake_conversation)
            end
        end
    end
end
re.velasco_obj = Object:create(re, "/retx063/Velasco", 0.55661398, -4.0648499, -2.8923299, { range = 0.80000001 })
re.velasco_obj.use_pnt_x = 0.272825
re.velasco_obj.use_pnt_y = -4.2909498
re.velasco_obj.use_pnt_z = -3.4000001
re.velasco_obj.use_rot_x = 0
re.velasco_obj.use_rot_y = 303.51801
re.velasco_obj.use_rot_z = 0
re.velasco_obj.lookAt = function(arg1) -- line 516
    manny:say_line("/rema064/")
end
re.velasco_obj.pickUp = function(arg1) -- line 520
    manny:say_line("/rema065/")
end
re.velasco_obj.use = function(arg1) -- line 524
    soft_script()
    if manny:walkto_object(arg1) then
        Dialog:run("ve1", "dlg_velasco.lua")
    end
end
re.velasco_obj.use_photo = function(arg1) -- line 531
    if manny:walkto_object(arg1) then
        Dialog:run("ve1", "dlg_velasco.lua", "photo")
    end
end
re.velasco_obj.use_logbook = function(arg1) -- line 537
    manny:say_line("/rema066/")
end
re.logbook = Object:create(re, "/retx067/logbook", 0, 0, 0, { range = 0 })
re.logbook.wav = "getBook.wav"
re.logbook.lookAt = function(arg1) -- line 546
    manny:say_line("/rema068/")
end
re.logbook.use = function(arg1) -- line 550
    manny:say_line("/rema069/")
end
re.plunge_trigger = { }
re.plunge_trigger.walkOut = function(arg1) -- line 562
    local local1 = manny:getpos()
    if plunge_trap_set then
        re.plunged = TRUE
        plunge_trap_set = FALSE
        START_CUT_SCENE()
        manny:walkto(local1.x, local1.y + 0.69999999, local1.z)
        manny:wait_for_actor()
        if manny.is_holding then
            manny.is_holding = nil
            manny:stop_chore(manny.hold_chore, manny.base_costume)
            manny:stop_chore(ma_hold, manny.base_costume)
            manny:stop_chore(ma_hold_scythe, manny.base_costume)
        end
        manny:set_visibility(FALSE)
        manny:play_sound_at("re_slip.wav")
        sleep_for(1000)
        manny:say_line("/hkma015/")
        manny:wait_for_message()
        sleep_for(1000)
        manny:say_line("/hkma013/")
        manny:wait_for_message()
        sleep_for(250)
        manny:set_visibility(TRUE)
        END_CUT_SCENE()
        start_script(cut_scene.plunge, cut_scene)
    else
        ResetMarioControls()
        manny:walkto(local1.x, local1.y - 0.80000001, local1.z)
        manny:say_line("/rema070/")
    end
end
re.fc_door1 = Object:create(re, "", -1.05828, -4.5809898, -2.974, { range = 0.60000002 })
re.fc_door1.use_pnt_x = -0.84753698
re.fc_door1.use_pnt_y = -4.31287
re.fc_door1.use_pnt_z = -3.4000001
re.fc_door1.use_rot_x = 0
re.fc_door1.use_rot_y = -230.744
re.fc_door1.use_rot_z = 0
re.fc_door1.out_pnt_x = -1.0012701
re.fc_door1.out_pnt_y = -4.5511599
re.fc_door1.out_pnt_z = -3.4000001
re.fc_door1.out_rot_x = 0
re.fc_door1.out_rot_y = -230.51601
re.fc_door1.out_rot_z = 0
re.fc_door1:make_untouchable()
re.fc_door1.walkOut = function(arg1) -- line 620
    start_script(re.see_cactus, arg1)
end
re.fc_door2 = Object:create(re, "", 2.57214, -5.1846299, -2.9554999, { range = 0.60000002 })
re.fc_door2.use_pnt_x = 2.57214
re.fc_door2.use_pnt_y = -4.0476298
re.fc_door2.use_pnt_z = -3.4000001
re.fc_door2.use_rot_x = 0
re.fc_door2.use_rot_y = -183.705
re.fc_door2.use_rot_z = 0
re.fc_door2.out_pnt_x = 2.506
re.fc_door2.out_pnt_y = -5.0750999
re.fc_door2.out_pnt_z = -3.4000001
re.fc_door2.out_rot_x = 0
re.fc_door2.out_rot_y = -183.705
re.fc_door2.out_rot_z = 0
re.fc_door2:make_untouchable()
re.fc_door2.walkOut = function(arg1) -- line 641
    start_script(re.see_cactus, arg1)
end
re.ri_door = Object:create(re, "/retx078/door", -1.46644, 0.210143, 0.31779999, { range = 0.80000001 })
re.ri_door.use_pnt_x = -1.46644
re.ri_door.use_pnt_y = -0.352357
re.ri_door.use_pnt_z = -0.13
re.ri_door.use_rot_x = 0
re.ri_door.use_rot_y = -359.17401
re.ri_door.use_rot_z = 0
re.ri_door.out_pnt_x = -1.47202
re.ri_door.out_pnt_y = 0.025
re.ri_door.out_pnt_z = -0.13
re.ri_door.out_rot_x = 0
re.ri_door.out_rot_y = -359.17401
re.ri_door.out_rot_z = 0
re.ri_door:make_untouchable()
re.ri_door.walkOut = function(arg1) -- line 668
    ri:come_out_door(ri.re_door)
end
re.ri_door.use = re.ri_door.walkOut
