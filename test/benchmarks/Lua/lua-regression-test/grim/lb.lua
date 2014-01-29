CheckFirstTime("lb.lua")
lb = Set:create("lb.set", "Lobby for Beaver Room", { lb_modws = 0, lb_ovrhd = 1 })
dofile("lb_bw.lua")
dofile("bonewagon_gl.lua")
lb.rock_actor = { }
lb.rock_actor.parent = Actor
lb.rock_actor.rocks = { }
lb.rock_actor.rocks[1] = { x = 0.307026, y = 3.31776, z = -0.214144, scale = 1.9 }
lb.rock_actor.rocks[2] = { x = -0.157974, y = 1.75476, z = -0.435144, scale = 1.9 }
lb.rock_actor.rocks[3] = { x = 0.0640259, y = -0.00324261, z = -0.190144, scale = 1.9 }
lb.rock_actor.rocks[4] = { x = 0.0370259, y = -1.06724, z = -0.0631438, scale = 1.7 }
lb.rock_actor.rocks[5] = { x = -0.3547, y = -1.73734, z = -0.0367978, scale = 2 }
lb.rock_actor.rocks[6] = { x = 0.41549, y = -1.62212, z = 0.1158, scale = 2 }
lb.rock_actor.default = function(arg1, arg2) -- line 27
    local local1
    if not arg1.rocks[arg2].actor then
        local1 = Actor:create(nil, nil, nil, "rock")
    else
        local1 = arg1.rocks[arg2].actor
    end
    local1:set_costume("x_spot.cos")
    local1:set_visibility(FALSE)
    local1:set_collision_mode(COLLISION_SPHERE, arg1.rocks[arg2].scale)
    local1:put_in_set(lb)
    local1:setpos(arg1.rocks[arg2].x, arg1.rocks[arg2].y, arg1.rocks[arg2].z)
    arg1.rocks[arg2].actor = local1
end
lb.rock_actor.default_all = function(arg1) -- line 44
    local local1, local2
    local1, local2 = next(arg1.rocks, nil)
    while local1 do
        arg1:default(local1)
        local1, local2 = next(arg1.rocks, local1)
    end
end
lb.rock_actor.free_all = function(arg1) -- line 53
    local local1, local2
    local1, local2 = next(arg1.rocks, nil)
    while local1 do
        if local2.actor then
            local2.actor:free()
        end
        local1, local2 = next(arg1.rocks, local1)
    end
end
lb.enable_bw_boxes = function(arg1, arg2) -- line 66
    local local1
    local1 = 1
    while local1 <= 7 do
        MakeSectorActive("bw_box" .. local1, arg2)
        local1 = local1 + 1
    end
    local1 = 1
    while local1 <= 5 do
        MakeSectorActive("no_bw_box" .. local1, not arg2)
        local1 = local1 + 1
    end
end
lb.glottis_drive_in_anim = function(arg1) -- line 82
    glottis:set_costume(nil)
    glottis:set_costume("gl_drive_up.cos")
    glottis:put_in_set(lb)
    glottis:set_visibility(TRUE)
    glottis:set_collision_mode(COLLISION_OFF)
    glottis:ignore_boxes()
    glottis:setpos(1.97028, 4.15063, 0)
    glottis:setrot(0, 93.8626, 0)
    start_sfx("bwDown02.WAV")
    fade_sfx("bwDown02.WAV", 500)
    start_sfx("bwTire01.WAV")
    glottis:play_chore(0)
    lb.bone_wagon:play_chore(lb_bw_drive_in, "lb_bw.cos")
    lb.bone_wagon:wait_for_chore(lb_bw_drive_in)
    sleep_for(300)
    glottis:stop_chore(0)
    lb:init_glottis()
