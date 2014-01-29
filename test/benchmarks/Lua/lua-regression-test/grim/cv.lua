CheckFirstTime("cv.lua")
dofile("cv_chain.lua")
cv = Set:create("cv.set", "crane conveyor", { cv_crnla = 0, cv_ovrhd = 1 })
cv.chain_bunched = FALSE
cv.chain_actor = Actor:create(nil, nil, nil, "CV Chain")
cv.music_counter = 0
cv.spill_chain = function(arg1) -- line 20
    ew.crane_down = TRUE
    if cy.lever.up then
        START_CUT_SCENE()
        set_override(cv.skip_spill_chain, cv)
        cv:switch_to_set()
        cv.chain_actor:play_chore(cv_chain_gone)
        play_movie("cv_bu.snm", 203, 0)
        wait_for_movie()
        END_CUT_SCENE()
        cv.chain_bunched = TRUE
    else
        cur_puzzle_state[42] = TRUE
        START_CUT_SCENE()
        set_override(cv.skip_spill_chain, cv)
        cv:switch_to_set()
        cv.chain_actor:play_chore(cv_chain_gone)
        play_movie("cv_cf.snm", 200, 0)
        wait_for_movie()
        cy:switch_to_set()
        cy.belt_actor:set_visibility(FALSE)
        cy.belt:play_chore(0)
        stop_sound("cy_cvgo.IMU")
        StartFullscreenMovie("cy_ch.snm")
        wait_for_movie()
        cy.belt_actor:set_visibility(TRUE)
        ac:switch_to_set()
        stop_sound("cy_cvgo.IMU")
        StartFullscreenMovie("ac_ch.snm")
        wait_for_movie()
        END_CUT_SCENE()
        cv.chain_bunched = FALSE
        ac.chain_state = "here"
    end
    ew:switch_to_set()
end
cv.skip_spill_chain = function(arg1) -- line 59
    kill_override()
    stop_sound("cy_cvgo.IMU")
    if cy.lever.up then
        cv.chain_bunched = TRUE
    else
        cv.chain_bunched = FALSE
        ac.chain_state = "here"
    end
    ew:switch_to_set()
end
cv.recoil_chain = function(arg1) -- line 72
    START_CUT_SCENE()
    set_override(cv.skip_recoil_chain, cv)
    if ac.chain_state == "here" then
        ac:switch_to_set()
        stop_sound("cy_cvgo.IMU")
        RunFullscreenMovie("ac_re.snm")
        wait_for_movie()
    else
        cv:switch_to_set()
        cv.chain_actor:play_chore(cv_chain_gone)
        stop_sound("cy_cvgo.IMU")
        play_movie("cv_re.snm", 200, 0)
        wait_for_movie()
    end
    END_CUT_SCENE()
    ac.chain_state = "gone"
    cv.chain_bunched = FALSE
    ew.crane_down = FALSE
    ew:switch_to_set()
end
cv.skip_recoil_chain = function(arg1) -- line 95
    kill_override()
    stop_sound("cy_cvgo.IMU")
    ac.chain_state = "gone"
    cv.chain_bunched = FALSE
    ew.crane_down = FALSE
    ew:switch_to_set()
end
cv.update_music_state = function(arg1) -- line 110
    if cv.music_counter > 2 then
        return stateCUV_LATER
    else
        return stateCV
    end
end
cv.enter = function(arg1) -- line 118
    inventory_disabled = FALSE
    if cv.chain_bunched or ac.chain_state ~= "gone" then
        if cv.chain_bunched then
            cv:add_object_state(0, "cv_bunch1.bm", nil, OBJSTATE_STATE, TRUE)
            cv:add_object_state(0, "cv_bunch2.bm", "cv_bunch2.zbm", OBJSTATE_OVERLAY, TRUE)
        else
            cv:add_object_state(0, "cv_paid_out.bm", "cv_paid_out.zbm", OBJSTATE_OVERLAY, TRUE)
        end
        cv.chain_actor:put_in_set(cv)
        cv.chain_actor:setpos(0, 0, 0)
        cv.chain_actor:setrot(0, 0, 0)
        cv.chain_actor:set_costume("cv_chain.cos")
        if cv.chain_bunched then
            cv.chain_actor:play_chore(cv_chain_bunched)
        else
            cv.chain_actor:play_chore(cv_chain_paid_out)
        end
    end
    if cy.lever.up then
        play_movie_looping("cv_bf.snm", 200, 240)
    else
        play_movie_looping("cv_br.snm", 197, 240)
    end
    start_sfx("cv_bf.IMU")
    ew.crane_actor.cur_point = ew.at_conveyor
    cv.music_counter = cv.music_counter + 1
