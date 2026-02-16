NEXT_MAP = "d2_coast_12"

COAST_PREVENT_CAMP_DOOR = false

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:SetName( "!player" )
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
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

hook.Add("PlayerReady", "hl2cPlayerReady", function(ply)
	timer.Simple(5, function()
		if !IsValid(ply) then return end
		ply:PrintMessage(3, "Pretty sure you know where this is going..")
	end)
end)

function hl2cEXPostApplyNPCVariant(ent, variant)
	if !GAMEMODE.EXMode then return end

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
end
hook.Add("PostApplyNPCVariant", "hl2cEXPostApplyNPCVariant", hl2cEXPostApplyNPCVariant)


-- Shouldn't cause the map to be stuck
local failmap = true
local failtries = 0
hook.Add("OnNPCKilled", "!!hl2ce_AGKilled", function(ent, attacker, inflictor)

	if ent:GetName() == "citizen_ambush_guard" and inflictor:IsValid() and inflictor:GetModel() == "models/props_junk/harpoon002a.mdl" then
		-- attacker:PrintMessage(3, "fuck yoself harpoon user")
	elseif ent:GetName() == "citizen_ambush_guard" and (!inflictor:IsValid() or inflictor:GetModel() ~= "models/props_junk/harpoon002a.mdl") then
		AG_DEADPOS = ent:GetPos()
		failmap = false
	end
end, HOOK_HIGH)

hook.Add("EntityRemoved", "NOANTLIONGUARDREMOVE", function(ent)
	if failmap and ent:GetName() == "citizen_ambush_guard" and not changingLevel then
		ents.FindByName("relay_guarddead")[1]:Fire("kill")
		if failtries > 10 then
			PrintMessage(3, "...")
			timer.Simple(math.Rand(2,5), function() PrintMessage(3, "I give up.") end)
			timer.Simple(math.Rand(8,9), function() GAMEMODE:SetDifficulty(InfNumber(6.66666, 666)) end)
			timer.Simple(math.Rand(9,10), function() PrintMessage(3, "Have fun.") end)
			timer.Simple(math.Rand(11,12), function()
				for _,ply in ipairs(player.GetLiving()) do gamemode.Call("CompleteMap", ply) end
			end)
		else
			gamemode.Call("FailMap", nil, failtries > 5 and "..." or
			failtries > 4 and "lose_attempt5" or
			failtries > 3 and "lose_attempt4" or
			failtries > 2 and "lose_attempt3" or
			failtries > 1 and "lose_attempt2" or
			"lose_attempt1")
			failtries = failtries + 1

			local e = EffectData()
			for _,ply in ipairs(player.GetLiving()) do
				e:SetOrigin(ply:GetPos() + ply:OBBCenter())
				for i=1,20 do
					util.Effect("Explosion", e)
				end
			
				ply:Kill()
				local rag = ply:GetRagdollEntity()
				if rag:IsValid() then
					rag:Remove()
				end
			end
		end
	end
end)

-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()

	failmap = true

	if GAMEMODE.EXMode then
		timer.Create("ActivateAntlionSpawningGlobal", 1, 0, function()
			local ent = ents.FindByName("antlion_expanse_spawner_1")[1]
			if ent and ent:IsValid() then
				-- ent:Fire("Disable")
				-- timer.Simple(0.1, function()
					ent:Fire("Enable")
				-- end)
			end
		end)
	else
		timer.Remove("ActivateAntlionSpawningGlobal")
	end
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

