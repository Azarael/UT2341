class UT2341BioAmmoPickup extends UTAmmoPickup;

#exec OBJ LOAD FILE=PickupSounds.uax

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

defaultproperties
{
     AmmoAmount=25
     MaxDesireability=0.320000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341BioAmmo'
     PickupMessage="You picked up some Tarydium sludge."
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     PickupForce="FlakAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTBioAmmo'
     DrawScale=0.300000
     PrePivot=(Z=40.000000)
     AmbientGlow=64
     CollisionHeight=8.250000
}
