-- EX Mode for this map is work in progress.

NEXT_MAP = "d2_prison_07"

-- TRIGGER_DELAYMAPLOAD = { Vector( 420, 58, 9 ), Vector( 455, 157, 114 ) }

TRIGGER_CHECKPOINT = {
	{Vector(1415, 595, -192), Vector(1456, 757, -31)}
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

	return ent
end

-- Accept input
function hl2cAcceptInput(ent, input, activator, caller, value)
	if !game.SinglePlayer() and ent:GetName() == "lcs_np_meetup03" and string.lower(input) == "resume" then
		for _, ply in ipairs(player.GetAll()) do
			ply:SetVelocity(Vector(0, 0, 0))
			ply:SetPos(Vector(1570, 706, -680))
			ply:SetEyeAngles(Angle(0, -180, 0))
		end
	end

	-- if !game.SinglePlayer() and ent:GetName() == "introom_door_1" and string.lower(input) == "setanimation" and value == "close" then
	-- 	-- return true
	-- end

	if !game.SinglePlayer() and (ent:GetName() == "door_controlroom_1" or ent:GetName() == "door_room1_gate") and string.lower(input) == "close" then
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

	if !game.SinglePlayer() and ent:GetName() == "lcs_np_cell01b" and input:lower() == "start" then
		timer.Create("eli_scene.timeout", 15, 1, function()
			if !IsValid(ent) then return end
			ent:Fire("Cancel")
			ents.FindByName("lcs_np_cell02")[1]:Fire("Start")
		end)
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_np_cell01b" and input:lower() == "cancel" then
		if timer.Exists("eli_scene.timeout") then
			timer.Remove("eli_scene.timeout")
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_np_cell02" and input:lower() == "start" then
		ents.FindByName("introom_door_1")[1]:Fire("SetAnimation", "close")
		ents.FindByName("introom_door_1")[1]:Fire("Close")

		for _,ply in ipairs(player.GetAll()) do
			if ply == activator then continue end
			ply:SetPos(Vector(550, 106, 0))
		end

		timer.Create("eli_scene_02.timeout", 90, 1, function()
			if !IsValid(ent) then return end
			ents.FindByName("alyx")[1]:SetPos(Vector(580, 204, 0))
			-- ent:Fire("Cancel")
			-- ents.FindByName("lcs_np_cell02")[1]:Fire("Start")
		end)
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
		-- if !GAMEMODE.MapVars.Room1SoldiersSpawned and ent:GetName() == "maker_croom1_1" and input:lower() == "spawn" then
			-- GAMEMODE.MapVars.Room1SoldiersSpawned = true

			-- SpawnSoldier("weapon_ar2", Vector(1084, 360, -192), 0, "room1_soldier")
			-- SpawnSoldier("weapon_shotgun", Vector(1424, 832, -192), -90, "room1_soldier")
			-- SpawnSoldier("weapon_shotgun", Vector(1338, 1128, -192), 180, "room1_soldier")
			-- SpawnSoldier("weapon_ar2", Vector(1248, 1216, -192), -90, "room1_soldier")
			-- SpawnSoldier("weapon_ar2", Vector(1120, 1216, -192), -90, "room1_soldier")
		-- end

		if ent:GetName() == "stair_soldiers_spawner" and input:lower() == "forcespawn" then
			local tbl = {
				SpawnSoldier("weapon_ar2", Vector(-144, 864, 0), 90, "room2_soldier"),
				SpawnSoldier("weapon_ar2", Vector(-256, 848, 0), 90, "room2_soldier"),
				SpawnSoldier("weapon_shotgun", Vector(128, 624, 0), 180, "room2_soldier"),
				SpawnSoldier("weapon_shotgun", Vector(128, 720, 0), 180, "room2_soldier")
			}

			local alyx = ents.FindByName("alyx")[1]
			for _,ent in ipairs(tbl) do
				if alyx then
					ent:SetEnemy(alyx)
					ent:UpdateEnemyMemory(alyx, alyx:GetPos())
				end

				ent:SetLastPosition(Vector(816, 640, -192))
				ent:SetSchedule(SCHED_FORCED_GO_RUN)
			end
		end

		-- first gate (I wish this section had nodegraph.)
		if ent:GetName() == "logic_room1_gate" and input:lower() == "trigger" then
			local tbl = {
				SpawnSoldier("weapon_ar2", Vector(508, -1700, 0), 90, "gate1_soldier"),
				SpawnSoldier("weapon_ar2", Vector(562, -1700, 0), 90, "gate1_soldier"),
			}

			for _,ent in ipairs(tbl) do
				ent:SetEnemy(activator)
				ent:UpdateEnemyMemory(activator, activator:GetPos())

				ent:SetLastPosition(Vector(536, -1008, 0))
				ent:SetSchedule(SCHED_FORCED_GO_RUN)
			end
		end

		-- blocked gate
		if ent:GetName() == "logic_room1_blockedgate" and input:lower() == "trigger" then
			local tbl = {
				SpawnSoldier("weapon_ar2", Vector(776, -2288, 0), 180, "blockedgate1_soldier"),
				SpawnSoldier("weapon_ar2", Vector(776, -2432, 0), 180, "blockedgate1_soldier"),
			}

			for _,ent in ipairs(tbl) do
				ent:SetEnemy(activator)
				ent:UpdateEnemyMemory(activator, activator:GetPos())

				ent:SetLastPosition(Vector(530, -2156, 0))
				ent:SetSchedule(SCHED_FORCED_GO_RUN)
			end
		end

		-- vent
		if ent:GetName() == "lcs_np_al_room2_vent" and input:lower() == "start" then
			SpawnSoldier("weapon_ar2", Vector(2032, -2050, -240), -135, "gate2_solier")
		end

		-- 2nd gate
		if ent:GetName() == "lcs_np_al_room2_gate" and input:lower() == "start" then
		end

		-- ambush
		if ent:GetName() == "logic_room2_ambush" and input:lower() == "trigger" then
			local tbl = {
				SpawnSoldier("weapon_ar2", Vector(1165, -2839, -240), 180, "ambush_soldier"),
				SpawnSoldier("weapon_ar2", Vector(954, -2716, -240), 180, "ambush_soldier"),
				SpawnSoldier("weapon_shotgun", Vector(954, -2614, -240), 180, "ambush_soldier"),
				SpawnSoldier("weapon_shotgun", Vector(1216, -2920, -240), 90, "ambush_soldier"),
				SpawnSoldier("weapon_shotgun", Vector(1216, -2980, -240), 90, "ambush_soldier"),
			}

			for _,ent in ipairs(tbl) do
				ent:SetEnemy(activator)
				ent:UpdateEnemyMemory(activator, activator:GetPos())

				ent:SetLastPosition(Vector(1494, -2428, -240))
				ent:SetSchedule(SCHED_FORCED_GO_RUN)
			end
		end
		
		-- shield off
		if ent:GetName() == "physbox_room3_plug" and input:lower() == "enablemotion" then
			GAMEMODE.MapVars.WhoDisabledShield = activator
		end

		if ent:GetName() == "logic_room3_field_disabled" and input:lower() == "trigger" then
			local tbl = {
				SpawnSoldier("weapon_shotgun", Vector(660, -2786, -240), -45, "forcefield_soldier"),
				SpawnSoldier("weapon_shotgun", Vector(660, -2716, -240), -90, "forcefield_soldier"),
				SpawnSoldier("weapon_ar2", Vector(416, -2592, -240), 0, "forcefield_soldier"),
				SpawnSoldier("weapon_ar2", Vector(416, -2656, -240), 0, "forcefield_soldier"),
				SpawnSoldier("weapon_ar2", Vector(736, -1940, -240), -90, "forcefield_soldier"),
				SpawnSoldier("weapon_ar2", Vector(580, -1940, -240), -90, "forcefield_soldier"),
			}

			for _,ent in ipairs(tbl) do
				if GAMEMODE.MapVars.WhoDisabledShield then
					ent:SetEnemy(GAMEMODE.MapVars.WhoDisabledShield)
					ent:UpdateEnemyMemory(GAMEMODE.MapVars.WhoDisabledShield, GAMEMODE.MapVars.WhoDisabledShield:GetPos())
				end

				ent:SetLastPosition(Vector(1158, -3188, -240))
				ent:SetSchedule(SCHED_FORCED_GO_RUN)
			end
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
