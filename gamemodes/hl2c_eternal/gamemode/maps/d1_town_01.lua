NEXT_MAP = "d1_town_01a"


local obj_amount = 404
if CLIENT then
	hook.Add("HUDPaint", "Hl2ce_HyperEX_Progress", function()
		if !GAMEMODE.HyperEXMode then return end
		if !GAMEMODE.MapVars.NoChaos then return end

		draw.DrawText(string.format("Zombies killed: %d/%d", GAMEMODE.MapVars.ZombiesKilled, obj_amount), "hl2ce_hudfont_small", 5, 5, GAMEMODE.MapVars.ZombiesKilled > obj_amount and Color(0,255,0) or Color(255,255,0), TEXT_ALIGN_LEFT)
	end)

	net.Receive("hl2ce_map_event", function()
		local event = net.ReadString()
		if event == "hl2c_hyperex_fuckedup" then
			local true_crazy = net.ReadBool()
			GAMEMODE.MapVars.NoChaos = !true_crazy
			GAMEMODE.MapVars.Started = true
			local last = CurTime()
			-- MY EYES!!! MY EYEEESS!!!!!!
			if true_crazy then
				hook.Add("RenderScreenspaceEffects", "hl2chypere_fucked_up", function()
					local idk = math.min(CurTime()-last-1, true_crazy and 5*(GAMEMODE.NoEpilepsy and 0.1 or 1) or 1)
					if idk < 0 then return end
					local cols = {
						["$pp_colour_addr"] = math.Rand(0, math.min(2, idk*0.05)),
						["$pp_colour_addg"] = math.Rand(0, math.min(2, idk*0.05)),
						["$pp_colour_addb"] = math.Rand(0, math.min(2, idk*0.05)),
						["$pp_colour_brightness"] = math.Rand(0, math.min(0.1, idk*0.01)),
						["$pp_colour_contrast"] = 1 + math.Rand(0, math.min(0.1, idk*0.01)),
						["$pp_colour_colour"] = 1,
						["$pp_colour_mulr"] = math.min(3.2, 1 + idk)^3 + idk,
						["$pp_colour_mulg"] = 1 + math.Rand(0, math.min(8, idk*0.03)),
						["$pp_colour_mulb"] = 1 + math.Rand(0, math.min(8, idk*0.03))
					}

					DrawColorModify(cols)
				end)
			else
				hook.Add("RenderScreenspaceEffects", "hl2chypere_fucked_up", function()
					local idk = math.sin(CurTime()-last)
					local cols = {
						["$pp_colour_addr"] = math.Rand(0, math.min(2, idk*0.02)),
						["$pp_colour_addg"] = math.Rand(0, math.min(2, idk*0.02)),
						["$pp_colour_addb"] = math.Rand(0, math.min(2, idk*0.02)),
						["$pp_colour_brightness"] = math.Rand(0, math.min(1, idk*0.01)),
						["$pp_colour_contrast"] = 1 + math.Rand(0, math.min(1, idk*0.01)),
						["$pp_colour_colour"] = 1 + math.Rand(0, math.min(0.5, idk*0.01)),
						["$pp_colour_mulr"] = math.min(3.2, 1 + idk)^3 + idk,
						["$pp_colour_mulg"] = 1 + math.Rand(0, math.min(8, idk*0.03)),
						["$pp_colour_mulb"] = 1 + math.Rand(0, math.min(8, idk*0.03))
					}

					DrawColorModify(cols)
				end)
			end

			-- ow my ears
			if true_crazy then
				sound.PlayFile("sound/music/ravenholm_1.mp3", "", function(station)
					if station then
						station:SetVolume(GAMEMODE.NoEpilepsy and 4 or 370)
						station:SetPlaybackRate(1)
					end
				end)
			end
		elseif event == "hl2c_hyperex_fuckedup2" then
			local last = CurTime()
			hook.Add("RenderScreenspaceEffects", "hl2chypere_fucked_up", function()
				local a = 5
				local idk = (last+a)-CurTime() < 0 and math.sin(CurTime()-(last+a)) or (last+a)-CurTime()
				local cols = {
					["$pp_colour_addr"] = math.Rand(0, math.min(2, idk*0.02)),
					["$pp_colour_addg"] = math.Rand(0, math.min(2, idk*0.02)),
					["$pp_colour_addb"] = math.Rand(0, math.min(2, idk*0.02)),
					["$pp_colour_brightness"] = math.Rand(0, math.min(1, idk*0.01)),
					["$pp_colour_contrast"] = 1 + math.Rand(0, math.min(1, idk*0.01)),
					["$pp_colour_colour"] = 1 + math.Rand(0, math.min(0.5, idk*0.01)),
					["$pp_colour_mulr"] = math.min(3.2, 1 + idk)^3 + idk,
					["$pp_colour_mulg"] = 1 + math.Rand(0, math.min(8, idk*0.03)),
					["$pp_colour_mulb"] = 1 + math.Rand(0, math.min(8, idk*0.03))
				}

				DrawColorModify(cols)
			end)


			for i=1,100 do
				timer.Simple(i*0.05, function()
					if i == 100 then
						RunConsoleCommand("stopsound")
						return
					end
					if !GAMEMODE.MapVars.Started then return end

					local e = EffectData()
					e:SetOrigin(LocalPlayer():GetPos())
					for i=1,4 do
						util.Effect("Explosion", e)
					end

					sound.PlayFile("sound/weapons/explode"..math.random(3,5)..".wav", "", function(station)
						if station then
							station:SetVolume(GAMEMODE.NoEpilepsy and 1 or 8)
						end
					end)
				end)
			end
		elseif event == "hl2c_hyperex_unfuckedup" then
			GAMEMODE.MapVars.Started = nil
			hook.Remove("RenderScreenspaceEffects", "hl2chypere_fucked_up")
			RunConsoleCommand("stopsound")
		elseif event == "hl2c_hyperex_objective" then
			GAMEMODE.MapVars.ZombiesKilled = 0
			chat.AddText(Color(255,255,0), string.format("Objective: Kill %d zombies", obj_amount))
			chat.AddText(Color(255,160,0), string.format("The what?! %d ZOMBIES?!", obj_amount))
			chat.AddText(Color(255,60,0), string.format("THIS MAP GOT ONLY LESS THAN 50 ZOMBIES!! HOW CAN WE KILL %d ZOMBIES ON THIS MAP LIKE THAT?!?!?!?", obj_amount))
		elseif event == "hl2c_hyperex_objectiveprogress" then
			GAMEMODE.MapVars.ZombiesKilled = net.ReadUInt(16)
		elseif event == "hl2c_ex_mapstart" then
			LocalPlayer():EmitSound("music/hl2_song7.mp3", 0, 70)
			LocalPlayer():EmitSound("music/ravenholm_1.mp3", 0, 170)

			for i=1,4 do
				sound.PlayFile("sound/music/ravenholm_1.mp3", "", function(station)
					if station then
						station:SetVolume(math.Rand(0.5,0.9))
						station:SetPlaybackRate(math.Rand(2.5,5))
					end
				end)
			end
		end
	end)

	function InitMapVars(vars)
		vars.ZombiesKilled = 0
	end
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
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

