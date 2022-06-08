DEFINE_BASECLASS("_mine_weapon");

SWEP.Base           = "_mine_weapon";

SWEP.Category       = "Winnie's weapons";
SWEP.Spawnable      = true;
SWEP.AdminSpawnable = true;

SWEP.ViewModel      = "models/mle_1935_hat/mle_1935_hat.mdl";
SWEP.WorldModel     = "models/mle_1935_hat/mle_1935_hat.mdl";

SWEP.Primary.Ammo   = "ammo_mle35_mine";

SWEP.VRightAxis     = -10;
SWEP.VUpAxis        = -80;

SWEP.VForward       = 13;
SWEP.VRight         = -14;
SWEP.VUp            = -6;

SWEP.WVector        = Vector(5, -3.5, 3);
SWEP.WAngle         = Angle(180, 90, -40);

SWEP.OffsetVector   = Vector(0, 0, -2);

SWEP.entToSpawn_    = "antitank_mine_base";

if (CLIENT) then SWEP.PrintName = "[FR]Anti-Tank MLE 1935 Mine"; end;