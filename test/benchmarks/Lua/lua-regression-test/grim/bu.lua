CheckFirstTime("bu.lua")
dofile("bu_scoop.lua")
dofile("bu_crushers.lua")
dofile("mn_chisel.lua")
bu = Set:create("bu.set", "upper beach", { bu_crsws = 0, bu_ovrhd = 1 })
bu.figurin_1_spot = { x = 0.747842, y = -21.4594, z = 0.982 }
bu.figurin_2_spot = { x = 1.73384, y = -21.7244, z = 1.091 }
bu.glottis_figurin = function() -- line 19
    glottis:play_chore(glottis_sailor_home_pose, "glottis_sailor.cos")
    while 1 do
        glottis:head_look_at_point(bu.figurin_1_spot)
        sleep_for(random() * 4000 + 1000)
        glottis:head_look_at_point(bu.figurin_2_spot)
        sleep_for(random() * 4000 + 1000)
    end
end
bu.lower_scoop = function() -- line 29
    START_CUT_SCENE()
    ew.crane_actor:play_chore(crane_down)
    sleep_for(1000)
    start_sfx("scoopcrs.wav")
    ew.crane_actor:wait_for_chore(crane_down)
    ew.crane_down = TRUE
    bu.scoop_here = TRUE
    bu:switch_to_set()
    sleep_for(3000)
    END_CUT_SCENE()
end
bu.break_chain = function(arg1) -- line 42
    ew.crane_broken = TRUE
    ew.crane_down = FALSE
    LockSet("bu.set")
    START_CUT_SCENE()
    set_override(bu.skip_break_chain, bu)
    manny:walkto_object(bu.scoop)
    manny:push_costume("mn_chisel.cos")
    manny:stop_chore(mn2_activate_chisel, "mn2.cos")
    manny:run_chore(mn_chisel_prepare_chisel, "mn_chisel.cos")
    manny:stop_chore(mn_chisel_prepare_chisel, "mn_chisel.cos")
    start_sfx("chiselbu.IMU", IM_HIGH_PRIORITY, 127)
    manny:play_chore_looping(mn_chisel_use_chisel, "mn_chisel.cos")
    sleep_for(1000)
    start_sfx("scoop_ch.WAV", IM_HIGH_PRIORITY, 127)
    bu.scoop:play_chore(bu_scoop_snaps_up)
    manny:head_look_at_point(0.191414, -26.7647, 2.118)
    bu.scoop:wait_for_chore(bu_scoop_snaps_up)
    stop_sound("chiselbu.IMU")
    ew:switch_to_set()
    music_state:set_sequence(seqCraneFall)
    RunFullscreenMovie("ew_c.snm")
    wait_for_movie()
    start_sfx("chiselmt.IMU", IM_HIGH_PRIORITY, 127)
    bu:switch_to_set()
    manny:put_in_set(bu)
    manny:put_at_object(bu.scoop)
    bu.scoop:play_chore(bu_scoop_scoop_only)
    SendObjectToFront(bu.scoop_obj)
    manny:set_chore_looping(mn_chisel_use_chisel, FALSE, "mn_chisel.cos")
    manny:wait_for_chore(mn_chisel_use_chisel, "mn_chisel.cos")
    fade_sfx("chiselmt.IMU", 250, 0)
    manny:run_chore(mn_chisel_back_to_hold, "mn_chisel.cos")
    manny:pop_costume()
    manny:play_chore_looping(mn2_activate_chisel, "mn2.cos")
    manny:head_look_at(nil)
    manny:say_line("/buma001/")
    END_CUT_SCENE()
    UnLockSet("bu.set")
end
bu.skip_break_chain = function(arg1) -- line 84
    kill_override()
    bu:switch_to_set()
    manny:put_in_set(bu)
    manny:put_at_object(bu.scoop)
    if manny:get_costume() == "mn_chisel.cos" then
        manny:pop_costume()
    end
    manny:head_look_at(nil)
    manny:play_chore(mn2_hold, "mn2.cos")
    manny:play_chore(mn2_activate_chisel, "mn2.cos")
    stop_sound("chiselmt.IMU")
    UnLockSet("bu.set")
end
bu.thatll_do = function() -- line 101
    START_CUT_SCENE()
    bu.glottis_obj:make_touchable()
    bl.glottis_here = FALSE
    bu.glottis_here = TRUE
    glottis:play_chore(glottis_sailor_home_pose, "glottis_sailor.cos")
    bu:switch_to_set()
    manny:put_in_set(bu)
    manny:set_visibility(TRUE)
    manny:setpos(-0.0418105, -19.8081, 0.74)
    manny:setrot(0, 241.857, 0)
    glottis:default("sailor")
    glottis:put_in_set(bu)
    glottis:setpos(1.18951, -20.867, 0.739999)
    glottis:setrot(0, 160, 0)
    sleep_for(500)
    glottis:say_line("/bugl002/")
    glottis:wait_for_message()
    END_CUT_SCENE()
    if meche_freed then
        stop_sound("cu_cybu.IMU")
        start_script(cut_scene.exodus)
    else
        glottis:say_line("/bugl003/")
        start_script(bu.glottis_figurin)
        wait_for_message()
    end
