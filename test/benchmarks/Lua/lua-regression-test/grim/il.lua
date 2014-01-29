CheckFirstTime("il.lua")
il = Set:create("il.set", "Inside the Lola", { il_top = 0, il_hitla = 1 })
il.surprise = function() -- line 13
    break_here()
    manny:walkto(0.944739, -1.65, 1.22)
    MakeSectorActive("after_sector", FALSE)
    sleep_for(1000)
    manny:say_line("/ilma001/")
end
dofile("mn_ladder_generic.lua")
il.hitsquad = { }
il.set_up_actors = function(arg1) -- line 25
    local local1 = 0
    repeat
        local1 = local1 + 1
        if not il.hitsquad[local1] then
            il.hitsquad[local1] = Actor:create(nil, nil, nil, "hitman" .. local1)
        end
        il.hitsquad[local1]:set_costume("hm" .. local1 .. "_HITMAN.cos")
        il.hitsquad[local1]:ignore_boxes()
        il.hitsquad[local1]:put_in_set(il)
        il.hitsquad[local1]:play_chore(1)
    until local1 == 3
    il.hitsquad[1]:setpos(-0.83835399, 5.77565, 0)
    il.hitsquad[1]:setrot(0, -115.959, 0)
    il.hitsquad[2]:setpos(1.0599999, 6.0443702, 0)
    il.hitsquad[2]:setrot(0, -299.41901, 0)
    il.hitsquad[3]:setpos(0.80137002, 6, 0)
    il.hitsquad[3]:setrot(0, -21.087799, 0)
end
il.enter = function(arg1) -- line 53
    il:current_setup(il_hitla)
    il:set_up_actors()
    if system.lastSet == lz then
        start_script(il.surprise)
    end
end
il.exit = function(arg1) -- line 64
    local local1 = 0
    repeat
        local1 = local1 + 1
        il.hitsquad[local1]:free()
    until local1 == 3
end
il.corpse2_trigger = { }
il.corpse2_trigger.walkOut = function(arg1) -- line 79
    il.corpse2:make_touchable()
    MakeSectorActive("corpse2_trigger", FALSE)
    manny:say_line("/ilma002/")
end
il.corpse3_4_trig = { }
il.corpse3_4_trig.walkOut = function(arg1) -- line 87
    il.corpse3:make_touchable()
    il.corpse4:make_touchable()
    MakeSectorActive("corpse3_4_trigger", FALSE)
    manny:say_line("/ilma003/")
    wait_for_message()
    manny:say_line("/ilma004/")
end
il.hit_trigger = { }
il.hit_trigger.walkOut = function(arg1) -- line 98
    start_script(cut_scene.hitsquad, cut_scene)
end
il.corpse1 = Object:create(il, "body", -0.64091802, -2.1347001, 1.47, { range = 2.2 })
il.corpse1.use_pnt_x = -0.45375299
il.corpse1.use_pnt_y = -1.89984
il.corpse1.use_pnt_z = 1.22
il.corpse1.use_rot_x = 0
il.corpse1.use_rot_y = 500.20401
il.corpse1.use_rot_z = 0
il.corpse1.lookAt = function(arg1) -- line 112
    manny:say_line("/ilma005/")
end
il.corpse1.pickUp = function(arg1) -- line 116
    manny:say_line("/ilma006/")
end
il.corpse1.use = function(arg1) -- line 121
    manny:say_line("/ilma007/")
end
il.corpse2 = Object:create(il, "body", 0.909082, -1.7247, 0.15000001, { range = 2.2 })
il.corpse2.use_pnt_x = 0.75139397
il.corpse2.use_pnt_y = -2.0161099
il.corpse2.use_pnt_z = 0
il.corpse2.use_rot_x = 0
il.corpse2.use_rot_y = 692.20599
il.corpse2.use_rot_z = 0
il.corpse2:make_untouchable()
il.corpse2.lookAt = function(arg1) -- line 135
    manny:say_line("/ilma008/")
