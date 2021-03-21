//=============================================================================
// ShieldPack
//=============================================================================
class UTBodyArmorPickup extends ShieldPickup;

#exec OBJ LOAD FILE=UT2341Weapons_Sounds.uax
#exec OBJ LOAD FILE=UT2341Weapons_SM.usx

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTBodyArmor');
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
     ShieldAmount=100
     bPredictRespawns=True
     PickupMessage="You got the Body Armor."
     PickupSound=Sound'UT2341Weapons_Sounds.General.ArmorUT'
     PickupForce="ShieldPack"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTBodyArmor'
     DrawScale=0.400000
     PrePivot=(Z=9.000000)
     ScaleGlow=0.600000
     Style=STY_AlphaZ
     CollisionRadius=32.000000
     CollisionHeight=19.000000
     RotationRate=(Yaw=0)
}
