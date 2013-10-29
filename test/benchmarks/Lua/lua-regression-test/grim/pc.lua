CheckFirstTime("pc.lua")
pc = Set:create("pc.set", "police station", { pc_estws = 0, pc_dorws = 1, pc_overhead = 2, pc_3_idfoto = 3, pc_4_idfoto = 4, pc_5_idfoto = 5, pc_6_idfoto = 6, pc_7_idfoto = 7, pc_8_idfoto = 8, pc_9_idfoto = 9, pc_10_idfoto = 10 })
pc.enter = function(arg1) -- line 19
    NewObjectState(pc_dorws, OBJSTATE_UNDERLAY, "pc_morgue_door.bm")
    pc.mg_door:set_object_state("pc_morgue_door.cos")
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -2.4, 3.7, 24)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -2.4, 3.7, 24)
    SetActorShadowPlane(manny.hActor, "shadow10")
    AddShadowPlane(manny.hActor, "shadow10")
    AddShadowPlane(manny.hActor, "shadow11")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, -2.4, 3.7, 24)
    SetActorShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow21")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, -0.518094, 5.57332, 20.649)
    SetActorShadowPlane(manny.hActor, "shadow50")
    AddShadowPlane(manny.hActor, "shadow50")
    SetActiveShadow(manny.hActor, 4)
    SetActorShadowPoint(manny.hActor, -2.44, 5.4, 13)
    SetActorShadowPlane(manny.hActor, "shadow60")
    AddShadowPlane(manny.hActor, "shadow60")
end
pc.exit = function(arg1) -- line 56
    KillActorShadows(manny.hActor)
end
pc.pi_door = Object:create(pc, "/pctx001/door", -0.055260599, 5.5387001, 13.4634, { range = 0.60000002 })
pc.pi_door.use_pnt_x = -0.055260599
pc.pi_door.use_pnt_y = 5.9387002
pc.pi_door.use_pnt_z = 13.0334
pc.pi_door.use_rot_x = 0
pc.pi_door.use_rot_y = -170.09599
pc.pi_door.use_rot_z = 0
pc.pi_door.out_pnt_x = 0.0441637
pc.pi_door.out_pnt_y = 5.4296498
pc.pi_door.out_pnt_z = 13.1
pc.pi_door.out_rot_x = 0
pc.pi_door.out_rot_y = -169.261
pc.pi_door.out_rot_z = 0
pc.pi_door.touchable = FALSE
pc.pi_box = pc.pi_door
pc.pi_door.walkOut = function(arg1) -- line 89
    pi:come_out_door(pi.pc_door)
end
pc.bp_door = Object:create(pc, "/pctx002/bridge", 0.233805, 1.23681, 12.2, { range = 0.60000002 })
pc.bp_door.use_pnt_x = -0.49619499
pc.bp_door.use_pnt_y = 1.23681
pc.bp_door.use_pnt_z = 11.8
pc.bp_door.use_rot_x = 0
pc.bp_door.use_rot_y = -89.502296
pc.bp_door.use_rot_z = 0
pc.bp_door.out_pnt_x = 0.31990099
pc.bp_door.out_pnt_y = 1.23359
pc.bp_door.out_pnt_z = 11.8
pc.bp_door.out_rot_x = 0
pc.bp_door.out_rot_y = -127.641
pc.bp_door.out_rot_z = 0
pc.bp_door.touchable = FALSE
pc.bp_box = pc.bp_door
pc.bp_door.walkOut = function(arg1) -- line 113
    bp:come_out_door(bp.pc_door)
end
pc.mg_door = Object:create(pc, "/pctx003/door", -2.24878, 5.3828001, 12.13, { range = 0.40000001 })
pc.mg_door.use_pnt_x = -2.47628
pc.mg_door.use_pnt_y = 5.2999902
pc.mg_door.use_pnt_z = 11.6
pc.mg_door.use_rot_x = 0
pc.mg_door.use_rot_y = 284.49301
pc.mg_door.use_rot_z = 0
pc.mg_door.out_pnt_x = -2.31284
pc.mg_door.out_pnt_y = 5.2999902
pc.mg_door.out_pnt_z = 11.6
pc.mg_door.out_rot_x = 0
pc.mg_door.out_rot_y = 284.49301
pc.mg_door.out_rot_z = 0
pc.mg_box = pc.mg_door
pc.mg_door.walkOut = function(arg1) -- line 134
    if made_vacancy then
        if arg1.tried then
            system.default_response("locked")
        else
            arg1.tried = TRUE
            START_CUT_SCENE()
            manny:walkto_object(arg1)
            manny:play_chore(mc_reach_med, "mc.cos")
            manny:wait_for_chore(mc_reach_med, "mc.cos")
            manny:stop_chore(mc_reach_med, "mc.cos")
            END_CUT_SCENE()
            manny:say_line("/pcma004/")
        end
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:play_chore(mc_reach_med, "mc.cos")
        sleep_for(500)
        arg1:play_chore(0)
        manny:wait_for_chore(mc_reach_med, "mc.cos")
        arg1:wait_for_chore(0)
        END_CUT_SCENE()
        mg:come_out_door(mg.pc_door)
    end
end
pc.ev_door = Object:create(pc, "/pctx005/stairs", -3.82284, 8.6571598, 13.4, { range = 1.5 })
pc.ev_door.use_pnt_x = -3.7506499
pc.ev_door.use_pnt_y = 7.79006
pc.ev_door.use_pnt_z = 12.5732
pc.ev_door.use_rot_x = 0
pc.ev_door.use_rot_y = -346.34601
pc.ev_door.use_rot_z = 0
pc.ev_door.out_pnt_x = -3.7282901
pc.ev_door.out_pnt_y = 8.5170202
pc.ev_door.out_pnt_z = 12.9
pc.ev_door.out_rot_x = 0
pc.ev_door.out_rot_y = -372.79599
pc.ev_door.out_rot_z = 0
pc.ev_door.touchable = FALSE
pc.ev_box = pc.ev_door
pc.ev_door.walkOut = function(arg1) -- line 180
    ev:come_out_door(ev.pc_door)
end
