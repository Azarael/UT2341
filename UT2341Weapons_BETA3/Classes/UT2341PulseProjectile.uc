//=============================================================================
// LinkProjectile.
//=============================================================================
class UT2341PulseProjectile extends Projectile;

#exec OBJ LOAD FILE=XEffectMat.utx

var Emitter Trail;

simulated function Destroyed()
{
    if (Trail != None)
    {
        Trail.Destroy();
    }
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local Rotator R;

	Super.PostBeginPlay();

	Velocity = Vector(Rotation);
    Velocity *= Speed;

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;

    Acceleration = Normal(Velocity) * 3000.0;

	if (Level.NetMode != NM_DedicatedServer)
	{
		Trail = Spawn(class'FX_PulseProjectileNew',self);
		Trail.SetBase(self);
	}

    if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC == None) || (Instigator == None) || (PC != Instigator.Controller) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( EffectIsRelevant(Location,false) )
	{
           Spawn(class'FX_PulseImpact',,, HitLocation, rotator(HitNormal));
	}
    PlaySound(Sound'UT2341Weapons_Sounds.PulseGun.PulseExp');
	Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if (Other == Instigator) return;
    if (Other == Owner) return;

    if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		}
		Explode(HitLocation, vect(0,0,1));
	}
}

/*
pulse pri has been improved with acceleration which did not exist in UT99
*/

defaultproperties
{
     Speed=1900.000000
     MaxSpeed=2500.000000
     Damage=30.000000
     DamageRadius=0.000000
     MomentumTransfer=13500.000000
     MyDamageType=Class'UT2341Weapons_BETA3.DamType_Pulse'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     ExploWallOut=10.000000
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=83
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_None
     CullDistance=3500.000000
     bDynamicLight=True
     AmbientSound=Sound'UT2341Weapons_Sounds.PulseGun.PulseFly'
     LifeSpan=3.000000
     PrePivot=(X=10.000000)
     Style=STY_Additive
     FluidSurfaceShootStrengthMod=6.000000
     SoundVolume=218
     SoundRadius=10.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=5.000000
     CollisionRadius=2.000000
     CollisionHeight=2.000000
}
