AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

function ENT:Initialize()
    self:SetModel("models/codww2/equipment/satchel charge.mdl");
    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetSolid(SOLID_VPHYSICS);
    self:SetCollisionGroup(COLLISION_GROUP_NONE);

    self.phys = self:GetPhysicsObject();
    self.ent = nil

    if (self.phys:IsValid()) then
        self.phys:Wake();
        self.phys:EnableMotion(true);
    end;

    self:EmitSound("physics/glass/glass_strain2.wav");

    timer.Simple(7, function() if IsValid(self) then self:Detonate() end end);
end;

function ENT:Detonate()
    local explosionDamage =	150;
    local explosionRadius =	300;
    self.detonated = true
    local pos = self:GetPos()
    //local rad = 3000

    net.Start("gred_net_createparticle")
        local tr = util.TraceLine({
        start    = pos,
        endpos   = pos - Vector(0,0,100),
        filter   = self})
        
        net.WriteString("gred_highcal_rocket_explosion")
        net.WriteVector(pos)
        net.WriteAngle(Angle(-90,0,0))
        net.WriteBool(tr.HitWorld)
    
    net.Broadcast()

    gred.CreateExplosion(pos,explosionRadius,explosionDamage,self.Decal,self.TraceLength,self.Attacker,self,self.DEFAULT_PHYSFORCE,self.DEFAULT_PHYSFORCE_PLYGROUND,self.DEFAULT_PHYSFORCE_PLYAIR)

    sound.Play("explosion/mortar_strike_close_0" .. math.random(1,4) .. ".wav", pos, 160, 80, 1.0);

    for i = 1, 3 do
        fire = ents.Create("env_fire");

        fire:SetPos(self:GetPos() + Vector(math.Rand(-100, 100), math.Rand(-100, 100), 0));
        fire:DropToFloor();
        fire:SetKeyValue("StartDisabled", 0);
        fire:SetKeyValue("damagescale", 1);
        fire:SetKeyValue("fireattack", 2);
        fire:SetKeyValue("firesize", 40);
        fire:SetKeyValue("ignitionpoint", 0);
        fire:SetKeyValue("health", 15);
        
        fire:Spawn();
        fire:Fire("StartFire", "", math.Rand(.3, 2));
        SafeRemoveEntityDelayed(fire, 15);
    end;

    self:Remove();
end;