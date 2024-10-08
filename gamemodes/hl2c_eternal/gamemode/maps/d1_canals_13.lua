ALLOWED_VEHICLE = "Airboat Gun"

NEXT_MAP = "d1_eli_01"

TRIGGER_DELAYMAPLOAD = { Vector( -762, -3866, -392 ), Vector( -518, -3845, -231 ) }

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn( ply )

	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_357" )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Initialize entities
function hl2cMapEdit()

	ents.FindByName( "global_newgame_template" )[ 1 ]:Remove()

end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )


hook.Add("AcceptInput", "hl2cAcceptInput", function(ent, input)
	if ent:GetName() == "relay_achievement_heli_1" and string.lower(input) == "trigger" then
		for _,ply in pairs(player.GetAll()) do
			ply:GiveXP(369)
		end
		print("heli died")
	end
end)