include("shared.lua");
game.AddParticles("particles/explosion.pcf")
PrecacheParticleSystem("ExplosionCore_wall")
function ENT:Draw() self:DrawModel(); end;