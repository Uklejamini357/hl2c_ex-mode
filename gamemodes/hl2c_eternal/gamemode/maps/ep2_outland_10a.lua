NEXT_MAP = "ep2_outland_11"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if GAMEMODE.HyperEXMode then
		if ent:GetName() == "dogvstrider_alyx_hide_lcs" and input:lower() == "start" then
			local strider = ents.FindByName("river_strider")[1]
			timer.Create("blah", 0, 0, function()
				if !IsValid(strider) then return end
				local eff = EffectData()
				eff:SetOrigin(strider:GetPos())
				util.Effect("Explosion", eff)
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
