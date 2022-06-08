if (SERVER) then
    AddCSLuaFile();
    SWEP.Weight = 1;
    SWEP.AutoSwitchTo = false;
    SWEP.AutoSwitchFrom = false;
end;

SWEP.Author = "Winnie";

SWEP.Instructions = [[Left Click : Plant Mine]];
SWEP.Category = "Winnie's weapons";
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.ViewModel = "models/hafthohlladung/hafthohlladung.mdl";
SWEP.WorldModel = "models/hafthohlladung/hafthohlladung.mdl";

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "ammo_haft_mine";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

if (CLIENT) then
    SWEP.PrintName = "[DE]Anti-Tank HAFTHOHLLADUNG";
    SWEP.Slot = 4;
    SWEP.SlotPos = 1;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = true;

    function SWEP:GetViewModelPosition(pos, ang)
        ang:RotateAroundAxis(ang:Right(), -7);
        ang:RotateAroundAxis(ang:Up(), -75);
        pos = pos + ang:Forward() * 12;
        pos = pos + ang:Right() * -13;
        pos = pos + ang:Up() * -10;
        return pos, ang;
    end;

    local WorldModel = ClientsideModel(SWEP.WorldModel);

    WorldModel:SetSkin(1);
    WorldModel:SetNoDraw(true);

    function SWEP:DrawWorldModel()
        local _owner = self:GetOwner();

        if (IsValid(_owner)) then
            local offsetVec = Vector(3, -1, 13);
            local offsetAng = Angle(180, 0, 0);

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

if (SERVER) then
    hook.Add("PlayerTick", "Winnie_Mines_Haft_pervisualization", function(ply, mv)
        local wep = ply:GetActiveWeapon();
        //local ang = ply:GetAngles();
        local tr = ply:GetEyeTrace();

        if (IsValid(ply) and ply:Alive() and ply:HasWeapon("weapon-haft-mine") and IsValid(wep) and wep:GetClass() == "weapon-haft-mine") then
            if (!IsValid(ply.haftmineprevis)) then
                ply.haftmineprevis = ents.Create("prop_physics");
                if (IsValid(ply.haftmineprevis)) then
                    ply.haftmineprevis:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0));
                    ply.haftmineprevis:SetPos(tr.HitPos - tr.HitNormal * ply.haftmineprevis:OBBMins().z);
                    ply.haftmineprevis:SetColor(Color(255, 0, 0, 150));
                    ply.haftmineprevis:SetModel("models/hafthohlladung/hafthohlladung.mdl");
                    ply.haftmineprevis:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);
                    ply.haftmineprevis:SetRenderMode(RENDERMODE_TRANSALPHA);
                    ply.haftmineprevis:Spawn();
                else ply.haftmineprevis = nil; end;

            elseif (IsValid(ply.haftmineprevis)) then
                local res = util.TraceLine{start = ply:GetShootPos(), endpos = ply:GetShootPos() + 115 * ply:GetAimVector(), filter = ply};
                if (tr.Entity:IsVehicle()) then
                    if (ply.haftmineprevis:GetModel() != "models/hafthohlladung/hafthohlladung.mdl") then
                        ply.haftmineprevis:SetModel("models/hafthohlladung/hafthohlladung.mdl");
                    end;
                    ply.haftmineprevis:SetPos(tr.HitPos - tr.HitNormal * ply.haftmineprevis:OBBMins().z);
                    res.HitNormal.z = -res.HitNormal.z;
                    ply.haftmineprevis:SetAngles(res.HitNormal:Angle() - Angle(90, 180, 0));
                    if (tr.HitPos:Distance(ply:GetPos()) >= 200) then ply.haftmineprevis:SetColor(Color(255, 255, 255, 0));
                    elseif (ply.haftmineprevis:GetColor().r == 255) then ply.haftmineprevis:SetColor(Color(0, 255, 0, 150)); end;
                else
                    if (ply.haftmineprevis:GetModel() != "models/hafthohlladung/hafthohlladung.mdl") then
                        ply.haftmineprevis:SetModel("models/hafthohlladung/hafthohlladung.mdl");
                    end;
                    ply.haftmineprevis:SetPos(tr.HitPos - tr.HitNormal * ply.haftmineprevis:OBBMins().z);
                    ply.haftmineprevis:SetAngles(Angle(0, ply:EyeAngles().y-180, 0));
                    if (tr.HitPos:Distance(ply:GetPos()) >= 200) then ply.haftmineprevis:SetColor(Color(255, 255, 255, 0));
                    elseif (ply.haftmineprevis:GetColor().g == 255) then ply.haftmineprevis:SetColor(Color(255, 0, 0, 150)); end;
                end;
            end;
        elseif (ply.haftmineprevis != nil and IsValid(ply.haftmineprevis)) then
            ply.haftmineprevis:Remove();
            ply.haftmineprevis = nil;
        end;
    end);
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

function SWEP:SetNextPrimaryFire(time) self.nextFire = time; end;

function SWEP:PrimaryAttack()
    if (SERVER) then
        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); return end;
        if (!self:CanPrimaryAttack()) then return end;

        local PlayerTrace = self:GetOwner():GetEyeTraceNoCursor().HitPos;

        if (PlayerTrace:Distance(self:GetOwner():GetPos()) <= 200) then
            local res = util.TraceLine{ start = self:GetOwner():GetShootPos(),
                                        endpos = self:GetOwner():GetShootPos() + 115 * self:GetOwner():GetAimVector(),
                                        filter = self:GetOwner()};
            if (IsValid(res.Entity) and res.Entity:IsVehicle()) then
                if (res.Hit) then
                    local mine = ents.Create("haft-mine");
                    mine:SetPos(PlayerTrace);
                    res.HitNormal.z = -res.HitNormal.z;
                    mine:SetAngles(res.HitNormal:Angle() - Angle(90, 180, 0));
                    mine:Spawn();
                    mine:SetCreator(self:GetOwner());
                    local ent_crea = res.Entity:GetCreator();

                    if (!(res.Entity:IsNPC() or res.Entity:IsPlayer()) and res.Entity:GetPhysicsObject():IsValid()) then
                        constraint.Weld(mine, res.Entity, 0, 0, 0, true, false);
                        mine.ent = res.Entity;
                        res.Entity:SetCreator(ent_crea);
                    end;
                end;
            else
                self:GetOwner():PrintMessage(HUD_PRINTCENTER, "Can't find metalic vehicle surface");
                return;
            end;
        end;
        self:TakePrimaryAmmo(1);

        self:SetNextPrimaryFire(CurTime() + 2);

        if (self:Ammo1() <= 0) then self:GetOwner():StripWeapon(self:GetClass()); end;
    end;
end;

function SWEP:SecondaryAttack() return; end;