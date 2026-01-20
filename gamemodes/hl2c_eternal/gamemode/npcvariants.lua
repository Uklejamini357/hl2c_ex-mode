local function AntlionGuardAURA()
	for k,ent in pairs(ents.FindByClass("npc_antlionguard")) do
		if !ent:IsValid() or ent.VariantType != 5 or ent:Health() < 0 then continue end 
		local effectdata = EffectData()
		ent:SetHealth(math.Clamp(ent:Health() + 3, 0, ent:GetMaxHealth()))
		if !timer.Exists("NPC_ANTLIONGUARD_AURA_FX") then
			timer.Create("NPC_ANTLIONGUARD_AURA_FX", 2, 1, function()
				if !ent:IsValid() then return end
				ent:EmitSound("ambient/machines/thumper_hit.wav", 120, 70)
				effectdata:SetOrigin(ent:GetPos() + Vector(0, 0, 60))
				util.Effect("zw_master_strike", effectdata)
			end)
		end

		for k,v in pairs(ents.FindInSphere(ent:GetPos(), 200)) do
			if (v:GetClass() == "npc_antlion" or v:GetClass() == "npc_antlion_worker") and v:IsNPC() then 
				v:SetHealth(math.Clamp(v:Health() + 10, 0, v:GetMaxHealth()))
				effectdata:SetOrigin(v:GetPos() + Vector(0, 0, 60))
				util.Effect("zw_master_strike", effectdata)
			elseif (v:IsNPC() or v:IsPlayer()) && v:GetClass() != "npc_antlionguard" then
				if v:Health() < 0 then continue end
				v:TakeDamage(1, ent)
				if v:IsPlayer() and v:Alive() then
					v:PrintMessage(4, "YOU ARE BEING DAMAGED BY ANTLION GUARD VARIANT,\nGET AWAY FROM IT!!")
				end
				effectdata:SetOrigin(v:GetPos() + Vector(0, 0, 60))
				util.Effect("zw_master_strike", effectdata)
			end 
		end 
	end
end

local function OnSpawnNewEnt(oldent, newent)
	local enemy = oldent:GetEnemy()
	if enemy and enemy:IsValid() then
		newent:SetEnemy(enemy)
		newent:UpdateEnemyMemory(enemy, oldent:GetEnemyLastKnownPos())
	end
	newent:SetLastPosition(oldent:GetLastPosition())
	newent:SetSchedule(oldent:GetCurrentSchedule())
end

