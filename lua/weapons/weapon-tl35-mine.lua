DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/mina35/mina35.mdl";
SWEP.WorldModel     = "models/mina35/mina35.mdl";

SWEP.Primary.Ammo   = "ammo_tl35_mine";

SWEP.VForward       = 13;
SWEP.VRight         = -13;
SWEP.VUp            = -5;

SWEP.VRightAxis     = -8;
SWEP.VUpAxis        = -70;

SWEP.WVector        = Vector(6, -3, 0);
SWEP.WAngle         = Angle(190, 120, -60);

SWEP.OffsetVector   = Vector(0, 0, -0.5);

SWEP.entToSpawn_    = "antitank_mine_base";

if (CLIENT) then SWEP.PrintName = "[URSS]Anti-Tank TL35 Mine"; end;