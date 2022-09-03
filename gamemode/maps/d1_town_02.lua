if ( file.Exists( "half-life_2_campaign/d1_town_03.txt", "DATA" ) ) then

	INFO_PLAYER_SPAWN = { Vector( -3755, -28, -3366 ), 45 }

	NEXT_MAP = "d1_town_02a"


	-- Player spawns
	function hl2cPlayerSpawn( ply )
	
		ply:Give( "weapon_crowbar" )
		ply:Give( "weapon_pistol" )
		ply:Give( "weapon_smg1" )
		ply:Give( "weapon_357" )
		ply:Give( "weapon_frag" )
		ply:Give( "weapon_physcannon" )
		ply:Give( "weapon_shotgun" )
	
	end
	hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )

else

	NEXT_MAP = "d1_town_03"


	-- Player spawns
	function hl2cPlayerSpawn( ply )
	
		ply:Give( "weapon_crowbar" )
		ply:Give( "weapon_pistol" )
		ply:Give( "weapon_smg1" )
		ply:Give( "weapon_357" )
		ply:Give( "weapon_frag" )
		ply:Give( "weapon_physcannon" )
	
	end
	hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )
	
	
	-- Accept input
	function hl2cAcceptInput( ent, input )
	
		if ( !game.SinglePlayer() && ( ent:GetName() == "freightlift_lift" ) && ( string.lower( input ) == "startforward" ) ) then
		
			for _, ply in pairs( player.GetAll() ) do
			
				ply:SetVelocity( Vector( 0, 0, 0 ) )
				ply:SetPos( Vector( -2943, 896, -3137 ) )
			
			end
			GAMEMODE:CreateSpawnPoint( Vector( -2944, 1071, -3520 ), -90 )
		
		end
	
	end
	hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )

end


-- Initialize entities
function hl2cMapEdit()

	ents.FindByName( "startobjects_template" )[ 1 ]:Remove()

end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )
