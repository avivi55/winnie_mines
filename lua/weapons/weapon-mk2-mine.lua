DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/shrapnel_mine_mk_ii/shrapnel_mine_mk_ii.mdl";
SWEP.WorldModel     = "models/shrapnel_mine_mk_ii/shrapnel_mine_mk_ii.mdl";

SWEP.Primary.Ammo   = "ammo_mk2_mine";

SWEP.VForward       = 10;
SWEP.VRight         = 5;
SWEP.VUp            = -13;

SWEP.VRightAxis     = -13;
SWEP.VUpAxis        = -8;

SWEP.WVector        = Vector(-4, -3, 8);
SWEP.WAngle         = Angle(150, -50, -30);

SWEP.OffsetVector   = Vector(0, 0, -12);

SWEP.entToSpawn_    = "bouncing_mine_base";

if (CLIENT) then SWEP.PrintName = "[UK]Anti-Personel MK2 Mine"; end;