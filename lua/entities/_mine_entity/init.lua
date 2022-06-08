AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

function ENT:Initialize()
	self:SetModel(self.Model);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);

	self.phys = self:GetPhysicsObject();
	if (self.phys:IsValid()) then
		self.phys:Wake();
		self.phys:EnableMotion(false);
	end;
	self.desactived = false;
	self.detonated = false;

	self:EmitSound("physics/glass/glass_strain2.wav");
end;

function ENT:Use(ply)
	if (!IsValid(self.defusor)) then
		self.defusor = ply;
		self.defuseTime = CurTime();
		self:EmitSound("weapons/elite/elite_reloadstart.wav");
		ply:PrintMessage(HUD_PRINTCENTER, "...");
	end;
end;

function ENT:Think()
	if (SERVER) then
		if (!IsValid(self:GetCreator())) then self:Remove(); end;

		if (IsValid(self.defusor) and isnumber(self.defuseTime)) then
			if (self.defusor:KeyDown(IN_USE) and (self:GetPos() - self.defusor:GetPos()):Length() < 100) then
				if (CurTime() - self.defuseTime > 2) then
					self:EmitSound("weapons/c4/c4_disarm.wav");

					local w_mine = ents.Create(self.WeaponClassName);
					w_mine:SetPos(self.defusor:GetShootPos());
					w_mine:Spawn();
					w_mine:Activate();

					self.defusor:PrintMessage(HUD_PRINTCENTER, "✓");

					if (self.defusor:HasWeapon(self.WeaponClassName)) then self.defusor:SelectWeapon(self.WeaponClassName);end;

					self:Remove();
				end;
			else
				self.defusor:PrintMessage(HUD_PRINTCENTER, "X");
				self.defusor = nil;
				self:EmitSound("weapons/deagle/de_clipout.wav");
			end;
		end;

		if (self:GetCreator():GetEyeTraceNoCursor().Entity == self and self:GetCreator():KeyDown(IN_RELOAD) 
			and (self:GetPos() - self:GetCreator():GetPos()):Length() < 100) then

			if (!self.desactived) then
				self:EmitSound("weapons/c4/c4_disarm.wav");
				self.desactived = true;
				self:GetCreator():PrintMessage(HUD_PRINTCENTER, "Deactivated");
				self:SetColor(Color(255, 0, 0, 0));
				timer.Simple(0.5, function() self:SetColor(Color(255, 255, 255, 0)) end);
			else
				self:EmitSound("weapons/c4/c4_disarm.wav");
				self.desactived = false;
				self:GetCreator():PrintMessage(HUD_PRINTCENTER, "Activated");
				self:SetColor(Color(0, 255, 0, 0));
				timer.Simple(0.5, function() self:SetColor(Color(255, 255, 255, 0)) end);
			end;
		end;
	end;
end;

function ENT:Detonate()
	if (self.detonated) then return end
	
	self.detonated = true;

	local explosionDamage =	150;
	local explosionRadius =	300;
	local pos = self:GetPos();

	net.Start("gred_net_createparticle")
		local tr = util.TraceLine({start = pos,endpos = pos-Vector(0,0,100),filter = self});
		
		net.WriteString("doi_artillery_explosion");
		net.WriteVector(pos);
		net.WriteAngle(Angle(-90,0,0));
		net.WriteBool(tr.HitWorld);
	net.Broadcast();

	gred.CreateExplosion(pos,explosionRadius,explosionDamage,self.Decal,self.TraceLength,self.Attacker,self,self.DEFAULT_PHYSFORCE,self.DEFAULT_PHYSFORCE_PLYGROUND,self.DEFAULT_PHYSFORCE_PLYAIR);

	if (self:WaterLevel() == 0) then
		self:EmitSound("explosion/mortar_strike_close_0" .. math.random(1,4) .. ".wav");
	else
		self:EmitSound("explosion/mortar_strike_close_water_0" .. math.random(1,4) .. ".wav");
	end
	self:Remove();
end;