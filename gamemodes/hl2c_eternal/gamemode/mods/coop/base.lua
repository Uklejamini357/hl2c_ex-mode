RESET_WEAPONS = true
MAP_FORCE_NO_FRIENDLIES = true

-- good luck.

if CLIENT then
    hook.Add("OnMapFailed", "damnit", function()
        LocalPlayer():EmitSound("vo/npc/barney/ba_damnit.wav")
        LocalPlayer():EmitSound("music/hl2_song23_suitsong3.mp3")
    end)

    return
end

hook.Add("AcceptInput", "fine", function(ent, input, _, _, value)
    if ent:GetClass() == "point_servercommand" and input:lower() == "command" and string.Explode(" ", value)[1] == "changelevel" then
        for _,ply in player.Iterator() do
            gamemode.Call("CompleteMap", ply)
        end
    end
end)
