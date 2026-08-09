NEXT_MAP = "d2_coast_10_d"

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	ply:EmitSound("@eateot/f2.mp3", 0, 92, 0.2)
end)

hook.Add("MapEdit", "jeep", function()
    if GAMEMODE.CampaignMapVars.GotJeep then
        ALLOWED_VEHICLE = "Jeep NoGun"
    end
end)
