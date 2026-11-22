NEXT_MAP = "ep2_outland_10a"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_357")
	ply:Give("weapon_smg1")
	ply:Give("weapon_ar2")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_crossbow")
	ply:Give("weapon_frag")
	-- ply:Give("weapon_rpg") -- if you knew the stash, then yes you would get one
end
hook.Add("PlayerSpawnLoadout", "hl2ce_PlayerLoadout", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()

end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if GAMEMODE.EXMode then
		if ent:GetName() == "prelude_soldier_wav" and input:lower() == "playsound" then
			PrintMessage(3, "TARGET ONE!!!!")
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
