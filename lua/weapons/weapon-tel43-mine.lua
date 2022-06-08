DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/codww2/equipment/tellermine 43.mdl";
SWEP.WorldModel     = "models/codww2/equipment/tellermine 43.mdl";

SWEP.Primary.Ammo   = "ammo_tel43_mine";

SWEP.VForward       = 13;
SWEP.VRight         = -13;
SWEP.VUp            = -5;

SWEP.VRightAxis     = -8;
SWEP.VUpAxis        = -70;

SWEP.WVector        = Vector(6, -6, -1);
SWEP.WAngle         = Angle(180, 120, -40);

SWEP.OffsetVector   = Vector(0, 0, 1);

SWEP.entToSpawn_    = "antitank_mine_base";

if (CLIENT) then SWEP.PrintName = "[DE]Anti-Tank Tellermine 43"; end;