NEXT_MAP = "d3_c17_13"


-- Player spawns
function hl2cPlayerSpawn( ply )

	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_357" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_ar2" )
	ply:Give( "weapon_rpg" )
	ply:Give( "weapon_crossbow" )
	ply:Give( "weapon_bugbait" )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Initialize entities
function hl2cMapEdit()

	ents.FindByName( "player_spawn_items_maker" )[ 1 ]:Remove()

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "entry_ceiling_breakable_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_debris_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_debris_clip_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_exp_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_exp_1" )[ 2 ]:Remove()
	
	end

end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )
