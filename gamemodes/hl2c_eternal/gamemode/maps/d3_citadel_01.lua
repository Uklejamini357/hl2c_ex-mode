NEXT_MAP = "d3_citadel_02"

NEXT_MAP_PERCENT = 1
NEXT_MAP_INSTANT_PERCENT = 1

GM.XP_REWARD_ON_MAP_COMPLETION = 0.3

CITADEL_VEHICLE_ENTITY = nil

if CLIENT then
	hook.Add("RenderScreenspaceEffects", "hl2c_HyperEX_ColorMod", function()
		if !GAMEMODE.HyperEXMode then return end

		local tbl = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = -0.04,
			["$pp_colour_contrast"] = 0.7,
			["$pp_colour_colour"] = 0.3,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}

		DrawColorModify(tbl)
		DrawSobel(2)
	end)

	function InitMapVars(vars)
		vars.EncounterTbl = {active = true}
	end

	net.Receive("hl2ce_map_event", function()
		local event = net.ReadString()

		if event == "hl2ce_hyperex_timerstart" then
			local last = net.ReadFloat()
			local _start = last + net.ReadFloat()
			local _end = last + net.ReadFloat()
			hook.Add("HUDPaint", "Hl2ce_HyperEX_maptimer", function()
				local t = CurTime()-last
				draw.DrawText(string.format("Time passed: %02d:%02d", math.floor(t/60), math.floor(t)%60), "TargetIDSmall", ScrW()/2, ScrH()/3, CurTime() >= _start and CurTime() < _end and Color(0,255,0) or Color(255,0,0), TEXT_ALIGN_CENTER)
			end)


			local b = CurTime()
			local function a(t, func)
				b = math.max(b, CurTime()) + t
				timer.Simple(b-CurTime(), func)
			end


			local tbl = GAMEMODE.MapVars.EncounterTbl

			a(2, function()
				if !tbl.active then return end
				LocalPlayer():EmitSound("#music/hl1_song14.mp3", 0, 90)
			end)

			-- antimatter dimensions pelle's first encounter reference?
			a(3, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "Hi.")
			end)
			a(3, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "You are here.")
			end)
			a(3, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "You are trapped here.")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "Forever.")
			end)
			a(1.4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "Infinite.")
			end)
			a(1.4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "Eternal.")
			end)

			a(5, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "I have already won.")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "And since that is the case, I can monologue, or reminisce.")
			end)

			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "How long have we done this Chaos?")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "How many times have we been here before?")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "How many plans have you, Gordon Freeman, operated?")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "All to try and fulfill your Destiny?")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "And how many times have you fallen before catching up here?")
			end)
			a(3, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "Count them, if you remember.")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "Not even the Monarchs, the 11 named and the innumerable unnamed.")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "The complex, the irrational, those that go Missing.")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "Of course, the great Gordon does not remember this.")
			end)
			a(4, function()
				if !tbl.active then return end
				chat.AddText(Color(255,0,0), "All those Ends that you hide every time.")
			end)
		elseif event == "hl2ce_hyperex_kill" then
			local last = CurTime()
			hook.Add("RenderScreenspaceEffects", "!hl2c_HyperEX_ColorMod", function()
				if !GAMEMODE.HyperEXMode then return end

				local tbl = {
					["$pp_colour_addr"] = math.min((CurTime()-last)*2, 3),
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = -0.04,
					["$pp_colour_contrast"] = 0.7,
					["$pp_colour_colour"] = 0.3,
					["$pp_colour_mulr"] = math.min((CurTime()-last)*15, 25),
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0
				}

				DrawColorModify(tbl)
				DrawSobel(2-math.min((CurTime()-last)*1, 2))
			end)
		end
	end)
	hook.Add("OnMapRestart", "hl2ce_MapRestart", function()
		table.Empty(GAMEMODE.MapVars.EncounterTbl)
		hook.Remove("HUDPaint", "Hl2ce_HyperEX_maptimer")
		hook.Remove("RenderScreenspaceEffects", "!hl2c_HyperEX_ColorMod")
	end)

	return
end

