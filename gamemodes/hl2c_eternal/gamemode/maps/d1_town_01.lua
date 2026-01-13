NEXT_MAP = "d1_town_01a"

if CLIENT then
	local real = nil
	net.Receive("hl2ce_map_event", function()
		local event = net.ReadString()
		if event == "hl2c_hyperex_fuckedup" then
			real = true
			local last = CurTime()
			-- MY EYES!!! MY EYEEESS!!!!!!
			hook.Add("RenderScreenspaceEffects", "hl2chypere_fucked_up", function()
				local idk = math.min(CurTime()-last-1, 4)
				if idk < 0 then return end
				local cols = {
					["$pp_colour_addr"] = math.Rand(0, math.min(2, idk*0.2)),
					["$pp_colour_addg"] = math.Rand(0, math.min(2, idk*0.2)),
					["$pp_colour_addb"] = math.Rand(0, math.min(2, idk*0.2)),
					["$pp_colour_brightness"] = math.Rand(0, math.min(0.1, idk*0.01)),
					["$pp_colour_contrast"] = 1 + math.Rand(0, math.min(0.1, idk*0.01)),
					["$pp_colour_colour"] = 1,
					["$pp_colour_mulr"] = math.min(3.2, 1 + idk)^3 + idk,
					["$pp_colour_mulg"] = 1 + math.Rand(0, math.min(8, idk*0.3)),
					["$pp_colour_mulb"] = 1 + math.Rand(0, math.min(8, idk*0.3))
				}

				DrawColorModify(cols)
			end)

			-- ow my ears
			for i=1,4 do
				sound.PlayFile("sound/music/ravenholm_1.mp3", "", function(station)
					if station then
						station:SetVolume(93)
						station:SetPlaybackRate(1)
					end
				end)
			end

			timer.Simple(20, function()
				if !real then return end
				hook.Add("RenderScreenspaceEffects", "hl2chypere_fucked_up", function()
					local idk = (last+25)-CurTime() < 0 and math.sin(CurTime()-(last+25))*0.2 or (last+25)-CurTime()
					local cols = {
						["$pp_colour_addr"] = math.Rand(0, math.min(2, idk*0.2)),
						["$pp_colour_addg"] = math.Rand(0, math.min(2, idk*0.2)),
						["$pp_colour_addb"] = math.Rand(0, math.min(2, idk*0.2)),
						["$pp_colour_brightness"] = math.Rand(0, math.min(1, idk*0.05)),
						["$pp_colour_contrast"] = 1 + math.Rand(0, math.min(1, idk*0.05)),
						["$pp_colour_colour"] = 1 + math.Rand(0, math.min(0.5, idk*0.05)),
						["$pp_colour_mulr"] = math.min(3.2, 1 + idk)^3 + idk,
						["$pp_colour_mulg"] = 1 + math.Rand(0, math.min(8, idk*0.3)),
						["$pp_colour_mulb"] = 1 + math.Rand(0, math.min(8, idk*0.3))
					}

					DrawColorModify(cols)
				end)


				for i=1,100 do
					timer.Simple(i*0.05, function()
						if i == 100 then
							RunConsoleCommand("stopsound")
							return
						end
						if !real then return end

						local e = EffectData()
						e:SetOrigin(LocalPlayer():GetPos())
						for i=1,4 do
							util.Effect("Explosion", e)
						end
					
						sound.PlayFile("sound/weapons/explode"..math.random(3,5)..".wav", "", function(station)
							if station then
								station:SetVolume(8)
							end
						end)
					end)
				end
			end)

		elseif event == "hl2c_hyperex_unfuckedup" then
			real = nil
			hook.Remove("RenderScreenspaceEffects", "hl2chypere_fucked_up")
			RunConsoleCommand("stopsound")
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

local function SpawnZombie(class, pos, ang)
	local ent = ents.Create(class)
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()

	return ent
end

function hl2cAcceptInput(ent, input)
	if GAMEMODE.EXMode then
		if ent:GetName() == "start_music" and input:lower() == "playsound" then
			if GAMEMODE.HyperEXMode then -- WTF?! NEW EX MODE ALREADY?!
				net.Start("hl2ce_map_event")
				net.WriteString("hl2c_hyperex_fuckedup")
				net.Broadcast()

				for i=1,6 do
					if !IsValid(ent) then return end
					timer.Simple(0.3*i, function()
						if !IsValid(ent) then return end
						PrintMessage(3, "UR FUCKED")
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
							PrintMessage(3, GlitchedText(string.sub(s,1,i), 10 + i*2))
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
					-- timer.Create("HAHAHAHAHAHAHA", 0.05, 100, function()
					-- 	if !IsValid(ent) then return end
					-- 	if tonumber(timer.RepsLeft("HAHAHAHAHAHAHA")) == 0 then
					-- 		for _,ply in pairs(player.GetAll()) do
					-- 			ply:Spectate(OBS_MODE_ROAMING)
					-- 			ply:SetPos(Vector(math.random(-(2^17)+1, (2^17)-1), math.random(-(2^17)+1, (2^17)-1), math.random(-(2^17)+1, (2^17)-1)))
					-- 		end

					-- 		net.Start("hl2ce_map_event")
					-- 		net.WriteString("hl2c_hyperex_unfuckedup")
					-- 		net.Broadcast()

					-- 		return
					-- 	end

					-- 	changingLevel = nil
					-- 	gamemode.Call("FailMap", nil, GlitchedText("All players have died!!!", 100-tonumber(timer.RepsLeft("HAHAHAHAHAHAHA"))))
					-- 	for _,ply in pairs(player.GetAll()) do
					-- 		local e = EffectData()
					-- 		e:SetOrigin(ply:GetPos())
					-- 		ply:Kill()
					-- 		for i=1,20 do
					-- 			util.Effect("Explosion", e)
					-- 		end
					-- 		ply:SendLua([[
					-- 			sound.PlayFile("sound/weapons/explode"..math.random(3,5)..".wav", "", function(station)
					-- 			if station then
					-- 				station:SetVolume(8)
					-- 			end
					-- 		end)
					-- 		]])
					-- 	end
					-- end)
				end)

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
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

-- Initialize entities
function hl2cMapEdit()

	ents.FindByName( "player_spawn_template" )[ 1 ]:Remove()

	if GAMEMODE.EXMode then
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
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )

hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", function(ent, dmginfo)
	if !GAMEMODE.EXMode then return end
	if !ent:IsPlayer() then return end
	dmginfo:ScaleDamage(5)
end)

