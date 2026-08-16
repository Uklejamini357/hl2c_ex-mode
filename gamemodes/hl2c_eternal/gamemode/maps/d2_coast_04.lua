ALLOWED_VEHICLE = "Jeep"

NEXT_MAP = "d2_coast_05"

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
end
hook.Add("PlayerSpawnLoadout", "hl2ce_PlayerLoadout", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	game.SetGlobalState("no_seagulls_on_jeep", GLOBAL_ON)

	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()
	ents.FindByName("jeep_filter")[1]:Fire("AddOutput", "filterclass prop_vehicle_jeep_old")
	ents.FindByName("push_car_superjump_01")[1]:Fire("Enable")

	if !game.SinglePlayer() then
		ents.FindByName("antlion_spawner")[1]:Fire("AddOutput", "spawntarget jeep")
	end

	ents.FindByClass("prop_vehicle_crane")[1]:Remove() -- fuck the crane
	ents.FindByClass("phys_magnet")[1]:Remove()

	local ent = ents.FindByName("prop_catwalk")[1]
	if ent then
		local phys = ent:GetPhysicsObject()
		if phys then
			phys:SetVelocityInstantaneous(Vector(math.max(-1000, -56239865102398), 0, 0))
		end
	end
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "push_car_superjump_01" and string.lower(input) == "disable" then
		return true
	end

	if ent:GetName() == "dock_spawn" and input:lower() == "forcespawn" and not ents.FindByClass("prop_vehicle_crane")[1] then
		PrintMessage(3, "what the fuck, WHERE IS THE CRANE?!?!?!?") -- will revert this when the crane stops causing crashes on fucking prop collision
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
