CheckFirstTime("hp.lua")
dofile("ra_bonked.lua")
hp = Set:create("hp.set", "high roller pantry", { hp_intha = 0, hp_hpopn = 1, hp_ovrhd = 2 })
hp.can_actor = Actor:create(nil, nil, nil, "Can of olives")
hp.can_actor.default = function(arg1) -- line 15
    arg1:set_costume(nil)
    arg1:set_costume("ra_bonked.cos")
    arg1:put_in_set(hp)
    arg1:setpos(-0.01509, -0.32876, 0)
    arg1:setrot(0, 541.536, 0)
end
hp.update_music_state = function(arg1) -- line 28
    return stateHP
end
hp.enter = function(arg1) -- line 32
    SetActorScale(manny.hActor, 1.3)
    if not hk.raoul_trapped then
        hp.can_actor:default()
        hp.can_actor:play_chore(ra_bonked_can_only, "ra_bonked.cos")
    end
    start_sfx("he_hk_hp.imu", IM_MEDIUM_PRIORITY, 50)
end
hp.exit = function(arg1) -- line 43
    SetActorScale(manny.hActor, 1)
    hp.can_actor:free()
    stop_sound("he_hk_hp.imu")
end
hp.cans1 = Object:create(hp, "/hptx001/cans", -0.38930601, 0.26661599, 0.69919997, { range = 0.89999998 })
hp.cans1.use_pnt_x = 0.19992299
hp.cans1.use_pnt_y = -0.0049829702
hp.cans1.use_pnt_z = 0
hp.cans1.use_rot_x = 0
hp.cans1.use_rot_y = 1352.92
hp.cans1.use_rot_z = 0
hp.cans1.parent = hk.cans1
hp.cans2 = Object:create(hp, "/hptx002/cans", -0.30170599, -0.468384, 0.2466, { range = 0.89999998 })
hp.cans2.use_pnt_x = 0.19992299
hp.cans2.use_pnt_y = -0.0049829702
hp.cans2.use_pnt_z = 0
hp.cans2.use_rot_x = 0
hp.cans2.use_rot_y = 1352.92
hp.cans2.use_rot_z = 0
hp.cans2.parent = hk.cans1
hp.cans3 = Object:create(hp, "/hptx003/cans", -0.27800101, -0.140359, 0.45750001, { range = 0.60000002 })
hp.cans3.use_pnt_x = 0.088239796
hp.cans3.use_pnt_y = -0.0133994
hp.cans3.use_pnt_z = 0
hp.cans3.use_rot_x = 0
hp.cans3.use_rot_y = 1534.3101
hp.cans3.use_rot_z = 0
hp.cans3.parent = hk.cans1
hp.cans4 = Object:create(hp, "/hptx004/cans", -0.27800101, 0.44454101, -0.1045, { range = 0.60000002 })
hp.cans4.use_pnt_x = 0.088239796
hp.cans4.use_pnt_y = -0.0133994
hp.cans4.use_pnt_z = 0
hp.cans4.use_rot_x = 0
hp.cans4.use_rot_y = 1534.3101
hp.cans4.use_rot_z = 0
hp.cans4.parent = hk.cans1
hp.hk_door = Object:create(hp, "/hptx005/door", 0.1018, -0.59680003, 0.5, { range = 0.60000002 })
hp.hk_door.use_pnt_x = 0.101979
hp.hk_door.use_pnt_y = -0.225199
hp.hk_door.use_pnt_z = 0
hp.hk_door.use_rot_x = 0
hp.hk_door.use_rot_y = 184.59399
hp.hk_door.use_rot_z = 0
hp.hk_door.out_pnt_x = 0.132102
hp.hk_door.out_pnt_y = -0.60000002
hp.hk_door.out_pnt_z = 0
hp.hk_door.out_rot_x = 0
hp.hk_door.out_rot_y = 184.59399
hp.hk_door.out_rot_z = 0
hp.hk_door.touchable = FALSE
hp.hk_box = hp.hk_door
hp.hk_door.walkOut = function(arg1) -- line 116
    START_CUT_SCENE()
    hk:switch_to_set()
    hk:current_setup(0)
    manny:put_in_set(hk)
    manny:setpos(hk.hp_door.out_pnt_x, hk.hp_door.out_pnt_y, hk.hp_door.out_pnt_z)
    manny:walkto(hk.hp_door.use_pnt_x, hk.hp_door.use_pnt_y, hk.hp_door.use_pnt_z)
    END_CUT_SCENE()
end
hp.hk_door.comeOut = function(arg1) -- line 126
    if hk.pantry:is_open() then
        hp:current_setup(hp_hpopn)
    else
        hp:current_setup(hp_intha)
    end
    Object.come_out_door(arg1)
end
