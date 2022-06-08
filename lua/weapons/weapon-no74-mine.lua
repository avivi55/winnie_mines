if (SERVER) then
    AddCSLuaFile();
    SWEP.Weight = 1;
    SWEP.AutoSwitchTo = false;
    SWEP.AutoSwitchFrom = false;
end;

SWEP.Author = "Winnie";

SWEP.Instructions = [[Left Click : throw mine]];
SWEP.Category = "Winnie's weapons";
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.ViewModel = "models/bfv/gadgets/uk_no74_sticky_bomb.mdl";
SWEP.WorldModel = "models/bfv/gadgets/uk_no74_sticky_bomb.mdl";

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "ammo_tnt_mine";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

if (CLIENT) then
    SWEP.PrintName = "[UK] N°74 Anti Tank Grenade";
    SWEP.Slot = 4;
    SWEP.SlotPos = 1;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = true;

    function SWEP:GetViewModelPosition(pos, ang)
        ang:RotateAroundAxis(ang:Right(), -7);
        ang:RotateAroundAxis(ang:Up(), -75);
        pos = pos + ang:Forward() * 12;
        pos = pos + ang:Right() * -13;
        pos = pos + ang:Up() * -6;
        return pos, ang;
    end;

    local WorldModel = ClientsideModel(SWEP.WorldModel);

    WorldModel:SetSkin(5);
    WorldModel:SetNoDraw(true);

    function SWEP:DrawWorldModel()
        local _owner = self:GetOwner();

        if (IsValid(_owner)) then
            local offsetVec = Vector(1.5, -1, 2);
            local offsetAng = Angle(150, 0, 0);

            local boneid = _owner:LookupBone("ValveBiped.Bip01_R_Hand");
            if (!boneid) then return end

            local matrix = _owner:GetBoneMatrix(boneid);
            if (!matrix) then return end

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
    local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

    return self.nextFire <= CurTime() and PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200;
end;

function SWEP:CanSecondaryAttack()
    self.nextFire = self.nextFire or 0;
    return self.nextFire <= CurTime();
end;

function SWEP:SetNextPrimaryFire(time) self.nextFire = time; end;

function SWEP:PrimaryAttack()
    if (self:Ammo1() < 0) then self:GetOwner():StripWeapon(self:GetClass()) return; end;
    if (!self:CanSecondaryAttack()) then return; end;

    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
    self:GetOwner():SetAnimation(PLAYER_ATTACK1);

    self:ThrowGrenade();

    self:SetNextPrimaryFire(CurTime() + 2);

    self:TakePrimaryAmmo(1);

    if (SERVER and self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); end;
end;

function SWEP:SecondaryAttack() return; end;

function SWEP:ThrowGrenade()
    if (CLIENT) then return; end;

    local ent = ents.Create("no74-mine");

    if (IsValid(ent)) then
        local ply = self:GetOwner();
        local EyeAng = ply:EyeAngles();

        ent:SetPos(ply:GetShootPos() - Vector(0,0,10));
        ent:SetAngles(Angle(0,EyeAng.y,0));
        ent:SetCreator(ply);
        ent:Spawn();

        local PhysObj = ent:GetPhysicsObject();
        if (IsValid(PhysObj)) then
            PhysObj:SetVelocity(EyeAng:Forward() * 500 + Vector(0,0,110));
            PhysObj:AddAngleVelocity(VectorRand() * 20);
        end;
    end;
end;