DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/mle_1939_ap/mle_1939_ap.mdl";
SWEP.WorldModel     = "models/mle_1939_ap/mle_1939_ap.mdl";

SWEP.Primary.Ammo   = "ammo_mle39_mine";

SWEP.VForward       = 12;
SWEP.VRight         = -12;
SWEP.VUp            = -12;

SWEP.VRightAxis     = -7;
SWEP.VUpAxis        = -75;

SWEP.WVector        = Vector(-1, -2, 6);
SWEP.WAngle         = Angle(150, 10, 0);

SWEP.OffsetVector   = Vector(0, 0, -10);

SWEP.entToSpawn_    = "bouncing_mine_base";

if (CLIENT) then SWEP.PrintName = "[FR]Anti-Personel MLE 1939 Mine"; end;