local failer
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

	if IsValid(PLAYER_VIEWCONTROL) && PLAYER_VIEWCONTROL:GetClass() == "point_viewcontrol" then
		ply:SetViewEntity(PLAYER_VIEWCONTROL)
		ply:SetNoDraw(true)
		ply:DrawWorldModel( false )
		ply:Lock()
	
		ply:SetCollisionGroup( COLLISION_GROUP_WORLD )
		ply:CollisionRulesChanged()
	else
		ply:SetViewEntity(NULL)
		ply:SetNoDraw(false)
		ply:DrawWorldModel(true)
		ply:UnLock()
	
		ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		ply:CollisionRulesChanged()
	end
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

function hl2cEX_PlayerInitialSpawn(ply)
	if !GAMEMODE.EXMode then return end
end
hook.Add("PlayerInitialSpawn", "hl2cEX_InitialSpawn", hl2cEX_PlayerInitialSpawn)

function hl2cPlayerReady(ply)
	if not GAMEMODE.MapVars.TimerStart then return end
	net.Start("hl2ce_map_event")
	net.WriteString("hl2ce_hyperex_timerstart")
	net.WriteFloat(GAMEMODE.MapVars.TimerStart)
	net.WriteFloat(GAMEMODE.MapVars.OpportunityTimeStart)
	net.WriteFloat(GAMEMODE.MapVars.OpportunityTimeEnd)
	net.Broadcast()
end
hook.Add("PlayerReady", "hl2ce_PlayerReady", hl2cPlayerReady)

hook.Add("EntityTakeDamage", "hl2cEX_gimnick", function(target, dmginfo)
	if !GAMEMODE.EXMode then return end
	if target:IsPlayer() then
		target:SetHealth(0)
		dmginfo:SetDamage(1000)
	end
	dmginfo:SetDamageType(DMG_DISSOLVE)
end, HOOK_LOW)


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()

	if GAMEMODE.HyperEXMode then
		for _,npc in ipairs(ents.FindByClass("npc_*")) do
			npc:Remove() -- we never had a lifeless map didn't we?
		end
	elseif GAMEMODE.EXMode then
		local ent = ents.Create("npc_combine_s")
		ent:SetPos(Vector(10094,3364,-1470))
		ent:SetAngles(Angle(0,180,0))
		ent:Give("weapon_ar2")
		ent:Spawn()

		for i=1,10 do
			for j=1,10 do
				local prop = ents.Create("prop_physics")
				prop:SetPos(Vector(6666-j*64+math.random(100), 4800-i*64+math.random(100), 1300+math.random(500)))
				prop:SetModel(table.Random({
					"models/props_combine/weaponstripper.mdl",
					"models/props_combine/combine_barricade_short02a.mdl",
					"models/props_combine/combine_fence01a.mdl",
					"models/props_combine/combine_fence01b.mdl",
					"models/props_combine/combine_window001.mdl",
					"models/props_combine/headcrabcannister01a.mdl",
					"models/props_combine/combine_intmonitor001.mdl",
					"models/props_combine/combine_interface001.mdl",
					"models/props_combine/breenbust.mdl",
					"models/props_combine/breenchair.mdl",
					"models/props_combine/breenclock.mdl",
					"models/props_combine/breendesk.mdl",
					"models/props_combine/breenglobe.mdl",
					"models/breen.mdl"
				}))
				prop:Spawn()

				timer.Simple(8, function()
					if !IsValid(prop) then return end
					prop:Dissolve()
					timer.Simple(2, function()
						if !IsValid(prop) then return end
						local pos = prop:GetPos()
						local eff = EffectData()
						eff:SetOrigin(pos)
						util.Effect("Explosion", eff)
					end)
				end)
			end
		end
	end

	PLAYER_VIEWCONTROL = nil
	failer = nil
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, caller)
	if ( !game.SinglePlayer() && ent:GetClass() == "point_viewcontrol" ) then
		if string.lower(input) == "enable" then
			PLAYER_VIEWCONTROL = ent

			for _, ply in ipairs(player.GetAll()) do
				ply:SetViewEntity( ent )
				ply:SetNoDraw(true)
				ply:DrawWorldModel(false)
				ply:Lock()

				ply:SetCollisionGroup( COLLISION_GROUP_WORLD )
				ply:CollisionRulesChanged()
			end

			if !ent.doubleEnabled then
				ent.doubleEnabled = true
				ent:Fire( "Enable" )
			end
		elseif string.lower(input) == "disable" then
			PLAYER_VIEWCONTROL = nil

			for _, ply in ipairs(player.GetAll()) do
				ply:SetViewEntity(ply)
				ply:SetNoDraw(false)
				ply:DrawWorldModel(true)
				ply:UnLock()
				ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				ply:CollisionRulesChanged()
			end

			return true
		end
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "zapper_fade" ) && ( string.lower(input) == "fade" ) ) then
		if failer then
			gamemode.Call("FailMap", failer, "BRUHHHHHHHHHHH YOU TOOK THE WRONG POD WHAT IS WRONG WITH YOU?!")
		else
			caller:PrintMessage(3, "No.")
			return true
		end
		-- PrintMessage(3, "You failed the map. (You took wrong the wrong pod.)")
	end

	if failer and string.sub(ent:GetName(), 1, 9) == "playerpod" then
		return true
	end

	if GAMEMODE.HyperEXMode then
		if ent:GetClass() == "ambient_generic" then
			return true
		end

		if ent:GetClass() == "point_template" and input:lower() == "forcespawn" then
			return true
		end

		if ent:GetName() == "relay_crow_fly" and input:lower() == "trigger" then
			timer.Simple(2.5, function()
				PrintMessage(3, GlitchedText("Chapter 12", 12*math.pi))
			end)
			timer.Simple(5.1, function()
				BroadcastLua([[chat.AddText(Color(255,0,0), "[Chapter name error, please try again later.]")]])
			end)
		end

		if input:lower() ~= "use" then return true end
	elseif GAMEMODE.EXMode then
		if ent:GetName() == "relay_crow_fly" and input:lower() == "trigger" then
			timer.Simple(2.5, function()
				PrintMessage(3, "Chapter 12")
			end)
			timer.Simple(5.1, function()
				PrintMessage(3, "The near end.")
			end)
		end

		if ent:GetName() == "zapper_start" and input:lower() == "enablerefire" then
			local function func()
				if !IsValid(ent) then return end
				for _,ent in ents.Iterator() do
					local phys = ent.GetPhysicsObject and ent:GetPhysicsObject()
					if phys and phys:IsValid() then
						phys:AddVelocity(VectorRand()*math.random(1000))
						phys:AddAngleVelocity(VectorRand()*math.random(666))
					end
				end
			end
			func()
			timer.Create("ZAPPING!!!", 0.1, 21, func)
		end
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

