DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/bfv/gadgets/ger_s-mine.mdl";
SWEP.WorldModel     = "models/bfv/gadgets/ger_s-mine.mdl";

SWEP.Primary.Ammo   = "ammo_s_mine";

SWEP.VForward       = 12;
SWEP.VRight         = -13;
SWEP.VUp            = -9;

SWEP.VRightAxis     = -7;
SWEP.VUpAxis        = -75;

SWEP.WVector        = Vector(2, -3, 2);
SWEP.WAngle         = Angle(150, 10, 0);

SWEP.OffsetVector   = Vector(0, 0, -6);

SWEP.entToSpawn_    = "bouncing_mine_base";

if (CLIENT) then SWEP.PrintName = "[DE]Anti-Personel S-Mine"; end;