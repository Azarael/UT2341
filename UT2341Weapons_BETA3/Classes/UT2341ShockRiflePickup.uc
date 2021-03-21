/*************************************************************
*
*
*
*************************************************************/

class UT2341ShockRiflePickup extends ShockRiflePickup;

static function StaticPrecache(LevelInfo L)
{
    /*
    L.AddPrecacheMaterial(Material'XEffects.ShockHeatDecal');
    L.AddPrecacheMaterial(Material'XEffectMat.shock_flash');
    L.AddPrecacheMaterial(Material'XEffectMat.shock_flare_a');
    L.AddPrecacheMaterial(Material'XEffectMat.shock_core');
    L.AddPrecacheMaterial(Material'XEffectMat.purple_line');
    L.AddPrecacheMaterial(Material'XEffectMat.shock_sparkle');
    L.AddPrecacheMaterial(Material'XEffectMat.shock_core_low');
    L.AddPrecacheMaterial(Material'XEffectMat.shock_Energy_green_faded');
    L.AddPrecacheMaterial(Material'XEffectMat.Shock_Elec_a');
    L.AddPrecacheMaterial(Material'XEffectMat.shock_gradient_b');
    L.AddPrecacheMaterial(Material'XEffectMat.Shock_ring_a');
    L.AddPrecacheMaterial(Material'XEffectMat.ShockComboFlash');
    L.AddPrecacheMaterial(Material'XGameShaders.shock_muzflash_1st');
    L.AddPrecacheMaterial(Material'XGameShaders.WeaponShaders.shock_muzflash_3rd');
    L.AddPrecacheMaterial(Material'XWeapons_rc.ShockBeamTex');
    L.AddPrecacheMaterial(Material'XEffects.SaDScorcht');
    L.AddPrecacheMaterial(Material'DeployableTex.C_T_Electricity_SG');
    L.AddPrecacheMaterial(Material'UT2004Weapons.ShockRipple');
    */
    L.AddPrecacheStaticMesh(StaticMesh'Editor.TexPropSphere');
    L.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTASMD');
}

simulated function UpdatePrecacheMaterials()
{
    /*
    Level.AddPrecacheMaterial(Material'XEffects.ShockHeatDecal');
    Level.AddPrecacheMaterial(Material'XEffectMat.shock_flash');
    Level.AddPrecacheMaterial(Material'XEffectMat.shock_flare_a');
    Level.AddPrecacheMaterial(Material'XEffectMat.shock_core');
    Level.AddPrecacheMaterial(Material'XEffectMat.purple_line');
    Level.AddPrecacheMaterial(Material'XEffectMat.shock_sparkle');
    Level.AddPrecacheMaterial(Material'XEffectMat.shock_core_low');
    Level.AddPrecacheMaterial(Material'XEffectMat.shock_Energy_green_faded');
    Level.AddPrecacheMaterial(Material'XEffectMat.Shock_Elec_a');
    Level.AddPrecacheMaterial(Material'XEffectMat.shock_gradient_b');
    Level.AddPrecacheMaterial(Material'XEffectMat.Shock_ring_a');
    Level.AddPrecacheMaterial(Material'XEffectMat.ShockComboFlash');
    Level.AddPrecacheMaterial(Material'XGameShaders.shock_muzflash_1st');
    Level.AddPrecacheMaterial(Material'XGameShaders.WeaponShaders.shock_muzflash_3rd');
    Level.AddPrecacheMaterial(Material'XWeapons_rc.ShockBeamTex');
    Level.AddPrecacheMaterial(Material'DeployableTex.C_T_Electricity_SG');
    Level.AddPrecacheMaterial(Material'XEffects.SaDScorcht');
    Level.AddPrecacheMaterial(Material'UT2004Weapons.ShockRipple');
    */

    Super(Weapon).UpdatePrecacheMaterials();
}

simulated function UpdatePrecacheStaticMeshes()
{
    //Level.AddPrecacheStaticMesh(StaticMesh'Editor.TexPropSphere');
    Super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
     InventoryType=Class'UT2341Weapons_BETA3.UT2341ShockRifle'
     PickupMessage="You got the ASMD Shock Rifle."
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTASMD'
     DrawScale=0.090000
     PrePivot=(Z=74.000000)
     Skins(0)=Texture'UT2341Weapons_Tex.ASMD-Weapon.ShockRifleTex0'
     AmbientGlow=64
     RotationRate=(Yaw=5000)
}
