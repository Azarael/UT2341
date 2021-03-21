class UT2341PulseAmmoPickup extends UTAmmoPickup;

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( Level.Game.bAllowVehicles )
		MaxDesireability *= 1.9;
}

defaultproperties
{
     AmmoAmount=50
     MaxDesireability=0.240000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341PulseAmmo'
     PickupMessage="You picked up pulse charges."
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     PickupForce="LinkAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTPulseCell'
     DrawScale=0.350000
     PrePivot=(Z=30.000000)
     AmbientGlow=64
     CollisionHeight=10.500000
}
