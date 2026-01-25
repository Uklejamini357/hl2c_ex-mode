NEXT_MAP = "ep1_c17_05"

-- TRIGGER_CHECKPOINT = {
	-- {Vector(1088, 1974, -256), Vector(1216, 1942, -144), -90}
-- }
-- welcome to one of the longest ep1's maps ever

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_smg1")
	ply:Give("weapon_ar2")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_frag")
	ply:Give("weapon_rpg")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

function hl2cPlayerInitialSpawn(ply)
end
hook.Add("PlayerInitialSpawn", "hl2cPlayerInitialSpawn", hl2cPlayerInitialSpawn)


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_ammo")[1]:Remove()

	local alyx = ents.Create("npc_alyx")
	alyx:SetName("alyx")
	alyx:SetKeyValue("GameEndAlly", "1")
	alyx:Give("weapon_alyxgun")
	alyx:SetPos(Vector(5364, 6440, -2548))
	alyx:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

local hastriggered

-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "lcs_hos_enterance_1" and string.lower(input) == "start" then -- cuz alyx never seems to be taking the shotgun, she doesn't want to unlock the door
		local entity = ents.FindByName("lcs_hos_enterance")[1]
		entity:Fire("Start", nil, 7)
		local ent = ents.FindByName("alyx")[1]
		timer.Simple(3, function()
			if !IsVaild(ent) then return end
			ent:Give("weapon_shotgun")
		end)
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
