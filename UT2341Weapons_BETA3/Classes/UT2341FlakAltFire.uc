class UT2341FlakAltFire extends ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter == None )
		FlashEmitter = Weapon.GetFireMode(0).FlashEmitter;
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=9.000000,Z=-12.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     FireAnim="FireAltLoad"
     FireEndAnim=
     FireAnimRate=0.900000
     FireSound=Sound'UT2341Weapons_Sounds.flak.Explode1'
     FireForce="FlakCannonAltFire"
     FireRate=1.000000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341FlakAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341FlakShell'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
}