end
lb.init_glottis = function(arg1) -- line 103
    glottis:set_costume(nil)
    glottis:set_costume("bonewagon_gl.cos")
    glottis:set_collision_mode(COLLISION_OFF)
    glottis:set_visibility(TRUE)
    glottis:set_mumble_chore(bonewagon_gl_gl_mumble)
    glottis:set_talk_chore(1, bonewagon_gl_stop_talk)
    glottis:set_talk_chore(2, bonewagon_gl_a)
    glottis:set_talk_chore(3, bonewagon_gl_c)
    glottis:set_talk_chore(4, bonewagon_gl_e)
    glottis:set_talk_chore(5, bonewagon_gl_f)
    glottis:set_talk_chore(6, bonewagon_gl_l)
    glottis:set_talk_chore(7, bonewagon_gl_m)
    glottis:set_talk_chore(8, bonewagon_gl_o)
    glottis:set_talk_chore(9, bonewagon_gl_t)
    glottis:set_talk_chore(10, bonewagon_gl_u)
    glottis:play_chore(bonewagon_gl_hide_bw, "bonewagon_gl.cos")
    glottis:put_in_set(lb)
    glottis:ignore_boxes()
    glottis:setpos(2.29732, 4.15139, 0.0027831)
    glottis:setrot(0, 90, 0)
    glottis:play_chore(bonewagon_gl_drive, "bonewagon_gl.cos")
    single_start_script(sg.glottis_roars, sg, glottis)
end
lb.drive_in = function(arg1) -- line 129
    bonewagon:put_in_set(nil)
    if not mod_solved then
        START_CUT_SCENE()
        StartMovie("lb_bw1.snm")
        wait_for_movie()
        lb:glottis_drive_in_anim()
        if not lb.felt_bumpy then
            lb.felt_bumpy = TRUE
            glottis:stop_chore(bonewagon_gl_drive, "bonewagon_gl.cos")
            glottis:play_chore(bonewagon_gl_gl_2hands_out, "bonewagon_gl.cos")
            glottis:say_line("/lbgl001/")
            glottis:wait_for_message()
            glottis:play_chore(bonewagon_gl_gl_stop_hands_out, "bonewagon_gl.cos")
            glottis:say_line("/lbgl022/")
            glottis:wait_for_message()
            glottis:play_chore(bonewagon_gl_drive, "bonewagon_gl.cos")
        end
        END_CUT_SCENE()
        lb:leave_BW()
    elseif not lb.got_key then
        START_CUT_SCENE()
        StartMovie("lb_bw1.snm")
        wait_for_movie()
        lb:glottis_drive_in_anim()
        glottis:say_line("/lbgl003/")
        wait_for_message()
        END_CUT_SCENE()
        lb:leave_BW()
    else
        START_CUT_SCENE()
        StartMovie("lb_bw1.snm")
        wait_for_movie()
        RunFullscreenMovie("lb.snm")
        END_CUT_SCENE()
        bv:drive_in()
    end
end
lb.drive_out = function(arg1) -- line 174
    START_CUT_SCENE()
    glottis:set_costume(nil)
    glottis:set_costume("gl_drive_up.cos")
    glottis:put_in_set(lb)
    glottis:setpos(1.97028, 4.15063, 0)
    glottis:setrot(0, 93.8626, 0)
    glottis:play_chore(1)
    sleep_for(200)
    start_sfx("bwStart.WAV", IM_HIGH_PRIORITY)
    sleep_for(300)
    start_sfx("bwUp05.WAV", IM_HIGH_PRIORITY)
    sleep_for(200)
    lb.bone_wagon:play_chore(lb_bw_drive_out, "lb_bw.cos")
    lb.bone_wagon:wait_for_chore(lb_bw_drive_out)
    glottis:wait_for_chore(1)
    END_CUT_SCENE()
    if mod_solved and lb.got_key then
        manny:set_selected()
        manny:set_visibility(TRUE)
        RunFullscreenMovie("lb.snm")
        bv:drive_in()
    else
        na:switch_to_set()
        bonewagon:put_in_set(na)
        bonewagon:follow_boxes()
        bonewagon:setpos(2.37537, -3.2269, 0.5)
        bonewagon:setrot(0, 247.545, 0)
        bonewagon:set_selected()
    end
end
lb.leave_BW = function(arg1) -- line 207
    stop_script(bonewagon.gas)
    stop_script(bonewagon.reverse)
    stop_script(bonewagon.left)
    stop_script(bonewagon.right)
    stop_script(bonewagon.monitor_turns)
    manny.is_driving = FALSE
    bonewagon.current_set = lb
    system.buttonHandler = SampleButtonHandler
    lb.bone_wagon:make_touchable()
    manny:put_in_set(system.currentSet)
    manny:set_visibility(TRUE)
    manny:set_selected()
    manny:ignore_boxes()
    manny:setpos(4.62181, 3.04604, 0.0662619)
    manny:setrot(0, 240, 0)
    manny:push_costume("ma_climb_bw.cos")
    SetActorFrustrumCull(manny.hActor, FALSE)
    manny:play_chore(ma_climb_bw_get_off_bw, "ma_climb_bw.cos")
    manny:wait_for_chore(ma_climb_bw_get_off_bw, "ma_climb_bw.cos")
    manny:pop_costume()
    manny:follow_boxes()
    SetActorFrustrumCull(manny.hActor, TRUE)
    manny:setpos(3.6732, 2.81382, 0.0666561)
    manny:setrot(0, 176.872, 0)
    manny:walkto(1.30964, 3.37437, -0.175334, 0, 82.1938, 0)
    inventory_disabled = FALSE
