-- EX Mode for this map is work in progress.

NEXT_MAP = "d2_prison_07"

-- TRIGGER_DELAYMAPLOAD = { Vector( 420, 58, 9 ), Vector( 455, 157, 114 ) }

TRIGGER_CHECKPOINT = {
	{ Vector( 1415, 595, -192 ), Vector( 1456, 757, -31 ) }
}

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

	if !game.SinglePlayer() then
		ents.FindByName("pClip_introom_door_1")[1]:Remove()
	end
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


local function SpawnSoldier(wep, pos, ang, id)
	local ent = ents.Create("npc_combine_s")
	ent:SetModel("models/combine_soldier_prisonguard.mdl")
	ent:Give(wep)
	ent:SetPos(pos)
	ent:SetAngles(Angle(0, ang, 0))
	ent:SetName(id)
	ent:Spawn()
end

-- Accept input
function hl2cAcceptInput( ent, input, activator, caller, value )

	if ( !game.SinglePlayer() && ( ent:GetName() == "lcs_np_meetup03" ) && ( string.lower(input) == "resume" ) ) then
		for _, ply in ipairs(player.GetAll()) do
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 1570, 706, -680 ) )
			ply:SetEyeAngles( Angle( 0, -180, 0 ) )
		end
	end

	-- if ( !game.SinglePlayer() && ( ent:GetName() == "introom_door_1" ) && ( string.lower(input) == "setanimation" ) && ( value == "close" ) ) then
		-- return true
	-- end

	if ( !game.SinglePlayer() && ( ( ent:GetName() == "door_controlroom_1" ) || ( ent:GetName() == "door_room1_gate" ) ) && ( string.lower(input) == "close" ) ) then
		return true
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_np_cell01a" and input:lower() == "start" then
		local alyx = ents.FindByName("alyx")[1]
		alyx:SetPos(Vector(374, 200, 0))
	end

	if !game.SinglePlayer() and string.lower(ent:GetName()) == "sound_elipod_move_1" and string.lower(input) == "startscripting" then
		for _,ply in ipairs(player.GetAll()) do
			if ply == activator then continue end
			ply:SetPos(Vector(500, 100, 0))
		end
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "start_train_1_relay" and input:lower() == "trigger" then
			timer.Simple(2.5, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Chapter 9a")
			end)
			timer.Simple(math.Rand(4.5,5), function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Against all odds")
			end)
		end

		-- i would love to make the first room with more soldiers, but this breaks the script.
		if !GAMEMODE.MapVars.Room1SoldiersSpawned and ent:GetName() == "maker_croom1_1" and input:lower() == "spawn" then
			-- GAMEMODE.MapVars.Room1SoldiersSpawned = true

			-- SpawnSoldier("weapon_ar2", Vector(1084, 360, -192), 0, "room1_soldier")
			-- SpawnSoldier("weapon_shotgun", Vector(1424, 832, -192), -90, "room1_soldier")
			-- SpawnSoldier("weapon_shotgun", Vector(1338, 1128, -192), 180, "room1_soldier")
			-- SpawnSoldier("weapon_ar2", Vector(1248, 1216, -192), -90, "room1_soldier")
			-- SpawnSoldier("weapon_ar2", Vector(1120, 1216, -192), -90, "room1_soldier")
		end

		if ent:GetName() == "stair_soldiers_spawner" and input:lower() == "forcespawn" then
			SpawnSoldier("weapon_ar2", Vector(-144, 864, 0), 90, "room2_soldier")
			SpawnSoldier("weapon_ar2", Vector(-256, 848, 0), 90, "room2_soldier")
			SpawnSoldier("weapon_shotgun", Vector(128, 624, 0), 180, "room2_soldier")
			SpawnSoldier("weapon_shotgun", Vector(128, 720, 0), 180, "room2_soldier")
		end
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
