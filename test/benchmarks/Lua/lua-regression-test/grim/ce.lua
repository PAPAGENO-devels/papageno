CheckFirstTime("ce.lua")
ce = Set:create("ce.set", "cafe ext", { ce_estla = 0, ce_estla1 = 0, ce_lotws = 1, ce_front = 2, ce_ovrhd = 3 })
ce.enter = function(arg1) -- line 18
    start_script(foghorn_sfx)
    ce:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    if meche.shanghaid then
        MakeSectorActive("raven_trigger", FALSE)
    end
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.34999999)
    local local1 = 0
    repeat
        local1 = local1 + 1
        if not table_actor[local1] then
            table_actor[local1] = Actor:create(nil, nil, nil, "table" .. local1)
        end
        table_actor[local1]:set_costume("x_spot.cos")
        table_actor[local1]:set_visibility(FALSE)
        table_actor[local1]:put_in_set(ce)
        table_actor[local1]:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(table_actor[local1].hActor, 0.1)
        if local1 == 1 then
            table_actor[local1]:setpos(2.3396201, -1.32845, -0.296)
        elseif local1 == 2 then
            table_actor[local1]:setpos(0.88068402, -1.32845, -0.296)
        end
    until local1 == 2
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 7.9204898, -3.27824, -0.2)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 1.2893, 2.8678, 10.28996)
    SetActorShadowPlane(manny.hActor, "shadow10")
    AddShadowPlane(manny.hActor, "shadow10")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 1.2893, 2.8678, 10.28996)
    SetActorShadowPlane(manny.hActor, "shadow11")
    AddShadowPlane(manny.hActor, "shadow11")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, -4.5999999, -2.8, -1.28996)
    SetActorShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow20")
    SetActiveShadow(manny.hActor, 4)
    SetActorShadowPoint(manny.hActor, 0, 0, 11.28996)
    SetActorShadowPlane(manny.hActor, "shadow30")
    AddShadowPlane(manny.hActor, "shadow30")
end
ce.exit = function(arg1) -- line 76
    local local1 = 0
    stop_script(foghorn_sfx)
    repeat
        local1 = local1 + 1
        table_actor[local1]:free()
    until local1 == 2
    manny:set_collision_mode(COLLISION_OFF)
    KillActorShadows(manny.hActor)
end
ce.raven_trigger = { }
ce.raven_trigger.walkOut = function(arg1) -- line 95
    if not meche.shanghaid then
        meche.shanghaid = TRUE
        box_off("raven_trigger")
        start_script(cut_scene.shanghai, cut_scene)
    end
end
ce.cc_door = Object:create(ce, "/cetx001/door", -1.42501, 0.0311844, 0.40000001, { range = 0.60000002 })
ce.cc_door.use_pnt_x = -1.51636
ce.cc_door.use_pnt_y = -0.46752101
ce.cc_door.use_pnt_z = -0.16
ce.cc_door.use_rot_x = 0
ce.cc_door.use_rot_y = -13.4927
ce.cc_door.use_rot_z = 0
ce.cc_door.out_pnt_x = -1.41036
ce.cc_door.out_pnt_y = -0.025
ce.cc_door.out_pnt_z = -0.16
ce.cc_door.out_rot_x = 0
ce.cc_door.out_rot_y = -13.4927
ce.cc_door.out_rot_z = 0
ce.cc_box = ce.cc_door
ce.cc_door.walkOut = function(arg1) -- line 124
    cc:come_out_door(cc.ce_door)
end
ce.ev_door = Object:create(ce, "/cetx002/door", -4.6819, -2.3219299, -3.0999999, { range = 0.60000002 })
ce.ev_door.use_pnt_x = -4.6613698
ce.ev_door.use_pnt_y = -2.60021
ce.ev_door.use_pnt_z = -3.3989999
ce.ev_door.use_rot_x = 0
ce.ev_door.use_rot_y = -699.302
ce.ev_door.use_rot_z = 0
ce.ev_door.out_pnt_x = -4.7340102
ce.ev_door.out_pnt_y = -2.40798
ce.ev_door.out_pnt_z = -3.3989999
ce.ev_door.out_rot_x = 0
ce.ev_door.out_rot_y = -699.302
ce.ev_door.out_rot_z = 0
ce.ev_box = ce.ev_door
ce.ev_door.walkOut = function(arg1) -- line 146
    ev:come_out_door(ev.ce_door)
end
ce.cl_door = Object:create(ce, "/cetx003/door", 7.4604902, -0.88297802, -1.61, { range = 0.60000002 })
ce.cl_door.use_pnt_x = 7.6303701
ce.cl_door.use_pnt_y = -1.8358099
ce.cl_door.use_pnt_z = -2
ce.cl_door.use_rot_x = 0
ce.cl_door.use_rot_y = 723.94202
ce.cl_door.use_rot_z = 0
ce.cl_door.out_pnt_x = 7.5304699
ce.cl_door.out_pnt_y = -1.52678
ce.cl_door.out_pnt_z = -2
ce.cl_door.out_rot_x = 0
ce.cl_door.out_rot_y = 734.23602
ce.cl_door.out_rot_z = 0
ce.cl_box = ce.cl_door
ce.cl_door.walkOut = function(arg1) -- line 167
    cl:come_out_door(cl.ce_door)
end