function hl2cPlayerSay(ply, text)
	if !GAMEMODE.HyperEXMode then return end
	local vars = GAMEMODE.MapVars
	if !vars then return end

	if not (vars.TimerStart or vars.OpportunityTimeStart or vars.OpportunityTimeEnd) then return end
	if CurTime() < (vars.TimerStart + vars.OpportunityTimeStart) or CurTime() >= (vars.TimerStart + vars.OpportunityTimeEnd) then
		return
	end
	if ply:Team() ~= TEAM_ALIVE then return end

	if text == "!skip" then
		timer.Simple(0, function()
			gamemode.Call("CompleteMap", ply)
		end)

		return
	end
end
hook.Add("PlayerSay", "hl2cPlayerSay", hl2cPlayerSay)


-- Player entered vehicle
function hl2cPlayerEnteredVehicle(ply, vehicle)
	if game.SinglePlayer() then return end
	if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
		CITADEL_VEHICLE_ENTITY = vehicle
		if !failer and string.sub(vehicle:GetName(), 1, 9) == "zapperpod" then
			failer = ply

			if GAMEMODE.HyperEXMode then
				gamemode.Call("FailMap", failer, "you softlocked yourself")
			elseif GAMEMODE.EXMode then
				BroadcastLua([[chat.AddText(Color(255,0,0), "BOI YO FUCKED UP REAL HARD")]])
			else
				BroadcastLua([[chat.AddText(Color(255,0,0), "You picked the wrong pod.")]])
			end

			if GAMEMODE.EXMode then
				for _,e in pairs(ents.FindByName("playerpod*")) do
					e:Dissolve()
				end
			end
		elseif string.sub(vehicle:GetName(), 1, 9) == "playerpod" then
			if GAMEMODE.HyperEXMode then
				GAMEMODE.MapVars.TimerStart = CurTime()
				GAMEMODE.MapVars.OpportunityTimeStart = math.Rand(120, 300)
				GAMEMODE.MapVars.OpportunityTimeEnd = GAMEMODE.MapVars.OpportunityTimeStart + math.Rand(10, 15)

				net.Start("hl2ce_map_event")
				net.WriteString("hl2ce_hyperex_timerstart")
				net.WriteFloat(CurTime())
				net.WriteFloat(GAMEMODE.MapVars.OpportunityTimeStart)
				net.WriteFloat(GAMEMODE.MapVars.OpportunityTimeEnd)
				net.Broadcast()

				timer.Simple(GAMEMODE.MapVars.OpportunityTimeStart, function()
					if !IsValid(vehicle) then return end
					PrintMessage(3, "This might be the right time to escape.. type !skip to escape this endless loop!")
				end)

				timer.Simple(GAMEMODE.MapVars.OpportunityTimeEnd, function()
					if !IsValid(vehicle) then return end
					BroadcastLua([[chat.AddText(Color(255,0,0), "Farewell, then.")]])
				end)

				timer.Simple(GAMEMODE.MapVars.OpportunityTimeEnd + math.Rand(2,3), function()
					if !IsValid(vehicle) then return end
					if #team.GetPlayers(TEAM_COMPLETED_MAP) == 0 then
						gamemode.Call("FailMap", nil, "You failed to escape the endless trap!\nYou had the chance, but you blew it!")
					end

					net.Start("hl2ce_map_event")
					net.WriteString("hl2ce_hyperex_kill")
					net.Broadcast()

					for i=0,3 do
						timer.Simple(i*0.5, function()
							for _,ply in ipairs(player.GetLiving()) do
								if i == 3 then
									ply:Kill()
								else
									local dmg = DamageInfo()
									dmg:SetDamage(math.ceil(ply:Health()/4))
									dmg:SetDamageType(DMG_DIRECT + DMG_FALL)
									dmg:SetAttacker(ents.FindByClass("gmod_gamerules")[1])
									dmg:SetInflictor(ents.FindByClass("gmod_gamerules")[1])

									ply:TakeDamageInfo(dmg)

									if !ply:Alive() then
										local eff = EffectData()

									end
								end
							end
						end)
					end
				end)

				local eff = EffectData()
				for _,e in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
					if vehicle == e then continue end
					if not string.find(e:GetName(), "pod") then continue end

					e:Dissolve()
					timer.Simple(1.9, function()
						eff:SetOrigin(e:GetPos())
						for i=1,3 do
							util.Effect("Explosion", eff)
						end
						e:Remove()
					end)
				end
			end
		end

		local viewcontrol = ents.Create("point_viewcontrol")
		viewcontrol:SetName("pod_player_viewcontrol")
		viewcontrol:SetPos(CITADEL_VEHICLE_ENTITY:GetPos())
		viewcontrol:SetKeyValue("spawnflags", "12" )
		viewcontrol:Spawn()
		viewcontrol:Activate()
		viewcontrol:SetParent(CITADEL_VEHICLE_ENTITY)
		viewcontrol:Fire("SetParentAttachment", "vehicle_driver_eyes")
		viewcontrol:Fire("Enable", "", 0.1)


		timer.Create("hl2cUpdatePlayerPosition", 0.1, 0, hl2cUpdatePlayerPosition)
	end
end
hook.Add("PlayerEnteredVehicle", "hl2cPlayerEnteredVehicle", hl2cPlayerEnteredVehicle)


if !game.SinglePlayer() then
	-- Update player position to the vehicle
	function hl2cUpdatePlayerPosition()
		for _, ply in ipairs( team.GetPlayers( TEAM_ALIVE ) ) do
			if ( IsValid( ply ) && ply:Alive() && IsValid( CITADEL_VEHICLE_ENTITY ) ) then
				ply:SetPos( CITADEL_VEHICLE_ENTITY:GetPos() )
			end
		end
	end
end
