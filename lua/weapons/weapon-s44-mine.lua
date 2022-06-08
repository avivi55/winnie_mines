DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/codww2/equipment/s-mine 44.mdl";
SWEP.WorldModel     = "models/codww2/equipment/s-mine 44.mdl";

SWEP.Primary.Ammo   = "ammo_s44_mine";

SWEP.VForward       = 12;
SWEP.VRight         = -13;
SWEP.VUp            = -9;

SWEP.VRightAxis     = 3;
SWEP.VUpAxis        = -75;

SWEP.WVector        = Vector(3, -3, 0);
SWEP.WAngle         = Angle(150, 10, 0);

SWEP.OffsetVector   = Vector(0, 0, -3);

SWEP.entToSpawn_    = "bouncing_mine_base";

if (CLIENT) then SWEP.PrintName = "[DE]Anti-Personel S-Mine 44"; end;