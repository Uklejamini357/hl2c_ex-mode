NEXT_MAP = "d3_c17_10a"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)

	ply:Give("weapon_crowbar")
	ply:Give("weapon_pistol")
	ply:Give("weapon_smg1")
	ply:Give("weapon_357")
	ply:Give("weapon_frag")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_ar2")
	ply:Give("weapon_rpg")
	ply:Give("weapon_crossbow")
	ply:Give("weapon_bugbait")

end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("player_spawn_items_maker")[1]:Remove()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

function hl2cAcceptInput(ent, input)
	if GAMEMODE.EXMode then
		if ent:GetName() == "lcs_medic_greet" and input:lower() == "start" then
			timer.Simple(2.5, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Chapter 11")
			end)

			timer.Simple(math.Rand(4.4,5), function()
				if !IsValid(ent) then return end
				PrintMessage(3, "The Combine Hell")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
