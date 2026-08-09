NEXT_MAP = "d1_trainstation_02_d"

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
    -- local maprestarts = GAMEMODE.MapRestarts

    -- ply:PrintMessage(3, "It's just you here.")
    -- timer.Simple(3, function()
    --     if maprestarts ~= GAMEMODE.MapRestarts then return end
    --     ply:PrintMessage(3, "No other human souls, or Xen creatures exist within this realm.")
    -- end)
    -- timer.Simple(7, function()
    --     if maprestarts ~= GAMEMODE.MapRestarts then return end
    --     ply:PrintMessage(3, "It's just you... and the world.")
    -- end)
    -- timer.Simple(7, function()
    --     if maprestarts ~= GAMEMODE.MapRestarts then return end
    --     ply:PrintMessage(3, "Or is it...")
    -- end)
end)

hook.Add("AcceptInput", "hl2ceAcceptInput", function(ent, input)
    if ent:GetName() == "song" and input:lower() == "playsound" then
        GAMEMODE.CampaignMapVars.SongStart = 0
    	GAMEMODE.CampaignMapVars.SongStartAt = RealTime()

        BroadcastLua(Format([[
            sound.PlayFile("sound/music/portal_self_esteem_fund.mp3", "noblock mono noplay", function(s)
                s:SetVolume(0.5)
                s:Play()
            end)
        ]], 0))

        return true
    end
end)

hook.Add("OnMapSwitch", "hl2ceSwitchMap", function()
	GAMEMODE.CampaignMapVars.SongStart = RealTime()+GAMEMODE.CampaignMapVars.SongStart-GAMEMODE.CampaignMapVars.SongStartAt
end)
