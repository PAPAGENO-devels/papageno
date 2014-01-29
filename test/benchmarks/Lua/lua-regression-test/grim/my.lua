td = { }
td.mug = { parent = Object }
CheckFirstTime("my.lua")
dofile("gl_pass_out.lua")
dofile("meche_w_gl.lua")
my = Set:create("my.set", "mayan workshop", { my_top = 0, my_glofg = 1 })
my.meche_w_glottis_table = Idle:create("meche_w_gl")
idt = my.meche_w_glottis_table
idt:add_state("base", { base = 0.6, soothe_1hand = 0.4 })
idt:add_state("soothe_1hand", { base = 0.6, soothe_1hand = 0.4 })
my.mechanics_turned = FALSE
my.worship_idle_table = Idle:create("mechanic_idles")
idt = my.worship_idle_table
idt:add_state("base", { base = 0.8, to_hold_chin = 0.1, tip_toes = 0.05, scratch_butt = 0.05 })
idt:add_state("to_hold_chin", { hold_chin = 1 })
idt:add_state("hold_chin", { hold_chin = 0.8, chin2base = 0.2 })
idt:add_state("chin2base", { base = 1 })
idt:add_state("tip_toes", { base = 1 })
idt:add_state("scratch_butt", { base = 1 })
my.work_idle_table = Idle:create("mechanic_idles")
idt = my.work_idle_table
idt:add_state("wrench_gond", { wrench_gond = 0.6, twist_wrench = 0.2, inspect_work = 0.1, akimbo = 0.1 })
idt:add_state("twist_wrench", { wrench_gond = 0.5, twist_wrench = 0.3, inspect_work = 0.1, akimbo = 0.1 })
idt:add_state("inspect_work", { wrench_gond = 0.6, twist_wrench = 0.2, inspect_work = 0.1, akimbo = 0.1 })
idt:add_state("akimbo", { wrench_gond = 0.6, twist_wrench = 0.2, inspect_work = 0.1, akimbo = 0.1 })
my.mechanics_work_idles = function(arg1) -- line 85
    local local1 = { "myTool1.WAV", "myTool2.WAV", "myTool3.WAV", "myTool4.WAV", "dd_hms.WAV", "tinker3.WAV" }
    local local2
    while system.currentSet == my do
        if mechanic3:is_choring(mechanic_idles_wrench_gond) then
            local2 = pick_one_of(local1, TRUE)
            start_sfx(local2, IM_MED_PRIORITY, 70)
            set_pan(local2, 30)
            mechanic3:wait_for_chore(mechanic_idles_wrench_gond)
        elseif mechanic3:is_choring(mechanic_idles_twist_wrench) then
            local2 = pick_one_of(local1, TRUE)
            start_sfx(local2, IM_MED_PRIORITY, 70)
            set_pan(local2, 30)
            mechanic3:wait_for_chore(mechanic_idles_twist_wrench)
        end
        break_here()
    end
end
my.mechanics_kill_idles = function(arg1, arg2) -- line 105
    local local1, local2, local3
    if arg2 == 1 then
        local1 = mechanic1
    elseif arg2 == 2 then
        local1 = mechanic2
    elseif arg2 == nil then
        local2 = start_script(my.mechanics_kill_idles, my, 1)
        local3 = start_script(my.mechanics_kill_idles, my, 2)
        while find_script(local2) or find_script(local3) do
            break_here()
        end
    end
    if arg2 ~= nil and local1 ~= nil then
        if local1.worship_idle_script then
            stop_script(local1.worship_idle_script)
        end
        if local1:is_choring(mechanic_idles_to_hold_chin) then
            local1:run_chore(mechanic_idles_chin2base)
        elseif local1:is_choring(mechanic_idles_hold_chin) then
            local1:run_chore(mechanic_idles_chin2base)
        elseif local1:is_choring(mechanic_idles_chin2base) or local1:is_choring(mechanic_idles_tip_toes) or local1:is_choring(mechanic_idles_scratch_butt) then
            local1:wait_for_chore()
        end
        local1:play_chore(mechanic_idles_base)
    end
