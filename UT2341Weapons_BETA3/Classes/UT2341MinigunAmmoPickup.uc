class UT2341MinigunAmmoPickup extends UTAmmoPickup;

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

defaultproperties
{
     AmmoAmount=50
     InventoryType=Class'UT2341Weapons_BETA3.UT2341MinigunAmmo'
     PickupMessage="You picked up 50 bullets."
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTminigunammo'
     DrawScale=0.300000
     PrePivot=(Z=44.000000)
     AmbientGlow=64
     CollisionHeight=12.750000
}
