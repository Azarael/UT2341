class UT2341FlakFire extends ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     ProjPerFire=8
     ProjSpawnOffset=(X=15.000000,Y=5.000000,Z=-6.000000)
     FireAnim="FireLoad"
     FireEndAnim=
     FireAnimRate=1.250000
     FireSound=Sound'UT2341Weapons_Sounds.flak.shot1'
     FireForce="FlakCannonFire"
     FireRate=0.785000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341FlakAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341FlakChunk'
     BotRefireRate=0.700000
     FlashEmitterClass=Class'XEffects.FlakMuzFlash1st'
     Spread=2000.000000
     SpreadStyle=SS_Random
}