end
my.mechanics_face_manny = function(arg1, arg2) -- line 137
    if not glottis.fainted and not my.mechanics_turned then
        my:mechanics_kill_idles(arg2)
        if not arg2 then
            mechanic1:stop_chore(mechanic_idles_base)
            mechanic2:stop_chore(mechanic_idles_base)
            mechanic1:play_chore(mechanic_idles_lk_left)
            mechanic2:play_chore(mechanic_idles_to_lk_right)
            mechanic1:wait_for_chore(mechanic_idles_lk_left)
            mechanic2:wait_for_chore(mechanic_idles_to_lk_right)
            mechanic1:play_chore(mechanic_idles_lk_left_hold)
            mechanic2:play_chore(mechanic_idles_lk_right)
        elseif arg2 == 1 then
            mechanic1:stop_chore(mechanic_idles_base)
            mechanic1:play_chore(mechanic_idles_lk_left)
            mechanic1:wait_for_chore(mechanic_idles_lk_left)
            mechanic1:play_chore(mechanic_idles_lk_left_hold)
        elseif arg2 == 2 then
            mechanic2:stop_chore(mehcanic_idles_base)
            mechanic2:play_chore(mechanic_idles_to_lk_right)
            mechanic2:wait_for_chore(mechanic_idles_to_lk_right)
            mechanic2:play_chore(mechanic_idles_lk_right)
        end
        my.mechanics_turned = TRUE
    end
end
my.mechanics_stop_face_manny = function(arg1, arg2) -- line 165
    if find_script(my.mechanics_face_manny) then
        wait_for_script(my.mechanics_face_manny)
    end
    if my.mechanics_turned then
        if not arg2 then
            mechanic1:stop_chore(mechanic_idles_lk_left_hold)
            mechanic1:play_chore(mechanic_idles_lk_left2base)
            mechanic2:stop_chore(mechanic_idles_lk_right)
            mechanic2:play_chore(mechanic_idles_right2base)
            mechanic1:wait_for_chore(mechanic_idles_lk_left2base)
            mechanic2:wait_for_chore(mechanic_idles_right2base)
            mechanic1:play_chore(mechanic_idles_base)
            mechanic2:play_chore(mehcanic_idles_base)
            mechanic1.worship_idle_script = start_script(mechanic1.new_run_idle, mechanic1, "base", my.worship_idle_table, "mechanic_idles.cos")
            mechanic2.worship_idle_script = start_script(mechanic2.new_run_idle, mechanic2, "base", my.worship_idle_table, "mechanic_idles.cos")
        elseif arg2 == 1 then
            mechanic1:stop_chore(mechanic_idles_lk_left_hold)
            mechanic1:play_chore(mechanic_idles_lk_left2base)
            mechanic1:wait_for_chore(mechanic_idles_lk_left2base)
            mechanic1:play_chore(mechanic_idles_base)
            mechanic1.worship_idle_script = start_script(mechanic1.new_run_idle, mechanic1, "base", my.worship_idle_table, "mechanic_idles.cos")
        elseif arg2 == 2 then
            mechanic2:stop_chore(mechanic_idles_lk_right)
            mechanic2:play_chore(mechanic_idles_right2base)
            mechanic2:wait_for_chore(mechanic_idles_right2base)
            mechanic2:play_chore(mehcanic_idles_base)
            mechanic2.worship_idle_script = start_script(mechanic2.new_run_idle, mechanic2, "base", my.worship_idle_table, "mechanic_idles.cos")
        end
        my.mechanics_turned = FALSE
    end
