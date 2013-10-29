CheckFirstTime("zw.lua")
zw = Set:create("zw.set", "sewer maze", { zw_intws = 0, zw_ovrhd = 1 })
zw.talk_bowlsley = function() -- line 12
    zw.talked_bowlsley = TRUE
    sleep_for(1000)
    manny:say_line("/zwma003/")
end
zw.afraid_of_the_dark = function() -- line 18
    START_CUT_SCENE()
    lw.alligator_roar()
    wait_for_message()
    sleep_for(500)
    manny:walkto(2.96139, 1.1807, 0)
    manny:wait_for_actor()
    if not bowlsley_in_hiding then
        manny:say_line("/zwma004/")
    else
        manny:say_line("/zwma005/")
        wait_for_message()
        manny:say_line("/zwma006/")
    end
    END_CUT_SCENE()
end
zw.exclaim_tears = function() -- line 36
    local local1
    START_CUT_SCENE()
    MakeSectorActive("sh_door", FALSE)
    MakeSectorActive("sprout_sector", TRUE)
    manny:setpos(-0.74887198, 7.41676, 0.47)
    manny:setrot(0, -159, 0)
    if manny.is_holding ~= th.grinder then
        open_inventory(TRUE, TRUE)
        manny.is_holding = th.grinder
        close_inventory()
    end
    local1 = start_script(manny_grind)
    wait_for_script(local1)
    manny:walkto(-0.61283201, 6.8979402, 0.47, 0, -181, 0)
    manny:wait_for_actor()
    local1 = start_script(manny_grind)
    wait_for_script(local1)
    manny:walkto(-0.69373399, 5.1929798, 0.47, 0, -527, 0)
    manny:wait_for_actor()
    MakeSectorActive("sh_door", TRUE)
    MakeSectorActive("sprout_sector", FALSE)
    END_CUT_SCENE()
end
zw.enter = function(arg1) -- line 66
    zw:add_ambient_sfx({ "alDstGrl.wav" }, { min_pan = 10, max_pan = 117, min_delay = 15000, max_delay = 30000 })
    start_script(sewer_drip)
    if trail_actor then
        start_script(sh.set_up_flowers)
    end
    MakeSectorActive("sprout_sector", FALSE)
    if exclaimed_tears and not zw.talked_flowers then
        zw.talked_flowers = TRUE
        if not uncovered_trail then
            start_script(zw.exclaim_tears)
        end
    end
    if not exclaimed_tears then
        zw.trail_of_tears:make_untouchable()
    else
        zw.trail_of_tears:make_touchable()
    end
end
zw.exit = function(arg1) -- line 90
    local local1 = 1
    stop_script(sewer_drip)
    if trail_actor.i > 0 then
        repeat
            trail_actor.instances[local1].actor:free()
            local1 = local1 + 1
        until local1 > trail_actor.i
    end
    trail_actor:free()
end
zw.hole1 = Object:create(zw, "/zwtx007/grating", -0.43904299, -0.963108, 0.13, { range = 0.80000001 })
zw.hole1.use_pnt_x = -0.33904299
zw.hole1.use_pnt_y = -1.46311
zw.hole1.use_pnt_z = 0
zw.hole1.use_rot_x = 0
zw.hole1.use_rot_y = -703.26099
zw.hole1.use_rot_z = 0
zw.hole1.parent = lw.hole
zw.hole2 = Object:create(zw, "/zwtx008/grating", 0.60697001, -1.2159899, 0, { range = 0.80000001 })
zw.hole2.use_pnt_x = 0.216971
zw.hole2.use_pnt_y = -1.28599
zw.hole2.use_pnt_z = 0
zw.hole2.use_rot_x = 0
zw.hole2.use_rot_y = -814.78003
zw.hole2.use_rot_z = 0
zw.hole2.parent = lw.hole
zw.hole3 = Object:create(zw, "/zwtx009/drain", -1.2687, -2.98229, 0.89999998, { range = 2 })
zw.hole3.use_pnt_x = -0.78869599
zw.hole3.use_pnt_y = -2.24229
zw.hole3.use_pnt_z = 0
zw.hole3.use_rot_x = 0
zw.hole3.use_rot_y = -933.48199
zw.hole3.use_rot_z = 0
zw.hole3.parent = lw.hole
zw.hole4 = Object:create(zw, "/zwtx010/grating", -2.48985, -1.58794, 0.047280099, { range = 1 })
zw.hole4.use_pnt_x = -1.85985
zw.hole4.use_pnt_y = -1.93794
zw.hole4.use_pnt_z = 0.047280099
zw.hole4.use_rot_x = 0
zw.hole4.use_rot_y = -987.08502
zw.hole4.use_rot_z = 0
zw.hole4.parent = lw.hole
zw.trail_of_tears = Object:create(zw, "/zwtx011/trail of baby tears", 1.78713, 0.534778, 0, { range = 0.60000002 })
zw.trail_of_tears.use_pnt_x = 1.66605
zw.trail_of_tears.use_pnt_y = 0.21121401
zw.trail_of_tears.use_pnt_z = 0
zw.trail_of_tears.use_rot_x = 0
zw.trail_of_tears.use_rot_y = 40.312698
zw.trail_of_tears.use_rot_z = 0
zw.trail_of_tears.lookAt = function(arg1) -- line 160
    manny:say_line("/zwma012/")