end
lb.get_in_BW = function(arg1) -- line 241
    stop_script(glottis.talk_randomly_from_weighted_table)
    START_CUT_SCENE()
    manny:head_look_at(nil)
    manny:walkto_object(lb.bone_wagon)
    manny:setrot(0, 264.4, 0)
    manny:push_costume("ma_climb_bw.cos")
    start_sfx("bwMaClmb.WAV")
    manny:play_chore(ma_climb_bw_get_on_bw, "ma_climb_bw.cos")
    manny:wait_for_chore(ma_climb_bw_get_on_bw, "ma_climb_bw.cos")
    manny:pop_costume()
    manny:put_in_set(nil)
    END_CUT_SCENE()
    lb.bone_wagon:make_untouchable()
    bonewagon.current_set = nil
    manny.is_driving = TRUE
    manny:set_visibility(FALSE)
    system.buttonHandler = bone_wagon_button_handler
    start_script(bonewagon.monitor_turns, bonewagon)
end
lb.enter = function(arg1) -- line 272
    if not lb.got_key then
        lb.key:show()
    else
        lb.key:hide()
    end
    if manny.is_driving or lb.bone_wagon.touchable then
        lb:add_object_state(lb_modws, "lb_bw.bm", "lb_bw.zbm", OBJSTATE_STATE)
        lb.bone_wagon:set_object_state("lb_bw.cos")
        lb:enable_bw_boxes(TRUE)
    else
        lb:enable_bw_boxes(FALSE)
    end
    if manny.is_driving then
        lb.bone_wagon:make_untouchable()
        start_script(lb.drive_in, lb)
    elseif lb.bone_wagon.touchable then
        lb.bone_wagon:play_chore(lb_bw_here, "lb_bw.cos")
        lb:init_glottis()
    end
    manny:set_collision_mode(COLLISION_SPHERE, 0.4)
    glottis:set_collision_mode(COLLISION_OFF)
    lb.rock_actor:default_all()
    lb:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
lb.exit = function(arg1) -- line 304
    manny:set_collision_mode(COLLISION_OFF)
    lb.rock_actor:free_all()
    glottis:free()
    lb.key_actor:free()
    stop_script(sg.glottis_roars)
    glottis:shut_up()
    bonewagon:shut_up()
end
lb.bone_wagon = Object:create(lb, "/lbtx004/Bone Wagon", 2.13448, 4.0596199, 0.290719, { range = 1.5 })
lb.bone_wagon.use_pnt_x = 3.6728101
lb.bone_wagon.use_pnt_y = 2.80704
lb.bone_wagon.use_pnt_z = 0.066261902
lb.bone_wagon.use_rot_x = 0
lb.bone_wagon.use_rot_y = 13.4301
lb.bone_wagon.use_rot_z = 0
lb.bone_wagon.touchable = FALSE
lb.bone_wagon.lookAt = function(arg1) -- line 332
    manny:say_line("/lbma005/")
end
lb.bone_wagon.use = function(arg1) -- line 336
    START_CUT_SCENE()
    lb:get_in_BW()
    lb:drive_out()
    END_CUT_SCENE()
end
lb.sign = Object:create(lb, "/lbtx006/sign", -0.76020002, 4.1336002, 0.89999998, { range = 1.5 })
lb.sign.use_pnt_x = -0.186588
lb.sign.use_pnt_y = 3.5676601
lb.sign.use_pnt_z = -0.29107299
lb.sign.use_rot_x = 0
lb.sign.use_rot_y = 47.726299
lb.sign.use_rot_z = 0
lb.sign.lookAt = function(arg1) -- line 352
    START_CUT_SCENE()
    if not lb.sign.seen then
        lb.sign.seen = TRUE
        manny:say_line("/lbma007/")
        wait_for_message()
    end
    manny:say_line("/lbma008/")
    wait_for_message()
    manny:say_line("/lbma009/")
    wait_for_message()
    manny:say_line("/lbma010/")
    wait_for_message()
    manny:say_line("/lbma011/")
    wait_for_message()
    manny:say_line("/lbma012/")
    wait_for_message()
    manny:say_line("/lbma013/")
    END_CUT_SCENE()
