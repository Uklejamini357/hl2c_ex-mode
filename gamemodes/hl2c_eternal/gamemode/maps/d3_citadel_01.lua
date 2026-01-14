NEXT_MAP = "d3_citadel_02"

NEXT_MAP_PERCENT = 1
NEXT_MAP_INSTANT_PERCENT = 1

GM.XP_REWARD_ON_MAP_COMPLETION = 0.3

CITADEL_VEHICLE_ENTITY = nil

if CLIENT then return end

local failer
-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_357" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_ar2" )
	ply:Give( "weapon_rpg" )
	ply:Give( "weapon_crossbow" )
	ply:Give( "weapon_bugbait" )

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
	ents.FindByName("global_newgame_template_ammo" )[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()

	if GAMEMODE.EXMode then
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
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )


-- Accept input
function hl2cAcceptInput(ent, input, caller)
	if ( !game.SinglePlayer() && ent:GetClass() == "point_viewcontrol" ) then
		if string.lower(input) == "enable" then
			PLAYER_VIEWCONTROL = ent

			for _, ply in ipairs( player.GetAll() ) do
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
				ply:SetCollisionGroup( COLLISION_GROUP_PLAYER )
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

	if GAMEMODE.EXMode then
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


if ( !game.SinglePlayer() ) then

	-- Player entered vehicle
	function hl2cPlayerEnteredVehicle( ply, vehicle )
	
		if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
			CITADEL_VEHICLE_ENTITY = vehicle
			if !failer and string.sub(vehicle:GetName(), 1, 9) == "zapperpod" then
				failer = ply
				BroadcastLua([[chat.AddText(Color(255,0,0), "BOI YO FUCKED UP REAL HARD")]])
				for _,e in pairs(ents.FindByName("playerpod*")) do
					e:Dissolve()
				end
			-- elseif failer and string.sub(vehicle:GetName(), 1, 9) == "playerpod" then
			-- 	BroadcastLua([[chat.AddText(Color(0,255,0), "AY YO WTF.. HOW YOU CLUTCHED THIS!?!?")]])
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


	-- Update player position to the vehicle
	function hl2cUpdatePlayerPosition()
	
		for _, ply in ipairs( team.GetPlayers( TEAM_ALIVE ) ) do
		
			if ( IsValid( ply ) && ply:Alive() && IsValid( CITADEL_VEHICLE_ENTITY ) ) then
			
				ply:SetPos( CITADEL_VEHICLE_ENTITY:GetPos() )
			
			end
		
		end
	
	end

end
