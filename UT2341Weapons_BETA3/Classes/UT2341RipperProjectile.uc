class UT2341RipperProjectile extends Projectile;

var Emitter Trail;
var bool bCanHitOwner;
var byte Bounces;
var sound WallImpactSound, PlayerImpactSound;

simulated function PostBeginPlay()
{
    Velocity = Vector(Rotation) * (Speed);

    SetRotation(Rotator(Velocity));
	
    Super.PostBeginPlay();
	
	if ( Level.NetMode != NM_DedicatedServer )
    {
		Trail = Spawn(class'FX_RipperProjTrail',self,, Location);
		Trail.SetBase(self);
    }
	
	SetTimer(0.2, false);
	
	LoopAnim('Cutting', 1, 0.1, 0);
}

simulated function Timer()
{
	bCanHitOwner=True;
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if (Other == None || (!bCanHitOwner && (Other == Instigator || Other == Owner)))
		return;
		
	if (xPawn(Other) != None)
		PlaySound(PlayerImpactSound);
	
	if ( Role == ROLE_Authority )
	{
		if ( Instigator == None || Instigator.Controller == None )
			Other.SetDelayedDamageInstigatorController( InstigatorController );

		if (xPawn(Other) != None && CheckHeadshot(xPawn(Other), HitLocation))
			Other.TakeDamage( Damage * 3.5, Instigator, HitLocation, MomentumTransfer * vector(Rotation), class'DamType_RipperBladeHead' );
		else Other.TakeDamage( Damage, Instigator, HitLocation, MomentumTransfer * vector(Rotation), MyDamageType );
	}
    Destroy();
}

function bool CheckHeadshot(xPawn Victim, vector HitLocation)
{
	local String	Bone;
	local float		BoneDist;
    local Vector ClosestLocation, BoneTestLocation, temp;

	//Find a point on the victim's Z axis at the same height as the HitLocation.
	ClosestLocation = Victim.Location;
	ClosestLocation.Z += (HitLocation - Victim.Location).Z;
	
	//Extend the hit along the projectile's Velocity to a point where it is closest to the victim's Z axis.
	temp = Normal(Velocity);
	temp *= VSize(ClosestLocation - HitLocation);
	BoneTestLocation = temp;
	BoneTestLocation *= normal(ClosestLocation - HitLocation) dot normal(temp);
	BoneTestLocation += HitLocation;

	Bone = string(Victim.GetClosestBone(BoneTestLocation, Normal(Velocity), BoneDist, 'head', 10));
	if (InStr(Bone, "head") > -1)
		return true;
	return false;
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

	if (Bounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(WallImpactSound);

        Velocity = 1 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
		SetRotation(Rotator(Velocity));
        Bounces = Bounces - 1;
        return;
    }
	Destroy();
}

simulated function Destroyed()
{
    if (Trail !=None) 
		Trail.Destroy();
	Super.Destroyed();
}

/*
the Ripper primary has been heavily improved due to its weakness in the older game.
speed values from 99 are 1300/1200, here it is 2000/1800
*/

defaultproperties
{
     Bounces=5
     WallImpactSound=Sound'UT2341Weapons_Sounds.Ripper.BladeHit'
     PlayerImpactSound=Sound'UT2341Weapons_Sounds.Ripper.BladeThunk'
     Speed=2000.000000
     MaxSpeed=1800.000000
     Damage=45.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'UT2341Weapons_BETA3.DamType_RipperBlade'
     AmbientSound=Sound'UT2341Weapons_Sounds.Ripper.RazorHum'
     LifeSpan=6.000000
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTRipperDisk'
     DrawScale=5.000000
     AmbientGlow=254
     Style=STY_Alpha
     SoundVolume=255
     SoundPitch=200
     SoundRadius=16.000000
     CollisionRadius=2.000000
     CollisionHeight=1.000000
     bBounce=True
}
