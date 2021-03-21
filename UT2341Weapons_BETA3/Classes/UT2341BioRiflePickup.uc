class UT2341BioRiflePickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XEffects.xbiosplat2');
    L.AddPrecacheMaterial(Texture'XEffects.xbiosplat');
    L.AddPrecacheMaterial(Texture'XGameShaders.bio_flash');
    L.AddPrecacheMaterial(Texture'WeaponSkins.BioGoo.BRInnerGoo');
    L.AddPrecacheMaterial(Texture'WeaponSkins.BioGoo.BRInnerBubbles');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.BioRiflePickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XEffects.xbiosplat2');
    Level.AddPrecacheMaterial(Texture'XEffects.xbiosplat');
    Level.AddPrecacheMaterial(Texture'XGameShaders.bio_flash');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.BioGoo.BRInnerGoo');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.BioGoo.BRInnerBubbles');

	super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxDesireability=0.750000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341BioRifle'
     PickupMessage="You got the Bio-Rifle."
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     PickupForce="FlakCannonPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTGESBioRifle'
     DrawScale=2.000000
     AmbientGlow=48
     RotationRate=(Yaw=5000)
}