end
my.intro = function(arg1) -- line 199
    start_script(my.mechanics_kill_idles, my)
    my.seen_intro = TRUE
    START_CUT_SCENE()
    manny:set_collision_mode(COLLISION_OFF)
    glottis:set_collision_mode(COLLISION_OFF)
    meche:set_collision_mode(COLLISION_OFF)
    my:cameraman()
    break_here()
    glottis:say_line("/mygl052/", { background = TRUE })
    sleep_for(2000)
    mechanic1:say_line("/mym1050/", { background = TRUE })
    mechanic2:say_line("/mym2051/", { background = TRUE })
    manny:head_look_at(my.glottis_obj)
    glottis:wait_for_message()
    mechanic1:wait_for_message()
    mechanic2:wait_for_message()
    start_script(manny.walkto_object, manny, my.glottis_obj)
    mechanic1:say_line("/mym1050/", { background = TRUE, skip_log = TRUE })
    mechanic2:say_line("/mym2051/", { background = TRUE, skip_log = TRUE })
    mechanic1:wait_for_message()
    mechanic2:wait_for_message()
    wait_for_script(manny.walkto_object)
    manny:say_line("/myma053/")
    manny:wait_for_message()
    mechanic1:say_line("/mym1054/")
    mechanic1:wait_for_message()
    mechanic1:say_line("/mym1055/", { background = TRUE })
    sleep_for(400)
    mechanic2:say_line("/mym2056/", { background = TRUE })
    mechanic2:wait_for_message()
    manny:tilt_head_gesture()
    manny:say_line("/myma057/")
    manny:wait_for_message()
    my:mechanics_face_manny()
    mechanic1:say_line("/mym1058/")
    mechanic1:wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/myma059/")
    manny:wait_for_message()
    mechanic1:say_line("/mym1060/", { background = TRUE })
    sleep_for(200)
    mechanic2:say_line("/mym2061/", { background = TRUE })
    manny:head_look_at(my.mechanic)
    mechanic2:wait_for_message()
    start_script(my.mechanics_stop_face_manny)
    mechanic1:say_line("/mym1062/")
    mechanic1:wait_for_message()
    manny:head_look_at(my.glottis_obj)
    manny:say_line("/myma063/")
    manny.knows_glottis_is_dying = TRUE
    END_CUT_SCENE()
end
my.set_up_actors = function(arg1) -- line 271
    mechanic1:default()
    mechanic1:put_in_set(my)
    mechanic1.saylineTable.x = 400
    mechanic1.saylineTable.y = 90
    if not glottis.fainted then
        mechanic1:setpos(0.868497, 1.14373, 0.8)
        mechanic1:setrot(0, 30, 0)
    else
        mechanic1:setpos(-0.60037, 2.04926, 0.8)
        mechanic1:setrot(0, 350, 0)
    end
    mechanic1:play_chore(mechanic_idles_base)
    mechanic1.worship_idle_script = start_script(mechanic1.new_run_idle, mechanic1, "base", my.worship_idle_table, "mechanic_idles.cos")
    mechanic2:default()
    mechanic2:put_in_set(my)
    mechanic2.saylineTable.x = 300
    mechanic2.saylineTable.y = 60
    if not glottis.fainted then
        mechanic2:setpos(-0.312695, 1.32205, 0.8)
        mechanic2:setrot(0, 300, 0)
    else
        mechanic2:setpos(-0.11137, 2.32426, 0.8)
        mechanic2:setrot(0, 10, 0)
    end
    mechanic2:play_chore(mechanic_idles_base)
    mechanic2.worship_idle_script = start_script(mechanic2.new_run_idle, mechanic2, "base", my.worship_idle_table, "mechanic_idles.cos")
    mechanic3:default()
    mechanic3:put_in_set(my)
    mechanic3:setpos(-1.23306, 1.48797, 0.8)
    mechanic3:setrot(0, 90, 0)
    start_script(mechanic3.new_run_idle, mechanic3, "wrench_gond", my.work_idle_table, "mechanic_idles.cos")
    start_script(my.mechanics_work_idles, my)
    manny:set_collision_mode(COLLISION_OFF)
    glottis:set_collision_mode(COLLISION_OFF)
    meche:set_collision_mode(COLLISION_OFF)
    glottis:default("sailor")
    glottis:put_in_set(my)
    glottis:setpos(0.684882, 1.21894, 0.8267)
    glottis:setrot(0, 199.944, 0)
    glottis:push_costume("gl_pass_out.cos")
    glottis:play_chore(gl_pass_out_passed_out, "gl_pass_out.cos")
    if seen_hell_train then
        meche:set_costume(nil)
        meche:set_costume("meche_w_gl.cos")
        meche:put_in_set(my)
        meche:set_mumble_chore(meche_w_gl_mumble)
        meche:set_talk_chore(1, meche_w_gl_stop_talk)
        meche:set_talk_chore(2, meche_w_gl_a)
        meche:set_talk_chore(3, meche_w_gl_c)
        meche:set_talk_chore(4, meche_w_gl_e)
        meche:set_talk_chore(5, meche_w_gl_f)
        meche:set_talk_chore(6, meche_w_gl_l)
        meche:set_talk_chore(7, meche_w_gl_m)
        meche:set_talk_chore(8, meche_w_gl_o)
        meche:set_talk_chore(9, meche_w_gl_t)
        meche:set_talk_chore(10, meche_w_gl_u)
        meche:ignore_boxes()
        meche:set_collision_mode(COLLISION_OFF)
        meche:setpos(-0.324862, 1.73889, 0.8)
        meche:setrot(0, 228.57, 0)
        meche.w_glottis_idle = start_script(meche.new_run_idle, meche, "base", my.meche_w_glottis_table, "meche_w_gl.cos")
        my.meche_obj:make_touchable()
    else
        my.meche_obj:make_untouchable()
    end
