-- tbh this was just edit of weapon_medkit weapon for it to fit with the hl2c EX gamemode
AddCSLuaFile()

SWEP.Base = "weapon_medkit"
SWEP.PrintName = "HL2c Medkit"
SWEP.Author = "Uklejamini"
SWEP.Purpose = "Heal people with your primary attack, or yourself with the secondary."
SWEP.Instructions = "Effectiveness is increased by 2% per Medical skill point, max efficiency 120%. Remember, healing other players will give you 1/4 of health you heal!"

SWEP.Slot = 5
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HealAmount = 3
SWEP.MaxAmmo = 100 -- Max ammo

local HealSound = Sound("HealthKit.Touch")
local DenySound = Sound("WallHealth.Deny")

function SWEP:Initialize()
	self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	local compensated = SERVER and owner:IsLagCompensated()
	if SERVER and owner:IsPlayer() and !compensated then
		owner:LagCompensation(true)
	end

	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * 64,
		filter = owner
	})

	if SERVER and owner:IsPlayer() and !compensated then
		owner:LagCompensation(false)
	end

	local ent = tr.Entity

	local need = self.HealAmount + (self.HealAmount * ((GAMEMODE.EndlessMode and 0.05 or 0.02) * owner:GetSkillAmount("Medical")))
	if IsValid(ent) then
		need = math.min(ent:GetMaxHealth() - ent:Health(), need)
	end

	if IsValid(ent) and self:Clip1() >= need and (ent:IsPlayer() or ent:IsNPC()) and ent:Health() < ent:GetMaxHealth() then
		self:TakePrimaryAmmo(need)
		if SERVER then
			ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
			if ent:IsPlayer() then
				owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + need * 0.25))
				owner:GiveXP(need * 0.35)
			elseif ent:IsFriendlyNPC() then
				owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + need * 0.2))
				owner:GiveXP(need * 0.28)
			end
		end

		self:EmitSound(HealSound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		self:SetNextPrimaryFire(CurTime() + 0.15)
		owner:SetAnimation(PLAYER_ATTACK1)

		-- Even though the viewmodel has looping IDLE anim at all times, we need this to make fire animation work in multiplayer
		self:SetNextIdle(CurTime() + 1.5)
		timer.Create("weapon_idle"..self:EntIndex(), 1.5, 1, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_IDLE) end end)
	else
		owner:EmitSound(DenySound)
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:SetNextSecondaryFire(CurTime() + 0.5)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	self:Regen(true)
end

function SWEP:Regen(keepaligned)
	local curtime = CurTime()
	local lastregen = self:GetLastAmmoRegen()
	local timepassed = curtime - lastregen
	local regenrate = 1
	local owner = self:GetOwner()

	if timepassed < regenrate then return false end

	local ammo = self:Clip1()
	local maxammo = self.MaxAmmo + (self.MaxAmmo * ((GAMEMODE.EndlessMode and 0.1 or 0.02) * owner:GetSkillAmount("Surgeon")))

	if ammo >= maxammo then return false end

	if regenrate > 0 then
		local toregen = 1 + (GAMEMODE.EndlessMode and 0.1 or 0.02) * owner:GetSkillAmount("Surgeon")
		self:SetClip1(math.min(self:Clip1() + toregen * math.floor(timepassed / regenrate), maxammo))

		self:SetLastAmmoRegen(keepaligned and curtime + (timepassed % regenrate) or curtime)
	else
		self:SetClip1(maxammo)
		self:SetLastAmmoRegen(curtime)
	end

	return true
end


function SWEP:OnRemove()
	timer.Stop("hl2ce_medkit_ammo"..self:EntIndex())
	timer.Stop("weapon_idle"..self:EntIndex())
end

function SWEP:Holster()
	timer.Stop("weapon_idle" .. self:EntIndex())
	return true
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay
end
