if SERVER then
    AddCSLuaFile ();
    SWEP.Weight = 1;
    SWEP.AutoSwitchTo = false;
    SWEP.AutoSwitchFrom = false;
end;

SWEP.Author = "Winnie";

SWEP.Instructions = [[Left Click : Plant Mine]];
SWEP.Category = "Winnie's weapons";
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.ViewModel = "models/antitankmine_gs_mkv/antitankmine_gs_mkv.mdl";
SWEP.WorldModel = "models/antitankmine_gs_mkv/antitankmine_gs_mkv.mdl";

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "slam";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

if CLIENT then
    SWEP.PrintName = "[UK]Anti-Tank MK5 Mine";
    SWEP.Slot = 4;
    SWEP.SlotPos = 1;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = true;

    function SWEP:GetViewModelPosition( pos, ang )
        ang:RotateAroundAxis( ang:Right(), -8 );
        ang:RotateAroundAxis( ang:Up(), -70 );
        pos = pos + ang:Forward()*13;
        pos = pos + ang:Right()*-13;
        pos = pos + ang:Up()*-5;
        return pos, ang;
    end;

    local WorldModel = ClientsideModel(SWEP.WorldModel);

	-- Settings...
	WorldModel:SetSkin(1);
	WorldModel:SetNoDraw(true);

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner();

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(5, -4, 1);
			local offsetAng = Angle(190, 100, -50);

			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand"); -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid);
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles());

			WorldModel:SetPos(newPos);
			WorldModel:SetAngles(newAng);

            WorldModel:SetupBones();
		else
			WorldModel:SetPos(self:GetPos());
			WorldModel:SetAngles(self:GetAngles());
		end;

		WorldModel:DrawModel();
	end;
end;

function SWEP:Initialize()
    self.Weapon:SetHoldType( "slam" );
end;

function SWEP:TakePrimaryAmmo( count )
	if self.Weapon:Clip1() <= 0 then

		if self:Ammo1() <= 0 then return end;

		self.Owner:RemoveAmmo( count, self.Weapon:GetPrimaryAmmoType() );

		return
	end;

	self.Weapon:SetClip1( self.Weapon:Clip1() - count );
end;

function SWEP:CanPrimaryAttack()
    self.nextFire = self.nextFire or 0;
    local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

	return self.nextFire <= CurTime() and self:Ammo1() > 0 and PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200;
end

function SWEP:SetNextPrimaryFire( time )
    self.nextFire = time;
end

function SWEP:PrimaryAttack()
    if SERVER then
        if( !self:CanPrimaryAttack() )then return end;
        self:TakePrimaryAmmo( 1 );

        local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

        if PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200 then
            local mine = ents.Create("mk5-mine");
            mine:SetPos(PlayerTrace);
            mine:Spawn();
            mine:SetCreator( self:GetOwner() );
        end;

        self:SetNextPrimaryFire( CurTime() + 1.5 );

        if self:Ammo1() <= 0 then
			self:GetOwner():StripWeapon( self:GetClass() );
		end;
    end;
end;