end
my.set_up_mechanic_objects = function(arg1) -- line 348
    if glottis.fainted then
        my.mechanic.use_pnt_x = -0.527928
        my.mechanic.use_pnt_y = 1.47087
        my.mechanic.use_pnt_z = 0.8
        my.mechanic.use_rot_x = 0
        my.mechanic.use_rot_y = 350
        my.mechanic.use_rot_z = 0
        my.mechanic.obj_x = -0.580636
        my.mechanic.obj_y = 2.10709
        my.mechanic.obj_z = 1.091
        my.mechanic2.use_pnt_x = -0.527928
        my.mechanic2.use_pnt_y = 1.47087
        my.mechanic2.use_pnt_z = 0.8
        my.mechanic.use_rot_x = 0
        my.mechanic.use_rot_y = 350
        my.mechanic.use_rot_z = 0
        my.mechanic2.obj_x = -0.134636
        my.mechanic2.obj_y = 2.35909
        my.mechanic2.obj_z = 1.101
    end
    my.mechanic:make_touchable()
    my.mechanic2:make_touchable()
end
my.hide_kitchen = function(arg1) -- line 382
    local local1
    while 1 do
        if manny:find_sector_name("upper_box") then
            local1 = FALSE
        else
            local1 = TRUE
        end
        if local1 ~= my.mk_door.touchable then
            if local1 then
                my.mk_door:make_touchable()
            else
                my.mk_door:make_untouchable()
            end
        end
        break_here()
    end
end
my.enter = function(arg1) -- line 402
    manny:set_collision_mode(COLLISION_OFF)
    glottis:set_collision_mode(COLLISION_OFF)
    meche:set_collision_mode(COLLISION_OFF)
    my:current_setup(my_glofg)
    start_script(my.set_up_actors, my)
    my:add_object_state(my_glofg, "my_blueprints.bm", nil, OBJSTATE_UNDERLAY)
    my.blueprints:set_object_state("my_blueprints.cos")
    if glottis.fainted then
        my.blueprints:make_touchable()
        my.blueprints:play_chore(0)
    else
        my.blueprints:make_untouchable()
    end
    my:set_up_mechanic_objects()
    start_script(my.hide_kitchen, my)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
my.exit = function(arg1) -- line 430
    stop_script(my.mechanics_work_idles)
    stop_script(my.hide_kitchen)
    mechanic1:free()
    mechanic2:free()
    mechanic3:free()
    glottis:free()
    KillActorShadows(manny.hActor)
end
my.gondola = Object:create(my, "/mytx003/gondola", -1.57847, 1.24098, 1.2499, { range = 1 })
my.gondola.use_pnt_x = -0.97988999
my.gondola.use_pnt_y = 0.98924202
my.gondola.use_pnt_z = 0.80000001
my.gondola.use_rot_x = 0
my.gondola.use_rot_y = 86.627098
my.gondola.use_rot_z = 0
my.gondola.lookAt = function(arg1) -- line 456
    if not arg1.seen then
        arg1.seen = TRUE
        START_CUT_SCENE()
        manny:hand_gesture()
        manny:say_line("/myma004/")
        wait_for_message()
        manny:twist_head_gesture()
        manny:say_line("/myma005/")
        END_CUT_SCENE()
    else
        manny:say_line("/myma005/")
    end
