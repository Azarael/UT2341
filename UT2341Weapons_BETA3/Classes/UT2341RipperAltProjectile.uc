class UT2341RipperAltProjectile extends Projectile;

#exec OBJ LOAD File=UT2341Weapons_Sounds.uax

var Emitter Trail;
var bool bCanHitOwner;

simulated function PostBeginPlay()
{
    Velocity = Vector(Rotation) * (Speed);

    SetRotation(Rotator(Velocity));
	
    Super.PostBeginPlay();
	
	if ( Level.NetMode != NM_DedicatedServer )
    {
		Trail = Spawn(class'FX_RipperProjTrail',self,, Location,Rotation);
		Trail.SetBase(self);
    }
	
	SetTimer(0.2, false);
	
	PlayAnim('Explosive', 1, 0, 0);
	FreezeAnimAt(0.0);
}

simulated function Timer()
{
	bCanHitOwner=True;
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if (Other == None || (!bCanHitOwner && (Other == Instigator || Other == Owner)))
		return;
		
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
		Explode(HitLocation, vector(rotation)*-1 );
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(Sound'UT2341Weapons_Sounds.General.Expl03',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'FX_RipperExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
//		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
//			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

simulated function Destroyed()
{
    if (Trail !=None) 
		Trail.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     Speed=1540.000000
     MaxSpeed=1300.000000
     Damage=51.000000
     DamageRadius=210.000000
     MomentumTransfer=87000.000000
     MyDamageType=Class'UT2341Weapons_BETA3.DamType_RipperBlade'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=23
     LightBrightness=255.000000
     LightRadius=3.000000
     bDynamicLight=True
     AmbientSound=Sound'UT2341Weapons_Sounds.Ripper.RazorHum'
     LifeSpan=6.000000
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTRipperDisk'
     DrawScale=5.000000
     AmbientGlow=128
     Style=STY_Alpha
     SoundVolume=255
     SoundPitch=200
     SoundRadius=12.000000
}
