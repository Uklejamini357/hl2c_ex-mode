ALLOWED_VEHICLE = "Jeep"

INFO_PLAYER_SPAWN = { Vector( 2087, -5411, 1375 ), 0 }

NEXT_MAP = "d2_coast_11"

if CLIENT then return end

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

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Initialize entities
function hl2cMapEdit()

	game.SetGlobalState( "no_seagulls_on_jeep", GLOBAL_ON )

	ents.FindByName( "player_spawn_items_maker" )[ 1 ]:Remove()
	ents.FindByName( "jeep_filter" )[ 1 ]:Fire( "AddOutput", "filterclass prop_vehicle_jeep_old" )

	if ( !game.SinglePlayer() ) then
	
--		ents.FindByName( "push_brush" )[ 1 ]:Remove()
	
	end

end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )


-- Accept input
function hl2cAcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "greeter_briefing_conditions" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "briefing_relay" )[ 1 ] ) ) then ents.FindByName( "briefing_relay" )[ 1 ]:Fire( "Trigger" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "garage_door" ) && ( string.lower( input ) == "close" ) ) then
	
		ALLOWED_VEHICLE = nil
		PrintMessage( HUD_PRINTTALK, "Vehicle spawning has been disabled." )
	
		for _, ply in pairs( player.GetAll() ) do
		
			if ( ply:InVehicle() ) then ply:ExitVehicle() end
			ply:RemoveVehicle()
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 4825, -235, 917 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 4825, -235, 917 ), -90 )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "lighthouse_secret_door" ) && ( string.lower( input ) == "close" ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )


if ( !game.SinglePlayer() ) then

	-- Entity takes damage
	function hl2cEntityTakeDamage( ent, dmgInfo )
	
		if ( IsValid( ent ) && ( ent:GetClass() == "npc_citizen" ) ) then
		
			return true
		
		end
	
	end
	hook.Add( "EntityTakeDamage", "hl2cEntityTakeDamage", hl2cEntityTakeDamage )

end
