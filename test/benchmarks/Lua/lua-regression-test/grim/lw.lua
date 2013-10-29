CheckFirstTime("lw.lua")
lw = Set:create("lw.set", "lsa sewer", { lw_bwnws = 0, lw_ovrhd = 1 })
dofile("bonewagon_gl.lua")
dofile("glottis_bonewagon.lua")
hole_count = 0
hole_table = { }
lw.alligator_roar = function() -- line 18
    local local1
    local1 = pick_one_of({ "lwAlRoar.wav", "lwAlRoar.wav", "alDstGrl.wav", "alRoar1.wav", "alRoar3.wav", "alSnort.wav" })
    start_sfx(local1)
    sleep_for(1000)
end
lw.vivamaro_fix = function() -- line 26
    IrisDown(320, 200, 0)
    lw:switch_to_set()
    salvador:default()
    salvador:put_in_set(lw)
    salvador:follow_boxes()
    salvador:set_walk_rate(0.5)
    salvador:set_walk_chore(sv_in_hq_walk)
    salvador:set_collision_mode(COLLISIONS_OFF)
    salvador:set_visibility(TRUE)
    olivia:default()
    olivia:put_in_set(lw)
    olivia:follow_boxes()
    olivia:set_collision_mode(COLLISIONS_OFF)
    olivia:set_visibility(TRUE)
    salvador:setpos(-1.65021, -1.53545, 0)
    salvador:setrot(0, 168.524, 0)
    olivia:setpos(-1.84472, -1.11754, 0)
    olivia:setrot(0, 170.49, 0)
    IrisUp(320, 200, 1000)
    olivia.head_script = start_script(olivia.head_follow_mesh, olivia, salvador, 6)
    start_script(salvador.walk_and_face, salvador, -1.76454, -2.09958, 0, 0, 98.7965, 0)
    start_script(olivia.walkto, olivia, -2.57605, -3.81668, 0)
    salvador:wait_for_actor()
    start_script(salvador.head_follow_mesh, salvador, olivia, 6)
    sleep_for(2000)
    stop_script(olivia.head_script)
    olivia:head_look_at(nil, 120)
    sleep_for(2000)
    salvador:walkto(-2.57605, -3.81668, 0)
    salvador:wait_for_actor()
    stop_script(salvador.head_follow_mesh)
    salvador:free()
    olivia:free()
    stop_script(sg.glottis_roars)
    glottis:wait_for_message()
    glottis:run_chore(bonewagon_gl_tovrm_lft, "bonewagon_gl.cos")
    glottis:play_chore(bonewagon_gl_squint, "bonewagon_gl.cos")
    sleep_for(2000)
end
lw.shout_hole = function(arg1) -- line 77
    local local1
    soft_script()
    if at.seen_albinizod then
        manny:say_line("/lwma001/")
        manny:wait_for_message()
        if at.pinched_albinizod then
            manny:say_line("/lwma002/")
            manny:wait_for_message()
            lw.alligator_roar()
        else
            manny:say_line("/lwma003/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma004/")
        end
    else
        if hole_table[arg1] then
            local1 = hole_table[arg1]
            PrintDebug("pre-existing hole" .. arg1.name .. "\n")
        else
            hole_count = hole_count + 1
            local1 = hole_count
            hole_table[arg1] = hole_count
            PrintDebug("Assinging " .. tostring(hole_count) .. " to " .. arg1.name .. "\n")
        end
        if local1 == 1 then
            manny:say_line("/lwma005/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma006/")
        elseif local1 == 2 then
            manny:say_line("/lwma007/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma008/")
        elseif local1 == 3 then
            manny:say_line("/lwma009/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma010/")
        elseif local1 == 4 then
            manny:say_line("/lwma011/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma012/")
        elseif local1 == 5 then
            manny:say_line("/rfma029/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma013/")
        elseif local1 == 6 then
            manny:say_line("/lwma014/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma015/")
            manny:wait_for_message()
            lw.alligator_roar()
            manny:say_line("/lwma016/")
        elseif local1 == 7 then
            manny:say_line("/lwma017/")
            manny:wait_for_message()
            lw.alligator_roar()
        else
            manny:say_line("/lwma018/")
            manny:wait_for_message()
            lw.alligator_roar()
        end
    end
