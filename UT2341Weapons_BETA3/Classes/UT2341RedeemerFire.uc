class UT2341RedeemerFire extends ProjectileFire;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = Super.SpawnProjectile(Start,Dir);
    if ( p == None )
        p = Super.SpawnProjectile(Instigator.Location,Dir);
    if ( p == None )
    {
	 	Weapon.Spawn(class'SmallRedeemerExplosion');
		Weapon.HurtRadius(500, 400, class'DamTypeRedeemer', 100000, Instigator.Location);
	}
    return p;
}

function float MaxRange()
{
	return 20000;
}

defaultproperties
{
     ProjSpawnOffset=(X=100.000000,Z=0.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     TransientSoundVolume=1.000000
     FireSound=Sound'UT2341Weapons_Sounds.Redeemer.WarheadShot'
     FireForce="redeemer_shoot"
     FireRate=1.000000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341RedeemerAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341RedeemerProjectile'
     BotRefireRate=0.500000
}
