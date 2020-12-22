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
SWEP.ViewModel = "models/shrapnel_mine_mk_ii/shrapnel_mine_mk_ii.mdl";
SWEP.WorldModel = "models/shrapnel_mine_mk_ii/shrapnel_mine_mk_ii.mdl";

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "slam";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

if CLIENT then
    SWEP.PrintName = "[UK]Anti-Personel MK2 Mine";
    SWEP.Slot = 4;
    SWEP.SlotPos = 1;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = true;

    function SWEP:GetViewModelPosition( pos, ang )
        ang:RotateAroundAxis( ang:Right(), -7 );
        ang:RotateAroundAxis( ang:Up(), -75 );
        pos = pos + ang:Forward()*12;
        pos = pos + ang:Right()*-13;
        pos = pos + ang:Up()*-8;
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
			local offsetVec = Vector(2.5, -3, 1);
			local offsetAng = Angle(150, -50, -30);

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

		if self:Ammo1() <= 0 then self:GetOwner():StripWeapon( self:GetClass() ); return end;

		self.Owner:RemoveAmmo( count, self.Weapon:GetPrimaryAmmoType() );

		return
	end;

	self.Weapon:SetClip1( self.Weapon:Clip1() - count );
end;

function SWEP:CanPrimaryAttack()
    self.nextFire = self.nextFire or 0;
    local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

	return self.nextFire <= CurTime() and PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200;
end;

function SWEP:SetNextPrimaryFire( time )
    self.nextFire = time;
end;

function SWEP:PrimaryAttack()
    if SERVER then
        if( !(self:Ammo1() > 0) )then self:GetOwner():StripWeapon( self:GetClass() ); return end;
        if( !self:CanPrimaryAttack() )then return end;
        self:TakePrimaryAmmo( 1 );

        local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

        if PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200 then
            local mine = ents.Create("mk2-mine");
            mine:SetPos(PlayerTrace + Vector(0, 0, -4));
            mine:SetAngles( Angle(0,self:GetOwner():EyeAngles().y + 90,0) );
            mine:Spawn();
            mine:SetCreator( self:GetOwner() );
        end;

        self:SetNextPrimaryFire( CurTime() + 2 );

        if self:Ammo1() <= 0 then
			self:GetOwner():StripWeapon( self:GetClass() );
		end;
    end;
end;