-- Priority hook function
function HL2cEX_NPCVariantSpawn(ent)
	if !GAMEMODE.EXMode or GAMEMODE.HyperEXMode or !ent:IsNPC() then return end

	hook.Run("ApplyNPCVariant", ent)
	if FORCE_NPCVARIANT then
		ent.VariantType = FORCE_NPCVARIANT
		FORCE_NPCVARIANT = nil
	elseif not ent.VariantType then
		ent.VariantType = math.random(1,2)
	end
	if ent:GetClass() == "npc_metropolice" then -- Elite variant - Increased damage and Health.
		if ent.VariantType == 1 then
			ent.ent_Color = Color(128,128,255)
			ent.ent_MaxHealthMul = 1.3
			ent.ent_HealthMul = 1.3
			ent.XPGainMult = 1.2
		elseif ent.VariantType == 2 then -- Deathbringer variant - 0.9x health and damage, Special: Launches a manhack towards the player upon dying, dealing 5.5x damage on its' first slashing hit, damage then decreases by 0.65x for every hit inflicted, down to 0.5x
			ent.ent_Color = Color(255,128,192)
			ent.ent_MaxHealthMul = 0.9
			ent.ent_HealthMul = 0.9
		end
	elseif ent:GetClass() == "npc_combine_s" then -- Destructive variant - deals massive damage but is also more fragile. Shotgunner damage reduced.
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.64
			ent.ent_HealthMul = 0.64

		elseif ent.VariantType == 2 then -- Boost health for normal soldiers
			ent.ent_MaxHealthMul = 1.2
			ent.ent_HealthMul = 1.2
		end
	elseif ent:GetClass() == "npc_manhack" then
	elseif ent:GetClass() == "npc_zombie" then
		if ent.VariantType == 1 then -- Explosive variant of regular zombies that explodes upon its' death (Explosions can be chained)
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.6
			ent.ent_HealthMul = 0.6
		end
	elseif ent:GetClass() == "npc_fastzombie" then -- Infective variant of Fast zombies can deal damage over time
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.7
			ent.ent_HealthMul = 0.7
		end
	elseif ent:GetClass() == "npc_zombine" then -- Tanky Zombine variant (Deals less damage but has much more health) Still very vulnerable to fire
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,255)
			ent.ent_MaxHealthMul = 2.2
			ent.ent_HealthMul = 2.2
			ent.XPGainMult = 1.3
		end
	elseif ent:GetClass() == "npc_antlionguard" then -- Healer Antlion Guard that slowly heals nearby antlions! (But is rarer!)
		ent.VariantType = math.random(1,5) --make antlion guard variant less common
		if ent.VariantType == 5 then
			ent.ent_Color = Color(0,255,0)
			ent.ent_MaxHealthMul = 1.1
			ent.ent_HealthMul = 1.1
			ent.XPGainMult = 1.3
	 else
			ent.ent_MaxHealthMul = 1.3
			ent.ent_HealthMul = 1.3
			ent.XPGainMult = 1.4
		end
	elseif ent:GetClass() == "npc_cscanner" or ent:GetClass() == "npc_clawscanner" then
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,128)
		end
	elseif ent:GetClass() == "npc_barnacle" then
		ent.VariantType = math.random(1,3) -- Barnacle has 3 variants
		if ent.VariantType == 1 then -- 1. Deadly variant - Deals triple damage, but can die faster
			ent.ent_MaxHealthMul = 0.6
			ent.ent_HealthMul = 0.6
			ent.ent_Color = Color(255,128,128)
		elseif ent.VariantType == 2 then -- 2. Bulky variant - Can take up a lot of damage, but cannot resist single hit of crowbar
			ent.ent_MaxHealthMul = 13.8
			ent.ent_HealthMul = 13.8
			ent.ent_Color = Color(128,128,255)
		else -- 3. Regular - Has 1.4x health, other stats are normal
			ent.ent_MaxHealthMul = 1.4
			ent.ent_HealthMul = 1.4
		end
	end

	hook.Run("PostApplyNPCVariant", ent, variant)
end
hook.Add("OnEntityCreated", "_HL2cEX_NPCVariantsSpawned", HL2cEX_NPCVariantSpawn)

function HL2cEX_NPCVariantKilled(ent, attacker)
	if !GAMEMODE.EXMode or GAMEMODE.HyperEXMode then return end
	if ent:GetClass() == "npc_zombie" then
		if ent.VariantType == 1 then
			local ent2 = ents.Create("env_explosion")
			ent2:SetOwner(attacker)
			ent2:SetKeyValue("iMagnitude", 45)
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 30))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			ent2:Activate()
			ent2:Fire("explode")
			local effectdata = EffectData()
			effectdata:SetOrigin(ent:GetPos() + Vector(0, 0, 60))
			util.Effect("zw_master_strike", effectdata)
			ent:EmitSound("ambient/machines/thumper_hit.wav", 120, 70)
		elseif ent.VariantType == 2 and math.random(1,100) < 35 then
			local ent2 = ents.Create("npc_headcrab")
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 10))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
		end
	elseif ent:GetClass() == "npc_fastzombie" then
		if ent.VariantType == 1 and math.random(1,100) < 15 then
			local ent2 = ents.Create("npc_headcrab_fast")
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 10))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
		end
	elseif ent:GetClass() == "npc_metropolice" then
		if ent.VariantType == 2 and math.random(1,100) < 45 then
			local ent2 = ents.Create("npc_manhack")
			ent2.VariantType = 3 -- Spawn in a special manhack variant - Damage increased up to 5.5x on first hit but next hit will deal a weaker attack down to 0.5x damage
			ent2.NextDamageMul = 5.5
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 50))
			ent2:SetAngles(ent:GetAngles())
			ent2.ent_Color = Color(128,192,255)
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
			ent2:GetPhysicsObject():SetVelocityInstantaneous((attacker:GetPos() - ent2:GetPos()) * 2)
		end
	elseif ent:GetClass() == "npc_sniper" then
		PrintMessage(3, "WTF YOU KILLED HIM!")
	elseif ent:GetClass() == "npc_poisonzombie" then
		if ent.VariantType == 1 then
			local ent2 = ents.Create("npc_headcrab_poison")
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 10))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
			timer.Simple(0, function()
				ent2:SetMaxHealth(ent2:Health() * 2)
				ent2:SetHealth(ent2:Health() * 2)
			end)
		end
	end