local function hl2cHyperEXApplyNPCVariant(ent)
	if !GAMEMODE.HyperEXMode then return end

	if ent:GetClass() == "npc_zombie" then
		ent.VariantType = 2
	end
end
hook.Add("ApplyNPCVariant", "hl2cHyperEXApplyNPCVariant", hl2cHyperEXApplyNPCVariant)

local function hl2cHyperEXOnNPCKilled(ent)
	if !GAMEMODE.HyperEXMode then return end
	if ent:GetClass() == "npc_zombie" then
		local vars = GAMEMODE.MapVars
		local prev = vars.ZombiesKilled
		vars.ZombiesKilled = vars.ZombiesKilled + 1

		net.Start("hl2ce_map_event")
		net.WriteString("hl2c_hyperex_objectiveprogress")
		net.WriteUInt(vars.ZombiesKilled, 16)
		net.Broadcast()

		if vars.ZombiesKilled >= obj_amount and prev < obj_amount then
			BroadcastLua([[chat.AddText(Color(0,255,0), "Finally.. WE CAN GET OUT OF HERE!!")]])
		end
	end
end
hook.Add("OnNPCKilled", "hl2cHyperEXOnNPCKilled", hl2cHyperEXOnNPCKilled)


local function SpawnZombie(class, pos, ang)
	local ent = ents.Create(class)
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()

	return ent
end


