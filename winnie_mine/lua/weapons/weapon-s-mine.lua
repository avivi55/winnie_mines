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
SWEP.ViewModel = "models/bfv/gadgets/ger_s-mine.mdl";
SWEP.WorldModel = "models/bfv/gadgets/ger_s-mine.mdl";

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "slam";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

if CLIENT then
    SWEP.PrintName = "Anti-Personel Mine";
    SWEP.Slot = 4;
    SWEP.SlotPos = 1;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = true;

    function SWEP:GetViewModelPosition( pos, ang )
        ang:RotateAroundAxis( ang:Right(), -7 );
        ang:RotateAroundAxis( ang:Up(), -75 );
        pos = pos + ang:Forward()*12;
        pos = pos + ang:Right()*-13;
        pos = pos + ang:Up()*-9;
        return pos, ang;
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

	return self.nextFire <= CurTime() and self:Ammo1() > 0;
end;

function SWEP:SetNextPrimaryFire( time )
    self.nextFire = time;
end;

function SWEP:PrimaryAttack()
    if SERVER then
        if( !self:CanPrimaryAttack() )then self:GetOwner():StripWeapon( self:GetClass() ); return end;
        self:TakePrimaryAmmo( 1 );

        local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

        if PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200 then
            local mine = ents.Create("s-mine");
            mine:SetPos(PlayerTrace + Vector(0, 0, -6));
            mine:Spawn();
            mine:SetCreator( self:GetOwner() );
        end;

        self:SetNextPrimaryFire( CurTime() + 2 );

        if self:Ammo1() <= 0 then
			self:GetOwner():StripWeapon( self:GetClass() );
		end;
    end;
end;