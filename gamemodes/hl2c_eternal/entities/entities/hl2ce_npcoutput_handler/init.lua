-- Basically needed so that these npcs output can work in lua
-- hotloading doesnt work, for some reason.
ENT.Base = "base_point"
ENT.Type = "point"


function ENT:Initialize()
	self:SetName("hl2ce_output_handler")
end

-- how tf this works
function ENT:KeyValue( k, v )
end

-- nope
function ENT:Think()
	return true
end

-- also no
function ENT:OnRemove()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end

function ENT:AcceptInput(input, activator, caller, value)
	if input == "cscanner_photograph" then
		if caller.VariantType == 1 then
			if caller:GetPos():DistToSqr(activator:GetPos()) < 90000 then
				local d = DamageInfo()
				d:SetDamage(10)
				d:SetDamageType(DMG_SLASH)
				d:SetAttacker(caller)
				d:SetInflictor(ents.FindByName("gmod_gamerules")[1] or caller)
				d:SetWeapon(self)
				activator:TakeDamageInfo(d)
				
			end
		end

		return true
	elseif input == "ag_summonants" then
		local enemy = caller:GetEnemy()

		for i=1,13 do
			local ent = ents.Create("npc_antlion")
			ent:SetKeyValue("startburrowed", 1)
			if math.random(10) == 1 then
				ent:AddFlags(262144)
			end
			local a = 1500
			ent:SetPos(caller:GetPos() + Vector(math.random(-a,a), math.random(-a,a), 500))
			if enemy then
				local ang = (enemy:GetPos() - caller:GetPos()):Angle()
				ang.pitch = 0
				ang.roll = 0
				ent:SetAngles(ang)
			else
				ent:SetAngles(Angle(0, math.Rand(-180, 180), 0))
			end
			ent:DropToFloor()
			ent:Spawn()
			local enemy = player.GetAll()[math.random(#player.GetAll())]
			ent:SetEnemy(enemy)
			ent:UpdateEnemyMemory(enemy, enemy:GetPos())
			ent:Input("unburrow")

		end

		return true
	end
end

function ENT:AddOutputFromAcceptInput()
end