end
my.gondola.pickUp = function(arg1) -- line 471
    START_CUT_SCENE()
    manny:twist_head_gesture()
    manny:say_line("/myma006/")
    END_CUT_SCENE()
end
my.gondola.use = function(arg1) -- line 478
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:head_look_at(my.mechanic2)
        manny:setrot(0, 275, 0, TRUE)
        manny:say_line("/myma007/")
        manny:wait_for_message()
        my:mechanics_face_manny()
        mechanic1:say_line("/mym1008/")
        mechanic1:wait_for_message()
        mechanic2:say_line("/mym2009/")
        mechanic2:wait_for_message()
        start_script(my.mechanics_stop_face_manny, my)
        manny:head_look_at(nil)
        END_CUT_SCENE()
    end
end
my.gondola.use_rag = function(arg1) -- line 496
    manny:say_line("/myma010/")
end
my.gondola.use_oily_rag = function(arg1) -- line 500
    manny:say_line("/myma011/")
end
my.glottis_obj = Object:create(my, "/mytx012/Glottis", 0.289318, 1.81618, 1.2539001, { range = 1 })
my.glottis_obj.use_pnt_x = -0.0096349996
my.glottis_obj.use_pnt_y = 1.05509
my.glottis_obj.use_pnt_z = 0.80000001
my.glottis_obj.use_rot_x = 0
my.glottis_obj.use_rot_y = 325.07001
my.glottis_obj.use_rot_z = 0
my.glottis_obj.lookAt = function(arg1) -- line 512
    manny:twist_head_gesture()
    manny:say_line("/myma064/")
end
my.glottis_obj.pickUp = function(arg1) -- line 517
    manny:head_look_at(my.mechanic)
    manny:say_line("/myma014/")
end
my.glottis_obj.use_scythe = function(arg1) -- line 522
    manny:say_line("/myma065/")
end
my.glottis_obj.use_rag = function(arg1) -- line 526
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:head_look_at(my.mechanic)
        manny:say_line("/myma016/")
        manny:wait_for_message()
        start_script(my.mechanics_face_manny, my)
        mechanic1:say_line("/mym1017/")
        mechanic1:wait_for_message()
        mechanic2:say_line("/mym2018/")
        mechanic2:wait_for_message()
        manny:head_look_at(nil)
        manny:say_line("/myma019/")
        start_script(my.mechanics_stop_face_manny, my)
        END_CUT_SCENE()
    end
end
my.glottis_obj.use_mug = function(arg1) -- line 544
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        if glottis.fainted then
            manny:say_line("/myma133/")
        else
            glottis:play_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
            sleep_for(500)
            glottis:say_line("/mygl134/")
            glottis:wait_for_message()
            glottis:wait_for_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
            glottis:play_chore(gl_pass_out_passed_out, "gl_pass_out.cos")
        end
        END_CUT_SCENE()
    end
end
my.glottis_obj.use_oily_rag = function(arg1) -- line 563
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:say_line("/myma020/")
        wait_for_message()
        glottis:play_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
        sleep_for(500)
        glottis:say_line("/mygl021/")
        glottis:wait_for_message()
        glottis:say_line("/mygl022/")
        glottis:wait_for_message()
        glottis:say_line("/mygl023/")
        glottis:wait_for_message()
        glottis:wait_for_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
        glottis:play_chore(gl_pass_out_passed_out, "gl_pass_out.cos")
        END_CUT_SCENE()
    end
end
my.glottis_obj.use_note = function(arg1) -- line 584
    tg.note:scare_response()
end
my.glottis_obj.use = function(arg1) -- line 588
    if manny:walkto_object(arg1) then
        Dialog:run("gl3", "dlg_glot3.lua")
    end