end
zw.trail_of_tears.pickUp = function(arg1) -- line 164
    system.default_response("mittens")
end
zw.trail_of_tears.use = zw.trail_of_tears.pickUp
zw.sh_door = Object:create(zw, "/zwtx001/door", -0.407727, 10.9327, 0.47, { range = 2 })
zw.sh_door.use_pnt_x = -0.657727
zw.sh_door.use_pnt_y = 7.32265
zw.sh_door.use_pnt_z = 0.47
zw.sh_door.use_rot_x = 0
zw.sh_door.use_rot_y = -733.05298
zw.sh_door.use_rot_z = 0
zw.sh_door.out_pnt_x = -0.449186
zw.sh_door.out_pnt_y = 8.8277702
zw.sh_door.out_pnt_z = 0.47
zw.sh_door.out_rot_x = 0
zw.sh_door.out_rot_y = -727.63202
zw.sh_door.out_rot_z = 0
zw.sh_door.walkOut = function(arg1) -- line 189
    sh:come_out_door(sh.zw_door)
end
zw.at_door = Object:create(zw, "/zwtx002/door", 2.9249301, 1.10021, 0.34999999, { range = 1 })
zw.at_door.use_pnt_x = 2.4960499
zw.at_door.use_pnt_y = 0.81119001
zw.at_door.use_pnt_z = 0
zw.at_door.use_rot_x = 0
zw.at_door.use_rot_y = -418.44299
zw.at_door.use_rot_z = 0
zw.at_door.out_pnt_x = 2.92488
zw.at_door.out_pnt_y = 1.10035
zw.at_door.out_pnt_z = 0
zw.at_door.out_rot_x = 0
zw.at_door.out_rot_y = -412.13101
zw.at_door.out_rot_z = 0
zw.at_door.lookAt = function(arg1) -- line 208
    manny:say_line("/zwma013/")
end
zw.at_exit = Object:create(zw, "/zwtx002/exit", 2.9249301, 1.10021, 0.34999999, { range = 0 })
zw.at_exit.use_pnt_x = 2.4960499
zw.at_exit.use_pnt_y = 0.81119001
zw.at_exit.use_pnt_z = 0
zw.at_exit.use_rot_x = 0
zw.at_exit.use_rot_y = -418.44299
zw.at_exit.use_rot_z = 0
zw.at_exit.out_pnt_x = 2.92488
zw.at_exit.out_pnt_y = 1.10035
zw.at_exit.out_pnt_z = 0
zw.at_exit.out_rot_x = 0
zw.at_exit.out_rot_y = -412.13101
zw.at_exit.out_rot_z = 0
zw.at_exit:make_untouchable()
zw.at_exit.walkOut = function(arg1) -- line 230
    if uncovered_trail then
        if albinizod_pinned then
            if fi.gun.owner == manny then
                START_CUT_SCENE()
                manny:walkto(2.96139, 1.1807, 0)
                manny:wait_for_actor()
                manny:say_line("/ksma013/")
                END_CUT_SCENE()
            else
                START_CUT_SCENE()
                IrisDown(320, 240, 1000)
                sleep_for(1000)
                at.manny_state = ON_LEDGE
                at:switch_to_set()
                manny:put_in_set(at)
                manny:setpos(0.597137, 6.13825, 1.3)
                start_script(manny.walkto, manny, 0.575701, 4.78142, 1.3, 0, -900.22, 0)
                IrisUp(320, 240, 1000)
                manny:wait_for_actor()
                END_CUT_SCENE()
            end
        else
            START_CUT_SCENE()
            IrisDown(320, 240, 1000)
            sleep_for(1000)
            at.manny_state = ON_GROUND
            manny:stop_chore()
            manny:put_in_set(at)
            at:current_setup(at_intbw)
            at:switch_to_set()
            IrisUp(320, 240, 1000)
            END_CUT_SCENE()
        end
    else
        start_script(zw.afraid_of_the_dark)
    end
end
