//=============================================================================
// LinkGunPickup.
//=============================================================================
class UT2341PulseGunPickup extends UTWeaponPickup;

#exec OBJ LOAD FILE=NewWeaponPickups.usx

static function StaticPrecache(LevelInfo L)
{
}

simulated function UpdatePrecacheMaterials()
{
	super.UpdatePrecacheMaterials();
}

simulated function UpdatePrecacheStaticMeshes()
{
	Super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
     MaxDesireability=0.700000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341PulseGun'
     PickupMessage="You got the Pulse Gun."
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     PickupForce="LinkGunPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTPulseGun'
     DrawScale=0.220000
     PrePivot=(Z=47.000000)
     AmbientGlow=64
     RotationRate=(Yaw=5000)
}
