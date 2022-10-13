NEXT_MAP = "d2_coast_12"

COAST_PREVENT_CAMP_DOOR = false


-- Player spawns
function hl2cPlayerSpawn( ply )
	ply:SetName( "!player" )
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
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

hook.Add("OnEntityCreated", "HL2cEX_AntlionVariants", function(ent)
	if !GAMEMODE.EXMode or !ent:IsNPC() then return end
	if ent:GetClass() == "npc_antlion" then
		ent:SetColor(Color(128,255,0,255))
		timer.Simple(0, function()
			if !ent:IsValid() then return end
			ent:SetColor(Color(128,255,0,255))
			ent:SetMaxHealth(1.3 * ent:Health())
			ent:SetHealth(1.3 * ent:Health())
		end)
	elseif ent:GetClass() == "npc_antlionguard" then
		timer.Simple(0, function()
			if !ent:IsValid() then return end
			ent:SetMaxHealth(1.5 * ent:Health())
			ent:SetHealth(1.5 * ent:Health())
		end)
	end
end)

-- Initialize entities
function hl2cMapEdit()

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()

end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )


-- Accept input
function hl2cAcceptInput( ent, input )

	if GAMEMODE.EXMode then
		timer.Create("ActivateAntlionSpawningGlobal", 1, 0, function()
			if (IsValid(ents.FindByName("antlion_expanse_spawner_1")[1])) then ents.FindByName("antlion_expanse_spawner_1")[1]:Fire("Enable") end
		end)
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "tutorial_exit_conditions" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "tutorial_follow_enemy" )[ 1 ] ) ) then ents.FindByName( "tutorial_follow_enemy" )[ 1 ]:Fire( "Trigger" ) end
		if ( IsValid( ents.FindByName( "hudhint_squeezebait" )[ 1 ] ) ) then ents.FindByName( "hudhint_squeezebait" )[ 1 ]:Fire( "ShowHudHint", "", 3 ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_vort_follow" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "aisc_vort_follow" )[ 1 ] ) ) then ents.FindByName( "aisc_vort_follow" )[ 1 ]:Fire( "Kill" ) end
		if ( IsValid( ents.FindByName( "aigl_vort" )[ 1 ] ) ) then ents.FindByName( "aigl_vort" )[ 1 ]:Fire( "Activate" ) end
		if ( IsValid( ents.FindByName( "aigf_vort" )[ 1 ] ) ) then ents.FindByName( "aigf_vort" )[ 1 ]:Fire( "Kill" ) end
		if ( IsValid( ents.FindByName( "aisc_vort_lead_to_guard" )[ 1 ] ) ) then ents.FindByName( "aisc_vort_lead_to_guard" )[ 1 ]:Fire( "Enable" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_vort_lead_to_guard" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "aisc_vort_lead_to_guard" )[ 1 ] ) ) then ents.FindByName( "aisc_vort_lead_to_guard" )[ 1 ]:Fire( "Disable" ) end
		if ( IsValid( ents.FindByName( "aigl_vort" )[ 1 ] ) ) then ents.FindByName( "aigl_vort" )[ 1 ]:Fire( "Deactivate" ) end
		if ( IsValid( ents.FindByName( "aisc_vort_begin_extract" )[ 1 ] ) ) then ents.FindByName( "aisc_vort_begin_extract" )[ 1 ]:Fire( "Enable" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_vort_begin_extract" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "vortigaunt_bugbait" )[ 1 ] ) ) then ents.FindByName( "vortigaunt_bugbait" )[ 1 ]:Fire( "ExtractBugbait", "citizen_ambush_guard", 0.1 ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_waitforgordon" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "lcs_vort_in_camp_a" )[ 1 ] ) ) then ents.FindByName( "lcs_vort_in_camp_a" )[ 1 ]:Fire( "Resume" ) end
		if ( IsValid( ents.FindByName( "aisc_waitforgordon" )[ 1 ] ) ) then ents.FindByName( "aisc_waitforgordon" )[ 1 ]:Fire( "Kill" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_gordonlostinterest" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "lcs_vort_interrupted" )[ 1 ] ) ) then ents.FindByName( "lcs_vort_interrupted" )[ 1 ]:Fire( "Cancel" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && COAST_PREVENT_CAMP_DOOR && ( ent:GetName() == "camp_door" ) && ( string.lower( input ) == "close" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && COAST_PREVENT_CAMP_DOOR && ( ent:GetName() == "camp_door_blocker" ) && ( string.lower( input ) == "enable" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && COAST_PREVENT_CAMP_DOOR && ( ent:GetName() == "antlion_cage_door" ) && ( string.lower( input ) == "close" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "music_antlionguard_1" ) && ( string.lower( input ) == "playsound" ) ) then
	
		GAMEMODE:CreateSpawnPoint( Vector( 4393, 6603, 590 ), 65 )
	
	end

	if ( !game.SinglePlayer() && !COAST_PREVENT_CAMP_DOOR && ( ent:GetName() == "vortigaunt_bugbait" ) && ( string.lower( input ) == "extractbugbait" ) ) then
	
		COAST_PREVENT_CAMP_DOOR = true
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )
