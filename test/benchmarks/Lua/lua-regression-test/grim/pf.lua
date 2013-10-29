CheckFirstTime("pf.lua")
pf = Set:create("pf.set", "photofinish", { pf_photocu = 0 })
pf.enter = function(arg1) -- line 20
    pf_save_handler = system.buttonHandler
    system.buttonHandler = pfButtonHandler
    music_state:update()
end
pf.exit = function(arg1) -- line 27
end
pf.switch_to_set = function(arg1) -- line 32
    if IsMoviePlaying() then
        StopMovie()
    else
        system.loopingMovie = nil
    end
    system.lastSet = system.currentSet
    LockSet(system.currentSet.setFile)
    pf_save_set = system.currentSet
    MakeCurrentSet(arg1.setFile)
    arg1:enter()
    system.currentSet = pf
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
    music_state:set_state(statePF)
end
pf.return_to_set = function(arg1) -- line 52
    pf:exit()
    system.currentSet = pf_save_set
    UnLockSet(pf_save_set.setFile)
    MakeCurrentSet(pf_save_set.setFile)
    system.buttonHandler = pf_save_handler
    if system.loopingMovie and type(system.loopingMovie) == "table" then
        play_movie_looping(system.loopingMovie.name, system.loopingMovie.x, system.loopingMovie.y)
    end
    music_state:update()
end
pfButtonHandler = function(arg1, arg2, arg3) -- line 72
    if arg2 then
        pf:return_to_set()
    end
end
