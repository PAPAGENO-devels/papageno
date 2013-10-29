CheckFirstTime("cl.lua")
cl = Set:create("cl.set", "cafe ledge", { cl_rubws = 0, cl_rubws2 = 0, cl_rubws3 = 0, cl_ovrhd = 1, cl_scope = 2 })
dofile("mc_telescope.lua")
cl.scope_count = 0
cl.observations = { }
cl.observations[1] = { line = "/clma002/", enabled = TRUE }
cl.observations[2] = { line = "/clma007/", enabled = TRUE }
cl.observations[3] = { line = "/clma008/", enabled = TRUE }
cl.observations[4] = { line = "/clma003/", enabled = TRUE }
cl.observations[5] = { line = "/clma010/", enabled = TRUE }
cl.observations[6] = { line = "/clma006/", enabled = FALSE }
cl.observations[7] = { line = "/clma009/", enabled = FALSE }
cl.observations[8] = { line = "/clma004/", enabled = FALSE }
cl.observations[9] = { line = "/clma005/", enabled = FALSE }
cl.use_telescope = function() -- line 36
    cl.scope_count = cl.scope_count + 1
    START_CUT_SCENE()
    cl.telescope:handles_down()
    sleep_for(1000)
    if dd.been_there then
        cl.observations[6].enabled = TRUE
        if not cl.observations[6].said then
            cl.scope_count = 6
        end
    end
    if dd.strike_on then
        cl.observations[9].enabled = TRUE
        if not cl.observations[9].said then
            cl.scope_count = 9
        end
    end
    if lx.seen_lola then
        cl.observations[7].enabled = FALSE
        cl.observations[8].enabled = FALSE
    elseif bi.seen_kiss then
        cl.observations[7].enabled = TRUE
        cl.observations[8].enabled = TRUE
        if not cl.observations[7].said then
            cl.scope_count = 7
        elseif not cl.observations[8].said then
            cl.scope_count = 8
        end
    end
    while not cl.observations[cl.scope_count].enabled do
        cl.scope_count = cl.scope_count + 1
        if cl.scope_count >= 10 then
            cl.scope_count = 1
        end
    end
    cl.observations[cl.scope_count].said = TRUE
    manny:say_line(cl.observations[cl.scope_count].line)
    manny:wait_for_message()
    sleep_for(500)
    cl.telescope:handles_up()
    END_CUT_SCENE()
end
cl.enter = function(arg1) -- line 94
    cl.telescope.hObjectState = cl:add_object_state(cl_scope, "cl_2_handles.bm", "cl_2_handles.zbm", OBJSTATE_STATE, FALSE)
    cl.telescope:set_object_state("cl_2_handles.cos")
    LoadCostume("mc_telescope.cos")
    single_start_script(foghorn_sfx)
    cl:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
end
cl.exit = function(arg1) -- line 102
    stop_script(foghorn_sfx)
end
cl.telescope = Object:create(cl, "/cltx011/telescope", 7.39784, 3.2763801, -1.61704, { range = 0.60000002 })
cl.telescope.use_pnt_x = 7.3768401
cl.telescope.use_pnt_y = 3.0823801
cl.telescope.use_pnt_z = -2.0120399
cl.telescope.use_rot_x = 0
cl.telescope.use_rot_y = -6.6929402
cl.telescope.use_rot_z = 0
cl.telescope.lookAt = function(arg1) -- line 119
    START_CUT_SCENE("no head")
    manny:head_look_at_point({ x = 7.34284, y = 3.22738, z = -1.518 })
    manny:say_line("/clma012/")
    wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
cl.telescope.pickUp = function(arg1) -- line 128
    system.default_response("bolted")
end
cl.telescope.use = function(arg1) -- line 132
    if manny:walkto(arg1) then
        start_script(cl.use_telescope)
    end
end
cl.telescope.handles_down = function(arg1) -- line 138
    START_CUT_SCENE()
    manny:push_costume("mc_telescope.cos")
    manny:run_chore(mc_telescope_lookat_scope, "mc_telescope.cos")
    END_CUT_SCENE()
end
cl.telescope.handles_up = function(arg1) -- line 147
    START_CUT_SCENE()
    manny:run_chore(mc_telescope_look_done, "mc_telescope.cos")
    manny:pop_costume()
    END_CUT_SCENE()
end
cl.ce_door = Object:create(cl, "/cltx001/door", 6.74511, -1.96692, -1.48, { range = 0.60000002 })
cl.ce_door.use_pnt_x = 6.74511
cl.ce_door.use_pnt_y = -0.63691902
cl.ce_door.use_pnt_z = -2
cl.ce_door.use_rot_x = 0
cl.ce_door.use_rot_y = 540.008
cl.ce_door.use_rot_z = 0
cl.ce_door.out_pnt_x = 6.7451501
cl.ce_door.out_pnt_y = -0.96232998
cl.ce_door.out_pnt_z = -2
cl.ce_door.out_rot_x = 0
cl.ce_door.out_rot_y = 540.008
cl.ce_door.out_rot_z = 0
cl.ce_box = cl.ce_door
cl.ce_door.walkOut = function(arg1) -- line 177
    ce:come_out_door(ce.cl_door)
end
