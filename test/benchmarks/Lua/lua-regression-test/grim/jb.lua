CheckFirstTime("jb.lua")
jb = Set:create("jb.set", "Bone Wagon Garage", { jb_garin = 0, jb_ovrhd = 1 })
dofile("msb_shooter.lua")
dofile("gl_shooter.lua")
jb.poured = FALSE
jb.frozen = FALSE
jb.glottis_nauseated_reminder = function(arg1) -- line 19
    while 1 do
        sleep_for(rndint(6000, 16000))
        start_sfx("glNausea.wav", IM_LOW_PRIORITY, 90)
        break_here()
    end
end
jb.rotate_glottis = function() -- line 29
    local local1 = { }
    glottis:stop_chore(glottis_flip_ears, "glottis.cos")
    glottis:play_chore_looping(gl_fastwalk_swivel_left, "gl_fastwalk.cos")
    repeat
        local1 = glottis:getrot()
        local1.y = local1.y + PerSecond(50)
        if local1.y > 180 then
            local1.y = 180
        end
        glottis:setrot(local1)
        break_here()
    until local1.y == 180
    glottis:stop_chore(gl_fastwalk_swivel_left, "gl_fastwalk.cos")
    glottis:head_look_at_manny()
    glottis:fade_in_chore(glottis_home_pose, "glottis.cos", 500)
