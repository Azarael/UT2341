/*************************************************************
*
*
*
*************************************************************/

class UT2341SniperRiflePickup extends ClassicSniperRiflePickup;

//===========================================================================
// Because it's slot 0, game will try to delay the spawning of this pickup.
// We reject this.
//===========================================================================
State Sleeping
{
	ignores Touch;

	function bool ReadyToPickup(float MaxWait)
	{
		return ( bPredictRespawns && (LatentFloat < MaxWait) );
	}

	function StartSleeping() {}

	function BeginState()
	{
		local int i;

		NetUpdateTime = Level.TimeSeconds - 1;
		bHidden = true;
		for ( i=0; i<4; i++ )
			TeamOwner[i] = None;
	}

	function EndState()
	{
		NetUpdateTime = Level.TimeSeconds - 1;
		bHidden = false;
	}

DelayedSpawn:
	Goto('Respawn');
Begin:
	Sleep( GetReSpawnTime() - RespawnEffectTime );
Respawn:
	RespawnEffect();
	Sleep(RespawnEffectTime);
    if (PickUpBase != None)
		PickUpBase.TurnOn();
    GotoState('Pickup');
}

defaultproperties
{
     InventoryType=Class'UT2341Weapons_BETA3.UT2341SniperRifle'
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTSniper'
     DrawScale=0.070000
     PrePivot=(Z=175.000000)
     AmbientGlow=64
     RotationRate=(Yaw=5000)
}
