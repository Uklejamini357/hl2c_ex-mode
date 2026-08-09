NEXT_MAP = "d1_canals_01_d"
INFO_PLAYER_SPAWN = { Vector( -9961, -3668, 330 ), 90 }

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	GAMEMODE.CampaignMapVars.SongStart = GAMEMODE.CampaignMapVars.SongStart or 0
	GAMEMODE.CampaignMapVars.SongStartAt = RealTime()

	ply:SendLua(string.format([[
        sound.PlayFile("sound/music/portal_self_esteem_fund.mp3", "noblock mono noplay", function(s)
            s:SetVolume(0.5)
            s:SetTime(%s)
            s:Play()
        end)
    ]], GAMEMODE.CampaignMapVars.SongStart))
end)

hook.Add("OnMapSwitch", "hl2ceSwitchMap", function()
	GAMEMODE.CampaignMapVars.SongStart = nil
end)