end
jb.dose_glottis = function() -- line 48
    local local1
    meche:set_collision_mode(COLLISION_OFF)
    START_CUT_SCENE()
    stop_script(xb.glottis_look_meche)
    if system.currentSet == jb then
        xb:switch_to_set()
        manny:put_in_set(xb)
        glottis:setrot(0, 180, 0)
        manny:setpos(28.775101, -14.0599, 1)
        manny:setrot(0, 358.76279, 0)
    else
        local1 = start_script(jb.rotate_glottis)
        manny:walkto(28.775101, -14.0599, 1, 0, 358.76279, 0)
        manny:wait_for_actor()
        wait_for_script(local1)
        glottis:head_look_at_manny()
    end
    glottis:say_line("/jbgl001/")
    wait_for_message()
    if lm.bottle.full then
        glottis:fade_out_chore(glottis_home_pose, "glottis.cos", 500)
        manny:stop_chore(msb_activate_bottle, "msb.cos")
        manny:stop_chore(msb_hold, "msb.cos")
        manny:push_costume("msb_shooter.cos")
        glottis:pop_costume()
        glottis:push_costume("gl_shooter.cos")
        glottis.nauseated = TRUE
        manny:say_line("/jbma002/")
        wait_for_message()
        glottis:head_look_at(nil)
        glottis:stop_chore(glottis_home_pose, "glottis.cos")
        manny:play_chore(msb_shooter_give_bottle)
        glottis:push_chore(gl_shooter_get_bottle)
        glottis:push_chore()
        manny:say_line("/jbma003/")
        wait_for_message()
        manny:say_line("/jbma004/")
        wait_for_message()
        lm.bottle:put_in_limbo()
        glottis:play_chore(gl_shooter_drink)
        glottis:say_line("/jbgl005/")
        wait_for_message()
        glottis:wait_for_chore()
        glottis:push_chore(gl_shooter_give_back)
        glottis:push_chore()
        glottis:push_chore(gl_shooter_wait)
        glottis:push_chore()
        manny:stop_chore(msb_shooter_give_bottle)
        manny:play_chore(msb_shooter_get_bottle, "msb_shooter.cos")
        manny:print_costumes()
        manny:push_chore()
        manny:push_chore(msb_shooter_wait)
        manny:push_chore()
        glottis:say_line("/jbgl007/")
        wait_for_message()
        glottis:say_line("/jbgl008/")
        wait_for_message()
        glottis:say_line("/jbgl009/")
        wait_for_message()
        glottis:say_line("/jbgl010/")
        wait_for_message()
        glottis:say_line("/jbgl011/")
        xb:current_setup(xb_newcu)
        glottis:play_chore(gl_shooter_grab)
        manny:play_chore(msb_shooter_grabbed)
        glottis:wait_for_chore()
        glottis:stop_chore(gl_shooter_grab)
        manny:stop_chore(msb_shooter_grabbed)
        glottis:play_chore_looping(gl_shooter_shake)
        start_sfx("glShake.imu")
        manny:play_chore_looping(msb_shooter_shaken)
        wait_for_message()
        manny:say_line("/jbma012/")
        wait_for_message()
        glottis:set_chore_looping(gl_shooter_shake, FALSE)
        manny:set_chore_looping(msb_shooter_shaken, FALSE)
        glottis:wait_for_chore()
        glottis:stop_chore(gl_shooter_shake)
        manny:stop_chore(msb_shooter_shaken)
        stop_sound("glShake.imu")
        system:lock_display()
        glottis:complete_chore(gl_shooter_lookup)
        glottis:wait_for_chore()
        system:unlock_display()
        xb:current_setup(xb_docws)
        manny:ignore_boxes()
        manny:setpos(28.7237, -13.925, 1.1018)
        manny:play_chore(msb_shooter_putdown)
        break_here()
        sleep_for(220)
        break_here()
        music_state:set_sequence(seqLumbagoLemo)
        glottis:play_chore(gl_shooter_prep_run)
        manny:wait_for_chore()
        glottis:wait_for_chore()
        manny:stop_chore(msb_shooter_putdown)
        glottis:stop_chore(gl_shooter_prep_run)
        manny:setpos(27.902641, -13.554483, 1)
        manny:setrot(0, 270, 0)
        manny:follow_boxes()
        manny:pop_costume()
        glottis:say_line("/jbgl013/")
        glottis:wait_for_chore()
        glottis:play_chore(gl_shooter_run_out)
        glottis:wait_for_chore(gl_shooter_run_out)
        glottis:set_visibility(FALSE)
        glottis:pop_costume()
        wait_for_message()
        meche:set_collision_mode(COLLISION_SPHERE)
        manny:head_look_at(meche)
        meche:say_line("/jbmc015/")
        wait_for_message()
        manny:say_line("/jbma016/")
        wait_for_message()
        IrisDown(355, 245, 1000)
        manny.is_holding = nil
        lm.bottle:free()
        manny:stop_chore(msb_hold, "msb.cos")
        glottis:pop_costume()
        sleep_for(1500)
        glottis:set_visibility(TRUE)
        glottis:play_chore_looping(glottis_flip_ears, "glottis.cos")
        IrisUp(215, 280, 1000)
        start_sfx("glNausea.wav")
        glottis:say_line("/jbgl017/")
        wait_for_message()
        glottis:say_line("/jbgl018/")
        wait_for_message()
        meche:say_line("/jbmc019/")
        xb.glottis_obj.obj_x = 28.8643
        xb.glottis_obj.obj_y = -13.7211
        xb.glottis_obj.obj_z = 1.8377399
        xb.glottis_obj.interest_actor:setpos({ x = 28.8643, y = -13.7211, z = 1.8377399 })
        xb.glottis_obj:make_touchable()
        xb.glottis_obj.interest_actor:put_in_set(xb)
        glottis:pop_costume()
        start_script(jb.glottis_nauseated_reminder)
    else
        manny:say_line("/jbma020/")
        wait_for_message()
        glottis:say_line("/jbgl021/")
    end
    END_CUT_SCENE()
end
jb.see_trap = function() -- line 229
    START_CUT_SCENE()
    manny:say_line("/jbma022/")
    wait_for_message()
    glottis:say_line("/jbgl023/")
    wait_for_message()
    sleep_for(1000)
    manny:head_look_at(jb.glottis_obj)
    sleep_for(500)
    glottis:say_line("/jbgl024/")
    wait_for_message()
    manny:head_look_at(nil)
    manny:twist_head_gesture()
    END_CUT_SCENE()
end
jb.set_up_actors = function(arg1) -- line 245
    glottis:default()
    glottis:put_in_set(jb)
    glottis:setpos(0.785915, -2.64663, 0.1)
    glottis:setrot(0, 377.007, 0)
    glottis:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(glottis.hActor, 0.5)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(chepito.hActor, 0.45)
    SetActorCollisionScale(manny.hActor, 0.35)
    glottis:head_look_at(nil)
