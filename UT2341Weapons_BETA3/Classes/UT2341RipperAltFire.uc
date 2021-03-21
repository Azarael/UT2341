class UT2341RipperAltFire extends ProjectileFire;

function DrawMuzzleFlash(Canvas Canvas)
{
}

function float MaxRange()
{
	return 5000;
}

defaultproperties
{
     ProjSpawnOffset=(X=20.000000,Y=9.000000,Z=-6.000000)
     FireAnim="FireAlt"
     FireEndAnim=
     FireSound=Sound'UT2341Weapons_Sounds.Ripper.RazorAlt'
     FireForce="BioRifleFire"
     FireRate=0.720000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341RipperAmmo'
     AmmoPerFire=1
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341RipperAltProjectile'
     BotRefireRate=0.830000
}