end
hook.Add("OnNPCKilled", "HL2cEX_NPCVariantsKilled", HL2cEX_NPCVariantKilled)

function HL2cEX_NPCVariantTakeDamage(ent, dmginfo)
	if !GAMEMODE.EXMode or GAMEMODE.HyperEXMode then return end
	local dmg, attacker = dmginfo:GetDamage(), dmginfo:GetAttacker()
	local attackerclass = attacker:GetClass()
	if attackerclass == "npc_metropolice" then
		if attacker.VariantType == 1 then
			dmginfo:ScaleDamage(1.5)
		elseif attacker.VariantType == 2 then
			dmginfo:ScaleDamage(0.9)
		end
	elseif attackerclass == "npc_manhack" then
		if attacker.VariantType == 3 then
			local dmgmul = attacker.NextDamageMul
			timer.Simple(0, function()
				if !dmgmul then return end
				attacker.NextDamageMul = math.max(0.5, dmgmul * 0.65)
			end)
		end
	elseif attackerclass == "npc_combine_s" then
		if attacker.VariantType == 1 then
			local wep = attacker:GetActiveWeapon()
			if wep:IsValid() and wep:GetClass() == "weapon_shotgun" then
				dmginfo:ScaleDamage(1.85)
			else
				dmginfo:ScaleDamage(2.55)
			end
		end
	elseif attackerclass == "npc_sniper" then
		if attacker.VariantType == 1 then
			dmginfo:ScaleDamage(215790)
		end
	elseif attackerclass == "npc_fastzombie" then
		if attacker.VariantType == 1 then
			if dmginfo:GetDamageType() != DMG_DIRECT then
				timer.Create("FastZombieDamage_"..ent:EntIndex(), 1, 5, function()
					if !ent:IsValid() then return end
					local d = DamageInfo()
					d:SetDamage(1)
					if attacker:IsValid() then
						d:SetAttacker(attacker)
					else
						d:SetAttacker(game.GetWorld())
					end
					d:SetDamageType(DMG_DIRECT)
					ent:TakeDamageInfo(d)
				end)
				dmginfo:ScaleDamage(0.5)
			elseif !ent:IsPlayer() then
				dmginfo:ScaleDamage(2)
			end
		end
	elseif attackerclass == "npc_zombine" then
		dmginfo:ScaleDamage(0.6)
	elseif attackerclass == "npc_headcrab" then
		dmginfo:SetDamageType(DMG_FALL)
		dmginfo:ScaleDamage(1.4)
	elseif attackerclass == "npc_headcrab_fast" then
		dmginfo:SetDamageType(DMG_FALL)
		dmginfo:ScaleDamage(1.2)
	elseif attackerclass == "npc_antlionguard" then
		dmginfo:ScaleDamage(2.25)
	elseif attackerclass == "npc_barnacle" then
		if attacker.VariantType == 1 then
			dmginfo:ScaleDamage(3)
		elseif attacker.VariantType == 2 then
			dmginfo:ScaleDamage(0.5)
		end
	end

	if ent:GetClass() == "npc_barnacle" then
	end
end
hook.Add("EntityTakeDamage", "HL2cEX_NPCVariantTakeDamage", HL2cEX_NPCVariantTakeDamage)

timer.Create("NPC_ANTLIONGUARD_AURA", 1, 0, AntlionGuardAURA)






-- HYPER EX