end
lw.set_up_actors = function(arg1) -- line 152
    if not bowlsley_in_hiding then
        glottis:set_costume("bonewagon_gl.cos")
        glottis:set_visibility(TRUE)
        glottis:ignore_boxes()
        glottis:set_collision_mode(COLLISIONS_OFF)
        glottis:put_in_set(lw)
        glottis:setpos(-0.830143, -3.34146, 0)
        glottis:setrot(0, -1036.7, 0)
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
        glottis:set_head(3, 4, 4, 165, 35, 80)
        glottis:play_chore(bonewagon_gl_hide_bw, "bonewagon_gl.cos")
        glottis:play_chore(bonewagon_gl_vrm2drv)
        single_start_script(sg.glottis_roars, sg, glottis)
        NewObjectState(lw_bwnws, OBJSTATE_STATE, "lw_bw.bm", "lw_bw.zbm")
        lw.bone_wagon:set_object_state("lw_bw.cos")
        lw.bone_wagon:play_chore(0)
    else
        lw.bone_wagon:make_untouchable()
    end
end
lw.enter = function(arg1) -- line 193
    lw:set_up_actors()
    start_script(sewer_drip)
    SetShadowColor(5, 5, 5)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -2, -0.5, 3.4)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(olivia.hActor, 0)
    SetActorShadowPoint(olivia.hActor, -2, -0.5, 3.4)
    SetActorShadowPlane(olivia.hActor, "shadow1")
    AddShadowPlane(olivia.hActor, "shadow1")
    SetActiveShadow(salvador.hActor, 0)
    SetActorShadowPoint(salvador.hActor, -2, -0.5, 3.4)
    SetActorShadowPlane(salvador.hActor, "shadow1")
    AddShadowPlane(salvador.hActor, "shadow1")
end
lw.exit = function(arg1) -- line 216
    stop_script(sg.glottis_roars)
    glottis:free()
    stop_script(sewer_drip)
    KillActorShadows(manny.hActor)
    KillActorShadows(olivia.hActor)
    KillActorShadows(salvador.hActor)
end
lw.hole = Object:create(lw, "/lwtx019/hole", -0.0230342, -0.178213, 0.37, { range = 0.80000001 })
lw.hole.use_pnt_x = -0.48280901
lw.hole.use_pnt_y = -0.43814
lw.hole.use_pnt_z = 0
lw.hole.use_rot_x = 0
lw.hole.use_rot_y = -72.097397
lw.hole.use_rot_z = 0
lw.hole.use = function(arg1) -- line 239
    start_script(lw.shout_hole, arg1)
end
lw.hole.lookAt = lw.hole.use
lw.bone_wagon = Object:create(lw, "", -1.28654, -2.9547801, 0.49399999, { range = 1.5 })
lw.bone_wagon.use_pnt_x = -1.86954
lw.bone_wagon.use_pnt_y = -2.2897799
lw.bone_wagon.use_pnt_z = 0
lw.bone_wagon.use_rot_x = 0
lw.bone_wagon.use_rot_y = 221.283
lw.bone_wagon.use_rot_z = 0
lw.bone_wagon.lookAt = function(arg1) -- line 255
    manny:say_line("/lbma005/")
end
lw.bone_wagon.use = function(arg1) -- line 259
    system.default_response("not now")
end
lw.sh_door = Object:create(lw, "/lwtx021/door", -1.7446001, -0.74928099, 0.58999997, { range = 0 })
lw.sh_door.use_pnt_x = -2.27809
lw.sh_door.use_pnt_y = -2.52914
lw.sh_door.use_pnt_z = 0
lw.sh_door.use_rot_x = 0
lw.sh_door.use_rot_y = 151.797
lw.sh_door.use_rot_z = 0
lw.sh_door.out_pnt_x = -2.9173701
lw.sh_door.out_pnt_y = -3.4418099
lw.sh_door.out_pnt_z = 0
lw.sh_door.out_rot_x = 0
lw.sh_door.out_rot_y = 158.724
lw.sh_door.out_rot_z = 0
lw.sh_box = lw.sh_door
lw.sh_door:make_untouchable()
lw.sh_door.walkOut = function(arg1) -- line 288
    sh:come_out_door(sh.lw_door)
end
lw.nq_door = Object:create(lw, "/lwtx021/ladder", -1.7446001, -0.74928099, 0.58999997, { range = 0.60000002 })
lw.nq_door.use_pnt_x = -1.6046
lw.nq_door.use_pnt_y = -0.87928098
lw.nq_door.use_pnt_z = 0
lw.nq_door.use_rot_x = 0
lw.nq_door.use_rot_y = -7911.6699
lw.nq_door.use_rot_z = 0
lw.nq_door.out_pnt_x = -1.6205699
lw.nq_door.out_pnt_y = -0.77024299
lw.nq_door.out_pnt_z = 0
lw.nq_door.out_rot_x = 0
lw.nq_door.out_rot_y = -7911.6699
lw.nq_door.out_rot_z = 0
lw.nq_door.lookAt = function(arg1) -- line 309
    manny:say_line("/lwma022/")
end
lw.nq_door.walkOut = function(arg1) -- line 313
    nq:come_out_door(nq.lw_door)
end
