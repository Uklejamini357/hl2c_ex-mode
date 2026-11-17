function GM:AddLoadoutCreatePrevent(entname, inputName) -- entname can be a table, inputName defaults to "forcespawn"
	hook.Add("AcceptInput", "preventLoadoutItems", function(ent, input)
		if (istable(entname) and entname[ent:GetName()] or ent:GetName() == entname) and input:lower() == (inputName or "forcespawn") then
			hook.Add("OnEntityCreated", "noStartItems", function(ent) -- this works. Phew, I don't have to keep items from spawning
				if ent:GetClass() ~= "item_item_crate" and string.sub(ent:GetClass(), 1, 5) == "item_" or string.sub(ent:GetClass(), 1, 7) == "weapon_" then
					SafeRemoveEntity(ent) -- safely removes supply items, we don't need that
				end
			end)

			timer.Simple(0, function() -- removes hook after a tick of this input
				hook.Remove("OnEntityCreated", "noStartItems")
				ent:Remove() -- BYE!!!
			end)
		else
			hook.Remove("OnEntityCreated", "noStartItems")
		end
	end)
end