-- Priority hook function
function HL2cHyperEX_NPCVariantSpawn(ent)
	if !GAMEMODE.HyperEXMode or !ent:IsNPC() then return end

	local class = ent:GetClass()
	hook.Run("ApplyNPCVariant", ent, class)
	if FORCE_NPCVARIANT then
		ent.VariantType = FORCE_NPCVARIANT
		FORCE_NPCVARIANT = nil
	elseif not ent.VariantType then
		ent.VariantType = math.random(1,3)
	end
	-- ent.VariantType = 1
	if not ent.NPCStrengthTier then
		ent.NPCStrengthTier = 1 -- mostly, just keep it at 1
	end
	if class == "npc_metropolice" then -- Elite variant - Increased damage and Health.
		if ent.VariantType == 1 then
			ent.ent_Color = Color(128,128,255)
			ent.ent_MaxHealthMul = 1.3
			ent.ent_HealthMul = 1.3
			ent.XPGainMult = 1.2
		elseif ent.VariantType == 2 then -- Deathbringer variant - 0.9x health and damage, Special: Launches a manhack towards the player upon dying, dealing 5.5x damage on its' first slashing hit, damage then decreases by 0.65x for every hit inflicted, down to 0.5x
			ent.ent_Color = Color(255,128,192)
			ent.ent_MaxHealthMul = 0.9
			ent.ent_HealthMul = 0.9
		end
	elseif class == "npc_combine_s" then -- Destructive variant - deals massive damage but is also more fragile. Shotgunner damage reduced.
		timer.Simple(0, function() -- below doesn't work without a timer, as it's just BEFORE it spawned. (don't i just love how gmod handles the hooks sometimes)
			if !IsValid(ent) then return end
			local model = ent:GetModel()
			local skin = ent:GetSkin()
			local wep = ent.GetActiveWeapon and IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon():GetClass()

			if model == "models/combine_soldier.mdl" or model == "models/combine_soldier_prisonguard.mdl" then -- Regular/Nova Prospekt Soldier
				if wep == "weapon_shotgun" then -- Shotgunner
					ent.NPCStrengthTier = 2
				else -- Otherwise, Regular
					ent.NPCStrengthTier = 1
				end

				if model == "models/combine_soldier_prisonguard.mdl" then -- Nova prospekt soldier
					ent.CSNovaProspektNPC = true
				end
			elseif model == "models/combine_super_soldier.mdl" then -- Elite Soldier
				ent.NPCStrengthTier = 3
			end
		end)

		if ent.VariantType == 2 and math.random(3) == 1 then -- i find the tanky variant very annoying to deal with
			ent.VariantType = 1
		end

		if ent.VariantType == 1 then -- I don't even know how to name this one
			ent.ent_Color = Color(127,255,255)
			ent.ent_MaxHealthMul = 1
			ent.ent_HealthMul = 1
		elseif ent.VariantType == 2 then -- Tanky Variant (yes :))
			ent.ent_Color = Color(127,255,127)
			ent.ent_MaxHealthMul = 4.666
			ent.ent_HealthMul = 4.666
		elseif ent.VariantType == 3 then -- "Hyper" Variant (???)
			ent.ent_Color = Color(255,0,127)
			ent.ent_MaxHealthMul = 1.5
			ent.ent_HealthMul = 1.5
		end
	elseif class == "npc_manhack" then
	elseif class == "npc_zombie" then
		if ent.VariantType == 1 then -- Explosive variant of regular zombies that explodes upon its' death (Explosions can be chained)
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.6
			ent.ent_HealthMul = 0.6
		end
	elseif class == "npc_fastzombie" then -- Infective variant of Fast zombies can deal damage over time
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.7
			ent.ent_HealthMul = 0.7
		end
	elseif class == "npc_zombine" then -- Tanky Zombine variant (Deals less damage but has much more health) Still very vulnerable to fire
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,255)
			ent.ent_MaxHealthMul = 2.2
			ent.ent_HealthMul = 2.2
			ent.XPGainMult = 1.3
		end
	elseif class == "npc_antlionguard" then -- Healer Antlion Guard that slowly heals nearby antlions! (But is rarer!)
		ent.VariantType = math.random(1,5) --make antlion guard variant less common
		if ent.VariantType == 5 then
			ent.ent_Color = Color(0,255,0)
			ent.ent_MaxHealthMul = 1.1
			ent.ent_HealthMul = 1.1
			ent.XPGainMult = 1.3
	 else
			ent.ent_MaxHealthMul = 1.3
			ent.ent_HealthMul = 1.3
			ent.XPGainMult = 1.4
		end
	elseif class == "npc_cscanner" or class == "npc_clawscanner" then
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,128)
		end
	elseif class == "npc_barnacle" then
		ent.VariantType = math.random(1,3) -- Barnacle has 3 variants
		if ent.VariantType == 1 then -- 1. Deadly variant - Deals triple damage, but can die faster
			ent.ent_MaxHealthMul = 0.6
			ent.ent_HealthMul = 0.6
			ent.ent_Color = Color(255,128,128)
		elseif ent.VariantType == 2 then -- 2. Bulky variant - Can take up a lot of damage, but cannot resist single hit of crowbar
			ent.ent_MaxHealthMul = 13.8
			ent.ent_HealthMul = 13.8
			ent.ent_Color = Color(128,128,255)
		else -- 3. Regular - Has 1.4x health, other stats are normal
			ent.ent_MaxHealthMul = 1.4
			ent.ent_HealthMul = 1.4
		end
	end

	hook.Run("PostApplyNPCVariant", ent, variant)
