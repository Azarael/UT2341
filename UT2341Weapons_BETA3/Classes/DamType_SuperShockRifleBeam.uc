/*************************************************************
*
*
*
*************************************************************/

class DamType_SuperShockRifleBeam extends DamTypeShockBeam;

defaultproperties
{
     WeaponClass=Class'UT2341Weapons_BETA3.UT2341SuperShockRifle'
     DeathString="%k inflicted mortal damage upon %o with the shock rifle."
     bLocationalHit=False
     bAlwaysSevers=True
     DamageOverlayMaterial=Shader'UT2341Weapons_Tex.SuperShock.SuperShockHitShader'
     VehicleDamageScaling=0.050000
     VehicleMomentumScaling=0.050000
}