end
my.mechanic = Object:create(my, "/mytx024/mechanic", 0.90907401, 1.2058901, 1.0159, { range = 0.69999999 })
my.mechanic.use_pnt_x = my.glottis_obj.use_pnt_x
my.mechanic.use_pnt_y = my.glottis_obj.use_pnt_y
my.mechanic.use_pnt_z = my.glottis_obj.use_pnt_z
my.mechanic.use_rot_x = 0
my.mechanic.use_rot_y = 259.65302
my.mechanic.use_rot_z = 0
my.mechanic.lookAt = function(arg1) -- line 603
    manny:say_line("/myma025/")
end
my.mechanic.pickUp = function(arg1) -- line 607
    manny:say_line("/myma026/")
end
my.mechanic.use = function(arg1) -- line 611
    if manny:walkto_object(arg1) then
        manny:head_look_at(arg1)
        Dialog:run("mm1", "dlg_mechanics.lua")
    end
end
my.mechanic.use_rag = function(arg1) -- line 618
    my.glottis_obj:use_rag()
end
my.mechanic.use_mug = function(arg1) -- line 622
    if manny:walkto_object(arg1) then
        if glottis.fainted then
            if not my.mechanics.shown_mug then
                my.mechanics.shown_mug = TRUE
                START_CUT_SCENE()
                manny:say_line("/myma066/")
                manny:wait_for_message()
                start_script(my.mechanics_face_manny, my, 1)
                mechanic1:say_line("/mym1067/")
                mechanic1:wait_for_message()
                mechanic2:say_line("/mym2068/")
                start_script(my.mechanics_stop_face_manny, my, 1)
                END_CUT_SCENE()
            else
                START_CUT_SCENE()
                manny:say_line("/myma069/")
                manny:wait_for_message()
                my:mechanics_face_manny()
                mechanic1:say_line("/mym1070/")
                mechanic1:wait_for_message()
                mechanic2:say_line("/mym2071/")
                mechanic2:wait_for_message()
                mechanic1:say_line("/mym1072/")
                mechanic1:wait_for_message()
                start_script(my.mechanics_stop_face_manny, my)
                END_CUT_SCENE()
            end
        else
            mechanic1:say_line("/mym1135/")
        end
    end
end
my.mechanic.use_note = function(arg1) -- line 657
    tg.note:scare_response()
end
my.mechanic.use_oily_rag = function(arg1) -- line 661
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        start_script(my.mechanics_face_manny, my)
        mechanic1:say_line("/mym1027/")
        mechanic1:wait_for_message()
        mechanic2:say_line("/mym2028/")
        start_script(my.mechanics_stop_face_manny, my)
        END_CUT_SCENE()
    end
end
my.mechanic2 = Object:create(my, "/mytx024/mechanic", -0.201547, 1.32197, 1.0571001, { range = 0.69999999 })
my.mechanic2.use_pnt_x = my.glottis_obj.use_pnt_x
my.mechanic2.use_pnt_y = my.glottis_obj.use_pnt_y
my.mechanic2.use_pnt_z = my.glottis_obj.use_pnt_z
my.mechanic2.use_rot_x = 0
my.mechanic2.use_rot_y = 23.421301
my.mechanic2.use_rot_z = 0
my.mechanic2.lookAt = my.mechanic.lookAt
my.mechanic2.pickUp = my.mechanic.pickUp
my.mechanic2.use = my.mechanic.use
my.mechanic2.use_rag = my.mechanic.use_rag
my.mechanic2.use_mug = my.mechanic.use_mug
my.mechanic2.use_note = my.mechanic.use_note
my.mechanic2.use_oily_rag = my.mechanic.use_oily_rag
my.drawers = Object:create(my, "/mytx029/drawers", -1.5660599, 1.20272, 0.25839999, { range = 0.60000002 })
my.drawers.use_pnt_x = -1.73005
my.drawers.use_pnt_y = 1.10267
my.drawers.use_pnt_z = 0
my.drawers.use_rot_x = 0
my.drawers.use_rot_y = 14.4633
my.drawers.use_rot_z = 0
my.drawers.lookAt = function(arg1) -- line 705
    manny:say_line("/myma030/")
