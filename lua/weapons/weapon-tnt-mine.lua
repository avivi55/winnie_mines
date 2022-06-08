if (SERVER) then
    AddCSLuaFile();
    SWEP.Weight = 1;
    SWEP.AutoSwitchTo = false;
    SWEP.AutoSwitchFrom = false;
end;

SWEP.Author = "Winnie";

SWEP.Instructions = [[Left Click : Plant TNT
Right Click : Throw TNT]];
SWEP.Category = "Winnie's weapons";
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.ViewModel = "models/codww2/equipment/satchel charge.mdl";
SWEP.WorldModel = "models/codww2/equipment/satchel charge.mdl";

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "ammo_tnt_mine";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

if (CLIENT) then
    SWEP.PrintName = "TNT";
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

    WorldModel:SetSkin(1);
    WorldModel:SetNoDraw(true);

    function SWEP:DrawWorldModel()
        local _owner = self:GetOwner();

        if (IsValid(_owner)) then
            local offsetVec = Vector(3, -3, -1);
            local offsetAng = Angle(40, 180, 0);

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
        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); return; end;

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
    //local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

    return self.nextFire <= CurTime();
end;

function SWEP:SetNextPrimaryFire(time) self.nextFire = time; end;

function SWEP:PrimaryAttack()
    if (SERVER) then
        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); return; end;
        if (!self:CanPrimaryAttack()) then return; end;

        local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

        if (PlayerTrace:Distance(self:GetOwner():GetPos()) < 200) then
            local res = util.TraceLine{ start = self:GetOwner():GetShootPos(),
                                        endpos = self:GetOwner():GetShootPos() + 115 * self:GetOwner():GetAimVector(),
                                        filter = self:GetOwner()};

            if (res.Hit) then
                local mine = ents.Create("tnt-mine");
                mine:SetPos(PlayerTrace);
                res.HitNormal.z = -res.HitNormal.z;
                mine:SetAngles(res.HitNormal:Angle());
                mine:Spawn();
                mine:SetCreator(self:GetOwner());
                if (IsValid(res.Entity)) then
                    if (!(res.Entity:IsNPC() or res.Entity:IsPlayer()) and res.Entity:GetPhysicsObject():IsValid()) then
                        constraint.Weld(mine, res.Entity, 0, 0, 0, true, false);
                        mine.ent = res.Entity;
                    end;
                elseif (mine.phys:IsValid()) then mine.phys:EnableMotion(false); end;
            end;
        end;

        self:TakePrimaryAmmo(1);

        self:SetNextPrimaryFire(CurTime() + 2);

        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); end;
    end;
end;

function SWEP:SecondaryAttack()
    if (SERVER) then
        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); return; end;
        if (!self:CanSecondaryAttack()) then return; end;

        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
        self:GetOwner():SetAnimation(PLAYER_ATTACK1);

        self:ThrowTNT();

        self:SetNextPrimaryFire(CurTime() + 2);

        self:TakePrimaryAmmo(1);

        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); end;
    end;
end;


function SWEP:ThrowTNT()
    if (CLIENT) then return; end;

    local ent = ents.Create("tnt-mine");
    local ply = self:GetOwner();

    if (IsValid(ent)) then
        local EyeAng = ply:EyeAngles();

        ent:SetPos(ply:GetShootPos() - Vector(0,0,10));
        ent:SetAngles(Angle(0,EyeAng.y,0));
        ent:Spawn();

        local PhysObj = ent:GetPhysicsObject();
        if (IsValid(PhysObj)) then
            PhysObj:SetVelocity(EyeAng:Forward() * 250 + Vector(0,0,200));
            PhysObj:AddAngleVelocity(VectorRand() * 20);
        end;
    end;
end;