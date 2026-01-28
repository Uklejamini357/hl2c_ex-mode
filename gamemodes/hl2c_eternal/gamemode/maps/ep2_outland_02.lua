
NEXT_MAP = "ep2_outland_03"

TRIGGER_CHECKPOINT = {
	{Vector(-2284, -9132, -716), Vector(-2516, -8900, -596)},
	-- {Vector(-3180, -9519, 111), Vector(-3060, -9434, 236)},
	{Vector(-3182, -9390, 112), Vector(-3308, -9519, 240)},
}

if CLIENT then return end

CUSTOM_NPC_KILLED_MESSAGE = "You failed to protect the vortigaunt from the antlion attacks!"

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_357")
	ply:Give("weapon_smg1")
	ply:Give("weapon_shotgun")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Player initial spawn
function hl2cPlayerInitialSpawn(ply)
end
hook.Add("PlayerInitialSpawn", "hl2cPlayerInitialSpawn", hl2cPlayerInitialSpawn)

-- Initialize entities
function hl2cPreMapEdit()
	if GAMEMODE.CampaignMapVars.ExtractObtained then
		INFO_PLAYER_SPAWN = {Vector(-3100, -9476, -3097), 0}
		NEXT_MAP = "ep2_outland_05"
		GAMEMODE.XP_REWARD_ON_MAP_COMPLETION = 0
	end
end
hook.Add("PreMapEdit", "hl2cPreMapEdit", hl2cPreMapEdit)

-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("spawnitems_template")[1]:Remove()

	if GAMEMODE.CampaignMapVars.ExtractObtained then
		local vort = ents.Create("npc_vortigaunt")
		vort:SetPos(Vector(-3100, -9500, -3097))
		vort:SetName("vort")
		vort:Spawn()
	end
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

-- Initialize entities
function hl2cOnEntityCreated(ent)
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		if ent:GetName() == "vort" then
			ent.allowDIE = true
		end
	end)
end
hook.Add("OnEntityCreated", "hl2cOnEntityCreated", hl2cOnEntityCreated)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() and ent:GetName() == "turret_arena_vcd_2" and string.lower(input) == "start" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end

			ply:SetPos(Vector(-3024, -9304, -894))
		end
		
		GAMEMODE:CreateSpawnPoint( Vector(-3024, -9304, -894), -90 )
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "turret_arena_vcd_1" and input:lower() == "start" then
			timer.Simple(1.3, function()
				if !IsValid(ent) then return end
				-- PrintMessage(3, "Chapter B2")
			end)

			timer.Simple(3.4, function()
				if !IsValid(ent) then return end
				-- PrintMessage(3, "The eternal loop >:)")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
