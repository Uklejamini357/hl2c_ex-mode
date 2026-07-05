NEXT_MAP = "d2_prison_08"

TRIGGER_CHECKPOINT = {
	{Vector(3488, -3472, -544), Vector(3664, -3312, -416)}
}

if CLIENT then
	net.Receive("hl2ce_map_event", function(len)
		local t = net.ReadString()

		if t == "2nddefroom" then
			chat.AddText(Color(255,0,0), "PREPARE FOR HELL.")
			chat.AddText(Color(255,120,0), "COMBINE ARRIVES IN... 15")
			
			for i=1,14 do
				timer.Simple(i, function()
					chat.AddText(Color(255,120,0), 15-i)
				end)
			end
		elseif t == "2nddefroomstart" then
			chat.AddText(Color(190,0,0), "HERE THEY COME!!!")
		end
	end)

	net.Receive("hl2ce_music", function()
		local bool = net.ReadBool()
		local sound = "#hl2c_eternal/music/chaos_defense.wav"
		local ply = LocalPlayer()

		if bool then
			GAMEMODE.MusicSound = CreateSound(ply, sound)
			GAMEMODE.MusicSound:SetSoundLevel(0)
			GAMEMODE.MusicSound:Play()
		else
			GAMEMODE.MusicSound:FadeOut(3)
		end
	end)
	return
end

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
hook.Add("PlayerSpawnLoadout", "hl2ce_PlayerLoadout", hl2cPlayerSpawn)

local function hl2cPlayerSpawn(ply)
	local turret_ai = ents.FindByName("relationship_turret_vs_player_like")[1]
	if IsValid(turret_ai) then
		turret_ai:Fire("ApplyRelationship")
	end
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	SECOND_DEFENSEROOM_COMPLETE = nil
	
	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()

	local turret_ai = ents.FindByName("relationship_turret_vs_player_like")[1]
	timer.Create("hl2cTurretRelationship", 1, 0, function()
		if IsValid(turret_ai) then
			turret_ai:Fire("ApplyRelationship")
		end
	end)
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

function hl2cOnEntityCreated(ent)
	if !ent:IsNPC() then return end
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		ent:AddRelationship("turret_buddy D_HT 99")

		for _,turret in ipairs(ents.FindByName("turret_buddy")) do
			turret:AddEntityRelationship(ent, D_HT, 99)
		end
	end)
end
hook.Add("OnEntityCreated", "hl2cOnEntityCreated", hl2cOnEntityCreated)


local function SpawnCombines(lower, upper)
	local ent1 = ents.FindByName("logic_room5_spawn_combine_lower")[1]
	local ent2 = ents.FindByName("logic_room5_spawn_combine_upper")[1]

	if lower and IsValid(ent1) then
		ent2:Fire("Trigger")
	end

	if upper and IsValid(ent2) then
		ent2:Fire("Trigger")
	end
end

local function TriggerEventDelayed(ent, time, func)
	timer.Simple(time, function()
		if !IsValid(ent) then return end
		if func then func() end
	end)
end

