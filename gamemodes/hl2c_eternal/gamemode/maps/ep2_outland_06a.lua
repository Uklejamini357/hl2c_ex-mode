NEXT_MAP = "ep2_outland_07"

ALLOWED_VEHICLE = "Jalopy"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() then
		if ent:GetName() == "playerclip_powerroom" and input:lower() == "enable" then
			for _,ply in ipairs(player.GetLiving()) do
				if ply == activator then continue end
				ply:SetPos(Vector(-3028, -9700, -1528))
				ply:SetEyeAngles(Angle(0, 180, 0))
			end
			GAMEMODE:ReplaceSpawnPoint(Vector(-3028, -9700, -1528), 180)
		end

		if !GAMEMODE.MapVars.HunterTriggerEnabled and ent:GetName() == "trigger_elevator_check" and input:lower() == "enable" then
			ents.FindByName("playerclip_elevator")[1]:Fire("Enable")
			ents.FindByName("button_elevator")[1]:Fire("Lock")

			for _,ply in ipairs(player.GetLiving()) do
				ply:SetPos(Vector(-3512, -9728, -1696))
				ply:SetEyeAngles(Angle(0, 0, 0))
			end

			GAMEMODE.MapVars.HunterTriggerEnabled = true
		end
	end

	if GAMEMODE.EXMode then
		if !GAMEMODE.MapVars.GotIntoCarOnce and ent:GetName() == "ep2_outland_06a_canCel_get_inCar" and input:lower() == "trigger" then
			timer.Simple(5.7, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Chapter B4")
			end)
			timer.Simple(8.1, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "untitled chapter")
			end)
			GAMEMODE.MapVars.GotIntoCarOnce = true
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
