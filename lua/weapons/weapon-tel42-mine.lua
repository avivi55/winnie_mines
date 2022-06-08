DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/bfv/gadgets/ger_tellermine42.mdl";
SWEP.WorldModel     = "models/bfv/gadgets/ger_tellermine42.mdl";

SWEP.Primary.Ammo   = "ammo_tel42_mine";

SWEP.VForward       = 13;
SWEP.VRight         = -13;
SWEP.VUp            = -5;

SWEP.VRightAxis     = -8;
SWEP.VUpAxis        = -70;

SWEP.WVector        = Vector(6, -5, 2);
SWEP.WAngle         = Angle(190, 120, -50);

SWEP.OffsetVector   = Vector(0, 0, -1);

SWEP.entToSpawn_    = "antitank_mine_base";

if (CLIENT) then SWEP.PrintName = "[DE]Anti-Tank Tellermine 42"; end;