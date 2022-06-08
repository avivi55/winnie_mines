AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");
DEFINE_BASECLASS("_mine_entity");

function ENT:Initialize()
	BaseClass.Initialize(self);
	self:SetRenderMode(0);
	self.spawnedTime = CurTime();
	self.isLaunched = false;
	self.gamemode = engine.ActiveGamemode();
	self.gamemodeCheck = true;
	self.boom = false;
end;

function ENT:Think()
	if (SERVER) then
		if (self.isLaunched) then return end;
		for _,ent in pairs(ents.FindInSphere(self:GetPos(),135)) do
			if ((ent:IsPlayer() or ent:IsNPC()) and !self.desactived) then
				if (self.gamemodeCheck) then
					if (ent != self:GetCreator()) then self:Launch(); end;
				else self:Launch(); return; end;
			end;
		end;
	end;
	BaseClass.Think(self);
end;

function ENT:Use(ply) BaseClass.Use(self, ply); end;

function ENT:OnTakeDamage(damage) if (IsValid(self)) then self:Detonate(); end; end;

function ENT:Launch()
	if (self.spawnedTime + 2 > CurTime()) then return; end;

	self.phys:EnableMotion(true);
	self.phys:SetVelocity(Vector(0,0,350));
	self:EmitSound("ins2_pin/nvg_off.wav", 75, 100, 500);

	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);
	timer.Simple(0.4, function() if (IsValid(self)) then self:SetCollisionGroup(COLLISION_GROUP_NONE); end; end);

	if (math.random(1,1000) != 4) then timer.Simple(1, function() if (IsValid(self)) then self:Detonate(); end; end); end;

	self.isLaunched = true;
end;

function ENT:Detonate() BaseClass.Detonate(self); end;