end
cv.exit = function(arg1) -- line 152
    StopMovie()
    stop_sound("cv_bf.IMU")
    cv.chain_actor:free()
end
cv.crane = Object:create(cv, "/cvtx001/crane", 0.0091107897, -8.84447, 9.3757, { range = 4 })
cv.crane.use_pnt_x = 0.0091107897
cv.crane.use_pnt_y = -11.6545
cv.crane.use_pnt_z = 6.7856998
cv.crane.use_rot_x = 0
cv.crane.use_rot_y = 709.03699
cv.crane.use_rot_z = 0
cv.crane.lookAt = function(arg1) -- line 173
    if meche.talked_boat and not cv.talked_tube then
        cv.talked_tube = TRUE
        manny:say_line("/cvma008/")
        wait_for_message()
        manny:say_line("/cvma009/")
    else
        manny:say_line("/cvma010/")
    end
end
cv.crane.pickUp = function(arg1) -- line 184
    manny:say_line("/cvma003/")
end
cv.crane.use = function(arg1) -- line 188
    ew.crane_pos = ew.at_conveyor
    start_script(ew.operate_crane)
end
cv.crane_door = Object:create(cv, "/cvtx004/cabin", -5.4229398, -8.2396097, 10.4, { range = 2 })
cv.crane_door.use_pnt_x = -5.4229398
cv.crane_door.use_pnt_y = -8.5096102
cv.crane_door.use_pnt_z = 9.9999905
cv.crane_door.use_rot_x = 0
cv.crane_door.use_rot_y = -319.966
cv.crane_door.use_rot_z = 0
cv.crane_door.out_pnt_x = -5.5999999
cv.crane_door.out_pnt_y = -8.1999998
cv.crane_door.out_pnt_z = 9.9999905
cv.crane_door.out_rot_x = 0
cv.crane_door.out_rot_y = -348.00299
cv.crane_door.out_rot_z = 0
cv.crane_door.walkOut = function(arg1) -- line 213
    ew.crane_pos = ew.at_conveyor
    start_script(ew.operate_crane)
end
cv.crane_door.lookAt = function(arg1) -- line 218
    manny:say_line("/cvma005/")
end
cv.crane_trigger = { name = "crane trigger" }
cv.crane_trigger.walkOut = function(arg1) -- line 223
    if ew.used_crane then
        cv.crane_door:walkOut()
    end
end
cv.cy_door = Object:create(cv, "/cvtx006/belt", -0.021805599, -12.4089, 5.3256602, { range = 0.60000002 })
cv.cy_door.use_pnt_x = -0.021805599
cv.cy_door.use_pnt_y = -11.9889
cv.cy_door.use_pnt_z = 5.7156601
cv.cy_door.use_rot_x = 0
cv.cy_door.use_rot_y = -183.96201
cv.cy_door.use_rot_z = 0
cv.cy_door.out_pnt_x = 0.0082815103
cv.cy_door.out_pnt_y = -12.3
cv.cy_door.out_pnt_z = 5.6000099
cv.cy_door.out_rot_x = 0
cv.cy_door.out_rot_y = -534.96198
cv.cy_door.out_rot_z = 0
cv.cy_door.lookAt = function(arg1) -- line 245
    manny:say_line("/cvma007/")
end
cv.cy_door.walkOut = function(arg1) -- line 249
    if not ew.crane_down or not ew.crane_broken or ew.crane_pos ~= ew.at_conveyor or cv.chain_bunched then
        cy:come_out_door(cy.cv_door)
    else
        cy:start_drifting()
    end
end
cv.skip_bunch1 = { name = "skip bunched chain1" }
cv.skip_bunch1.walkOut = function(arg1) -- line 258
    if cv.chain_bunched or ac.chain_state ~= "gone" then
        cv.cy_door:walkOut()
    end
end
cv.skip_bunch2 = { name = "skip bunched chain2" }
cv.skip_bunch2.walkOut = function(arg1) -- line 265
    if cv.chain_bunched or ac.chain_state ~= "gone" then
        cv.crane_door:walkOut()
    end
end