end
my.drawers.use = function(arg1) -- line 709
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:play_chore(msb_give, "msb.cos")
        manny:wait_for_chore(msb_give, "msb.cos")
        sleep_for(250)
        start_sfx("gaTools.WAV")
        wait_for_sound("gaTools.WAV")
        sleep_for(250)
        manny:stop_chore(msb_give, "msb.cos")
        manny:play_chore(msb_give_exit, "msb.cos")
        manny:wait_for_chore(msb_give_exit, "msb.cos")
        manny:stop_chore(msb_give_exit, "msb.cos")
        manny:say_line("/myma031/")
        END_CUT_SCENE()
    end
end
my.drawers.use_rag = function(arg1) -- line 727
    manny:say_line("/myma032/")
end
my.drawers.use_oily_rag = function(arg1) -- line 731
    manny:say_line("/myma033/")
end
my.oil_drum = Object:create(my, "/mytx034/oil drum", -1.49058, 0.21397001, 0.20999999, { range = 0.60000002 })
my.oil_drum.use_pnt_x = -1.71724
my.oil_drum.use_pnt_y = 0.0111995
my.oil_drum.use_pnt_z = 0
my.oil_drum.use_rot_x = 0
my.oil_drum.use_rot_y = 328.16699
my.oil_drum.use_rot_z = 0
my.oil_drum.lookAt = function(arg1) -- line 743
    manny:say_line("/myma035/")
end
my.oil_drum.pickUp = function(arg1) -- line 747
    manny:say_line("/myma036/")
end
my.oil_drum.use = function(arg1) -- line 751
    if my.talked_fuel then
        if manny:walkto_object(arg1) then
            START_CUT_SCENE()
            manny:head_look_at(my.mechanic)
            manny:say_line("/myma037/")
            manny:wait_for_message()
            start_script(my.mechanics_face_manny, my, 1)
            mechanic1:say_line("/mym1038/")
            mechanic1wait_for_message()
            mechanic2:say_line("/mym2039/")
            start_script(my.mechanics_stop_face_manny, my, 1)
            END_CUT_SCENE()
        end
    else
        manny:say_line("/myma040/")
    end
end
my.oil_drum.use_rag = function(arg1) -- line 770
    if manny:walkto_object(arg1) then
        mk.rag:free()
        my.oily_rag:get()
        START_CUT_SCENE()
        manny:stop_chore(msb_hold, "msb.cos")
        manny:push_costume("msb_rag_cup.cos")
        manny:play_chore(msb_rag_cup_take_rag, "msb_rag_cup.cos")
        sleep_for(1000)
        start_sfx("myRagDip.WAV")
        manny:wait_for_chore(msb_rag_cup_take_rag, "msb_rag_cup.cos")
        manny:stop_chore(msb_rag_cup_take_rag, "msb_rag_cup.cos")
        manny:play_chore(msb_hold, "msb.cos")
        manny:play_chore(msb_activate_oily_rag, "msb.cos")
        manny:pop_costume()
        manny:say_line("/myma041/")
        END_CUT_SCENE()
        manny.is_holding = my.oily_rag
    end
end
my.oily_rag = Object:create(my, "/mytx042/oily rag", 0, 0, 0, { range = 0 })
my.oily_rag.string_name = "oily_rag"
my.oily_rag.wav = "getrag.wav"
my.oily_rag.lookAt = function(arg1) -- line 796
    manny:say_line("/myma043/")
end
my.oily_rag.use = function(arg1) -- line 800
    START_CUT_SCENE()
    look_at_item_in_hand(TRUE)
    manny:say_line("/myma044/")
    manny:wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
my.oily_rag.default_response = function(arg1) -- line 809
    manny:say_line("/myma045/")
end
my.meche_obj = Object:create(my, "/mytx136/Meche", -0.34484699, 1.68527, 1.2071, { range = 0.60000002 })
my.meche_obj.use_pnt_x = -0.63064498
my.meche_obj.use_pnt_y = 1.54602
my.meche_obj.use_pnt_z = 0.80000001
my.meche_obj.use_rot_x = 0
my.meche_obj.use_rot_y = 291.53601
my.meche_obj.use_rot_z = 0
my.meche_obj.lookAt = function(arg1) -- line 822
    manny:say_line("/myma137/")
