local function AntlionGuardAURA()
	for k,ent in pairs(ents.FindByClass("npc_antlionguard")) do
		if !ent:IsValid() or ent.VariantType != 1 or ent:Health() < 0 then continue end 
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
	elseif ent:GetClass() == "npc_combine_s" then
		if ent.VariantType == 1 then -- Destructive variant - deals massive damage but is also more fragile. Shotgunner damage reduced.
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.64
			ent.ent_HealthMul = 0.64

		elseif ent.VariantType == 2 then -- Boost health for normal soldiers
			ent.ent_MaxHealthMul = 1.2
			ent.ent_HealthMul = 1.2
		end
	elseif ent:GetClass() == "npc_strider" then
		if ent.VariantType == 1 then -- Furious variant - Always has aggressive behavior (Like in EP1)
			ent.ent_Color = Color(255,128,128)

			ent:Input("EnableAggressiveBehavior")
		elseif ent.VariantType == 2 then
			ent.ent_Color = Color(128,128,255)
		end
	-- elseif ent:GetClass() == "npc_manhack" then
	elseif ent:GetClass() == "npc_zombie" then
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.6
			ent.ent_HealthMul = 0.6
		end
	elseif ent:GetClass() == "npc_fastzombie" then -- Bloodly variant of Fast zombies can deal damage over time
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
	elseif ent:GetClass() == "npc_antlionguard" then -- Healer Antlion Guard that slowly heals nearby antlions!
		ent.VariantType = math.random(1,5) --make antlion guard variant less common
		if ent.VariantType == 1 then
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
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		hook.Run("PostApplyNPCVariantDelayed", ent, variant)
	end)
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
			FORCE_NPCVARIANT = 3
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
		if ent.VariantType == 1 then
			PrintMessage(3, "WTF YOU KILLED HIM!")
		end
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
	if !IsValid(attacker) then return end
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
			dmginfo:ScaleDamage(math.Rand(0, 215790)) -- insane rng moment
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
	elseif attackerclass == "npc_antlionguard" and dmginfo:GetDamageType() ~= DMG_POISON then
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


local function StriderShootCannon(ent, target)
	if !IsValid(ent.ShootingCannonInfoTarget) then
		ent.ShootingCannonInfoTarget = ents.Create("info_target")
		ent.ShootingCannonInfoTarget:SetPos(target:GetPos())
		ent.ShootingCannonInfoTarget:Spawn()

		ent:CallOnRemove("RemoveInfoTarget", function(ent)
			ent.ShootingCannonInfoTarget:Remove()
		end)
	end

	ent.ShootingCannonInfoTarget:SetPos(target:GetPos())
	ent:SetSaveValue("m_hCannonTarget", ent.ShootingCannonInfoTarget)
	ent.m_NextCannonShoot = CurTime() + math.Rand(5, 10)
end

