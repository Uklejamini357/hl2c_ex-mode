NEXT_MAP = "d3_c17_03"

TRIGGER_CHECKPOINT = {
	{ Vector( -5552, -5706, -4 ), Vector( -5505, -5537, 103 ) }
}

TRIGGER_DELAYMAPLOAD = { Vector( -5203, -4523, 0 ), Vector( -5143, -4483, 121 ) }

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
	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

function hl2cAcceptInput(ent, input, activator)
	if GAMEMODE.EXMode then
		if ent:GetName() == "dog_pickup_throwapc_1" and input:lower() == "start" then
			timer.Simple(1.5, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Chapter 10")
			end)

			timer.Simple(math.Rand(3.5, 4), function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Return to city 17")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