end
bu.footstep_monitor = function(arg1) -- line 130
    while TRUE do
        if system.currentActor:find_sector_name("ramp_box") then
            system.currentActor.footsteps = footsteps.marble
        else
            system.currentActor.footsteps = footsteps.sand
        end
        break_here()
    end
end
bu.enter = function(arg1) -- line 147
    bu:add_object_state(0, "bu_ocean.bm", nil, OBJSTATE_UNDERLAY)
    bu.edge:set_object_state("bu_ocean.cos")
    bu.edge:play_chore_looping(0)
    if not crusher_free then
        bu:add_object_state(0, "bu_crusher_anim.bm", nil, OBJSTATE_UNDERLAY)
    else
        bu:add_object_state(0, "bu_crushers.bm", "bu_crushers.zbm", OBJSTATE_STATE)
    end
    if ew.crane_broken and ew.crane_down and ew.crane_pos == ew.at_crusher then
        bu:add_object_state(0, "bu_tangle.bm", nil, OBJSTATE_UNDERLAY)
    end
    if bu.scoop_here then
        bu.chain_obj = bu:add_object_state(0, "bu_snapsup.bm", "bu_snapsup.zbm", OBJSTATE_STATE)
        bu.scoop_obj = bu:add_object_state(0, "bu_bucket.bm", "bu_bucket.zbm", OBJSTATE_STATE)
        SendObjectToFront(bu.chain_obj)
    end
    bu.scoop:set_object_state("bu_scoop.cos")
    bu.fallen_crusher:set_object_state("bu_crushers.cos")
    if bu.glottis_here then
        bu.glottis_obj:make_touchable()
    else
        bu.glottis_obj:make_untouchable()
    end
    if bu.scoop_here then
        bu.scoop:make_touchable()
        if not ew.crane_broken then
            bu.scoop:play_chore(bu_scoop_entire_scoop)
        else
            bu.scoop:play_chore(bu_scoop_scoop_only)
        end
        box_off("scoop_box")
    else
        bu.scoop:play_chore(bu_scoop_scoop_gone)
        bu.scoop:make_untouchable()
        box_on("scoop_box")
    end
    if crusher_free then
        bu.fallen_crusher:make_touchable()
        bu.fallen_crusher:play_chore(bu_crushers_broken)
        box_off("crusher_box")
    else
        if ew.crane_pos == ew.at_crusher and ew.crane_broken and ew.crane_down then
            bu.fallen_crusher:play_chore(bu_crushers_tangled)
        else
            bu.fallen_crusher:play_chore_looping(bu_crushers_spin)
            start_sfx("cu_cybu.IMU", IM_HIGH_PRIORITY, 80)
        end
        box_on("crusher_box")
    end
    if bu.glottis_here then
        glottis:default("sailor")
        glottis:put_in_set(bu)
        glottis:setpos(1.18951, -20.867, 0.739999)
        glottis:setrot(0, 160, 0)
        glottis:play_chore(glottis_sailor_home_pose, "glottis_sailor.cos")
        start_script(bu.glottis_figurin)
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 100)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 0, 0, 100)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
    start_script(bu.footstep_monitor)
end
bu.exit = function(arg1) -- line 227
    stop_script(bu.footstep_monitor)
    stop_script(bu.glottis_figurin)
    stop_sound("chiselmt.IMU")
    stop_sound("chiselbu.IMU")
    stop_sound("cu_cybu.IMU")
    glottis:free()
    bu.fallen_crusher:stop_chore(bu_crushers_spin)
    KillActorShadows(manny.hActor)
end
bu.fallen_crusher = Object:create(bu, "/butx004/coral crusher", 1.08074, -21.811501, 1.104, { range = 2 })
bu.fallen_crusher.use_pnt_x = -0.0131819
bu.fallen_crusher.use_pnt_y = -20.1103
bu.fallen_crusher.use_pnt_z = 0.74000001
bu.fallen_crusher.use_rot_x = 0
bu.fallen_crusher.use_rot_y = 214.37601
bu.fallen_crusher.use_rot_z = 0
bu.fallen_crusher.touchable = FALSE
bu.fallen_crusher.lookAt = function(arg1) -- line 256
    if bu.glottis_here then
        manny:say_line("/buma005/")
    else
        manny:say_line("/buma006/")
    end
end
bu.fallen_crusher.pickUp = function(arg1) -- line 264
    system.default_response("hernia")
end
bu.fallen_crusher.use = function(arg1) -- line 268
    if bu.glottis_here then
        manny:say_line("/buma007/")
    else
        manny:say_line("/buma008/")
    end
end
bu.fallen_crusher.use_chisel = function(arg1) -- line 276
    manny:say_line("/buma009/")
