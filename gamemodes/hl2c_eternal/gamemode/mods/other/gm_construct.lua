print("empty")

if CLIENT then
    net.Receive("sbox_what", function()
        if net.ReadBit() == 1 then
            LocalPlayer():EmitSound("buttons/button11.wav", nil, nil, 0.2)
        else
            LocalPlayer():EmitSound("buttons/button10.wav", nil, nil, 0.2)
        end
    end)

    return
end

util.AddNetworkString("sbox_what")

local function Beep(maprestarts)
    if maprestarts ~= GAMEMODE.MapRestarts then return end

    net.Start("sbox_what")
    net.WriteBit(0)
    net.Broadcast()
end

local function CycleReset(first)
    if GAMEMODE.MapRestarts < 0 then return end
    if not first then
        net.Start("sbox_what")
        net.WriteBit(1)
        net.Broadcast()
    end

    local maprestarts = GAMEMODE.MapRestarts
    timer.Simple(4.5, function() Beep(maprestarts) end)
    timer.Simple(5.5, function() Beep(maprestarts) end)
    timer.Simple(6.5, function() Beep(maprestarts) end)


    timer.Create("someshit", 7.5, 1, function()
        CycleReset(false)
    end)
end

local function SpawnProp(model, pos, ang, material, color, skin)
	local prop = ents.Create("prop_dynamic")
	prop:SetModel(model)
	prop:SetPos(pos)
	prop:SetAngles(ang)
	if material then
		prop:SetMaterial(material)
	end
	if color then
		prop:SetColor(color)
	end
	if skin then
		prop:SetSkin(skin)
	end
	prop:Spawn()
	prop:PhysicsInit(SOLID_VPHYSICS)
	
	local phys = prop:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	return prop
end



hook.Add("MapEdit", "hl2cMapEdit", function()
    PrintMessage(3, "beep, beep, beep, badebop")
    CycleReset(true)



    -- props

    SpawnProp("models/props_phx/construct/metal_plate2x4.mdl", Vector(626, -1241, -67), Angle(0, -180, 45), "", Color(255, 255, 255), 0)
    SpawnProp("models/props_phx/construct/metal_plate2x4.mdl", Vector(626, -1376, 68), Angle(0, 180, 45), "", Color(255, 255, 255), 0)
end)


hook.Add("PlayerSay", "fuckoff", function(pl, txt)
    if not pl:IsAdmin() or txt ~= "!fuckoff" then return end

    GAMEMODE.MapRestarts = -312451279361
    timer.Remove("someshit")
end)

