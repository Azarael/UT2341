/*************************************************************
*
*
*
*************************************************************/

class UT2341SuperShockRifleBeamFire extends ShockBeamFire;

var class<Emitter> BeamImpactEffectClass;

defaultproperties
{
     BeamImpactEffectClass=Class'UT2341Weapons_BETA3.FX_SuperShockRifleImpact'
     BeamEffectClass=Class'UT2341Weapons_BETA3.FX_SuperShockRifleBeamEffect'
     DamageType=Class'UT2341Weapons_BETA3.DamType_SuperShockRifleBeam'
     DamageMin=1000
     DamageMax=1000
     TraceRange=50000.000000
     Momentum=150000.000000
     FireSound=Sound'UT2341Weapons_Sounds.ShockRifle.TazerFire'
     FireRate=0.850000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341SuperShockRifleAmmo'
     AmmoPerFire=0
     FlashEmitterClass=Class'UT2341Weapons_BETA3.FX_SuperShockRifleBeamMuzFlash'
}
