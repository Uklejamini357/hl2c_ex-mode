NEXT_MAP = "ep1_c17_00"

TRIGGER_CHECKPOINT = {
	{Vector(3448, -88, 3440), Vector(3652, -252, 3540)}
}

-- TRIGGER_DELAYMAPLOAD = { Vector( 5120, 4840, -6720 ), Vector( 5136, 4480, -6480) }

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", function(ent, dmginfo)
	local atk = dmginfo:GetAttacker()
	if not ent:IsPlayer() and atk:GetClass() == "npc_rollermine" then
		dmginfo:SetDamage(math.huge)
	end
end)

-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()

	local alyx = ents.Create("npc_alyx")
	alyx:SetName("alyx")
	alyx:SetKeyValue("GameEndAlly", "1")
	alyx:Give("weapon_alyxgun")
	alyx:SetPos(Vector(3500, 14104, 3598))
	alyx:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

local hastriggered

-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if ent:GetName() == "trigger_alyx_close_airlock" and string.lower(input) == "enable" and not hastriggered then
		local alyx = ents.FindByName("alyx")[1]
		alyx:SetPos(Vector( 3388, 12646, 3604 ))
		alyx:SetLastPosition(Vector( 3388, 11750, 3604 ))
		alyx:SetSchedule( SCHED_FORCED_GO_RUN )
		hastriggered = true
	end

	if ent:GetName() == "al_citadel_04_rearsoldierslock" and input:lower() == "start" then
		for _,pl in ipairs(player.GetLiving()) do
			if pl == activator then continue end
			pl:SetPos(Vector(3306, 11762, 3600))
			pl:SetEyeAngles(Angle(0,0,0))
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
