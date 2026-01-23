NEXT_MAP = "ep1_citadel_04"
GM.XpGainOnNPCKillMul = 0.35
GM.DifficultyGainOnNPCKillMul = 0.5


TRIGGER_CHECKPOINT = {
	{Vector(1868, 11904, 4230), Vector(2000, 11632, 4416)},
	{Vector(1742, 10404, 5630), Vector(2010, 10856, 5744)},
}

-- TRIGGER_DELAYMAPLOAD = { Vector( 5120, 4840, -6720 ), Vector( 5136, 4480, -6480) }

INFO_PLAYER_SPAWN = {Vector(-714, 12184, 5368) , 0}

if CLIENT then return end

function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


hook.Add("Think", "hl2cThink", function()
	if game.GetGlobalState("super_phys_gun") == GLOBAL_ON then
		for _, ent in pairs( ents.FindByClass("weapon_*" ) ) do
			if ( IsValid( ent ) && ent:IsWeapon() && ( ent:GetClass() != "weapon_physcannon" ) && ( !IsValid( ent:GetOwner() ) || ( IsValid( ent:GetOwner() ) && ent:GetOwner():IsPlayer() ) ) ) then
				ent:Remove()
			end
		end
	end
end)

function hl2cMapEdit()
	game.SetGlobalState("super_phys_gun", GLOBAL_ON)

	ents.FindByName("global_newgame_template_base_items")[1]:Remove()

	local alyx = ents.Create("npc_alyx")
	alyx:SetName("alyx")
	alyx:SetKeyValue("GameEndAlly", "1")
	alyx:Give("weapon_alyxgun")
	alyx:SetPos(Vector(-761, 12192, 5312))
	alyx:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() and input:lower() == "scriptplayerdeath" then
		return
	end

	if ent:GetName() == "reload" and input:lower() == "reload" then
		return true
	end

	if !game.SinglePlayer() and ent:GetName() == "beam_core_death" and string.lower(input) == "turnon" then
		timer.Create("ep1_citadel_03_deathbeam_off", 1, 1, function()
			ent:Fire("turnoff")
		end)

		-- ent:SetKeyValue("LightningEnd", activator:GetName())

		if activator:Alive() then
			activator:Kill()
		end
		return true -- at this point it's better to just not run it at all because it can kill other players
	end

	if ent:GetName() == "super_phys_gun" and string.lower(input) == "turnoff" then
		for _,ply in ipairs(player.GetAll()) do
			ply:SetArmor(0)
		end
	end

	if GAMEMODE.EXMode and ent:GetName() == "relay_enteringcorecontrol" and input:lower() == "trigger" then
		timer.Simple(math.Rand(1,1.5), function()
			PrintMessage(3, "Chapter A2")
		end)

		timer.Simple(math.Rand(2.5,3), function()
			PrintMessage(3, "Delaying the inevitable")
		end)
	end

	if ent:GetName() == "lcs_core_control_scene" and input:lower() == "start" then
		GAMEMODE.MapVars.ReactorRoomTriggered = true
	end

	if !game.SinglePlayer() and ent:GetName() == "pclip_door1" and input:lower() == "enable" and GAMEMODE.MapVars.ReactorRoomTriggered then
		GAMEMODE.MapVars.ReactorRoomTriggered = nil

		GAMEMODE:ReplaceSpawnPoint(Vector(1232, 11860, 5312), -90)
		for _,pl in ipairs(player.GetLiving()) do
			if activator == pl then continue end
			pl:SetPos(Vector(1232, 11860, 5312))
			pl:SetEyeAngles(Angle(0, -90, 0))
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_core_control_scene" and input:lower() == "resume" then

		GAMEMODE:ReplaceSpawnPoint(Vector(1648, 11736, 4224))
		for _,pl in ipairs(player.GetLiving()) do
			if activator == pl then continue end
			pl:SetPos(Vector(1492, 11726, 5312))
			pl:SetEyeAngles(Angle(0, 180, 0))
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_alyx_corecomplete" and input:lower() == "resume" then
		GAMEMODE:ReplaceSpawnPoint(Vector(1512, 12126, 5312))
		for _,pl in ipairs(player.GetLiving()) do
			if activator == pl then continue end
			pl:SetPos(Vector(1512, 12126, 5312))
			pl:SetEyeAngles(Angle(0, 0, 0))
		end
	end

	if ent:GetName() == "Teleport_lift_doors" and input:lower() == "close" then
		for _,pl in ipairs(player.GetLiving()) do
			if activator == pl then continue end
			pl:SetPos(Vector(1152, 13626, 5292))
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)


local combinekilled = 0
function hl2cOnNPCKilled( ent, attacker, wep )
	local entname = ent:GetName()
	if entname == "npc_elite_controltype_1" or entname == "npc_elite_controltype_2" or entname == "npc_elite_controlroom" then
		combinekilled = combinekilled + 1
		print(combinekilled)

		if combinekilled == 5 then
			ents.FindByName("alyx")[1]:SetPos(Vector(1672, 12130, 5316))
		end
	end
end
hook.Add("OnNPCKilled", "hl2cOnNPCKilled", hl2cOnNPCKilled )


