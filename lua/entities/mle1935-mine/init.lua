AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include('shared.lua');

function ENT:Initialize()
	self:SetModel( "models/mle_1935_hat/mle_1935_hat.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:SetSolid( SOLID_VPHYSICS );

	self.phys = self:GetPhysicsObject();

	if ( self.phys:IsValid() ) then
		self.phys:Wake();
        self.phys:EnableMotion(false);
	end;

	self:EmitSound("physics/glass/glass_strain2.wav");
end;


function ENT:Touch( ent )
	if( ent:GetClass():lower() ~= self:GetClass() and !ent:IsPlayer())then
		local dmginfo = DamageInfo();
		dmginfo:SetDamage( 1000 );
		dmginfo:SetAttacker( self:GetCreator() );
		dmginfo:SetDamageType( DMG_DIRECT );
		dmginfo:SetInflictor( self );
		dmginfo:SetDamagePosition( self:GetPos() );

		if( ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" )then --* based for simfphys vehicles
			ent:GetBaseEnt():TakeDamageInfo( dmginfo );
		else
			ent:TakeDamageInfo( dmginfo );
		end;
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

		if IsValid( self.defusor ) and isnumber( self.defuseTime ) then
			if( self.defusor:KeyDown( IN_USE ) and (self:GetPos() - self.defusor:GetPos()):Length() < 100 )then
				if( CurTime() - self.defuseTime > 2 )then
					self:EmitSound( "weapons/c4/c4_disarm.wav" );

					local w_mine = ents.Create( "weapon-mle1935-mine" );
					w_mine:SetPos( self.defusor:GetShootPos() );
					w_mine:Spawn();
					w_mine:Activate();

					self.defusor:PrintMessage( HUD_PRINTCENTER, "✓");

					if( self.defusor:HasWeapon( "weapon-mle1935-mine" ) )then
						self.defusor:SelectWeapon( "weapon-mle1935-mine" );
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

function ENT:Detonate()
	local explosion = ents.Create("env_explosion");
	explosion:SetPos(self:GetPos());
	explosion:Spawn();
	explosion:SetKeyValue("iMagnitude", 100);
	explosion:SetKeyValue("iRadiusOverride", 200);
	explosion:Fire("explode");
	self:EmitSound("ins2_explosion/explode.wav");
	self:Remove();
end;