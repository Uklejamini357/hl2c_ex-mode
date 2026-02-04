NEXT_MAP = "ep2_outland_02"

TRIGGER_CHECKPOINT = {
	{Vector(4277, -1268, -1452), Vector(4613, -1150, -1157)},
	{Vector(5248, -2768, -2304), Vector(5440, -2854, -2176)},
}

TRIGGER_DELAYMAPLOAD = {Vector(4884, -1554, 2772), Vector(4978, -1662, 2974)}

if CLIENT then return end

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


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("loaditems_template")[1]:Remove()
	if !game.SinglePlayer() then
		ents.FindByName("vort_freeman_death_vcd")[1]:Remove()
	end

	local vort = ents.Create("npc_vortigaunt")
	vort:SetPos(Vector(4244, -1708, 384))
	vort:SetAngles(Angle(0, 45, 0))
	vort:SetName("vort")
	vort:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

-- Initialize entities
function hl2cOnNPCKilled(ent, attacker)
	if ent:GetName() == "maze_guard" then
		gamemode.Call("FailMap", attacker, "Did you really not listen to what Vort has said?!\
Now the larval extract is ruined!")

		return true
	end
end
hook.Add("OnNPCKilled", "hl2cOnNPCKilled", hl2cOnNPCKilled)


local dontremove = {
	"vort_dont_kill_guardian_vcd",
	"vort_elevator_hint_lcs",
	"vort_goodjob_vcd_1"
}

-- Accept input
function hl2cAcceptInput(ent, input, activator)
	-- vort fallls to their death
	if !game.SinglePlayer() then
		if table.HasValue(dontremove, ent:GetName()) and (input:lower() == "cancel" or input:lower() == "kill") then
			return true
		end

		if ent:GetName() == "guardcaveentry_block_player" and input:lower() == "enable" then
			return true
		end

		if ent:GetName() == "grub_tunnel_1_playerblock" and input:lower() == "enable" then
			return true
		end

		if ent:GetName() == "grub_tunnel_2_playerblock" and input:lower() == "enable" then
			return true
		end

		if ent:GetName() == "guard_leap_3_playerblock" and input:lower() == "enable" then
			return true
		end

		if ent:GetName() == "vort_elevator_dialog_lcs" and input:lower() == "start" then
			for _,ply in ipairs(player.GetLiving()) do
				if ply == activator then continue end
				ply:SetPos(Vector(4910, -1609, -2244))
				ply:SetEyeAngles(Angle(0,0,0))
			end
		end
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "maze_guard" and input:lower() == "sethealth" then
			return true
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

function hl2cOnMapCompleted()
	GAMEMODE.CampaignMapVars.ExtractObtained = true
end
hook.Add("OnMapCompleted", "hl2cOnMapCompleted", hl2cOnMapCompleted)
