//=============================================================================
// HealthPack
//=============================================================================
class UTHealthPack extends TournamentHealth
	notplaceable;
	
function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

defaultproperties
{
     HealingAmount=30
     PickupSound=Sound'UT2341Weapons_Sounds.General.UTHealth'
     PickupForce="HealthPack"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTMedPack'
     CullDistance=6500.000000
     DrawScale=1.800000
     PrePivot=(Z=10.000000)
     AmbientGlow=16
     ScaleGlow=0.600000
     Style=STY_AlphaZ
     TransientSoundVolume=0.350000
     RotationRate=(Yaw=0)
}
