NEXT_MAP = "ep2_outland_06"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_357")
	ply:Give("weapon_smg1")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_frag")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()

	ents.FindByName("spawnitems_template")[1]:Remove()

	local alyx = ents.Create("npc_alyx")
	alyx:SetName("alyx")
	alyx:SetKeyValue("GameEndAlly", "1")
	alyx:Give("weapon_alyxgun")
	alyx:SetPos(Vector(-2916, 1364, 148))
	alyx:SetAngles(Angle(0, -90, 0))
	alyx:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() then
		if ent:GetName() == "basket_up_relay" and input:lower() == "trigger" then
			for _,ply in ipairs(player.GetLiving()) do
				if ply == activator then continue end
				ply:SetPos(Vector(648, 5740, 16))
				ply:SetEyeAngles(Angle(0,0,0))
			end
			GAMEMODE:ReplaceSpawnPoint(Vector(780, 5762, 652), 0)
		end
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "alyx_bridge_pullout_lcs" and input:lower() == "start" then
			timer.Simple(2.2, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Chapter B3")
			end)
			timer.Simple(4.6, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "A race against time")
			end)
			timer.Simple(15, function()
				if !IsValid(ent) then return end
				BroadcastLua([[chat.AddText(Color(255,0,0), "Approx. 3 hours left until the combine make it to the White Forest")]])
			end)
		end
	end

end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
