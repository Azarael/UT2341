class UT2341RocketAmmoPickup extends UTAmmoPickup;

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

defaultproperties
{
     AmmoAmount=12
     MaxDesireability=0.300000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341RocketAmmo'
     PickupMessage="You picked up a rocket can."
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     PickupForce="RocketAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTRocketPack'
     DrawScale=0.100000
     PrePivot=(Z=140.000000)
     AmbientGlow=64
     CollisionHeight=13.500000
}
