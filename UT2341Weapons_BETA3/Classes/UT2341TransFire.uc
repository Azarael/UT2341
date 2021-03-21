class UT2341TransFire extends TransFire;

var Name RecallAnim;

event ModeDoFire()
{
    if (!AllowFire())
        return;

    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);
		
	// Must play firing before server modifies puck (for anim state) - Azarael

	// client
    if (Instigator.IsLocallyControlled())
    {
        ShakeView();
        PlayFiring();
        FlashMuzzleFlash();
        StartMuzzleSmoke();
    }
    else // server
    {
        ServerPlayFiring();
    }
	
    // server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
        DoFireEffect();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
        if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

        if ( AIController(Instigator.Controller) != None )
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

        Instigator.DeactivateSpawnProtection();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    // set the next firing time. must be careful here so client and server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
            NextFireTime += MaxHoldTime + FireRate;
        else
            NextFireTime = Level.TimeSeconds + FireRate;
    }
    else
    {
        NextFireTime += FireRate;
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }

    Load = AmmoPerFire;
    HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
	
	if (Translauncher(Weapon) != None)
	{
		if (TransLauncher(Weapon).TransBeacon != None)
			UT2341Translocator(Weapon).BeaconOut(true);
	}
}


simulated function PlayFiring()
{
    if (!UT2341Translocator(Weapon).bBeaconOut)
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        ClientPlayForceFeedback( TransFireForce );  // jdf
    }
	else
    {
        Weapon.PlayAnim(RecallAnim, FireAnimRate, TweenTime);
        ClientPlayForceFeedback( RecallFireForce );  // jdf
    }
}

simulated function bool AllowFire()
{
    return Super(ProjectileFire).AllowFire();
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local UT2341TransBeacon TransBeacon;

    if (TransLauncher(Weapon).TransBeacon == None)
    {
		TransBeacon = Weapon.Spawn(class'UT2341TransBeacon',,, Start, Dir);
		TransBeacon.Master = UT2341Translocator(Weapon);
		if ( (Instigator != None) && (Instigator.PlayerReplicationInfo != None) && (Instigator.PlayerReplicationInfo.Team != None) )
			TransBeacon.myTeam = Instigator.PlayerReplicationInfo.Team.TeamIndex;

        TransLauncher(Weapon).TransBeacon = TransBeacon;
        Weapon.PlaySound(TransFireSound,SLOT_Interact,,,,,false);
    }
    else
    {
        TransLauncher(Weapon).ViewPlayer();
        if ( TransLauncher(Weapon).TransBeacon.Disrupted() )
        {
			if( (Instigator != None) && (PlayerController(Instigator.Controller) != None) )
				PlayerController(Instigator.Controller).ClientPlaySound(RecallFireSound);
		}
		else
		{
			TransLauncher(Weapon).TransBeacon.Destroy();
			TransLauncher(Weapon).TransBeacon = None;
			Weapon.PlaySound(RecallFireSound,SLOT_Interact,,,,,false);
		}
    }
    return TransBeacon;
}

defaultproperties
{
     RecallAnim="FireB"
     TransFireSound=Sound'UT2341Weapons_Sounds.XLoc.ThrowTarget'
     RecallFireSound=Sound'UT2341Weapons_Sounds.XLoc.ReturnTarget'
     ProjSpawnOffset=(X=46.000000,Y=-25.000000)
     FireAnim="FireA"
     FireRate=0.500000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341TransAmmo'
     AmmoPerFire=0
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341TransBeacon'
}
