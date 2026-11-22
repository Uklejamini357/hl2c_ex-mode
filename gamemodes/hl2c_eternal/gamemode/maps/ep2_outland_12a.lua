NEXT_MAP = "d1_trainstation_01"

NEXT_MAP_PERCENT = 1
NEXT_MAP_INSTANT_PERCENT = 101

if CLIENT then
	hook.Add("HUDPaint", "blah", function()
		if not GAMEMODE.MapVars.EndTime then return end
		local col = Color(255,255,255)
	
		col.a = math.Clamp(CurTime()-GAMEMODE.MapVars.EndTime >= 10 and 1-(CurTime() - (GAMEMODE.MapVars.EndTime+10))/8 or (CurTime() - GAMEMODE.MapVars.EndTime)/3, 0, 1)*255
		if col.a == 0 then return end

		draw.SimpleText("END", "hl2ce_hudfont", ScrW()/2, ScrH()/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)

	return
end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawnLoadout", "hl2ce_PlayerLoadout", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


function hl2cOnNPCKilled(ent, attacker)
	if !GAMEMODE.EXMode then return end
	do return end -- maybe no

	if ent:GetName() == "advisor" then
		GAMEMODE.MapVars.AdvisorsKilled = (GAMEMODE.MapVars.AdvisorsKilled or 0) + 1
		if GAMEMODE.MapVars.AdvisorsKilled == 2 then
			PrintMessage(3, "Or is it? We'll see...")
		else
			PrintMessage(3, "Uh. I'm not sure if that will actually work.")
		end
	elseif ent:GetName() == "eli_advisor" then
		GAMEMODE.MapVars.AdvisorsKilled = (GAMEMODE.MapVars.AdvisorsKilled or 0) + 1
		if GAMEMODE.MapVars.AdvisorsKilled == 2 then
			PrintMessage(3, "Or is it? We'll see...")
		else
			PrintMessage(3, "Uh. I'm not sure if that will actually work.")
		end
	end
end
hook.Add("OnNPCKilled", "hl2cOnNPCKilled", hl2cOnNPCKilled)

-- Accept input
function hl2cAcceptInput(ent, input)
    if ent:GetName() == "credits" and string.lower(input) == "rolloutrocredits" then
		if !GAMEMODE:GameStateIsRunning() then return end
        gamemode.Call("NextMap")
        gamemode.Call("OnCampaignCompleted")

		for _,ply in ipairs(player.GetAll()) do
			gamemode.Call("PlayerCompletedCampaign", ply)
		end

        gamemode.Call("PostOnCampaignCompleted")
    end

	if GAMEMODE.EXMode then
		if ent:GetName() == "relay.advisor.scene" and input:lower() == "trigger" then
			if GAMEMODE.MapVars.AdvisorsKilled == 2 then
				ents.FindByName("fade_out_credits")[1]:Fire("fade")
				ents.FindByName("credits")[1]:Fire("rolloutrocredits", nil, 10)
				return true
			else
				PrintMessage(3, "NOOOOOO!!!!")
			end
		end

		if ent:GetName() == "fade_out_credits" and input:lower() == "fade" then
			BroadcastLua([[GAMEMODE.MapVars.EndTime = CurTime()]])

			for _,pl in player.Iterator() do
				pl:RemoveSuit()
				pl:StripWeapons()
			end
		end

	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

GM:AddLoadoutCreatePrevent("startitems_template")
