AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include('shared.lua');

function ENT:Initialize()
	self:SetModel( "models/m2a1_mine/m2a1_mine.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:SetSolid( SOLID_VPHYSICS );
    self.spawnedTime = CurTime();
    self.isLaunched = false;
	self.gamemode = engine.ActiveGamemode()
	self.gamemodeCheck = self.gamemode == "militaryrp"

	self.boom = false;

    self.phys = self:GetPhysicsObject();

	if ( self.phys:IsValid() ) then
		self.phys:Wake();
        self.phys:EnableMotion(false);
	end;
	self:EmitSound("physics/glass/glass_strain2.wav");
end;



function ENT:OnTakeDamage( damage )
	if IsValid(self) and self.boom == false then
		self:Detonate();
	end;
end;

function ENT:Use( ply )
	if not IsValid( self.Defusor ) then
		self.defusor = ply;
		self.defuseTime = CurTime();
		self:EmitSound( "weapons/elite/elite_reloadstart.wav" );
		ply:PrintMessage( HUD_PRINTCENTER, "...");
	end;
end;

function ENT:Think()
	if SERVER then
		if( !IsValid(self:GetCreator() ))then self:Remove(); end;

		if self.isLaunched then return end;

		for _,ent in pairs(ents.FindInSphere(self:GetPos(),135)) do
			if( ent:IsPlayer() or ent:IsNPC() )then
				if( self.gamemodeCheck )then
					if( ent ~= self:GetCreator() )then
						self:Launch();
					end;
				else
					self:Launch();
					return
				end;
			end;
		end;

		if IsValid( self.defusor ) and isnumber( self.defuseTime ) then
			if( self.defusor:KeyDown( IN_USE ) and (self:GetPos() - self.defusor:GetPos()):Length() < 100 )then
				if( CurTime() - self.defuseTime > 2 )then
					self:EmitSound( "weapons/c4/c4_disarm.wav" );

					local w_mine = ents.Create( "weapon-m2a1-mine" );
					w_mine:SetPos( self.defusor:GetShootPos() );
					w_mine:Spawn();
					w_mine:Activate();

					self.defusor:PrintMessage( HUD_PRINTCENTER, "✓");

					if( self.defusor:HasWeapon( "weapon-m2a1-mine" ) )then
						self.defusor:SelectWeapon( "weapon-m2a1-mine" );
					end;

					self:Remove();
				end;
			else
				self.defusor:PrintMessage( HUD_PRINTCENTER, "X");
				self.defusor = nil;
				self:EmitSound( "weapons/deagle/de_clipout.wav" );
			end;
		end;
	end;
end;

function ENT:Launch()
	if self.spawnedTime + 2 > CurTime() then return end;

	self.phys:EnableMotion(true);
	self.phys:SetVelocity(Vector(0,0,350));
	self:EmitSound("ins2_pin/nvg_off.wav", 75, 100, 500);

	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	timer.Simple(0.4, function() if IsValid(self) then self:SetCollisionGroup( COLLISION_GROUP_NONE ) end end);

	if( math.random(1,1000) ~= 4 )then
		timer.Simple(1, function() if IsValid(self) then self:Detonate() end end);
	end;

	self.isLaunched = true;
end;

function ENT:Detonate()
	local explosion = ents.Create("env_explosion");
	explosion:SetPos(self:GetPos());
	explosion:Spawn();
	explosion:SetKeyValue("iMagnitude", 300);
	explosion:SetKeyValue("iRadiusOverride", 400);
	explosion:Fire("explode");
	self:EmitSound("ins2_explosion/explode.wav");
	self.boom = true;
	self:Remove();
end;