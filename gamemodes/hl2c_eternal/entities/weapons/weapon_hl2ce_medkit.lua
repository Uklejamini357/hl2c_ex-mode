-- tbh this was just edit of weapon_medkit weapon for it to fit with the hl2c EX gamemode
AddCSLuaFile()

SWEP.Base = "weapon_medkit"
SWEP.PrintName = "HL2c Medkit"
SWEP.Author = "Uklejamini"
SWEP.Purpose = "Heal other allies with your primary, or revive downed allies with secondary.\nRevived players are put back with 25% of their max health."
SWEP.Instructions = "Primary: Heal ally.\nSecondary: Revive a dead player.\n\nNeed to have at least 50% charges to revive!\nEffectiveness is increased as your Medical skill level goes."

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
	self.nextReviveFetch = SysTime()
	self:SetHoldType("slam")
	
	if CLIENT then
		GAMEMODE.DeadPlayersToRevive = {}

		local x,y = self:GetHealIconExpectedPos()
		self.IconPosX = x
		self.IconPosY = y
	end
end

function SWEP:PrimaryAttack()
	if IsValid(self:GetRevivingPlayer()) then return end

	local owner = self:GetOwner()
	local compensated = SERVER and owner:IsLagCompensated()
	if SERVER and owner:IsPlayer() and !compensated then
		owner:LagCompensation(true)
	end

	-- local tr = util.TraceLine({
	-- 	start = owner:GetShootPos(),
	-- 	endpos = owner:GetShootPos() + owner:GetAimVector() * 64,
	-- 	filter = owner
	-- })

	if SERVER and owner:IsPlayer() and !compensated then
		owner:LagCompensation(false)
	end

	local ent = self:GetHealingEntity()

	local need = self.HealAmount + (self.HealAmount * ((GAMEMODE.EndlessMode and 0.05 or 0.02) * owner:GetSkillAmount("Medical")))
	if IsValid(ent) then
		need = math.min(ent:GetMaxHealth() - ent:Health(), need)
	end

	if IsValid(ent) and self:Clip1() >= need and (ent:IsPlayer() or ent:IsFriendlyNPC()) and ent:Health() < ent:GetMaxHealth() then
		self:TakePrimaryAmmo(need)
		if SERVER then
			ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
			if ent:IsPlayer() then
				owner:GiveXP(need * 0.35)
			elseif ent:IsFriendlyNPC() then
				owner:GiveXP(need * 0.35/2)
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
		self:SetNextPrimaryFire(CurTime() + 0.25)
		self:SetNextSecondaryFire(CurTime() + 0.25)
	end
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()

	if !SERVER then return end
	if GAMEMODE:HardcoreEnabled() then return end
	if IsValid(self:GetRevivingPlayer()) then return end
	if self:Clip1() < self:GetMaxAmmo()*0.5 then return end

	local tbl = {}
	for _,pl in player.Iterator() do
		if !pl:Alive() and pl.deathRevivePos then
			local pos = pl.deathRevivePos + pl:OBBCenter()
			local dist = pos:Distance(owner:GetPos() + owner:OBBCenter())

			if dist > 64 then continue end

			tbl[#tbl+1] = {pl, dist}
		end
	end

	table.sort(tbl, function(a, b) return a[2] < b[2] end)
	
	if tbl[1] then
		self:StartReviving(tbl[1][1])
	end
end

function SWEP:RevivePlayer(pl)
	if !SERVER then return end
	if pl:Alive() then return end

	local pos = pl.deathRevivePos
	GAMEMODE.DeadPlayers[pl:SteamID()] = nil
	pl:Spawn()
	pl:SetHealth(pl:GetMaxHealth()*0.25)
	pl.invulnerableTime = CurTime()
	pl:AddFlags(FL_DUCKING)
	pl:SetPos(pos)
	pl:EmitSound("ambient/levels/labs/electric_explosion1.wav")
	pl:EmitSound("items/suitchargeok1.wav")
	self:GetOwner():GiveXP(7)

	self:SetClip1(self:Clip1() - self:GetMaxAmmo()*0.5)

	net.Start("hl2ce_revive")
	net.WriteUInt(REVIVE_PLAYERREVIVED, 4)
	net.WriteEntity(self:GetOwner())
	net.WriteEntity(pl)
	net.Broadcast()

	GAMEMODE:SendPlayersToRevive(player.GetAll())
end

function SWEP:StartReviving(pl)
	self:SetRevivingPlayer(pl)
	self:SetReviveStartTime(CurTime())
	self:SetReviveEndTime(CurTime()+5)

	if not self.ReviveSound then self.ReviveSound = CreateSound(self, "items/medcharge4.wav") end
	self.ReviveSound:Play()

	if SERVER then
		net.Start("hl2ce_revive")
		net.WriteUInt(REVIVE_PLAYERSTARTREVIVE, 4)
		net.WriteEntity(self:GetOwner())
		net.WriteFloat(self:GetReviveEndTime())
		net.Send(pl)
	end
end

function SWEP:StopReviving()
	local pl = self:GetRevivingPlayer()
	self:SetRevivingPlayer(NULL)
	self:SetReviveStartTime(0)
	self:SetReviveEndTime(0)

	if not self.ReviveSound then self.ReviveSound = CreateSound(self, "items/medcharge4.wav") end
	self.ReviveSound:Stop()

	if SERVER then
		net.Start("hl2ce_revive")
		net.WriteUInt(REVIVE_PLAYERSTOPREVIVE, 4)
		net.WriteEntity(self:GetOwner())
		net.Send(pl)
	end
end

function SWEP:Think()
	self:Regen(true)

	local reviving = self:GetRevivingPlayer()
	if IsValid(reviving) then
		local owner = self:GetOwner()
		if owner:KeyDown(IN_ATTACK2) then
			if self:GetReviveEndTime() <= CurTime() then
				self:RevivePlayer(reviving)
				self:StopReviving()
			end
		else
			self:StopReviving()
		end

		local pos = SERVER and reviving.deathRevivePos + reviving:OBBCenter() or CLIENT and GAMEMODE.DeadPlayersToRevive[reviving] or Vector(0,0,0)
		local dist = pos:Distance(owner:GetPos() + owner:OBBCenter())
		if dist > 64 then
			self:StopReviving()
		end
	end

	if CLIENT and self.nextReviveFetch and self.nextReviveFetch <= SysTime() then
		self.nextReviveFetch = SysTime()+2
	
		net.Start("hl2ce_revive")
		net.WriteUInt(REVIVE_SENDDEADPLAYERS, 4)
		net.SendToServer()
	end
end

function SWEP:Regen(keepaligned)
	local curtime = CurTime()
	local lastregen = self:GetLastAmmoRegen()
	local timepassed = curtime - lastregen
	local regenrate = 1
	local owner = self:GetOwner()

	if timepassed < regenrate then return false end

	local ammo = self:Clip1()
	local maxammo = self:GetMaxAmmo()

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
	self:StopReviving()

	timer.Stop("hl2ce_medkit_ammo"..self:EntIndex())
	timer.Stop("weapon_idle"..self:EntIndex())
end

function SWEP:Deploy()
	if CLIENT then
		GAMEMODE.DeadPlayersToRevive = {}
		self.nextReviveFetch = SysTime()+2

		net.Start("hl2ce_revive")
		net.WriteUInt(REVIVE_SENDDEADPLAYERS, 4)
		net.SendToServer()
	end

	return true
end

function SWEP:Holster()
	timer.Stop("weapon_idle" .. self:EntIndex())
	return true
end

function SWEP:SetRevivingPlayer(pl)
	self:SetDTEntity(0, pl)
end

function SWEP:GetRevivingPlayer()
	return self:GetDTEntity(0) or NULL
end

function SWEP:SetReviveStartTime(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetReviveStartTime()
	return self:GetDTFloat(1) or 0
end

function SWEP:SetReviveEndTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetReviveEndTime()
	return self:GetDTFloat(2) or 0
end

function SWEP:GetHealingEntity()
	local pl = self:GetOwner()
	local tbl = {}
	local pos = pl:GetShootPos()
	for _,ent in ipairs(ents.FindInCone(pos, pl:GetAimVector(), 64, math.cos(math.rad(60/2)))) do
		if pl ~= ent and (ent:IsPlayer() and ent:Alive() or ent:IsFriendlyNPC() and ent:Health() > 0) then
			tbl[#tbl+1] = ent
		end
	end

	table.sort(tbl, function(a,b)
		local apos,bpos = a:GetPos() + a:OBBCenter(), b:GetPos() + b:OBBCenter()
		return apos:Distance(pos) < bpos:Distance(pos) and a:Health() < b:Health()
	end)

	if tbl[1] then
		return tbl[1]
	end

	return NULL
end

function SWEP:CanHeal()
	local ent = self:GetHealingEntity()
	local need = self.HealAmount + (self.HealAmount * ((GAMEMODE.EndlessMode and 0.05 or 0.02) * self:GetOwner():GetSkillAmount("Medical")))
	return IsValid(ent) and self:Clip1() >= need and (ent:IsPlayer() or ent:IsFriendlyNPC()) and ent:Health() < ent:GetMaxHealth()
end

function SWEP:GetMaxAmmo()
	return self.MaxAmmo + (self.MaxAmmo * ((GAMEMODE.EndlessMode and 0.1 or 0.02) * self:GetOwner():GetSkillAmount("Surgeon")))
end

if !CLIENT then return end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay
end

local healthmat = Material("hl2c_eternal/health", "smooth")

function SWEP:GetHealIconPos()
	return self.IconPosX, self.IconPosY
end

function SWEP:GetHealIconExpectedPos()
	if IsValid(self:GetRevivingPlayer()) then
		local tbl = (GAMEMODE.DeadPlayersToRevive[self:GetRevivingPlayer()]):ToScreen()

		return tbl.x, tbl.y
	end

	local ent = self:GetHealingEntity()

	if IsValid(ent) then
		local tbl = (ent:GetPos() + ent:OBBCenter()):ToScreen()
		return tbl.x, tbl.y
	else
		return ScrW()/2, ScrH()/2
	end
end

function SWEP:DrawHUD()
	local pl = LocalPlayer()

	local w,h = ScrW(), ScrH()
	draw.SimpleText("LMB: Heal player or ally", "hl2ce_hudfont_small", w*0.98, h*0.85, Color(255,255,255,120), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	draw.SimpleText("RMB: Revive a dead player", "hl2ce_hudfont_small", w*0.98, h*0.85+18, Color(255,255,255,120), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	draw.SimpleText("Need 50% charges to revive!", "hl2ce_hudfont_small", w*0.98, h*0.85+36, Color(255,255,255,120), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

	for ply,pos in pairs(GAMEMODE.DeadPlayersToRevive) do
		local scr = pos:ToScreen()

		local toofar = pos:Distance(pl:GetPos() + pl:OBBCenter()) > 64
		local notenoughammo = self:Clip1() < self:GetMaxAmmo()*0.5
		local reviving = self:GetRevivingPlayer() == ply
		local reviveperc = 100 * (CurTime() - self:GetReviveStartTime()) / (self:GetReviveEndTime() - self:GetReviveStartTime())

		draw.SimpleText(ply:Nick(), "hl2ce_hudfont", scr.x, scr.y-70, Color(255,0,0,155), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(toofar and "Too far to revive!" or notenoughammo and "Not enough charges!" or reviving and "Reviving "..ply:Nick().." ("..math.Round(reviveperc).."%)" or "Hold RMB to revive a player!",
		"hl2ce_hudfont_small", scr.x, scr.y+60, (toofar or notenoughammo) and Color(255,0,0,155) or reviving and Color(255,0,0,155):Lerp(Color(0,255,0,155), reviveperc/100) or Color(0,255,0,155), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		surface.SetDrawColor(255,0,0,155)
		surface.DrawLine(scr.x, scr.y-40, scr.x, scr.y+40)
		surface.DrawLine(scr.x-25, scr.y, scr.x+25, scr.y)
	end

	if not healthmat then return end

	local healing = self:GetHealingEntity()
	local _x1,_y1 = self:GetHealIconPos()
	local _x2,_y2 = self:GetHealIconExpectedPos()
	self.IconPosX = _x1 + (_x2 - _x1) * math.min(1, FrameTime()*8)
	self.IconPosY = _y1 + (_y2 - _y1) * math.min(1, FrameTime()*8)

	local posx, posy = self:GetHealIconPos()
	local wdth, hght = 96, 96

	local col = IsValid(healing) and Color(255,0,0):Lerp(Color(0,255,0), healing:Health()/healing:GetMaxHealth()) or COLOR_WHITE
	col.a = 120

	surface.SetMaterial(healthmat)
	if self:CanHeal() then
		surface.SetDrawColor(col.r,col.g,col.b,150)
	else
		surface.SetDrawColor(255,5,5,150)
	end
	surface.DrawTexturedRect(posx - wdth/2, posy - hght/2, wdth, hght)

	if IsValid(healing) then
		draw.SimpleText(healing:IsPlayer() and healing:Nick() or healing:GetClass(), "hl2ce_hudfont_small", posx, posy - hght/1.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(healing:Health().." / ".. healing:GetMaxHealth().." ("..math.Round(100*healing:Health()/healing:GetMaxHealth()).."%)", "hl2ce_hudfont_small", posx, posy + hght/1.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end
