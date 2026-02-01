NEXT_MAP = "d2_coast_03"

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
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	ALLOWED_VEHICLE = nil

	game.SetGlobalState( "no_seagulls_on_jeep", GLOBAL_ON )

	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()

	ents.FindByName("jeep")[1]:Fire( "EnableGun", "1" )
	ents.FindByName("jeep")[1]:SetBodygroup( 1, 1 )

	local ent = ents.Create("prop_dynamic")
	ent:SetModel("models/props_wasteland/cargo_container01.mdl")
	ent:SetPos(Vector(-8610, 512, 956))
	ent:SetAngles(Angle(0, 0, 0))

	if ent:PhysicsInit(SOLID_VPHYSICS) then
		ent:GetPhysicsObject():EnableMotion(false)
	end

	if GAMEMODE.EXMode then -- oh boy you AIN'T SURVIVING THE SANDS.
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_max", 38)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_regen_amount", 9)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_regen_time", 4)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("pool_start", 13)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("MaxLiveChildren", 26)
		ents.FindByName("antlion_spawner")[1]:SetKeyValue("MaxNPCCount", 40)

		ents.FindByClass("phys_magnet")[1]:AddCallback("PhysicsCollide", function(ent, phys)
			local hit = phys.HitEntity
			timer.Simple(0.15, function()
				local eff = EffectData()
				eff:SetOrigin(phys.HitPos)
				for i=1,20 do
					util.Effect("Explosion", eff)
				end

				hit:SetColor(HSVToColor(math.random(360), math.Rand(0,1), math.Rand(0,1)))
			end)
		end)
	end
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, caller)
	local entname = ent:GetName()
	local inputlower = input:lower()

	if !game.SinglePlayer() and entname == "logic_startcraneseq" and inputlower == "trigger" then
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage(HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3).")

		if GAMEMODE.EXMode then
			timer.Simple(2.1, function()
				PrintMessage(3, "Chapter 7")
			end)
			timer.Simple(4.6, function()
				PrintMessage(3, "The Coast of death")
			end)
		end
	end

	if !game.SinglePlayer() and entname == "push_car_superjump_01" and inputlower == "disable" then
		return true
	end

	if GAMEMODE.EXMode then
		if entname == "logic_vo_didntgetinjeep" and inputlower == "trigger" then
			caller:PrintMessage(3, "NO NO AND NO")
			caller:EnterVehicle(ents.FindByName("jeep")[1])
		end

		if entname == "logic_jeepflipped" and inputlower == "trigger" then
			for i=1,166 do
				timer.Simple(i/27, function()
					local ent = ents.Create("npc_antlion")
					ent:SetKeyValue("startburrowed", 1)
					if math.random(10) == 1 then
						ent:AddFlags(262144)
					end
					local a = 1500
					ent:SetPos(ents.FindByName("jeep")[1]:GetPos() + Vector(math.random(-a,a), math.random(-a,a), 500))
					ent:SetAngles(Angle(0, math.Rand(-180, 180), 0))
					ent:DropToFloor()
					ent:Spawn()
					local enemy = player.GetAll()[math.random(#player.GetAll())]
					ent:SetEnemy(enemy)
					ent:UpdateEnemyMemory(enemy, enemy:GetPos())
					ent:Input("unburrow")
				end)
			end
		end

		-- had to fix it, else it could just get overridden easily
		if entname == "antlion_spawner" and string.sub(inputlower, 1, 3) == "set" then
			return true
		end
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