end
lb.sign.use = function(arg1) -- line 373
    if lb.got_key then
        manny:say_line("/lbma014/")
    else
        if not lb.sign.seen then
            START_CUT_SCENE()
            arg1:lookAt()
            wait_for_message()
            END_CUT_SCENE()
        end
        lb.got_key = TRUE
        START_CUT_SCENE()
        MakeSectorActive("get_key_box1", TRUE)
        MakeSectorActive("get_key_box2", TRUE)
        manny:walkto(-0.486298, 3.81497, -0.3, 0, 22.8147, 0)
        manny:wait_for_actor()
        manny:push_costume("ma_action_sign.cos")
        start_sfx("keyRatl.IMU", IM_HIGH_PRIORITY, 90)
        manny:play_chore(ma_action_sign_start_lift, "ma_action_sign.cos")
        manny:wait_for_chore(ma_action_sign_start_lift, "ma_action_sign.cos")
        start_script(lb.sign.rattle_key, lb.sign)
        manny:play_chore_looping(ma_action_sign_loop_lift, "ma_action_sign.cos")
        sleep_for(2000)
        fade_sfx("keyRatl.imu", 400)
        lb.sign:drop_key()
        manny:set_chore_looping(ma_action_sign_loop_lift, FALSE, "ma_action_sign.cos")
        manny:wait_for_chore(ma_action_sign_loop_lift, "ma_action_sign.cos")
        manny:run_chore(ma_action_sign_end_lift, "ma_action_sign.cos")
        manny:stop_chore(ma_action_sign_end_lift, "ma_action_sign.cos")
        manny:pop_costume()
        manny:backup(500)
        manny:head_look_at_point(-0.575574, 3.86573, -0.300025)
        sleep_for(1000)
        manny:say_line("/lbma015/")
        manny:walkto(-0.486298, 3.81497, -0.3, 0, 22.8147, 0)
        manny:wait_for_actor()
        manny:play_chore(ma_reach_low, "ma.cos")
        sleep_for(1000)
        manny:generic_pickup(lb.key)
        manny:wait_for_chore(ma_reach_low, "ma.cos")
        manny:stop_chore(ma_reach_low, "ma.cos")
        manny:walkto_object(arg1)
        MakeSectorActive("get_key_box1", FALSE)
        MakeSectorActive("get_key_box2", FALSE)
        END_CUT_SCENE()
    end
end
lb.sign.pickUp = lb.sign.use
lb.sign.rattle_key = function(arg1) -- line 423
    local local1 = 2
    local local2, local3
    while system.currentSet == lb do
        local2 = rndint(270 - local1, 270 + local1)
        local3 = rndint(0 - local1, local1)
        lb.key_actor:setrot(local2, local3, 0)
        break_here()
        if local1 < 20 then
            local1 = local1 + 1
        end
    end
end
lb.sign.drop_key = function(arg1) -- line 438
    local local1, local2
    local local3 = 0.0099999998
    stop_script(lb.sign.rattle_key)
    local2 = manny:getpos()
    local1 = lb.key_actor:getpos()
    while local1.z > local2.z do
        local1.z = local1.z - local3
        lb.key_actor:setpos(local1.x, local1.y, local1.z)
        local3 = local3 + 0.0099999998
        break_here()
    end
    start_sfx("keyDrop.wav")
    lb.key:hide()
end
lb.key = Object:create(lb, "/lbtx016/key", -0.498319, 4.5485702, 0.56169403, { range = 0 })
lb.key.lookAt = function(arg1) -- line 459
    manny:say_line("/lbma017/")
end
lb.key.use = function(arg1) -- line 463
    manny:say_line("/lbma018/")
end
lb.key.default_response = function(arg1) -- line 467
    manny:say_line("/lbma019/")
