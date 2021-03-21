class UT2341FlakAmmoPickup extends UTAmmoPickup;

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

defaultproperties
{
     AmmoAmount=10
     MaxDesireability=0.320000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341FlakAmmo'
     PickupMessage="You picked up 10 Flak Shells."
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     PickupForce="FlakAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTFlakAmmo'
     DrawScale=0.250000
     PrePivot=(Z=40.000000)
     AmbientGlow=48
     CollisionHeight=8.250000
}