end
bu.glottis_obj = Object:create(bu, "/butx010/Glottis", 1.09553, -20.609301, 1.6544, { range = 1.6 })
bu.glottis_obj.use_pnt_x = -0.0131819
bu.glottis_obj.use_pnt_y = -20.1103
bu.glottis_obj.use_pnt_z = 0.74000001
bu.glottis_obj.use_rot_x = 0
bu.glottis_obj.use_rot_y = 214.37601
bu.glottis_obj.use_rot_z = 0
bu.glottis_obj.touchable = FALSE
bu.glottis_obj.lookAt = function(arg1) -- line 291
    manny:say_line("/buma011/")
end
bu.glottis_obj.use = function(arg1) -- line 295
    soft_script()
    manny:say_line("/buma012/")
    wait_for_message()
    arg1:lookAt()
end
bu.glottis_obj.pickUp = bu.glottis_obj.use
bu.scoop = Object:create(bu, "/butx013/scoop", 0.57289398, -28.5487, 1.15, { range = 1 })
bu.scoop.use_pnt_x = 0.257514
bu.scoop.use_pnt_y = -27.9783
bu.scoop.use_pnt_z = 0.74000001
bu.scoop.use_rot_x = 0
bu.scoop.use_rot_y = 238.513
bu.scoop.use_rot_z = 0
bu.scoop.touchable = FALSE
bu.scoop.lookAt = function(arg1) -- line 315
    manny:say_line("/buma014/")
end
bu.scoop.use = function(arg1) -- line 319
    manny:say_line("/buma015/")
end
bu.scoop.pickUp = bu.scoop.use
bu.scoop.use_chisel = function(arg1) -- line 325
    if ew.crane_broken then
        manny:say_line("/buma016/")
    else
        start_script(bu.break_chain)
    end
end
bu.edge = Object:create(bu, "/butx017/Edge of the World", -15.0152, -12.9614, 2.03, { range = 14.5 })
bu.edge.use_pnt_x = -3.0652399
bu.edge.use_pnt_y = -22.6014
bu.edge.use_pnt_z = 0.74000102
bu.edge.use_rot_x = 0
bu.edge.use_rot_y = -291.95999
bu.edge.use_rot_z = 0
bu.edge.lookAt = function(arg1) -- line 342
    manny:say_line("/buma018/")
end
bu.edge.pickUp = function(arg1) -- line 346
    manny:say_line("/buma019/")
end
bu.edge.use = function(arg1) -- line 350
    soft_script()
    if gh.been_there then
        manny:say_line("/buma020/")
        if raised_lamancha then
            wait_for_message()
            manny:say_line("/buma021/")
        end
    else
        manny:say_line("/buma022/")
    end
end
bu.cu_door1 = Object:create(bu, "/butx023/ramp", -1.28095, -10.6155, 3.6182301, { range = 0.60000002 })
bu.cu_door1.use_pnt_x = -1.28095
bu.cu_door1.use_pnt_y = -10.6155
bu.cu_door1.use_pnt_z = 3.6182301
bu.cu_door1.use_rot_x = 0
bu.cu_door1.use_rot_y = 12.4888
bu.cu_door1.use_rot_z = 0
bu.cu_box1 = bu.cu_door1
bu.cu_door1.walkOut = function(arg1) -- line 377
    cu:come_out_door(cu.bu_door1)
end
bu.cu_door2 = Object:create(bu, "/butx024/ramp", 0.965415, -10.7594, 3.55654, { range = 0.60000002 })
bu.cu_door2.use_pnt_x = 0.965415
bu.cu_door2.use_pnt_y = -10.7594
bu.cu_door2.use_pnt_z = 3.55654
bu.cu_door2.use_rot_x = 0
bu.cu_door2.use_rot_y = -1.0762399
bu.cu_door2.use_rot_z = 0
bu.cu_box2 = bu.cu_door2
bu.cu_door2.walkOut = function(arg1) -- line 392
    cu:come_out_door(cu.bu_door2)
end
bu.bl_door = Object:create(bu, "/butx025/beach", 2.33357, -27.1721, 1.15, { range = 0.60000002 })
bu.bl_door.use_pnt_x = 1.85357
bu.bl_door.use_pnt_y = -27.1721
bu.bl_door.use_pnt_z = 0.74000001
bu.bl_door.use_rot_x = 0
bu.bl_door.use_rot_y = -138.97301
bu.bl_door.use_rot_z = 0
bu.bl_door.out_pnt_x = 1.85357
bu.bl_door.out_pnt_y = -27.1721
bu.bl_door.out_pnt_z = 0.74000001
bu.bl_door.out_rot_x = 0
bu.bl_door.out_rot_y = -138.97301
bu.bl_door.out_rot_z = 0
bu.bl_box1 = bu.bl_door
bu.bl_box2 = bu.bl_door
bu.bl_door.lookAt = function(arg1) -- line 415
    manny:say_line("/buma026/")
end
bu.bl_door.walkOut = function(arg1) -- line 419
    bl:come_out_door(bl.bu_door)
end
