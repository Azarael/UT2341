class UT2341RipperAmmoPickup extends UTAmmoPickup;

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

defaultproperties
{
     AmmoAmount=25
     InventoryType=Class'UT2341Weapons_BETA3.UT2341RipperAmmo'
     PickupMessage="You picked up razor blades."
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTRipperAmmo'
     PrePivot=(Z=13.000000)
     AmbientGlow=64
     CollisionHeight=12.750000
}
