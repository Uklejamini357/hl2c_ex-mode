INFO_PLAYER_SPAWN = {Vector( 3326, 4990, 1536), -90}

TRIGGER_CHECKPOINT = {
	{Vector(2846,-3537,1920), Vector(3036,-3360,1938)}
}

NEXT_MAP = "d2_coast_07"

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
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

function hl2cMapEdit()
	ents.FindByName("player_spawn_items_maker")[1]:Remove()
	ents.FindByName("jeep_filter")[1]:Fire( "AddOutput", "filterclass prop_vehicle_jeep_old" )

	local propblock = ents.Create( "prop_physics" )
	propblock:SetName( "prop_block" )
	propblock:SetPos( Vector( 3328, 5150, 1600 ) )
	propblock:SetModel( "models/props_wasteland/rockcliff01b.mdl" )
	propblock:DrawShadow( false )
	propblock:Spawn()
	propblock:Activate()
	propblock:GetPhysicsObject():EnableMotion( false )
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() and ent:GetName() == "button_press" and string.lower(input) == "trigger" then
		ents.FindByName("prop_block")[1]:Remove()

		-- for _, ply in ipairs(player.GetAll()) do
		-- 	if ply == activator then continue end

		-- 	ply:SetVelocity(-ply:GetVelocity())
		-- 	ply:SetPos(Vector(2991, -3426, 1932))
		-- 	ply:SetEyeAngles(Angle(0, 0, 0))
		-- end
		GAMEMODE:CreateSpawnPoint(Vector(2991, -3426, 1932), 0)

		GAMEMODE.CampaignMapVars.ForceFieldDeactivated = true
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

hook.Add("CompleteMap", "hl2c_PreventMapCompletion", function(pl)
	if !GAMEMODE.CampaignMapVars.ForceFieldDeactivated then
		pl:PrintMessage(3, "Nuh uh")
		pl:SetPos(Vector( 3326, 4990, 1536))
		pl:SetEyeAngles(Angle(0,-90,0))
		pl:SetVelocity(-pl:GetVelocity())
		return false
	end
end)

hook.Add("OnCheckpointActivated", "hl2c_Checkpoint_activated", function(pl)
	for _,ply in ipairs(player.GetLiving()) do
		ply:SetPos(pl:GetPos())
	end
end)
