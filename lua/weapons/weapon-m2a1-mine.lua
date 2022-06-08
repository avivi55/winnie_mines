DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/m2a1_mine/m2a1_mine.mdl";
SWEP.WorldModel     = "models/m2a1_mine/m2a1_mine.mdl";

SWEP.Primary.Ammo   = "ammo_m2a1_mine";

SWEP.VForward       = 12;
SWEP.VRight         = -2;
SWEP.VUp            = -12;

SWEP.VRightAxis     = -13;
SWEP.VUpAxis        = -9;

SWEP.WVector        = Vector(0, 3, 7);
SWEP.WAngle         = Angle(160, 10, 0);

SWEP.OffsetVector   = Vector(0, 0, -5);

SWEP.entToSpawn_    = "bouncing_mine_base";

if (CLIENT) then SWEP.PrintName = "[US]Anti-Personel M2A1 Mine"; end;