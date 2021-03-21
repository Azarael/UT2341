//=============================================================================
// UDamagePack
//=============================================================================
class UTUDamagePack extends TournamentPickUp;

#exec OBJ LOAD FILE=E_Pickups.usx
#exec OBJ LOAD FILE=XGameShaders.utx

function RespawnEffect()
{
	spawn(class'FX_PickupRespawn');
}

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTUDamage');
	L.AddPrecacheMaterial(Material'XGameShaders.PlayerShaders.WeaponUDamageShader');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'XGameShaders.PlayerShaders.WeaponUDamageShader');
	super.UpdatePrecacheMaterials();
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh(StaticMesh'UT2341Weapons_SM.UTUDamage');
	Super.UpdatePrecacheStaticMeshes();
}

auto state Pickup
{
	function Touch( actor Other )
	{
        local Pawn P;

		if ( ValidTouch(Other) )
		{
            P = Pawn(Other);
            P.EnableUDamage(30);
			AnnouncePickup(P);
            SetRespawn();
		}
	}
}

defaultproperties
{
     MaxDesireability=2.000000
     bPredictRespawns=True
     RespawnTime=90.000000
     PickupMessage="DOUBLE DAMAGE!"
     PickupSound=Sound'UT2341Weapons_Sounds.General.AmpPickup'
     PickupForce="UDamagePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTUDamage'
     Physics=PHYS_Rotating
     DrawScale=1.500000
     AmbientGlow=16
     ScaleGlow=0.600000
     Style=STY_AlphaZ
     TransientSoundRadius=600.000000
     CollisionRadius=32.000000
     CollisionHeight=32.000000
     Mass=10.000000
}