function hl2cAcceptInput(ent, input)
	local entname = ent:GetName()
	local inputlower = input:lower()
	if GAMEMODE.EXMode then
		if entname == "start_music" and inputlower == "playsound" then
			if GAMEMODE.HyperEXMode then -- WTF?! NEW EX MODE ALREADY?!
				net.Start("hl2ce_map_event")
				net.WriteString("hl2c_hyperex_fuckedup")
				net.WriteBool(!GAMEMODE.MapVarsPersisting.AlreadyLost)
				net.Broadcast()

				if !GAMEMODE.MapVarsPersisting.AlreadyLost then
					for i=1,6 do
						if !IsValid(ent) then return end
						timer.Simple(0.3*i, function()
							if !IsValid(ent) then return end
							BroadcastLua([[chat.AddText(Color(255,0,0), "UR FUCKED")]])
							BroadcastLua(string.format([[chat.AddText(Color(255,0,0), "CRAZINESS: %d")]], (5+i*3)^(1+i*0.3)))
						end)
					end
					timer.Simple(2, function()
						if !IsValid(ent) then return end
						for i=1,6 do
							timer.Simple(i*0.08, function()
							if !IsValid(ent) then return end
								PrintMessage(3, GlitchedText("CHAPTER 6", 10 + i*5))
							end)
						end
					end)
					timer.Simple(2.8, function()
						if !IsValid(ent) then return end
						local s = "WELCOME TO HYPERHELL!!!!!!!!!!"
						for i=1,30 do
							timer.Simple(i*0.05, function()
							if !IsValid(ent) then return end
								PrintMessage(3, GlitchedText(string.sub(s,1,i-1), 10 + i*2)..s[i])
							end)
						end
					end)
					timer.Simple(10, function()
						if !IsValid(ent) then return end

						BroadcastLua([[chat.AddText(Color(255,0,0), GlitchedText("I came here to tell you", 10))]])
						timer.Simple(3, function()
							if !IsValid(ent) then return end
							BroadcastLua([[chat.AddText(Color(190,0,0), GlitchedText("that you fucked up", 20))]])
						end)
						timer.Simple(5, function()
							if !IsValid(ent) then return end
							BroadcastLua([[chat.AddText(Color(140,0,0), GlitchedText("real hard this time", 30))]])
						end)
						timer.Simple(7.6, function()
							if !IsValid(ent) then return end
							BroadcastLua([[chat.AddText(Color(140,0,0), GlitchedText("GOODBYE!!!", 50))]])
						end)
					end)

					timer.Simple(20, function()
						if !IsValid(ent) then return end
						GAMEMODE.MapVarsPersisting.AlreadyLost = true

						net.Start("hl2ce_map_event")
						net.WriteString("hl2c_hyperex_fuckedup2")
						net.Broadcast()

						timer.Create("HAHAHAHAHAHAHA", 0.05, 100, function()
							if !IsValid(ent) then return end
							if tonumber(timer.RepsLeft("HAHAHAHAHAHAHA")) == 0 then
								for _,ply in pairs(player.GetAll()) do
									ply:Spectate(OBS_MODE_ROAMING)
									ply:SetPos(Vector(math.random(-(2^17)+1, (2^17)-1), math.random(-(2^17)+1, (2^17)-1), math.random(-(2^17)+1, (2^17)-1)))
								end
							
								net.Start("hl2ce_map_event")
								net.WriteString("hl2c_hyperex_unfuckedup")
								net.Broadcast()
							
								return
							end
						
							changingLevel = nil
							GAMEMODE.DisableDataSave = true
							gamemode.Call("FailMap", nil, GlitchedText("All players have died!!!", 100-tonumber(timer.RepsLeft("HAHAHAHAHAHAHA"))))
							for _,ply in pairs(player.GetAll()) do
								ply:Kill()
								local rag = ply:GetRagdollEntity()
								if rag:IsValid() then
									rag:Remove()
								end
							end
						end)
					end)

					GAMEMODE.MapVarsPersisting.AlreadyLost = true
					return true
				end

				GAMEMODE.MapVars.Started = true
				GAMEMODE.MapVars.ZombiesKilled = 0
				net.Start("hl2ce_map_event")
				net.WriteString("hl2c_hyperex_objective")
				net.Broadcast()

				return true
			end

			timer.Simple(2, function() PrintMessage(3, "Chapter 6") end)
			timer.Simple(4, function()
				local s = "WELCOMETOHELL"
				for i=1,#s do
					timer.Simple(i*0.1, function()
						PrintMessage(3, s[i])
					end)
				end
			end)

			for i=1,3 do
				for j=1,3 do
					SpawnZombie("npc_fastzombie", Vector(4892-((math.floor(j/3)%3)*3)*36, -2316+((i%3)*3)*36, -3770), Angle(0,180,0))
				end
			end

			for i=1,7 do
				SpawnZombie("npc_fastzombie", Vector(3550+((i%3)*3)*50, -2260, -3900), Angle(0,0,0))
			end

			-- wtf?!
			net.Start("hl2ce_map_event")
			net.WriteString("hl2c_ex_mapstart")
			net.Broadcast()
			return true
		end

		if entname == "monk" and inputlower == "kill" then
			timer.Remove("Hl2c_EX_input1")
		end
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("player_spawn_template")[1]:Remove()

	if GAMEMODE.EXMode then
		if GAMEMODE.HyperEXMode then
			GAMEMODE.DisableDataSave = false
			GAMEMODE.MapVars.ZombiesKilled = 0
		end

		local prop = ents.Create("prop_dynamic")
		prop:SetPos(Vector(4384, -3026, -3766))
		prop:SetModel("models/props_lab/blastdoor001c.mdl")
		prop:Spawn()
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:AddCallback("PhysicsCollide", function(ent, data)
			local pl = data.HitEntity

			if pl:IsValid() and pl:IsPlayer() then
				if prop.what_question_mark[pl] and prop.what_question_mark[pl] > 100 then
					local e = EffectData()
					e:SetOrigin(pl:GetPos())
					pl:Kill()
					for i=1,69 do -- nice
						util.Effect("Explosion", e)
					end
					if pl:GetRagdollEntity():IsValid() then
						pl:GetRagdollEntity():Remove()
					end
				else
					pl:PrintMessage(3, GlitchedText("NO", prop.what_question_mark[pl] or 0))
					prop.what_question_mark[pl] = (prop.what_question_mark[pl] or 0) + 2
				end
			end
		end)
		prop.what_question_mark = {}

		local phys = prop:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:EnableMotion(false)
		end

		-- have to do this workaround. oh well, it works it works. not complaining
		ents.FindByClass("info_player_start")[1]:Remove()
		local plrspawn = ents.Create("info_player_start")
		plrspawn:SetPos(Vector(4266, -2924, -3760))
		plrspawn:SetAngles(Angle(0, 90, 0))
		plrspawn:Spawn()

		timer.Create("Hl2c_EX_input1", 0.325, 0, function()
			if !GAMEMODE.EXMode then timer.Remove("Hl2c_EX_input1") return end
			local e = ents.FindByName("grigori_pyre_script_door_1")[1]
			if !IsValid(e) then return end
			e:Fire("Toggle")

			if GAMEMODE.HyperEXMode then
				local eff = EffectData()
				eff:SetOrigin(e:GetPos())
				for i=1,3 do
					util.Effect("Explosion", eff)
				end
			end
		end)
		timer.Create("Hl2c_EX_input2", 5, 0, function()
			if !GAMEMODE.EXMode then timer.Remove("Hl2c_EX_input2") return end
			local e = ents.FindByName("crushtrap_02_switch_01")[1]
			if !IsValid(e) then return end
			e:Fire("Use")
			e:Fire("Unlock")

			timer.Adjust("Hl2c_EX_input2", timer.TimeLeft("Hl2c_EX_input2")*0.99, 0)
		end)

		net.Start("hl2ce_map_event")
		net.WriteString("hl2c_hyperex_unfuckedup")
		net.Broadcast()
	end
	
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