end
il.corpse2.pickUp = function(arg1) -- line 139
end
il.corpse2.use = function(arg1) -- line 142
end
il.corpse3 = Object:create(il, "bodies", -0.227751, 0.54334402, 0.090000004, { range = 4 })
il.corpse3.use_pnt_x = -0.227751
il.corpse3.use_pnt_y = 0.0133441
il.corpse3.use_pnt_z = 0
il.corpse3.use_rot_x = 0
il.corpse3.use_rot_y = 741.45099
il.corpse3.use_rot_z = 0
il.corpse3:make_untouchable()
il.corpse3.lookAt = function(arg1) -- line 155
    manny:say_line("/ilma009/")
end
il.corpse3.pickUp = function(arg1) -- line 159
end
il.corpse3.use = function(arg1) -- line 162
end
il.corpse4 = Object:create(il, "bodies", 0.27697, 3.8699701, 0.059999999, { range = 7 })
il.corpse4.use_pnt_x = 0.27697
il.corpse4.use_pnt_y = 3.3299699
il.corpse4.use_pnt_z = 0
il.corpse4.use_rot_x = 0
il.corpse4.use_rot_y = 726.98999
il.corpse4.use_rot_z = 0
il.corpse4:make_untouchable()
il.corpse4.lookAt = il.corpse3.lookAt
il.corpse4.pickUp = function(arg1) -- line 177
end
il.corpse4.use = function(arg1) -- line 180
end
il.ladder = Object:create(il, "", -0.929676, -2.54263, 1.22, { range = 0 })
il.ladder.use_pnt_x = -0.92801201
il.ladder.use_pnt_y = -2.52267
il.ladder.use_pnt_z = 1.22
il.ladder.use_rot_x = 0
il.ladder.use_rot_y = 98.054703
il.ladder.use_rot_z = 0
il.ladder_top = il.ladder
il.ladder.walkOut = function(arg1) -- line 198
    local local1 = { }
    START_CUT_SCENE()
    manny:walkto(-0.929676, -2.54263, 1.22, 0, 98.054703, 0)
    manny:wait_for_actor()
    manny:wait_for_message()
    manny:ignore_boxes()
    manny:push_costume("mn_ladder_generic.cos")
    manny:play_chore_looping(mn_ladder_generic_hat_on)
    manny:play_chore(5)
    manny:wait_for_chore()
    manny:setpos(-0.707012, -2.4626701, 0.54400003)
    manny:play_chore(4)
    repeat
        local1 = manny:getpos()
        local1.z = local1.z - PerSecond(1)
        if local1.z < 0 then
            local1.z = 0
        end
        manny:setpos(local1)
        break_here()
    until local1.z == 0
    manny:pop_costume()
    manny:play_chore_looping(mn2_hat_on, "mn2.cos")
    manny:follow_boxes()
    END_CUT_SCENE()
end
il.lz_door = Object:create(il, "hatch", 1.6194299, -1.8312401, 1.65, { range = 0.60000002 })
il.lz_door.use_pnt_x = 1.3794301
il.lz_door.use_pnt_y = -1.8312401
il.lz_door.use_pnt_z = 1.22
il.lz_door.use_rot_x = 0
il.lz_door.use_rot_y = 266.48801
il.lz_door.use_rot_z = 0
il.lz_door.out_pnt_x = 1.5
il.lz_door.out_pnt_y = -1.83859
il.lz_door.out_pnt_z = 1.22
il.lz_door.out_rot_x = 0
il.lz_door.out_rot_y = 266.48801
il.lz_door.out_rot_z = 0
il.lz_door.walkOut = function(arg1) -- line 251
    lz:come_out_door(lz.il_door)
end
il.lz_door.lookAt = function(arg1) -- line 255
    system.default_response("way out")
end
il.lz_door.use = function(arg1) -- line 260
end