end
jb.enter = function(arg1) -- line 265
    NewObjectState(jb_garin, OBJSTATE_UNDERLAY, "jb_jello.bm")
    jb.bone_wagon:set_object_state("jb_jello.cos")
    if jb.frozen then
        jb.bone_wagon:play_chore(2)
        box_off("dominos")
        box_on("stop_box")
    else
        if jb.poured then
            jb.bone_wagon:play_chore(1)
        else
            jb.bone_wagon:play_chore(0)
        end
        box_off("stop_box")
    end
    if jb.poured and not jb.frozen then
        manny.footsteps = footsteps.jello
    end
    if glottis.nauseated and not jb.poured then
        start_script(jb.glottis_nauseated_reminder)
    end
    jb:set_up_actors()
end
jb.exit = function(arg1) -- line 298
    stop_script(jb.glottis_nauseated_reminder)
    glottis:free()
end
jb.bone_wagon = Object:create(jb, "/jbtx025/Bone Wagon", 0.47191101, 2.2590899, 1.036, { range = 1.5 })
jb.bone_wagon.use_pnt_x = 0.653099
jb.bone_wagon.use_pnt_y = 0.39972201
jb.bone_wagon.use_pnt_z = 0
jb.bone_wagon.use_rot_x = 0
jb.bone_wagon.use_rot_y = 18.1998
jb.bone_wagon.use_rot_z = 0
jb.bone_wagon.lookAt = function(arg1) -- line 316
    soft_script()
    manny:say_line("/jbma026/")
    wait_for_message()
    glottis:say_line("/jbgl027/")
    wait_for_message()
    glottis:say_line("/jbgl028/")
end
jb.bone_wagon.pickUp = function(arg1) -- line 325
    manny:say_line("/jbma029/")
end
jb.bone_wagon.use = function(arg1) -- line 329
    if jb.frozen then
        manny:say_line("/jbma030/")
    elseif jb.poured then
        manny:say_line("/jbma031/")
    else
        manny:say_line("/jbma032/")
    end
end
jb.glottis_obj = Object:create(jb, "/jbtx033/Glottis", 0.86613202, -1.86167, 0.94, { range = 1.2 })
jb.glottis_obj.use_pnt_x = 0.56613201
jb.glottis_obj.use_pnt_y = -1.62167
jb.glottis_obj.use_pnt_z = 0.1
jb.glottis_obj.use_rot_x = 0
jb.glottis_obj.use_rot_y = -494.08899
jb.glottis_obj.use_rot_z = 0
jb.glottis_obj.lookAt = function(arg1) -- line 349
    if glottis.nauseated then
        if jb.poured then
            soft_script()
            manny:say_line("/jbma034/")
            wait_for_message()
            glottis:say_line("/jbgl035/")
        else
            manny:say_line("/jbma036/")
        end
    else
        manny:say_line("/jbma037/")
    end
end
jb.glottis_obj.pickUp = function(arg1) -- line 364
    system.default_response("not now")
