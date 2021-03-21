class UT2341TransPickup extends UTWeaponPickup
	notplaceable;

defaultproperties
{
     InventoryType=Class'UT2341Weapons_BETA3.UT2341Translocator'
     PickupMessage="You got the Translocator."
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     PickupForce="SniperRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTTranslocator'
     DrawScale=0.200000
     RotationRate=(Yaw=5000)
}
