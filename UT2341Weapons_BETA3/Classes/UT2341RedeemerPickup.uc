class UT2341RedeemerPickup extends UTWeaponPickup;

#exec OBJ LOAD FILE=EpicParticles.utx
#exec OBJ LOAD FILE=2K4HUD.utx

var material PrecacheHUDTextures[4];

function PrebeginPlay()
{
	Super.PreBeginPlay();
	if ( Level.Game.IsA('xMutantGame') )
		Destroy();
}

function SetWeaponStay()
{
	bWeaponStay = false;
}

function float GetRespawnTime()
{
	return ReSpawnTime;
}

static function StaticPrecache(LevelInfo L)
{
	local int i;
	
	for ( i=0; i<4; i++ )
		L.AddPrecacheMaterial(Default.PrecacheHUDTextures[i]);
	L.AddPrecacheMaterial(Material'EpicParticles.Smokepuff2');
	L.AddPrecacheMaterial(Material'EpicParticles.IonBurn');
	L.AddPrecacheMaterial(Material'EpicParticles.IonWave');
	L.AddPrecacheMaterial(Material'EpicParticles.BurnFlare1');
	L.AddPrecacheMaterial(Material'EpicParticles.WhiteStreak01aw');
	L.AddPrecacheMaterial(Material'EpicParticles.Smokepuff');
	L.AddPrecacheMaterial(Material'EpicParticles.SoftFlare');
	L.AddPrecacheMaterial(Material'WeaponSkins.RDMR_Missile');
	L.AddPrecacheMaterial(Material'AW-2004Explosions.Part_explode2');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.RedeemerPickup');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.RedeemerMissile');
}

simulated function UpdatePrecacheMaterials()
{
	local int i;
	
	for ( i=0; i<4; i++ )
		Level.AddPrecacheMaterial(Default.PrecacheHUDTextures[i]);
	Level.AddPrecacheMaterial(Material'EpicParticles.Smokepuff2');
	Level.AddPrecacheMaterial(Material'EpicParticles.IonBurn');
	Level.AddPrecacheMaterial(Material'EpicParticles.IonWave');
	Level.AddPrecacheMaterial(Material'EpicParticles.BurnFlare1');
	Level.AddPrecacheMaterial(Material'EpicParticles.WhiteStreak01aw');
	Level.AddPrecacheMaterial(Material'EpicParticles.Smokepuff');
	Level.AddPrecacheMaterial(Material'EpicParticles.SoftFlare');
	Level.AddPrecacheMaterial(Material'WeaponSkins.RDMR_Missile');
	Level.AddPrecacheMaterial(Material'AW-2004Explosions.Part_explode2');

	super.UpdatePrecacheMaterials();
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTRedeemerMissile');
	Level.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTRedeemer');
	
	Super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
     PrecacheHUDTextures(0)=Texture'2K4Hud.ZoomFX.RedeemerInnerScope'
     PrecacheHUDTextures(1)=Texture'2K4Hud.ZoomFX.RedeemerOuterEdge'
     PrecacheHUDTextures(2)=Texture'2K4Hud.ZoomFX.RedeemerOuterScope'
     PrecacheHUDTextures(3)=Texture'2K4Hud.ZoomFX.RDM_Altitude'
     bWeaponStay=False
     MaxDesireability=1.000000
     InventoryType=Class'UT2341Weapons_BETA3.UT2341Redeemer'
     RespawnTime=120.000000
     PickupMessage="You got the Redeemer."
     PickupSound=Sound'UT2341Weapons_Sounds.General.WeaponPickup'
     PickupForce="FlakCannonPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTRedeemer'
     DrawScale=0.200000
     RotationRate=(Yaw=5000)
}
