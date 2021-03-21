//=============================================================================
// SuperShieldPack
//=============================================================================
class ShieldBelt extends ShieldPickup placeable;

#exec OBJ LOAD FILE=E_Pickups.usx

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTShieldBelt');
}

static function string GetLocalString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	return Default.PickupMessage;
}

defaultproperties
{
     ShieldAmount=150
     RespawnTime=60.000000
     PickupMessage="You got the Shield Belt."
     PickupSound=Sound'UT2341Weapons_Sounds.General.BeltSnd'
     PickupForce="LargeShieldPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTShieldBelt'
     DrawScale=0.750000
     PrePivot=(Z=26.000000)
     ScaleGlow=0.600000
     Style=STY_AlphaZ
     TransientSoundRadius=450.000000
     CollisionRadius=32.000000
     RotationRate=(Yaw=0)
}