end
jb.glottis_obj.use = function(arg1) -- line 368
    if jb.poured then
        if jb.frozen then
            manny:say_line("/jbma038/")
        else
            manny:say_line("/jbma039/")
            wait_for_message()
            glottis:say_line("/jbgl040/")
        end
    elseif glottis.nauseated then
        if system.currentSet == jb then
            xb:come_out_door(xb.jb_door)
        end
        jb.poured = TRUE
        stop_script(jb.glottis_nauseated_reminder)
        stop_script(xb.glottis_look_meche)
        START_CUT_SCENE()
        meche:set_collision_mode(COLLISION_OFF)
        manny:walkto(28.978, -14.1141, 0.999412, 0, -3.28925, 0)
        manny:say_line("/jbma041/")
        wait_for_message()
        music_state:set_state(stateKS)
        glottis:stop_chore(glottis_flip_ears, "glottis.cos")
        glottis:push_costume("gl_puke.cos")
        glottis:play_chore(0)
        glottis:say_line("/jbgl045/")
        glottis:wait_for_message()
        start_sfx("glPuke3.wav")
        glottis:wait_for_chore()
        start_sfx("glPuke4.wav")
        xb:current_setup(xb_newcu)
        start_sfx("glPuke2.wav")
        glottis:setrot(0, 90, 0)
        glottis:play_chore(1)
        wait_for_message()
        glottis:say_line("/jbgl042/")
        start_sfx("glPuke1.wav")
        wait_for_message()
        xb.jello:play_chore(0)
        glottis:say_line("/jbgl043/")
        start_sfx("glPuke3.wav")
        wait_for_message()
        start_sfx("glPuke1.wav")
        wait_for_sound("glPuke1.wav")
        glottis:say_line("/jbgl044/")
        start_sfx("glPuke2.wav")
        wait_for_message()
        glottis:wait_for_chore()
        xb:current_setup(xb_docws)
        glottis:setrot(0, 90, 0)
        glottis:setrot(0, 90, 0)
        xb.glottis_obj.obj_x = 28.029
        xb.glottis_obj.obj_y = -13.0451
        xb.glottis_obj.obj_z = 1.66
        xb.glottis_obj.interest_actor:setpos(28.029, -13.0451, 1.66)
        glottis:pop_costume()
        glottis:play_chore_looping(glottis_flip_ears, "glottis.cos")
        wait_for_message()
        manny:say_line("/jbma048/")
        glottis:head_look_at_manny()
        wait_for_message()
        glottis:say_line("/jbgl049/")
        glottis:wait_for_message()
        music_state:set_sequence(seqBreathMint)
        music_state:update()
        glottis:head_look_at(nil)
        meche:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(meche.hActor, 0.35)
        END_CUT_SCENE()
    else
        manny:say_line("/jbma050/")
        wait_for_message()
        glottis:say_line("/jbgl051/")
    end
end
jb.glottis_obj.use_bottle = function(arg1) -- line 447
    start_script(jb.dose_glottis)
end
jb.glottis_obj.use_note = function(arg1) -- line 451
    tg.note:scare_response()
end
jb.glottis_obj.use_nitro = function(arg1) -- line 455
    manny:say_line("/jbma052/")
end
jb.domino_ramp = Object:create(jb, "/jbtx053/dominos", 0.745911, 2.47809, 0.296, { range = 0.5 })
jb.domino_ramp.use_pnt_x = 0.98916101
jb.domino_ramp.use_pnt_y = 2.67907
jb.domino_ramp.use_pnt_z = 0
jb.domino_ramp.use_rot_x = 0
jb.domino_ramp.use_rot_y = 126.727
jb.domino_ramp.use_rot_z = 0
jb.domino_ramp.lookAt = function(arg1) -- line 468
    manny:say_line("/jbma054/")
end
jb.domino_ramp.pickUp = function(arg1) -- line 472
    manny:say_line("/jbma055/")
end
jb.domino_ramp.use = jb.domino_ramp.pickUp
jb.domino_trigger = Object:create(jb, "", 0, 0, 0, { range = 0 })
jb.domino_trigger.walkOut = function(arg1) -- line 479
    if jb.poured then
        jb.bone_wagon:use()
    else
        manny:say_line("/jbma065/")
    end
end
jb.dominos = Object:create(jb, "/jbtx056/dominos", 1.04419, 0.349545, -0.0099999905, { range = 1.9 })
jb.dominos.use_pnt_x = 0.80419397
jb.dominos.use_pnt_y = -1.20046
jb.dominos.use_pnt_z = 0.1
jb.dominos.use_rot_x = 0
jb.dominos.use_rot_y = 10.9633
jb.dominos.use_rot_z = 0
jb.dominos.lookAt = function(arg1) -- line 496
    if jb.poured then
        if jb.frozen then
            manny:say_line("/jbma057/")
            wait_for_message()
            manny:say_line("/jbma058/")
            wait_for_message()
            glottis:say_line("/jbgl059/")
        else
            manny:say_line("/jbma060/")
            wait_for_message()
            glottis:say_line("/jbgl061/")
            wait_for_message()
            glottis:say_line("/jbgl062/")
        end
    else
        manny:say_line("/jbma063/")
    end
end
jb.dominos.pickUp = function(arg1) -- line 516
    manny:say_line("/jbma064/")
end
jb.dominos.use = function(arg1) -- line 521
    if jb.poured then
        if jb.frozen then
            manny:say_line("/jbma066/")
        else
            manny:say_line("/jbma067/")
        end
    else
        arg1:walkOut()
    end
