//=============================================================================
// FlakChunk.
//=============================================================================
class UT2341FlakChunk extends Projectile;

var Emitter Glow;
var byte Bounces;
var float DamageAtten;
var sound ImpactSounds[3];

var ConstantColor myConstantColor;
var Combiner myCombiner;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function Destroyed()
{
    if (Glow!=None)
		Glow.Destroy();
		
	if (Level.NetMode != NM_DedicatedServer)
	{
		myCombiner.Material1 = None;
		myCombiner.Material2 = None;
		myCombiner.Mask = None;
		Level.ObjectPool.FreeObject(myCombiner);
		
		Level.ObjectPool.FreeObject(myConstantColor);
	}
	
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Glow = Spawn(class'FX_FlakChunkGlow',self);
            Glow.SetBase(self);
        }
    }

    if (Role == ROLE_Authority)
    {
        Velocity = Vector(Rotation) * (Speed + (FRand() * 200 - 100));
        if (PhysicsVolume.bWaterVolume)
            Velocity *= 0.65;
    }

    r = FRand();
    if (r > 0.75)
        Bounces = 2;
    else if (r > 0.25)
        Bounces = 1;
    else
        Bounces = 0;

    SetRotation(RotRand());
	
    Super.PostBeginPlay();
}

//===========================================================================
// PostNetBeginPlay
// 
// Apparently, SetOverlayMaterial doesn't work for this class.
// Hence, this irritating and convoluted method!
//===========================================================================
simulated function PostNetBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		myConstantColor = ConstantColor(Level.ObjectPool.AllocateObject(class'ConstantColor'));
		myConstantColor.Color.R = 255;
		myConstantColor.Color.G = 255;
		myConstantColor.Color.B = 255;
		myConstantColor.Color.A = 0;
		myCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
		
		myCombiner.CombineOperation = CO_AlphaBlend_With_Mask;
		myCombiner.AlphaOperation = AO_Use_Mask;
		myCombiner.Material2 = Texture'WeaponSkins.Skins.FlakChunkTex';
		myCombiner.Material1 = Texture'UT2341Weapons_Tex.Flak.FlakChunkHot';
		myCombiner.Mask = myConstantColor;
		
		Skins[0] = myCombiner;
	}
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (FlakChunk(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
    {
        speed = VSize(Velocity);
        if ( speed > 200 )
        {
			if (FRand() > 0.5)
				PlaySound(Sound'UT2341Weapons_Sounds.Flak.ChunkHit');
            if ( Role == ROLE_Authority )
			{
				if ( Instigator == None || Instigator.Controller == None )
					Other.SetDelayedDamageInstigatorController( InstigatorController );

                Other.TakeDamage( Damage, Instigator, HitLocation,
                    (MomentumTransfer * Velocity/speed), MyDamageType );
			}
        }
        Destroy();
    }
}

simulated function Landed( Vector HitNormal )
{
    SetPhysics(PHYS_None);
    LifeSpan = 1.0;
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry 
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        Destroy();
        return;
    }

    SetPhysics(PHYS_Falling);
	if (Bounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(ImpactSounds[Rand(3)]);

        Velocity = 0.65 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
        Bounces = Bounces - 1;
        return;
    }
	bBounce = false;
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
    if (Volume.bWaterVolume)
    {
        if ( Glow != None )
            Glow.Destroy();
        Velocity *= 0.65;
    }
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	
	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (myConstantColor != None)
	{
		if ( (DeltaTime * 255 + myConstantColor.Color.A) > 255)
		{
			MyConstantColor.Color.A = 255;
			Disable('Tick');
		}
		else myConstantColor.Color.A += DeltaTime * 2 * 255;
		
		AmbientGlow = 255 - myConstantColor.Color.A;
	}
}

/*
n.b
flak chunk speed values match ut99 exactly, with no compensatory mechanism, 
because flak was too strong
*/

defaultproperties
{
     Bounces=1
     ImpactSounds(0)=Sound'UT2341Weapons_Sounds.flak.Hit1'
     ImpactSounds(1)=Sound'UT2341Weapons_Sounds.flak.Hit3'
     ImpactSounds(2)=Sound'UT2341Weapons_Sounds.flak.Hit5'
     Speed=2750.000000
     MaxSpeed=2970.000000
     Damage=24.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'UT2341Weapons_BETA3.DamType_Flak'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     CullDistance=3000.000000
     LifeSpan=2.000000
     DrawScale=21.000000
     AmbientGlow=64
     bBounce=True
}
