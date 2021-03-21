//=============================================================================
// Minigun.
//=============================================================================
class UT2341MinigunPickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XEffects.ShellCasingTex');
    L.AddPrecacheMaterial(Texture'AW-2004Explosions.Part_explode2s');
    L.AddPrecacheMaterial(Texture'AW-2004Particles.TracerShot');
	L.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTMinigun');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XEffects.ShellCasingTex');
    Level.AddPrecacheMaterial(Texture'AW-2004Explosions.Part_explode2s');
    Level.AddPrecacheMaterial(Texture'AW-2004Particles.TracerShot');

	super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxDesireability=0.730000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341Minigun'
     PickupMessage="You got the Minigun."
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     PickupForce="MinigunPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTminigun'
     DrawScale=0.150000
     PrePivot=(Z=40.000000)
     AmbientGlow=64
     RotationRate=(Yaw=5000)
}
