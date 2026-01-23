NEXT_MAP = "ep1_c17_00a"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", function(ent, dmginfo)
	local atk = dmginfo:GetAttacker()

	if ent:GetName() == "train_2_ambush_zombine" and ent == atk then
		dmginfo:SetDamage(math.huge) -- let the zombine die. no matter what
		ent:SetHealth(0)
	elseif GAMEMODE.EXMode and ent:GetName() == "alyx" and (atk:GetClass() == "npc_headcrab_poison" or atk:GetClass() == "npc_headcrab_black") then
		PrintMessage(3, "OH, I HATE THESE THINGS!!!")
		dmginfo:SetDamage(math.huge)
		ent:SetHealth(0)
		ent.allowDIE = true
	end
end)

-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("new_game_template")[1]:Remove()

	local alyx = ents.Create("npc_alyx")
	alyx:SetName("alyx")
	alyx:SetKeyValue("GameEndAlly", "1")
	alyx:Give("weapon_alyxgun")
	alyx:SetPos(Vector(4977, -5977, -116))
	alyx:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

local hastriggered

-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "train_2_ambush_zombine" and string.lower(input) == "pullgrenade" then
		-- print("sethealth")
		-- ent:SetHealth(1)
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "lcs_al_c17_00_posttrain2" and input:lower() == "start" then
			timer.Simple(2, function()
				PrintMessage(3, "Chapter A3")
			end)

			timer.Simple(math.Rand(3.5,4.5), function()
				PrintMessage(3, "The dark fate")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
