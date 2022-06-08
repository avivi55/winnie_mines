DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/m1a1_mine/m1a1_mine.mdl";
SWEP.WorldModel     = "models/m1a1_mine/m1a1_mine.mdl";

SWEP.Primary.Ammo   = "ammo_m2a1_mine";

SWEP.VRightAxis     = -8;
SWEP.VUpAxis        = -70;

SWEP.VForward       = 13;
SWEP.VRight         = -13;
SWEP.VUp            = -8;

SWEP.WVector        = Vector(9, -3, 0);
SWEP.WAngle         = Angle(190, 100, -50);

SWEP.OffsetVector   = Vector(0, 0, -2.5);

SWEP.entToSpawn_    = "antitank_mine_base";

if (CLIENT) then SWEP.PrintName = "[US]Anti-Tank M1A1 Mine"; end;