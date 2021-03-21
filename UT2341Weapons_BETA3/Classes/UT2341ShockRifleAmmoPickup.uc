/*************************************************************
*
*
*
*************************************************************/

class UT2341ShockRifleAmmoPickup extends ShockAmmoPickup;

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

defaultproperties
{
     InventoryType=Class'UT2341Weapons_BETA3.UT2341ShockRifleAmmo'
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTASMDCore'
     DrawScale3D=(X=0.400000,Y=0.400000,Z=0.250000)
     PrePivot=(Z=125.000000)
     AmbientGlow=64
}
