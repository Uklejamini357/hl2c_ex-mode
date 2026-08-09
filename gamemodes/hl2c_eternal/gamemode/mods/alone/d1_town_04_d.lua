NEXT_MAP = "d1_town_05_d"

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	ply:EmitSound("@eateot/f6.mp3", 0, 100, 0.2)
end)
