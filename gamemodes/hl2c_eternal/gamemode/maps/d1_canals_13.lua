ALLOWED_VEHICLE = "Airboat Gun"

NEXT_MAP = "d1_eli_01"

TRIGGER_DELAYMAPLOAD = {
	Vector( -762, -3866, -392 ), Vector( -518, -3845, -231 )
}

local bossfight
if CLIENT then
	net.Receive("hl2ce_map_event", function()
		local event = net.ReadString()
		if event == "playmusic" then
			local play = net.ReadBool()
			local snd = "#*hl2c_eternal/music/chopper_fight.mp3"
			local ply = LocalPlayer()

			if play then
				ply:EmitSound(snd, 0, 100, 1, CHAN_STATIC, SND_DELAY, 0)
			else
				ply:EmitSound(snd, 0, 100, 1, CHAN_STATIC, SND_DELAY + SND_STOP, 0)
			end
		end
	end)

	return
end

local activated = true
local sk_helicopter_health = GetConVar("sk_helicopter_health")

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_pistol")
	ply:Give("weapon_smg1")
	ply:Give("weapon_357")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("global_newgame_template")[1]:Remove()
	bossfight = false
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

hook.Add("PlayerReady", "d1_canals_13.playmusic", function(pl)
	if bossfight then
		net.Start("hl2ce_map_event")
		net.WriteString("playmusic")
		net.WriteBool(true)
		net.Broadcast()
	end
end)

hook.Add("AcceptInput", "hl2cAcceptInput", function(ent, input)
	if ent:GetName() == "canals_npc_reservoircopter01" and input:lower() == "activate" then
		GAMEMODE:SetCurrentBoss(ent)
		net.Start("hl2ce_boss")
		net.WriteEntity(ent)
		net.Broadcast()

		if GAMEMODE.EXMode then
			PrintMessage(3, ">>> OH SHIT HELICOPTER HAS BEEN ACTIVATED SHOOT IT DOWN <<<")

			local hpmul = 1 + (#player.GetAll()-1)*0.4
			if hpmul ~= 1 then
				ent:SetHealth(ent:Health() * hpmul)
				ent:SetMaxHealth(ent:Health() * hpmul)
			end

			bossfight = true
			net.Start("hl2ce_map_event")
			net.WriteString("playmusic")
			net.WriteBool(true)
			net.Broadcast()

			net.Start("hl2ce_boss")
			net.WriteEntity(ent)
			net.Broadcast()
		end
	end

	if !GAMEMODE.EXMode then return end
	if ent:GetName() == "relay_achievement_heli_1" and input:lower() == "trigger" then
		net.Start("hl2ce_map_event")
		net.WriteString("playmusic")
		net.WriteBool(false)
		net.Broadcast()
		bossfight = false

		print("heli died yipee")
	end

	if ent:GetName() == "gate3_wheel" and input:lower() == "use" then
		if !bossfight then
			ents.FindByName("door_lock2_2")[1]:Fire("setposition", 1)
		end
		return true
	end
end)
