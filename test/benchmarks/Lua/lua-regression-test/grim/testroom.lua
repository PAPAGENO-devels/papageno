CheckFirstTime("testroom.lua")
testroom = Set:create("testroom.set", "testroom", { })
testroom.switch_to_set = function(arg1) -- line 24
    PrintDebug("Switching to set: " .. arg1.name .. ".\n")
    system.lastSet = system.currentSet
    if system.currentSet then
        system.currentSet:CommonExit()
    end
    system.currentSet = arg1
    arg1:CommonEnter()
    MakeCurrentSet(arg1.setFile)
    arg1:enter()
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
end
HelpScreen = function() -- line 61
    RenderModeUser(TRUE)
    DimScreen()
    CleanBuffer()
    BlastText("Papa gotta brand new bag", { x = 40, y = 40, fgcolor = Red, font = special_font })
    Display()
end
EndHelp = function() -- line 70
    RenderModeUser(nil)
end