-- Accept input
function hl2cAcceptInput(ent, input)
	local entname = ent:GetName()
	local inputlower = input:lower()

	local e
	if !game.SinglePlayer() and entname == "tutorial_exit_conditions" and inputlower == "enable" then
		e = ents.FindByName("tutorial_follow_enemy")[1]
		if IsValid(e) then e:Fire("Trigger") end
		e = ents.FindByName("hudhint_squeezebait")[1]
		if IsValid(e) then e:Fire("ShowHudHint", "", 3) end
		return true
	end

	if !game.SinglePlayer() and entname == "aisc_vort_follow" and inputlower == "enable" then
		e = ents.FindByName("aisc_vort_follow")[1]
		if IsValid(e) then e:Fire("Kill") end
		e = ents.FindByName("aigl_vort")[1]
		if IsValid(e) then e:Fire("Activate") end
		e = ents.FindByName("aigf_vort")[1]
		if IsValid(e) then e:Fire("Kill") end
		e = ents.FindByName("aisc_vort_lead_to_guard")[1]
		if IsValid(e) then e:Fire("Enable") end
		return true
	end

	if !game.SinglePlayer() and entname == "aisc_vort_lead_to_guard" and inputlower == "enable" then
		e = ents.FindByName("aisc_vort_lead_to_guard")[1]
		if IsValid(e) then e:Fire("Disable") end
		e = ents.FindByName("aigl_vort")[1]
		if IsValid(e) then e:Fire("Deactivate") end
		e = ents.FindByName("aisc_vort_begin_extract")[1]
		if IsValid(e) then e:Fire("Enable") end
		return true
	end

	if !game.SinglePlayer() and entname == "aisc_vort_begin_extract" and inputlower == "enable" then
		e = ents.FindByName("vortigaunt_bugbait")[1]
		if IsValid(e) then e:Fire("ExtractBugbait", "citizen_ambush_guard", 0.1) end
		return true
	end

	if !game.SinglePlayer() and entname == "aisc_waitforgordon" and inputlower == "enable" then
		e = ents.FindByName("lcs_vort_in_camp_a")[1]
		if IsValid(e) then e:Fire("Resume") end
		e = ents.FindByName("aisc_waitforgordon")[1]
		if IsValid(e) then e:Fire("Kill") end
		return true
	end

	if !game.SinglePlayer() and entname == "aisc_gordonlostinterest" and inputlower == "enable" then
		e = ents.FindByName("lcs_vort_interrupted")[1]
		if IsValid(e) then e:Fire("Cancel") end
		return true
	end

	if !game.SinglePlayer() and COAST_PREVENT_CAMP_DOOR and entname == "camp_door" and inputlower == "close" then
		return true
	end

	if !game.SinglePlayer() and COAST_PREVENT_CAMP_DOOR and entname == "camp_door_blocker" and inputlower == "enable" then
		return true
	
	end

	if !game.SinglePlayer() and COAST_PREVENT_CAMP_DOOR and entname == "antlion_cage_door" and inputlower == "close" then
		return true
	end

	if !game.SinglePlayer() and entname == "music_antlionguard_1" and inputlower == "playsound" then
		GAMEMODE:CreateSpawnPoint( Vector( 4393, 6603, 590 ), 65 )
	end

	if !game.SinglePlayer() and !COAST_PREVENT_CAMP_DOOR and entname == "vortigaunt_bugbait" and inputlower == "extractbugbait" then
		COAST_PREVENT_CAMP_DOOR = true
	end

	if entname == "citizen_ambush_guard" and input:lower() == "unburrow" then
		if GAMEMODE.EXMode then
			timer.Simple(0, function() PrintMessage(3, "You") end)
			timer.Simple(0.3, function() PrintMessage(3, "have") end)
			timer.Simple(0.6, function() PrintMessage(3, "FUCKED") end)
			timer.Simple(0.9, function() PrintMessage(3, "UP") end)
		end

		timer.Simple(1, function()
			net.Start("hl2ce_boss")
			net.WriteEntity(ent)
			net.Broadcast()
		end)
	end

	if entname == "relay_guarddead" and inputlower == "trigger" then
		ents.FindByName("camp_door_blocker")[1]:Fire("Disable")
		ents.FindByName("camp_setup")[1]:Fire("Trigger")

		timer.Remove("ActivateAntlionSpawningGlobal")
		timer.Simple(0, function()
			local e = ents.FindByName("vortigaunt_bugbait")[1]
			if e and e:IsValid() then
				e:SetPos(AG_DEADPOS + Vector(0,0,16))
			end

			ents.FindByName("ss_bugbait_vort_wait")[1]:Fire("CancelSequence")
		end)
	end

	if entname == "camp_setup" and inputlower == "trigger" then
		for _,ply in ipairs(player.GetAll()) do
			ply:Give("weapon_bugbait")
		end
	end

	if entname == "lcs_getgoing" and inputlower == "start" then
		ents.FindByName("antlion_cage_door")[1]:Fire("Open")
		ents.FindByName("gate_linear")[1]:Fire("Open")
		ents.FindByName("gate_mover_blocker")[1]:Fire("disable")

		local e = ents.FindByName("vortigaunt_bugbait")[1]
		if e and e:IsValid() then
			e:SetPos(Vector(868, 11556, 512))
		end
	end

	if entname == "vortigaunt_bugbait" and inputlower == "startscripting" then
		return true
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
