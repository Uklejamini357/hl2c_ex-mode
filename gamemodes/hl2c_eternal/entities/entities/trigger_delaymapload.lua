-- Entity information
ENT.Base = "base_brush"
ENT.Type = "brush"


-- Called when the entity first spawns
function ENT:Initialize()

	local w = self.max.x - self.min.x
	local l = self.max.y - self.min.y
	local h = self.max.z - self.min.z

	local min = Vector( 0 - ( w / 2 ), 0 - ( l / 2 ), 0 - ( h / 2 ) )
	local max = Vector( w / 2, l / 2, h / 2 )

	self:DrawShadow( false )
	self:SetCollisionBounds( min, max )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetMoveType( 0 )
	self:SetTrigger( true )

end


-- Called when an entity touches me :D
function ENT:StartTouch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Team() == TEAM_ALIVE and (ent:GetMoveType() != MOVETYPE_NOCLIP or ent:InVehicle()) then
		gamemode.Call("CompleteMap", ent)
	end
end


-- Checks to see if we should go to the next map
function ENT:Think()
end
