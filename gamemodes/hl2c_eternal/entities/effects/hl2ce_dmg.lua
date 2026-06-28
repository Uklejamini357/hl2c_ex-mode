EFFECT.LifeTime = 3

local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM
local draw = draw
local cam = cam

local Particles = {}

local col = Color(255,255,255)
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

			-- col.g = math.Clamp(col.g - (particle.Amount * 0.4), 0, 255)
			col.a = math.Clamp(particle.DieTime - curtime, 0, 1) * 220

			local pos = particle:GetPos()
			cam.Start3D2D(pos, ang, math.min(1, pos:Distance(pl:GetPos())/2000))
            draw.SimpleText(FormatNumber(particle.Amount), "hl2ce_dmgfont", 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			cam.End3D2D()
		end
	end

	if done then
		Particles = {}
	end
end)

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
	particle:SetVelocity(math.Clamp(amount, 5, 50) * 4 * vel * velscal)

	particle.Amount = GAMEMODE.LastDamageDealt or amount
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
