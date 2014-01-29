CheckFirstTime("bs.lua")
bs = Set:create("bs.set", "temple back stairs", { bs_intla = 0, bs_ovrhd = 1 })
bs.force_hell_train = function() -- line 12
    START_CUT_SCENE()
    sleep_for(1000)
    meche:say_line("/bsmc004/")
    wait_for_message()
    manny:say_line("/bsma005/")
    wait_for_message()
    meche:say_line("/bsmc010/")
    wait_for_message()
    END_CUT_SCENE()
    start_script(cut_scene.helltrain)
end
bs.enter = function(arg1) -- line 31
    gate_keeper:free()
    gate_keeper:set_costume("gatekeeper.cos")
    gate_keeper:put_in_set(bs)
    gate_keeper:setpos(-1.59135, 32.6508, 17.8771)
    gate_keeper:setrot(0.17, 0)
    gate_keeper:play_chore(gatekeeper_cross_arms_hold, "gatekeeper.cos")
end
bs.my_door = Object:create(bs, "/bstx001/door", -5.7663999, 25.9069, 12.51, { range = 1 })
bs.my_door.use_pnt_x = -6.1564002
bs.my_door.use_pnt_y = 25.856899
bs.my_door.use_pnt_z = 11.69
bs.my_door.use_rot_x = 0
bs.my_door.use_rot_y = -1183.61
bs.my_door.use_rot_z = 0
bs.my_door.out_pnt_x = -5.8578
bs.my_door.out_pnt_y = 25.7847
bs.my_door.out_pnt_z = 11.69
bs.my_door.out_rot_x = 0
bs.my_door.out_rot_y = -1183.61
bs.my_door.out_rot_z = 0
bs.my_door.walkOut = function(arg1) -- line 65
    my:come_out_door(my.bs_door)
end
bs.my_door.lookAt = function(arg1) -- line 69
    manny:say_line("/bsma002/")
end
bs.my_door.comeOut = function(arg1) -- line 73
    if td.been_there and not seen_hell_train then
        start_script(bs.force_hell_train)
    else
        Object.come_out_door(arg1)
    end
end
bs.tg_door = Object:create(bs, "/bstx003/stairs", -6.7597098, 28.635401, 13.3277, { range = 1.5 })
bs.tg_door.use_pnt_x = -6.7597098
bs.tg_door.use_pnt_y = 27.5553
bs.tg_door.use_pnt_z = 12.4177
bs.tg_door.use_rot_x = 0
bs.tg_door.use_rot_y = 354.259
bs.tg_door.use_rot_z = 0
bs.tg_door.out_pnt_x = -6.76017
bs.tg_door.out_pnt_y = 28.205601
bs.tg_door.out_pnt_z = 12.7428
bs.tg_door.out_rot_x = 0
bs.tg_door.out_rot_y = 376.64999
bs.tg_door.out_rot_z = 0
bs.tg_door.lookAt = function(arg1) -- line 97
    manny:say_line("/bsma007/")
end
bs.tg_door.walkOut = function(arg1) -- line 101
    tg:come_out_door(tg.bs_door)
end
bs.td_door = Object:create(bs, "/bstx008/stairs", -10.4931, 27.2355, 10.2963, { range = 0.60000002 })
bs.td_door.use_pnt_x = -9.7930698
bs.td_door.use_pnt_y = 27.2355
bs.td_door.use_pnt_z = 10.6863
bs.td_door.use_rot_x = 0
bs.td_door.use_rot_y = 102.702
bs.td_door.use_rot_z = 0
bs.td_door.out_pnt_x = -10.2518
bs.td_door.out_pnt_y = 27.2188
bs.td_door.out_pnt_z = 10.461
bs.td_door.out_rot_x = 0
bs.td_door.out_rot_y = 82.1297
bs.td_door.out_rot_z = 0
bs.td_door.walkOut = function(arg1) -- line 123
    td:come_out_door(td.bs_door)
end
bs.td_door.lookAt = function(arg1) -- line 127
    manny:say_line("/bsma009/")
end
