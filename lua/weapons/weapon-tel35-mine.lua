DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/tmi_35/tmi_35.mdl";
SWEP.WorldModel     = "models/tmi_35/tmi_35.mdl";

SWEP.Primary.Ammo   = "ammo_tel35_mine";

SWEP.VForward       = 14;
SWEP.VRight         = -15;
SWEP.VUp            = -8;

SWEP.VRightAxis     = -8;
SWEP.VUpAxis        = -70;

SWEP.WVector        = Vector(11, -3, 0);
SWEP.WAngle         = Angle(170, 125, -56);

SWEP.OffsetVector   = Vector(0, 0, -4);

SWEP.entToSpawn_    = "antitank_mine_base";

if (CLIENT) then  SWEP.PrintName = "[DE]Anti-Tank Tellermine 35"; end;