end
hook.Add("OnEntityCreated", "_HL2cHyperEX_NPCVariantsSpawned", HL2cHyperEX_NPCVariantSpawn)

local function HL2cHyperEX_NPCVariantKilled(ent, attacker)
	if !GAMEMODE.HyperEXMode then return end
	if ent:GetClass() == "npc_zombie" then
		if ent.VariantType == 1 then
			local ent2 = ents.Create("env_explosion")
			ent2:SetOwner(attacker)
			ent2:SetKeyValue("iMagnitude", 45)
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 30))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			ent2:Activate()
			ent2:Fire("explode")

			local effectdata = EffectData()
			effectdata:SetOrigin(ent:GetPos() + Vector(0, 0, 60))
			util.Effect("zw_master_strike", effectdata)
			ent:EmitSound("ambient/machines/thumper_hit.wav", 120, 70)
		elseif ent.VariantType == 2 and math.random(1,100) <= 95 then
			local ent2 = ents.Create("npc_zombie")
			ent2:SetPos(ent:GetPos())
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
			ent2.XPGainMult = math.max(0.01, (ent.XPGainMult or 1) * 0.6)
			ent2.DifficultyGainMult = math.max(0.01, (ent.DifficultyGainMult or 1) * 0.6)
			ent2.VariantType = 2
			ent2.ent_MaxHealthMul = math.min(1e10, infmath.ConvertInfNumberToNormalNumber(ent.ent_MaxHealthMul or 1)*1.01 + 0.05)
			ent2.ent_HealthMul = math.min(1e10, infmath.ConvertInfNumberToNormalNumber(ent.ent_HealthMul or 1)*1.01 + 0.05)

			ent:Remove()
		end
	elseif ent:GetClass() == "npc_fastzombie" then
		if ent.VariantType == 1 and math.random(1,100) < 15 then
			local ent2 = ents.Create("npc_headcrab_fast")
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 10))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
		end
	elseif ent:GetClass() == "npc_combine_s" then
		if ent.VariantType == 1 then
			local tier = ent.NPCStrengthTier
			if tier then
				FORCE_NPCVARIANT = 1
				local ent2 = ents.Create(tier > 1 and "npc_combine_s" or "npc_metropolice")
				ent2:Give(tier == 3 and "weapon_shotgun" or "weapon_smg1")
				ent2:SetPos(ent:GetPos())
				ent2:SetAngles(ent:GetAngles())
				ent2:SetModel(ent.CSNovaProspektNPC and "models/combine_soldier_prisonguard.mdl" or "models/combine_soldier.mdl")
				ent2:Spawn()
				OnSpawnNewEnt(ent, ent2)

				ent:Remove()
			end
		end
	elseif ent:GetClass() == "npc_metropolice" then
		if ent.VariantType == 2 and math.random(1,100) < 45 then
			local ent2 = ents.Create("npc_manhack")
			ent2.VariantType = 3 -- Spawn in a special manhack variant - Damage increased up to 5.5x on first hit but next hit will deal a weaker attack down to 0.5x damage
			ent2.NextDamageMul = 5.5
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 50))
			ent2:SetAngles(ent:GetAngles())
			ent2.ent_Color = Color(128,192,255)
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
			ent2:GetPhysicsObject():SetVelocityInstantaneous((attacker:GetPos() - ent2:GetPos()) * 2)
		end
	elseif ent:GetClass() == "npc_sniper" then
		PrintMessage(3, "WTF YOU KILLED HIM!")
	elseif ent:GetClass() == "npc_poisonzombie" then
		if ent.VariantType == 1 then
			local ent2 = ents.Create("npc_headcrab_poison")
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 10))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
			timer.Simple(0, function()
				ent2:SetMaxHealth(ent2:Health() * 2)
				ent2:SetHealth(ent2:Health() * 2)
			end)
		end
	end
