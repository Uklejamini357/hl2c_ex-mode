NEXT_MAP_PERCENT = 1--420
NEXT_MAP_INSTANT_PERCENT = 6969


if CLIENT then
    net.Receive("hl2ce_map_event", function()
        local event = net.ReadString()

        if event == "noclip" then
            chat.AddText("If you're not careful and you noclip out of reality in the wrong areas, you'll end up in the Backrooms, where it's nothing but the stink of old moist carpet, the madness of mono-yellow, the endless background noise of fluorescent lights at maximum hum-buzz,  and approximately six hundred million square miles of randomly segmented empty rooms to be trapped in\
\
God save you if you hear something wandering around nearby, because it sure as hell has heard you")
        end
    end)

    return
end

hook.Add("GetFailReason", "hl2cGetFailReason", function(ply, reason)
    if reason == "you_are_dead" or reason == "all_players_died" then
        return "You died. End of story."
    end
end)

hook.Add("MapEdit", "hl2cMapEdit", function()
    -- local e = ents.FindByName("kostil0")[1]
    -- if e and IsValid(e) then
    --     e:Remove()
    -- end

    local e = ents.FindByName("strip1")[1]
    if e and IsValid(e) then
        e:Remove()
    end
end)

function hl2cAcceptInput(ent, input)
    if ent:GetName() == "relay1" and input:lower() == "trigger" then
        PrintMessage(3, "event triggered")
    end

    if ent:GetName() == "deathfade1" and input:lower() == "fade" then
        for _,ply in ipairs(player.GetLiving()) do
            ply:Kill()
        end
    end

    if ent:GetName() == "try1" and input:lower() == "enable" then
    end

    if ent:GetName() == "try2" and input:lower() == "enable" then
        PrintMessage(3, "What the hell was that?!")
        timer.Simple(1.2, function()
            if !IsValid(ent) then return end
            PrintMessage(3, "Well, at least you still have 4 lives left!")
        end)
    end

    if ent:GetName() == "try3" and input:lower() == "enable" then
        PrintMessage(3, "You let yourself get attacked by that thing again?!")
        timer.Simple(1.2, function()
            if !IsValid(ent) then return end
            PrintMessage(3, "3 lives left.. better be careful.")
        end)
    end

    if ent:GetName() == "try4" and input:lower() == "enable" then
        PrintMessage(3, "OH MY GOD AGAIN!?")
        timer.Simple(1.2, function()
            if !IsValid(ent) then return end
            PrintMessage(3, "2 lives.. really, be more careful!!")
        end)
    end

    if ent:GetName() == "try5" then
        if input:lower() == "enable" then
            PrintMessage(3, "...")
            timer.Simple(1.2, function()
                if !IsValid(ent) then return end
                PrintMessage(3, "1 more... and it's all over.")
            end)
        end
    end

    if ent:GetName() == "endver1" and input:lower() == "enable" then
        timer.Simple(math.Rand(0.3, 0.6), function()
            if !IsValid(ent) then return end
            PrintMessage(3, "*sigh*")
        end)
        timer.Simple(1.2, function()
            if !IsValid(ent) then return end
            PrintMessage(3, "Goodbye, I guess.")
        end)
        timer.Simple(1.7, function()
            if !IsValid(ent) then return end
            gamemode.Call("FailMap", nil, "ending 1")
        end)
    end

    if ent:GetName() == "endver2" and input:lower() == "enable" then
        gamemode.Call("FailMap", nil, "ending 2")
    end

    if ent:GetName() == "endver3" and input:lower() == "enable" then
        gamemode.Call("FailMap", nil, "ending 3")
    end

    if ent:GetName() == "endver4" and input:lower() == "enable" then
        gamemode.Call("FailMap", nil, "Stuck ending")
    end

    if ent:GetName() == "endver5" and input:lower() == "enable" then
        PrintMessage(3, "Woooooo, you survived!")

        for _,ply in ipairs(player.GetLiving()) do
            local pos,ang = ply:GetPos(),ply:EyeAngles()
            gamemode.Call("CompleteMap", ply)
            ply:UnSpectate()
            ply:SetMoveType(MOVETYPE_WALK)
            ply:Spawn()
            ply:SetPos(pos)
            ply:SetEyeAngles(ang)
            ply:SetTeam(TEAM_COMPLETED_MAP)
        end
    end

    if ent:GetName() == "went1" and input:lower() == "disable" and !ent.lol then
        ent.lol = true
        timer.Simple(0.7, function()
            if !IsValid(ent) then return end
            net.Start("hl2ce_map_event")
            net.WriteString("noclip")
            net.Broadcast()
        end)
    end

    if ent:GetName() == "train5" and input:lower() == "startforward" then
        PrintMessage(3, "RUN!!!")
    end

    -- if ent:GetName() == "lua0" and input:lower() == "runcode" then
    --     local e = ents.FindByName("kostil0")[1]
    --     if e and IsValid(e) then
    --         e:Remove()
    --     end

    --     return true
    -- end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
