INFO_PLAYER_SPAWN = {Vector(4935, -2887, 4), 90}

NEXT_MAP = "d3_citadel_01_d"

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	GAMEMODE.CampaignMapVars.SongStart = GAMEMODE.CampaignMapVars.SongStart or 0
	GAMEMODE.CampaignMapVars.SongStartAt = RealTime()

	ply:SendLua(string.format([[
		sound.PlayFile("sound/eateot/g1.mp3", "noblock mono noplay", function(s)
			s:SetVolume(0.2)
			s:SetTime(%s)
			s:Play()
			STATION = s		end)
	]], GAMEMODE.CampaignMapVars.SongStart))
end)

hook.Add("OnMapSwitch", "hl2ceSwitchMap", function()
	GAMEMODE.CampaignMapVars.SongStart = RealTime()+GAMEMODE.CampaignMapVars.SongStart-GAMEMODE.CampaignMapVars.SongStartAt
end)
