AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");
DEFINE_BASECLASS("_mine_entity");

function ENT:Initialize()
    self:SetModel("models/hafthohlladung/hafthohlladung.mdl");
    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetUseType(SIMPLE_USE);
    self:SetSolid(SOLID_VPHYSICS);
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    self.phys = self:GetPhysicsObject();
    self.ent = nil;

    if (self.phys:IsValid()) then
        self.phys:Wake();
        self.phys:EnableMotion(true);
    end;

    self:EmitSound("physics/glass/glass_strain2.wav");

    timer.Simple(7, function() if (IsValid(self)) then self:Detonate(); end; end);
end;

function ENT:Use(ply) return; end;
function ENT:Think() return; end;

function ENT:Detonate()
    local dmginfo = DamageInfo();
    dmginfo:SetDamage(2000);
    dmginfo:SetAttacker(self:GetCreator());
    dmginfo:SetDamageType(DMG_DIRECT);
    dmginfo:SetInflictor(self);
    dmginfo:SetDamagePosition(self:GetPos());

    if (self.ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel") then self.ent = self.ent:GetBaseEnt():TakeDamageInfo(dmginfo); end;

    self.ent:TakeDamageInfo(dmginfo);
    BaseClass.Detonate(self);
end;