if (SERVER) then
    AddCSLuaFile();
    SWEP.Weight = 1;
    SWEP.AutoSwitchTo = false;
    SWEP.AutoSwitchFrom = false;
end;

SWEP.Author = "Winnie";

SWEP.Instructions = [[Left Click : Plant Mine]];
SWEP.Category = "Winnie's weapons";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;

SWEP.ViewModel = "models/props_interiors/pot01a.mdl";
SWEP.WorldModel = "models/props_interiors/pot01a.mdl";

SWEP.VForward = 1;
SWEP.VRight   = 1;
SWEP.VUp      = 1;

SWEP.VRightAxis   = 1;
SWEP.VUpAxis      = 1;

SWEP.WVector = Vector(0, 0, 0);
SWEP.WAngle  = Angle(150, 10, 0);

SWEP.OffsetVector = Vector(2, -3, 2);

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

SWEP.entToSpawn_ = "";

if (CLIENT) then
    SWEP.PrintName = "0";
    SWEP.Slot = 4;
    SWEP.SlotPos = 1;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = true;

    function SWEP:GetViewModelPosition(pos, ang)
        ang:RotateAroundAxis(ang:Right(), self.VRightAxis);
        ang:RotateAroundAxis(ang:Up(), self.VUpAxis);
        pos = pos + ang:Forward() * self.VForward;
        pos = pos + ang:Right() * self.VRight;
        pos = pos + ang:Up() * self.VUp;
        return pos, ang;
    end;

    local WorldModel = ClientsideModel(SWEP.WorldModel);

    WorldModel:SetSkin(1);
    WorldModel:SetNoDraw(true);
    function SWEP:DrawWorldModel()
        local _owner = self:GetOwner();
        if (IsValid(_owner)) then
            local offsetVec = self.WVector;
            local offsetAng = self.WAngle;
            
            WorldModel:SetModel(self.WorldModel);

            local boneid = _owner:LookupBone("ValveBiped.Bip01_R_Hand");
            if (!boneid) then return; end;
            local matrix = _owner:GetBoneMatrix(boneid);
            if (!matrix) then return; end;

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles());

            WorldModel:SetPos(newPos);
            WorldModel:SetAngles(newAng);

            WorldModel:SetupBones();
        else
            WorldModel:SetPos(self:GetPos());
            WorldModel:SetAngles(self:GetAngles());
        end;
        WorldModel:DrawModel();
    end;
end;

function SWEP:Initialize() self:SetHoldType("slam"); end;

function SWEP:TakePrimaryAmmo(count)
    if (self:Clip1() <= 0) then
        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); return end;

        self:GetOwner():RemoveAmmo(count, self:GetPrimaryAmmoType());

        return;
    end;

    self:SetClip1(self:Clip1() - count);
end;

function SWEP:CanPrimaryAttack()
    self.nextFire = self.nextFire or 0;
    return self.nextFire <= CurTime();
end;

function SWEP:SetNextPrimaryFire(time) self.nextFire = time; end;

function SWEP:PrimaryAttack()
    if (SERVER) then
        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); return; end;
        if (!self:CanPrimaryAttack()) then return; end;

        local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

        if (PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200) then
            local mine = ents.Create(self.entToSpawn_);

            mine.Model = self.ViewModel;
            mine.WeaponClassName = self.ClassName;

            mine:SetPos(PlayerTrace + self.OffsetVector);
            mine:SetAngles(Angle(0,self:GetOwner():EyeAngles().y + 90,0));
            mine:Spawn();
            mine:SetCreator(self:GetOwner());
            if (IsValid(mine)) then
                self:TakePrimaryAmmo(1);
                self:SetNextPrimaryFire(CurTime() + 2);
            end;
        else
            self:GetOwner():PrintMessage(HUD_PRINTCENTER, "Place Mine on surface !!");
            return;
        end;


        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); end;
    end;
end;

function SWEP:SecondaryAttack() return; end;