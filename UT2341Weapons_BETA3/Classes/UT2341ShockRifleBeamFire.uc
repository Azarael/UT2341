/*************************************************************
*
*
*
*************************************************************/

class UT2341ShockRifleBeamFire extends ShockBeamFire;

var class<Emitter> BeamImpactEffectClass;

//var() class<ShockBeamEffect> BeamEffectClass;

//#exec OBJ LOAD FILE=..\Sounds\WeaponSounds.uax

// Leaving this in here because ShockProjFire.ProjSpawnOffset is probably wrong
/*
function DoFireEffect()
{
    local Vector StartTrace,X,Y,Z;
    local Rotator R, Aim;

    Instigator.MakeNoise(1.0);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    if ( PlayerController(Instigator.Controller) != None )
    {
        // for combos
       Weapon.GetViewAxes(X,Y,Z);
        StartTrace = StartTrace + X*class'ShockProjFire'.Default.ProjSpawnOffset.X;
        if ( !Weapon.WeaponCentered() )
            StartTrace = StartTrace + Weapon.Hand * Y*class'ShockProjFire'.Default.ProjSpawnOffset.Y + Z*class'ShockProjFire'.Default.ProjSpawnOffset.Z;
    }

    Aim = AdjustAim(StartTrace, AimError);
    R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
}
*/

/*
function InitEffects()
{
    if ( Level.DetailMode == DM_Low )
        FlashEmitterClass = None;
    Super.InitEffects();
    if ( FlashEmitter != None )
        Weapon.AttachToBone(FlashEmitter, 'tip');
}
*/

/*
function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local xEmitter Beam;

    if (Weapon != None)
    {
        Beam = Weapon.Spawn(BeamEffectClass,,, Start, Dir);
        if (ReflectNum != 0)
        {
            Beam.Instigator = None; // prevents client side repositioning of beam start
        }
        FX_ShockRifleBeamEffect(Beam).AimAt(HitLocation, HitNormal);
    }
}
*/

defaultproperties
{
     BeamImpactEffectClass=Class'UT2341Weapons_BETA3.FX_ShockRifleImpact'
     BeamEffectClass=Class'UT2341Weapons_BETA3.FX_ShockRifleBeamEffect'
     DamageType=Class'UT2341Weapons_BETA3.DamType_ShockRifleBeam'
     DamageMin=60
     DamageMax=60
     FireSound=Sound'UT2341Weapons_Sounds.ShockRifle.TazerFire'
     FireRate=0.850000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341ShockRifleAmmo'
     FlashEmitterClass=Class'UT2341Weapons_BETA3.FX_ShockRifleBeamMuzFlash'
}