end
hook.Add("OnNPCKilled", "HL2cHyperEX_NPCVariantsKilled", HL2cHyperEX_NPCVariantKilled)

local function HL2cHyperEX_NPCVariantInflictDamage(ent, dmginfo)
	if !GAMEMODE.HyperEXMode then return end

	local dmg, attacker = dmginfo:GetDamage(), dmginfo:GetAttacker()
	local attackerclass = attacker:GetClass()
	if attackerclass == "npc_metropolice" then
		if attacker.VariantType == 1 then
			dmginfo:ScaleDamage(1.5)
		elseif attacker.VariantType == 2 then
			dmginfo:ScaleDamage(0.9)
		end
	elseif attackerclass == "npc_manhack" then
		if attacker.VariantType == 3 then
			local dmgmul = attacker.NextDamageMul
			timer.Simple(0, function()
				if !dmgmul then return end
				attacker.NextDamageMul = math.max(0.5, dmgmul * 0.65)
			end)
		end
	elseif attackerclass == "npc_combine_s" then
	elseif attackerclass == "npc_sniper" then
		if attacker.VariantType == 1 then
			dmginfo:ScaleDamage(10^math.Rand(1, 30))
		end
	elseif attackerclass == "npc_fastzombie" then
		if attacker.VariantType == 1 then
			if dmginfo:GetDamageType() != DMG_DIRECT then
				timer.Create("FastZombieDamage_"..ent:EntIndex(), 1, 5, function()
					if !ent:IsValid() then return end
					local d = DamageInfo()
					d:SetDamage(1)
					if attacker:IsValid() then
						d:SetAttacker(attacker)
					else
						d:SetAttacker(game.GetWorld())
					end
					d:SetDamageType(DMG_DIRECT)
					ent:TakeDamageInfo(d)
				end)
				dmginfo:ScaleDamage(0.5)
			elseif !ent:IsPlayer() then
				dmginfo:ScaleDamage(2)
			end
		end
	elseif attackerclass == "npc_zombine" then
		dmginfo:ScaleDamage(0.6)
	elseif attackerclass == "npc_headcrab" then
		dmginfo:SetDamageType(DMG_FALL)
		dmginfo:ScaleDamage(1.4)
	elseif attackerclass == "npc_headcrab_fast" then
		dmginfo:SetDamageType(DMG_FALL)
		dmginfo:ScaleDamage(1.2)
	elseif attackerclass == "npc_antlionguard" then
		dmginfo:ScaleDamage(2.25)
	elseif attackerclass == "npc_barnacle" then
		if attacker.VariantType == 1 then
			dmginfo:ScaleDamage(3)
		elseif attacker.VariantType == 2 then
			dmginfo:ScaleDamage(0.5)
		end
	end

	if ent:GetClass() == "npc_barnacle" then
	end
end
hook.Add("EntityTakeDamage", "HL2cHyperEX_NPCVariantInflictDamage", HL2cHyperEX_NPCVariantInflictDamage)

local function HL2cHyperEX_NPCVariantTakeDamage(ent, dmginfo)
	if !GAMEMODE.HyperEXMode then return end

	local dmg, attacker = dmginfo:GetDamage(), dmginfo:GetAttacker()
	local class = ent:GetClass()
	if class == "npc_combine_s" then
		if attacker:GetClass() == "npc_antlion" and bit.band(dmginfo:GetDamageType(), DMG_SLASH) ~= 0 then
			local d = GetConVar("sk_antlion_swipe_damage"):GetInt() -- these fucks should NOT instakill the soldiers.
			if ent.VariantType == 2 then
				dmginfo:SetDamage(d)
			else
				dmginfo:SetDamage(math.max(d, ent:Health()/4))
			end
		end
	end
end
hook.Add("EntityTakeDamage", "HL2cHyperEX_NPCVariantTakeDamage", HL2cHyperEX_NPCVariantTakeDamage)

local function HL2cHyperEX_NPCVariantThink(ent, class)
	if class == "npc_fastzombie" then
		ent:SetPlaybackRate(6.8)
	end
end

hook.Add("Think", "HL2cHyperEX_NPCVariantThink", function()
	if !GAMEMODE.HyperEXMode then return end
	for _,ent in ents.Iterator() do
		if !ent:IsValid() or !ent:IsNPC() then continue end
		HL2cHyperEX_NPCVariantThink(ent, ent:GetClass())
	end
end)