end
my.meche_obj.pickUp = function(arg1) -- line 826
    system.default_response("not now")
end
my.meche_obj.use = function(arg1) -- line 830
    START_CUT_SCENE()
    manny:hand_gesture()
    manny:say_line("/myma138/")
    manny:wait_for_message()
    meche:say_line("/mymc139/")
    END_CUT_SCENE()
end
my.meche_obj.use_scythe = function(arg1) -- line 839
    system.default_response("already")
end
my.meche_obj.use_note = function(arg1) -- line 843
    tg.note:scare_response()
end
my.meche_obj.use_rag = function(arg1) -- line 847
    meche:say_line("/mymc140/")
end
my.meche_obj.use_oily_rag = function(arg1) -- line 851
    meche:say_line("/mymc141/")
end
my.blueprints = Object:create(my, "/mytx142/blueprints", -0.230636, 2.5320899, 1.528, { range = 1.5 })
my.blueprints.use_pnt_x = -0.58096302
my.blueprints.use_pnt_y = 1.6
my.blueprints.use_pnt_z = 0.80000001
my.blueprints.use_rot_x = 0
my.blueprints.use_rot_y = 325.14099
my.blueprints.use_rot_z = 0
my.blueprints.lookAt = function(arg1) -- line 864
    manny:say_line("/myma143/")
    manny:wait_for_message()
    manny:say_line("/myma144/")
end
my.blueprints.pickUp = function(arg1) -- line 870
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:hand_gesture()
        manny:say_line("/myma145/")
        manny:wait_for_message()
        mechanic1:say_line("/mym1146/")
        mechanic1:wait_for_message()
        mechanic2:say_line("/mym2147/")
        END_CUT_SCENE()
    end
end
my.blueprints.use = my.blueprints.lookAt
my.mk_door = Object:create(my, "/mytx046/door", -0.75014102, 0.197624, 0.46000001, { range = 0.69999999 })
my.mk_door.use_pnt_x = -0.72014099
my.mk_door.use_pnt_y = -0.112376
my.mk_door.use_pnt_z = 0
my.mk_door.use_rot_x = 0
my.mk_door.use_rot_y = -742.88702
my.mk_door.use_rot_z = 0
my.mk_door.out_pnt_x = -0.67506498
my.mk_door.out_pnt_y = 0.050000001
my.mk_door.out_pnt_z = 0
my.mk_door.out_rot_x = 0
my.mk_door.out_rot_y = -750.41699
my.mk_door.out_rot_z = 0
my.mk_door.walkOut = function(arg1) -- line 904
    mk:come_out_door(mk.my_door)
end
my.mk_door.lookAt = function(arg1) -- line 908
    manny:say_line("/myma047/")
end
my.bs_door = Object:create(my, "/mytx048/outside", 1.9549201, 0.415411, 1.21, { range = 1.3 })
my.bs_door.use_pnt_x = 1.17048
my.bs_door.use_pnt_y = 0.48182699
my.bs_door.use_pnt_z = 0.80000001
my.bs_door.use_rot_x = 0
my.bs_door.use_rot_y = 260.271
my.bs_door.use_rot_z = 0
my.bs_door.out_pnt_x = 1.56278
my.bs_door.out_pnt_y = 0.41471499
my.bs_door.out_pnt_z = 0.80000001
my.bs_door.out_rot_x = 0
my.bs_door.out_rot_y = 260.271
my.bs_door.out_rot_z = 0
my.bs_door.walkOut = function(arg1) -- line 929
    bs:come_out_door(bs.my_door)
end
my.bs_door.lookAt = function(arg1) -- line 933
    manny:say_line("/myma049/")
end
my.bs_door.comeOut = function(arg1) -- line 937
    if not my.seen_intro then
        manny:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
        manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
        start_script(my.intro)
    else
        Object.come_out_door(arg1)
    end
end
