class UT2341RipperFire extends ProjectileFire;

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
     FireEndAnim=
     FireAnimRate=1.200000
     FireSound=Sound'UT2341Weapons_Sounds.Ripper.StartBlade'
     FireForce="BioRifleFire"
     FireRate=0.385000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341RipperAmmo'
     AmmoPerFire=1
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341RipperProjectile'
     BotRefireRate=0.800000
}
