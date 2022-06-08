AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");
DEFINE_BASECLASS("_mine_entity");

function ENT:Initialize() BaseClass.Initialize(self); end;

function ENT:Touch(ent)
	if (ent:GetClass():lower() != self:GetClass() && !(ent:GetClass():find("trigger")) && !ent:IsPlayer() && !self.desactived) then
		local dmginfo = DamageInfo();
		dmginfo:SetDamage(2000);
		dmginfo:SetAttacker(self:GetCreator());
		dmginfo:SetDamageType(DMG_DIRECT);
		dmginfo:SetInflictor(self);
		dmginfo:SetDamagePosition(self:GetPos());

		if (ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel") then ent:GetBaseEnt():TakeDamageInfo(dmginfo);
		else ent:TakeDamageInfo(dmginfo); end;

		self:Detonate();
	end;
end;

function ENT:Use(ply) BaseClass.Use(self, ply); end;

function ENT:Think() BaseClass.Think(self); end;

function ENT:Detonate() BaseClass.Detonate(self); end;