//=============================================================================
// FlakCannonPickup.
//=============================================================================
class UT2341FlakCannonPickup extends UTWeaponPickup;

#exec OBJ LOAD FILE=WeaponStaticMesh.usx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XEffects.FlakTrailTex');
    if ( L.DetailMode != DM_Low )
		L.AddPrecacheMaterial(Texture'XEffects.fexpt');
    L.AddPrecacheMaterial(Texture'XEffects.ExplosionFlashTex');
    L.AddPrecacheMaterial(Texture'XEffects.GoldGlow');
    L.AddPrecacheMaterial(Texture'WeaponSkins.FlakTex0');
    L.AddPrecacheMaterial(Texture'WeaponSkins.FlakTex1');
    L.AddPrecacheMaterial(Texture'WeaponSkins.FlakChunkTex');
    L.AddPrecacheMaterial(Texture'XWeapons.NewFlakSkin');
    L.AddPrecacheMaterial(Texture'XGameShaders.flak_flash');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakchunk');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakshell');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.FlakCannonPickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'XEffects.FlakTrailTex');
    if ( Level.DetailMode != DM_Low )
		Level.AddPrecacheMaterial(Texture'XEffects.fexpt');
    Level.AddPrecacheMaterial(Texture'XEffects.ExplosionFlashTex');
    Level.AddPrecacheMaterial(Texture'XEffects.GoldGlow');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.FlakTex0');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.FlakTex1');
    Level.AddPrecacheMaterial(Texture'WeaponSkins.FlakChunkTex');
    Level.AddPrecacheMaterial(Texture'XWeapons.NewFlakSkin');
    Level.AddPrecacheMaterial(Texture'XGameShaders.flak_flash');

	super.UpdatePrecacheMaterials();
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakchunk');
	Level.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.flakshell');
	Super.UpdatePrecacheStaticMeshes();
}
	

defaultproperties
{
     MaxDesireability=0.750000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341FlakCannon'
     PickupMessage="You got the Flak Cannon."
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     PickupForce="FlakCannonPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTFlakCannon'
     DrawScale=1.500000
     AmbientGlow=48
     RotationRate=(Yaw=5000)
}
