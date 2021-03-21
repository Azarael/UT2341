class UT2341SniperAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=10
     InventoryType=Class'UT2341Weapons_BETA3.UT2341SniperAmmo'
     PickupMessage="You picked up a box of sniper rounds."
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmmoSnd'
     PickupForce="SniperAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTSniperAmmo'
     DrawScale=0.200000
     PrePivot=(Z=96.000000)
     AmbientGlow=64
     CollisionHeight=19.000000
}