hook.Add("PlayerReady", "hl2ce_hyperEX_playerReady", function(ply)
	if !GAMEMODE.HyperEXMode then return end
	local vars = GAMEMODE.MapVars

	if !GAMEMODE.MapVarsPersisting.AlreadyLost then
		ply:PrintMessage(3, "BEWARE: This map has high flashing and epilepsy right at the start...")
		ply:PrintMessage(3, "Set volume to 0 and enable option to weaken light flashes in the options.")
		return
	end
	if !vars or !vars.Started then return end

	net.Start("hl2ce_map_event")
	net.WriteString("hl2c_hyperex_fuckedup")
	net.WriteBool(false)
	net.Broadcast()

	net.Start("hl2ce_map_event")
	net.WriteString("hl2c_hyperex_objective")
	net.Broadcast()

	net.Start("hl2ce_map_event")
	net.WriteString("hl2c_hyperex_objectiveprogress")
	net.WriteUInt(vars.ZombiesKilled, 16)
	net.Broadcast()
end)

hook.Add("CompleteMap", "hl2ce_hyperEX_", function(ply)
	if !GAMEMODE.HyperEXMode then return end

	local mapvars = GAMEMODE.MapVars
	if mapvars and (mapvars.ZombiesKilled or 0) < obj_amount then
		ply:SendLua([[chat.AddText(Color(255,0,0), "YOU DID NOT MEET THE REQUIREMENTS!")]])
		ply:Kill()
		local rag = ply:GetRagdollEntity()
		if rag and rag:IsValid() then
			rag:Dissolve()
		end
		return false
	end
end)

hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", function(ent, dmginfo)
	if !GAMEMODE.EXMode then return end
	if !ent:IsPlayer() then return end
	dmginfo:ScaleDamage(2.5)
end)