end
jb.dominos.use_nitro = function(arg1) -- line 533
    if jb.poured then
        START_CUT_SCENE()
        jb.frozen = TRUE
        cur_puzzle_state[49] = TRUE
        box_off("domino_trigger")
        box_on("stop_box")
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:push_costume("msb_pour_nitro.cos")
        manny:play_chore(0)
        manny:wait_for_chore()
        manny:play_chore(1)
        sleep_for(500)
        jb.bone_wagon:play_chore(0)
        start_sfx("jbNitPor.wav")
        StartMovie("jb.snm", nil, 0, 240)
        wait_for_movie()
        jb.bone_wagon:play_chore(2)
        manny:wait_for_chore()
        manny:play_chore(2)
        manny:wait_for_chore()
        manny:pop_costume()
        put_away_held_item()
        glottis:say_line("/jbgl068/")
        wait_for_message()
        glottis:say_line("/jbgl069/")
        wait_for_message()
        manny:say_line("/jbma070/")
        END_CUT_SCENE()
    else
        manny:say_line("/jbma071/")
    end
end
jb.plunger = Object:create(jb, "/jbtx072/plunger", 0.35891101, 2.5240901, -0.90399998, { range = 0.60000002 })
jb.plunger.use_pnt_x = 0.379758
jb.plunger.use_pnt_y = 2.6993799
jb.plunger.use_pnt_z = 0
jb.plunger.use_rot_x = 0
jb.plunger.use_rot_y = 170.683
jb.plunger.use_rot_z = 0
jb.plunger.lookAt = function(arg1) -- line 578
    manny:say_line("/jbma073/")
end
jb.plunger.pickUp = function(arg1) -- line 582
    jb.domino_ramp:pickUp()
end
jb.plunger.use = function(arg1) -- line 586
    manny:say_line("/jbma074/")
    wait_for_message()
    manny:say_line("/jbma075/")
end
jb.dynamite = Object:create(jb, "/jbtx076/dynamite", -0.079089001, 2.5630901, 0.38, { range = 0.80000001 })
jb.dynamite.use_pnt_x = 0.045685198
jb.dynamite.use_pnt_y = 2.71242
jb.dynamite.use_pnt_z = 0
jb.dynamite.use_rot_x = 0
jb.dynamite.use_rot_y = 166.71201
jb.dynamite.use_rot_z = 0
jb.dynamite.lookAt = function(arg1) -- line 600
    manny:say_line("/jbma077/")
end
jb.dynamite.pickUp = function(arg1) -- line 604
    START_CUT_SCENE()
    manny:walkto(0.292617, 2.89696, 0.05, 0, 139.748, 0)
    manny:say_line("/jbma078/")
    music_state:set_sequence(seqJelloSuspense)
    wait_for_message()
    manny:play_chore(msb_reach_low, "msb.cos")
    sleep_for(500)
    start_sfx("jbDefuse.wav")
    sleep_for(500)
    start_script(cut_scene.vivamaro, cut_scene)
    END_CUT_SCENE()
end
jb.dynamite.use = jb.dynamite.pickUp
jb.xb_door = Object:create(jb, "/jbtx079/door", 0.25442499, -1.8533, 0.50999999, { range = 0.89999998 })
jb.xb_door.use_pnt_x = 0.66442502
jb.xb_door.use_pnt_y = -1.5033
jb.xb_door.use_pnt_z = 0.1
jb.xb_door.use_rot_x = 0
jb.xb_door.use_rot_y = -200.77901
jb.xb_door.use_rot_z = 0
jb.xb_door.out_pnt_x = 0.20763899
jb.xb_door.out_pnt_y = -1.8844
jb.xb_door.out_pnt_z = 0.1
jb.xb_door.out_rot_x = 0
jb.xb_door.out_rot_y = -231.24699
jb.xb_door.out_rot_z = 0
jb.xb_door:make_untouchable()
jb.xb_door.walkOut = function(arg1) -- line 642
    xb:come_out_door(xb.jb_door)
end
jb.xb_door.lookAt = function(arg1) -- line 646
    manny:say_line("/jbma080/")
end
