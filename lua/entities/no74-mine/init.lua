AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

function ENT:Initialize()
    self:SetModel("models/codww2/equipment/no, 74 st grenade.mdl");
    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetSolid(SOLID_VPHYSICS);
    self:SetCollisionGroup(COLLISION_GROUP_NONE);

    self.phys = self:GetPhysicsObject();
    self.ent = nil
    self.isAttached = false

    if (self.phys:IsValid()) then
        self.phys:Wake();
        self.phys:EnableMotion(true);
    end;

    self:EmitSound("physics/glass/glass_strain2.wav");

    timer.Simple(5, function() if IsValid(self) then self:Detonate(self.ent) end end);
end;

function ENT:Touch(ent)
    if (!isAttached and ent:IsVehicle()) then
        self.isAttached = true;
        constraint.Weld(self, ent, 0, 0, 0, true, false);
        self.ent = ent;
        self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);
        return;
    end;
end;

function ENT:Detonate(ent)
    if (IsValid(ent) and self.isAttached) then
        local dmginfo = DamageInfo();
        dmginfo:SetDamage(2000);
        dmginfo:SetAttacker(self:GetCreator());
        dmginfo:SetDamageType(DMG_DIRECT);
        dmginfo:SetInflictor(self);
        dmginfo:SetDamagePosition(self:GetPos());
        ent:TakeDamageInfo(dmginfo);
    end;

    local explosionDamage =	150;
    local explosionRadius =	300;
    self.detonated = true;
    local pos = self:GetPos();

    local effectdata = EffectData();
    effectdata:SetOrigin(pos + Vector(0,0,100));
    effectdata:SetFlags(table.KeyFromValue(gred.Particles,"high_explosive_air"));
    effectdata:SetAngles(Angle(0,90,0))
    util.Effect("gred_particle_simple",effectdata)

    gred.CreateExplosion(pos, explosionRadius, explosionDamage, 
                        self.Decal, self.TraceLength, self.Attacker,
                        self, self.DEFAULT_PHYSFORCE, self.DEFAULT_PHYSFORCE_PLYGROUND,
                        self.DEFAULT_PHYSFORCE_PLYAIR)

    if self:WaterLevel() == 0 then
        self:EmitSound("explosion/mortar_strike_close_0" .. math.random(1,4) .. ".wav");
    else
        self:EmitSound("explosion/mortar_strike_close_water_0" .. math.random(1,4) .. ".wav");
    end
    self:Remove();
end;