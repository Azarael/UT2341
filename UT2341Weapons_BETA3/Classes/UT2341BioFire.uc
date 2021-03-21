class UT2341BioFire extends ProjectileFire;

function DrawMuzzleFlash(Canvas Canvas)
{
    if (FlashEmitter != None)
        FlashEmitter.SetRotation(Weapon.Rotation);
    Super.DrawMuzzleFlash(Canvas);
}

function float MaxRange()
{
	return 1500;
}

defaultproperties
{
     ProjSpawnOffset=(X=20.000000,Y=9.000000,Z=-6.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     FireLoopAnim=
     FireEndAnim=
     FireSound=Sound'UT2341Weapons_Sounds.BioRifle.GelShot'
     FireForce="BioRifleFire"
     FireRate=0.280000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341BioAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=70.000000)
     ShakeRotRate=(X=1000.000000)
     ShakeRotTime=1.800000
     ShakeOffsetMag=(Z=-2.000000)
     ShakeOffsetRate=(Z=1000.000000)
     ShakeOffsetTime=1.800000
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341BioGlob'
     BotRefireRate=0.800000
     FlashEmitterClass=Class'XEffects.BioMuzFlash1st'
}
