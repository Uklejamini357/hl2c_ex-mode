-- HL2 Alone Mod maps.
-- For personal use only.

local c = Color(255,255,255)
if SERVER then
    hook.Add("PlayerButtonDown", "hl2cePlayerButtonDown", function(pl, key)
        if key == KEY_ENTER then
            pl:SendLua([[if input.IsKeyDown(KEY_LALT) then
                gui.EnableScreenClicker(!vgui.CursorVisible())
            end]])
        end
    end)

    if !game.SinglePlayer() then
        hook.Add("DoPlayerDeath", "nil", function(pl)
            GAMEMODE:RestartMap(0)
            return true
        end)
    end

    hook.Add("PlayerDeathSound", "nil", function(pl)
        return true
    end)
elseif CLIENT then
    hook.Add("Think", "3123blah", function()
        local pl = LocalPlayer()
        if STATION and STATION:IsValid() then
            if pl:IsValid() and pl:Alive() then
                STATION:Play()
            else
                STATION:Pause()
            end
        end
    end)

    hook.Add("PreRender", "hl2cePreRender", function()
        local pl = LocalPlayer()
        if !pl:Alive() then
            cam.Start2D()
            draw.SimpleText("[SIGNAL LOST]", "Trebuchet24", ScrW()/2, ScrH()/2, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End2D()
            RunConsoleCommand("stopsound")
            c.a = c.a - 10*FrameTime()
            return true
        else
            c.a = 255
        end
    end)
end

hook.Add("PlayerSpawnReady", "AloneMod.hl2cePlayerInitialSpawn", function(ply)
    if game.SinglePlayer() then return end
    ply:PrintMessage(3, "These maps are best played at singleplayer.")
end)

hook.Add("MapEdit", "ohmygodstfu", function()
	for _,ent in ipairs(ents.FindByName("text_*")) do
		ent:Remove()
	end

    local ent = ents.FindByName("c")[1]
    if ent then
        ent:Remove()
    end

	local ent = ents.FindByName("t")[1]
    if ent then
        ent:Remove()
    end

	local ent = ents.FindByName("t2")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("player_spawn_template")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("player_items_template")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("player_spawn_items_maker")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("player_spawn_items_template")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("global_newgame_template")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("global_newgame_template_ammo")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("global_newgame_template_local_items")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("global_newgame_template_base_items")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("global_newgame_entmaker")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("startobjects_template")[1]
    if ent then
        ent:Remove()
    end

    local ent = ents.FindByName("spawn_items_template")[1]
    if ent then
        ent:Remove()
    end
end)