end
lb.key.show = function(arg1) -- line 471
    if not lb.key_actor then
        lb.key_actor = Actor:create(nil, nil, nil, "key")
    end
    lb.key_actor:set_costume("key.cos")
    lb.key_actor:set_visibility(TRUE)
    lb.key_actor:put_in_set(lb)
    lb.key_actor:setpos(-0.586667, 5.20806, 1.39971)
    lb.key_actor:setrot(270, 0, 0)
    SetActorScale(lb.key_actor.hActor, 2)
end
lb.key.hide = function(arg1) -- line 483
    lb.key_actor:set_visibility(FALSE)
    lb.key_actor:put_in_set(nil)
end
lb.bd_door = Object:create(lb, "/lbtx020/door", -2.1602001, -8.6664, 1.9, { range = 0.5 })
lb.bd_box = lb.bd_door
lb.bd_door.use_pnt_x = 0.1023
lb.bd_door.use_pnt_y = -2.49984
lb.bd_door.use_pnt_z = -0.105641
lb.bd_door.use_rot_x = 0
lb.bd_door.use_rot_y = 157.991
lb.bd_door.use_rot_z = 0
lb.bd_door.out_pnt_x = -0.015922099
lb.bd_door.out_pnt_y = -5.6293201
lb.bd_door.out_pnt_z = -0.59090799
lb.bd_door.out_rot_x = 0
lb.bd_door.out_rot_y = 184.998
lb.bd_door.out_rot_z = 0
lb.bd_door.walkOut = function(arg1) -- line 512
    bv:come_out_door(bv.sg_door)
end
lb.na_door = Object:create(lb, "/lbtx021/door", 12.6398, -8.6664, 1.9, { range = 0.5 })
lb.sg_box = lb.na_door
lb.na_door.use_pnt_x = 11.78
lb.na_door.use_pnt_y = -8.6630001
lb.na_door.use_pnt_z = 0.2
lb.na_door.use_rot_x = 0
lb.na_door.use_rot_y = -473.85001
lb.na_door.use_rot_z = 0
lb.na_door.out_pnt_x = 12.864
lb.na_door.out_pnt_y = -8.9449997
lb.na_door.out_pnt_z = 0.2
lb.na_door.out_rot_x = 0
lb.na_door.out_rot_y = -456.97501
lb.na_door.out_rot_z = 0
lb.na_door.walkOut = function(arg1) -- line 536
    if not manny.is_driving then
        na:come_out_door(na.trapdoor)
    else
        START_CUT_SCENE()
        na:switch_to_set()
        na:current_setup(na_intha)
        bonewagon:put_in_set(na)
        bonewagon:stop_movement_scripts()
        bonewagon:setpos(0.0607441, -2.06767, 0.5)
        bonewagon:setrot(0, 206.292, 0)
        bonewagon:driveto(1.47095, -3.18422, 0.5)
        END_CUT_SCENE()
    end
end
lb.lb_cheat1 = { }
lb.lb_cheat1.use_pnt_x = 7.2045999
lb.lb_cheat1.use_pnt_y = -4.1036401
lb.lb_cheat1.use_pnt_z = -0.50999898
lb.lb_cheat1.use_rot_x = 0
lb.lb_cheat1.use_rot_y = 191.978
lb.lb_cheat1.use_rot_z = 0
lb.lb_cheat1.walkOut = function(arg1) -- line 562
    manny:setpos(lb.lb_cheat2.use_pnt_x, lb.lb_cheat2.use_pnt_y, lb.lb_cheat2.use_pnt_z)
    manny:setrot(lb.lb_cheat2.use_rot_x, lb.lb_cheat2.use_rot_y + 180, lb.lb_cheat2.use_rot_z)
end
lb.lb_cheat2 = { }
lb.lb_cheat2.use_pnt_x = 10.5435
lb.lb_cheat2.use_pnt_y = -8.7032404
lb.lb_cheat2.use_pnt_z = -0.74350899
lb.lb_cheat2.use_rot_x = 0
lb.lb_cheat2.use_rot_y = 97.036102
lb.lb_cheat2.use_rot_z = 0
lb.lb_cheat2.walkOut = function(arg1) -- line 577
    manny:setpos(lb.lb_cheat1.use_pnt_x, lb.lb_cheat1.use_pnt_y, lb.lb_cheat1.use_pnt_z)
    manny:setrot(lb.lb_cheat1.use_rot_x, lb.lb_cheat1.use_rot_y + 180, lb.lb_cheat1.use_rot_z)
end
