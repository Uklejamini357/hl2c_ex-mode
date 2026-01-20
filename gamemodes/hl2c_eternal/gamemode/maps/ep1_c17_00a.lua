NEXT_MAP = "ep1_c17_01"

TRIGGER_DELAYMAPLOAD = {Vector(4513, 3530, 1904), Vector(4658, 3636, 2026)}

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_shotgun")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("new_game_template")[1]:Remove()

	local alyx = ents.Create("npc_alyx")
	alyx:SetName("alyx")
	alyx:SetKeyValue("GameEndAlly", "1")
	alyx:Give("weapon_alyxgun")
	alyx:SetPos(Vector(800, 2600, 308))
	alyx:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

local hastriggered

-- Accept input
function hl2cAcceptInput(ent, input)
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
