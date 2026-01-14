NEXT_MAP = "d2_coast_03"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)

	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_357" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_ar2" )

end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()

	game.SetGlobalState( "no_seagulls_on_jeep", GLOBAL_ON )

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()

	ents.FindByName( "jeep" )[ 1 ]:Fire( "EnableGun", "1" )
	ents.FindByName( "jeep" )[ 1 ]:SetBodygroup( 1, 1 )


	if GAMEMODE.EXMode then -- oh boy you AIN'T SURVIVING THE SANDS.
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_max", 38)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_regen_amount", 9)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_regen_time", 4)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_start", 13)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("MaxLiveChildren", 26)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("MaxNPCCount", 40)

		ents.FindByClass("phys_magnet")[1]:AddCallback("PhysicsCollide", function(ent, phys)
			timer.Simple(0.15, function()
				local eff = EffectData()
				eff:SetOrigin(phys.HitPos)
				for i=1,20 do
					util.Effect("Explosion", eff)
				end
			end)
		end)
	end
end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )


-- Accept input
function hl2cAcceptInput(ent, input, caller)
	local entname = ent:GetName()
	local inputlower = input:lower()

	if ( !game.SinglePlayer() && ( ent:GetName() == "logic_startcraneseq" ) && ( string.lower(input) == "trigger" ) ) then
	
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage( HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3)." )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "push_car_superjump_01" ) && string.lower(input) == "disable" ) then
		return true
	end

	if GAMEMODE.EXMode then
		if entname == "logic_vo_didntgetinjeep" and inputlower == "trigger" then
			caller:PrintMessage(3, "NO NO AND NO")
			caller:EnterVehicle(ents.FindByName("jeep")[1])
		end

		if entname == "logic_jeepflipped" and inputlower == "trigger" then
			for i=1,106 do
				timer.Simple(i/20, function()
					local ent = ents.Create("npc_antlion")
					ent:SetKeyValue("startburrowed", 1)
					ent:SetPos(ents.FindByName("jeep")[1]:GetPos() + Vector(math.random(-1000,1000), math.random(-1000,1000), 500))
					ent:SetAngles(Angle(0, math.Rand(-180, 180), 0))
					ent:DropToFloor()
					ent:Spawn()
					ent:Input("unburrow")
				end)
			end

			timer.Simple(3, function()
				PrintMessage(3, "Chapter 7")
			end)
			timer.Simple(5.6, function()
				PrintMessage(3, "welcome to the coast.")
			end)
		end
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