-- Priority hook function
function HL2cHyperEX_NPCVariantSpawn(ent)
	if !GAMEMODE.HyperEXMode or !ent:IsNPC() then return end
	if !IsValid(ent) then return end

	local class = ent:GetClass()
	hook.Run("ApplyNPCVariant", ent, class)
	if FORCE_NPCVARIANT then
		ent.VariantType = FORCE_NPCVARIANT
		FORCE_NPCVARIANT = nil
	elseif not ent.VariantType then
		ent.VariantType = math.random(1,3)
	end
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
	elseif class == "npc_combine_s" then
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

			if ent.VariantType == 3 then
				ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
			end
		end)

		if ent.VariantType == 2 and math.random(3) == 1 then -- i find the tanky variant very annoying to deal with
			ent.VariantType = 1
		end

		if ent.VariantType == 1 then -- I don't even know how to name this one
			ent.ent_Color = Color(127,255,255)
			ent.ent_MaxHealthMul = 1
			ent.ent_HealthMul = 1

			-- cuz we know it's easily grindable with it
			ent.DifficultyGainMult = 0.2
			ent.XPGainMult = 0.3
		elseif ent.VariantType == 2 then -- Tanky Variant (yes :))
			ent.ent_Color = Color(127,255,127)
			ent.ent_MaxHealthMul = 2.666
			ent.ent_HealthMul = 2.666
			ent.DifficultyGainMult = 1.2
			ent.XPGainMult = 1.9
		elseif ent.VariantType == 3 then -- "Hyper" Variant - 1.5x health, with near-perfect weapon aim!
			ent.ent_Color = Color(255,0,127)
			ent.ent_MaxHealthMul = 1.5
			ent.ent_HealthMul = 1.5

			ent.DifficultyGainMult = math.Rand(1.1, 1.2)
			ent.XPGainMult = 1.3
		end
	elseif class == "npc_strider" then
		if ent.VariantType == 1 then -- Advanced Variant - Constantly uses strider cannon, every 5-10 seconds. Always sprints and has aggressive behavior like in episodic.
			ent.ent_Color = Color(127,0,255)
			ent.ent_MaxHealthMul = 1.3
			ent.ent_HealthMul = 1.3

			ent.DifficultyGainMult = math.Rand(1, 1.1)
			ent.XPGainMult = 1.2
			ent:Input("ActivateSpeedModifier")
			ent:Input("EnableAggressiveBehavior")
		elseif ent.VariantType == 2 then -- Hunter-Strider Variant - On death spawns in 3 hunters, or 10 manhacks. (Only if i somehow was able to make it shoot flechettes)
			ent.ent_Color = Color(63,160,255)

			ent.DifficultyGainMult = math.Rand(1, 1.1)
			ent.XPGainMult = 1.2
		elseif ent.VariantType == 3 then -- Exploder Variant - On death spawns 25 frag nades near it, exploding after only 25 seconds!
			ent.ent_Color = Color(127,255,127)
		end
	elseif class == "npc_manhack" then
	elseif class == "npc_zombie" then
		if ent.VariantType == 1 then -- Volatile variant - Violently explodes on death!
			ent.ent_Color = Color(254,54,54)
			ent.ent_MaxHealthMul = 1.4
			ent.ent_HealthMul = 1.4
			ent.XPGainMult = 1.3
		elseif ent.VariantType == 2 then -- Undying variant - 95% chance to revive, with higher hp.
			ent.ent_Color = Color(163,121,236)
			ent.ent_MaxHealthMul = 0.9
			ent.ent_HealthMul = 0.9
		elseif ent.VariantType == 3 then -- Deathful variant - On death drops a vial that poisons the player with 80% of player's health (or minimum 10 damage) if picked up!
			ent.ent_Color = Color(33,254,44)
			ent.ent_MaxHealthMul = 1.2
			ent.ent_HealthMul = 1.2

			ent.XPGainMult = 1.2
		end
	elseif class == "npc_fastzombie" then -- 6.66x animation speed (hmm...)
		if ent.VariantType == 1 then
			ent.ent_Color = Color(255,128,128)
			ent.ent_MaxHealthMul = 0.7
			ent.ent_HealthMul = 0.7
		end
	elseif class == "npc_zombine" then -- Suicider - Spams pulling out grenade if it has less than 50% hp. If it manages to kill itself, explode violently with 250 radius (WHAT?!?!?)
		if ent.VariantType == 1 then
			ent.ent_Color = Color(161,89,228)
			ent.ent_MaxHealthMul = 1.8
			ent.ent_HealthMul = 1.8
			ent.XPGainMult = 1.3
		elseif ent.VariantType == 2 then -- Infested - Spawns 8 headcrabs if it dies! (Are you kidding me...)
			ent.ent_Color = Color(247,35,35)
			ent.ent_MaxHealthMul = 1.1
			ent.ent_HealthMul = 1.1
			ent.XPGainMult = 1
		elseif ent.VariantType == 3 then -- Lethal - If it sprints, game over. (yes.)
			ent.ent_Color = Color(57,192,216)
			ent.ent_MaxHealthMul = 1.1
			ent.ent_HealthMul = 1.1
			ent.XPGainMult = 1.25
			ent.DifficultyGainMult = 1.1
		end
	elseif class == "npc_antlionguard" then -- Healer Antlion Guard that slowly heals nearby antlions! (But is rarer!)
		ent.VariantType = math.random(1,2) --make antlion guard variant less common
		if ent.VariantType == 1 then
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
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		hook.Run("PostApplyNPCVariantDelayed", ent, variant)
	end)
end
hook.Add("OnEntityCreated", "_HL2cHyperEX_NPCVariantsSpawned", HL2cHyperEX_NPCVariantSpawn)

