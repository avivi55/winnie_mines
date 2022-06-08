DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/antitankmine_gs_mkv/antitankmine_gs_mkv.mdl";
SWEP.WorldModel     = "models/antitankmine_gs_mkv/antitankmine_gs_mkv.mdl";

SWEP.Primary.Ammo   = "ammo_mk5_mine";

SWEP.VRightAxis     = -9;
SWEP.VUpAxis        = -70;

SWEP.VForward       = 13;
SWEP.VRight         = -13;
SWEP.VUp            = -8;

SWEP.WVector        = Vector(6, -2, 5);
SWEP.WAngle         = Angle(190, 100, -50);

SWEP.OffsetVector   = Vector(0, 0, -4);

SWEP.entToSpawn_    = "antitank_mine_base";

if (CLIENT) then SWEP.PrintName = "[UK]Anti-Tank MK5 Mine"; end;