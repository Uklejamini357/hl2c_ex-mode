-- map lua file for that oven map because why not
-- thought to have fun with it more than just that
if CLIENT then return end
local enabled = false	
local losing = false	
local moneys = 0
local timerhandler = "InfDifficulty.blah"

hook.Add("MapEdit", "InfDifficulty", function(ent, input)
	timer.Remove(timerhandler)
	enabled = false
	losing = false
	moneys = 0
end)

hook.Add("EntityTakeDamage", "InfDifficulty", function(ent, dmginfo)
	if ent:GetName() == "pepperonipizza" then
		local atk = dmginfo:GetAttacker()
		timer.Create("break_pepperoni_pizza_"..ent:EntIndex(), 0, 1, function()
			if IsValid(ent) then return end
			moneys = moneys - 25
			local s = "YOU RUINED THE PIZZA!! -25 MONEYS"
			if moneys < 0 then
				s = s.." (at debt of "..moneys.." moneys)"
			end
			BroadcastLua("surface.PlaySound('npc/stalker/go_alert2a.wav')")
			PrintMessage(3, s)

			if moneys < -100 then
				if !losing then
					PrintMessage(3, "...")
					local e = ents.FindByName("pizzaspawner2")[1]
					timer.Simple(math.Rand(3,5), function()
						if !IsValid(e) then return end
						if changingLevel then return end
						gamemode.Call("FailMap", atk, "You lost because you got yourself in crippling debt of "..moneys.." moneys!"..(moneys < -200 and "\nSeems like someone can't even manage their pizzas properly!" or "").."\nYou have been fired for general incompetence!"..(moneys < -500 and "\nAnd you ended up getting sued for causing catastrophic economic damages to the restaurant!" or ""))
					end)
					losing = true
				end
			elseif moneys < -50 then
				PrintMessage(3, "STOP GETTING YOURSELF IN MORE DEBT!!")
			end
		end)
	end
end)

hook.Add("PreCleanupMap", "InfDifficulty.prevent", function()
	enabled = true
end)

hook.Add("PostCleanupMap", "InfDifficulty.allow", function()
	enabled = false
end)


hook.Add("EntityRemoved", "InfDifficulty.Idk", function(ent)
	if ent:GetName() == "oven_battey" and !enabled then
		timer.Simple(0, function()
			game.CleanUpMap(true, nil, function()
				ents.FindByName("pizzaoven_relay1")[1]:Fire("enable")
				ents.FindByName("pizzaoven_relay1")[1]:Fire("trigger")
				ents.FindByName("pizzaoven_relay_regular_1")[1]:Fire("disable")
				ents.FindByName("pizzaoven_relay1")[1]:Fire("disable")
				ents.FindByName("pizzaoven_realbutton")[1]:Fire("kill")
			end)
		end)
	end
end)


hook.Add("AcceptInput", "InfDifficulty", function(ent, input)
	local entname = ent:GetName()
	local inputlower = input:lower()


	if entname == "pizzaspawner2" and inputlower == "forcespawn" then
		local s = "You made pizza! +10 moneys!"
		local m = moneys
		moneys = moneys + 10

		if m ~= 0 then
			s = s.." (total "..moneys..")"
		end

		for _,ply in ipairs(player.GetLiving()) do
			ply:Give("weapon_physcannon")
		end

		PrintMessage(3, s)
	end

	if entname == "pizzaoven_relay1" then
		if inputlower == "trigger" and enabled then
			BroadcastLua([[chat.AddText(Color(255,0,0), "AUTHORIZED BULLSHIT DETECTED!!")]])
			GAMEMODE:SetDifficulty(1)
		elseif inputlower == "enable" then
			enabled = true
		end
	elseif entname == "pizzaoven_relay2" and inputlower == "trigger" then
		timer.Create(timerhandler, 0, 0, function()
			if !IsValid(ent) then return end
			local ft = FrameTime()
			local diff = GAMEMODE:GetDifficulty()
			GAMEMODE:SetDifficulty((diff*(1+2*ft))^(1 + (0.01*ft*(math.min(150, diff:log(2)^0.9)*math.log10(math.max(10, diff:log10()))))))
		end)
	elseif entname == "pizzaoven_relay3" and inputlower == "trigger" then
		timer.Remove(timerhandler)
		GAMEMODE:SetDifficulty(1)
		gamemode.Call("FailMap", nil, "You let the oven get blown up!\nYou got fired and arrested, for causing catastrophic damages to the restaurant!")
	end
end)
