CheckFirstTime("ck.lua")
ck = Set:create("ck.set", "crane track", { ck_crnha = 0, ck_ovrhd = 1 })
ck.enter = function(arg1) -- line 18
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 25, 100)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
ck.exit = function(arg1) -- line 27
    KillActorShadows(manny.hActor)
end
