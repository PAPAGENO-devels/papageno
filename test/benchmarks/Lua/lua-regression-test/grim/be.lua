CheckFirstTime("be.lua")
be = Set:create("be.set", "Blue Casket Exterior", { be_front = 0, be_ovrhd = 1 })
be.enter = function(arg1) -- line 18
    if skinny_girl then
        skinny_girl:free()
    end
    if cig_girl then
        cig_girl:free()
    end
    if hooka_guy1 then
        hooka_guy1:free()
    end
    if hooka_guy2 then
        hooka_guy2:free()
    end
    if alexi then
        alexi:free()
    end
    if gunnar then
        gunnar:free()
    end
    if slisko then
        slisko:free()
    end
    if bi.book.act then
        bi.book.act:free()
    end
    if olivia then
        olivia:free()
    end
    if beat_waiter then
        beat_waiter:free()
    end
    beat_waiter.frozen = FALSE
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.13, 1.15, 1.013)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow11")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 0.13, 1.15, 1.013)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow4")
    AddShadowPlane(manny.hActor, "shadow5")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 0, 0, 100)
    SetActorShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow20")
end
be.exit = function(arg1) -- line 53
    KillActorShadows(manny.hActor)
end
be.sign = Object:create(be, "/betx002/sign", 0.66385001, 0.51091802, 0.63, { range = 0.89999998 })
be.sign.use_pnt_x = 0.01385
be.sign.use_pnt_y = 0.040918101
be.sign.use_pnt_z = 0
be.sign.use_rot_x = 0
be.sign.use_rot_y = 340.01001
be.sign.use_rot_z = 0
be.sign.lookAt = function(arg1) -- line 71
    soft_script()
    manny:say_line("/bema003/")
    wait_for_message()
    manny:say_line("/bema004/")
end
be.sign.pickUp = function(arg1) -- line 78
    system.default_response("attached")
end
be.sign.use = be.sign.lookAt
be.bw_door = Object:create(be, "/betx001/door", 0.001162, -1.0640399, 0.60000002, { range = 0.60000002 })
be.bw_door.use_pnt_x = 0.058942601
be.bw_door.use_pnt_y = -0.60401201
be.bw_door.use_pnt_z = 0.158694
be.bw_door.use_rot_x = 0
be.bw_door.use_rot_y = -170.021
be.bw_door.use_rot_z = 0
be.bw_door.out_pnt_x = 0.166039
be.bw_door.out_pnt_y = -1.1
be.bw_door.out_pnt_z = 0.26100001
be.bw_door.out_rot_x = 0
be.bw_door.out_rot_y = -168.386
be.bw_door.out_rot_z = 0
be.bw_door:make_untouchable()
be.bw_box = be.bw_door
be.bw_door.walkOut = function(arg1) -- line 107
    bw:come_out_door(bw.be_door)
end
be.bi_door = Object:create(be, "/betx005/door", 0.0020643701, 0.866988, 0.44999999, { range = 0.69999999 })
be.bi_door.use_pnt_x = 0.0020643701
be.bi_door.use_pnt_y = 0.65698802
be.bi_door.use_pnt_z = 0
be.bi_door.use_rot_x = 0
be.bi_door.use_rot_y = 1082.0699
be.bi_door.use_rot_z = 0
be.bi_door.out_pnt_x = -0.0063442402
be.bi_door.out_pnt_y = 0.82499999
be.bi_door.out_pnt_z = 0
be.bi_door.out_rot_x = 0
be.bi_door.out_rot_y = -353.702
be.bi_door.out_rot_z = 0
be.bi_box = be.bi_door
be.bi_door.lookAt = function(arg1) -- line 129
    manny:say_line("/bema006/")
end
be.bi_door.walkOut = function(arg1) -- line 133
    if not bi.seen_kiss then
        bi.kiss_trigger_set = TRUE
    end
    if not bi.seen_waiter then
        bi.waiter_cue = TRUE
    end
    bi:come_out_door(bi.be_door)
end
