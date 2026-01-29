NEXT_MAP = "d1_trainstation_01"

NEXT_MAP_PERCENT = 1
NEXT_MAP_INSTANT_PERCENT = 101

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


function hl2cOnNPCKilled(ent, attacker)
	if !GAMEMODE.EXMode then return end
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
		if changingLevel then return end
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
			if GAMEMODE.MapVars.AdvisorsKilled == 2 then
				PrintMessage(3, "You unlocked the secret ending!")
				timer.Simple(1, function()
					PrintMessage(3, "I don't know how you did it.. but...")
				end)
				timer.Simple(2, function()
					PrintMessage(3, "Eli is still alive!")
				end)
			else
				PrintMessage(3, "I'm afraid that this is the end of your journey...")
				timer.Simple(1, function()
					PrintMessage(3, "This one of probably one of the saddest endings in the gaming history.")
				end)
				timer.Simple(2, function()
					PrintMessage(3, "Nearly all of us felt the same.")
				end)
				timer.Simple(3, function()
					PrintMessage(3, "But in fact, it's just a video game.")
				end)
				timer.Simple(5, function()
					BroadcastLua([[chat.AddText(Color(255,0,0), "The end.")]])
				end)
			end
		end

	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