local function HL2cHyperEX_NPCVariantKilled(ent, attacker)
	if !GAMEMODE.HyperEXMode then return end
	if ent:GetClass() == "npc_zombie" then
		if ent.VariantType == 1 then
			local ent2 = ents.Create("env_explosion")
			ent2:SetOwner(ent)
			ent2:SetKeyValue("iMagnitude", 150)
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
			FORCE_NPCVARIANT = 2
			local ent2 = ents.Create("npc_zombie")
			ent2:SetPos(ent:GetPos())
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
			ent2.XPGainMult = math.max(0.01, (ent.XPGainMult or 1) * 0.6)
			ent2.DifficultyGainMult = math.max(0.01, (ent.DifficultyGainMult or 1) * 0.6)
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
	elseif ent:GetClass() == "npc_zombine" then
		if ent.VariantType == 1 and ent == attacker then
			local ent2 = ents.Create("env_explosion")
			ent2:SetOwner(ent)
			ent2:SetKeyValue("iMagnitude", 150)
			ent2:SetKeyValue("iRadiusOverride", 250)
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 30))
			ent2:SetAngles(ent:GetAngles())
			ent2:Spawn()
			ent2:Fire("explode")
		elseif ent.VariantType == 2 then
			local ang = ent:GetAngles()
			for i=0,7 do
				local ent2 = ents.Create("npc_headcrab")
				ent2:SetPos(ent:GetPos() + ((ang + Angle(0, i*45, 0)):Forward()*48 + Vector(0, 0, 8)))
				ent2:SetAngles(ang)
				ent2:Spawn()
				ent2:Fire("explode")
				OnSpawnNewEnt(ent, ent2)
			end
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
			FORCE_NPCVARIANT = 3
			local ent2 = ents.Create("npc_manhack") -- Spawn in a special manhack variant - Damage increased up to 5.5x on first hit but next hit will deal a weaker attack down to 0.5x damage
			ent2.NextDamageMul = 5.5
			ent2:SetPos(ent:GetPos() + Vector(0, 0, 50))
			ent2:SetAngles(ent:GetAngles())
			ent2.ent_Color = Color(128,192,255)
			ent2:Spawn()
			OnSpawnNewEnt(ent, ent2)
			ent2:GetPhysicsObject():SetVelocityInstantaneous((attacker:GetPos() - ent2:GetPos()) * 2)
		end
	elseif ent:GetClass() == "npc_strider" then
		if ent.VariantType == 2 then
			local episodic = GetConVar("hl2_episodic"):GetBool()
			for i=1,episodic and 3 or 10 do
				local ent2 = ents.Create(episodic and "npc_hunter" or "npc_manhack")
				ent2:SetPos(ent:GetPos() + Angle(0, ent:GetAngles().yaw, 0):Forward()*(i-2)*70)
				ent2:SetAngles(ent:GetAngles())
				ent2:Spawn()
				OnSpawnNewEnt(ent, ent2)
				if not episodic then
					ent2.DontCollide = ent.RagdolledEntity
					ent2:CollisionRulesChanged()
					local a = attacker:GetPos() - ent:GetPos()
					ent2:SetVelocity((a/a:Length()) * 1000)
				end
			end
		elseif ent.VariantType == 3 then
			for i=1,25 do
				local ent2 = ents.Create("npc_grenade_frag")
				ent2:SetPos(ent:GetPos() + Vector(-20 + ((i%5)*10), -20 + ((math.floor(i/5)%5)*10), -80))
				ent2:SetOwner(ent)
				ent2:Spawn()
				local vel = VectorRand()*math.random(300, 500)
				vel.z = -math.random(250,350)
				local phys = ent2:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:SetVelocityInstantaneous(vel)
				end
				ent2:Input("SetTimer", nil, nil, 1.5)
			end
		end
	elseif ent:GetClass() == "npc_sniper" then
		if ent.VariantType == 1 then
			PrintMessage(3, "WTF YOU KILLED HIM!")
		end
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
	if !IsValid(attacker) then return end
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
	elseif attackerclass == "npc_antlionguard" and dmginfo:GetDamageType() ~= DMG_POISON then
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
	if !IsValid(ent) then return end

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
	elseif class == "npc_strider" then
		if ent.VariantType == 1 then
			dmginfo:ScaleDamage(0.7)
		end
	end
end
hook.Add("EntityTakeDamage", "HL2cHyperEX_NPCVariantTakeDamage", HL2cHyperEX_NPCVariantTakeDamage)

local function HL2cHyperEX_NPCVariantThink(ent, class)
	if class == "npc_fastzombie" then
		ent:SetPlaybackRate(6.66)
	elseif class == "npc_zombie" then
		if ent.VariantType == 3 then
			ent:SetColor(HSVToColor(((CurTime() - ent.spawnTime)*200) % 360, 1, 1))
		end
	elseif class == "npc_zombine" then
		if ent.VariantType == 1 and ent:Health() < ent:GetMaxHealth()/2 and (not ent.NextGrenadePull or ent.NextGrenadePull<CurTime()) then
			ent:Input("PullGrenade")
			ent.NextGrenadePull = CurTime() + 1.2
		elseif ent.VariantType == 3 then
			ent:SetPlaybackRate(6.96)
		end
	elseif class == "npc_strider" then
		if ent.VariantType == 1 then
			local enemy = ent:GetEnemy()
			if enemy and IsValid(enemy) and enemy ~= ent and (ent.m_NextCannonShoot or 0) < CurTime() then
				StriderShootCannon(ent, enemy)
			end
		end
	end
end

hook.Add("Think", "HL2cHyperEX_NPCVariantThink", function()
	if !GAMEMODE.HyperEXMode then return end
	for _,ent in ents.Iterator() do
		if !ent:IsValid() or !ent:IsNPC() then continue end
		HL2cHyperEX_NPCVariantThink(ent, ent:GetClass())
	end
end)
