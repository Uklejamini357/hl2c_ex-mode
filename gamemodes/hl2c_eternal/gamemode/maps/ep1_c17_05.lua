NEXT_MAP = "ep1_c17_06"

TRIGGER_DELAYMAPLOAD = {Vector(9888, 9664, -736), Vector(9632, 9536, -512)} -- Skip this map.

-- TRIGGER_CHECKPOINT = {
	-- {Vector(1088, 1974, -256), Vector(1216, 1942, -144), -90}
-- }

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_smg1")
	ply:Give("weapon_ar2")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

function hl2cPlayerInitialSpawn(ply)
end
hook.Add("PlayerInitialSpawn", "hl2cPlayerInitialSpawn", hl2cPlayerInitialSpawn)


-- Initialize entities
function hl2cMapEdit()
	-- local ent = ents.Create("base_ai")
	-- ent:Spawn()

	-- local ent = ents.Create("ai_goal_follow")
	-- ent:SetName("refugee_follow_player_1")
	-- ent:SetKeyValue("goal", "!player")
	-- ent:SetKeyValue("formation", "0")
	-- ent:SetKeyValue("actor", "citizen_refugees_1")
	-- ent:SetKeyValue("searchtype", "0")
	-- ent:SetKeyValue("startactive", "1")
	-- ent:Spawn()

	-- local ent = ents.Create("ai_goal_follow")
	-- ent:SetName("refugee_follow_player_2")
	-- ent:SetKeyValue("goal", "!player")
	-- ent:SetKeyValue("formation", "0")
	-- ent:SetKeyValue("actor", "citizen_refugees_2")
	-- ent:SetKeyValue("searchtype", "0")
	-- ent:SetKeyValue("startactive", "1")
	-- ent:Spawn()

	-- local ent = ents.Create("ai_goal_follow")
	-- ent:SetName("refugee_follow_player_3")
	-- ent:SetKeyValue("goal", "!player")
	-- ent:SetKeyValue("formation", "0")
	-- ent:SetKeyValue("actor", "citizen_refugees_3")
	-- ent:SetKeyValue("searchtype", "0")
	-- ent:SetKeyValue("startactive", "1")
	-- ent:Spawn()

	-- local ent = ents.Create("ai_goal_follow")
	-- ent:SetName("refugee_follow_player_4")
	-- ent:SetKeyValue("goal", "!player")
	-- ent:SetKeyValue("formation", "0")
	-- ent:SetKeyValue("actor", "citizen_refugees_4")
	-- ent:SetKeyValue("searchtype", "0")
	-- ent:SetKeyValue("startactive", "1")
	-- ent:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "relay_pickup_citizens" and input:lower() == "trigger" then
		ents.FindByName("citizen_refugees_1")[1]:UseFollowBehavior()
		ents.FindByName("citizen_refugees_2")[1]:UseFollowBehavior()
		ents.FindByName("citizen_refugees_3")[1]:UseFollowBehavior()
		ents.FindByName("citizen_refugees_4")[1]:UseFollowBehavior()
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "lcs_al_c17_05_barneyoverhere" and input:lower() == "start" then
			timer.Simple(1.3, function()
				PrintMessage(3, "Chapter A5")
			end)
			timer.Simple(3.7, function()
				PrintMessage(3, "Map needs a fix, sorry.")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

hook.Add("OnMapCompleted", "hl2ceOnMapCompleted", function()
	PrintMessage(3, "Fuck this map.")
end)