-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() and ent:GetName() == "door_croom2_gate" and string.lower(input) == "close" then
		return true
	end

	if !game.SinglePlayer() and ent:GetName() == "logic_room5_entry" and string.lower(input) == "trigger" then
		for _, ply in ipairs(player.GetAll()) do
			if ply == activator then continue end

			ply:SetVelocity(Vector(0, 0, 0))
			ply:SetPos(Vector(4161, -3966, -519))
			ply:SetEyeAngles(Angle(0, -90, 0))
		end
		GAMEMODE:CreateSpawnPoint(Vector(4710, -4237, -524), 180)
	end

	-- if you think you can cheese the 2nd room... too bad!
	-- cuz you will have a hell amount of combine soldiers you will have to deal with before being able to proceed :)
	-- and turrets aren't going to be able to handle them all alone
	-- AND, the room above which you'd use to skip this section... well, you can't anymore!
	if GAMEMODE.EXMode then
		if ent:GetName() == "logic_room5_entry" and string.lower(input) == "trigger" then
			local function SpawnTurret(pos, ang)
				local turret = ents.Create("npc_turret_floor")
				turret:SetName("turret_buddy")
				turret:SetPos(pos)
				turret:SetAngles(ang)
				turret:Spawn()

				turret:AddRelationship("npc_combine_s D_HT 99")
				turret:AddRelationship("npc_metropolice D_HT 99")
				turret:AddRelationship("npc_manhack D_HT 99")
			end

			for i=1,2 do
				SpawnTurret(Vector(4228, -4066, -538), Angle(0, -90, 0))
				SpawnTurret(Vector(4184, -4066, -538), Angle(0, -90, 0))
				SpawnTurret(Vector(4124, -4066, -538), Angle(0, -90, 0))
			end

			ents.FindByName("relationship_turret_vs_player_like")[1]:Fire("ApplyRelationship")
		end

		if ent:GetName() == "logic_room5_turretsdeployed" and input:lower() == "trigger" then
			net.Start("hl2ce_map_event")
			net.WriteString("2nddefroom")
			net.Broadcast()
		end


		if ent:GetName() == "lcs_message_room5_incoming" and input:lower() == "start" then
			net.Start("hl2ce_map_event")
			net.WriteString("2nddefroomstart")
			net.Broadcast()

			if GAMEMODE.HyperEXMode then
				FORCE_NPCVARIANT = 2
				local npc = ents.Create("npc_combine_s")
				npc.ent_MaxHealthMul = (npc.ent_MaxHealthMul or 1) * 150
				npc.ent_HealthMul = (npc.ent_HealthMul or 1) * 150
				npc.ent_Color = Color(255,0,0)
				npc:AddEFlags(EFL_NO_DISSOLVE)
				npc:SetModelScale(1.1)
				npc:SetPos(Vector(4717, -5001, -544))
				npc:Give("weapon_ar2")
				npc:Spawn()
				npc:SetLastPosition(Vector(4161, -3966, -519))
				npc:SetSchedule(SCHED_FORCED_GO_RUN)
				GAMEMODE:SetCurrentBoss(npc)

				timer.Simple(1, function()
					if !IsValid(npc) then return end
					npc:SetLastPosition(Vector(4161, -3966, -519))
					npc:SetSchedule(SCHED_FORCED_GO_RUN)

					local tbl = {}
					for _,pl in ipairs(player.GetLiving()) do
						tbl[#tbl+1] = {pl, pl:GetPos():Distance(npc:GetPos())}
					end
					table.sort(tbl, function(a,b) return a[2] < b[2] end)

					npc:SetEnemy(tbl[1][1])

					net.Start("hl2ce_boss")
					net.WriteEntity(npc)
					net.Broadcast()
				end)

				net.Start("hl2ce_music")
				net.WriteBool(true)
				net.Broadcast()
			end


			SpawnCombines(true, true)
			SpawnCombines(true, true)

			for i=1,8 do
				TriggerEventDelayed(ent, i*5, function()
					SpawnCombines(true, false)
				end)
			end

		end

		if ent:GetName() == "lcs_al_moresoldiers01" and input:lower() == "start" then
			local ag = ents.Create("npc_antlionguard")
			ag:AddFlags(FL_NOTARGET)
			ag:SetPos(Vector(3240, -4336, -400))
			ag.dontDIE = true
			ag:Spawn()

			local ag = ents.Create("npc_antlionguard")
			ag:AddFlags(FL_NOTARGET)
			ag:SetPos(Vector(3480, -4108, -400))
			ag:SetAngles(Angle(0,-90,0))
			ag.dontDIE = true
			ag:Spawn()

			for i=0,9 do
				TriggerEventDelayed(ent, 5+i*8, function()
					SpawnCombines(true, i%2==1)
				end)
			end
		end

		if ent:GetName() == "lcs_al_moresoldiers02" and input:lower() == "start" then
			for i=0,10 do
				TriggerEventDelayed(ent, i*4, function()
					SpawnCombines(true, true)
				end)
			end
		end

		if ent:GetName() == "lcs_al_moresoldiers04" and input:lower() == "start" then
			for i=0,20 do
				TriggerEventDelayed(ent, i*3, function()
					SpawnCombines(true, true)
				end)
			end
		end

		if ent:GetName() == "lcs_message_room5_done" and input:lower() == "start" then
		end

		if ent:GetName() == "logic_room5_assault_finished" and input:lower() == "trigger" then
			if !SECOND_DEFENSEROOM_COMPLETE then
				timer.Create("checkCombines", 1, 0, function()
					if !IsValid(ent) then timer.Remove("checkCombines") return end

					for _,e in ipairs(ents.FindInBox(Vector(3160,-5264-553), Vector(4880,-3010,-32))) do
						local class = e:GetClass()
						if class == "npc_combine_s" or class == "npc_metropolice" or class == "npc_manhack" then return end
					end

					SECOND_DEFENSEROOM_COMPLETE = true

					timer.Remove("checkCombines")
					ent:Fire("Trigger")
				end)
				return true
			end

			for k,v in ipairs(ents.FindByClass("npc_antlionguard")) do
				v.dontDIE = nil
				v:SetHealth(0)
				v:Dissolve()
				v:TakeDamage(9e999)
			end

			net.Start("hl2ce_music")
			net.WriteBool(false)
			net.Broadcast()
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
