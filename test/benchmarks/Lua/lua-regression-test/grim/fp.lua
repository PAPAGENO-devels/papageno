CheckFirstTime("fp.lua")
fp = Set:create("fp.set", "florist shop", { fp_top = 0, fp_extws = 1 })
fp.hear_bell = function() -- line 12
    break_here()
    print_temporary("sfx: Ding! Ding!")
end
fp.enter = function(arg1) -- line 22
    NewObjectState(fp_extws, OBJSTATE_STATE, "fp_door.bm", "fp_door_open.zbm")
    fp.fi_door:set_object_state("fp_door.cos")
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.02, 0.73, 1.2)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow4")
end
fp.ext = function(arg1) -- line 36
    KillActorShadows(manny.hActor)
end
fp.flowerbox = Object:create(fp, "/fptx002/flowerbox", -0.51320302, 0.89507401, 0.19, { range = 1 })
fp.flowerbox.use_pnt_x = 0.0467971
fp.flowerbox.use_pnt_y = 1.27507
fp.flowerbox.use_pnt_z = -0.15000001
fp.flowerbox.use_rot_x = 0
fp.flowerbox.use_rot_y = -529.185
fp.flowerbox.use_rot_z = 0
fp.flowerbox.lookAt = function(arg1) -- line 53
    manny:say_line("/fpma003/")
end
fp.flowerbox.pickUp = function(arg1) -- line 57
    system.default_response("no")
end
fp.flowerbox.use = function(arg1) -- line 61
    system.default_response("no")
end
fp.flowerbox2 = Object:create(fp, "/fptx004/flowerbox", 0.526797, 0.89507401, 0.19, { range = 1 })
fp.flowerbox2.use_pnt_x = 0.0467971
fp.flowerbox2.use_pnt_y = 1.27507
fp.flowerbox2.use_pnt_z = -0.15000001
fp.flowerbox2.use_rot_x = 0
fp.flowerbox2.use_rot_y = -529.185
fp.flowerbox2.use_rot_z = 0
fp.flowerbox2.parent = fp.flowerbox
fp.at_door = Object:create(fp, "/fptx001/door", -0.049922001, 2.8169701, 0.376041, { range = 0.60000002 })
fp.at_door.use_pnt_x = -0.071339399
fp.at_door.use_pnt_y = 1.83802
fp.at_door.use_pnt_z = -0.27553901
fp.at_door.use_rot_x = 0
fp.at_door.use_rot_y = -354.61099
fp.at_door.use_rot_z = 0
fp.at_door.out_pnt_x = -0.079703301
fp.at_door.out_pnt_y = 1.925
fp.at_door.out_pnt_z = -0.28999999
fp.at_door.out_rot_x = 0
fp.at_door.out_rot_y = -354.61099
fp.at_door.out_rot_z = 0
fp.at_box = fp.at_door
fp.at_door.walkOut = function(arg1) -- line 95
    at:come_out_door(at.fp_door)
end
fp.fi_door = Object:create(fp, "/fptx005/florist's shop", 0.029999999, 0.58499998, 0.56, { range = 2 })
fp.fi_door.use_pnt_x = 0.049835201
fp.fi_door.use_pnt_y = 0.85460001
fp.fi_door.use_pnt_z = 0
fp.fi_door.use_rot_x = 0
fp.fi_door.use_rot_y = -180.10001
fp.fi_door.use_rot_z = 0
fp.fi_door.out_pnt_x = 0.0495211
fp.fi_door.out_pnt_y = 0.625
fp.fi_door.out_pnt_z = 0
fp.fi_door.out_rot_x = 0
fp.fi_door.out_rot_y = -180.10001
fp.fi_door.out_rot_z = 0
fp.fi_box = fp.fi_door
fp.fi_door.lookAt = function(arg1) -- line 117
    manny:say_line("/fpma006/")
end
fp.fi_door.walkOut = function(arg1) -- line 121
    if fi.gun.owner == manny then
        system.default_response("nah")
    else
        START_CUT_SCENE()
        if manny.is_holding then
            put_away_held_item()
        end
        manny:start_open_door_anim()
        sleep_for(800)
        fp.fi_door:play_chore(0)
        sleep_for(268)
        END_CUT_SCENE()
        fi:enter_from_fp()
    end
end
