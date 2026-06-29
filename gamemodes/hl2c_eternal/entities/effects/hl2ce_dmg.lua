EFFECT.LifeTime = 3

local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM
local draw = draw
local cam = cam

local Particles = {}

local col = Color(255,255,255)


local bit_band = bit.band

local DMG_GENERIC = DMG_GENERIC
local DMG_CRUSH = DMG_CRUSH
local DMG_BULLET = DMG_BULLET
local DMG_SLASH = DMG_SLASH
local DMG_BURN = DMG_BURN
local DMG_VEHICLE = DMG_VEHICLE
local DMG_FALL = DMG_FALL
local DMG_BLAST = DMG_BLAST
local DMG_CLUB = DMG_CLUB
local DMG_SHOCK = DMG_SHOCK
local DMG_SONIC = DMG_SONIC
local DMG_ENERGYBEAM = DMG_ENERGYBEAM
local DMG_PREVENT_PHYSICS_FORCE = DMG_PREVENT_PHYSICS_FORCE
local DMG_NEVERGIB = DMG_NEVERGIB
local DMG_ALWAYSGIB = DMG_ALWAYSGIB
local DMG_DROWN = DMG_DROWN
local DMG_PARALYZE = DMG_PARALYZE
local DMG_NERVEGAS = DMG_NERVEGAS
local DMG_POISON = DMG_POISON
local DMG_RADIATION = DMG_RADIATION
local DMG_DROWNRECOVER = DMG_DROWNRECOVER
local DMG_ACID = DMG_ACID
local DMG_SLOWBURN = DMG_SLOWBURN
local DMG_REMOVENORAGDOLL = DMG_REMOVENORAGDOLL
local DMG_PHYSGUN = DMG_PHYSGUN
local DMG_PLASMA = DMG_PLASMA
local DMG_AIRBOAT = DMG_AIRBOAT
local DMG_DISSOLVE = DMG_DISSOLVE
local DMG_BLAST_SURFACE = DMG_BLAST_SURFACE
local DMG_DIRECT = DMG_DIRECT
local DMG_BUCKSHOT = DMG_BUCKSHOT
local DMG_SNIPER = DMG_SNIPER
local DMG_MISSILEDEFENSE = DMG_MISSILEDEFENSE

hook.Add("PostDrawTranslucentRenderables", "hl2ce_DrawDMG", function()
	if #Particles == 0 then return end

	local done = true
	local curtime = CurTime()

	local pl = LocalPlayer()
	local ang = EyeAngles()
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	for _, particle in pairs(Particles) do
		if particle and curtime < particle.DieTime then
			done = false

			particle.Color.a = math.Clamp(particle.DieTime - curtime, 0, 1) * 220

			local pos = particle:GetPos()
			cam.Start3D2D(pos, ang, math.Clamp(pos:Distance(pl:GetPos())/2000, 0.1, 1))
            draw.SimpleText(FormatNumber(particle.Amount), "hl2ce_dmgfont", 0, 0, particle.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			cam.End3D2D()
		end
	end

	if done then
		Particles = {}
	end
end)

local dmgcols = {
	[DMG_SLASH] = Color(210, 90, 90),
	[DMG_BURN] = Color(240, 40, 40),
	[DMG_BLAST] = Color(210, 210, 90),
	[DMG_SHOCK] = Color(21, 126, 253),
	[DMG_ENERGYBEAM] = Color(0, 247, 255),
	[DMG_PARALYZE] = Color(85, 0, 255),
	[DMG_NERVEGAS] = Color(185, 8, 91),
	[DMG_POISON] = Color(57, 255, 50),
	[DMG_RADIATION] = Color(145, 244, 39),
	[DMG_ACID] = Color(57, 255, 50),
	[DMG_SLOWBURN] = Color(230, 60, 60),
	[DMG_PLASMA] = Color(255, 0, 200),
	[DMG_AIRBOAT] = Color(253, 255, 135),
	[DMG_DISSOLVE] = Color(45, 0, 108),
	[DMG_BLAST_SURFACE] = Color(210, 210, 90)
}

local gravity = Vector(0, 0, -500)
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local amount = data:GetMagnitude()
	local Type = data:GetScale()
	local velscal = 1.2

	local vel = VectorRand()
	vel.z = math.Rand(0.7, 0.98)
	vel:Normalize()

	local emitter = ParticleEmitter(pos)
	local particle = emitter:Add("sprites/glow04_noz", pos)
	particle:SetDieTime(2)
	particle:SetStartAlpha(0)
	particle:SetEndAlpha(0)
	particle:SetStartSize(0)
	particle:SetEndSize(0)
	particle:SetCollide(true)
	particle:SetBounce(0.7)
	particle:SetAirResistance(32)
	particle:SetGravity(gravity * (velscal ^ 2))
	particle:SetVelocity(math.Clamp(amount*10, 25, 200) * vel * velscal)
	local dmgtype = GAMEMODE.LastDamageTypeDealt
	particle.Color = COLOR_WHITE:Copy()

	local dmginfos = {}
	local dmginfos_len = 0
	for i=0,31 do
		local dmgt = 2^i
		if bit_band(dmgtype, dmgt) == dmgt then
			dmginfos[dmgt] = true
			dmginfos_len = dmginfos_len + 1
		end
	end

	local lerp = math.min(1, 1/dmginfos_len)
	for dmgt,_ in pairs(dmginfos) do
		if dmgcols[dmgt] then
			particle.Color = particle.Color:Lerp(dmgcols[dmgt], lerp)
		end
	end

	particle.Amount = GAMEMODE.LastDamageDealt or amount
	particle.DamageType = GAMEMODE.LastDamageDealt or 0
	particle.DieTime = CurTime() + 2
	particle.Type = Type

	table.insert(Particles, particle)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
